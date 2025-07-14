local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ======= Global Variables =======
_G.ColorLightKill = Color3.fromRGB(255, 0, 0)
_G.ColorLightSurvivor = Color3.fromRGB(0, 255, 0)
_G.EspHighlight = false
_G.EspGui = false
_G.EspName = true
_G.EspDistance = true
_G.EspHealth = true

local InfiniteJumpEnabled = false
local PowerJumpEnabled = false
local PowerJumpStrength = 100

-- ======= ESP Functions =======
local function Esp_Player(character, color)
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") or not character:FindFirstChild("Humanoid") then
        return
    end

    -- Highlight
    local highlight = character:FindFirstChild("Esp_Highlight")
    if _G.EspHighlight then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Esp_Highlight"
            highlight.Parent = character
            highlight.Adornee = character
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
        end
        highlight.FillColor = color
        highlight.OutlineColor = color
    else
        if highlight then
            highlight:Destroy()
        end
    end

    -- BillboardGui
    local head = character.Head
    local gui = head:FindFirstChild("Esp_Gui")
    if _G.EspGui then
        if not gui then
            gui = Instance.new("BillboardGui")
            gui.Name = "Esp_Gui"
            gui.Adornee = head
            gui.AlwaysOnTop = true
            gui.Size = UDim2.new(0, 100, 0, 50)
            gui.StudsOffset = Vector3.new(0, 2, 0)
            gui.Parent = head

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TextLabel"
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Font = Enum.Font.Code
            textLabel.TextSize = 15
            textLabel.TextColor3 = color
            textLabel.TextStrokeTransparency = 0.5
            textLabel.Parent = gui
        end

        -- Update Text
        local textLabel = gui:FindFirstChild("TextLabel")
        if textLabel then
            local text = ""
            if _G.EspName then
                text = character.Name
            end
            if _G.EspDistance then
                local dist = 0
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    dist = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                end
                text = text .. "\nDist: " .. string.format("%.1f", dist)
            end
            if _G.EspHealth then
                text = text .. "\nHP: " .. math.floor(character.Humanoid.Health)
            end
            textLabel.Text = text
            textLabel.TextColor3 = color
        end
    else
        if gui then
            gui:Destroy()
        end
    end
end

local function ClearEspPlayers()
    for _, teamFolder in pairs({"Killers", "Survivors"}) do
        local team = Workspace.Players:FindFirstChild(teamFolder)
        if team then
            for _, char in pairs(team:GetChildren()) do
                local highlight = char:FindFirstChild("Esp_Highlight")
                if highlight then highlight:Destroy() end
                local gui = char:FindFirstChild("Head") and char.Head:FindFirstChild("Esp_Gui")
                if gui then gui:Destroy() end
            end
        end
    end
end

local function RunEspKillers()
    while _G.EspKillers do
        local killers = Workspace.Players:FindFirstChild("Killers")
        if killers then
            for _, char in pairs(killers:GetChildren()) do
                Esp_Player(char, _G.ColorLightKill)
            end
        end
        task.wait(0.7)
    end
end

local function RunEspSurvivors()
    while _G.EspSurvivors do
        local survivors = Workspace.Players:FindFirstChild("Survivors")
        if survivors then
            for _, char in pairs(survivors:GetChildren()) do
                Esp_Player(char, _G.ColorLightSurvivor)
            end
        end
        task.wait(0.7)
    end
end

-- ======= Teleport Functions =======
local function TeleportToKiller()
    local killers = Workspace.Players:FindFirstChild("Killers")
    if killers then
        for _, char in pairs(killers:GetChildren()) do
            if char:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
                return
            end
        end
    end
    warn("No Killers found!")
end

