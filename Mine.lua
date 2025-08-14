-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/112279762578792"))()

-- Library --
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "DYHUB - Mines (Premium)", HidePremium = false, SaveConfig = true, ConfigFolder = "clock.lua.mines"})
local MineTab = Window:MakeTab({
    Name = "Mining",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local ShopTab = Window:MakeTab({
    Name = "Shop",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Init --
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local Mouse = plr:GetMouse()
local root = plr.Character:FindFirstChild("HumanoidRootPart")
local Mine = ReplicatedStorage["shared/network/MiningNetwork@GlobalMiningEvents"].Mine
local Drill = ReplicatedStorage["shared/network/MiningNetwork@GlobalMiningFunctions"].Drill
local Dynamite = ReplicatedStorage["shared/network/DynamiteNetwork@GlobalDynamiteFunctions"].UseDynamite
local BuyItem = ReplicatedStorage.Ml.BuyItem
local items = workspace:FindFirstChild("Items")

-- Variables --
local AutoMine = false
local MiningStrength = 1
local MiningThread = nil
local AutoDrill = false
local DrillingThread = nil
local AutoDynamite = false
local DynamiteThread = nil
local ColOres = false
local CollectSpeed = 0.5
local CollectMode = "Legit"
local OresThread = nil
local PromptButtonHoldBegan = nil
local tradertomPos = nil
getgenv().desiredWalkSpeed = 16
local ownPos = nil
local MiningDir = "Camera"
local function findtradertom()
    if not tradertomPos then
        root.CFrame = CFrame.new(Vector3.new(998, 245, -71))
        local attempt = 0
        repeat
            for _, npc in pairs(workspace:GetChildren()) do
                if npc:IsA("Model") and npc:GetAttribute("Name") == "Trader Tom" and npc:FindFirstChild("HumanoidRootPart") then
                    tradertomPos = npc.HumanoidRootPart.Position
                    break
                end
            end
            task.wait(0.1)
            attempt = attempt + 1
        until tradertomPos or attempt > 20

        if not tradertomPos then
            warn("Could not find Trader Tom after", 20, "attempts")
        end
    end
end

pcall(function()
    findtradertom()
end)

if not getgenv().wshb then
    getgenv().wshb = true
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if plr.Character and plr.Character.Humanoid then
                plr.Character.Humanoid.WalkSpeed = getgenv().desiredWalkSpeed
            end
        end)
    end)
end

-- Functions --
local function findNearestItem()
    if not items or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local playerPos = plr.Character.HumanoidRootPart.Position
    local closestItem = nil
    local shortestDistance = math.huge

    for _, item in ipairs(items:GetChildren()) do
        local itemPos
        if item:IsA("MeshPart") then
            itemPos = item.Position
        elseif item:IsA("Tool") and item:FindFirstChild("Handle") then
            itemPos = item.Handle.Position
        end

        if itemPos then
            local distance = (playerPos - itemPos).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestItem = item
            end
        end
    end

    return closestItem
end

local function MineOres()
    while AutoMine do
        local camera = workspace.CurrentCamera.CFrame.LookVector
        if MiningDir == "Camera" then
            minePos = Vector3.new(
                math.round(math.clamp(camera.X * 1000, -1000, 1000)),
                math.round(math.clamp(camera.Y * 1000, -1000, 1000)),
                math.round(math.clamp(camera.Z * 1000, -1000, 1000))
            )
        elseif MiningDir == "Towards Ores" then
            local closestItem = findNearestItem()
            if closestItem and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local playerPos = plr.Character.HumanoidRootPart.Position
                local itemPos
                if closestItem:IsA("MeshPart") then
                    itemPos = closestItem.Position
                elseif closestItem:IsA("Tool") and closestItem:FindFirstChild("Handle") then
                    itemPos = closestItem.Handle.Position
                end
                local direction = (itemPos - playerPos).Unit
                minePos = Vector3.new(
                    math.round(math.clamp(direction.X * 1000, -1000, 1000)),
                    math.round(math.clamp(direction.Y * 1000, -1000, 1000)),
                    math.round(math.clamp(direction.Z * 1000, -1000, 1000))
                )
            else
                minePos = Vector3.new(
                    math.round(math.clamp(camera.X * 1000, -1000, 1000)),
                    math.round(math.clamp(camera.Y * 1000, -1000, 1000)),
                    math.round(math.clamp(camera.Z * 1000, -1000, 1000))
                )
            end
        else
            minePos = Vector3.new(
                math.random(-1000, 1000),
                math.random(-1000, 1000),
                math.random(-1000, 1000)
            )
        end
        Mine:FireServer(minePos, MiningStrength)
        task.wait(0.1)
    end
end

local function MineOresDrill()
    while AutoDrill do
        local camera = workspace.CurrentCamera.CFrame.LookVector
        if MiningDir == "Camera" then
            minePos = Vector3.new(
                math.round(math.clamp(camera.X * 1000, -1000, 1000)),
                math.round(math.clamp(camera.Y * 1000, -1000, 1000)),
                math.round(math.clamp(camera.Z * 1000, -1000, 1000))
            )
        elseif MiningDir == "Towards Ores" then
            local closestItem = findNearestItem()
            if closestItem and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local playerPos = plr.Character.HumanoidRootPart.Position
                local itemPos
                if closestItem:IsA("MeshPart") then
                    itemPos = closestItem.Position
                elseif closestItem:IsA("Tool") and closestItem:FindFirstChild("Handle") then
                    itemPos = closestItem.Handle.Position
                end
                local direction = (itemPos - playerPos).Unit
                minePos = Vector3.new(
                    math.round(math.clamp(direction.X * 1000, -1000, 1000)),
                    math.round(math.clamp(direction.Y * 1000, -1000, 1000)),
                    math.round(math.clamp(direction.Z * 1000, -1000, 1000))
                )
            else
                minePos = Vector3.new(
                    math.round(math.clamp(camera.X * 1000, -1000, 1000)),
                    math.round(math.clamp(camera.Y * 1000, -1000, 1000)),
                    math.round(math.clamp(camera.Z * 1000, -1000, 1000))
                )
            end
        else
            minePos = Vector3.new(
                math.random(-1000, 1000),
                math.random(-1000, 1000),
                math.random(-1000, 1000)
            )
        end
        Drill:FireServer(math.random(0,9e9), {direction = minePos, heat = 0, overheated = false})
        task.wait(0.05)
    end
end

local function UseDynamite()
    while AutoDynamite do
        local hitPosition = Mouse.Hit.Position
        Dynamite:FireServer(math.random(0,9e9), hitPosition)
        task.wait(0.5)
    end
end

local function navigateToNearestOre()
    local humanoid = plr.Character.Humanoid
    local playerPos = root.Position
    local plrHeadPos = plr.Character.Head.Position
    local closestItem = findNearestItem()
    local targetPos = nil

    if closestItem then
        if closestItem:IsA("MeshPart") then
            targetPos = closestItem.Position
        elseif closestItem:IsA("Tool") and closestItem:FindFirstChild("Handle") then
            targetPos = closestItem.Handle.Position
        end
    else
        local radius = 50
        local randomAngle = math.random() * 2 * math.pi
        local randomDistance = math.random(20, radius)
        targetPos = playerPos + Vector3.new(math.cos(randomAngle) * randomDistance, 0, math.sin(randomAngle) * randomDistance)
    end

    if targetPos then
        if closestItem then
            local rayOrigin = plrHeadPos
            local rayDirection = targetPos - plrHeadPos
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {plr.Character, items}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

            if not raycastResult then
                local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
                local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
                tween:Play()
                tween.Completed:Wait()
            end
        else
            local path = PathfindingService:CreatePath({
                AgentRadius = 7,
                AgentHeight = 9.5,
                AgentCanJump = true,
                Costs = {}
            })

            local success, errorMessage = pcall(function()
                path:ComputeAsync(root.Position, targetPos)
            end)

            if success and path.Status == Enum.PathStatus.Success then
                for _, waypoint in ipairs(path:GetWaypoints()) do
                    if not plr.Character or not plr.Character.Humanoid then
                        break
                    end
                    humanoid:MoveTo(waypoint.Position)
                    local reached = humanoid.MoveToFinished:Wait(2)
                    if waypoint.Action == Enum.PathWaypointAction.Jump then
                        humanoid.Jump = true
                    end
                end
            else
                humanoid:MoveTo(targetPos)
            end
        end
    end
    task.wait(0.1)
end

local function CollectOres()
    local miningNetwork = ReplicatedStorage:FindFirstChild("shared/network/MiningNetwork@GlobalMiningEvents")
    local collectItem = miningNetwork and miningNetwork:FindFirstChild("CollectItem")

    while ColOres do
        if CollectMode == "Legit" then
            navigateToNearestOre()
        else
            local items = items:GetChildren()
            if #items > 0 then
                for _, item in ipairs(items) do
                    if not ColOres then
                        break
                    end
                    local success, err = pcall(function()
                        collectItem:FireServer(item.Name)
                    end)
                    if not success then
                        warn("Error collecting item:", err)
                    end
                    task.wait(CollectSpeed)
                end
            end
        end
        task.wait()
    end
end

local function SellInventory()
    if not tradertomPos then
        OrionLib:MakeNotification({
            Name = "Auto Sell Failed",
            Content = "Could not find trader tom's position, retrying search.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        findtradertom()
        if not tradertomPos then
            return
        end
    end

    local success, err = pcall(function()
        local lastPos = root.Position
        root.CFrame = CFrame.new(tradertomPos)
        task.wait(0.5)
        ReplicatedStorage.Ml.SellInventory:FireServer()
        task.wait(0.5)
        root.CFrame = CFrame.new(lastPos)
    end)

    if not success then
        OrionLib:MakeNotification({
            Name = "Auto Sell Failed",
            Content = err,
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end

-- Tab Elements --

-- Mining --
AutoMineToggle = MineTab:AddToggle({Name = "Auto Mine",  Default = false,  Callback = function(bool)
    AutoMine = bool
    if AutoMine then
        if MiningStrength then
            MiningThread = task.spawn(MineOres)
            OrionLib:MakeNotification({
                Name = "Auto Mining",
                Content = "Auto mining is now active.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Mining Strength Missing!",
                Content = "Please set the mining strength first.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            AutoMine = false
            AutoMineToggle:Set(false)
        end
    else
        if MiningThread then
            task.cancel(MiningThread)
            MiningThread = nil
            OrionLib:MakeNotification({
                Name = "Auto Mining",
                Content = "Auto mining has been disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

MineTab:AddToggle({Name = "Auto Drill (REQUIRES ANY DRILL)",  Default = false,  Callback = function(bool)
    AutoDrill = bool
    if AutoDrill then
        DrillingThread = task.spawn(MineOresDrill)
        OrionLib:MakeNotification({
            Name = "Auto Drill",
            Content = "Auto drill is now active.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if DrillingThread then
            task.cancel(DrillingThread)
            DrillingThread = nil
            OrionLib:MakeNotification({
                Name = "Auto Drill",
                Content = "Auto drill has been disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

MineTab:AddToggle({Name = "Auto Dynamite (REQUIRES ANY DYNAMITE)",  Default = false,  Callback = function(bool)
    AutoDynamite = bool
    if AutoDynamite then
        DynamiteThread = task.spawn(UseDynamite)
        OrionLib:MakeNotification({
            Name = "Auto Dynamite",
            Content = "Auto dynamite is now active.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if DynamiteThread then
            task.cancel(DynamiteThread)
            DynamiteThread = nil
            OrionLib:MakeNotification({
                Name = "Auto Dynamite",
                Content = "Auto dynamite has been disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

MineTab:AddDropdown({
    Name = "Mining Strength", 
    Default = "Max", 
    Options = {"Max", "Good", "Decent", "Bad"}, 
    Callback = function(Value)
        if Value == "Max" then
            MiningStrength = 1
        elseif Value == "Good" then
            MiningStrength = 0.8
        elseif Value == "Decent" then
            MiningStrength = 0.7
        elseif Value == "Bad" then
            MiningStrength = 0.6
        end
        if AutoMine then
            if MiningThread then
                task.cancel(MiningThread)
            end
            MiningThread = task.spawn(MineOres)
        end
    end
})

MineTab:AddDropdown({
    Name = "Mining Direction", 
    Default = "Camera", 
    Options = {"Camera", "Random", "Towards Ores"}, 
    Callback = function(Value)
        MiningDir = Value
    end
})

MineTab:AddToggle({Name = "Collect Ores",  Default = false,  Callback = function(bool)
    ColOres = bool
    if ColOres then
        OresThread = task.spawn(CollectOres)
        OrionLib:MakeNotification({
            Name = "Collecting Ores",
            Content = "Auto Ore Collecting is now active. (Might cause lag bcuz game bad lol)",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if OresThread then
            task.cancel(OresThread)
            OresThread = nil
            OrionLib:MakeNotification({
                Name = "Collecting Ores",
                Content = "Auto Ore Collecting is now disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

MineTab:AddDropdown({
    Name = "Collect Speed",
    Default = "Slow",
    Options = {"Instant (LAG)", "Fast", "Slow"},
    Callback = function(Value)
        if Value == "Instant (LAG)" then
            CollectSpeed = 0
        elseif Value == "Fast" then
            CollectSpeed = 0.125
        elseif Value == "Slow" then
            CollectSpeed = 0.5
        end
    end
})

MineTab:AddDropdown({
    Name = "Collect Mode",
    Default = "Legit",
    Options = {"Always", "Legit"},
    Callback = function(Value)
        CollectMode = Value
    end
})

MineTab:AddButton({Name = "Sell Everything", Callback = function()
    SellInventory()
end})

MineTab:AddButton({Name = "Equip Best Items (USE SCRIPT'S MINING)", Callback = function()
    local EquipItem = ReplicatedStorage.Ml.EquipItem
    EquipItem:FireServer("Dragon Pickaxe")
    task.wait(2)
    EquipItem:FireServer("Ruby Drill")
    task.wait(2)
    EquipItem:FireServer("Toxic Dynamite")
end})

-- Teleport --
TeleportTab:AddLabel("Teleports")

TeleportTab:AddButton({Name = "Forest", Callback = function()
    local targetPos = Vector3.new(998, 245, -71)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Mine Passage", Callback = function()
    local targetPos = Vector3.new(1020, 181, -1451)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Crystal Cave", Callback = function()
    local targetPos = Vector3.new(1011, 177, -2910)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Merchant Mike (Ores)", Callback = function()
    local targetPos = Vector3.new(1043, 245, -198)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Driller Dan (Drills)", Callback = function()
    local targetPos = Vector3.new(906, 245, -454)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Sally (Pickaxes)", Callback = function()
    local targetPos = Vector3.new(1054, 245, -283)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Bob (Radars)", Callback = function()
    local targetPos = Vector3.new(1085, 245, -468)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddButton({Name = "Miner Mike (Offline)", Callback = function()
    local targetPos = Vector3.new(954, 245, -222)
    root.CFrame = CFrame.new(targetPos)
end})

TeleportTab:AddLabel("Custom Teleports")

TeleportTab:AddButton({Name = "Set your own position", Callback = function()
    ownPos = root.Position
    OrionLib:MakeNotification({
        Name = "Teleport Set!",
        Content = "Successfully set teleport position.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end})

TeleportTab:AddButton({Name = "Teleport to your own position", Callback = function()
    if ownPos then
        root.CFrame = CFrame.new(ownPos)
    else
        OrionLib:MakeNotification({
            Name = "Teleport Failed!",
            Content = "Please set your position first.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end})

-- Shop --
ShopTab:AddParagraph("WARNING","If you try to buy something you already own here, you will WASTE MONEY.")

ShopTab:AddDropdown({Name = "Pickaxes", Options = {
"Rusty Pickaxe ($5)",
"Wooden Pickaxe ($250)",
"Stone Pickaxe ($1,350)",
"Iron Pickaxe ($5,000)",
"Emerald Pickaxe ($20,000)",
"Sapphire Pickaxe ($40,000)",
"Ruby Pickaxe ($100,000)",
"Amethyst Pickaxe ($100,000)",
"Quartz Pickaxe ($500,000)",
"Citrine Pickaxe ($1,000,000)",
"Obsidian Pickaxe ($2,500,000)",
"Celestite Pickaxe ($5,000,000)",
"Frostbite Pickaxe ($6,000,000)",
"Sunfrost Pickaxe ($7,500,000)",
"Rosefrost Pickaxe ($9,000,000)",
"Shadowfrost Pickaxe ($12,500,000)"
}, Callback = function(Value)
	BuyItem:FireServer(string.gsub(Value, "%s%(%$[%d,]+%)", ""))
end})

ShopTab:AddDropdown({Name = "Radars", Options = {
"Copper Radar ($50)",
"Iron Radar ($500)",
"Gold Radar ($1,500)",
"Diamond Radar ($4,000)",
"Emerald Radar ($20,000)",
"Sapphire Radar ($40,000)",
"Ruby Radar ($70,000)",
"Amethyst Radar ($100,000)",
"Quartz Radar ($1,500,000)",
"Citrine Radar ($3,500,000)",
"Obsidian Radar ($5,000,000)",
"Celestite Radar ($7,000,000)",
"Frostbite Radar ($7,000,000)",
"Sunfrost Radar ($8,500,000)",
"Rosefrost Radar ($10,000,000)",
"Shadowfrost Radar ($13,000,000)"
}, Callback = function(Value)
	BuyItem:FireServer(string.gsub(Value, "%s%(%$[%d,]+%)", ""))
end})

ShopTab:AddDropdown({Name = "Drills", Options = {
"Weak Drill ($25,000)",
"Light Drill ($50,000)",
"Heavy Drill ($250,000)"
}, Callback = function(Value)
	BuyItem:FireServer(string.gsub(Value, "%s%(%$[%d,]+%)", ""))
end})

ShopTab:AddDropdown({Name = "Dynamites", Options = {
"Light Dynamite ($600,000)",
"Heavy Dynamite ($1,000,000)"
}, Callback = function(Value)
	BuyItem:FireServer(string.gsub(Value, "%s%(%$[%d,]+%)", ""))
end})

-- Misc --
MiscTab:AddLabel("Join our (dsc.gg/dyhub)")

MiscTab:AddToggle({Name = "Instant Proximity Prompt",  Default = false,  Callback = function(bool)
    if bool then
        if fireproximityprompt then
            PromptButtonHoldBegan = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
        else
            OrionLib:MakeNotification({
                Name = "Incompatible Exploit",
                Content = "Your exploit is incompatible with fireproximityprompt.",
                Image = "rbxassetid://4483345998",
                Time = 6
            })
        end
    else
        if PromptButtonHoldBegan then
            PromptButtonHoldBegan:Disconnect()
            PromptButtonHoldBegan = nil
        end
    end
end})

MiscTab:AddSlider({Name = "Walkspeed", Min = 16, Max = 200, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1, Callback = function(Value)
    pcall(function()
        getgenv().desiredWalkSpeed = Value
    end)
end})

MiscTab:AddButton({Name = "Remove Fog", Callback = function()
	Lighting.FogEnd = 10000
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
end})

MiscTab:AddButton({
    Name = "Full Bright",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end
})

OrionLib:Init()
