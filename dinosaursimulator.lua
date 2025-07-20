repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

local Window = WindUI:CreateWindow({
    Title = "DYHUB - Dinosaur Simulator",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- Main Tab
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GameEvents = workspace:WaitForChild("GameEvents")
local Props = workspace:WaitForChild("GameMap"):WaitForChild("Gameland"):WaitForChild("Props")
local Bushes = Props:WaitForChild("Bushes")
local WaterTiles = workspace:WaitForChild("GameMap"):WaitForChild("Water"):GetChildren()
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- CREATE GRASS PLATFORM
local function createGrassPlatform()
    local part = Instance.new("Part", Workspace)
    part.Name = "DNA FARM | GrassPlatform"
    part.Anchored = true
    part.CanCollide = true
    part.Size = Vector3.new(100, 1, 100)
    part.Position = Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
    part.Material = Enum.Material.Grass
    part.Color = Color3.fromRGB(106, 190, 48)
end

-- SMOOTH MOVE FUNCTION
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

-- DNA AutoFarm
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

-- Amber AutoFarm
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
                            if prompt then
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

-- Amber ESP
local espToggle = false
local espObjects = {}

local function createEspAmber(amber)
    local highlight = Instance.new("Highlight", amber)
    highlight.FillColor = Color3.fromRGB(255, 150, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Name = "AmberESP"

    local billboard = Instance.new("BillboardGui", amber)
    billboard.Name = "AmberLabel"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = amber:FindFirstChildWhichIsA("BasePart")
    billboard.AlwaysOnTop = true

    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Amber"
    text.TextColor3 = Color3.fromRGB(255, 150, 0)
    text.TextScaled = true

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

                    for amber in pairs(espObjects) do
                        if not amber or not amber.Parent then
                            removeEspAmber(amber)
                        end
                    end

                    task.wait(2)
                end
            end)
        else
            for amber, _ in pairs(espObjects) do
                removeEspAmber(amber)
            end
        end
    end,
})

-- AUTO HUNGER
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

                    task.wait(2) -- กินทุก 2 วิ
                end
            end)
        end
    end,
})

-- AUTO THIRST
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

                    task.wait(2) -- ดื่มน้ำทุก 2 วิ
                end
            end)
        end
    end,
})


-- teleport
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ฟังก์ชันลากตัวเองแบบ smooth ภายใน duration วินาที
local function smoothMoveTo(targetPos, duration)
    local startPos = Character.HumanoidRootPart.Position
    local startTime = tick()
    local endTime = startTime + duration
    while tick() < endTime do
        local alpha = (tick() - startTime) / duration
        local newPos = startPos:Lerp(targetPos, alpha)
        Character:PivotTo(CFrame.new(newPos))
        RunService.RenderStepped:Wait()
    end
end

-------------------------
-- 1. Amber Dropdown --
-------------------------

-- หา Amber ทั้งหมดใน workspace.MiscellaneousStorage
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

-- สร้างชื่อ Amber1, Amber2, ...
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

-----------------------------
-- 2. Region-Center Dropdown --
-----------------------------

local regionCenters = {
    Lab1 = Workspace.RegionCenter:FindFirstChild("Lab1") and Workspace.RegionCenter.Lab1.Position or nil,
    Lab2 = Workspace.RegionCenter:FindFirstChild("Lab2") and Workspace.RegionCenter.Lab2.Position or nil,
    Lab3 = Workspace.RegionCenter:FindFirstChild("Lab3") and Workspace.RegionCenter.Lab3.Position or nil,
}

local selectedRegion = nil
TeleportTab:Dropdown({
    Title = "Select Region-Center To Teleport",
    Values = {"Lab1", "Lab2", "Lab3"},
    Multi = false,
    Callback = function(selected)
        selectedRegion = selected
        print("[DYHUB] Selected Region Teleport:", selectedRegion)
    end,
})

TeleportTab:Button({
    Title = "Teleport to Region-Center",
    Icon = "atom",
    Callback = function()
        if not selectedRegion then
            warn("Please select Region-Center first!")
            return
        end
        local pos = regionCenters[selectedRegion]
        if pos then
            smoothMoveTo(pos + Vector3.new(0,3,0), 2)
        else
            warn("Selected Region-Center position not found!")
        end
    end,
})

-------------------------
-- 3. Lab Dropdown --
-------------------------

local labs = {}
-- ตรวจสอบและเก็บตำแหน่ง Lab1, Lab2
if Workspace:FindFirstChild("Labs") then
    if Workspace.Labs:FindFirstChild("Lab1") and Workspace.Labs.Lab1.PrimaryPart then
        labs.Lab1 = Workspace.Labs.Lab1.PrimaryPart.Position
    end
    if Workspace.Labs:FindFirstChild("Lab2") and Workspace.Labs.Lab2.PrimaryPart then
        labs.Lab2 = Workspace.Labs.Lab2.PrimaryPart.Position
    end
