async = require 'async'
nodemailer = require 'nodemailer'
crypto = require 'crypto'
config = require '../../config/config'

module.exports =
  showEmailForm: (req, res) ->
    res.render 'forgot/show'

  sendMail: (app) ->
    (req, res, next) ->
      req.assert('email', 'Please enter a valid email address.').isEmail()

      errors = req.validationErrors()

      if errors
        req.flash 'errors', errors
        return res.redirect '/forgot'

      async.waterfall [
        (done) ->
          crypto.randomBytes 20, (err, buf) ->
            token = buf.toString('hex')
            done err, token

        (token, done) ->
          app.models.user.findOne
            email: req.body.email.toLowerCase()
          .exec (err, user) ->
            if !user
              req.flash 'error', 'No account with that email address exists.'
              return req.redirect '/forgot'
            if !user.resetPasswordExpires || user.resetPasswordExpires > Date.now()
              user.resetPasswordToken = token
              user.resetPasswordExpires = (new Date((Date.now() + 60 * 60 * 1000))).toISOString()
            else
              req.flash 'error', 'Your reset token is not expired. Try again later'
              return res.redirect '/forgot'
            user.save (err) ->
              done err, token, user

        (token, user, done) ->
          smtpTransport = nodemailer.createTransport
            service: 'MailGun'
            auth:
              user: config.mailgun.user
              pass: config.mailgun.password
          mailOptions =
            to: user.email
            from: 'passwordreset@node-tt.herokuapp.com'
            subject: 'Node.js Password Reset'
            text: 'You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\n' +
              'Please click on the following link, or paste this into your browser to complete the process:\n\n' +
              'http://' + req.headers.host + '/reset/' + token + '\n\n' +
              'If you did not request this, please ignore this email and your password will remain unchanged.\n'
          smtpTransport.sendMail mailOptions, (err) ->
            req.flash 'info', 'An e-mail has been sent to ' + user.email + ' with further instructions.'
            done err
      ], (err) ->
        if err
          return next err
        res.redirect '/forgot'

  showNewPasswordForm: (app) ->
    (req, res) ->
      app.models.user.findOne
        resetPasswordToken: req.params.token
        resetPasswordExpires:
          '>': new Date
      .exec (err, user) ->
        if !user
          req.flash 'error', 'Password reset token is invalid or has expired'
          return res.redirect '/forgot'
        res.render 'forgot/reset'

  saveNewPassword: (app) ->
    (req, res, next) ->
      req.assert('password', '6 to 100 characters required').len(6, 100)

      errors = req.validationErrors()
      if errors
        req.flash 'errors', errors
        return res.redirect 'back'
      async.waterfall [
        (done) ->
          app.models.user.findOne
            resetPasswordToken: req.params.token
            resetPasswordExpires:
              '>': new Date
          .exec (err, user) ->
            if !user
              req.flash 'error', 'Password reset token is invalid or has expired'
              return res.redirect 'back'
            user.password = req.body.password
            user.resetPasswordToken = undefined
            user.resetPasswordExpires = undefined
            user.save (err) ->
              if err
                return next(err)
              req.logIn user, (err) ->
                done err, user

        (user, done) ->
          smtpTransport = nodemailer.createTransport
            service: 'MailGun'
            auth:
              user: config.mailgun.user
              pass: config.mailgun.password
          mailOptions =
            to: user.email
            from: 'node-tt@herokuapp.com'
            subject: 'Your password has been changed'
            text: 'Hello,\n\n' +
              'This is a confirmation that the password for your account ' + user.email + ' has just been changed.\n'
          smtpTransport.sendMail mailOptions, (err) ->
            req.flash 'success', 'Success! Your password has been changed.'
            done err
      ], (err) ->
        if err
          return next err
        res.redirect '/'
