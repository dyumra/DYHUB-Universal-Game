local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Window = WindUI:CreateWindow({
    Folder = "DYHUB Config | 99-N-I-T-F",
    Title = "DYHUB | 99 Nights in the Forest",
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "rocket" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Esp = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Bring = Window:Tab({ Title = "Bring Items", Icon = "package" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "tool" }),
}


local infHungerActive = false
local infHungerThread

Tabs.Main:Toggle({
    Title = "Inf Hunger (Fixed)",
    Default = false,
    Callback = function(state)
        infHungerActive = state
        if state then
            infHungerThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RequestConsumeItem = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
                while infHungerActive do
                    local args = {
                        Instance.new("Model", nil)
                    }
                    RequestConsumeItem:InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        else
            infHungerActive = false
        end
    end
})

Tabs.Main:Button({Title="Auto Cook (Meat)", Callback=function()
    local campfirePos = Vector3.new(1.87, 4.33, -3.67)
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            local name = item.Name:lower()
            if name:find("meat") then
                local part = item:FindFirstChildWhichIsA("BasePart") or item
                if part then
                    part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2)))
                end
            end
        end
    end
end})

local autoTreeFarmActive = false
local autoTreeFarmThread

Tabs.Main:Toggle({
    Title = "Auto Tree Farm",
    Default = false,
    Callback = function(state)
        autoTreeFarmActive = state
        if state then
            autoTreeFarmThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local ToolDamageObject = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local Backpack = LocalPlayer:WaitForChild("Backpack")

                local function getAllTrees()
                    local map = workspace:FindFirstChild("Map")
                    if not map then return {} end
                    local landmarks = map:FindFirstChild("Landmarks") or map:FindFirstChild("Foliage")
                    if not landmarks then return {} end
                    local trees = {}
                    for _, tree in ipairs(landmarks:GetChildren()) do
                        if tree.Name == "Small Tree" and tree:IsA("Model") and tree.Parent then
                            local trunk = tree:FindFirstChild("Trunk") or tree.PrimaryPart
                            if trunk then
                                table.insert(trees, {tree = tree, trunk = trunk})
                            end
                        end
                    end
                    return trees
                end

                local function getAxe()
                    local inv = LocalPlayer:FindFirstChild("Inventory")
                    if not inv then return nil end
                    return inv:FindFirstChild("Old Axe") or inv:FindFirstChildWhichIsA("Tool")
                end

                while autoTreeFarmActive do
                    local trees = getAllTrees()
                    for _, t in ipairs(trees) do
                        if not autoTreeFarmActive then break end
                        if t.tree and t.tree.Parent then
                            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local hrp = char:FindFirstChild("HumanoidRootPart", 3)
                            if hrp and t.trunk then
                                local treeCFrame = t.trunk.CFrame
                                local rightVector = treeCFrame.RightVector
                                local targetPosition = treeCFrame.Position + rightVector * 3
                                hrp.CFrame = CFrame.new(targetPosition)
                                task.wait(0.25)
                                local axe = getAxe()
                                if axe then
                                    if axe.Parent == Backpack then
                                        axe.Parent = char
                                        task.wait(0.15)
                                    end
                                    while t.tree.Parent and autoTreeFarmActive do
                                        pcall(function() axe:Activate() end)
                                        local args = {
                                            t.tree,
                                            axe,
                                            "1_8264699301",
                                            t.trunk.CFrame
                                        }
                                        pcall(function() ToolDamageObject:InvokeServer(unpack(args)) end)
                                        task.wait(1)
                                    end
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                    task.wait(1)
                end
            end)
        else
            autoTreeFarmActive = false
        end
    end
})

local IYMouse = Players.LocalPlayer:GetMouse()
local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1
local flyKeyDown
local flyKeyUp
local velocityHandlerName = "BodyVelocity"
local gyroHandlerName = "BodyGyro"
local mfly1
local mfly2