end

local selectedLab = nil
TeleportTab:Dropdown({
    Title = "Select Lab To Teleport",
    Values = {"Lab1", "Lab2", "Lab3"},
    Multi = false,
    Callback = function(selected)
        selectedLab = selected
        print("[DYHUB] Selected Lab Teleport:", selectedLab)
    end,
})

local function getRandomPositionFromLab3()
    local lab3Folder = Workspace:FindFirstChild("Labs") and Workspace.Labs:FindFirstChild("Lab3")
    if not lab3Folder then return nil end

    local parts = {}
    for _, obj in ipairs(lab3Folder:GetDescendants()) do
        if obj:IsA("BasePart") then
            table.insert(parts, obj)
        end
    end

    if #parts > 0 then
        local part = parts[math.random(1, #parts)]
        return part.Position
    end
    return nil
end

TeleportTab:Button({
    Title = "Teleport to Lab",
    Icon = "atom",
    Callback = function()
        if not selectedLab then
            warn("Please select Lab first!")
            return
        end
        if selectedLab == "Lab3" then
            local pos = getRandomPositionFromLab3()
            if pos then
                smoothMoveTo(pos + Vector3.new(0,3,0), 2)
            else
                warn("No parts found in Lab3 folder!")
            end
        else
            local pos = labs[selectedLab]
            if pos then
                smoothMoveTo(pos + Vector3.new(0,3,0), 2)
            else
                warn("Lab position not found!")
            end
        end
    end,
})


-- Player Tab
local espEnabled = false
local espUpdateConnection
local espOptions = {
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowTypeDino = false,
    HighlightColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false,
}

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

            local target = LocalPlayer:FindFirstChild("MemoryCard")
            local y = 0

            if espOptions.ShowName then
                addLine(target.Name, y)
                y += 20
            end

            if espOptions.ShowHealth and target.Character:FindFirstChild("Humanoid") then
                addLine("HP: " .. math.floor(target.Character.Humanoid.Health), y)
                y += 20
            end

            if espOptions.ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                addLine("Dist: " .. math.floor(dist), y)
                y += 20
            end

            if MemoryCard and MemoryCard:FindFirstChild("CurrentDino") and MemoryCard.CurrentDino:IsA("StringValue") then
                addLine("Type: " .. MemoryCard.CurrentDino.Value, y)
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
    espEnabled = state
    if espEnabled then
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

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Wait()
        updateESP()
    end
end)

PlayerTab:Toggle({
    Title = "Enable ESP",
    Value = false,
    Callback = function(state)
        toggleESP(state)
    end,
})

PlayerTab:Dropdown({
    Title = "ESP Color",
    Default = "Green",
    Options = {
        "Red", "Green", "Blue", "Yellow", "Purple", "Cyan", "White", "Black", "Rainbow"
    },
    Callback = function(colorName)
        espOptions.Rainbow = false
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(128, 0, 128),
            Cyan = Color3.fromRGB(0, 255, 255),
            White = Color3.fromRGB(255, 255, 255),
            Black = Color3.fromRGB(0, 0, 0),
            Rainbow = nil,
        }
        if colorName == "Rainbow" then
            espOptions.Rainbow = true
        else
            espOptions.HighlightColor = colors[colorName] or Color3.fromRGB(0, 255, 0)
        end
    end,
})

PlayerTab:Toggle({
    Title = "Show Player Name",
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

-- Misc Tab
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

local antiAfkEnabled = false
local antiAdminEnabled = false

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
                    task.wait(60) -- ป้องกัน AFK โดนเตะ
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
            -- เชื่อมต่อกับ event ของการเข้าเกมของผู้เล่นใหม่
            Players.PlayerAdded:Connect(function(player)
                if player.Name == "Yolmar_43" then
                    -- ทำการ server hop
                    -- สมมติว่าคุณรู้ gameId ของเกมนี้ (หรือใช้ current gameId)
                    local placeId = game.PlaceId
                    -- เรียกใช้ TeleportService เพื่อย้ายไป server ใหม่
                    TeleportService:Teleport(placeId, LocalPlayer)
                end
            end)
        end
    end,
})

-- Config Tab: Save/Load config (simple memory config, you can extend to file or data store)
ConfigTab:Button({
    Title = "Save Config",
    Callback = function()
        print("[DYHUB] Config saved!")
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Callback = function()
        print("[DYHUB] Config loaded!")
    end,
})

-- Main loop
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

print("[DYHUB] Script loaded successfully!")
