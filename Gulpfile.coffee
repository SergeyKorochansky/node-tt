gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
less = require 'gulp-less'
prefix = require 'gulp-autoprefixer'
minifyCSS = require 'gulp-minify-css'
coffelint = require 'gulp-coffeelint'
nodemon = require 'gulp-nodemon'
gutil = require 'gulp-util'
del = require 'del'

paths = {
  styles: ['app/assets/styles/**/*.less']
  coffee: ['app/**/*.coffee', 'Gulpfile.coffee']
}

gulp.task 'style', ->
  gulp.src(paths.styles)
  .pipe(sourcemaps.init())
  .pipe(less()).on('error', gutil.log)
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

gulp.task 'watch', ->
  gulp.watch(paths.styles, ['style'])
  gulp.watch(paths.coffee, ['lint'])

gulp.task 'clean', ->
  del('public')

gulp.task 'build', ['clean', 'style']

gulp.task 'default', ['build', 'lint', 'server', 'watch']