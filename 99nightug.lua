repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local function KeepEsp(Char, Parent)
    if Char then
        local highlight = Char:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
    if Parent then
        local billboard = Parent:FindFirstChildOfClass("BillboardGui")
        if billboard then
            billboard:Destroy()
        end
    end
end

local function CreateEsp(Char, Color, Text, Parent, numberOffset)
    if not Char or not Char:IsA("Model") then return end
    if not Char:FindFirstChild("HumanoidRootPart") then return end
    if not Parent or not Parent:IsA("BasePart") then return end

    KeepEsp(Char, Parent)

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, numberOffset or 3, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    task.spawn(function()
        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                if ActiveDistanceEsp then
                    label.Text = Text .. " (" .. math.floor(distance + 0.5) .. " stud)"
                else
                    label.Text = Text
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function bringItemsByName(name)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(0, 3, 0) + root.CFrame.LookVector * 5
            end
        end
    end
end


local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - 99 Night in the Forest",
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
    Folder = "DYHUB Config | 99NitF | V3",
    Title = "DYHUB - 99 Night in the Forest @ In-game (Beta)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(520, 300),
    Transparent = true,
    Theme = "Dark",
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
    Main = Window:Tab({ Title = "Main", Icon = "rocket" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Esp = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Bring = Window:Tab({ Title = "Bring All", Icon = "atom" }),
    BringGeneral = Window:Tab({ Title = "Bring General", Icon = "badge-plus" }),
    BringWeapon = Window:Tab({ Title = "Bring Weapon", Icon = "swords" }),
    BringItem = Window:Tab({ Title = "Bring Items", Icon = "package" }),
    BringFood = Window:Tab({ Title = "Bring Food", Icon = "apple" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "file-cog" }),
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
            if infHungerThread then
                task.cancel(infHungerThread)
                infHungerThread = nil
            end
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
            if autoTreeFarmThread then
                task.cancel(autoTreeFarmThread)
                autoTreeFarmThread = nil
            end
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
            if autoBreakThread then
                task.cancel(autoBreakThread)
                autoBreakThread = nil
            end
        end
    end
})

-- ========= Esp Tab
local ActiveEspPlayer = false

local ActiveEspItems = false
local ActiveEspEnemy = false
local ActiveEspChildren = false
local ActiveEspPeltTrader = false
local ActiveDistanceEsp = false

Tabs.Esp:Toggle({
    Title = "Esp (Player)",
    Default = false,
    Callback = function(state)
        ActiveEspPlayer = state
        task.spawn(function()
            while ActiveEspPlayer do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = player.Character
                        if not char:FindFirstChildOfClass("Highlight") and not char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(char, Color3.fromRGB(0, 255, 0), player.Name, char.HumanoidRootPart, 2)
                        end
                    end
                end
                task.wait(0.1)
            end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    KeepEsp(char, char.HumanoidRootPart)
                end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Items)",
    Default = false,
    Callback = function(state)
        ActiveEspItems = state
        task.spawn(function()
            while ActiveEspItems do
                for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
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
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 0, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})
Tabs.Esp:Toggle({
    Title = "Esp (Children)",
    Default = false,
    Callback = function(state)
        ActiveEspChildren = state
        task.spawn(function()
            while ActiveEspChildren do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
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
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") and not Obj:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 255), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

-----------------------------------------------------------------
-- TELEPORT TAB
-----------------------------------------------------------------
Tabs.Teleport:Toggle({
    Title = "Scan Map (Essential)",
    Default = false,
    Callback = function(state)
        getgenv().scan_map = state

        task.spawn(function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
            if not foliage then return end

            local trees = {}
            for _, obj in ipairs(foliage:GetChildren()) do
                if obj.Name == "Small Tree" and obj:IsA("Model") then
                    local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                    if trunk then
                        table.insert(trees, trunk)
                    end
                end
            end

            while getgenv().scan_map and #trees > 0 do
                for _, trunk in ipairs(trees) do
                    if not getgenv().scan_map then break end
                    local treeCFrame = trunk.CFrame
                    local rightVector = treeCFrame.RightVector
                    local targetPosition = treeCFrame.Position + rightVector * 25
                    hrp.CFrame = CFrame.new(targetPosition)
                    task.wait(0.15)
                end
            end
        end)
    end
})


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

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

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

local Other = {
    "Item Chest",
    "Item Chest2",
    "Item Chest3",
    "Item Chest4",
    "Item Chest5",
    "Item Chest6"
}

for i, name in ipairs(Other) do
    Tabs.Teleport:Button({
        Title = "TP to Chest" .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Items
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

local Other = {
    "Alien Chest"
}

for i, name in ipairs(Other) do
    Tabs.Teleport:Button({
        Title = "TP to Alien Chest" .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Items
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
Tabs.Bring:Button({Title="Bring Everything (Up Size)",Callback=function()
    for _, item in ipairs(workspace.Items:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
        if part then
            part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-25,25), 0, math.random(-25,25))
        end
    end
end})
Tabs.Bring:Button({Title="Bring Logs All", Callback=function()
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
Tabs.Bring:Button({Title="Bring Fuel All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("fuel canister") or name:find("oil barrel") or name:find("coal") or name:find("Biofuel")) and item:IsA("Model") then
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
        ["tyre"] = true, ["Old Car Engine"] = true, ["Washing Machine"] = true, ["Old Car Engine"] = true, ["UFO Component"] = true, ["Cultist Prototype"] = true, ["sheet metal"] = true, ["broken fan"] = true, ["bolt"] = true, ["old radio"] = true, ["ufo junk"] = true, ["ufo scrap"] = true, ["broken microwave"] = true,
    }
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            for scrapName, _ in pairs(scrapNames) do
                if itemName:find(scrapName) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
                    end
                    break
                end
            end
        end
    end
end })
Tabs.Bring:Button({Title="Bring Food All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("Meat? Sandwich") or name:find("Morsel") or name:find("Cake") or name:find("Carrot") or name:find("Pumpkin") or name:find("Corn") or name:find("Meat") or name:find("Cooked") or name:find("Berry") or name:find("Apple") or name:find("Steak") or name:find("Stew") or name:find("Steak") or name:find("Hearty Stew") or name:find("Meat? Sandwich")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Pelts/Foot All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("bunny foot") or name:find("wolf pelt") or name:find("alpha wolf pelt") or name:find("bear pelt")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Materials All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (
            name:find("scrap") or
            name:find("cultist gem") or
            name:find("forest gem") or
            name:find("mossy coin")
        ) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Healing All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (
            name:find("Medkit") or
            name:find("Bandage")
        ) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Lost Children All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Characters:GetChildren()) do
        local name = item.Name:lower()
        if (
            name:find("lost child") or
            name:find("lost child2") or
            name:find("lost child3") or
            name:find("lost child4")
        ) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Chest All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("Item Chest") or name:find("Alien Chest") or name:find("Item Chest2") or name:find("Item Chest3") or name:find("Item Chest4") or name:find("Item Chest5") or name:find("Item Chest6")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
-- Weapon
Tabs.BringWeapon:Button({Title="Bring Morningstar", Callback=function() bringItemsByName("Morningstar") end})
Tabs.BringWeapon:Button({Title="Bring Laser Sword", Callback=function() bringItemsByName("Laser Sword") end})
Tabs.BringWeapon:Button({Title="Bring Katana", Callback=function() bringItemsByName("Katana") end})
Tabs.BringWeapon:Button({Title="Bring Spear", Callback=function() bringItemsByName("Spear") end})
Tabs.BringWeapon:Button({Title="Bring Tactical Shotgun", Callback=function() bringItemsByName("Tactical Shotgun") end})
Tabs.BringWeapon:Button({Title="Bring Kunai", Callback=function() bringItemsByName("Kunai") end})
Tabs.BringWeapon:Button({Title="Bring Knife", Callback=function() bringItemsByName("Knife") end})
Tabs.BringWeapon:Button({Title="Bring Revolver", Callback=function() bringItemsByName("Revolver") end})
Tabs.BringWeapon:Button({Title="Bring Rifle", Callback=function() bringItemsByName("Rifle") end})
Tabs.BringWeapon:Button({Title="Bring Alien Raygun", Callback=function() bringItemsByName("Ray Gun") end})ฃ
Tabs.BringWeapon:Button({Title="Bring Alien Raycannon", Callback=function() bringItemsByName("Laser Cannon") end})
Tabs.BringWeapon:Button({Title="Bring Strong Axe", Callback=function() bringItemsByName("Strong Axe") end})
Tabs.BringWeapon:Button({Title="Bring Good Axe", Callback=function() bringItemsByName("Good Axe") end})
Tabs.BringWeapon:Button({Title="Bring Old Axe", Callback=function() bringItemsByName("Old Axe") end})
Tabs.BringWeapon:Button({Title="Bring Rifle Ammo", Callback=function() bringItemsByName("Rifle Ammo") end})
Tabs.BringWeapon:Button({Title="Bring Revolver Ammo", Callback=function() bringItemsByName("Revolver Ammo") end})
Tabs.BringWeapon:Button({Title="Bring Shotgun Ammo", Callback=function() bringItemsByName("Revolver Ammo") end})
Tabs.BringWeapon:Button({Title="Bring Leather Body", Callback=function() bringItemsByName("Leather Body") end})
Tabs.BringWeapon:Button({Title="Bring Iron Body", Callback=function() bringItemsByName("Iron Body") end})
Tabs.BringWeapon:Button({Title="Bring Thorn Body", Callback=function() bringItemsByName("Thorn Body") end})
Tabs.BringWeapon:Button({Title="Bring Alien Armor", Callback=function() bringItemsByName("Alien Armor") end})
Tabs.BringWeapon:Button({Title="Bring Riot Shield", Callback=function() bringItemsByName("Riot Shield") 

-- Food
Tabs.BringFood:Button({Title="Bring Steak", Callback=function() bringItemsByName("Steak") end})
Tabs.BringFood:Button({Title="Bring Apple", Callback=function() bringItemsByName("Apple") end})
Tabs.BringFood:Button({Title="Bring Berry", Callback=function() bringItemsByName("Berry") end})
Tabs.BringFood:Button({Title="Bring Hearty Stew", Callback=function() bringItemsByName("Hearty Stew") end})
Tabs.BringFood:Button({Title="Bring Stew", Callback=function() bringItemsByName("Stew") end})
Tabs.BringFood:Button({Title="Bring Chili", Callback=function() bringItemsByName("Chili") end})

Tabs.BringFood:Button({Title="Bring Pumpkin", Callback=function() bringItemsByName("Pumpkin") end})
Tabs.BringFood:Button({Title="Bring Corn", Callback=function() bringItemsByName("Corn") end})
Tabs.BringFood:Button({Title="Bring Carrot", Callback=function() bringItemsByName("Carrot") end})
Tabs.BringFood:Button({Title="Bring Cake", Callback=function() bringItemsByName("Cake") end})
Tabs.BringFood:Button({Title="Bring Morsel", Callback=function() bringItemsByName("Morsel") end})
Tabs.BringFood:Button({Title="Bring Meat? Sandwich", Callback=function() bringItemsByName("Meat? Sandwich") end})

-- Item
Tabs.BringItem:Button({Title="Bring Rope", Callback=function() bringItemsByName("Rope") end})
Tabs.BringItem:Button({Title="Bring Scrap", Callback=function() bringItemsByName("Scrap") end})
Tabs.BringItem:Button({Title="Bring Wood", Callback=function() bringItemsByName("Wood") end})
Tabs.BringItem:Button({Title="Bring Rock", Callback=function() bringItemsByName("Rock") end})
Tabs.BringItem:Button({Title="Bring Bolt", Callback=function() bringItemsByName("Bolt") end})
Tabs.BringItem:Button({Title="Bring Sheet Metal", Callback=function() bringItemsByName("Sheet Metal") end})
Tabs.BringItem:Button({Title="Bring Cloth", Callback=function() bringItemsByName("Cloth") end})
Tabs.BringItem:Button({Title="Bring Tyre", Callback=function() bringItemsByName("Tyre") end})
Tabs.BringItem:Button({Title="Bring Nails", Callback=function() bringItemsByName("Nails") end})
Tabs.BringItem:Button({Title="Bring Stone Pickaxe", Callback=function() bringItemsByName("Stone Pickaxe") end})
Tabs.BringItem:Button({Title="Bring Fan", Callback=function() bringItemsByName("Fan") end})
Tabs.BringItem:Button({Title="Bring Broken Fan", Callback=function() bringItemsByName("Broken Fan") end})
Tabs.BringItem:Button({Title="Bring Broken Microwave", Callback=function() bringItemsByName("Broken Microwave") end})
Tabs.BringItem:Button({Title="Bring UFO Junk", Callback=function() bringItemsByName("UFO Junk") end})
Tabs.BringItem:Button({Title="Bring UFO Scrap", Callback=function() bringItemsByName("UFO Scrap") end})
Tabs.BringItem:Button({Title="Bring Seed Box", Callback=function() bringItemsByName("Seed Box") end})
Tabs.BringItem:Button({Title="Bring Coin Stack", Callback=function() bringItemsByName("Coin Stack") end})
Tabs.BringItem:Button({Title="Bring Old Radio", Callback=function() bringItemsByName("Old Radio") end})
Tabs.BringItem:Button({Title="Bring Chair", Callback=function() bringItemsByName("Chair") end})

-- General
Tabs.BringGeneral:Button({Title="Bring Chili Seeds", Callback=function() bringItemsByName("Chili Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Firefly Seeds", Callback=function() bringItemsByName("Firefly Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Berry Seeds", Callback=function() bringItemsByName("Berry Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Flower Seeds", Callback=function() bringItemsByName("Flower Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Old Sack", Callback=function() bringItemsByName("Old Sack") end})
Tabs.BringGeneral:Button({Title="Bring Good Sack", Callback=function() bringItemsByName("Good Sack") end})
Tabs.BringGeneral:Button({Title="Bring Giant Sack", Callback=function() bringItemsByName("Giant Sack") end})
Tabs.BringGeneral:Button({Title="Bring Flashlight", Callback=function() bringItemsByName("Flashlight") end})
Tabs.BringGeneral:Button({Title="Bring Strong Flashlight", Callback=function() bringItemsByName("Strong Flashlight") end})
Tabs.BringGeneral:Button({Title="Bring Bandage", Callback=function() bringItemsByName("Bandage") end})
Tabs.BringGeneral:Button({Title="Bring MedKit", Callback=function() bringItemsByName("MedKit") end})
end})
Tabs.BringGeneral:Button({Title="Bring Saplings", Callback=function() bringItemsByName("Saplings") end})
Tabs.BringGeneral:Button({Title="Bring Stakes", Callback=function() bringItemsByName("Stakes") end})
Tabs.BringGeneral:Button({Title="Bring Wolf Pelts", Callback=function() bringItemsByName("Wolf Pelts") end})
Tabs.BringGeneral:Button({Title="Bring Bear Pelts", Callback=function() bringItemsByName("Bear Pelts") end})

local hitboxSettings = {All=false, Alien=false, Wolf=false, Bunny=false, Cultist=false, Bear=false, Show=false, Size=10}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.All and (name:find("alien") or name:find("alien elite") or name:find("bear") or name:find("polar bear") or name:find("wolf") or name:find("alpha") or name:find("bunny") or name:find("dragon") or name:find("cultist") or name:find("cross") or name:find("crossbow cultist"))) or
        (hitboxSettings.Alien and (name:find("alien") or name:find("alien elite"))) or
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Bear and (name:find("bear") or name:find("polar bear"))) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross") or name:find("crossbow cultist"))) -- <--- ตรงนี้ได้ลบ 'or' ที่เกินออกแล้ว
    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Toggle({Title="Expand All Hitbox", Default=false, Callback=function(val) hitboxSettings.All=val end})
Tabs.Hitbox:Toggle({Title="Expand Alien Hitbox", Default=false, Callback=function(val) hitboxSettings.Alien=val end})
Tabs.Hitbox:Toggle({Title="Expand Bear Hitbox", Default=false, Callback=function(val) hitboxSettings.Bear=val end})
Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=200, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})

getgenv().speedEnabled = false
getgenv().speedValue = 20
Tabs.Misc:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.Misc:Slider({
    Title = "Set Speed Value",
    Value = {Min = 16, Max = 600, Default = 20},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50
Tabs.Misc:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 16 end
    end
})
Tabs.Misc:Slider({
    Title = "Set Jump Value",
    Value = {Min = 10, Max = 600, Default = 50},
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

Tabs.Player:Button({
    Title = "No Cooldown (Open Chest)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/nodelay.lua"))()
    end
})


Tabs.Player:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})

local noclipConnection

Tabs.Player:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "No Cooldown (Good Axe Only)",
    Default = false,
    Callback = function(state)
        -- This functionality seems tied to BreakJointsOnDeath, which isn't typical for cooldowns.
        -- If this is meant to disable weapon cooldown, it would require a different approach,
        -- likely by invoking the remote event for weapon usage repeatedly.
        -- For now, keeping the original behavior for BreakJointsOnDeath as it was.
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.BreakJointsOnDeath = not state
        end
    end
})

Tabs.Player:Toggle({
    Title = "God mode (Beta)",
    Default = false,
    Callback = function(state)
        -- God mode typically involves setting Humanoid.Health to math.huge or constantly healing.
        -- The current implementation uses BreakJointsOnDeath which is not god mode.
        -- Leaving the original behavior for now, but noting it's not a true god mode.
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
                -- Using Jump state for continuous jumping
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                -- Connect to keep jumping while state is active and humanoid exists
                local jumpConnection = Humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Landed and Humanoid.JumpPower == math.huge then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                -- Store connection to disconnect later
                Humanoid:SetAttribute("InfinityJumpConnection", jumpConnection)
            else
                Humanoid.JumpPower = 50 -- Default jump power
                local jumpConnection = Humanoid:GetAttribute("InfinityJumpConnection")
                if jumpConnection then
                    jumpConnection:Disconnect()
                    Humanoid:SetAttribute("InfinityJumpConnection", nil)
                end
            end
        end
    end
})

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
                msText.Text = "Ew Wifi Ping: " .. ping .. " ms"
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