Tabs.Player:Slider({
    Title = "Set Base Speed Fly",
    Min = 5,
    Max = 250,
    Default = 15,
    Callback = function(val)
        iyflyspeed = val
    end
})

Tabs.Player:Toggle({
    Title = "Enabled Fly",
    Default = false,
    Callback = function(state)
        if state then
            sFLY(false)
        else
            NOFLY()
        end
    end
})

local autoBreakActive = false
local autoBreakSpeed = 1
local autoBreakThread

Tabs.Main:Slider({
    Title = "Auto Hit Speed",
    Min = 0.1,
    Max = 2,
    Default = 1,
    Callback = function(val)
        autoBreakSpeed = val
    end
})

Tabs.Main:Toggle({
    Title = "Auto Hit (Auto Break)",
    Default = false,
    Callback = function(state)
        autoBreakActive = state
        if state then
            autoBreakThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local camera = workspace.CurrentCamera
                while autoBreakActive do
                    local function getWeapon()
                        local inv = player:FindFirstChild("Inventory")
                        return inv and (inv:FindFirstChild("Spear")
                            or inv:FindFirstChild("Strong Axe")
                            or inv:FindFirstChild("Good Axe")
                            or inv:FindFirstChild("Old Axe"))
                    end
                    local weapon = getWeapon()
                    if weapon then
                        local ray = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 15)
                        if ray and ray.Instance and ray.Instance.Name == "Trunk" then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
                                ray.Instance.Parent, weapon, "4_7591937906", CFrame.new(ray.Position)
                            )
                        end
                    end
                    task.wait(autoBreakSpeed)
                end
            end)
        else
            autoBreakActive = false
        end
    end
})

-- ========= Esp Tab
local ActiveEspItems = false
local ActiveEspEnemy = false
local ActiveEspChildren = false
local ActiveEspPeltTrader = false
local ActiveDistanceEsp = false

Tabs.Esp:Toggle({
    Title = "Esp (Items)",
    Default = false,
    Callback = function(state)
        ActiveEspItems = state
        task.spawn(function()
            while ActiveEspItems do
                task.spawn(function()
                    for _, Obj in pairs(Game.Workspace.Items:GetChildren()) do
                        if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(Obj, Color3.fromRGB(255, 255, 0), Obj.Name, Obj.PrimaryPart)
                        end
                    end
                end)
                task.wait(0.1)
            end
            task.spawn(function()
                for _, Obj in pairs(Game.Workspace.Items:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        KeepEsp(Obj, Obj.PrimaryPart)
                    end
                end
            end)
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Enemies)",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                task.spawn(function()
                    for _, Obj in pairs(Game.Workspace.Characters:GetChildren()) do
                        if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(Obj, Color3.fromRGB(255, 0, 0), Obj.Name, Obj.PrimaryPart)
                        end
                    end
                end)
                task.wait(0.1)
            end
            task.spawn(function()
                for _, Obj in pairs(Game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        KeepEsp(Obj, Obj.PrimaryPart)
                    end
                end
            end)
        end)
    end
})

