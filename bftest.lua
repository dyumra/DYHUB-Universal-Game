--[[
    Mid-Journey
    SJAD © 2025
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Mid-Journey Hub (discord.gg/6UaRDjBY42)",
    LoadingTitle = "Evade v2 Rewritten",
    LoadingSubtitle = "Credits: (SJAD) - Sea Journeys Advanced Development",
    Theme = "Light",
    ShowText = "MidWare GUI",
    Icon = 105495960707973,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SJAD_Evade",
        FileName = "EvadeConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "6UaRDjBY42",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "SJAD Keysystem",
        Subtitle = "Sorry I need more member :)",
        Note = "Get from discord server : discord.gg/6UaRDjBY42",
        FileName = "SJAD",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"SJAD-0001-111"}
    }
})

local Confirmed = false
local autoRespawnMethod = nil
local respawnConnection
local lastSavedPosition
local playerESPThread
local ticketESPThread
local nextbotESPThread
local tracerThread = nil
local tracerLines = {}
local infiniteSlideEnabled = false
local slideFrictionValue = -8
local lagGui
local lagGuiButton

local function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r .. ", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end
    return result
end

local MainTab = Window:CreateTab("Main")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")

MainTab:CreateToggle({
    Name = "Automatic Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(state)
        getgenv().AutoRespawnEnabled = state

        if respawnConnection then
            respawnConnection:Disconnect()
            respawnConnection = nil
        end

        if state then
            local player = game:GetService("Players").LocalPlayer
            task.defer(function()
                while not player.Character do task.wait() end
                respawnConnection = player.CharacterAdded:Connect(function(character)
                    task.defer(function()
                        character:WaitForChild("HumanoidRootPart", 5)
                        character:WaitForChild("Humanoid", 5)

                        character:GetAttributeChangedSignal("Downed"):Connect(function()
                            if not getgenv().AutoRespawnEnabled then return end
                            if character:GetAttribute("Downed") ~= true then return end
                            if autoRespawnMethod ~= "Fake Revive" then return end

                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if hrp then lastSavedPosition = hrp.Position end

                            task.wait(3)
                            local start = tick()
                            repeat
                                game:GetService("ReplicatedStorage")
                                    :WaitForChild("Events", 9e9)
                                    :WaitForChild("Player", 9e9)
                                    :WaitForChild("ChangePlayerMode", 9e9)
                                    :FireServer(true)
                                task.wait(1)
                            until character:GetAttribute("Downed") ~= true or tick() - start > 1

                            local newChar
                            repeat
                                newChar = player.Character
                                task.wait()
                            until newChar and newChar:FindFirstChild("HumanoidRootPart")

                            local newHRP = newChar:FindFirstChild("HumanoidRootPart")
                            if lastSavedPosition and newHRP then
                                newHRP.CFrame = CFrame.new(lastSavedPosition)
                                task.wait(0.5)
                                if (newHRP.Position - lastSavedPosition).Magnitude > 1 then return end
                            end
                        end)
                    end)
                end)
                player.CharacterAdded:Fire(player.Character)
            end)
        end
    end
})

MainTab:CreateDropdown({
    Name = "Respawn Method",
    Options = {"Random", "Fake Revive"},
    CurrentOption = {"Random"},
    MultipleOptions = false,
    Flag = "RespawnMethod",
    Callback = function(value)
        autoRespawnMethod = value[1]
    end
})

VisualsTab:CreateToggle({
    Name = "Game Timer Display",
    CurrentValue = false,
    Flag = "ShowGameTime",
    Callback = function(state)
        local screenGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SJAD_EvadeTimer")
        if screenGui then screenGui.Enabled = state end
    end
})

