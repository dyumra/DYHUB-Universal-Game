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
    Title = "Auto Farm (DNA) (Turn On: Auto Eat Water/Hunger first)",
    Value = false,
    Callback = function(state)
        dnaToggle = state
        if state then
            task.spawn(function()
                while dnaToggle do
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local rootPos = Character.HumanoidRootPart.Position
                        local targetY = rootPos.Y + 100

                        -- ลอยตัวละครขึ้น
                        Character.HumanoidRootPart.CFrame = CFrame.new(rootPos.X, targetY, rootPos.Z)

                        -- ลอยไดโนที่อยู่ใกล้ (30 studs) พร้อมกัน
                        for _, dino in ipairs(Workspace:WaitForChild("Dinosaurs"):GetChildren()) do
                            if dino:IsA("Model") and dino:FindFirstChild("HumanoidRootPart") then
                                local dinoPos = dino.HumanoidRootPart.Position
                                if (dinoPos - rootPos).Magnitude <= 5 then
                                    dino.HumanoidRootPart.CFrame = CFrame.new(dinoPos.X, targetY, dinoPos.Z)
                                end
                            end
                        end
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

MainTab:Toggle({
    Title = "Auto Farm (Amber) (Fixing)",
    Value = false,
    Callback = function(state)
        amberToggle = state
        if state then
            task.spawn(function()
                while amberToggle do
                    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
                        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    end

                    local amberList = {}
                    for _, amber in ipairs(Workspace:WaitForChild("MiscellaneousStorage"):GetChildren()) do
                        if amber.Name == "Amber" and amber:IsA("Model") and amber.PrimaryPart then
                            table.insert(amberList, amber)
                        end
                    end

                    for _, amber in ipairs(amberList) do
                        local prompt = amber:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            -- Teleport to Amber PrimaryPart + offset
                            local targetPos = amber.PrimaryPart.Position + Vector3.new(0, 3, 0)
                            if Character and Character:FindFirstChild("HumanoidRootPart") then
                                Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                            end
                            task.wait(0.3)
                            fireproximityprompt(prompt)
                            task.wait(1) -- รอระยะก่อนไปต่อ
                        end
                    end

                    task.wait(2)
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
    Title = "ESP (Amber) (Fixing)",
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

                    task.wait(0.69)
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

                    task.wait(0.69)
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
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local speedValue = 10
local jumpPowerValue = 50
local speedConnection = nil

speedConnection = RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local hrp = character.HumanoidRootPart
        if humanoid.MoveDirection.Magnitude > 0 then
            local moveDir = humanoid.MoveDirection.Unit -- normalize
            hrp.CFrame = hrp.CFrame + moveDir * speedValue * (1/60)
        end
    end
end)

-- Slider สำหรับปรับความเร็ว
PlayerTab:Slider({
    Title = "WalkSpeed (CFrame Movement)",
    Default = speedValue,
    Min = 10,
    Max = 600,
    Callback = function(value)
        speedValue = value
    end,
})


PlayerTab:Slider({
    Title = "JumpPower",
    Default = jumpPowerValue,
    Min = 10,
    Max = 600,
    Callback = function(value)
        jumpPowerValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = jumpPowerValue
        end
    end,
})

local espOptions = {
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    ShowDino = true,
    HighlightColor = Color3.new(1, 1, 1),
    Rainbow = false,
}

PlayerTab:Toggle({
    Title = "ESP Show Name",
    Value = espOptions.ShowName,
    Callback = function(state) espOptions.ShowName = state end,
})
PlayerTab:Toggle({
    Title = "ESP Show Health",
    Value = espOptions.ShowHealth,
    Callback = function(state) espOptions.ShowHealth = state end,
})
PlayerTab:Toggle({
    Title = "ESP Show Distance",
    Value = espOptions.ShowDistance,
    Callback = function(state) espOptions.ShowDistance = state end,
})
PlayerTab:Toggle({
    Title = "ESP Show Dino Type",
    Value = espOptions.ShowDino,
    Callback = function(state) espOptions.ShowDino = state end,
})
PlayerTab:Toggle({
    Title = "ESP Rainbow Color",
    Value = espOptions.Rainbow,
    Callback = function(state) espOptions.Rainbow = state end,
})

local function createEspGui(target)
    if not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    local gui = head:FindFirstChild("DYESP")
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = "DYESP"
        gui.Size = UDim2.new(0, 200, 0, 100)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = true
        gui.Parent = head
    end
    return gui
end 

local function updateEspGui()
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Head") then
            local gui = createEspGui(target)
            if gui then
                -- Clear old labels
                for _, child in pairs(gui:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end

                local yOffset = 0
                local function addLabel(text)
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 0, 20)
                    label.Position = UDim2.new(0, 0, 0, yOffset)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = espOptions.Rainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or espOptions.HighlightColor
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Font = Enum.Font.SourceSansBold
                    label.Text = text
                    label.Parent = gui
                    yOffset += 20
                end

                if espOptions.ShowName then
                    addLabel(target.Name)
                end 
                if espOptions.ShowHealth then
                    local humanoid = target.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        addLabel("HP: " .. math.floor(humanoid.Health))
                    end
                end

                if espOptions.ShowDistance then
                    local hrpLocal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local hrpTarget = target.Character:FindFirstChild("HumanoidRootPart")
                    if hrpLocal and hrpTarget then
                        local dist = (hrpLocal.Position - hrpTarget.Position).Magnitude
                        addLabel("Dist: " .. math.floor(dist))
                    end
                end

                if espOptions.ShowDino then
                    local memCard = target:FindFirstChild("MemoryCard")
                    if memCard then
                        local currentDino = memCard:FindFirstChild("CurrentDino")
                        if currentDino and currentDino:IsA("StringValue") then
                            addLabel("Type: " .. currentDino.Value)
                        else
                            addLabel("Type: Unknown")
                        end
                    else
                        addLabel("Type: Unknown")
                    end
                end
            end
        else
            -- Remove ESP Gui if player doesn't have character or head
            if target.Character and target.Character:FindFirstChild("Head") then
                local head = target.Character.Head
                local gui = head:FindFirstChild("DYESP")
                if gui then
                    gui:Destroy()
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateEspGui()
end)


-- Misc Tab --

local antiAfkEnabled = false
MiscTab:Toggle({
    Title = "Bypass Anti-Cheat",
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

local antiAfkEnabled = false
MiscTab:Toggle({
    Title = "Anti Admin",
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
        speedValue = config.WalkSpeed or 10
        jumpPowerValue = config.JumpPower or 50
        selectedAmber = config.SelectedAmber
        selectedRegion = config.SelectedRegion

        -- Apply values to toggles/sliders
        MainTab:GetToggle("Auto Farm (DNA)").Value = dnaToggle
        MainTab:GetToggle("Auto Farm (Amber)").Value = amberToggle
        MainTab:GetToggle("Auto Eat Hunger").Value = autoHunger
        MainTab:GetToggle("Auto Eat Water").Value = autoWater
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
