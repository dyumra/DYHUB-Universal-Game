-- =========================
local version = "1.0.7" -- อัพเดท
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
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

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local TP = Window:Tab({ Title = "Teleport", Icon = "zap" })
local Shop = Window:Tab({ Title = "Collect", Icon = "gift" })
Window:SelectTab(1)

-- ====================== CHEST SYSTEM ======================

Shop:Section({ Title = "Chest System", Icon = "package" })

local selectedNormal = {}
local selectedGiant = {}
local selectedHuge = {}

Shop:Dropdown({
    Title = "Select Chest (Normal)",
    Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"},
    Multi = true,
    Callback = function(values) selectedNormal = values end
})

Shop:Dropdown({
    Title = "Select Chest (Giant)",
    Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"},
    Multi = true,
    Callback = function(values) selectedGiant = values end
})

Shop:Dropdown({
    Title = "Select Chest (Huge)",
    Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"},
    Multi = true,
    Callback = function(values) selectedHuge = values end
})

local function collectChest(chest)
    if chest and chest:FindFirstChild("ProximityPrompt") then
        -- วาร์ปไปเหนือ chest นิดหน่อย
        LocalPlayer.Character:PivotTo(chest:GetPivot() + Vector3.new(0, 3, 0))
        task.wait(0.4)
        -- กด ProximityPrompt
        fireproximityprompt(chest.ProximityPrompt, 1)
        task.wait(1) -- รอ 1 วิ ค่อยไป chest ต่อไป
    end
end

Shop:Toggle({
    Title = "Auto Collect (Selected Chests)",
    Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                for _, v in ipairs(selectedNormal) do
                    local chest = Workspace.ChestFolder:FindFirstChild(v)
                    if chest then collectChest(chest) end
                end
                for _, v in ipairs(selectedGiant) do
                    local chest = Workspace.ChestFolder:FindFirstChild(v.."_Giant")
                    if chest then collectChest(chest) end
                end
                for _, v in ipairs(selectedHuge) do
                    local chest = Workspace.ChestFolder:FindFirstChild(v.."_Huge")
                    if chest then collectChest(chest) end
                end
                task.wait(0.5)
            end
        end)
    end
})

-- ====================== GAME SYSTEM ======================
Main:Section({ Title = "Game System", Icon = "gamepad-2" })

local autoPlay = false
Main:Toggle({
    Title = "Auto Play",
    Default = false,
    Callback = function(state)
        autoPlay = state
        task.spawn(function()
            while autoPlay do
                local args = { "play" }
                game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Game"):FireServer(unpack(args))
                task.wait(1) -- หน่วง 1 วิ (ปรับได้)
            end
        end)
    end
})

-- ====================== TREE SYSTEM ======================

Main:Section({ Title = "Tree", Icon = "tree" })

local autoTreeAura = false
local auraRange = 30

Main:Slider({
    Title = "Auto Cut Trees Delay (sec)",
    Description = "Set delay time between Cut Trees",
    Value = {Min = 5, Max = 100, Default = auraRange},
    Step = 1,
    Callback = function(val)
        CutTreesDelay = val
    end
})

-- Auto Cut Trees (Aura)
Main:Toggle({
    Title = "Auto Cut Trees (Aura)",
    Default = false,
    Callback = function(state)
        autoTreeAura = state
        task.spawn(function()
            while autoTreeAura do
                local character = LocalPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, tree in ipairs(workspace:WaitForChild("TreesFolder"):GetChildren()) do
                        if tree:IsA("Model") and tree:FindFirstChild("PrimaryPart") then
                            local distance = (root.Position - tree.PrimaryPart.Position).Magnitude
                            if distance <= CutTreesDelay then
                                local args = {
                                    "damage",
                                    tree.Name
                                }
                                ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Tree"):FireServer(unpack(args))
                                task.wait(0.01) -- ความเร็ว 0.01
                            end
                        end
                    end
                end
                task.wait(0.01) -- ความเร็ว 0.01
            end
        end)
    end
})

-- Auto Cut Trees (All)
local autoTreeAll = false
Main:Toggle({
    Title = "Auto Cut Trees (All)",
    Default = false,
    Callback = function(state)
        autoTreeAll = state
        task.spawn(function()
            while autoTreeAll do
                for _, tree in ipairs(workspace:WaitForChild("TreesFolder"):GetChildren()) do
                    if tree:IsA("Model") then
                        local args = {
                            "damage",
                            tree.Name
                        }
                        ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Tree"):FireServer(unpack(args))
                        task.wait(0.01)
                    end
                end
                task.wait(0.01)
          end
        end)
    end
})

Main:Section({ Title = "Chest (All)", Icon = "archive" })
Main:Toggle({
    Title = "Auto Collect All Chests",
    Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                for _, chest in ipairs(Workspace.ChestFolder:GetChildren()) do
                    collectChest(chest)
                end
                task.wait(0.5)
            end
        end)
    end
})

-- ====================== WORLD TELEPORT ======================

TP:Section({ Title = "World Teleport", Icon = "map" })

TP:Button({
    Title = "Teleport to World 1",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(-115, 3.5, -120))
    end
})

TP:Button({
    Title = "Teleport to World 2",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(-1000, 3.5, -125))
    end
})
