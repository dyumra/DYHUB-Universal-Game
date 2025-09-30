-- =========================
local version = "1.3.7" -- UPDATE
-- =========================

repeat task.wait() until game:IsLoaded()

if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== SERVICES ======================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Cut Trees | Premium Version",
    Folder = "DYHUB_CT",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    Window:Tag({
        Title = version,
        Color = Color3.fromHex("#30ff6a")
    })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- ====================== TABS ======================
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local TP = Window:Tab({ Title = "Teleport", Icon = "zap" })
local Shop = Window:Tab({ Title = "Collect", Icon = "gift" })
local Auto = Window:Tab({ Title = "Open", Icon = "gem" })
local Misc = Window:Tab({ Title = "Misc", Icon = "settings" })
Window:SelectTab(1)

-- ====================== CHEST SYSTEM ======================
Shop:Section({ Title = "Chest System", Icon = "package" })
local selectedNormal, selectedGiant, selectedHuge = {}, {}, {}
local AutoCollectSelected = false
local AutoCollectAll = false

local function formatName(name)
    return string.gsub(name, "%s+", "")
end

local function findChest(name)
    local cleanName = formatName(name)
    for _, chest in ipairs(Workspace.ChestFolder:GetChildren()) do
        if formatName(chest.Name) == cleanName then
            return chest
        end
    end
    return nil
end

local function collectChest(chest)
    if chest then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local pivot = chest.PrimaryPart and chest.PrimaryPart.CFrame or chest:GetPivot()
            root.CFrame = pivot + Vector3.new(0,3,0)
            task.wait(0.15)
            local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then fireproximityprompt(prompt,1) end
        end
    end
end