local function TeleportToRandomPlayer()
    local survivors = Workspace.Players:FindFirstChild("Survivors")
    if survivors then
        local chars = {}
        for _, char in pairs(survivors:GetChildren()) do
            if char:FindFirstChild("HumanoidRootPart") then
                table.insert(chars, char)
            end
        end
        if #chars > 0 then
            local randomChar = chars[math.random(1, #chars)]
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomChar.HumanoidRootPart.CFrame
            return
        end
    end
    warn("No Survivors found!")
end

local function TeleportToGenerator()
    local map = Workspace:FindFirstChild("Map")
    if map and map:FindFirstChild("Ingame") and map.Ingame:FindFirstChild("Map") then
        for _, gen in pairs(map.Ingame.Map:GetChildren()) do
            if gen.Name == "Generator" and gen:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gen.HumanoidRootPart.CFrame
                return
            end
        end
    end
    warn("No Generator found!")
end

-- ======= Misc Features =======
-- Xray toggle: makes all parts in Workspace.Map transparent
local XrayEnabled = false
local function ToggleXray(value)
    XrayEnabled = value
    local map = Workspace:FindFirstChild("Map")
    if not map then return end
    for _, obj in pairs(map:GetDescendants()) do
        if obj:IsA("BasePart") then
            if XrayEnabled then
                obj.LocalTransparencyModifier = 0.5
            else
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Power Jump (Boost Humanoid.JumpPower)
RunService.Heartbeat:Connect(function()
    if PowerJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = PowerJumpStrength
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        -- Reset jump power to default 50 if disabled
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower ~= 50 then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
        end
    end
end)

-- ======= Create Window & Tabs =======
local Window = WindUI:CreateWindow({
    Folder = "DYHUB Scripts (Forsaken)",
    Title = "DYHUB | Forsaken",
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    HasOutline = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "star" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "rocket" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "tool" })
local EspTab = Window:Tab({ Title = "ESP", Icon = "eye" })

-- ======= Main Tab (ตัวอย่างใส่ Auto General + WalkSpeed) =======
local mainGroup = MainTab:AddLeftGroupbox("Main Features")

mainGroup:AddToggle("AutoGeneral", {
    Text = "Auto General",
    Default = false,
    Callback = function(Value)
        _G.AutoGeneral = Value
        spawn(function()
            while _G.AutoGeneral do
                local map = Workspace:FindFirstChild("Map")
                if map and map:FindFirstChild("Ingame") and map.Ingame:FindFirstChild("Map") then
                    for _, v in ipairs(map.Ingame.Map:GetChildren()) do
                        if v.Name == "Generator" and v:FindFirstChild("Remotes") and v.Remotes:FindFirstChild("RE") then
                            v.Remotes.RE:FireServer()
                        end
                    end
                end
                task.wait(1.8)
            end
        end)
    end,
})

mainGroup:AddSlider("WalkSpeedSlider", {
    Text = "WalkSpeed",
    Default = 20,
    Min = 7,
    Max = 50,
    Rounding = 0,
    Callback = function(value)
        _G.SpeedWalk = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedWalk
        end
    end,
})

mainGroup:AddToggle("SetSpeedToggle", {
    Text = "Set Speed",
    Default = false,
    Callback = function(Value)
        _G.NahSpeed = Value
        spawn(function()
            while _G.NahSpeed do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedWalk or 20
                    LocalPlayer.Character.Humanoid:SetAttribute("BaseSpeed", _G.SpeedWalk or 20)
                end
                task.wait()
            end
        end)
    end,
})

-- ======= Teleport Tab =======
local teleportGroup = TeleportTab:AddLeftGroupbox("Teleport Options")

teleportGroup:AddButton("Teleport To Killer", function()
    TeleportToKiller()
end)

teleportGroup:AddButton("Teleport To Random Player", function()
    TeleportToRandomPlayer()
end)

teleportGroup:AddButton("Teleport To Generator", function()
    TeleportToGenerator()
end)

-- ======= Misc Tab =======
local miscGroup = MiscTab:AddLeftGroupbox("Misc Features")

miscGroup:AddToggle("XrayToggle", {
    Text = "Xray (Make Map Transparent)",
    Default = false,
    Callback = function(value)
        ToggleXray(value)
    end,
})

miscGroup:AddToggle("InfiniteJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(value)
        InfiniteJumpEnabled = value
    end,
})

miscGroup:AddToggle("PowerJumpToggle", {
    Text = "Power Jump",
    Default = false,
    Callback = function(value)
        PowerJumpEnabled = value
    end,
})

miscGroup:AddSlider("PowerJumpStrengthSlider", {
    Text = "Power Jump Strength",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        PowerJumpStrength = value
    end,
})

-- ======= ESP Tab =======
local espGroup = EspTab:AddLeftGroupbox("ESP Settings")

espGroup:AddToggle("EspKillersToggle", {
    Text = "ESP Killers",
    Default = false,
    Callback = function(Value)
        _G.EspKillers = Value
        if not Value then
            ClearEspPlayers()
        else
            spawn(RunEspKillers)
        end
    end,
})

espGroup:AddToggle("EspSurvivorsToggle", {
    Text = "ESP Survivors",
    Default = false,
    Callback = function(Value)
        _G.EspSurvivors = Value
        if not Value then
            ClearEspPlayers()
        else
            spawn(RunEspSurvivors)
        end
    end,
})

espGroup:AddColorPicker("ColorKillers", {
    Default = _G.ColorLightKill,
    Callback = function(Value)
        _G.ColorLightKill = Value
    end,
})

espGroup:AddColorPicker("ColorSurvivors", {
    Default = _G.ColorLightSurvivor,
    Callback = function(Value)
        _G.ColorLightSurvivor = Value
    end,
})

espGroup:AddToggle("EspHighlightToggle", {
    Text = "ESP Highlight",
    Default = _G.EspHighlight,
    Callback = function(Value)
        _G.EspHighlight = Value
    end,
})

espGroup:AddToggle("EspGuiToggle", {
    Text = "ESP GUI (Name, Distance, Health)",
    Default = _G.EspGui,
    Callback = function(Value)
        _G.EspGui = Value
    end,
})

espGroup:AddToggle("EspNameToggle", {
    Text = "Show Name",
    Default = _G.EspName,
    Callback = function(Value)
        _G.EspName = Value
    end,
})

espGroup:AddToggle("EspDistanceToggle", {
    Text = "Show Distance",
    Default = _G.EspDistance,
    Callback = function(Value)
        _G.EspDistance = Value
    end,
})

espGroup:AddToggle("EspHealthToggle", {
    Text = "Show Health",
    Default = _G.EspHealth,
    Callback = function(Value)
        _G.EspHealth = Value
    end,
})

print("DYHUB | Forsaken GUI Loaded!")
