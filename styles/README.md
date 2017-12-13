How to generate css files from scss files
```bash
$ cd ~/styles/
$ gulp
```
Gulp will auto rebuild when save new change in $EDITOR.
At the first time it will include all the files
due to gulp-cached plugin litmitation. After that, it
will only rebuild new change from current file and its
dependent files
