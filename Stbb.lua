repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer
local GetReadyRemote = ReplicatedStorage:WaitForChild("GetReadyRemote")
local SkipHelicopterRemote = ReplicatedStorage:WaitForChild("SkipHelicopter")
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

local autoFarmActive = false
local autoReadyActive = false
local autoSkipHelicopterActive = false
local flushAuraActive = false
local espActive = false

local movementMode = "Teleport"
local espMode = "Highlight"

local visitedNPCs = {}
local pressCount = {}
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function createBillboard(model, humanoid)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DYHUB_ESP_Billboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = workspace

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    local function updateText()
        if humanoid and humanoid.Health and humanoid.MaxHealth then
            local nameText = model.Name or "NPC"
            local healthText = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
            textLabel.Text = nameText .. "\n" .. healthText
        else
            textLabel.Text = model.Name or "NPC"
        end
    end

    updateText()

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if humanoid and humanoid.Health <= 0 then
            billboard:Destroy()
            if conn then
                conn:Disconnect()
                conn = nil
            end
        else
            updateText()
        end
    end)

    table.insert(espObjects, billboard)
end

local function applyESPToModel(model)
    if espMode == "Highlight" then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = workspace
        table.insert(espObjects, highlight)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            createBillboard(model, humanoid)
        end
    elseif espMode == "BoxHandle" then
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 2)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.Parent = workspace.Terrain
        table.insert(espObjects, box)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            createBillboard(model, humanoid)
        end
    end
end

local function updateESP()
    clearESP()
    if not espActive then return end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        applyESPToModel(char)
    end

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    applyESPToModel(npc)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if espActive then
            pcall(updateESP)
        else
            clearESP()
        end
        task.wait(1)
    end
end)

local function isVisited(npc)
    for _, v in ipairs(visitedNPCs) do
        if v == npc then return true end
    end
    return false
end

local function addVisited(npc)
    table.insert(visitedNPCs, npc)
end

local function removeVisited(npc)
    for i, v in ipairs(visitedNPCs) do
        if v == npc then
            table.remove(visitedNPCs, i)
            break
        end
    end
    pressCount[npc] = nil
end

local function keepModifyProximityPrompts()
    spawn(function()
        while true do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.HoldDuration ~= 0 then
                        obj.HoldDuration = 0
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end
keepModifyProximityPrompts()

local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC, closestPrompt = nil, nil

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                for _, prompt in pairs(npc:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" then
                        if (pressCount[npc] or 0) < 3 then
                            local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                            if dist < lastDist then
                                closestNPC, closestPrompt = npc, prompt
                                lastDist = dist
                            end
                        end
                    end
                end
            end
        end
    end

    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoidNoProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil

    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local hasProximity = false
                        for _, child in pairs(npc:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                hasProximity = true
                                break
                            end
                        end
                        if not hasProximity then
                            local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                            if dist < lastDist then
                                closestNPC = npc
                                lastDist = dist
                            end
                        end
                    end
                end
            end
        end
    end

    return closestNPC
end

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPos)}

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

local function teleportToTarget(targetPos, duration)
    if movementMode == "CFrame" then
        smoothTeleportTo(targetPos, duration or 0.5)
    else
        instantTeleportTo(targetPos)
    end
end

local function attackHumanoidNoProximity(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")

    if humanoid and hrp and humanoid.Health > 0 then
        while humanoid.Health > 0 and autoFarmActive do
            teleportToTarget(hrp.Position + Vector3.new(0, 3, 0), 0.5)
            LMBRemote:FireServer()
            task.wait(0.1)
        end
        removeVisited(npc)
    end
end

local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc, prompt = findNextNPCWithFlushProximity(1000, hrp)
                    if npc and prompt and prompt.Parent then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local targetPos = prompt.Parent.Position + Vector3.new(0, 3, 0)
                            teleportToTarget(targetPos, 0.5)
                            while (pressCount[npc] or 0) < 3 do
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                                pressCount[npc] = (pressCount[npc] or 0) + 1
                                task.wait(0.15)
                            end
                            addVisited(npc)
                        else
                            removeVisited(npc)
                        end
                    else
                        local npc2 = findNextNPCWithHumanoidNoProximity(1000, hrp)
                        if npc2 then
                            if not isVisited(npc2) then
                                addVisited(npc2)
                            end
                            attackHumanoidNoProximity(npc2)
                        else
                            visitedNPCs = {}
                            pressCount = {}
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

local function flushAura()
    task.spawn(function()
        while flushAuraActive do
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" then
                        local dist = (prompt.Parent.Position - hrp.Position).Magnitude
                        if dist <= 1000 then
                            pcall(function()
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                            end)
                            task.wait(0.2)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

local function sendReady(value)
    GetReadyRemote:FireServer("1", value)
end

local function startAutoReady()
    task.spawn(function()
        sendReady(true)
        while autoReadyActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                sendReady(true)
            end
            task.wait(1)
        end
        sendReady(false)
    end)
end

local function startAutoSkipHelicopter()
    task.spawn(function()
        while autoSkipHelicopterActive do
            pcall(function()
                SkipHelicopterRemote:FireServer()
            end)
            task.wait(1)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoFarmActive then startAutoFarm() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
    if flushAuraActive then flushAura() end
end)

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - ST : Blockade Battlefront",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB TEAM - Join us at dsc.gg/dyhub",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - ST : Blockade Battlefront (Version: 2.2)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(600, 400),
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

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })

MainTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value)
        movementMode = value
    end,
})

