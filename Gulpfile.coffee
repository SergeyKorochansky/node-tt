gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
less = require 'gulp-less'
prefix = require 'gulp-autoprefixer'
minifyCSS = require 'gulp-minify-css'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
coffelint = require 'gulp-coffeelint'
nodemon = require 'gulp-nodemon'
gutil = require 'gulp-util'
del = require 'del'
shell = require 'gulp-shell'

paths = {
  styles: ['app/assets/styles/**/*.less']
  coffee: ['app/**/*.coffee', 'Gulpfile.coffee']
  bower:  ['bower_components']
  scripts:[
    'bower_components/jquery/dist/jquery.min.js'
    'bower_components/bootstrap/js/collapse.js'
    'bower_components/bootstrap/js/transition.js'
  ]
}

gulp.task 'js', ->
  gulp.src(paths.scripts)
  .pipe(uglify())
  .pipe(concat('default.js'))
  .pipe(gulp.dest('public/js'))

gulp.task 'style', ->
  gulp.src(paths.styles)
  .pipe(sourcemaps.init())
  .pipe(less(paths: paths.bower)).on('error', gutil.log)
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('public/css'))

gulp.task 'lint', ->
  gulp.src(paths.coffee)
  .pipe(coffelint())
  .pipe(coffelint.reporter())

gulp.task 'server', ->
  nodemon(script: 'app.coffee')

gulp.task 'seed', shell.task 'node_modules/.bin/coffee ./config/seed.coffee'

gulp.task 'watch', ->
  gulp.watch(paths.styles, ['style'])
  gulp.watch(paths.coffee, ['lint'])

gulp.task 'clean', ->
  del('public')

gulp.task 'build', ['clean', 'style', 'js']

gulp.task 'default', ['build', 'lint', 'server', 'watch']