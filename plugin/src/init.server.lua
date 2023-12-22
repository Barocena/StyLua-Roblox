--!strict

-- StyLua Roblox
-- Version 1.1.0

local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local StudioService = game:GetService("StudioService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local ServerStorage = game:GetService("ServerStorage")

assert(plugin, "This code must run inside of a plugin")

if game:GetService("RunService"):IsRunning() then
	return
end

local ConfigInfo = {
	column_width = {
		DefaultValue = 120,
		Options = "<number>",
	},
	line_endings = {
		DefaultValue = "Unix",
		Options = "Unix,Windows",
	},
	indent_type = {
		DefaultValue = "Tabs",
		Options = "Tabs,Spaces",
	},
	indent_width = {
		DefaultValue = 4,
		Options = "<number>",
	},
	quote_style = {
		DefaultValue = "AutoPreferDouble",
		Options = "AutoPreferDouble, AutoPreferSingle, ForceDouble, ForceSingle",
	},
	call_parentheses = {
		DefaultValue = "Always",
		Options = "Always, NoSingleString, NoSingleTable, None, Input",
	},
	collapse_simple_statement = {
		DefaultValue = "Never",
		Options = "Never, FunctionOnly, ConditionalOnly, Always",
	},
	sort_requires = {
		DefaultValue = false,
		Options = "<boolean>",
	},
}

function wrap(Value)
	if type(Value) == "string" then
		return '"' .. Value .. '"'
	else
		return tostring(Value)
	end
end

function generateSettings()
	local Settings = plugin:GetSetting("StyLuaSettings")
	local Output = "-- Stylua Configuration\nreturn {\n\n"
	for CName, CValue in Settings do
		Output = Output
			.. "\t"
			.. CName
			.. " = "
			.. wrap(CValue)
			.. ",	--| "
			.. ConfigInfo[CName].Options
			.. " | "
			.. "\n"
	end

	Output = Output .. "\n}"

	return Output
end

function validateSettings(Module)
	local Settings
	local result: any, _: any = loadstring(Module.Source)
	if result == nil then
		return false
	end
	local _, err = pcall(function()
		Settings = result()
	end)
	if err then
		return false
	end
	-- type and option checks
	for Cname, CValue in Settings do
		if type(CValue) ~= type(ConfigInfo[Cname].DefaultValue) then
			return false
		end
		if type(ConfigInfo[Cname].DefaultValue) == "string" then
			local Options = string.split(ConfigInfo[Cname].Options:gsub("%s+", ""), ",")
			if not table.find(Options, CValue) then
				return false
			end
		end
	end
	return Settings
end

local Connection
function applySettings()
	local Module = AnalyticsService.StyLua_Settings
	Connection = ScriptEditorService.TextDocumentDidChange:Connect(function()
		local NewSetting = validateSettings(Module)
		if NewSetting then
			plugin:SetSetting("StyLuaSettings", NewSetting)
		end
	end)
end

function openSettings()
	local Module = AnalyticsService:FindFirstChild("StyLua_Settings")

	if not Module then
		Module = Instance.new("ModuleScript")
		Module.Name = "StyLua_Settings"
		Module.Archivable = false
		Module.Parent = AnalyticsService
	end

	if not plugin:GetSetting("StyLuaSettings") then
		local ConfigTable = {}
		for ConfigName, ConfigData in pairs(ConfigInfo) do
			ConfigTable[ConfigName] = ConfigData.DefaultValue
		end
		plugin:SetSetting("StyLuaSettings", ConfigTable)
	end

	ScriptEditorService:UpdateSourceAsync(Module, function()
		return generateSettings()
	end)
	if Connection == nil then
		applySettings()
	end
	plugin:OpenScript(Module)
end

function fetchSettings()
	local Config = {}

	-- Place Only Settings
	local PlaceSetting = ServerStorage:FindFirstChild("StyLua")
	if PlaceSetting and PlaceSetting:IsA("LuaSourceContainer") then
		local PlaceConfig = validateSettings(PlaceSetting)
		if PlaceConfig then
			for setting, value in PlaceConfig :: any do
				if value ~= ConfigInfo[setting].DefaultValue then
					Config[setting] = value
				end
			end
		end
		return Config
	end

	--Global Settings
	for setting, value in plugin:GetSetting("StyLuaSettings") do
		if value ~= ConfigInfo[setting].DefaultValue then
			Config[setting] = value
		end
	end
	return Config
end

local FormatAction =
	plugin:CreatePluginAction("StyLua Format", "Format", "Formats the code", "rbxassetid://15177733701", true)

function formatter(script)
	local ConfigJSON = fetchSettings()

	local success, result = pcall(HttpService.RequestAsync, HttpService, {
		Method = "POST" :: "POST",
		Url = `http://localhost:18259/stylua?Config={HttpService:JSONEncode(ConfigJSON)}`,
		Headers = {
			["Content-Type"] = "text/plain",
		},
		Body = ScriptEditorService:GetEditorSource(script),
	})
	if not success then
		warn(`[StyLua] Connecting to server failed: {result}`)
	elseif not result.Success then
		local body = result.Body :: any
		if body:match("<!DOCTYPE html>") then
			--[[
			For some reason it gives error message with doctype (on roblox output only) 
			so did some parsing and cleaning up for better error message
			--]]
			warn(`[StyLua] {body:match("<pre>(.-)</pre>"):gsub("&#39;", "'"):gsub("<br>", "\n"):sub(1, -1)}`)
		end
	else
		if ScriptEditorService:GetEditorSource(script) == result.Body then
			return
		end
		ScriptEditorService:UpdateSourceAsync(script, function()
			return result.Body
		end)
		ChangeHistoryService:SetWaypoint("StyLua")
	end
end

function format()
	if StudioService.ActiveScript then
		formatter(StudioService.ActiveScript)
		return
	end
	local Selected = Selection:Get()
	for _, Object in Selected do
		if Object:IsA("LuaSourceContainer") then
			formatter(Object)
		end
	end
end

local toolbar = plugin:CreateToolbar("StyLua")

local FormatButton = toolbar:CreateButton("StyLua", "Format Document", "rbxassetid://15177733701", "StyLua")
FormatButton.ClickableWhenViewportHidden = true

local SettingButton =
	toolbar:CreateButton("StyLuaSettings", "StyLua Settings", "rbxassetid://15177736312", "StyLua Settings")
SettingButton.ClickableWhenViewportHidden = true

FormatAction.Triggered:Connect(format)
FormatButton.Click:Connect(format)
SettingButton.Click:Connect(openSettings)
