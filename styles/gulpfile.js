const gulp         = require('gulp');
const sass         = require('gulp-sass');
const uglifyCss    = require('gulp-clean-css');
const rename       = require('gulp-rename');
const newer        = require('gulp-newer');
const gulpsync     = require('gulp-sync')(gulp);
const cached       = require('gulp-cached');
const filter       = require('gulp-filter');
const debug        = require('gulp-debug');
const findSassMain = require('gulp-sass-inheritance');

let path = {
   src: "src/**/*.scss",
   srcEntry: "src/**/main.scss",
   build: "dist/**/style.css",
   dest: "dist/"
}


gulp.task('compileCss', function(){
   return gulp.src(path.src)
      // only pass files that change in cache
      .pipe(cached('css'))
      // include file that depend on the files that have changed (main files)
      .pipe(findSassMain({dir: 'src/'}))
      // now remove the imported file, only keep main file for compiling
      .pipe(filter(path.srcEntry))

      // rename file on destination, must put after filter or filter dont know what files to remove
      .pipe(rename(function(path) {
         path.basename = "style";
         path.extname = ".css";
      }))
      .pipe(debug({title: 'compile after filter'}))
      .pipe(sass().on('error', sass.logError))

      .pipe(gulp.dest(path.dest));
});

gulp.task('uglifyCss', function(){
   return gulp.src(path.build)
      // change the name first before piping to changed plugin so plugin get the
      // src filename with the new name same as dest name
      .pipe(rename(function(path) {
         path.basename = "style";
         path.extname = ".min.css";
      }))
      // .pipe(newer(path.dest))
      .pipe(cached('mincss'))
      .pipe(uglifyCss())

      .pipe(gulp.dest(path.dest));
});

// https://stackoverflow.com/questions/9781218/how-to-change-node-jss-console-font-color
let color = {
   red: '\x1b[31m',
   green: '\x1b[32m',
   yellow: '\x1b[33m',
   cyan: '\x1b[36m',
   reset: '\x1b[0m'
}
let cwd = process.cwd();

function formatEventType(eventType)
{
   if (eventType == 'changed') {
      return 'MODIFIED';
   }
   else if (eventType == 'added') {
      return ' ADDED  ';
   }
   else if (eventType == 'deleted') {
      return 'DELETED ';
   }
}

function getColorCode(eventType)
{
   if (eventType == 'changed') {
      return '%s' + color.yellow + '%s' + color.reset + '%s' + color.cyan + '%s' + color.reset;
   }
   else if (eventType == 'added') {
      return '%s' + color.green + '%s' + color.reset + '%s' + color.cyan + '%s' + color.reset;
   }
   else if (eventType == 'deleted') {
      return '%s' + color.red + '%s' + color.reset + '%s' + color.cyan + '%s' + color.reset;
   }
}

gulp.task('watch', function() {
   gulp.watch(path.src, gulpsync.sync(['compileCss', 'uglifyCss']))
      .on('change', function(event) {
         let fileName = event.path.split('/').pop();
         let replaceRegex = new RegExp('(' + cwd + '|' + fileName +  ')', 'g');
         let fileParent = event.path.replace(replaceRegex, '');
         let eventType = formatEventType(event.type);
         let colorCode = getColorCode(event.type);

         console.log(colorCode, '[', eventType , '] ' + fileParent, fileName);
      });
});

gulp.task('default', ['watch']);