local espTypes = {
    ["Fuel All"] = {
        color = Color3.fromRGB(255, 140, 0),
        items = { "Log", "Fuel Canister", "Coal", "Oil Barrel" }
    },
    ["Scraps All"] = {
        color = Color3.fromRGB(169, 169, 169),
        items = { "Sheet Metal", "Broken Fan", "UFO Junk", "Bolt", "Old Radio", "UFO Scrap", "Broken Microwave" }
    },
    ["Ammo All"] = {
        color = Color3.fromRGB(0, 255, 0),
        items = { "Rifle Ammo", "Revolver Ammo" }
    },
    ["Guns All"] = {
        color = Color3.fromRGB(255, 0, 0),
        items = { "Rifle", "Revolver" }
    },
    ["Food All"] = {
        color = Color3.fromRGB(255, 255, 0),
        items = { "Meat? Sandwich", "Cake", "Carrot", "Morsel" }
    },
    ["body All"] = {
        color = Color3.fromRGB(255, 255, 255),
        items = { "Leather Body", "Iron Body" }
    },
    ["Bandage"] = {
        color = Color3.fromRGB(255, 192, 203),
        items = { "Bandage" }
    },
    ["Medkit"] = {
        color = Color3.fromRGB(255, 0, 255),
        items = { "MedKit" }
    },
    ["Coin"] = {
        color = Color3.fromRGB(255, 215, 0),
        items = { "Coin Stack" }
    },
    ["Radio"] = {
        color = Color3.fromRGB(135, 206, 235),
        items = { "Old Radio" }
    },
    ["tyre"] = {
        color = Color3.fromRGB(105, 105, 105),
        items = { "Tyre" }
    },
    ["broken fan"] = {
        color = Color3.fromRGB(112, 128, 144),
        items = { "Broken Fan" }
    },
    ["broken microwave"] = {
        color = Color3.fromRGB(47, 79, 79),
        items = { "Broken Microwave" }
    },
    ["bolt"] = {
        color = Color3.fromRGB(0, 191, 255),
        items = { "Bolt" }
    },
    ["Sheet Metal"] = {
        color = Color3.fromRGB(192, 192, 192),
        items = { "Sheet Metal" }
    },
    ["SeedBox"] = {
        color = Color3.fromRGB(124, 252, 0),
        items = { "Seed Box" }
    },
    ["Chair"] = {
        color = Color3.fromRGB(210, 180, 140),
        items = { "Chair" }
    },
}

for category, data in pairs(espTypes) do
    Tabs.Esp:Toggle({
        Title = "ESP (" .. category .. ")",
        Default = false,
        Callback = function(state)
            local active = state
            task.spawn(function()
                while active do
                    for _, obj in pairs(game.Workspace.Items:GetChildren()) do
                        if obj:IsA("Model") and obj.PrimaryPart and not obj:FindFirstChildOfClass("Highlight")
                            and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            for _, itemName in pairs(data.items) do
                                if string.lower(obj.Name) == string.lower(itemName) then
                                    CreateEsp(obj, data.color, obj.Name, obj.PrimaryPart)
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.25)
                end
            end)
        end
    })
end


