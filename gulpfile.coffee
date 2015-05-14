gulp        = require 'gulp'
del         = require 'del'
runSequence = require 'run-sequence'
coffee      = require 'gulp-coffee'
packager    = require 'gulp-atom-shell'
sketch      = require 'gulp-sketch'
iconutil    = require 'gulp-iconutil'
gif         = require 'gulp-if'
shell       = require 'gulp-shell'

$ =
  coffee:   ['./src/**/*.coffee']
  iconapp:  ['./src/app.sketch']
  icontray: ['./src/tray.sketch']
  meta:     ['./src/package.json']
  package:  ['./dist/**']
  dist:     './dist/'

#gulp.task 'default', (cb) -> runSequence 'clean', 'prebuild', 'package', cb
#gulp.task 'prebuild', (cb) -> runSequence ['icon-app', 'icon-tray', 'coffee', 'meta'], 'npm', cb
gulp.task 'default', (cb) -> runSequence 'prebuild', 'package', cb
gulp.task 'prebuild', (cb) -> runSequence ['coffee', 'meta'], 'npm', cb

gulp.task 'clean', (cb) -> del $.dist, -> cb()

gulp.task 'coffee', ->
  gulp.src $.coffee
  .pipe coffee()
  .pipe gulp.dest $.dist

gulp.task 'meta', ->
  gulp.src $.meta
  .pipe gulp.dest $.dist

gulp.task 'npm', shell.task 'npm install', cwd: 'dist', quiet: true

gulp.task 'package', ->
  gulp.src $.package
  .pipe packager
    version: '0.22.1'
    platform: 'darwin'
    darwinIcon: 'dist/app.icns'
  .pipe packager.zfsdest 'app.zip'

#
# Generating icons (you need to have sketchtool)
#
gulp.task 'icon-tray', ->
  gulp.src $.icontray
  .pipe sketch
    export: 'artboards'
    scales: '1.0,2.0'
    formats: 'png'
  .pipe gulp.dest $.dist

gulp.task 'icon-app', ->
  gulp.src $.iconapp
  .pipe sketch
    export: 'artboards'
    scales: '1.0'
    formats: 'png'
  .pipe iconutil 'app.icns'
  .pipe gulp.dest $.dist