-- Dropdown สำหรับ Select Chest
Shop:Dropdown({ Title = "Select Chest (Normal)", Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"}, Multi = true, Callback = function(values) selectedNormal = values end })
Shop:Dropdown({ Title = "Select Chest (Giant)", Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"}, Multi = true, Callback = function(values) selectedGiant = values end })
Shop:Dropdown({ Title = "Select Chest (Huge)", Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"}, Multi = true, Callback = function(values) selectedHuge = values end })

-- Toggle Selected Chests
Shop:Toggle({
    Title = "Auto Collect Selected Chests",
    Description = "Automatically teleport and collect selected chests",
    Default = false,
    Callback = function(state)
        AutoCollectSelected = state
        task.spawn(function()
            while AutoCollectSelected do
                for _, v in ipairs(selectedNormal) do if not AutoCollectSelected then break end collectChest(findChest(v)) end
                for _, v in ipairs(selectedGiant) do if not AutoCollectSelected then break end collectChest(findChest(v.."_Giant")) end
                for _, v in ipairs(selectedHuge) do if not AutoCollectSelected then break end collectChest(findChest(v.."_Huge")) end
                task.wait(0.3)
            end
        end)
    end
})

-- Toggle All Chests
Shop:Toggle({
    Title = "Auto Collect All Chests",
    Description = "Automatically teleport and collect every chest in the map",
    Default = false,
    Callback = function(state)
        AutoCollectAll = state
        task.spawn(function()
            while AutoCollectAll do
                for _, chest in ipairs(Workspace.ChestFolder:GetChildren()) do
                    if not AutoCollectAll then break end collectChest(chest)
                end
                task.wait(0.3)
            end
        end)
    end
})

-- ====================== GAME SYSTEM ======================
Main:Section({ Title = "Game System", Icon = "gamepad-2" })
local autoPlay = false
Main:Toggle({
    Title = "Auto Play",
    Description = "Automatically play the game continuously",
    Default = false,
    Callback = function(state)
        autoPlay = state
        task.spawn(function()
            while autoPlay do
                ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Game"):FireServer("play")
                task.wait(0.8)
            end
        end)
    end
})

-- ====================== TREE SYSTEM ======================
Main:Section({ Title = "Tree System", Icon = "tree-deciduous" })
local autoTreeAura = false
local auraRange = 25
Main:Slider({ Title = "Auto Cut Trees (Aura)", Description = "Automatically damage trees around your character", Value = {Min = 5, Max = 100, Default = auraRange}, Step = 1, Callback = function(val) auraRange = val end })
Main:Toggle({ Title = "Auto Cut Trees (Aura)", Description = "Automatically cut trees within aura range", Default = false, Callback = function(state)
    autoTreeAura = state
    task.spawn(function()
        while autoTreeAura do
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, tree in ipairs(Workspace:WaitForChild("TreesFolder"):GetChildren()) do
                    if tree:IsA("Model") and tree.PrimaryPart then
                        local distance = (root.Position - tree.PrimaryPart.Position).Magnitude
                        if distance <= auraRange then
                            ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Tree"):FireServer("damage", tree.Name)
                            task.wait(0.01)
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end})
local autoTreeAll = false
Main:Toggle({ Title = "Auto Cut Trees (All)", Description = "Automatically cut all trees in the map", Default = false, Callback = function(state)
    autoTreeAll = state
    task.spawn(function()
        while autoTreeAll do
            for _, tree in ipairs(Workspace:WaitForChild("TreesFolder"):GetChildren()) do
                if tree:IsA("Model") then
                    ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Tree"):FireServer("damage", tree.Name)
                    task.wait(0.01)
                end
            end
            task.wait(0.01)
        end
    end)
end})

-- ====================== WORLD TELEPORT ======================
TP:Section({ Title = "World Teleport", Icon = "map" })
TP:Button({ Title = "Teleport to World 1", Description = "Instantly teleport to World 1", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(-115, 3.5, -120)) end })
TP:Button({ Title = "Teleport to World 2", Description = "Instantly teleport to World 2", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(-1000, 3.5, -125)) end })

-- ====================== MISC TAB ======================
Misc:Section({ Title = "Misc", Icon = "settings" })
local AntiAFK = false
Misc:Toggle({ Title = "Anti-AFK", Description = "Prevents you from being kicked for idle", Default = false, Callback = function(state)
    AntiAFK = state
    task.spawn(function()
        local vu = game:GetService("VirtualUser")
        while AntiAFK do
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(60)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(60)
        end
    end)
end})

-- ====================== AUTO TAB ======================
Auto:Section({ Title = "Auto Open Chests", Icon = "package" })

local AutoOpenChests = false
local OpenChestType = {"Normal"} -- Normal / Giant / Huge
local OpenChestLevel = {1,2,3,4,5,6,7,8,9} -- Levels

-- Dropdown เลือก Type
Auto:Dropdown({
    Title = "Select Chest Type",
    Description = "Choose chest type to auto open",
    Values = {"Normal","Giant","Huge"},
    Multi = true,
    Callback = function(values)
        OpenChestType = values
    end
})

-- Dropdown เลือก Level
Auto:Dropdown({
    Title = "Select Chest Level",
    Description = "Choose chest level to auto open",
    Values = {"1","2","3","4","5","6","7","8","9"},
    Multi = true,
    Callback = function(values)
        OpenChestLevel = {}
        for _, v in ipairs(values) do
            table.insert(OpenChestLevel, tonumber(v))
        end
    end
})

-- Toggle Auto Open
Auto:Toggle({
    Title = "Auto Open Selected Chests",
    Description = "Automatically open selected chest types and levels",
    Default = false,
    Callback = function(state)
        AutoOpenChests = state
        task.spawn(function()
            while AutoOpenChests do
                local chestList = {}
                for _, t in ipairs(OpenChestType) do
                    for _, l in ipairs(OpenChestLevel) do
                        if t == "Normal" then table.insert(chestList, "Chest"..l)
                        elseif t == "Giant" then table.insert(chestList, "Chest"..l.."_Giant")
                        elseif t == "Huge" then table.insert(chestList, "Chest"..l.."_Huge") end
                    end
                end

                for _, chestName in ipairs(chestList) do
                    if not AutoOpenChests then break end
                    local args = {"Open", chestName}
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Signal"):WaitForChild("ChestFunction"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.2)
                end
                task.wait(0.5)
            end
        end)
    end
})
