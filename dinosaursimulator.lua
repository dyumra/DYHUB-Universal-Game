repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

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

-- Create Grass Platform (for AutoFarm DNA)
local function createGrassPlatform()
    if Workspace:FindFirstChild("DNA FARM | GrassPlatform") then
        Workspace["DNA FARM | GrassPlatform"]:Destroy()
    end
    local part = Instance.new("Part", Workspace)
    part.Name = "DNA FARM | GrassPlatform"
    part.Anchored = true
    part.CanCollide = true
    part.Size = Vector3.new(100, 1, 100)
    part.Position = Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
    part.Material = Enum.Material.Grass
    part.Color = Color3.fromRGB(106, 190, 48)
end

-- Smooth Move Function
local function smoothMoveTo(position, duration)
    local startPos = Character.HumanoidRootPart.Position
    local startTime = tick()
    local endTime = startTime + duration
    while tick() < endTime do
        local alpha = (tick() - startTime) / duration
        local newPos = startPos:Lerp(position, alpha)
        Character:PivotTo(CFrame.new(newPos))
        RunService.RenderStepped:Wait()
    end
end

-- Main Tab: Auto Farm DNA
local dnaToggle = false
MainTab:Toggle({
    Title = "Auto Farm (DNA)",
    Value = false,
    Callback = function(state)
        dnaToggle = state
        if state then
            createGrassPlatform()
            task.spawn(function()
                while dnaToggle do
                    local pos = Character.HumanoidRootPart.Position
                    local targetY = pos.Y + 444
                    smoothMoveTo(Vector3.new(pos.X, targetY, pos.Z), 5)
                    task.wait(5)
                end
            end)
        end
    end,
})

-- Main Tab: Auto Farm Amber
local amberToggle = false
MainTab:Toggle({
    Title = "Auto Farm (Amber)",
    Value = false,
    Callback = function(state)
        amberToggle = state
        if state then
            task.spawn(function()
                while amberToggle do
                    for _, amber in ipairs(Workspace.MiscellaneousStorage:GetChildren()) do
                        if amber.Name == "Amber" and amber:IsA("Model") and amber:FindFirstChildOfClass("ProximityPrompt") then
                            local prompt = amber:FindFirstChildOfClass("ProximityPrompt")
                            if prompt and amber.PrimaryPart then
                                local pos = amber:GetPivot().Position
                                smoothMoveTo(pos + Vector3.new(0, 3, 0), 3)
                                task.wait(0.5)
                                fireproximityprompt(prompt)
                                task.wait(1)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

-- Main Tab: Amber ESP
local espToggle = false
local espObjects = {}

local function createEspAmber(amber)
    if not amber.PrimaryPart then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 150, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Name = "AmberESP"
    highlight.Parent = amber

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AmberLabel"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = amber.PrimaryPart
    billboard.AlwaysOnTop = true
    billboard.Parent = amber

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Amber"
    text.TextColor3 = Color3.fromRGB(255, 150, 0)
    text.TextScaled = true
    text.Parent = billboard

    espObjects[amber] = {highlight, billboard}
end

local function removeEspAmber(amber)
    if espObjects[amber] then
        for _, obj in pairs(espObjects[amber]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        espObjects[amber] = nil
    end
end

MainTab:Toggle({
    Title = "Esp (Amber)",
    Value = false,
    Callback = function(state)
        espToggle = state
        if state then
            task.spawn(function()
                while espToggle do
                    for _, amber in ipairs(Workspace.MiscellaneousStorage:GetChildren()) do
                        if amber.Name == "Amber" and not espObjects[amber] then
                            createEspAmber(amber)
                        end
                    end

                    -- Clean up disappeared ambers
                    for amber in pairs(espObjects) do
                        if not amber or not amber.Parent then
                            removeEspAmber(amber)
                        end
                    end
                    task.wait(2)
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

-- Amber Dropdown setup
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

-- Region Centers
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
local walkSpeedChanged = false

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

PlayerTab:Button({
    Title = "Reset Character",
    Icon = "refresh",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
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
            VirtualUser:Button2Down(Vector2.new(0,0))
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(10)
                end
            end)
        end
    end,
})

-- ESP for Players (Name, HP, Distance, Dino Type)
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

-- Config Tab: Save & Load Config (example - needs implementation)
ConfigTab:Button({
    Title = "Save Config",
    Icon = "save",
    Callback = function()
        -- Implement config save here
        print("Save Config clicked")
    end,
})
ConfigTab:Button({
    Title = "Load Config",
    Icon = "load",
    Callback = function()
        -- Implement config load here
        print("Load Config clicked")
    end,
})

-- Notify Player Loaded
game.StarterGui:SetCore("SendNotification", {
    Title = "DYHUB",
    Text = "Dinosaur Simulator Script Loaded!",
    Duration = 5,
})

print("DYHUB | Dinosaur Simulator Script Loaded!")
