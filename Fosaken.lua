local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/Test.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/ThemeManagerCopy.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/SaveManagerCopy.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

function Notification(Message, Time)
if _G.ChooseNotify == "Obsidian" then
Library:Notify(Message, Time or 5)
elseif _G.ChooseNotify == "Roblox" then
game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = Message,Icon = "rbxassetid://7733658504",Duration = Time or 5})
end
if _G.NotificationSound then
        local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = _G.VolumeTime or 2
            sound.PlayOnRemove = true
            sound:Destroy()
        end
    end

Library:SetDPIScale(85)

local Window = Library:CreateWindow({
    Title = "DYHUB | Forsaken",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "DYHUB | Version: v187",
	Icon = 0,
	AutoLock = false,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})

Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://7734053426"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Main1Group = Tabs.Tab:AddLeftGroupbox("Main")

Main1Group:AddToggle("AutoGeneral", {
    Text = "Auto General",
    Default = false, 
    Callback = function(Value) 
_G.AutoGeneral = Value
while _G.AutoGeneral do
if workspace.Map.Ingame:FindFirstChild("Map") then
for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
if v.Name == "Generator" and v:FindFirstChild("Remotes") and v.Remotes:FindFirstChild("RE") then
v.Remotes:FindFirstChild("RE"):FireServer()
end
end
end
task.wait(1.8)
end
    end
})

Main1Group:AddToggle("Inf Stamina", {
    Text = "Inf Stamina",
    Default = false, 
    Callback = function(Value) 
_G.InfStamina = Value
while _G.InfStamina do
local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
if staminaModule then
    staminaModule.MaxStamina = 696969
    staminaModule.Stamina = 696969
    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
end
task.wait()
end
    end
})

Main1Group:AddSlider("Speed", {
    Text = "WalkSpeed",
    Default = 25,
    Min = 7,
    Max = 99,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.SpeedWalk = Value
    end
})

Main1Group:AddToggle("SetSpeed", {
    Text = "Set Speed",
    Default = false, 
    Callback = function(Value) 
_G.NahSpeed = Value
while _G.NahSpeed do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedWalk
game.Players.LocalPlayer.Character.Humanoid:SetAttribute("BaseSpeed", _G.SpeedWalk)
end
task.wait()
end
    end
})

local Main2Group = Tabs.Tab:AddRightGroupbox("Esp")

Main2Group:AddToggle("General", {
    Text = "Esp General",
    Default = false, 
    Callback = function(Value) 
_G.EspGeneral = Value
if _G.EspGeneral == false then
if workspace.Map.Ingame:FindFirstChild("Map") then
	for i, v in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
		if v.Name == "Generator" then
			for x, n in pairs(v:GetChildren()) do
				if n.Name:find("Esp_") then
					n:Destroy()
				end
			end
		end
	end
end
end
while _G.EspGeneral do
if workspace.Map.Ingame:FindFirstChild("Map") then
for i, v in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
if v.Name == "Generator" and v:FindFirstChild("Progress") then
if v:FindFirstChild("Esp_Highlight") then
	if v:FindFirstChild("Progress").Value == 100 then
		v:FindFirstChild("Esp_Highlight").FillColor = Color3.fromRGB(0, 255, 0)
		v:FindFirstChild("Esp_Highlight").OutlineColor = Color3.fromRGB(0, 255, 0)
	else
		v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.new(255, 255, 255)
		v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.new(255, 255, 255)
	end
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "General ("..v.Progress.Value.."%)" or "")..
            (_G.EspDistance == true and "\nDistance [ Fix ]" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiGenEsp = Instance.new("BillboardGui", v)
	GuiGenEsp.Adornee = v
	GuiGenEsp.Name = "Esp_Gui"
	GuiGenEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiGenEsp.AlwaysOnTop = true
	GuiGenEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiGenEspText = Instance.new("TextLabel", GuiGenEsp)
	GuiGenEspText.BackgroundTransparency = 1
	GuiGenEspText.Font = Enum.Font.Code
	GuiGenEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiGenEspText.TextSize = 15
	GuiGenEspText.TextColor3 = Color3.new(0,0,0) 
	GuiGenEspText.TextStrokeTransparency = 0.5
	GuiGenEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiGenEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
end
task.wait()
end
    end
})

