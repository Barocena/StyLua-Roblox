const { compile } = require("nexe");

compile({
  input: "./index.js",
  output: "StyLua-Roblox.exe",
  build: true,
  verbose: true,
  resources: "assets/icon.ico",
  rc: {
    FileDescription: "StyLua Roblox Plugin",
    ProductName: "StyLua Roblox Plugin",
    LegalCopyright: "https://github.com/Barocena/StyLua-Roblox-Plugin",
  },
})
  .then(() => console.log("Build completed!"))
  .catch(console.error);