<div align="center">
<img src="./assets/icon.ico">
<h1>
StyLua Roblox
</h1>
</div>

[StyLua](https://github.com/JohnnyMorganz/StyLua) roblox plugin is a formatter made for roblox studio.

## Installation

### With GitHub Releases & Roblox Marketplace

- Download the `StyLua-Roblox` from [latest release](github.com/Barocena/StyLua-Roblox-Plugin/releases/latest)
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

To Format, click the StyLua button or bind a shortcut from shortcut settings.<br>
Formatting with a script editor open will format the current script.<br>
To format multiple scripts, you can close the script editor and select the scripts you want to format from Explorer and format.

To Change the Configuration of StyLua, Click the Open Settings Button.<br>
more info about options and what it does can be found [here](https://github.com/JohnnyMorganz/StyLua?tab=readme-ov-file#options)

To Create Place-only Settings, Add a module named `StyLua` (case-sensitive) to ServerStorage.<br>
Copy the Settings from Open Settings menu and paste it in, plugin will use these settings
