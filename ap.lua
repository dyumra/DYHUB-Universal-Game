if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game.Workspace
local Players = game.Players
local player = Players.LocalPlayer

-- anti afk
spawn(function()
    while true do
        VirtualInputManager:SendKeyEvent(true, 101, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, 101, false, game)
        task.wait(120)
    end
end)

local Window = Fluent:CreateWindow({
    Title = "DYHUB | Anime Power",
    SubTitle = "dsc.gg/dyhub",
    TabWidth = 100,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Infos = Window:AddTab({ Title = "Infos", Icon = "info" }),
    Setup = Window:AddTab({ Title = "Setup", Icon = "banana" }),
    Main = Window:AddTab({ Title = "Main", Icon = "loader" }),
    Tower = Window:AddTab({ Title = "Tower", Icon = "archive" }),
    Defense = Window:AddTab({ Title = "Defense", Icon = "shield" }), 
    Raid = Window:AddTab({ Title = "Raid", Icon = "swords" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "sword" }),
    Quests = Window:AddTab({ Title = "Quests", Icon = "check" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Roll = Window:AddTab({ Title = "Roll", Icon = "egg" }),
    Upgrades = Window:AddTab({ Title = "Upgrades", Icon = "arrow-up-circle" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),

}

getgenv().Settings = {
    DefaultDelay = 0.5,
    MinDelay = 0.2,
    MaxDelay = 5
}

local worldList = {
    "shinobi world",
    "boar tavern",
    "namek",
    "sky lands",
    "shadows city",
    "cursed school",
    "skull island",
    "fortified city",
    "town of beginnings",
    "hollow invasion",
    "golden dunes",
    "a city",
    "infinity castle",
    "combustion district",
    "ant nest",
    "tokyo",
    "nordic saga",
    "blue key",
    "castle town",
    "slime reincarnation",
    "babylon",
    "kaiju city",
    "cursed shed"
}

local mobList = {
    ["shinobi world"] = {
        "zaruka",
        "madaha",
        "risane",
        "nagaco",
        "itaki",
        "tony"
    },
    ["boar tavern"] = {
        "knight",
        "thunder knight",
        "fraudim",
        "toxinia",
        "estaroza",
        "demon king"
    },
    ["namek"] = {
        "geko black",
        "frooze",
        "golden frooze",
        "boo",
        "peccole",
        "jeren"
    },
    ["sky lands"] = {
        "kome",
        "marco",
        "buggy",
        "leopard",
        "kobi",
        "edwerd"
    },
    ["shadows city"] = {
        "fang",
        "lenhart",
        "denzoo",
        "giant monarch",
        "niris",
        "daru"
    },
    ["cursed school"] = {
        "white",
        "honami",
        "mohite",
        "jego",
        "toko",
        "sokona"
    },
    ["skull island"] = {
        "sorceress",
        "scarlet queen",
        "dark empress",
        "shadow prince",
        "obsidian warrior",
        "king solaris",
    },
    ["fortified city"] = {
        "soucha",
        "ranger",
        "female titan",
        "titan bo",
        "armon",
        "colosso"
    },
    ["town of beginnings"] = {
        "rassago",
        "bercou",
        "argoh",
        "iuma",
        "kinela",
        "kaiada"
    },
    ["hollow invasion"] = {
        "ororibashi",
        "eier",
        "grimjol",
        "thwach",
        "aizan",
        "alquiorra"
    },
    ["golden dunes"] = {
        "nagent oagent",
        "lisco",
        "bot lants",
        "pololoco",
        "axb lo",
        "nountain cim"
    },
    ["a city"] = {
        "sound soc",
        "vaccina",
        "xarou",
        "sea king",
        "boras",
        "cosmic fear"
    },
    ["infinity castle"] = {
        "daki",
        "tyutaro",
        "tohakuten",
        "araza",
        "louma",
        "lokushibo"
    },
    ["combustion district"] = {
        "agun",
        "joker",
        "sha gusakabe",
        "nontgomery",
        "kenimaru chinmon",
        "god shinla",
    },
    ["ant nest"] = {
        "shiruku",
        "galluto",
        "riroka",
        "lhrollo",
        "kerfepitou",
        "meluem"
    },
    ["tokyo"] = {
        "ura",
        "nara",
        "nari",
        "rakizawa",
        "aman",
        "ero coshimura"
    },
    ["nordic saga"] = {
        "blefer",
        "leaf",
        "shain",
        "loki",
        "angry",
        "mad",
    },
    ["blue key"] = {
        "kailer",
        "noa",
        "otola",
        "kunimari",
        "sare",
        "kare"
    },
    ["castle town"] = {
        "malti",
        "host orai",
        "sin",
        "ren",
        "lito",
        "rojo"
    },
    ["slime reincarnation"] = {
        "shizua",
        "valente",
        "milium",
        "veldahanva",
        "diabli",
        "guu"
    },
    ["babylon"] = {
        "nobuhaga",
        "jeana",
        "kirai",
        "jeana over",
        "archer",
        "ishrar"
    },
    ["kaiju city"] = {
        "kaiju",
        "kaija n100",
        "evolved kaiju",
        "red kaiju",
        "evolved kaija n100",
        "kaija n80"
    },
    ["cursed shed"] = {
        "ali",
        "mitala",
        "bider",
        "bomb woman",
        "katana",
        "saw man dark"
    }
}

local lineages = {
    "demon",
    "giant",
    "monkey",
    "shark",
    "bunny",
    "angel",
    "dragon"
}

local haki = {
    "green",
    "yellow",
    "pink",
    "purple",
    "blue",
    "reddish orange",
    "shadow",
    "rainbow"
}

local titles = {
    "beginner",
    "shinobi",
    "sin",
    "saiya",
    "pirate",
    "shadow monarch",
    "absolute being",
    "sukazen",
    "gokai",
    "titan",
    "dual blade warrior",
    "soul hunter",
    "bizarre hunter",
    "the strongest man",
    "flame pillar",
    "infernum",
    "king of ants",
    "ghoul",
    "thor",
    "soccer player",
    "shield hero",
    "demonic slime",
    "king of heroes",
    "collector",
    "chainsaw"
}

local shadowBosses = {
    "keru",
    "tris",
    "iron",
    "tank"
}

local grimoires = {
    "wind",
    "light",
    "ice",
    "flame",
    "time",
    "anti magic",
    "sacred"
}

_G.currentWorld = function()
    local world = Workspace:FindFirstChild("currentWorld")
    if world and world:GetChildren()[1] then
        return world:GetChildren()[1].Name
    end
    return nil
end

local Options = Fluent.Options

_G.GetPlayerRoot = function()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

_G.FireRemote = function(eventName)
    local args = { [1] = eventName }
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

_G.FireRemoteTwoArg = function(eventName, arg2)
    local args = { [1] = eventName, [2] = arg2 }
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

_G.FireRemoteThreeArg = function(eventName, arg2, arg3)
    local args = { [1] = eventName, [2] = arg2, [3] = arg3 }
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

_G.FindNearestMob = function(worldName, mobNames, playerRoot)
    local nearestPart = nil
    local shortestDistance = math.huge
    local worldFolder = Workspace.spawners:FindFirstChild(worldName)

    if not worldFolder then
        return nil, math.huge
    end

    for _, part in pairs(worldFolder:GetChildren()) do
        if part:IsA("BasePart") then
            local enemyType = part:GetAttribute("enemyType")
            local health = part:GetAttribute("health")
            if enemyType and health and health > 0 then
                for mobName, _ in pairs(mobNames) do
                    if enemyType == mobName then
                        local distance = (playerRoot.Position - part.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPart = part
                        end
                        break
                    end
                end
            end
        end
    end

    return nearestPart, shortestDistance
end

_G.FindNearestTowerMob = function(playerRoot)
    local nearestPart = nil
    local shortestDistance = math.huge
    local towerFolder = Workspace.spawners:FindFirstChild("tower")

    if not towerFolder then
        return nil, math.huge
    end

    for _, part in pairs(towerFolder:GetChildren()) do
        if part:IsA("BasePart") then
            local health = part:GetAttribute("health")
            if health and health > 0 then
                local distance = (playerRoot.Position - part.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPart = part
                end
            end
        end
    end

    return nearestPart, shortestDistance
end

_G.GetSecondsUntilNextTowerOpening = function()
    local currentTime = os.date("*t")
    local currentHour = currentTime.hour
    local currentMinute = currentTime.min
    local currentSecond = currentTime.sec
    
    local nextOpeningMinute
    
    if currentMinute < 30 then
        nextOpeningMinute = 30
    else
        nextOpeningMinute = 0
    end
    
    local secondsUntilOpening
    
    if nextOpeningMinute == 30 then
        secondsUntilOpening = (30 - currentMinute) * 60 - currentSecond
    else
        secondsUntilOpening = (60 - currentMinute) * 60 - currentSecond
    end
    
    if secondsUntilOpening <= 0 then
        secondsUntilOpening = 3600
    end
    
    return secondsUntilOpening
end

_G.GetCurrentTowerFloor = function()
    local floorLabelPath = player.PlayerGui:FindFirstChild("Interface")
                         and player.PlayerGui.Interface:FindFirstChild("tower")
                         and player.PlayerGui.Interface.tower:FindFirstChild("floor")
                         and player.PlayerGui.Interface.tower.floor:FindFirstChild("label")

    if floorLabelPath then
        local floorText = floorLabelPath.Text
        local floorNumberStr = floorText:match("Floor (%d+)")
        if floorNumberStr then
            return tonumber(floorNumberStr)
        end
    end
    return nil
end


-- this does not work as intended
_G.AutoTowerLoop = function()
    local priority = Options.AutomationPriority.Value
    local inRaid = player:GetAttribute("inRaid")
    local inDungeon = player:GetAttribute("inDungeon")
    local inDefense = player:GetAttribute("inDefense")

    if inRaid and priority == "Raid First" then
        while player:GetAttribute("inRaid") and Options.AutoTower.Value do task.wait(1) end
    elseif inDungeon and priority == "Dungeon First" then
        while player:GetAttribute("inDungeon") and Options.AutoTower.Value do task.wait(1) end
    elseif inDefense and priority == "Defense First" then
        while player:GetAttribute("inDefense") and Options.AutoTower.Value do task.wait(1) end
    end

    if not Options.AutoTower.Value then return end

    if not _G.SavedWorldPosition then
        Fluent:Notify({ Title = "Warning", Content = "No saved position for Tower. Saving current.", Duration = 5 })
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            _G.SavedWorldPosition = rootPart.CFrame
            _G.SavedWorld = _G.currentWorld()
            Fluent:Notify({ Title = "Position Saved", Content = "Position saved for Tower return.", Duration = 3 })
            _G.UpdateSavedPositionButtons()
        else
            Fluent:Notify({ Title = "Error", Content = "Could not save position for Tower.", Duration = 3 })
            Options.AutoTower:SetValue(false)
            return
        end
    elseif not _G.SavedWorld then
        _G.SavedWorld = _G.currentWorld()
    end

    local wasInTower = false
    local portalPath

    local success, err = pcall(function()
        while Options.AutoTower.Value do
            inRaid = player:GetAttribute("inRaid")
            inDungeon = player:GetAttribute("inDungeon")
            inDefense = player:GetAttribute("inDefense")
            priority = Options.AutomationPriority.Value

            if (inRaid and priority == "Raid First") or
               (inDungeon and priority == "Dungeon First") or
               (inDefense and priority == "Defense First") then
                 _G.isAttemptingTowerEntry = false
                 task.wait(2)
                 continue
            end

            local rootPart = _G.GetPlayerRoot()
            local inTower = player:GetAttribute("inTower")

            if wasInTower and not inTower then
                _G.isAttemptingTowerEntry = false
                if not player:GetAttribute("justLeftTowerByFloor") then
                else
                    player:SetAttribute("justLeftTowerByFloor", nil)
                end

                if _G.SavedWorld and _G.SavedWorldPosition then
                     _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                     task.wait(2)
                     rootPart = _G.GetPlayerRoot()
                     if rootPart then
                         rootPart.CFrame = _G.SavedWorldPosition
                         task.wait(0.5)
                     end
                end
                wasInTower = false
            end

            if not inTower then
                 _G.isAttemptingTowerEntry = false
                local secondsToWait = _G.GetSecondsUntilNextTowerOpening()
                local currentTime = os.date("*t")
                local minutesToWait = math.floor(secondsToWait / 60)
                local remainingSeconds = secondsToWait % 60
                
                local nextOpeningTime
                if currentTime.min < 30 then
                    nextOpeningTime = string.format("%02d:30:00", currentTime.hour)
                else
                    local nextHour = (currentTime.hour + 1) % 24
                    nextOpeningTime = string.format("%02d:00:00", nextHour)
                end
                
                Fluent:Notify({ 
                    Title = "Tower", 
                    Content = string.format("Next opening: %s (%d min and %d seg)", 
                        nextOpeningTime, minutesToWait, remainingSeconds), 
                    Duration = 5 
                })

                while secondsToWait > 0 and Options.AutoTower.Value do
                    task.wait(1)
                    secondsToWait = secondsToWait - 1
                    inRaid = player:GetAttribute("inRaid")
                    inDungeon = player:GetAttribute("inDungeon")
                    inDefense = player:GetAttribute("inDefense")
                    priority = Options.AutomationPriority.Value
                    if (inRaid and priority == "Raid First") or
                       (inDungeon and priority == "Dungeon First") or
                       (inDefense and priority == "Defense First") then
                         break
                    end
                    if secondsToWait % 30 == 0 and secondsToWait > 0 then
                        local minutesLeft = math.floor(secondsToWait / 60)
                        local secondsLeft = secondsToWait % 60
                        Fluent:Notify({ 
                            Title = "Tower", 
                            Content = string.format("%d min and %d seg until next opening", 
                                minutesLeft, secondsLeft), 
                            Duration = 3 
                        })
                    end
                end

                if secondsToWait > 0 and ( (inRaid and priority == "Raid First") or (inDungeon and priority == "Dungeon First") or (inDefense and priority == "Defense First") ) then
                    continue
                end

                if not Options.AutoTower.Value then break end

                _G.isAttemptingTowerEntry = true

                if _G.currentWorld() ~= "town of beginnings" then
                    _G.FireRemoteTwoArg("teleportToWorld", "town of beginnings")
                    task.wait(3)
                    if not Options.AutoTower.Value then _G.isAttemptingTowerEntry = false; break end
                end

                rootPart = _G.GetPlayerRoot()
                if not rootPart then
                    _G.isAttemptingTowerEntry = false
                    task.wait(5)
                    continue
                end

                portalPath = Workspace.currentWorld:FindFirstChild("town of beginnings") and Workspace.currentWorld["town of beginnings"]:FindFirstChild("elements") and Workspace.currentWorld["town of beginnings"].elements:FindFirstChild("towerPortal") and Workspace.currentWorld["town of beginnings"].elements.towerPortal:FindFirstChild("Part")

                if portalPath then
                    rootPart.CFrame = portalPath.CFrame * CFrame.new(0, 2, 0)
                    task.wait(1.5)
                    if not Options.AutoTower.Value then _G.isAttemptingTowerEntry = false; break end

                    inTower = player:GetAttribute("inTower")
                    if inTower then
                         _G.isAttemptingTowerEntry = false
                         wasInTower = true
                    else
                        _G.isAttemptingTowerEntry = false
                        task.wait(5)
                    end
                else
                    _G.isAttemptingTowerEntry = false
                    task.wait(10)
                end

            elseif inTower then
                 _G.isAttemptingTowerEntry = false
                 wasInTower = true
                 rootPart = _G.GetPlayerRoot()
                 if rootPart then
                    local leaveFloorTarget = Options.LeaveOnFloor.Value
                    if leaveFloorTarget ~= "None" then
                        local currentFloor = _G.GetCurrentTowerFloor()
                        if currentFloor then
                            local targetFloorNum = tonumber(leaveFloorTarget)
                            if targetFloorNum and currentFloor >= targetFloorNum then
                                Fluent:Notify({ Title = "Tower", Content = "Reached target floor " .. leaveFloorTarget .. ". Leaving...", Duration = 4 })
                                player:SetAttribute("justLeftTowerByFloor", true)
                                _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                                task.wait(2)
                                continue
                            end
                        end
                    end
                    local nearestPart, distance = _G.FindNearestTowerMob(rootPart)
                    if nearestPart then
                        local targetPos = nearestPart.Position - Vector3.new(1, 0, -5)
                        if distance > 4 then
                            rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                        end
                        task.wait(Options.AutoFarmDelaySlider.Value)
                    else
                        task.wait(0.5)
                    end
                 else
                     task.wait(1)
                 end
            end

            task.wait(0.1)
        end
    end)

    _G.isAttemptingTowerEntry = false
    if not success then
        warn("Error in AutoTowerLoop:", err)
    end
end

_G.FindNearestDefenseMob = function(playerRoot)
    local nearestPart = nil
    local shortestDistance = math.huge
    local defenseFolder = Workspace.spawners:FindFirstChild("defense")

    if not defenseFolder then
        return nil, math.huge
    end

    for _, part in pairs(defenseFolder:GetChildren()) do
        if part:IsA("BasePart") then
            local health = part:GetAttribute("health")
            if health and health > 0 then
                local distance = (playerRoot.Position - part.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPart = part
                end
            end
        end
    end

    return nearestPart, shortestDistance
end

_G.AutoDefenseLoop = function()
    local priority = Options.AutomationPriority.Value
    local inRaid = player:GetAttribute("inRaid")
    local inDungeon = player:GetAttribute("inDungeon")
    local inTower = player:GetAttribute("inTower")

    if inRaid and priority == "Raid First" then
        Fluent:Notify({ Title = "Priority", Content = "Raid is active and has priority. Defense will wait.", Duration = 3 })
        while player:GetAttribute("inRaid") and Options.AutoDefense.Value do
            task.wait(1)
        end
    elseif inDungeon and priority == "Dungeon First" then
         Fluent:Notify({ Title = "Priority", Content = "Dungeon is active and has priority. Defense will wait.", Duration = 3 })
        while player:GetAttribute("inDungeon") and Options.AutoDefense.Value do
            task.wait(1)
        end
    elseif inTower and priority == "Tower First" then
        Fluent:Notify({ Title = "Priority", Content = "Tower is active and has priority. Defense will wait.", Duration = 3 })
        while player:GetAttribute("inTower") and Options.AutoDefense.Value do
            task.wait(1)
        end
    end

    if not _G.SavedWorldPosition then
        Fluent:Notify({ Title = "Warning", Content = "No saved position found for Defense. Please save your position first!", Duration = 5 })
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            _G.SavedWorldPosition = rootPart.CFrame
            _G.SavedWorld = _G.currentWorld()
            Fluent:Notify({ Title = "Position Saved", Content = "Current position automatically saved for Defense return.", Duration = 3 })
            _G.UpdateSavedPositionButtons()
        else
             Fluent:Notify({ Title = "Error", Content = "Could not save position for Defense.", Duration = 3 })
             Options.AutoDefense:SetValue(false)
             return
        end
    elseif not _G.SavedWorld then
         _G.SavedWorld = _G.currentWorld()
    end

    local difficulty = Options.DefenseDifficulty.Value
    local privacy = Options.DefensePrivacy.Value

    local defenseArgs = {
        ["privacy"] = privacy,
        ["difficult"] = difficulty
    }

    if Options.DefenseJoin.Value then
        _G.FireRemoteTwoArg("joinDefense")
        task.wait(3)
    end

    _G.FireRemoteTwoArg("startDefense", defenseArgs)
    task.wait(3)

    local wasInDefense = false

    while Options.AutoDefense.Value do
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            local isInDefense = player:GetAttribute("inDefense")

            if wasInDefense and not isInDefense then

                if _G.SavedWorld then
                    _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                    task.wait(2)
                    rootPart = _G.GetPlayerRoot()
                    if rootPart and _G.SavedWorldPosition then
                        rootPart.CFrame = _G.SavedWorldPosition
                        task.wait(0.5)
                    end
                end

                wasInDefense = false

                if Options.DefenseJoin.Value then
                    _G.FireRemoteTwoArg("joinDefense")
                    task.wait(3)
                end
                
                task.wait(2)
                _G.FireRemoteTwoArg("startDefense", defenseArgs)
                task.wait(5)
            end

            if isInDefense then
                wasInDefense = true
                local nearestPart, distance = _G.FindNearestDefenseMob(rootPart)

                if nearestPart then
                    local targetPos = nearestPart.Position - Vector3.new(1, 0, -5)
                    if distance > 4 then
                        rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                    end
                else
                    task.wait(0.5)
                end
            else
                 if not wasInDefense then

                    if Options.DefenseJoin.Value then
                        _G.FireRemoteTwoArg("joinDefense")
                        task.wait(3)
                    end
                     _G.FireRemoteTwoArg("startDefense", defenseArgs)
                     task.wait(5)
                 end
            end
        else
            task.wait(0.5)
        end

        task.wait()
    end
end


_G.FindNearestDungeonMob = function(dungeonMode, playerRoot)
    local nearestPart = nil
    local shortestDistance = math.huge
    local dungeonFolder = Workspace.spawners:FindFirstChild(dungeonMode)

    if not dungeonFolder then
        return nil, math.huge
    end

    for _, part in pairs(dungeonFolder:GetChildren()) do
        if part:IsA("BasePart") then
            local health = part:GetAttribute("health")
            if health and health > 0 then
                local distance = (playerRoot.Position - part.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPart = part
                end
            end
        end
    end

    return nearestPart, shortestDistance
end

_G.GetQuestMob = function()
    local questText = player.PlayerGui.Interface.hud.right.quests.world.info.Text
    local mobName = questText:match("Defeat %d+ (.+)!")
    if mobName then
        mobName = mobName:lower()
        local currentWorld = _G.currentWorld()
        if currentWorld and mobList[currentWorld] then
            for _, mob in pairs(mobList[currentWorld]) do
                if mob == mobName then
                    return mobName
                end
            end
        end
    end
    return nil
end

_G.AutoWorldQuestLoop = function()
    local lastQuestCheck = 0
    local cachedWorld = nil
    local cachedMob = nil

    while Options.AutoFarmWorldQuest.Value do
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            local currentTime = tick()
            if currentTime - lastQuestCheck >= 5 or not cachedMob then
                cachedWorld = _G.currentWorld()
                cachedMob = _G.GetQuestMob()
                lastQuestCheck = currentTime

                if cachedWorld and cachedMob then
                    local mobValid = false
                    for _, mob in pairs(mobList[cachedWorld] or {}) do
                        if mob == cachedMob then
                            mobValid = true
                            break
                        end
                    end

                    if mobValid then
                        _G.FireRemoteTwoArg("setQuest", cachedWorld)
                        Options.WorldDropdown:SetValue(cachedWorld)
                        Options.MobDropdown:SetValue({[cachedMob] = true})
                    else
                        Fluent:Notify({
                            Title = "Invalid Mob",
                            Content = "Quest mob " .. cachedMob .. " not found in " .. cachedWorld,
                            Duration = 3
                        })
                        task.wait(1)
                    end
                else
                    Fluent:Notify({
                        Title = "Quest Error",
                        Content = "Could not detect quest or current world!",
                        Duration = 3
                    })
                    task.wait(1)
                end
            end

            if cachedWorld and cachedMob and _G.currentWorld() == cachedWorld then
                local nearestPart, distance = _G.FindNearestMob(cachedWorld, {[cachedMob] = true}, rootPart)
                if nearestPart then
                    local targetPos = nearestPart.Position - Vector3.new(1, 0, 2)
                    if distance > 4 then
                        rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                    end
                end
            end
        else
            task.wait(0.5)
        end

        task.wait(Options.AutoFarmDelaySlider.Value)
    end
end

_G.AutoRollChampionsLoop = function()
    while Options.AutoRollChampions.Value do
        local currentWorld = _G.currentWorld()
        local rollType = Options.RollTypeDropdown.Value == "Single" and "one" or "multi"
        local args = {
            [1] = "rollChampion",
            [2] = rollType,
            [3] = currentWorld
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        task.wait(0.5)
    end
end

_G.AutoDungeonLoop = function(dungeonMode)
    local inRaid = player:GetAttribute("inRaid")
    local inDefense = player:GetAttribute("inDefense")
    local inTower = player:GetAttribute("inTower")
    local priority = Options.AutomationPriority.Value
    
    if inRaid and priority == "Raid First" then
        Fluent:Notify({
            Title = "Priority",
            Content = "Raid is active and has priority. Dungeon will wait.",
            Duration = 3
        })
        
        while player:GetAttribute("inRaid") and Options["Auto" .. dungeonMode:gsub("dungeon ", ""):gsub("^%l", string.upper) .. "Dungeon"].Value do
            task.wait(1)
        end
    elseif inDefense and priority == "Defense First" then
        Fluent:Notify({
            Title = "Priority",
            Content = "Defense is active and has priority. Dungeon will wait.",
            Duration = 3
        })

        while player:GetAttribute("inDefense") and Options["Auto" .. dungeonMode:gsub("dungeon ", ""):gsub("^%l", string.upper) .. "Dungeon"].Value do
            task.wait(1)
        end
    elseif inTower and priority == "Tower First" then
        Fluent:Notify({
            Title = "Priority",
            Content = "Tower is active and has priority. Dungeon will wait.",
            Duration = 3
        })

        while player:GetAttribute("inTower") and Options["Auto" .. dungeonMode:gsub("dungeon ", ""):gsub("^%l", string.upper) .. "Dungeon"].Value do
            task.wait(1)
        end
    end
    
    if not _G.SavedWorldPosition then
        Fluent:Notify({
            Title = "Warning",
            Content = "No saved position found. Please save your position first!",
            Duration = 5
        })
        
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            _G.SavedWorldPosition = rootPart.CFrame
            _G.SavedWorld = _G.currentWorld()
            Fluent:Notify({
                Title = "Position Saved",
                Content = "Current position automatically saved for dungeon return.",
                Duration = 3
            })
        end
    else
        if not _G.SavedWorld then
            _G.SavedWorld = _G.currentWorld()
        end
    end
    
    local args = {
        [1] = "joinDungeon",
        [2] = dungeonMode
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    
    task.wait(2)
    
    local wasInDungeon = false
    local lastRoom = 0

    while Options["Auto" .. dungeonMode:gsub("dungeon ", ""):gsub("^%l", string.upper) .. "Dungeon"].Value do
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            local currentWorld = _G.currentWorld()
            local inDungeon = player:GetAttribute("inDungeon")
            
            if wasInDungeon and not inDungeon then
                
                if _G.SavedWorld then
                    _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                    task.wait(2)
                    rootPart = _G.GetPlayerRoot()
                    if rootPart and _G.SavedWorldPosition then
                        rootPart.CFrame = _G.SavedWorldPosition
                    end
                end
                
                wasInDungeon = false
                lastRoom = 0
                
                local args = {
                    [1] = "joinDungeon",
                    [2] = dungeonMode
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                task.wait(5)
            end
            
            if currentWorld == dungeonMode or inDungeon then
                wasInDungeon = true
                local currentRoom = _G.GetCurrentDungeonRoom()
                if currentRoom then
                    lastRoom = currentRoom
                end
                
                local leaveRoom = Options.LeaveOnRoom.Value
                
                if currentRoom and leaveRoom ~= "None" and tonumber(currentRoom) >= tonumber(leaveRoom) then
                    _G.FireRemote("leaveDungeon")
                    task.wait(3)
                    
                    if _G.SavedWorld then
                        _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                        task.wait(2)
                        rootPart = _G.GetPlayerRoot()
                        if rootPart then
                            rootPart.CFrame = _G.SavedWorldPosition
                        end
                    end
                    
                    wasInDungeon = false
                    lastRoom = 0
                    
                    local args = {
                        [1] = "joinDungeon",
                        [2] = dungeonMode
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    task.wait(5)
                end
                
                local nearestPart, distance = _G.FindNearestDungeonMob(dungeonMode, rootPart)
                if nearestPart then
                    local targetPos = nearestPart.Position - Vector3.new(1, 0, -5)
                    if distance > 4 then
                        rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                    end
                else
                    task.wait(0.5)
                end
            else
                local args = {
                    [1] = "joinDungeon",
                    [2] = dungeonMode
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                task.wait(2)
            end
        else
            task.wait(0.5)
        end
        
        task.wait()
    end
end

_G.GetEquippedTitle = function()
    local character = Workspace:FindFirstChild("characters") and Workspace.characters:FindFirstChild(player.Name)
    if character and character:FindFirstChild("player") and character.player:FindFirstChild("title") then
        local titleText = character.player.title.Text
        return titleText and titleText:lower() or nil
    end
    return nil
end

_G.AutoBuyTitleLoop = function()
    local maxTitles = #titles

    while Options.AutoBuyTitle.Value do
        local equippedTitle = _G.GetEquippedTitle()
        local currentIndex = 0

        if equippedTitle then
            for i, title in ipairs(titles) do
                if title == equippedTitle then
                    currentIndex = i
                    break
                end
            end
        end

        local nextTitleIndex = currentIndex + 1

        if nextTitleIndex > maxTitles then
            Options.AutoBuyTitle:SetValue(false)
            break
        end

        local buyArgs = {
            [1] = "buyTitle",
            [2] = nextTitleIndex
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(buyArgs))

        task.wait(0.5)

        local equipArgs = {
            [1] = "equipTitle",
            [2] = nextTitleIndex
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("events"):WaitForChild("RemoteEvent"):FireServer(unpack(equipArgs))

        local newEquippedTitle = _G.GetEquippedTitle()
        if newEquippedTitle == titles[nextTitleIndex] then
        else
            task.wait(5) 
        end

        task.wait(1) 
    end
end

_G.AutoFarmLoop = function()
    while Options.AutoFarm.Value do
        if _G.isAttemptingTowerEntry then
            task.wait(0.5)
            continue
        end

        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            local selectedWorld = Options.WorldDropdown.Value
            local selectedMobs = Options.MobDropdown.Value
            local currentWorld = _G.currentWorld()
            local inRaid = player:GetAttribute("inRaid")
            local inDungeon = player:GetAttribute("inDungeon")
            local inDefense = player:GetAttribute("inDefense")
            local inTower = player:GetAttribute("inTower")
            local priority = Options.AutomationPriority.Value

            if (inRaid and priority == "Raid First") or
               (inDungeon and priority == "Dungeon First") or
               (inDefense and priority == "Defense First") or
               (inTower and priority == "Tower First") then
                 task.wait(1)
                 continue
            else
                if selectedWorld and currentWorld == selectedWorld then
                    if selectedMobs and type(selectedMobs) == "table" and next(selectedMobs) ~= nil then
                        local nearestPart, distance = _G.FindNearestMob(selectedWorld, selectedMobs, rootPart)
                        if nearestPart then
                            local targetPos = nearestPart.Position - Vector3.new(1, 0, 2)
                            if distance > 4 then
                                rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                            end
                        end
                    end
                else
                    if _G.SavedWorldPosition then
                        if currentWorld ~= selectedWorld then
                             if not inRaid and not inDungeon and not inDefense and not inTower then
                                 _G.FireRemoteTwoArg("teleportToWorld", selectedWorld)
                                 task.wait(2)
                             else
                                 task.wait(1)
                             end
                        end
                    else
                        task.wait(1)
                    end
                end
            end
        else
            task.wait(0.5)
        end

        task.wait(Options.AutoFarmDelaySlider.Value)
    end
end

_G.AutoCollectLoop = function()
    local collectRadius = 200 

    while Options.AutoCollect.Value do
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            local dropsCollected = {}
            
            for _, drop in pairs(Workspace.temp:GetChildren()) do
                if drop:IsA("Part") and drop.CollisionGroup == "drops" then
                    local distance = (rootPart.Position - drop.Position).Magnitude
                    
                    if distance <= collectRadius then
                        table.insert(dropsCollected, drop.Name)
                        
                        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tween = game:GetService("TweenService"):Create(drop, tweenInfo, {
                            Position = rootPart.Position
                        })
                        
                        tween:Play()
                        tween.Completed:Connect(function()
                            pcall(function() 
                                drop:Destroy() 
                            end)
                        end)
                    end
                end
            end
            
            if #dropsCollected > 0 then
                task.wait(0.5)
            else
                task.wait(1)
            end
        else
            task.wait(0.5) 
        end
    end
end

_G.AutoGemQuestLoop = function()
    while Options.AutoGemQuest.Value do
        _G.FireRemoteTwoArg("setQuest", "gemsQuest")
        task.wait(10)
    end
end

_G.AutoQuestLoop = function()
    while Options.AutoQuest.Value do
        _G.FireRemoteTwoArg("setQuest", _G.currentWorld())
        task.wait(10)
    end
end

_G.AutoEvolveLoop = function()
    while Options.AutoEvolve.Value do
        _G.FireRemote("evolveAbility")
        task.wait(10)
    end
end

_G.AutoRollLineagesLoop = function()
    local selectedLineages = Options.LineageDropdown.Value
    local currentLineage = player:GetAttribute("lineage")

    if selectedLineages and currentLineage and selectedLineages[currentLineage] then
        Options.AutoRollLineages:SetValue(false)
        return
    end

    while Options.AutoRollLineages.Value do
        _G.FireRemote("rollLineages")
        _G.FireRemote("rollLineage")

        currentLineage = player:GetAttribute("lineage")
        if selectedLineages and currentLineage and selectedLineages[currentLineage] then
            Options.AutoRollLineages:SetValue(false)
            break
        end

        task.wait(0.1)
    end
end

_G.AutoRollHakiLoop = function()
    local selectedHakis = Options.HakiDropdown.Value
    local currentHaki = player:GetAttribute("haki")
    local currentHakiColor = currentHaki and currentHaki:match("^([^%.]+)")

    if selectedHakis and currentHakiColor and selectedHakis[currentHakiColor] then
        Options.AutoRollHaki:SetValue(false)
        return
    end

    while Options.AutoRollHaki.Value do
        _G.FireRemote("rollHakis")

        currentHaki = player:GetAttribute("haki")
        currentHakiColor = currentHaki and currentHaki:match("^([^%.]+)") 
        if selectedHakis and currentHakiColor and selectedHakis[currentHakiColor] then
            Options.AutoRollHaki:SetValue(false)
            break
        end

        task.wait(0.1)
    end
end

_G.AutoRollGrimoireLoop = function()
    local selectedGrimoire = Options.GrimoireDropdown.Value
    local currentGrimoire = player:GetAttribute("grimoire")

    if selectedGrimoire and currentGrimoire and selectedGrimoire[currentGrimoire] then
        Options.AutoRollGrimoire:SetValue(false)
        return
    end

    while Options.AutoRollGrimoire.Value do
        _G.FireRemote("rollGrimoires")

        currentGrimoire = player:GetAttribute("grimoire")
        if selectedGrimoire and currentGrimoire and selectedGrimoire[currentGrimoire] then
            Options.AutoRollGrimoire:SetValue(false)
            break
        end

        task.wait(0.1)
    end
end

_G.GetCurrentDungeonRoom = function()
    local label = player.PlayerGui:WaitForChild("Interface"):WaitForChild("dungeon"):WaitForChild("room"):WaitForChild("label")
    local roomText = label.Text
    local roomNumber = roomText:match("Room (%d+)")
    return roomNumber and tonumber(roomNumber) or nil
end

_G.SavedWorldPosition = nil

local function createRoomList()
    local rooms = {"None"}
    for i = 1, 50 do
        table.insert(rooms, tostring(i))
    end
    return rooms
end

local function createWaveList()
    local waves = {"None"}
    for i = 1, 30 do
        table.insert(waves, tostring(i))
    end
    return waves
end

local function createFloorList()
    local floors = {"None"}
    for i = 1, 50 do
        table.insert(floors, tostring(i))
    end
    return floors
end

_G.AutoRaidLoop = function()
    local inDungeon = player:GetAttribute("inDungeon")
    local inDefense = player:GetAttribute("inDefense")
    local inTower = player:GetAttribute("inTower")
    local priority = Options.AutomationPriority.Value
    
    if inDungeon and priority == "Dungeon First" then
        Fluent:Notify({
            Title = "Priority",
            Content = "Dungeon is active and has priority. Raid will wait.",
            Duration = 3
        })
        while player:GetAttribute("inDungeon") and Options.AutoRaid.Value do
            task.wait(1)
        end
    elseif inDefense and priority == "Defense First" then
        Fluent:Notify({
            Title = "Priority",
            Content = "Defense is active and has priority. Raid will wait.",
            Duration = 3
        })
        while player:GetAttribute("inDefense") and Options.AutoRaid.Value do
            task.wait(1)
        end
    elseif inTower and priority == "Tower First" then
        Fluent:Notify({
            Title = "Priority",
            Content = "Tower is active and has priority. Raid will wait.",
            Duration = 3
        })
        while player:GetAttribute("inTower") and Options.AutoRaid.Value do
            task.wait(1)
        end
    end
    
    if not _G.SavedWorldPosition then
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            _G.SavedWorldPosition = rootPart.CFrame
            _G.SavedWorld = _G.currentWorld()
            Fluent:Notify({
                Title = "Position Saved",
                Content = "Current position automatically saved for raid return.",
                Duration = 3
            })
        end
    else
        if not _G.SavedWorld then
            _G.SavedWorld = _G.currentWorld()
        end
    end
    
    local wasInRaid = false
    local lastWave = 0
    local bossWaves = {5, 10, 15, 20, 25, 30}

    while Options.AutoRaid.Value do
        local rootPart = _G.GetPlayerRoot()
        if rootPart then
            local inRaid = Players.LocalPlayer:GetAttribute("inRaid")
            local raidWave = Workspace:GetAttribute("raidWave")
            
            if wasInRaid and not inRaid then
                
                if _G.SavedWorld then
                    _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                    task.wait(2)
                    rootPart = _G.GetPlayerRoot()
                    if rootPart and _G.SavedWorldPosition then
                        rootPart.CFrame = _G.SavedWorldPosition
                    end
                end
                
                wasInRaid = false
                lastWave = 0
            end
            
            if inRaid then
                wasInRaid = true
                if raidWave then
                    lastWave = raidWave
                    
                    local isBossWave = false
                    for _, wave in pairs(bossWaves) do
                        if raidWave == wave then
                            isBossWave = true
                            break
                        end
                    end
                    
                    local selectedBosses = Options.ShadowBossDropdown.Value
                    
                    if isBossWave then
                        local raidFolder = Workspace.spawners:FindFirstChild("raid")
                        local nearestPart = nil
                        local shortestDistance = math.huge
                        local shouldArise = false
                        
                        if raidFolder then
                            for _, part in pairs(raidFolder:GetChildren()) do
                                if part:IsA("BasePart") and part:GetAttribute("health") and part:GetAttribute("health") > 0 then
                                    local enemyType = part:GetAttribute("enemyType")
                                    local distance = (rootPart.Position - part.Position).Magnitude
                                    
                                    if enemyType and selectedBosses[enemyType] then
                                        shouldArise = true
                                        nearestPart = part
                                        shortestDistance = distance
                                        break
                                    elseif distance < shortestDistance then
                                        shortestDistance = distance
                                        nearestPart = part
                                    end
                                end
                            end
                        end
                        
                        if nearestPart then
                            local targetPos = nearestPart.Position - Vector3.new(1, 0, -5)
                            if shortestDistance > 10 then
                                rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                            end
                            
                            if shouldArise and next(selectedBosses) ~= nil then
                                for i = 1, 4 do
                                    _G.FireRemote("arise")
                                    task.wait()
                                end
                            end
                            
                        end
                    else
                        local nearestPart = nil
                        local shortestDistance = math.huge
                        local raidFolder = Workspace.spawners:FindFirstChild("raid")
                        if raidFolder then
                            for _, part in pairs(raidFolder:GetChildren()) do
                                if part:IsA("BasePart") and part:GetAttribute("health") and part:GetAttribute("health") > 0 then
                                    local distance = (rootPart.Position - part.Position).Magnitude
                                    if distance < shortestDistance then
                                        shortestDistance = distance
                                        nearestPart = part
                                    end
                                end
                            end
                        end
                        if nearestPart then
                            local targetPos = nearestPart.Position - Vector3.new(1, 0, -5)
                            if shortestDistance > 10 then
                                rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                            end
                        end
                    end
                end
                
                local leaveOnWave = Options.LeaveOnWave.Value
                if leaveOnWave ~= "None" and raidWave and tonumber(raidWave) >= tonumber(leaveOnWave) then
                    
                    _G.FireRemote("leaveRaid")
                    task.wait(2)
                    
                    if _G.SavedWorldPosition and _G.SavedWorld then
                        local currentWorld = _G.currentWorld()
                        if currentWorld ~= _G.SavedWorld then
                            _G.FireRemoteTwoArg("teleportToWorld", _G.SavedWorld)
                            task.wait(2)
                        end
                        rootPart = _G.GetPlayerRoot()
                        if rootPart then
                            rootPart.CFrame = _G.SavedWorldPosition
                        end
                    end
                    wasInRaid = false
                    lastWave = 0
                end
            else
                _G.FireRemote("joinRaid")
                task.wait(3)
            end
        else
            task.wait(0.5)
        end
        
        task.wait()
    end
end

_G.AutoRollSwordsLoop = function()
    while Options.AutoRollSwords.Value do
        _G.FireRemoteTwoArg("rollSwords", "one")
        task.wait(0.1)
    end
end

_G.FarmMobs = function()
    local selectedWorld = Options.WorldDropdown.Value
    local selectedMobs = Options.MobDropdown.Value
    
    local rootPart = _G.GetPlayerRoot()
    if rootPart then
        local currentWorld = _G.currentWorld()
        local inRaid = player:GetAttribute("inRaid")
        local inDungeon = player:GetAttribute("inDungeon")
        
        if inRaid then
            local nearestPart = nil
            local shortestDistance = math.huge
            local raidFolder = Workspace.spawners:FindFirstChild("raid")
            
            if raidFolder then
                for _, part in pairs(raidFolder:GetChildren()) do
                    if part:IsA("BasePart") and part:GetAttribute("health") and part:GetAttribute("health") > 0 then
                        local distance = (rootPart.Position - part.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPart = part
                        end
                    end
                end
                
                if nearestPart then
                    local targetPos = nearestPart.Position - Vector3.new(1, 0, 2)
                    if shortestDistance > 4 then
                        rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                    end
                end
            end
        elseif inDungeon then
            local dungeonMode = currentWorld
            local nearestPart, distance = _G.FindNearestDungeonMob(dungeonMode, rootPart)
            
            if nearestPart then
                local targetPos = nearestPart.Position - Vector3.new(1, 0, 2)
                if distance > 4 then
                    rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                end
            end
        else
            if currentWorld ~= selectedWorld then
                _G.FireRemoteTwoArg("teleportToWorld", selectedWorld)
                task.wait(2)
            else
                if selectedMobs and type(selectedMobs) == "table" and next(selectedMobs) ~= nil then
                    local nearestPart, distance = _G.FindNearestMob(currentWorld, selectedMobs, rootPart)
                    if nearestPart then
                        local targetPos = nearestPart.Position - Vector3.new(1, 0, 2)
                        if distance > 4 then
                            rootPart.CFrame = CFrame.new(targetPos, nearestPart.Position)
                        end
                    end
                end
            end
        end
    end
end

_G.RollAndFarmLoop = function()
    local lastRollTime = 0

    while Options.RollAndFarm.Value do
        if _G.isAttemptingTowerEntry then
            task.wait(0.5)
            continue
        end

        local rootPart = _G.GetPlayerRoot()
        if not rootPart then
            task.wait(0.2)
            continue
        else
            local currentWorld = _G.currentWorld()
            local currentTime = tick()
            local inRaid = player:GetAttribute("inRaid")
            local inDungeon = player:GetAttribute("inDungeon")
            local inDefense = player:GetAttribute("inDefense")
            local inTower = player:GetAttribute("inTower")
            local priority = Options.AutomationPriority.Value

            if (inRaid and priority == "Raid First") or
               (inDungeon and priority == "Dungeon First") or
               (inDefense and priority == "Defense First") or
               (inTower and priority == "Tower First") then
                task.wait(1)
                continue
            else
                if player.PlayerGui:FindFirstChild("Roll") and player.PlayerGui.Roll.Enabled then
                     _G.FarmMobs()
                else
                    if currentTime - lastRollTime > 3 then
                        local didRoll = false

                        if Options.RollChampionsWhileFarming.Value then
                            local championLocation = nil
                            if currentWorld and Workspace.currentWorld:FindFirstChild(currentWorld) then
                                local worldFolder = Workspace.currentWorld[currentWorld]
                                if worldFolder:FindFirstChild("interactions") and worldFolder.interactions:FindFirstChild("Champion") then
                                    championLocation = worldFolder.interactions.Champion
                                end
                            end

                            if championLocation then
                                rootPart.CFrame = championLocation.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.2)
                                if not Options.RollAndFarm.Value then break end

                                local rollType = Options.RollTypeDropdown.Value == "Single" and "one" or "multi"
                                local args = { [1] = "rollChampion", [2] = rollType, [3] = currentWorld }
                                ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
                                lastRollTime = currentTime
                                didRoll = true
                                task.wait()
                            end
                        end

                        if not didRoll and Options.RollSwordsWhileFarming.Value and currentWorld == "boar tavern" then
                            local swordLocation = nil
                            if Workspace.currentWorld:FindFirstChild("boar tavern") then
                                local worldFolder = Workspace.currentWorld["boar tavern"]
                                if worldFolder:FindFirstChild("interactions") and worldFolder.interactions:FindFirstChild("Swords") then
                                    swordLocation = worldFolder.interactions.Swords
                                    rootPart.CFrame = swordLocation.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.2)
                                    if not Options.RollAndFarm.Value then break end

                                    _G.FireRemoteTwoArg("rollSwords", "one")
                                    lastRollTime = currentTime
                                    didRoll = true
                                    task.wait()
                                end
                            end
                        end

                        if not didRoll and Options.RollHakiWhileFarming.Value and currentWorld == "sky lands" then
                            local selectedHakis = Options.HakiDropdown.Value
                            local currentHaki = player:GetAttribute("haki")
                            local currentHakiColor = currentHaki and currentHaki:match("^([^%.]+)")
                            if not (selectedHakis and currentHakiColor and selectedHakis[currentHakiColor]) then
                                local hakiLocation = nil
                                if Workspace.currentWorld:FindFirstChild("sky lands") then
                                     local worldFolder = Workspace.currentWorld["sky lands"]
                                     if worldFolder:FindFirstChild("interactions") and worldFolder.interactions:FindFirstChild("Hakis") then
                                         hakiLocation = worldFolder.interactions.Hakis
                                         rootPart.CFrame = hakiLocation.CFrame + Vector3.new(0, 3, 0)
                                         task.wait(0.2)
                                         if not Options.RollAndFarm.Value then break end

                                         _G.FireRemote("rollHakis")
                                         lastRollTime = currentTime
                                         didRoll = true
                                         task.wait()
                                     end
                                end
                            end
                        end

                        if not didRoll and Options.RollLineagesWhileFarming.Value and currentWorld == "namek" then
                            local selectedLineages = Options.LineageDropdown.Value
                            local currentLineage = player:GetAttribute("lineage")
                            if not (selectedLineages and currentLineage and selectedLineages[currentLineage]) then
                                local lineageLocation = nil
                                if Workspace.currentWorld:FindFirstChild("namek") then
                                    local worldFolder = Workspace.currentWorld["namek"]
                                    if worldFolder:FindFirstChild("interactions") and worldFolder.interactions:FindFirstChild("Lineages") then
                                        lineageLocation = worldFolder.interactions.Lineages
                                        rootPart.CFrame = lineageLocation.CFrame + Vector3.new(0, 3, 0)
                                        task.wait(0.2)
                                        if not Options.RollAndFarm.Value then break end

                                        _G.FireRemote("rollLineage")
                                        _G.FireRemote("rollLineages")
                                        lastRollTime = currentTime
                                        didRoll = true
                                        task.wait()
                                    end
                                end
                            end
                        end

                        if not didRoll and Options.RollGrimoireWhileFarming.Value and currentWorld == "skull island" then
                            local selectedGrimoire = Options.GrimoireDropdown.Value
                            local currentGrimoire = player:GetAttribute("grimoire")
                            if not (selectedGrimoire and currentGrimoire and selectedGrimoire[currentGrimoire]) then
                                local grimoireLocation = nil
                                if Workspace.currentWorld:FindFirstChild("skull island") then
                                     local worldFolder = Workspace.currentWorld["skull island"]
                                     if worldFolder:FindFirstChild("interactions") and worldFolder.interactions:FindFirstChild("Grimoires") then
                                         grimoireLocation = worldFolder.interactions.Grimoires
                                         rootPart.CFrame = grimoireLocation.CFrame + Vector3.new(0, 3, 0)
                                         task.wait(0.2)
                                         if not Options.RollAndFarm.Value then break end

                                         _G.FireRemote("rollGrimoires")
                                         lastRollTime = currentTime
                                         didRoll = true
                                         task.wait()
                                     end
                                end
                            end
                        end

                        if not didRoll then
                            _G.FarmMobs()
                        end
                    else
                        _G.FarmMobs()
                    end
                end
            end
        end

        task.wait(0.1)
    end
end

do
    Tabs.Main:AddSection("Farm Options")

    local WorldDropdown = Tabs.Main:AddDropdown("WorldDropdown", {
        Title = "Select World",
        Values = worldList,
        Multi = false,
        Default = worldList[1]
    })

    local MobDropdown = Tabs.Main:AddDropdown("MobDropdown", {
        Title = "Select Mob",
        Values = mobList[worldList[1]],
        Multi = true,
        Default = {[mobList[worldList[1]][1]] = true}
    })

    WorldDropdown:OnChanged(function()
        local selectedWorld = Options.WorldDropdown.Value
        MobDropdown:SetValues(mobList[selectedWorld])
        if not Options.MobDropdown.Value or type(Options.MobDropdown.Value) ~= "table" or next(Options.MobDropdown.Value) == nil then
            MobDropdown:SetValue({[mobList[selectedWorld][1]] = true})
        end
    end)

    MobDropdown:OnChanged(function()
        local selectedMobs = Options.MobDropdown.Value
        local mobList = {}
        for mob, enabled in pairs(selectedMobs) do
            if enabled then
                table.insert(mobList, mob)
            end
        end
    end)

    Tabs.Main:AddSlider("AutoFarmDelaySlider", {
        Title = "Auto Farm Delay",
        Description = "Too fast may cause ban",
        Default = getgenv().Settings.DefaultDelay,
        Min = getgenv().Settings.MinDelay,
        Max = getgenv().Settings.MaxDelay,
        Rounding = 1
    })

    Tabs.Defense:AddSection("Defense Options")

    Tabs.Defense:AddDropdown("DefenseDifficulty", {
        Title = "Select Difficulty",
        Values = {"easy", "medium", "hard"},
        Multi = false,
        Default = "easy"
    })

    Tabs.Defense:AddDropdown("DefensePrivacy", {
        Title = "Select Privacy",
        Values = {"public", "friends", "private"},
        Multi = false,
        Default = "public"
    })

    Tabs.Defense:AddToggle("DefenseJoin",{
        Title = "Join Other Player Defense",
        Default = false
    })

    local AutoDefenseToggle = Tabs.Defense:AddToggle("AutoDefense", {
        Title = "Auto Defense",
        Default = false
    })

    Tabs.Defense:AddSection("World Position")
    local SavePositionDefenseButton = Tabs.Defense:AddButton({
        Title = "Save Current Position",
        Description = "Current saved position: " .. (_G.SavedWorld or "None"),
        Callback = function()
            local rootPart = _G.GetPlayerRoot()
            if rootPart then
                _G.SavedWorldPosition = rootPart.CFrame
                _G.SavedWorld = _G.currentWorld()
                Fluent:Notify({
                    Title = "Position Saved",
                    Content = "Your current position has been saved for Defense return!",
                    Duration = 3
                })
                _G.UpdateSavedPositionButtons()
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Character not found! Unable to save position.",
                    Duration = 3
                })
            end
        end
    })
    Options.SavePositionDefenseButton = SavePositionDefenseButton

    AutoDefenseToggle:OnChanged(function()
        if Options.AutoDefense.Value then
            task.spawn(_G.AutoDefenseLoop)
        end
    end)

    local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarm", {
        Title = "Auto Farm",
        Default = false
    })

    Tabs.Setup:AddSection("Setup")
    local AutoClickToggle = Tabs.Setup:AddToggle("AutoClick", {
        Title = "Auto Click",
        Default = false
    })

    local AutoCollectToggle = Tabs.Setup:AddToggle("AutoCollect", {
        Title = "Auto Collect Drops",
        Default = false
    })

    local AutoUseAbilityToggle = Tabs.Setup:AddToggle("AutoUseAbility", {
        Title = "Auto Use Ability",
        Default = false
    })

    local AutoRankUpToggle = Tabs.Setup:AddToggle("AutoRankUp", {
        Title = "Auto Rank Up",
        Default = false
    })

    local AutoEvolveToggle = Tabs.Setup:AddToggle("AutoEvolve", {
        Title = "Auto Evolve Ability",
        Default = false
    })

    local AutoQuestToggle = Tabs.Quests:AddToggle("AutoQuest", {
        Title = "Auto Redeem World Quest",
        Default = false
    })

    local AutoGemQuestToggle = Tabs.Quests:AddToggle("AutoGemQuest", {
        Title = "Auto Redeem Gem Quest",
        Default = false
    })

    local AutoWorldQuestToggle = Tabs.Quests:AddToggle("AutoFarmWorldQuest", {
        Title = "Auto Farm World Quest",
        Description = "This will farm the enemies from the quest.",
        Default = false
    })

    Tabs.Roll:AddSection("Auto Roll Champions")
    local AutoRollChampionsToggle = Tabs.Roll:AddToggle("AutoRollChampions", {
        Title = "Auto Roll Champions",
        Default = false
    })

    local RollTypeDropdown = Tabs.Roll:AddDropdown("RollTypeDropdown", {
        Title = "Roll Type",
        Description = "Choose between single or multiple rolls",
        Values = {"Single", "Multiple"},
        Multi = false,
        Default = "Single"
    })

    Tabs.Roll:AddSection("Auto Roll Swords")
    local AutoRollSwordsToggle = Tabs.Roll:AddToggle("AutoRollSwords", {
        Title = "Auto Roll Swords",
        Default = false
    })

    Tabs.Roll:AddSection("Auto Roll Lineages")
    Tabs.Roll:AddDropdown("LineageDropdown", {
        Title = "Stop on Lineage",
        Values = lineages,
        Multi = true,
        Default = {["demon"] = true}
    })

    local AutoRollLineagesToggle = Tabs.Roll:AddToggle("AutoRollLineages", {
        Title = "Auto Roll Lineages",
        Default = false
    })

    Tabs.Roll:AddSection("Auto Roll Haki")
    Tabs.Roll:AddDropdown("HakiDropdown", {
        Title = "Stop on Haki",
        Values = haki,
        Multi = true,
        Default = {["green"] = true}
    })

    local AutoRollHakiToggle = Tabs.Roll:AddToggle("AutoRollHaki", {
        Title = "Auto Roll Haki",
        Default = false
    })

    Tabs.Roll:AddSection("Auto Roll Grimoire")
    Tabs.Roll:AddDropdown("GrimoireDropdown", {
        Title = "Stop on Grimoire",
        Values = grimoires,
        Multi = true,
        Default = {["wind"] = true}
    })

    local AutoRollGrimoireToggle = Tabs.Roll:AddToggle("AutoRollGrimoire", {
        Title = "Auto Roll Grimoire",
        Default = false
    })

    Tabs.Roll:AddSection("Auto Spin Wheel")
    local AutoSpinWheelToggle = Tabs.Roll:AddToggle("AutoSpinWheel", {
        Title = "Auto Spin Wheel",
        Default = false
    })

    Tabs.Dungeon:AddSection("Dungeon Options")
    Tabs.Dungeon:AddDropdown("LeaveOnRoom", {
        Title = "Leave on Room",
        Values = createRoomList(),
        Multi = false,
        Default = "None"
    })
    Tabs.Dungeon:AddSection("Auto Dungeon")
    local AutoEasyDungeonToggle = Tabs.Dungeon:AddToggle("AutoEasyDungeon", {
        Title = "Auto Easy Dungeon",
        Default = false
    })

    local AutoMediumDungeonToggle = Tabs.Dungeon:AddToggle("AutoMediumDungeon", {
        Title = "Auto Medium Dungeon",
        Default = false
    })

    local AutoHardDungeonToggle = Tabs.Dungeon:AddToggle("AutoHardDungeon", {
        Title = "Auto Hard Dungeon",
        Default = false
    })

    local AutoInsaneDungeonToggle = Tabs.Dungeon:AddToggle("AutoInsaneDungeon", {
        Title = "Auto Insane Dungeon",
        Default = false
    })

    Tabs.Dungeon:AddSection("World Position")
    local SavePositionDungeonButton = Tabs.Dungeon:AddButton({
        Title = "Save Current Position",
        Description = "Current saved position: " .. (_G.SavedWorld or "None"),
        Callback = function()
            local rootPart = _G.GetPlayerRoot()
            if rootPart then
                _G.SavedWorldPosition = rootPart.CFrame
                _G.SavedWorld = _G.currentWorld()
                Fluent:Notify({
                    Title = "Position Saved",
                    Content = "Your current position has been saved for dungeon return!",
                    Duration = 3
                })
                
                _G.UpdateSavedPositionButtons()
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Character not found! Unable to save position.",
                    Duration = 3
                })
            end
        end
    })

    Tabs.Tower:AddSection("Tower Options")

    Tabs.Tower:AddDropdown("LeaveOnFloor", {
        Title = "Leave on Floor",
        Values = createFloorList(),
        Multi = false,
        Default = "None"
    })

    local AutoTowerToggle = Tabs.Tower:AddToggle("AutoTower", {
        Title = "Auto Tower",
        Description = "Enters Tower at xx:00 and xx:30",
        Default = false
    })

    Tabs.Tower:AddSection("World Position")
    local SavePositionTowerButton = Tabs.Tower:AddButton({
        Title = "Save Current Position",
        Description = "Current saved position: " .. (_G.SavedWorld or "None"),
        Callback = function()
            local rootPart = _G.GetPlayerRoot()
            if rootPart then
                _G.SavedWorldPosition = rootPart.CFrame
                _G.SavedWorld = _G.currentWorld()
                Fluent:Notify({ Title = "Position Saved", Content = "Position saved for Tower return!", Duration = 3 })
                _G.UpdateSavedPositionButtons()
            else
                Fluent:Notify({ Title = "Error", Content = "Character not found! Unable to save position.", Duration = 3 })
            end
        end
    })
    Options.SavePositionTowerButton = SavePositionTowerButton

    AutoTowerToggle:OnChanged(function()
        if Options.AutoTower.Value then
            task.spawn(_G.AutoTowerLoop)
        end
    end)


    Tabs.Upgrades:AddSection("Auto Buy Upgrades")
    local upgrades = {
        { Name = "PowerBoost", Arg = "powerBoost", Title = "Auto Power Boost" },
        { Name = "CoinsBoost", Arg = "coinsBoost", Title = "Auto Coins Boost" },
        { Name = "DamageBoost", Arg = "damageBoost", Title = "Auto Damage Boost" },
        { Name = "DropsBoost", Arg = "dropsBoost", Title = "Auto Drops Boost" },
        { Name = "LuckBoost", Arg = "luckBoost", Title = "Auto Luck Boost" },
        { Name = "FastRoll", Arg = "fastRoll", Title = "Auto Fast Roll" }
    }

    for _, upgrade in pairs(upgrades) do
        local toggle = Tabs.Upgrades:AddToggle(upgrade.Name, {
            Title = upgrade.Title,
            Default = false
        })

        toggle:OnChanged(function()
            if Options[upgrade.Name].Value then
                task.spawn(function()
                    while Options[upgrade.Name].Value do
                        _G.FireRemoteTwoArg("buyUpgrade", upgrade.Arg)
                        task.wait(1)
                    end
                end)
            end
        end)
    end

    local AutoBuyTitleToggle = Tabs.Upgrades:AddToggle("AutoBuyTitle", {
        Title = "Auto Buy Title",
        Default = false
    }) 

    Options.SavePositionDungeonButton = SavePositionDungeonButton

    Tabs.Teleport:AddSection("Worlds")
    for _, world in pairs(worldList) do
        Tabs.Teleport:AddButton({
            Title = world:gsub("^%l", string.upper),
            Callback = function()
                _G.FireRemoteTwoArg("teleportToWorld", world)
            end
        })
    end
    Tabs.Teleport:AddSection("Dungeon")
    Tabs.Teleport:AddButton({
        Title = "Teleport to Dungeon",
        Callback = function()
            _G.FireRemoteTwoArg("teleportToWorld", "dungeon")
        end
    })
    Tabs.Teleport:AddSection("Server")
    Tabs.Teleport:AddButton({
        Title = "Server Hop",
        Description = "Teleport to server with least players.",
        Callback = function()
            local Http = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local Api = "https://games.roblox.com/v1/games/"
            local _place = game.PlaceId
            local _servers = Api .. _place .. "/servers/Public?sortOrder=Asc&limit=100"
            local function ListServers(cursor)
                local Raw = game:HttpGet(_servers .. ((cursor and "&cursor=" .. cursor) or ""))
                return Http:JSONDecode(Raw)
            end
            local Server, Next
            repeat
                local Servers = ListServers(Next)
                Server = Servers.data[1]
                Next = Servers.nextPageCursor
            until Server
            Fluent:Notify({
                Title = "Server Hop",
                Content = "Teleporting to a new server...",
                Duration = 3
            })
            TPS:TeleportToPlaceInstance(_place, Server.id, player)
        end
    })
    Tabs.Infos:AddSection("Information")
    Tabs.Infos:AddParagraph({Title = "This script is no longer updated.",})
    Tabs.Infos:AddSection("Support")
    Tabs.Infos:AddParagraph({
        Title = "Anti-AFK",
        Content = "Anti-AFK is automatically enabled."
    })
    
    Tabs.Settings:AddSection("Game Notifications")
    local NotificationsToggle = Tabs.Settings:AddToggle("GameNotifications", {
        Title = "Enable Game Notifications",
        Default = true 
    })

    AutoFarmToggle:OnChanged(function()
        if Options.AutoFarm.Value then
            if Options.RollAndFarm.Value then
                Options.RollAndFarm:SetValue(false)
                Fluent:Notify({
                    Title = "Redundant",
                    Content = "Roll & Farm deactivated.",
                    Duration = 3
                })
            end
            task.spawn(_G.AutoFarmLoop)
        end
    end)

    AutoCollectToggle:OnChanged(function()
        if Options.AutoCollect.Value then
            task.spawn(_G.AutoCollectLoop)
        end
    end)

    AutoClickToggle:OnChanged(function()
        if Options.AutoClick.Value then
            task.spawn(function()
                while Options.AutoClick.Value do
                    _G.FireRemote("attack")
                    task.wait()
                end
            end)
        end
    end)

    AutoUseAbilityToggle:OnChanged(function()
        if Options.AutoUseAbility.Value then
            task.spawn(function()
                while Options.AutoUseAbility.Value do
                    _G.FireRemote("useAbility")
                    task.wait(3)
                end
            end)
        end
    end)

    AutoRankUpToggle:OnChanged(function()
        if Options.AutoRankUp.Value then
            task.spawn(function()
                while Options.AutoRankUp.Value do
                    _G.FireRemote("rankup")
                    task.wait(5)
                end
            end)
        end
    end)

    AutoEvolveToggle:OnChanged(function()
        if Options.AutoEvolve.Value then
            task.spawn(_G.AutoEvolveLoop)
        end
    end)

    AutoRollChampionsToggle:OnChanged(function()
        if Options.AutoRollChampions.Value then
            task.spawn(_G.AutoRollChampionsLoop)
        end
    end)

    AutoRollSwordsToggle:OnChanged(function()
        if Options.AutoRollSwords.Value then
            task.spawn(_G.AutoRollSwordsLoop)
        end
    end)


    AutoEasyDungeonToggle:OnChanged(function()
        if Options.AutoEasyDungeon.Value then
            task.spawn(function()
                _G.AutoDungeonLoop("dungeon easy")
            end)
        end
    end)

    AutoMediumDungeonToggle:OnChanged(function()
        if Options.AutoMediumDungeon.Value then
            task.spawn(function()
                _G.AutoDungeonLoop("dungeon medium")
            end)
        end
    end)

    AutoHardDungeonToggle:OnChanged(function()
        if Options.AutoHardDungeon.Value then
            task.spawn(function()
                _G.AutoDungeonLoop("dungeon hard")
            end)
        end
    end)

    AutoInsaneDungeonToggle:OnChanged(function()
        if Options.AutoInsaneDungeon.Value then
            task.spawn(function()
                _G.AutoDungeonLoop("dungeon insane")
            end)
        end
    end)

    AutoQuestToggle:OnChanged(function()
        if Options.AutoQuest.Value then
            task.spawn(_G.AutoQuestLoop)
        end
    end)

    AutoGemQuestToggle:OnChanged(function()
        if Options.AutoGemQuest.Value then
            task.spawn(_G.AutoGemQuestLoop)
        end
    end)

    AutoWorldQuestToggle:OnChanged(function()
        if Options.AutoFarmWorldQuest.Value then
            task.spawn(_G.AutoWorldQuestLoop)
        end
    end)

    AutoRollLineagesToggle:OnChanged(function()
        if Options.AutoRollLineages.Value then
            local selectedLineages = Options.LineageDropdown.Value
            if not selectedLineages or not next(selectedLineages) then
                Fluent:Notify({
                    Title = "Warning",
                    Content = "Please select at least one lineage to stop on!",
                    Duration = 3
                })
                Options.AutoRollLineages:SetValue(false)
                return
            end
            task.spawn(_G.AutoRollLineagesLoop)
        end
    end)

    AutoRollHakiToggle:OnChanged(function()
        if Options.AutoRollHaki.Value then
            local selectedHakis = Options.HakiDropdown.Value
            if not selectedHakis or not next(selectedHakis) then
                Fluent:Notify({
                    Title = "Warning",
                    Content = "Please select at least one haki to stop on!",
                    Duration = 3
                })
                Options.AutoRollHaki:SetValue(false)
                return
            end
            task.spawn(_G.AutoRollHakiLoop)
        end
    end)

    AutoRollGrimoireToggle:OnChanged(function()
        if Options.AutoRollGrimoire.Value then
            local selectedGrimoire = Options.GrimoireDropdown.Value
            if not selectedGrimoire or not next(selectedGrimoire) then
                Fluent:Notify({
                    Title = "Warning",
                    Content = "Please select at least one Grimoire to stop on!",
                    Duration = 3
                })
                Options.AutoRollGrimoire:SetValue(false)
                return
            end
            task.spawn(_G.AutoRollGrimoireLoop)
        end
    end)

    AutoBuyTitleToggle:OnChanged(function()
        if Options.AutoBuyTitle.Value then
            task.spawn(_G.AutoBuyTitleLoop)
        end
    end)

    AutoSpinWheelToggle:OnChanged(function()
        if Options.AutoSpinWheel.Value then
            task.spawn(function()
                while Options.AutoSpinWheel.Value do
                    _G.FireRemoteTwoArg("spinWheel", "normal")
                    task.wait(5)
                end
            end)
        end
    end)

    NotificationsToggle:OnChanged(function()
        local notifications = player.PlayerGui:WaitForChild("Interface"):WaitForChild("notifications")
        if notifications then
            notifications.Visible = Options.GameNotifications.Value
        end
    end)

    Tabs.Raid:AddSection("Raid Options")
    Tabs.Raid:AddDropdown("LeaveOnWave", {
        Title = "Leave on Wave",
        Values = createWaveList(),
        Multi = false,
        Default = "None"
    })
    Tabs.Raid:AddDropdown("ShadowBossDropdown", {
        Title = "Target Shadow Boss",
        Description = "Select bosses to use Arise on during boss waves (leave empty to skip Arise)",
        Values = shadowBosses,
        Multi = true,
        Default = {["keru"] = true}
    })
    local AutoRaidToggle = Tabs.Raid:AddToggle("AutoRaid", {
        Title = "Auto Raid",
        Default = false
    })

    Tabs.Raid:AddParagraph({
        Title = "Note",
        Content = "Arise is automatically used on boss waves.\nYou dont need to kill the boss to arise."
    })

    AutoRaidToggle:OnChanged(function()
        if Options.AutoRaid.Value then
            task.spawn(_G.AutoRaidLoop)
        end
    end)

    Tabs.Raid:AddSection("World Position")

    _G.UpdateSavedPositionButtons = function()
        local positionText = "Current saved position: " .. (_G.SavedWorld or "None")
    
        if Options.SavePositionRaidButton then Options.SavePositionRaidButton:SetDesc(positionText) end
        if Options.SavePositionDungeonButton then Options.SavePositionDungeonButton:SetDesc(positionText) end
        if Options.SavePositionDefenseButton then Options.SavePositionDefenseButton:SetDesc(positionText) end
        if Options.SavePositionTowerButton then Options.SavePositionTowerButton:SetDesc(positionText) end
    end    

    local SavePositionRaidButton = Tabs.Raid:AddButton({
        Title = "Save Current Position",
        Description = "Current saved position: " .. (_G.SavedWorld or "None"),
        Callback = function()
            local rootPart = _G.GetPlayerRoot()
            if rootPart then
                _G.SavedWorldPosition = rootPart.CFrame
                _G.SavedWorld = _G.currentWorld()
                Fluent:Notify({
                    Title = "Position Saved",
                    Content = "Your current position has been saved for raid return!",
                    Duration = 3
                })
                
                _G.UpdateSavedPositionButtons()
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Character not found! Unable to save position.",
                    Duration = 3
                })
            end
        end
    })

    Options.SavePositionRaidButton = SavePositionRaidButton

    Tabs.Main:AddSection("Roll & Farm")

    local RollAndFarmToggle = Tabs.Main:AddToggle("RollAndFarm", {
        Title = "Roll & Farm",
        Description = "Automatically roll while farming",
        Default = false
    })

    local RollChampionsWhileFarmingToggle = Tabs.Main:AddToggle("RollChampionsWhileFarming", {
        Title = "Roll Champions While Farming",
        Default = false
    })

    local RollSwordsWhileFarmingToggle = Tabs.Main:AddToggle("RollSwordsWhileFarming", {
        Title = "Roll Swords While Farming",
        Description = "Requires being in Boar Tavern",
        Default = false
    })

    local RollHakiWhileFarmingToggle = Tabs.Main:AddToggle("RollHakiWhileFarming", {
        Title = "Roll Haki While Farming",
        Description = "Requires being in Sky Lands",
        Default = false
    })

    local RollLineagesWhileFarmingToggle = Tabs.Main:AddToggle("RollLineagesWhileFarming", {
        Title = "Roll Lineages While Farming",
        Description = "Requires being in Namek",
        Default = false
    })

    local RollGrimoireWhileFarmingToggle = Tabs.Main:AddToggle("RollGrimoireWhileFarming", {
        Title = "Roll Grimoire While Farming",
        Description = "Requires being in Skull Island",
        Default = false
    })

    Tabs.Main:AddParagraph({
        Title = "How to use Roll & Farm",
        Content = "1. Toggle on the option(s) you want (Champion, Sword, Haki, Lineage).\n2. Select the world and the mobs you want to farm\n3. Toggle on Roll & Farm\n4. Done!\n\nNote: You dont need to toggle auto farm, and you can use auto dungeon/raid at the same time. The script will teleport to the correct interaction point based on the selected rolls and current world."
    })

    RollAndFarmToggle:OnChanged(function()
        if Options.RollAndFarm.Value then
            if Options.AutoFarm.Value then
                Options.AutoFarm:SetValue(false)
                Fluent:Notify({
                    Title = "Redundant",
                    Content = "Auto Farm deactivated.",
                    Duration = 3
                })
            end
            
            if not (Options.RollChampionsWhileFarming.Value or Options.RollSwordsWhileFarming.Value or Options.RollHakiWhileFarming.Value or Options.RollLineagesWhileFarming.Value or Options.RollGrimoireWhileFarming.Value) then
                Fluent:Notify({
                    Title = "Warning",
                    Content = "Please enable at least one roll option",
                    Duration = 3
                })
                Options.RollAndFarm:SetValue(false)
                return
            end
            
            task.spawn(_G.RollAndFarmLoop)
        end
    end)

    Tabs.Settings:AddSection("Automation Priority")

    Tabs.Settings:AddDropdown("AutomationPriority", {
        Title = "Priority",
        Description = "Choose which feature takes priority when multiple are active",
        Values = {
            "Raid First",
            "Defense First",
            "Dungeon First",
            "Tower First",
            "Roll & Farm First"
        },
        Multi = false,
        Default = "Raid First"
    })

    Tabs.Settings:AddParagraph({
        Title = "Priority System",
        Content = "When multiple automation features are active:\n\n" ..
                  "• Raid First: Will prioritize completing raids before other activities\n" ..
                  "• Defense First: Will prioritize completing defense before other activities\n" ..
                  "• Dungeon First: Will prioritize completing dungeons before other activities\n" ..
                  "• Tower First: Will prioritize completing tower before other activities\n" ..
                  "• Auto Farm/Roll & Farm First: Will prioritize rolling and farming in the normal world"
    })
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("DYHUB")
SaveManager:SetFolder("DYHUB/animepower")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()