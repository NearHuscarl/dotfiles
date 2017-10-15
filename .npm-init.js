let fs = require('fs'),
   path = require('path'),
   homeDir = process.env.HOME,
   cwd = process.cwd(),
   name = cwd.split('/').slice(-1).pop();

function getGlobalGitConfig() {
   let configPath = [ path.join(homeDir,  '.gitconfig'), path.join(homeDir, '.config/git/config') ];

   for (let i = 0; i < configPath.length; i++) {
      if (fs.existsSync(configPath[i])) {
         let config = fs.readFileSync(configPath[i], 'utf-8'),
            name = config.match(/name = .+?\n/)[0].replace(/(name = |\n)/g, ''),
            email = config.match(/email = .+?\n/)[0].replace(/(email = |\n)/g, '');

         return {name: name, email: email};
      }
   }
   console.log('There is no global git config in $HOME');
}

let git = getGlobalGitConfig()

module.exports = {
   name: name,
   version: '0.1.0',
   author: {
      name: git.name,
      email: git.email
   },
   license: "BSD-3-Clauses"
};
