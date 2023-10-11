--!strict
local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local StudioService = game:GetService("StudioService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
assert(plugin, "This code must run inside of a plugin")

if game:GetService("RunService"):IsRunning() then
	return
end

local toolbar = plugin:CreateToolbar("StyLua")

local FormatButton =
	toolbar:CreateButton("StyLua", "Format Document", "rbxassetid://15034570789", "StyLua") :: PluginToolbarButton
FormatButton.ClickableWhenViewportHidden = true

local FormatAction =
	plugin:CreatePluginAction("StyLua Format", "Format", "Formats the code", "rbxassetid://15034570789", true)

function Format()
	if not StudioService.ActiveScript then
		return
	end
	local success, result = pcall(HttpService.RequestAsync, HttpService, {
		Method = "POST" :: "POST",
		Url = "http://localhost:3000/stylua",
		Headers = {
			["Content-Type"] = "text/plain",
		},
		Body = ScriptEditorService:GetEditorSource(StudioService.ActiveScript),
	})
	if not success then
		warn(`[StyLua] Connecting to server failed: {result}`)
	elseif not result.Success then
		warn(`[StyLua] {result.Body}`)
	else
		ScriptEditorService:UpdateSourceAsync(StudioService.ActiveScript, function()
			return result.Body
		end)
		ChangeHistoryService:SetWaypoint("StyLua")
	end
end

FormatAction.Triggered:Connect(Format)
FormatButton.Click:Connect(Format)