function Esp_Player(v, Colorlight)
if v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
	v:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v.Head:FindFirstChild("Esp_Gui") and v.Head["Esp_Gui"]:FindFirstChild("TextLabel") then
	v.Head["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and v.Name or "")..
            (_G.EspDistance == true and "\nDistance [ "..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude).." ]" or "")..
            (_G.EspHealth == true and "\nHealth [ "..string.format("%.0f", v.Humanoid.Health).." ]" or "")
    v.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v.Head:FindFirstChild("Esp_Gui") == nil then
	GuiPlayerEsp = Instance.new("BillboardGui", v.Head)
	GuiPlayerEsp.Adornee = v.Head
	GuiPlayerEsp.Name = "Esp_Gui"
	GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiPlayerEsp.AlwaysOnTop = true
	GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
	GuiPlayerEspText.BackgroundTransparency = 1
	GuiPlayerEspText.Font = Enum.Font.Code
	GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiPlayerEspText.TextSize = 15
	GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
	GuiPlayerEspText.TextStrokeTransparency = 0.5
	GuiPlayerEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiPlayerEspText
	elseif _G.EspGui == false and v.Head:FindFirstChild("Esp_Gui") then
	v.Head:FindFirstChild("Esp_Gui"):Destroy()
end
end

Main2Group:AddDropdown("EspPlayer", {
    Text = "Esp Player",
    Values = {"Killers", "Survivors"},
    Default = "",
    Multi = true
})

Main2Group:AddToggle("Player", {
    Text = "Esp Player",
    Default = false, 
    Callback = function(Value) 
_G.EspPlayer = Value
if _G.EspPlayer == false then
	for i, v in pairs(game.Workspace.Players:GetChildren()) do
		if v.Name == "Killers" or v.Name == "Survivors" then
			for y, z in pairs(v:GetChildren()) do
				if z.Name:find("Esp_") then
					z:Destroy()
				end
			end
		end
	end
end
while _G.EspPlayer do
for i, v in pairs(game.Workspace.Players:GetChildren()) do
	if Options.EspPlayer.Value["Killers"] and v.Name == "Killers" then
		for y, z in pairs(v:GetChildren()) do
			if z:FindFirstChild("HumanoidRootPart") and z:FindFirstChild("Humanoid") and z:FindFirstChild("Head") then
				Esp_Player(z, _G.ColorLightKill or Color3.fromRGB(255, 0, 0))
			end
		end
	elseif not Options.EspPlayer.Value["Killers"] then
		if v.Name == "Killers" then
			for y, z in pairs(v:GetChildren()) do
				if z.Name:find("Esp_") then
					z:Destroy()
				end
			end
		end
	end
	if Options.EspPlayer.Value["Survivors"] and v.Name == "Survivors" then
		for y, z in pairs(v:GetChildren()) do
			if z:FindFirstChild("HumanoidRootPart") and z:FindFirstChild("Humanoid") and z:FindFirstChild("Head") then
				Esp_Player(z, _G.ColorLightSurvivors or Color3.fromRGB(0, 255, 0))
			end
		end
	elseif not Options.EspPlayer.Value["Survivors"] and v.Name == "Survivors" then
		for y, z in pairs(v:GetChildren()) do
			if z.Name:find("Esp_") then
				z:Destroy()
			end
		end
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp1", {
     Default = Color3.new(255, 0, 0),
     Callback = function(Value)
_G.ColorLightKill = Value
     end
}):AddColorPicker("Color Esp2", {
     Default = Color3.new(0, 255, 0),
     Callback = function(Value)
_G.ColorLightSurvivors= Value
     end
})

Main2Group:AddDivider()

