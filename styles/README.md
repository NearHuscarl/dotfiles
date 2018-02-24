## Dependencies:

```bash
$ npm install gulp-cli -g
$ cd ~/styles/
$ npm install # install dependencies list in package.json
```

## Generate css files from scss files

```bash
$ cd ~/styles/
$ gulp
```
Gulp will auto rebuild when save new change in $EDITOR.  At the first time it
will include all the files due to `gulp-cached` plugin litmitation. After that,
it will only rebuild new change from current file and its dependent files

## Using tampermonkey to init those custom css files into the browser:
Tampermonkey is an extension for chromium-based browser (chrome, vivaldi, opera)

**Note**: On firefox, there is a similar extension called greesemonkey which should
have similar functionality

```
Tampermonkey icon > Create a new script...
```

This is a sample snippet to make custom css work on reddit.com

```javascript
// ==UserScript==
// @name        Custom Css Reddit
// @namespace   style-loader
// @version     1
// @resource    FILE_CSS file:///home/near/styles/dist/reddit/style.min.css
// @author      Near Huscarl
// @include     https://www.reddit.com/*
// @grant       GM_getResourceText
// @grant       GM_addStyle
// @run-at      document-start
// ==/UserScript==

let cssText = GM_getResourceText ('FILE_CSS');
GM_addStyle (cssText);
```

Here is another one for github page
```javascript
// ==UserScript==
// @name        Custom Css Github
// @namespace   style-loader
// @version     1
// @resource    FILE_CSS file:///home/near/styles/dist/github/style.min.css
// @author      Near Huscarl
// @include     /^https://(gist\.|)github.com/*/
// @grant       GM_getResourceText
// @grant       GM_addStyle
// @run-at      document-start
// ==/UserScript==

let cssText = GM_getResourceText ('FILE_CSS');
GM_addStyle (cssText);
```

**Note:** To apply local css file with tampermonkey. Go to extension setting
and check `Allow access to file URLs`

## Backup scripts
```
Tampermonkey icon > Options > Utilities
```

## Preferences
https://docs.npmjs.com/misc/config
