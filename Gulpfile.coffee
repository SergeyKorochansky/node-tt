gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
less = require 'gulp-less'
prefix = require 'gulp-autoprefixer'
minifyCSS = require 'gulp-minify-css'
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
    less: ['app/assets/styles/**/*.less']
    coffee: ['app/**/*.coffee', 'Gulpfile.coffee']
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
  dest:
    css: 'public/css'
    js: 'public/js'
}

gulp.task 'js', ->
  gulp.src(paths.src.js)
  .pipe(uglify())
  .pipe(concat('default.js'))
  .pipe(gulp.dest(paths.dest.js))

gulp.task 'less', ->
  gulp.src(paths.src.less)
  .pipe(sourcemaps.init())
  .pipe(less(paths: paths.bower)).on('error', gutil.log)
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(sourcemaps.write())
  .pipe(gulp.dest(paths.dest.css))

gulp.task 'css', ->
  gulp.src(paths.src.css)
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(concat('lib.css'))
  .pipe(gulp.dest(paths.dest.css))

gulp.task 'lint', ->
  gulp.src(paths.src.coffee)
  .pipe(coffelint())
  .pipe(coffelint.reporter())

gulp.task 'browser-sync', ['server'], ->
  browserSync
    proxy: 'http://localhost:3000'
    files: ['public/**/*.*']
    browser: 'google-chrome'
    port: 7000

gulp.task 'server', (cb) ->
  called = false
  nodemon [
    '--debug'
    '--verbose'
    'app.coffee'
    '--watch app/'
    '--watch config/'
    '--watch app.coffee'
    '--ext coffee,jade'
    '--ignore public/'
    '--ignore .idea/'
    '--ignore *___jb*'
  ].join ' '
  .on 'start',  ->
    unless called
      called = true
      cb()
  .on 'restart', ->
    setTimeout ->
      browserSync.reload()
    , 1500

gulp.task 'debugger', ->
  gulp.src([])
  .pipe(nodeInspector())

gulp.task 'seed', shell.task 'node_modules/.bin/coffee ./config/seed.coffee'

gulp.task 'watch', ->
  gulp.watch(paths.src.less, ['less'])
  gulp.watch(paths.src.coffee, ['lint'])

gulp.task 'clean', ->
  del('public')

gulp.task 'build', ['clean', 'less', 'css', 'js']

gulp.task 'default', ['build', 'lint', 'debugger', 'browser-sync', 'watch']