_G.EspHighlight = false
Main2Group:AddToggle("Esp Hight Light", {
    Text = "Esp Hight Light",
    Default = false, 
    Callback = function(Value) 
_G.EspHighlight = Value
    end
}):AddColorPicker("Color Esp", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.ColorLight = Value
     end
})

_G.EspGui = false
Main2Group:AddToggle("Esp Gui", {
    Text = "Esp Gui",
    Default = false, 
    Callback = function(Value) 
_G.EspGui = Value
    end
}):AddColorPicker("Color Esp Text", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.EspGuiTextColor = Value
     end
})

Main2Group:AddSlider("Text Size", {
    Text = "Text Size [ Gui ]",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.EspGuiTextSize = Value
    end
})

Main2Group:AddDivider()

_G.EspName = false
Main2Group:AddToggle("Esp Name", {
    Text = "Esp Name",
    Default = false, 
    Callback = function(Value) 
_G.EspName = Value
    end
})

_G.EspDistance = false
Main2Group:AddToggle("Esp Distance", {
    Text = "Esp Distance",
    Default = false, 
    Callback = function(Value) 
_G.EspDistance = Value
    end
})

_G.EspHealth = false
Main2Group:AddToggle("Esp Health", {
    Text = "Esp Health",
    Default = false, 
    Callback = function(Value) 
_G.EspHealth = Value
    end
})

------------------------------------------------------------------------
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local CreditsGroup = Tabs["UI Settings"]:AddRightGroupbox("Credits")
local Info = Tabs["UI Settings"]:AddRightGroupbox("Info")

MenuGroup:AddDropdown("NotifySide", {
    Text = "Notification Side",
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
Library:SetNotifySide(Value)
    end
})

_G.ChooseNotify = "Obsidian"
MenuGroup:AddDropdown("NotifyChoose", {
    Text = "Notification Choose",
    Values = {"Obsidian", "Roblox"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
})

_G.NotificationSound = true
MenuGroup:AddToggle("NotifySound", {
    Text = "Notification Sound",
    Default = true, 
    Callback = function(Value) 
_G.NotificationSound = Value 
    end
})

MenuGroup:AddSlider("Volume Notification", {
    Text = "Volume Notification",
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})

MenuGroup:AddToggle("KeybindMenuOpen", {Default = false, Text = "Open Keybind Menu", Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
_G.LinkJoin = loadstring(game:HttpGet("https://pastefy.app/Ml1XV4J3/raw?part="))()
MenuGroup:AddButton("Copy Link Discord", function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Discord"])
        Library:Notify("Copied discord link to clipboard!")
    else
        Library:Notify("Discord link: ".._G.LinkJoin["Discord"], 10)
    end
end):AddButton("Copy Link DYHUB SERVER", function()
    if setclipboard then
        setclipboard(_G.LinkJoin["DYHUB"])
        Library:Notify("Copied DYHUB link to clipboard!")
    else
        Library:Notify("DYHUB link: ".._G.LinkJoin["DYHUB"], 10)
    end
end)
MenuGroup:AddButton("Unload", function() Library:Unload() end)
CreditsGroup:AddLabel("DYHUB LOADER - Python / Dex / Script", true)
CreditsGroup:AddLabel("DYHUB TEAM - Script / Dex", true)
CreditsGroup:AddLabel("@DYUMRA - Script / Dex", true)

Info:AddLabel("Counter [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel("Executor [ "..identifyexecutor().." ]", true)
Info:AddLabel("Job Id [ "..game.JobId.." ]", true)
Info:AddDivider()
Info:AddButton("Copy JobId", function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Library:Notify("Copied Success")
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Info:AddInput("Join Job", {
    Default = "Put JobId in here",
    Numeric = false,
    Text = "Join Job",
    Placeholder = "UserJobId",
    Callback = function(Value)
_G.JobIdJoin = Value
    end
})

Info:AddButton("Join JobId", function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdJoin, game.Players.LocalPlayer)
end)

Info:AddButton("Copy Join JobId", function()
    if setclipboard then
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, '..game.JobId..", game.Players.LocalPlayer)")
        Library:Notify("Copied Success") 
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig() 