MainTab:Toggle({
    Title = "Auto Farm (Op)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

MainTab:Toggle({
    Title = "Flush Aura (Beta)",
    Default = false,
    Callback = function(value)
        flushAuraActive = value
        if flushAuraActive then
            flushAura()
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Ready",
    Default = false,
    Callback = function(value)
        autoReadyActive = value
        if autoReadyActive then
            startAutoReady()
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Skip Helicopter",
    Default = false,
    Callback = function(value)
        autoSkipHelicopterActive = value
        if autoSkipHelicopterActive then
            startAutoSkipHelicopter()
        end
    end,
})

local CodesTab = Window:Tab({ Title = "Codes", Icon = "bird" })

local redeemCodes = {
    "AstroInvasionBegin",
    "WaveStuckIssue",
    "50KGroup",
    "DarkDriveIssue",
    "Digi",
}

local selectedCodes = {}

CodesTab:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value)
        selectedCodes = value or {}
    end,
})

CodesTab:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        for _, codeKey in ipairs(selectedCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

CodesTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, codeKey in ipairs(redeemCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("RedeemCode"):FireServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })

EspTab:Dropdown({
    Title = "ESP Mode",
    Values = {"Highlight", "BoxHandle"},
    Default = espMode,
    Multi = false,
    Callback = function(value)
        espMode = value
        if espActive then
            updateESP()
        end
    end,
})

EspTab:Toggle({
    Title = "ESP (Enemy)",
    Default = false,
    Callback = function(value)
        espActive = value
        if espActive then
            updateESP()
        else
            clearESP()
        end
    end,
})

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local QuestTab = Window:Tab({ Title = "Auto Quest", Icon = "sword" })

QuestTab:Button({
    Title = "Open Menu (Quest Clock-Man)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestClockManUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

QuestTab:Button({
    Title = "Open Menu (Quest)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

QuestTab:Button({
    Title = "Auto Quest (Beta)",
    Callback = function()
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

local GameTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Gamepasst = {
    "LuckyBoost",
    "RareLuckyBoost",
    "LegendaryLuckyBoost",
    "All"
}

local Gamepassts = {}

GameTab:Dropdown({
    Title = "Select Gamepass",
    Multi = true,
    Values = Gamepasst,
    Callback = function(value)
        Gamepassts = value or {}
    end,
})

GameTab:Button({
    Title = "Unlock Selected Gamepass",
    Callback = function()
        local gachaData = player:FindFirstChild("GachaData")
        if not gachaData then
            gachaData = Instance.new("Folder")
            gachaData.Name = "GachaData"
            gachaData.Parent = player
        end

        local toUnlock = {}

        for _, v in ipairs(Gamepassts) do
            if v == "All" then
                toUnlock = {"LuckyBoost", "RareLuckyBoost", "LegendaryLuckyBoost"}
                break
            else
                table.insert(toUnlock, v)
            end
        end

        for _, gamepassName in ipairs(toUnlock) do
            pcall(function()
                local boolValue = gachaData:FindFirstChild(gamepassName)
                if not boolValue then
                    boolValue = Instance.new("BoolValue")
                    boolValue.Name = gamepassName
                    boolValue.Parent = gachaData
                end
                boolValue.Value = true
                task.wait(0.2)
            end)
        end
    end,
})

PlayerTab:Button({
    Title = "Open Menu (Helicopter)",
    Callback = function()
        local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("003-A")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
})

-- Player Tab Vars
getgenv().speedEnabled = false
getgenv().speedValue = 20

PlayerTab:Slider({
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

PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50

PlayerTab:Slider({
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

PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end
})

local noclipConnection

PlayerTab:Toggle({
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

PlayerTab:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local uis = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer
        local infJumpConnection

        if state then
            infJumpConnection = uis.JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            getgenv().infJumpConnection = infJumpConnection
        else
            if getgenv().infJumpConnection then
                getgenv().infJumpConnection:Disconnect()
                getgenv().infJumpConnection = nil
            end
        end
    end
})

PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})

-- Misc Tab Vars for Lighting Effects
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogStart = Lighting.FogStart
local oldFogEnd = Lighting.FogEnd
local oldFogColor = Lighting.FogColor

local fullBrightConnection
local noFogConnection

MiscTab:Toggle({
    Title = "FullBright",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 5
            Lighting.ClockTime = 14

            fullBrightConnection = RunService.RenderStepped:Connect(function()
                if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
                if Lighting.Brightness ~= 10 then Lighting.Brightness = 10 end
                if Lighting.Ambient ~= Color3.new(1,1,1) then Lighting.Ambient = Color3.new(1,1,1) end
            end)
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            Lighting.Ambient = oldAmbient
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e10
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)

            noFogConnection = RunService.RenderStepped:Connect(function()
                if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end
                if Lighting.FogEnd ~= 1e10 then Lighting.FogEnd = 1e10 end
                if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then Lighting.FogColor = Color3.fromRGB(255, 255, 255) end
            end)
        else
            if noFogConnection then
                noFogConnection:Disconnect()
                noFogConnection = nil
            end
            Lighting.FogStart = oldFogStart
            Lighting.FogEnd = oldFogEnd
            Lighting.FogColor = oldFogColor
        end
    end
})

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name = "VibrantEffect"
vibrantEffect.Saturation = 1
vibrantEffect.Contrast = 0.4
vibrantEffect.Brightness = 0.05
vibrantEffect.Enabled = false
vibrantEffect.Parent = Lighting

MiscTab:Toggle({
    Title = "Vibrant Colors 200%",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            vibrantEffect.Enabled = true
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            vibrantEffect.Enabled = false
        end
    end
})

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), false, true, showPing
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

MiscTab:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

MiscTab:Toggle({
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

MiscTab:Button({
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

print("[DYHUB] DYHUB - Loaded! (Console Show)")
