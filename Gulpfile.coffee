gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
prefix = require 'gulp-autoprefixer'
minifyCSS = require 'gulp-minify-css'
urlAdjuster = require 'gulp-css-url-adjuster'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
coffelint = require 'gulp-coffeelint'
nodemon = require 'gulp-nodemon'
browserSync = require 'browser-sync'
gutil = require 'gulp-util'
del = require 'del'
shell = require 'gulp-shell'
nodeInspector = require 'gulp-node-inspector'

paths = {
  bower: ['bower_components']
  src:
    app:
      coffee: [
        'app/**/*.coffee'
        'config/**/*.coffee'
        'app.coffee'
      ]
      jade: 'app/views/**/*.jade'
    assets:
      coffee: 'app/assets/scripts/**/*.coffee'
      less: 'app/assets/styles/**/*.less'
      css: [
        'bower_components/select2/select2.css'
        'bower_components/select2/select2-bootstrap.css'
      ]
      js: [
        'bower_components/jquery/dist/jquery.min.js'
        'bower_components/bootstrap/js/alert.js'
        'bower_components/bootstrap/js/collapse.js'
        'bower_components/bootstrap/js/transition.js'
        'bower_components/select2/select2.min.js'
      ]
      img: [
        'bower_components/select2/select2.png'
        'bower_components/select2/select2x2.png'
        'bower_components/select2/select2-spinner.gif'
      ]
  dest:
    app: 'build/'
    css: 'build/public/css'
    js: 'build/public/js'
    img: 'build/public/img'
}

gulp.task 'app-coffee', ['clean', 'app-lint'], (cb) ->
  gulp.src(paths.src.app.coffee, base: '.')
  .pipe(sourcemaps.init(sourceRoot: '../'))
  .pipe(coffee(bare: true).on('error', gutil.log))
  .pipe(sourcemaps.write('./'))
  .pipe(gulp.dest(paths.dest.app))
  cb()

gulp.task 'templates', ['clean'], ->
  gulp.src(paths.src.app.jade, base: '.')
  .pipe(gulp.dest(paths.dest.app))

gulp.task 'assets-coffee', ['clean', 'assets-lint'], ->
  gulp.src(paths.src.assets.coffee)
  .pipe(coffee().on('error', gutil.log))
  .pipe(uglify())
  .pipe(concat('default.js'))
  .pipe(gulp.dest(paths.dest.js))

gulp.task 'js', ['clean'], ->
  gulp.src(paths.src.assets.js)
  .pipe(uglify())
  .pipe(concat('lib.js'))
  .pipe(gulp.dest(paths.dest.js))

gulp.task 'img', ['clean'], ->
  gulp.src(paths.src.assets.img)
  .pipe(gulp.dest(paths.dest.img))

gulp.task 'less', ['clean'], ->
  gulp.src(paths.src.assets.less)
  .pipe(sourcemaps.init())
  .pipe(less(paths: paths.bower)).on('error', gutil.log)
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(sourcemaps.write())
  .pipe(gulp.dest(paths.dest.css))

gulp.task 'css', ['clean'], ->
  gulp.src(paths.src.assets.css)
  .pipe(urlAdjuster(prepend: '/img/'))
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(concat('lib.css'))
  .pipe(gulp.dest(paths.dest.css))

gulp.task 'app-lint', ->
  gulp.src(paths.src.app.coffee)
  .pipe(coffelint())
  .pipe(coffelint.reporter())

gulp.task 'assets-lint', ->
  gulp.src(paths.src.assets.coffee)
  .pipe(coffelint())
  .pipe(coffelint.reporter())

gulp.task 'browser-sync', ['server'], ->
  browserSync
    proxy: 'http://localhost:3000'
    files: ['public/**/*.*']
    browser: 'google-chrome'
    port: 7000

gulp.task 'server', ['app-coffee', 'templates'], (cb) ->
  called = false
  nodemon [
    '--debug'
    'build/app.js'
    '--watch build/'
    '--ignore build/public/'
    '--ignore app/'
    '--ignore config/'
    '--ignore .idea/'
    '--ignore .git/'
    '--ignore node_modules/'
    '--ignore bower_components/'
    '--ext js,jade'
  ].join ' '
  .on 'start', ->
    setTimeout ->
      unless called
        called = true
        cb()
    , 3000

  .on 'restart', ->
    setTimeout ->
      browserSync.reload()
    , 1500

gulp.task 'debugger', ->
  nodeInspector()

gulp.task 'seed', shell.task 'node_modules/.bin/coffee ./config/seed.coffee'

gulp.task 'watch', ->
  gulp.watch(paths.src.app.coffee, ['app-coffee'])
  gulp.watch(paths.src.app.jade, ['templates'])
  gulp.watch(paths.src.assets.coffee, ['assets-coffee'])
  gulp.watch(paths.src.assets.less, ['less'])

gulp.task 'clean', (cb) ->
  del('build', cb)

commonTasks = ['css', 'js', 'less', 'img', 'assets-coffee']

gulp.task 'build', commonTasks.concat ['app-coffee', 'templates']

gulp.task 'default', commonTasks.concat ['browser-sync', 'watch', 'debugger']