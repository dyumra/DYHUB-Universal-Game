repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Confirm popup
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

-- Create Window and Tabs
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

-- Environment references
local GameEvents = Workspace:WaitForChild("GameEvents")
local Props = Workspace:WaitForChild("GameMap"):WaitForChild("Gameland"):WaitForChild("Props")
local Bushes = Props:WaitForChild("Bushes")
local WaterTiles = Workspace:WaitForChild("GameMap"):WaitForChild("Water"):GetChildren()

-- Variables
local dnaToggle = false
local amberToggle = false
local espToggle = false
local autoHunger = false
local autoWater = false
local antiAfkEnabled = false
local antiAdminEnabled = false

-- ESP options
local espOptions = {
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowDino = false,
    HighlightColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false,
}
local espObjects = {}
local espUpdateConnection = nil
local antiAdminConnection = nil

-- Utility functions --

-- Smooth move character to position in duration seconds
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

-- Create a grass platform below the player for DNA farming
local function createGrassPlatform()
    local existing = Workspace:FindFirstChild("DNA FARM | GrassPlatform")
    if existing then existing:Destroy() end

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

-- Fire proximity prompt safely
local function safeFireProximityPrompt(prompt)
    if prompt then
        pcall(function()
            fireproximityprompt(prompt)
        end)
    end
end

-- Create Amber ESP highlight and label
local function createEspAmber(amber)
    if espObjects[amber] then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 150, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Name = "AmberESP"
    highlight.Parent = amber

    local basePart = amber:FindFirstChildWhichIsA("BasePart")
    if not basePart then
        highlight:Destroy()
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AmberLabel"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = basePart
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

-- Remove Amber ESP
local function removeEspAmber(amber)
    if espObjects[amber] then
        for _, obj in pairs(espObjects[amber]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        espObjects[amber] = nil
    end
end

-- Update ESP for players
local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local gui = head:FindFirstChild("DYESP")
            if not gui then
                gui = Instance.new("BillboardGui")
                gui.Name = "DYESP"
                gui.Size = UDim2.new(0, 200, 0, 100)
                gui.StudsOffset = Vector3.new(0, 2.5, 0)
                gui.AlwaysOnTop = true
                gui.Parent = head
            end

            -- Clear old labels
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end

            local function addLine(text, yOffset)
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
            end

            local y = 0

            if espOptions.ShowName then
                addLine(target.Name, y)
                y += 20
            end

            local humanoid = target.Character:FindFirstChild("Humanoid")
            if espOptions.ShowHealth and humanoid then
                addLine("HP: " .. math.floor(humanoid.Health), y)
                y += 20
            end

            if espOptions.ShowDistance and Character and Character:FindFirstChild("HumanoidRootPart") then
                local dist = (Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                addLine("Dist: " .. math.floor(dist), y)
                y += 20
            end

            local memoryCard = target:FindFirstChild("MemoryCard")
            if espOptions.ShowDino and memoryCard and memoryCard:FindFirstChild("CurrentDino") and memoryCard.CurrentDino:IsA("StringValue") then
                addLine("Type: " .. memoryCard.CurrentDino.Value, y)
                y += 20
            end
        end
    end
end

local function clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local gui = player.Character.Head:FindFirstChild("DYESP")
            if gui then
                gui:Destroy()
            end
        end
    end
end

local function toggleESP(state)
    espToggle = state
    if espToggle then
        updateESP()
        espUpdateConnection = RunService.Heartbeat:Connect(updateESP)
    else
        clearESP()
        if espUpdateConnection then
            espUpdateConnection:Disconnect()
            espUpdateConnection = nil
        end
    end
end

-- Remove ESP GUI when player leaves
Players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local gui = player.Character.Head:FindFirstChild("DYESP")
        if gui then gui:Destroy() end
    end
end)

-- Main Tab --

MainTab:Toggle({
    Title = "Auto Farm (DNA)",
    Value = false,
    Callback = function(state)
        dnaToggle = state
        if state then
            createGrassPlatform()
            task.spawn(function()
                while dnaToggle do
                    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                        task.wait(1)
                        continue
                    end
                    local pos = Character.HumanoidRootPart.Position
                    local targetY = pos.Y + 444
                    smoothMoveTo(Vector3.new(pos.X, targetY, pos.Z), 5)
                    task.wait(1.69)
                end
                -- Cleanup platform when stopped
                local platform = Workspace:FindFirstChild("DNA FARM | GrassPlatform")
                if platform then
                    platform:Destroy()
                end
            end)
        else
            local platform = Workspace:FindFirstChild("DNA FARM | GrassPlatform")
            if platform then
                platform:Destroy()
            end
        end
    end,
})

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
                                safeFireProximityPrompt(prompt)
                                task.wait(0.69)
                            end
                        end
                    end
                    task.wait(1.69)
                end
            end)
        end
    end,
})

