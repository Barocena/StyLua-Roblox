const exe = require("@angablue/exe");

const build = exe({
  entry: "package.json",
  out: "StyLua-Roblox.exe",
  version: "1.1.0",
  target: "node20-win-x64",
  icon: "./assets/icon.ico",
  pkg: ["-C","Brotli"],
  executionLevel: "asInvoker",
  properties: {
    FileDescription: "StyLua Roblox",
    ProductName: "StyLua Roblox",
    LegalCopyright: "https://github.com/Barocena/StyLua-Roblox",
    OriginalFilename: "StyLua-Roblox.exe",
  },
});

build.then(() => console.log("Build completed!"));