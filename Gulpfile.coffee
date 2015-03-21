gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
prefix = require 'gulp-autoprefixer'
minifyCSS = require 'gulp-minify-css'
urlAdjuster = require 'gulp-css-url-adjuster'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
gzip = require 'gulp-gzip'
coffelint = require 'gulp-coffeelint'
nodemon = require 'gulp-nodemon'
browserSync = require 'browser-sync'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
runSequence = require 'run-sequence'
del = require 'del'
shell = require 'gulp-shell'
nodeInspector = require 'gulp-node-inspector'
path = require 'path'
config = require './config/config'

root = path.resolve(__dirname)
bower = "#{root}/bower_components"

paths = {
  src:
    app:
      coffee: [
        "#{root}/app/**/*.coffee"
        "#{root}/config/**/*.coffee"
        "#{root}/app.coffee"
      ]
      jade: "#{root}/app/views/**/*.jade"
    assets:
      coffee: "#{root}/assets/scripts/**/*.coffee"
      less: "#{root}/assets/styles/**/*.less"
      css: [
        "#{bower}/select2/select2.css"
        "#{bower}/select2/select2-bootstrap.css"
      ]
      js: [
        "#{bower}/jquery/dist/jquery.min.js"
        "#{bower}/bootstrap/js/alert.js"
        "#{bower}/bootstrap/js/collapse.js"
        "#{bower}/bootstrap/js/transition.js"
        "#{bower}/select2/select2.min.js"
      ]
      img: [
        "#{bower}/select2/select2.png"
        "#{bower}/select2/select2x2.png"
        "#{bower}/select2/select2-spinner.gif"
      ]
  dest:
    app: "#{root}/build"
    assets: "#{root}/build/public"
    css: "#{root}/build/public/css"
    js: "#{root}/build/public/js"
    img: "#{root}/build/public/img"
}

gulp.task 'app:coffee', ->
  gulp.src(paths.src.app.coffee, base: root)
  .pipe(sourcemaps.init(sourceRoot: '.'))
  .pipe(coffee(bare: true).on('error', gutil.log))
  .pipe(sourcemaps.write('.'))
  .pipe(gulp.dest(paths.dest.app))

gulp.task 'app:jade',
  shell.task "mkdir -p #{root}/build/app;
   ln --symbolic #{root}/app/views #{root}/build/app/views"

gulp.task 'assets:coffee', ->
  gulp.src(paths.src.assets.coffee, base: root)
  .pipe(coffee().on('error', gutil.log))
  .pipe(uglify())
  .pipe(concat('default.js'))
  .pipe(gulp.dest(paths.dest.js))
  .pipe(gzip())
  .pipe(gulp.dest(paths.dest.js))

gulp.task 'assets:js', ->
  gulp.src(paths.src.assets.js)
  .pipe(uglify())
  .pipe(concat('lib.js'))
  .pipe(gulp.dest(paths.dest.js))
  .pipe(gzip())
  .pipe(gulp.dest(paths.dest.js))

gulp.task 'assets:img', ->
  gulp.src(paths.src.assets.img)
  .pipe(gulp.dest(paths.dest.img))
  .pipe(gzip())
  .pipe(gulp.dest(paths.dest.img))

gulp.task 'assets:less', ->
  gulp.src(paths.src.assets.less)
  .pipe(less(paths: bower)).on('error', gutil.log)
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(gulp.dest(paths.dest.css))
  .pipe(gzip())
  .pipe(gulp.dest(paths.dest.css))

gulp.task 'assets:css', ->
  gulp.src(paths.src.assets.css)
  .pipe(urlAdjuster(prepend: '/img/'))
  .pipe(prefix())
  .pipe(minifyCSS())
  .pipe(concat('lib.css'))
  .pipe(gulp.dest(paths.dest.css))
  .pipe(gzip())
  .pipe(gulp.dest(paths.dest.css))

gulp.task 'app:lint', ->
  gulp.src(paths.src.app.coffee)
  .pipe(coffelint())
  .pipe(coffelint.reporter())

gulp.task 'assets:lint', ->
  gulp.src(paths.src.assets.coffee)
  .pipe(coffelint())
  .pipe(coffelint.reporter())

gulp.task 'browser-sync', ->
  setTimeout ->
    browserSync
      proxy: 'http://localhost:3000'
      files: ["#{paths.dest.assets}/**/*.*"]
      browser: 'google-chrome'
      port: 7000
      notify: false
  , 1000

gulp.task 'browser-sync-reload', ->
  browserSync.reload()

gulp.task 'nodemon', ->
  nodemon
    verbose: true
    cwd: paths.dest.app
    script: "#{paths.dest.app}/app.js"
    nodeArgs: ['--debug']
    ignore: [paths.dest.assets]
    ext: 'js jade'
  .on 'restart', ['browser-sync-reload']

gulp.task 'debugger', ->
  gulp.src([])
  .pipe(nodeInspector())

gulp.task 'seed', shell.task 'node_modules/.bin/coffee ./config/seed.coffee'

gulp.task 'watch', ->
  watch paths.src.app.coffee, ->
    runSequence ['app:lint', 'app:coffee'],
      'browser-sync-reload'

  watch paths.src.app.jade, ->
    runSequence 'browser-sync-reload'

  watch paths.src.assets.coffee, ->
    runSequence ['assets:lint', 'assets:coffee']

  watch paths.src.assets.less, ->
    runSequence 'assets:less'

gulp.task 'clean', (cb) ->
  del(paths.dest.app, cb)

buildTasks = ['assets:less', 'assets:coffee', 'assets:css', 'assets:js',
              'assets:img',
              'app:coffee', 'app:jade']

gulp.task 'build', ->
  runSequence 'clean',
    buildTasks

gulp.task 'default', ->
  runSequence 'clean',
    buildTasks,
    ['debugger', 'nodemon', 'browser-sync', 'watch']