Tabs.Esp:Toggle({
    Title = "Esp (Children)",
    Default = false,
    Callback = function(state)
        ActiveEspChildren = state
        task.spawn(function()
            while ActiveEspChildren do
                task.spawn(function()
                    for _, Obj in pairs(Game.Workspace.Characters:GetChildren()) do
                        if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(Obj, Color3.fromRGB(0, 255, 0), Obj.Name, Obj.PrimaryPart)
                        end
                    end
                end)
                task.wait(0.1)
            end
            task.spawn(function()
                for _, Obj in pairs(Game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        KeepEsp(Obj, Obj.PrimaryPart)
                    end
                end
            end)
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Pelt Trader)",
    Default = false,
    Callback = function(state)
        ActiveEspPeltTrader = state
        task.spawn(function()
            while ActiveEspPeltTrader do
                task.spawn(function()
                    for _, Obj in pairs(Game.Workspace.Characters:GetChildren()) do
                        if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(Obj, Color3.fromRGB(0, 255, 255), Obj.Name, Obj.PrimaryPart)
                        end
                    end
                end)
                task.wait(0.1)
            end
            task.spawn(function()
                for _, Obj in pairs(Game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        KeepEsp(Obj, Obj.PrimaryPart)
                    end
                end
            end)
        end)
    end
})


-----------------------------------------------------------------
-- TELEPORT TAB
-----------------------------------------------------------------
Tabs.Teleport:Button({
    Title="Teleport to Camp",
    Callback=function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end
})
Tabs.Teleport:Button({
    Title="TP to NPC Trader",
    Callback=function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Button({
    Title = "TP to Random Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        -- Try to use Foliage or Landmarks for trees
        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        -- Gather all "Small Tree" models
        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        -- Pick a random tree
        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

local lostChildNames = {
    "Lost Child",
    "Lost Child2",
    "Lost Child3",
    "Lost Child4"
}

for i, name in ipairs(lostChildNames) do
    Tabs.Teleport:Button({
        Title = "TP to Lost Child " .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Characters
            local targetLostChild = workspaceCharacters:FindFirstChild(name)

            if targetLostChild and targetLostChild:IsA("Model") and targetLostChild.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetLostChild.PrimaryPart.CFrame
            else
                warn(name .. " not found in Characters or has no PrimaryPart")
            end
        end
    })
end

-----------------------------------------------------------------
-- BRING TAB
-----------------------------------------------------------------
Tabs.Bring:Button({Title="Bring Everything (Fixed Lag)",Callback=function()
    for _, item in ipairs(workspace.Items:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
        if part then
            part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end})
Tabs.Bring:Button({Title="Bring Logs", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("log") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Fuel Canister", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("fuel canister") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Oil Barrel", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("oil barrel") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({ Title = "Bring Scrap All", Callback = function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local scrapNames = {
        ["tyre"] = true, ["sheet metal"] = true, ["broken fan"] = true, ["bolt"] = true, ["old radio"] = true, ["ufo junk"] = true, ["ufo scrap"] = true, ["broken microwave"] = true,
    }
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            for scrapName, _ in pairs(scrapNames) do
                if itemName:find(scrapName) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                    break
                end
            end
        end
    end
end })
Tabs.Bring:Button({Title="Bring Coal", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("coal") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Meat (Raw & Cooked)", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("meat") or name:find("cooked")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Flashlight", Callback=function() bringItemsByName("Flashlight") end})
Tabs.Bring:Button({Title="Bring Nails", Callback=function() bringItemsByName("Nails") end})
Tabs.Bring:Button({Title="Bring Fan", Callback=function() bringItemsByName("Fan") end})

Tabs.Bring:Button({Title="Bring Rope", Callback=function() bringItemsByName("Rope") end})
Tabs.Bring:Button({Title="Bring Scrap", Callback=function() bringItemsByName("Scrap") end})
Tabs.Bring:Button({Title="Bring Wood", Callback=function() bringItemsByName("Wood") end})
Tabs.Bring:Button({Title="Bring Cloth", Callback=function() bringItemsByName("Cloth") end})
Tabs.Bring:Button({Title="Bring Rock", Callback=function() bringItemsByName("Rock") end})
Tabs.Bring:Button({Title="Bring Stone Pickaxe", Callback=function() bringItemsByName("Stone Pickaxe") end})
Tabs.Bring:Button({Title="Bring Knife", Callback=function() bringItemsByName("Knife") end})
Tabs.Bring:Button({Title="Bring Spear", Callback=function() bringItemsByName("Spear") end})
Tabs.Bring:Button({Title="Bring Leather Body", Callback=function() bringItemsByName("Leather Body") end})
Tabs.Bring:Button({Title="Bring Iron Body", Callback=function() bringItemsByName("Iron Body") end})
Tabs.Bring:Button({Title="Bring Revolver", Callback=function() bringItemsByName("Revolver") end})
Tabs.Bring:Button({Title="Bring Rifle", Callback=function() bringItemsByName("Rifle") end})
Tabs.Bring:Button({Title="Bring Bandage", Callback=function() bringItemsByName("Bandage") end})
Tabs.Bring:Button({Title="Bring MedKit", Callback=function() bringItemsByName("MedKit") end})
Tabs.Bring:Button({Title="Bring Old Radio", Callback=function() bringItemsByName("Old Radio") end})
Tabs.Bring:Button({Title="Bring Coin Stack", Callback=function() bringItemsByName("Coin Stack") end})
Tabs.Bring:Button({Title="Bring UFO Junk", Callback=function() bringItemsByName("UFO Junk") end})
Tabs.Bring:Button({Title="Bring UFO Scrap", Callback=function() bringItemsByName("UFO Scrap") end})
Tabs.Bring:Button({Title="Bring Broken Microwave", Callback=function() bringItemsByName("Broken Microwave") end})
Tabs.Bring:Button({Title="Bring Bolt", Callback=function() bringItemsByName("Bolt") end})
Tabs.Bring:Button({Title="Bring Chair", Callback=function() bringItemsByName("Chair") end})
Tabs.Bring:Button({Title="Bring Seed Box", Callback=function() bringItemsByName("Seed Box") end})
Tabs.Bring:Button({Title="Bring Meat? Sandwich", Callback=function() bringItemsByName("Meat? Sandwich") end})
Tabs.Bring:Button({Title="Bring Cake", Callback=function() bringItemsByName("Cake") end})
Tabs.Bring:Button({Title="Bring Carrot", Callback=function() bringItemsByName("Carrot") end})
Tabs.Bring:Button({Title="Bring Morsel", Callback=function() bringItemsByName("Morsel") end})
Tabs.Bring:Button({Title="Bring Tyre", Callback=function() bringItemsByName("Tyre") end})
Tabs.Bring:Button({Title="Bring Broken Fan", Callback=function() bringItemsByName("Broken Fan") end})
Tabs.Bring:Button({Title="Bring Sheet Metal", Callback=function() bringItemsByName("Sheet Metal") end})
Tabs.Bring:Button({Title="Bring Strong Axe", Callback=function() bringItemsByName("Strong Axe") end})
Tabs.Bring:Button({Title="Bring Good Axe", Callback=function() bringItemsByName("Good Axe") end})
Tabs.Bring:Button({Title="Bring Old Axe", Callback=function() bringItemsByName("Old Axe") end})
Tabs.Bring:Button({Title="Bring Rifle Ammo", Callback=function() bringItemsByName("Rifle Ammo") end})
Tabs.Bring:Button({Title="Bring Revolver Ammo", Callback=function() bringItemsByName("Revolver Ammo") end})


Tabs.Hitbox:Slider({
    Title = "Hitbox",
    Min = 0,
    Max = 100,
    Default = 0,
    Callback = function(val)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name ~= game.Players.LocalPlayer.Name then
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                if part.Name ~= "HumanoidRootPart" then
                                    part.Size = part.Size + Vector3.new(val, val, val)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.Player:Slider({
    Title = "Set WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end
})

Tabs.Player:Slider({
    Title = "Set JumpPower",
    Min = 50,
    Max = 250,
    Default = 50,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = val
        end
    end
})

Tabs.Player:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = 0
                Humanoid.JumpPower = 0
            end
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not state
                end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "No Fall Damage",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.BreakJointsOnDeath = not state
        end
    end
})

Tabs.Player:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if state then
                Humanoid.JumpPower = math.huge
                Humanoid.Touched:Connect(function(hit)
                    if Humanoid and hit and hit.Parent == workspace then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                Humanoid.JumpPower = 50 -- Default jump power
            end
        end
    end
})

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 10), Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 30), Color3.fromRGB(0,255,0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)
Tabs.Misc:Toggle({Title="Show FPS", Default=true, Callback=function(val) showFPS=val; fpsText.Visible=val end})
Tabs.Misc:Toggle({Title="Show Ping (ms)", Default=true, Callback=function(val) showPing=val; msText.Visible=val end})

Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("✅ FPS Boost Applied")
    end
})

-- FUNCTIONS DEFINITIONS (MOVED TO BOTTOM)
local function FLY(vfly)
    FLYING = true
    local BG = Instance.new('BodyGyro')
    local BV = Instance.new('BodyVelocity')
    BG.P = 9e4
    local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    BG.Parent = T
    BV.Parent = T
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = T.CFrame
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0
    task.spawn(function()
        repeat task.wait()
        if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
            Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
        end
        if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
            SPEED = 50
        elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
            SPEED = 0
        end
        if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
            BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
            lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
        elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
            BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
        else
            BV.Velocity = Vector3.new(0, 0, 0)
        end
        BG.CFrame = workspace.CurrentCamera.CoordinateFrame
        until not FLYING
        CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        SPEED = 0
        BG:Destroy()
        BV:Destroy()
        if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
            Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
        end
    end)
end

local function sFLY(vfly)
    repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat task.wait() until IYMouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

    local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    FLY(vfly) -- Calling the function defined above

    flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 's' then
            CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'a' then
            CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'd' then
            CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif QEfly and KEY:lower() == 'e' then
            CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif QEfly and KEY:lower() == 'q' then
            CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = 0
        elseif KEY:lower() == 's' then
            CONTROL.B = 0
        elseif KEY:lower() == 'a' then
            CONTROL.L = 0
        elseif KEY:lower() == 'd' then
            CONTROL.R = 0
        elseif KEY:lower() == 'e' then
            CONTROL.Q = 0
        elseif KEY:lower() == 'q' then
            CONTROL.E = 0
        end
    end)
end

local function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function UnMobileFly()
    pcall(function()
        FLYING = false
        local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        root:FindFirstChild(velocityHandlerName):Destroy()
        root:FindFirstChild(gyroHandlerName):Destroy()
        Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        mfly1:Disconnect()
        mfly2:Disconnect()
    end)
end

local function MobileFly()
    UnMobileFly()
    FLYING = true

    local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local v3none = Vector3.new()
    local v3zero = Vector3.new(0, 0, 0)
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local bv = Instance.new("BodyVelocity")
    bv.Name = velocityHandlerName
    bv.Parent = root
    bv.MaxForce = v3zero
    bv.Velocity = v3zero

    local bg = Instance.new("BodyGyro")
    bg.Name = gyroHandlerName
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly1 = Players.LocalPlayer.CharacterAdded:Connect(function()
        local bv = Instance.new("BodyVelocity")
        bv.Name = velocityHandlerName
        bv.Parent = root
        bv.MaxForce = v3zero
        bv.Velocity = v3zero

        local bg = Instance.new("BodyGyro")
        bg.Name = gyroHandlerName
        bg.Parent = root
        bg.MaxTorque = v3inf
        bg.P = 1000
        bg.D = 50
    end)

    mfly2 = RunService.RenderStepped:Connect(function()
        root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        camera = workspace.CurrentCamera
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
            local humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            local VelocityHandler = root:FindFirstChild(velocityHandlerName)
            local GyroHandler = root:FindFirstChild(gyroHandlerName)

            VelocityHandler.MaxForce = v3inf
            GyroHandler.MaxTorque = v3inf
            humanoid.PlatformStand = true
            GyroHandler.CFrame = camera.CoordinateFrame
            VelocityHandler.Velocity = v3none

            local direction = controlModule:GetMoveVector()
            if direction.X > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((iyflyspeed) * 50))
            end
            if direction.X < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((iyflyspeed) * 50))
            end
            if direction.Z > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((iyflyspeed) * 50))
            end
            if direction.Z < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((iyflyspeed) * 50))
            end
        end
    end)
end

local function CreateEsp(Char, Color, Text,Parent,number)
    if not Char then return end
    if Char:FindFirstChild("ESP") and Char:FindFirstChildOfClass("Highlight") then return end
    local highlight = Char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char


    local billboard = Char:FindFirstChild("ESP") or Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, number, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent


    local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    task.spawn(function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")

        local LocalPlayer = Players.LocalPlayer
        local Camera = Workspace.CurrentCamera

        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                task.spawn(function()
                    if ActiveDistanceEsp then
                        label.Text = Text.." ("..math.floor(distance + 0.5).." m)"
                    else
                        label.Text = Text
                    end
                end)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function KeepEsp(Char,Parent)
    if Char and Char:FindFirstChildOfClass("Highlight") and Parent:FindFirstChildOfClass("BillboardGui") then
        Char:FindFirstChildOfClass("Highlight"):Destroy()
        Parent:FindFirstChildOfClass("BillboardGui"):Destroy()
    end
end

local function bringItemsByName(name)
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 5
            end
        end
    end
end
