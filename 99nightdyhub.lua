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
    --Player = Window:Tab({ Title = "Player", Icon = "user" }),
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

local autoBreakActive = false
local autoBreakThread
local autoBreakSpeed = 1

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
    EspItemsTab:Toggle({
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
        if item.Name:lower():find("Fuel Canister") and item:IsA("Model") then
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
        if item.Name:lower():find("Oil Barrel") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({
    Title = "Bring Scrap All",
    Callback = function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local scrapNames = {
            ["tyre"] = true,
            ["sheet metal"] = true,
            ["broken fan"] = true,
            ["bolt"] = true,
            ["old radio"] = true,
            ["ufo junk"] = true,
            ["ufo scrap"] = true,
            ["broken microwave"] = true,
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
    end
})
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
Tabs.Bring:Button({Title="Bring Ammo", Callback=function()
    local keywords = {"ammo"}
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        for _, word in ipairs(keywords) do
            if item.Name:lower():find(word) then
                local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
                if part then
                    part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Sheet Metal", Callback=function()
    local keyword = "sheet metal"
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(keyword) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Fuel Canister", Callback=function()
    local keyword = "fuel canister"
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(keyword) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Tyre", Callback=function()
    local keyword = "tyre"
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(keyword) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Bandage", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") and item.Name:lower():find("bandage") then
            local part = item:FindFirstChildWhichIsA("BasePart")
            if part then
                part.CFrame = root.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Lost Child", Callback=function()
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:lower():find("lost") and model:FindFirstChild("HumanoidRootPart") then
            model:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
        end
    end
end})

Tabs.Bring:Button({Title="Bring Revolver", Callback=function()
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") and item.Name:lower():find("revolver") then
            local part = item:FindFirstChildWhichIsA("BasePart")
            if part then
                part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end
end})

-----------------------------------------------------------------
-- HITBOX TAB
-----------------------------------------------------------------
local hitboxSettings = {Wolf=false, Bunny=false, Cultist=false, Show=false, Size=10}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))
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

Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=30, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})

-----------------------------------------------------------------
-- MISC TAB
-----------------------------------------------------------------
getgenv().speedEnabled = false
getgenv().speedValue = 28
Tabs.Misc:Toggle({
    Title = "Speed Hack",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.Misc:Slider({
    Title = "Speed Value",
    Value = {Min = 16, Max = 600, Default = 28},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
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
