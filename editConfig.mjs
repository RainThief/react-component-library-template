import fs from 'fs';

const pkg = JSON.parse(fs.readFileSync("./package.json"));

const newPkg = {
  ...pkg,
  "name": "",
  "version": "0.0.1",
  "description": "React Component Library",
  "main": "build/cjs/index.js",
  "module": "build/es/index.js",
  "scripts": {
    ...pkg["scripts"],
    "build": "rollup -c"
  }
}

fs.writeFileSync('package.json', JSON.stringify(newPkg, null, 4));