MainTab:Toggle({
    Title = "ESP (Amber)",
    Value = false,
    Callback = function(state)
        espToggle = state
        if state then
            task.spawn(function()
                while espToggle do
                    -- Create ESP for new ambers
                    for _, amber in ipairs(Workspace.MiscellaneousStorage:GetChildren()) do
                        if amber.Name == "Amber" and not espObjects[amber] then
                            createEspAmber(amber)
                        end
                    end

                    -- Remove ESP for destroyed ambers
                    for amber, _ in pairs(espObjects) do
                        if not amber or not amber.Parent then
                            removeEspAmber(amber)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            for amber, _ in pairs(espObjects) do
                removeEspAmber(amber)
            end
        end
    end,
})

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
                            local dist = (Character.HumanoidRootPart.Position - bush.Leaves.Position).Magnitude
                            if dist < closestDist then
                                closestBush = bush.Leaves
                                closestDist = dist
                            end
                        end
                    end

                    if closestBush then
                        GameEvents:WaitForChild("EatPlant"):FireServer(closestBush)
                    end

                    task.wait(1)
                end
            end)
        end
    end,
})

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
                            local dist = (Character.HumanoidRootPart.Position - tile.Water.Position).Magnitude
                            if dist < closestDist then
                                closestWater = tile.Water
                                closestDist = dist
                            end
                        end
                    end

                    if closestWater then
                        GameEvents:WaitForChild("addThirst"):FireServer(closestWater, closestWater.Position)
                    end

                    task.wait(1)
                end
            end)
        end
    end,
})

-- Teleport Tab --

-- Prepare amber list and names
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
            smoothMoveTo(target.PrimaryPart.Position + Vector3.new(0,3,0), 2)
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
            smoothMoveTo(pos + Vector3.new(0, 3, 0), 2)
        else
            warn("Region position not found!")
        end
    end,
})

-- Player Tab --

PlayerTab:Slider({
    Title = "Walkspeed",
    Value = 16,
    Min = 1,
    Max = 500,
    Callback = function(value)
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = value
        end
    end,
})

PlayerTab:Slider({
    Title = "JumpPower",
    Value = 50,
    Min = 10,
    Max = 500,
    Callback = function(value)
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.JumpPower = value
        end
    end,
})

PlayerTab:Toggle({
    Title = "Enable ESP",
    Value = false,
    Callback = toggleESP,
})

PlayerTab:Toggle({
    Title = "Show Name",
    Value = false,
    Callback = function(state)
        espOptions.ShowName = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Health",
    Value = false,
    Callback = function(state)
        espOptions.ShowHealth = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Distance",
    Value = false,
    Callback = function(state)
        espOptions.ShowDistance = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Type Dino",
    Value = false,
    Callback = function(state)
        espOptions.ShowDino = state
    end,
})

PlayerTab:Toggle({
    Title = "Rainbow ESP",
    Value = false,
    Callback = function(state)
        espOptions.Rainbow = state
    end,
})

-- Misc Tab --

MiscTab:Toggle({
    Title = "Anti AFK",
    Value = false,
    Callback = function(state)
        antiAfkEnabled = state
        if antiAfkEnabled then
            VirtualUser:Button2Down(Vector2.new(0,0))
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(15)
                end
            end)
        end
    end,
})

MiscTab:Toggle({
    Title = "Anti Admin",
    Value = false,
    Callback = function(state)
        antiAdminEnabled = state
        if antiAdminEnabled then
            if not antiAdminConnection then
                antiAdminConnection = Players.PlayerAdded:Connect(function(player)
                    if player.Name == "Yolmar_43" then
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end
                end)
            end
        else
            if antiAdminConnection then
                antiAdminConnection:Disconnect()
                antiAdminConnection = nil
            end
        end
    end,
})

-- Config Tab --
ConfigTab:Button({
    Title = "Save Config",
    Icon = "floppy-disk",
    Callback = function()
        print("Config saved (implement your own save logic)")
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Icon = "upload",
    Callback = function()
        print("Config loaded (implement your own load logic)")
    end,
})

-- Notify loaded
warn("[DYHUB] Dinosaur Simulator script loaded successfully!")