VisualsTab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,
    Flag = "EspPlayer",
    Callback = function(state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local function getDistance(pos)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            return hrp and (pos - hrp.Position).Magnitude or nil
        end

        local function createPlayerESP(part)
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "PlayerESP"
            billboard.Adornee = part
            billboard.Size = UDim2.new(0, 180, 0, 25)
            billboard.StudsOffset = Vector3.new(0, 3.2, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Parent = part

            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextStrokeTransparency = 0.25
            label.TextScaled = true
            label.RichText = true
            label.Font = Enum.Font.GothamSemibold
            label.Text = ""
            label.TextColor3 = Color3.fromRGB(180, 220, 255)
            label.Parent = billboard

            return label
        end

        local function removeAllESPs()
            local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
            if folder then
                for _, char in ipairs(folder:GetChildren()) do
                    if char:IsA("Model") then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local existing = hrp:FindFirstChild("PlayerESP")
                            if existing then existing:Destroy() end
                        end
                    end
                end
            end
        end

        if state then
            if playerESPThread and coroutine.status(playerESPThread) == "suspended" then
                coroutine.close(playerESPThread)
            end
            playerESPThread = coroutine.create(function()
                while true do
                    local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                    if folder then
                        for _, char in ipairs(folder:GetChildren()) do
                            if char:IsA("Model") then
                                local team = char:GetAttribute("Team")
                                if team ~= "Nextbot" and char.Name ~= Players.LocalPlayer.Name then
                                    local hrp = char:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        local espGui = hrp:FindFirstChild("PlayerESP")
                                        local label = espGui and espGui:FindFirstChild("Label")
                                        if not label then label = createPlayerESP(hrp) end
                                        if label then
                                            local dist = getDistance(hrp.Position) or 0
                                            local downed = char:GetAttribute("Downed")
                                            local downedTime = tonumber(char:GetAttribute("DownedTimeLeft")) or 0
                                            local name = char.Name

                                            local displayText, color
                                            if downed == true then
                                                color = Color3.fromRGB(255, 150, 150)
                                                displayText = string.format('%s <font size="16">(Downed %.0f)</font>', name, downedTime)
                                            elseif downed == false then
                                                color = Color3.fromRGB(150, 255, 150)
                                                displayText = string.format('%s\n%.0f studs', name, dist)
                                            else
                                                color = Color3.fromRGB(150, 200, 255)
                                                displayText = string.format('%s\n%.0f studs', name, dist)
                                            end
                                            if label.Text ~= displayText or label.TextColor3 ~= color then
                                                label.Text = displayText
                                                label.TextColor3 = color
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            coroutine.resume(playerESPThread)
        else
            removeAllESPs()
            if playerESPThread and coroutine.status(playerESPThread) == "suspended" then
                coroutine.close(playerESPThread)
                playerESPThread = nil
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "ESP Ticket",
    CurrentValue = false,
    Flag = "EspTicket",
    Callback = function(state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local function getDistance(pos)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            return hrp and (pos - hrp.Position).Magnitude or nil
        end

        local function createESP(part)
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "TicketESP"
            billboard.Adornee = part
            billboard.Size = UDim2.new(0, 180, 0, 25)
            billboard.StudsOffset = Vector3.new(0, 3.2, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Parent = part

            local label = Instance.new("TextLabel")
            label.Name = "Ticket"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextStrokeTransparency = 0.25
            label.TextScaled = true
            label.Font = Enum.Font.GothamSemibold
            label.TextColor3 = Color3.fromRGB(255, 255, 200)
            label.Text = "Ticket"
            label.Parent = billboard

            return billboard
        end

        local function removeAllTicketESP()
            local ticketFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
            if ticketFolder then
                for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                    if ticketModel:IsA("Model") then
                        local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local existing = part:FindFirstChild("TicketESP")
                            if existing then existing:Destroy() end
                        end
                    end
                end
            end
        end

        if state then
            if ticketESPThread and coroutine.status(ticketESPThread) == "suspended" then
                coroutine.close(ticketESPThread)
            end
            ticketESPThread = coroutine.create(function()
                while true do
                    local ticketFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
                    if ticketFolder then
                        for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                            if ticketModel:IsA("Model") then
                                local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local billboard = part:FindFirstChild("TicketESP") or createESP(part)
                                    local label = billboard and billboard:FindFirstChild("Ticket")
                                    if label then
                                        local dist = getDistance(part.Position)
                                        if dist then
                                            label.Text = string.format("%s\n%.0f studs", ticketModel.Name, dist)
                                        else
                                            label.Text = ticketModel.Name
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            coroutine.resume(ticketESPThread)
        else
            removeAllTicketESP()
            if ticketESPThread and coroutine.status(ticketESPThread) == "suspended" then
                coroutine.close(ticketESPThread)
                ticketESPThread = nil
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "ESP Nextbot",
    CurrentValue = false,
    Flag = "EspNextbot",
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local function getDistance(pos)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            return hrp and (pos - hrp.Position).Magnitude or nil
        end
        local function getESPPart(obj)
            if obj:IsA("BasePart") then return obj
            elseif obj:IsA("Model") then
                return obj:FindFirstChild("Root") or obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
            end
        end
        local function getColorByDistance(dist)
            if dist <= 12 then return Color3.fromRGB(80, 80, 80)
            elseif dist <= 60 then
                local t = (dist - 6) / 14
                return Color3.fromRGB(255, 150 + (255 - 150) * t, 150)
            else return Color3.fromRGB(220, 180, 255)
            end
        end
        local function createESP(part)
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NextbotESP"
            billboard.Adornee = part
            billboard.Size = UDim2.new(0, 180, 0, 25)
            billboard.StudsOffset = Vector3.new(0, 3.2, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Parent = part

            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextStrokeTransparency = 0.25
            label.TextScaled = true
            label.Font = Enum.Font.GothamSemibold
            label.Text = ""
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Parent = billboard

            return billboard
        end
        local function removeAllNextbotESP()
            local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
            if folder then
                for _, npc in ipairs(folder:GetChildren()) do
                    local part = getESPPart(npc)
                    if part then
                        local existing = part:FindFirstChild("NextbotESP")
                        if existing then existing:Destroy() end
                    end
                end
            end
        end
        if state then
            if nextbotESPThread and coroutine.status(nextbotESPThread) == "suspended" then
                coroutine.close(nextbotESPThread)
            end
            nextbotESPThread = coroutine.create(function()
                while true do
                    local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                    if folder then
                        for _, npc in ipairs(folder:GetChildren()) do
                            if npc:GetAttribute("Team") == "Nextbot" then
                                local part = getESPPart(npc)
                                if part then
                                    local billboard = part:FindFirstChild("NextbotESP") or createESP(part)
                                    local label = billboard and billboard:FindFirstChild("Label")
                                    if label then
                                        local dist = getDistance(part.Position)
                                        if dist then
                                            label.Text = string.format("%s\n%.0f studs", npc.Name, dist)
                                            label.TextColor3 = getColorByDistance(dist)
                                        else
                                            label.Text = npc.Name
                                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            coroutine.resume(nextbotESPThread)
        else
            removeAllNextbotESP()
            if nextbotESPThread and coroutine.status(nextbotESPThread) == "suspended" then
                coroutine.close(nextbotESPThread)
                nextbotESPThread = nil
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Tracer Downed Players",
    CurrentValue = false,
    Flag = "TracerDowned",
    Callback = function(state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera

        local function cleanup()
            for _, line in ipairs(tracerLines) do
                if line and line.Remove then line:Remove()
                elseif line then line.Visible = false end
            end
            tracerLines = {}
        end

        if state then
            tracerThread = coroutine.create(function()
                while true do
                    cleanup()
                    local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                    if folder then
                        for _, char in ipairs(folder:GetChildren()) do
                            if char:IsA("Model") then
                                local team = char:GetAttribute("Team")
                                local downed = char:GetAttribute("Downed")
                                if team ~= "Nextbot" and char.Name ~= LocalPlayer.Name and downed == true then
                                    local hrp = char:FindFirstChild("HumanoidRootPart")
                                    if hrp and Camera then
                                        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                                        if onScreen then
                                            local tracer = Drawing.new("Line")
                                            tracer.Color = Color3.fromRGB(255, 150, 150)
                                            tracer.Thickness = 2
                                            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                            tracer.To = Vector2.new(pos.X, pos.Y)
                                            tracer.ZIndex = 1
                                            tracer.Visible = true
                                            table.insert(tracerLines, tracer)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
            coroutine.resume(tracerThread)
        else
            if tracerThread and coroutine.status(tracerThread) == "suspended" then
                coroutine.close(tracerThread)
                tracerThread = nil
            end
            cleanup()
        end
    end
})

local currentSettings = { Speed = 1500, JumpCap = 1, AirStrafeAcceleration = 187 }
local requiredFields = {
    Friction=true, AirStrafeAcceleration=true, JumpHeight=true, RunDeaccel=true,
    JumpSpeedMultiplier=true, JumpCap=true, SprintCap=true, WalkSpeedMultiplier=true,
    BhopEnabled=true, Speed=true, AirAcceleration=true, RunAccel=true, SprintAcceleration=true
}
local appliedOnce = false
getgenv().ApplyMode = "Not Optimized"

local function getMatchingTables()
    local matched = {}
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            local ok = true
            for field in pairs(requiredFields) do
                if rawget(obj, field) == nil then ok = false; break end
            end
            if ok then table.insert(matched, obj) end
        end
    end
    return matched
end

local function applyToTables(callback)
    for _, tableObj in ipairs(getMatchingTables()) do
        if typeof(tableObj) == "table" then
            pcall(callback, tableObj)
        end
    end
end

MainTab:CreateSlider({
    Name = "Set Speed",
    Range = {1450, 10000},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1500,
    Flag = "SpeedSlider",
    Callback = function(val)
        currentSettings.Speed = val
        applyToTables(function(obj) obj.Speed = val end)
    end
})

MainTab:CreateSlider({
    Name = "Set Jump Cap",
    Range = {0.1, 500},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "JumpCapSlider",
    Callback = function(val)
        currentSettings.JumpCap = val
        applyToTables(function(obj) obj.JumpCap = val end)
    end
})

MainTab:CreateSlider({
    Name = "Strafe Acceleration",
    Range = {1, 10000},
    Increment = 1,
    Suffix = "",
    CurrentValue = 187,
    Flag = "StrafeSlider",
    Callback = function(val)
        currentSettings.AirStrafeAcceleration = val
        applyToTables(function(obj) obj.AirStrafeAcceleration = val end)
    end
})

MainTab:CreateDropdown({
    Name = "Apply Method",
    Options = {"Not Optimized", "Optimized"},
    CurrentOption = {"Not Optimized"},
    MultipleOptions = false,
    Flag = "ApplyModeDropdown",
    Callback = function(opt)
        getgenv().ApplyMode = opt[1]
    end
})

MainTab:CreateToggle({
    Name = "Infinite Slide",
    CurrentValue = false,
    Flag = "InfiniteSlideToggle",
    Callback = function(state)
        infiniteSlideEnabled = state
        local cachedTables
        local plrModel
        local slideConnection
        local keys = {
            "Friction","AirStrafeAcceleration","JumpHeight","RunDeaccel",
            "JumpSpeedMultiplier","JumpCap","SprintCap","WalkSpeedMultiplier",
            "BhopEnabled","Speed","AirAcceleration","RunAccel","SprintAcceleration"
        }
        local function hasAll(tbl)
            if type(tbl) ~= "table" then return false end
            for _, k in ipairs(keys) do if rawget(tbl, k) == nil then return false end end
            return true
        end
        local function setFriction(value)
            if not cachedTables then return end
            for _, t in ipairs(cachedTables) do
                pcall(function() t.Friction = value end)
            end
        end
        local function updatePlayerModel()
            local GameFolder = workspace:FindFirstChild("Game")
            local PlayersFolder = GameFolder and GameFolder:FindFirstChild("Players")
            if PlayersFolder then plrModel = PlayersFolder:FindFirstChild(game.Players.LocalPlayer.Name) else plrModel = nil end
        end
        local function onHeartbeat()
            if not plrModel then setFriction(5); return end
            local success, currentState = pcall(function() return plrModel:GetAttribute("State") end)
            if success and currentState then
                if currentState == "Slide" then
                    pcall(function() plrModel:SetAttribute("State", "EmotingSlide") end)
                elseif currentState == "EmotingSlide" then
                    setFriction(slideFrictionValue)
                else setFriction(5) end
            else setFriction(5) end
        end
        if state then
            cachedTables = {}
            for _, obj in ipairs(getgc(true)) do
                local success, result = pcall(function() if hasAll(obj) then return obj end end)
                if success and result then table.insert(cachedTables, result) end
            end
            updatePlayerModel()
            slideConnection = game:GetService("RunService").Heartbeat:Connect(onHeartbeat)
            game.Players.LocalPlayer.CharacterAdded:Connect(function() wait(0.1); updatePlayerModel() end)
        else
            cachedTables = nil; plrModel = nil
            if slideConnection then slideConnection:Disconnect(); slideConnection = nil end
            setFriction(5)
        end
    end
})

MainTab:CreateSlider({
    Name = "Infinite Slide Speed",
    Range = {-500, -1},
    Increment = 1,
    Suffix = "",
    CurrentValue = -8,
    Flag = "SlideSpeedSlider",
    Callback = function(val)
        slideFrictionValue = val
    end
})

getgenv().autoJumpEnabled = false
getgenv().bhopMode = "Acceleration"
getgenv().bhopAccelValue = -0.1

MainTab:CreateToggle({
    Name = "Bhop",
    CurrentValue = false,
    Flag = "BhopToggle",
    Callback = function(state)
        getgenv().autoJumpEnabled = state
    end
})

MainTab:CreateDropdown({
    Name = "Bhop Mode",
    Options = {"Acceleration", "No Acceleration"},
    CurrentOption = {"Acceleration"},
    MultipleOptions = false,
    Flag = "BhopModeDropdown",
    Callback = function(opt)
        getgenv().bhopMode = opt[1]
    end
})

MainTab:CreateSlider({
    Name = "Bhop Acceleration",
    Range = {-5, -0.01},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = -0.1,
    Flag = "BhopAccelSlider",
    Callback = function(val)
        getgenv().bhopAccelValue = val
    end
})

getgenv().autoCarryEnabled = false
MainTab:CreateToggle({
    Name = "Auto Carry",
    CurrentValue = false,
    Flag = "AutoCarry",
    Callback = function(state)
        getgenv().autoCarryEnabled = state
    end
})

getgenv().SelectedEmote = nil
getgenv().EmoteEnabled = false

local emoteList = {}
local success, emotesFolder = pcall(function() return game:GetService("ReplicatedStorage").Items.Emotes end)
if success and typeof(emotesFolder) == "Instance" then
    for _, emote in ipairs(emotesFolder:GetChildren()) do
        if emote:IsA("ModuleScript") or emote:IsA("LocalScript") or emote:IsA("Script") then
            table.insert(emoteList, emote.Name)
        end
    end
    table.sort(emoteList)
end

MainTab:CreateDropdown({
    Name = "Select Emote",
    Options = emoteList,
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "EmoteSelect",
    Callback = function(opt)
        getgenv().SelectedEmote = opt[1]
    end
})

MainTab:CreateToggle({
    Name = "Enable Emote (Hold Crouch)",
    CurrentValue = false,
    Flag = "EmoteEnable",
    Callback = function(state)
        getgenv().EmoteEnabled = state
    end
})

getgenv().lagSwitchEnabled = false
getgenv().lagDuration = 0.5

MiscTab:CreateToggle({
    Name = "Lag Switch (Patched)",
    CurrentValue = false,
    Flag = "LagSwitch",
    Callback = function(state)
        getgenv().lagSwitchEnabled = state
    end
})

MiscTab:CreateSlider({
    Name = "Lag Duration (s)",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "LagDurationSlider",
    Callback = function(val)
        getgenv().lagDuration = val
    end
})

MiscTab:CreateLabel("Mid-Journey — SJAD © 2025")

task.spawn(function()
    while true do
        local friction = 5
        if getgenv().autoJumpEnabled and getgenv().bhopMode == "Acceleration" then
            friction = getgenv().bhopAccelValue or -5
        end
        if not getgenv().autoJumpEnabled then friction = 5 end
        for _, t in pairs(getgc(true)) do
            if type(t) == "table" and rawget(t, "Friction") then
                if getgenv().bhopMode == "No Acceleration" then
                else
                    t.Friction = friction
                end
            end
        end
        task.wait(0.15)
    end
end)

task.spawn(function()
    while true do
        if getgenv().autoJumpEnabled then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                local humanoid = character.Humanoid
                if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            task.wait(getgenv().bhopMode == "No Acceleration" and 0.05 or 0)
        else
            task.wait()
        end
    end
end)

task.spawn(function()
    while true do
        if getgenv().autoCarryEnabled then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
                    if other ~= game.Players.LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (hrp.Position - other.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= 20 then
                            local args = { "Carry", [3] = other.Name }
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Character"):WaitForChild("Interact"):FireServer(unpack(args))
                            end)
                            task.wait(0.01)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local guiPath = { "PlayerGui", "Shared", "HUD", "Mobile", "Right", "Mobile", "CrouchButton" }

    local function waitForDescendant(parent, name)
        local found = parent:FindFirstChild(name, true)
        while not found do
            parent.DescendantAdded:Wait()
            found = parent:FindFirstChild(name, true)
        end
        return found
    end

    local function connectCrouchButton()
        local gui = player:WaitForChild(guiPath[1])
        for i = 2, #guiPath do
            gui = waitForDescendant(gui, guiPath[i])
        end
        local button = gui
        local holding = false
        local validHold = false
        button.MouseButton1Down:Connect(function()
            holding = true
            validHold = true
            task.delay(0.5, function()
                if holding and validHold and getgenv().EmoteEnabled and getgenv().SelectedEmote then
                    local args = { [1] = getgenv().SelectedEmote }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("Character", 9e9):WaitForChild("Emote", 9e9):FireServer(unpack(args))
                end
            end)
        end)
        button.MouseButton1Up:Connect(function()
            holding = false
            validHold = false
        end)
    end
    while true do
        pcall(connectCrouchButton)
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if getgenv().lagSwitchEnabled then
        end
        task.wait()
    end
end)
