<div align="center">
<h1>
StyLua Roblox Plugin
</h1>
</div>

[StyLua](https://github.com/JohnnyMorganz/StyLua) roblox plugin is a formatter made for roblox studio.
Since implementing StyLua directly in the studio is not possible, it sends the code to the local webserver and gets formatted output back instead.

## Installation

### With GitHub Releases & Roblox Marketplace

- Download the `StyLua-Plugin.exe` from [latest release](github.com/Barocena/StyLua-Roblox-Plugin/releases/latest)
- Install the [plugin](https://create.roblox.com/marketplace/asset/15035645978/StyLua-Plugin)

### Manual Installation
###### Installing with GitHub releases and roblox marketplace is recommended

#### Requirements
- [git](https://git-scm.com/downloads)
- [npm](https://nodejs.org/en)
- [Rojo](https://rojo.space)

#### Program
- `git clone` the Project
- run `npm install`
- run `node index.js` to start the web server

#### Plugin
- `git clone` the Project
- cd to the `plugin` folder
- run `rojo build --plugin -o stylua.rbxmx`
- reboot the studio, plugin will be installed

## Usage

Once installed, you can run the program and use the plugin on Studio, Program needs to run while you using the plugin.

To Format, click the StyLua button or bind a shortcut from shortcut settings.
Formatting with a script editor open will format the current script.
To format multiple scripts, you can close the script editor and select the scripts you want to format from Explorer and format.

To Change the Configuration of StyLua, Click the Open Settings Button.
more info about options and what it does can be found [here](https://github.com/JohnnyMorganz/StyLua?tab=readme-ov-file#options)
