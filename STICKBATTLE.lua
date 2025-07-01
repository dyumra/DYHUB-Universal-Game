--[[
  === DYHUB | Stick Battles ===
  Version: 2.0.0.0.0.0.0.8
  ===== DYHUB'S TEAM =====
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local MIN_Y_COORDINATE = -50

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = txt,
            Duration = 3
        })
    end)
end

local function getRainbow(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f*t+0)*127+128),
        math.floor(math.sin(f*t+2)*127+128),
        math.floor(math.sin(f*t+4)*127+128)
    )
end

notify("✅ DYHUB Loaded for Stick Battles")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | Stick Battles"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 300)
frame.Position = UDim2.new(0.5, -135, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Stick Battles | DYHUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function createBtn(text, posY)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local KillAll, ESP = false, false
local TargetPart = "Head"
local ESPMode = "Highlight"
local ESPColor = Color3.new(1,1,1)
local Rainbow = false
local KillAllIndex = 1
local PositionMode = "Front"
local parts = {"Head", "Torso"}
local partIdx = 1

local posY = 50

local btnKillAll = createBtn("Kill All: OFF", posY)
btnKillAll.MouseButton1Click:Connect(function()
    KillAll = not KillAll
    btnKillAll.Text = "Kill All: " .. (KillAll and "ON" or "OFF")
    notify(btnKillAll.Text)
    if KillAll then
        KillAllIndex = 1
    end
end)
posY = posY + 38

local btnPosition = createBtn("Position: Front", posY)
btnPosition.MouseButton1Click:Connect(function()
    PositionMode = PositionMode == "Front" and "Behind" or "Front"
    btnPosition.Text = "Position: " .. PositionMode
    notify(btnPosition.Text)
end)
posY = posY + 38

local btnESP = createBtn("ESP: OFF", posY)
btnESP.MouseButton1Click:Connect(function()
    ESP = not ESP
    btnESP.Text = "ESP: " .. (ESP and "ON" or "OFF")
    notify(btnESP.Text)
end)
posY = posY + 38

local btnESPMode = createBtn("ESP Mode: Highlight", posY)
btnESPMode.MouseButton1Click:Connect(function()
    ESPMode = ESPMode == "Highlight" and "Box" or "Highlight"
    btnESPMode.Text = "ESP Mode: " .. ESPMode
    notify(btnESPMode.Text)
end)
posY = posY + 38

local btnTargetPart = createBtn("Target Lock: Head", posY)
btnTargetPart.MouseButton1Click:Connect(function()
    partIdx = partIdx % #parts + 1
    TargetPart = parts[partIdx]
    btnTargetPart.Text = "Target Lock: " .. TargetPart
    notify(btnTargetPart.Text)
end)

local highlights, boxes = {}

local function valid(p)
    return p and p.Character and p.Character:FindFirstChild(TargetPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local function getEnemies()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and valid(p) then
            table.insert(list, p)
        end
    end
    return list
end

local function getPositionCFrame(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = target.Character.HumanoidRootPart
    local offset = PositionMode == "Front" and hrp.CFrame.LookVector * 3 or -hrp.CFrame.LookVector * 3
    return CFrame.new(hrp.Position + offset, hrp.Position)
end

local CurrentTarget = nil
local lastTeleportTime = 0
local TELEPORT_DELAY = 1.5

RunService.RenderStepped:Connect(function()
    if KillAll then
        local enemies = getEnemies()
        if #enemies > 0 then
            local currentTime = tick()
            if not CurrentTarget or not valid(CurrentTarget) or (currentTime - lastTeleportTime >= TELEPORT_DELAY) then
                local foundNewTarget = false
                local startIdx = KillAllIndex
                repeat
                    KillAllIndex = (KillAllIndex % #enemies) + 1
                    CurrentTarget = enemies[KillAllIndex]
                    if valid(CurrentTarget) then
                        foundNewTarget = true
                        break
                    end
                    if KillAllIndex == startIdx then break end
                until foundNewTarget
                if not foundNewTarget then CurrentTarget = nil else lastTeleportTime = currentTime end
            end
        else
            CurrentTarget = nil
        end

        if CurrentTarget and valid(CurrentTarget) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = getPositionCFrame(CurrentTarget)
            if pos then player.Character.HumanoidRootPart.CFrame = pos end
        else
            CurrentTarget = nil
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        if ESP and valid(p) then
            local c = Rainbow and getRainbow(tick()) or ESPColor
            if ESPMode == "Highlight" then
                if not highlights[p] then
                    local h = Instance.new("Highlight")
                    h.Adornee = p.Character
                    h.FillTransparency = 0.5
                    h.Parent = p.Character
                    highlights[p] = h
                    if boxes[p] then boxes[p]:Destroy() boxes[p] = nil end
                end
                highlights[p].FillColor = c
            elseif ESPMode == "Box" then
                local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
                if root then
                    if not boxes[p] then
                        local b = Instance.new("BoxHandleAdornment")
                        b.Adornee = root
                        b.Size = Vector3.new(4,6,2)
                        b.AlwaysOnTop = true
                        b.ZIndex = 5
                        b.Transparency = 0.5
                        b.Color3 = c
                        b.Parent = root
                        boxes[p] = b
                        if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
                    else
                        boxes[p].Color3 = c
                    end
                end
            end
        else
            if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
            if boxes[p] then boxes[p]:Destroy() boxes[p] = nil end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local c = getRainbow(tick())
    stroke.Color = c
    title.TextColor3 = c
    toggleBtn.TextColor3 = c
end)
