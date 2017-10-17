let fs = require('fs'),
   path = require('path'),
   homeDir = process.env.HOME,
   cwd = process.cwd(),
   name = cwd.split('/').slice(-1).pop();

// name property in package.json only accept lowercase chars and dash
function transformName(name)
{
   return name.toLowerCase().replace(/[^a-z ]/g, '').replace(/\s+/g, '-');
}

function getGlobalGitConfig() {
   let configPath = [ path.join(homeDir,  '.gitconfig'), path.join(homeDir, '.config/git/config') ];

   for (let i = 0; i < configPath.length; i++) {
      if (fs.existsSync(configPath[i])) {
         let config = fs.readFileSync(configPath[i], 'utf-8'),
            name = config.match(/\[user\][^[]+name\s+=\s+([^\n]+)\n/)[1],
            email = config.match(/\[user\][^[]+email\s+=\s+([^\n]+)\n/)[1];

         return {name: name, email: email};
      }
   }
   console.log('There is no global git config in $HOME');
}

let git = getGlobalGitConfig();
let name = transformName(name);

const packageConfig = {
   name: name,
   description: '',
   version: '1.0.0',
   author: `${git.name} <${git.email}>`,
   license: "BSD-3-Clause"
};

module.exports = packageConfig;
