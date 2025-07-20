repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Popup Confirm
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Dinosaur Simulator",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

-- Create Window & Tabs
local Window = WindUI:CreateWindow({
    Title = "DYHUB - Dinosaur Simulator",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- References for MainTab functions
local GameEvents = Workspace:WaitForChild("GameEvents")
local Props = Workspace:WaitForChild("GameMap"):WaitForChild("Gameland"):WaitForChild("Props")
local Bushes = Props:WaitForChild("Bushes")
local WaterTiles = Workspace:WaitForChild("GameMap"):WaitForChild("Water"):GetChildren()

-- Smooth Move Function
local dnaToggle = false

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

local function smoothMoveTo(position, duration)
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Character.HumanoidRootPart
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = { Position = position }
        local tween = TweenService:Create(hrp, tweenInfo, goal)
        tween:Play()
        tween.Completed:Wait()
    end
end

local function createGrassPlatform()
    if Workspace:FindFirstChild("DNA FARM | GrassPlatform") then
        Workspace["DNA FARM | GrassPlatform"]:Destroy()
    end
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local part = Instance.new("Part")
        part.Name = "DNA FARM | GrassPlatform"
        part.Anchored = true
        part.CanCollide = true
        part.Size = Vector3.new(100, 1, 100)
        part.Position = Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
        part.Material = Enum.Material.Grass
        part.Color = Color3.fromRGB(106, 190, 48)
        part.Parent = Workspace
    end
end

MainTab:Toggle({
    Title = "Auto Farm (DNA)",
    Value = false,
    Callback = function(state)
        dnaToggle = state
        if state then
            task.spawn(function()
                while dnaToggle do
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local pos = Character.HumanoidRootPart.Position
                        local targetY = pos.Y + 600
                        smoothMoveTo(Vector3.new(pos.X, targetY, pos.Z), 3)
                        task.wait(0.5)
                        createGrassPlatform()
                    else
                        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    end
                    task.wait(5)
                end
            end)
        end
    end,
})

-- Auto Farm Amber
local amberToggle = false

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

MainTab:Toggle({
    Title = "Auto Farm (Amber)",
    Value = false,
    Callback = function(state)
        amberToggle = state
        if state then
            task.spawn(function()
                local doneAmbers = {}
                while amberToggle do
                    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
                        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    end

                    local rootPos = Character.HumanoidRootPart.Position
                    for _, amber in ipairs(Workspace:WaitForChild("MiscellaneousStorage"):GetChildren()) do
                        if amber.Name == "Amber" and amber:IsA("Model") and not doneAmbers[amber] then
                            local prompt = amber:FindFirstChildOfClass("ProximityPrompt")
                            local part = amber:FindFirstChildWhichIsA("BasePart")
                            if prompt and part then
                                local distance = (part.Position - rootPos).Magnitude
                                if distance <= prompt.MaxActivationDistance then
                                    fireproximityprompt(prompt)
                                    doneAmbers[amber] = true
                                    task.wait(0.3)
                                else
                                    smoothMoveTo(part.Position + Vector3.new(0, 3, 0), 1.5)
                                    task.wait(0.3)
                                    fireproximityprompt(prompt)
                                    doneAmbers[amber] = true
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})

-- Amber ESP
local espToggle = false
local espObjects = {}

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

local function createEspAmber(amber)
    if not amber.PrimaryPart then
        local root = amber:FindFirstChild("HumanoidRootPart") or amber:FindFirstChildWhichIsA("BasePart")
        if root then
            amber.PrimaryPart = root
        else
            return
        end
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "AmberESP"
    highlight.Adornee = amber
    highlight.FillColor = Color3.fromRGB(255, 150, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Parent = amber

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AmberLabel"
    billboard.Adornee = amber.PrimaryPart
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = amber

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.TextColor3 = Color3.fromRGB(255, 150, 0)
    text.Parent = billboard

    espObjects[amber] = {
        highlight = highlight,
        billboard = billboard,
        textLabel = text,
    }
end

local function removeEspAmber(amber)
    local objs = espObjects[amber]
    if objs then
        if objs.highlight then objs.highlight:Destroy() end
        if objs.billboard then objs.billboard:Destroy() end
        espObjects[amber] = nil
    end
end

Workspace.MiscellaneousStorage.ChildAdded:Connect(function(child)
    if espToggle and child:IsA("Model") and child.Name == "Amber" then
        task.delay(0.1, function()
            if not espObjects[child] then
                createEspAmber(child)
            end
        end)
    end
end)

MainTab:Toggle({
    Title = "ESP (Amber)",
    Value = false,
    Callback = function(state)
        espToggle = state

        if state then
            for _, amber in ipairs(Workspace.MiscellaneousStorage:GetChildren()) do
                if amber:IsA("Model") and amber.Name == "Amber" then
                    createEspAmber(amber)
                end
            end

            task.spawn(function()
                while espToggle do
                    local root = Character and Character:FindFirstChild("HumanoidRootPart")
                    for amber, objs in pairs(espObjects) do
                        if not amber.Parent then
                            removeEspAmber(amber)
                        elseif root then
                            local dist = (amber.PrimaryPart.Position - root.Position).Magnitude
                            objs.textLabel.Text = string.format("Amber\n%.1f studs", dist)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            for amber in pairs(espObjects) do
                removeEspAmber(amber)
            end
        end
    end,
})

-- Auto Eat Hunger
local autoHunger = false
MainTab:Toggle({
    Title = "Auto Eat Hunger",
    Value = false,
    Callback = function(state)
        autoHunger = state
        if state then
            task.spawn(function()
                while autoHunger do
                    local closestBush = nil
                    local closestDist = math.huge

                    for _, bush in pairs(Bushes:GetChildren()) do
                        if bush:FindFirstChild("Leaves") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - bush.Leaves.Position).Magnitude
                            if dist < closestDist then
                                closestBush = bush.Leaves
                                closestDist = dist
                            end
                        end
                    end

                    if closestBush then
                        GameEvents:WaitForChild("EatPlant"):FireServer(closestBush)
                    end

                    task.wait(2)
                end
            end)
        end
    end,
})

-- Auto Eat Water
local autoWater = false
MainTab:Toggle({
    Title = "Auto Eat Water",
    Value = false,
    Callback = function(state)
        autoWater = state
        if state then
            task.spawn(function()
                while autoWater do
                    local closestWater = nil
                    local closestDist = math.huge

                    for _, tile in pairs(WaterTiles) do
                        if tile:FindFirstChild("Water") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - tile.Water.Position).Magnitude
                            if dist < closestDist then
                                closestWater = tile.Water
                                closestDist = dist
                            end
                        end
                    end

                    if closestWater then
                        GameEvents:WaitForChild("addThirst"):FireServer(closestWater, closestWater.Position)
                    end

                    task.wait(2)
                end
            end)
        end
    end,
})

-- Teleport Tab --

local function smoothTeleportTo(position, duration)
    smoothMoveTo(position, duration)
end

local amberList = {}
do
    local count = 0
    for _, v in ipairs(Workspace.MiscellaneousStorage:GetChildren()) do
        if v.Name == "Amber" and v:IsA("Model") and v.PrimaryPart then
            count = count + 1
            amberList[count] = v
        end
    end
end

local amberNames = {}
for i = 1, #amberList do
    table.insert(amberNames, "Amber"..i)
end

local selectedAmber = nil
TeleportTab:Dropdown({
    Title = "Select Amber To Teleport",
    Values = amberNames,
    Multi = false,
    Callback = function(selected)
        selectedAmber = selected
        print("[DYHUB] Selected Amber Teleport:", selectedAmber)
    end,
})

TeleportTab:Button({
    Title = "Teleport to Amber",
    Icon = "atom",
    Callback = function()
        if not selectedAmber then
            warn("Please select Amber first!")
            return
        end
        local index = tonumber(selectedAmber:match("%d+"))
        local target = amberList[index]
        if target and target.PrimaryPart then
            smoothTeleportTo(target.PrimaryPart.Position + Vector3.new(0,3,0), 2)
        else
            warn("Target Amber not found or missing PrimaryPart")
        end
    end,
})

local regionCenters = {
    Lab1 = Workspace.RegionCenter:FindFirstChild("Lab1") and Workspace.RegionCenter.Lab1.Position or nil,
    Lab2 = Workspace.RegionCenter:FindFirstChild("Lab2") and Workspace.RegionCenter.Lab2.Position or nil,
    Lab3 = Workspace.RegionCenter:FindFirstChild("Lab3") and Workspace.RegionCenter.Lab3.Position or nil,
}

local selectedRegion = nil
TeleportTab:Dropdown({
    Title = "Select Region",
    Values = {"Lab1", "Lab2", "Lab3"},
    Multi = false,
    Callback = function(value)
        selectedRegion = value
        print("[DYHUB] Selected Region:", selectedRegion)
    end,
})

TeleportTab:Button({
    Title = "Teleport to Region",
    Icon = "location",
    Callback = function()
        if not selectedRegion then
            warn("Please select a Region first!")
            return
        end
        local pos = regionCenters[selectedRegion]
        if pos then
            smoothTeleportTo(pos + Vector3.new(0, 3, 0), 2)
        else
            warn("Region position not found!")
        end
    end,
})

-- Player Tab --

local speedValue = 16
local jumpPowerValue = 50

PlayerTab:Slider({
    Title = "WalkSpeed",
    Default = speedValue,
    Min = 10,
    Max = 100,
    Callback = function(value)
        speedValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        end
    end,
})

PlayerTab:Slider({
    Title = "JumpPower",
    Default = jumpPowerValue,
    Min = 10,
    Max = 150,
    Callback = function(value)
        jumpPowerValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = jumpPowerValue
        end
    end,
})

-- ESP Dinosaurs --

local espDinoToggle = false
local espDinoObjects = {}

local function addLabel(text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.Text = text
    return label
end

local function createEspDino(dinoModel)
    if not dinoModel.PrimaryPart then
        local rootPart = dinoModel:FindFirstChild("HumanoidRootPart") or dinoModel:FindFirstChildWhichIsA("BasePart")
        if rootPart then
            dinoModel.PrimaryPart = rootPart
        else
            return
        end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DinoESP"
    billboard.Adornee = dinoModel.PrimaryPart
    billboard.Size = UDim2.new(0, 150, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = dinoModel

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard

    local nameLabel = addLabel("Name: Unknown")
    nameLabel.Parent = frame

    local hpLabel = addLabel("HP: ???")
    hpLabel.Position = UDim2.new(0, 0, 0, 18)
    hpLabel.Parent = frame

    local typeLabel = addLabel("Type: ???")
    typeLabel.Position = UDim2.new(0, 0, 0, 36)
    typeLabel.Parent = frame

    espDinoObjects[dinoModel] = {
        billboard = billboard,
        nameLabel = nameLabel,
        hpLabel = hpLabel,
        typeLabel = typeLabel,
    }
end

local function removeEspDino(dinoModel)
    local objs = espDinoObjects[dinoModel]
    if objs then
        if objs.billboard then objs.billboard:Destroy() end
        espDinoObjects[dinoModel] = nil
    end
end

MainTab:Toggle({
    Title = "ESP (Dino)",
    Value = false,
    Callback = function(state)
        espDinoToggle = state
        if state then
            for _, dino in ipairs(Workspace.Dinosaurs:GetChildren()) do
                if dino:IsA("Model") and not espDinoObjects[dino] then
                    createEspDino(dino)
                end
            end

            task.spawn(function()
                while espDinoToggle do
                    local root = Character and Character:FindFirstChild("HumanoidRootPart")
                    for dino, objs in pairs(espDinoObjects) do
                        if not dino.Parent then
                            removeEspDino(dino)
                        elseif root and dino.PrimaryPart then
                            local dist = (dino.PrimaryPart.Position - root.Position).Magnitude

                            -- Name
                            local dinoName = dino.Name or "Unknown"
                            objs.nameLabel.Text = "Name: " .. tostring(dinoName)

                            -- HP
                            local humanoid = dino:FindFirstChildOfClass("Humanoid")
                            if humanoid and humanoid.Health then
                                objs.hpLabel.Text = "HP: " .. math.floor(humanoid.Health)
                            else
                                objs.hpLabel.Text = "HP: ???"
                            end

                            -- Type (MemoryCard/CurrentDino StringValue safe check)
                            local memCard = dino:FindFirstChild("MemoryCard")
                            if memCard then
                                local currentDino = memCard:FindFirstChild("CurrentDino")
                                if currentDino and currentDino:IsA("StringValue") and currentDino.Value ~= nil then
                                    objs.typeLabel.Text = "Type: " .. tostring(currentDino.Value)
                                else
                                    objs.typeLabel.Text = "Type: Unknown"
                                end
                            else
                                objs.typeLabel.Text = "Type: Unknown"
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            for dino in pairs(espDinoObjects) do
                removeEspDino(dino)
            end
        end
    end,
})

-- Misc Tab --

local antiAfkEnabled = false
MiscTab:Toggle({
    Title = "Anti AFK",
    Value = false,
    Callback = function(state)
        antiAfkEnabled = state
        if state then
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(20)
                end
            end)
        end
    end,
})

-- Config Save/Load --

local ConfigFileName = "DYHUB_DinoSim_Config.json"

local function saveConfig()
    local config = {
        AutoFarmDNA = dnaToggle,
        AutoFarmAmber = amberToggle,
        AutoEatHunger = autoHunger,
        AutoEatWater = autoWater,
        ESPAmber = espToggle,
        ESPDino = espDinoToggle,
        WalkSpeed = speedValue,
        JumpPower = jumpPowerValue,
        SelectedAmber = selectedAmber,
        SelectedRegion = selectedRegion,
    }
    local json = game:GetService("HttpService"):JSONEncode(config)
    writefile(ConfigFileName, json)
end

local function loadConfig()
    if isfile(ConfigFileName) then
        local json = readfile(ConfigFileName)
        local config = game:GetService("HttpService"):JSONDecode(json)
        dnaToggle = config.AutoFarmDNA or false
        amberToggle = config.AutoFarmAmber or false
        autoHunger = config.AutoEatHunger or false
        autoWater = config.AutoEatWater or false
        espToggle = config.ESPAmber or false
        espDinoToggle = config.ESPDino or false
        speedValue = config.WalkSpeed or 16
        jumpPowerValue = config.JumpPower or 50
        selectedAmber = config.SelectedAmber
        selectedRegion = config.SelectedRegion

        -- Apply values to toggles/sliders
        MainTab:GetToggle("Auto Farm (DNA)").Value = dnaToggle
        MainTab:GetToggle("Auto Farm (Amber)").Value = amberToggle
        MainTab:GetToggle("Auto Eat Hunger").Value = autoHunger
        MainTab:GetToggle("Auto Eat Water").Value = autoWater
        MainTab:GetToggle("ESP (Amber)").Value = espToggle
        MainTab:GetToggle("ESP (Dino)").Value = espDinoToggle
        PlayerTab:GetSlider("WalkSpeed").Value = speedValue
        PlayerTab:GetSlider("JumpPower").Value = jumpPowerValue
    end
end

loadConfig()

ConfigTab:Button({
    Title = "Save Config",
    Icon = "content-save",
    Callback = saveConfig,
})

ConfigTab:Button({
    Title = "Load Config",
    Icon = "folder-open",
    Callback = loadConfig,
})

return Window
