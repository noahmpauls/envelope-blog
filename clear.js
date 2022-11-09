fs = require('fs');

fs.rm("./_site", { recursive: true, force: true }, err => console.log(err))