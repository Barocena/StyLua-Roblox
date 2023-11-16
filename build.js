// build.js
const exe = require("@angablue/exe");

const build = exe({
  entry: "./index.js",
  out: "./out/StyLua-Plugin.exe",
  version: "1.0.0",
  target: "latest-win-x64",
  icon: "./assets/icon.ico",
  executionLevel: "asInvoker",
  properties: {
    FileDescription: "StyLua Roblox Plugin",
    ProductName: "StyLua Roblox Plugin",
    LegalCopyright: "https://github.com/Barocena/StyLua-Roblox-Plugin",
    OriginalFilename: "StyLua-Plugin.exe",
  },
});

build.then(() => console.log("Build completed!"));
