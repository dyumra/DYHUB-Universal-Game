-- === DYHUB Aimbot & ESP | FULL === --
local player = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 3
        })
    end)
end

notify("📊 DYHUB Loaded")

local function getRainbowColor(t)
    local freq = 2
    return Color3.fromRGB(
        math.floor(math.sin(freq * t + 0) * 127 + 128),
        math.floor(math.sin(freq * t + 2) * 127 + 128),
        math.floor(math.sin(freq * t + 4) * 127 + 128)
    )
end

-- === GUI ===
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 500)
frame.Position = UDim2.new(0.5, -150, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "DYHUB | Aimbot & ESP"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)

RunService.RenderStepped:Connect(function()
    local c = getRainbowColor(tick())
    stroke.Color = c
    title.TextColor3 = c
end)

local function createBtn(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local posY = 40
local AimbotOn, SmoothAimbot, WallAimbot = false, false, false
local ESPOn, ESPTeam, ShowName = false, false, false
local AimbotTargetPart, targetParts, partIndex = "Head", {"Head", "UpperTorso", "Torso"}, 1
local ESPMode, espModes, modeIndex = "Highlight", {"Highlight", "BoxHighlight"}, 1
local ESPColor = Color3.new(1,1,1)
local ESPRainbow = false

local aimbotBtn = createBtn("Aimbot: OFF", posY)
aimbotBtn.MouseButton1Click:Connect(function()
    AimbotOn = not AimbotOn
    aimbotBtn.Text = "Aimbot: " .. (AimbotOn and "ON" or "OFF")
    notify(aimbotBtn.Text)
end)

posY += 35
local smoothBtn = createBtn("Smooth Aimbot: OFF", posY)
smoothBtn.MouseButton1Click:Connect(function()
    SmoothAimbot = not SmoothAimbot
    smoothBtn.Text = "Smooth Aimbot: " .. (SmoothAimbot and "ON" or "OFF")
    notify(smoothBtn.Text)
end)

posY += 35
local wallBtn = createBtn("Wall Aimbot: OFF", posY)
wallBtn.MouseButton1Click:Connect(function()
    WallAimbot = not WallAimbot
    wallBtn.Text = "Wall Aimbot: " .. (WallAimbot and "ON" or "OFF")
    notify(wallBtn.Text)
end)

posY += 35
local lockBtn = createBtn("Target Lock: Head", posY)
lockBtn.MouseButton1Click:Connect(function()
    partIndex = partIndex % #targetParts + 1
    AimbotTargetPart = targetParts[partIndex]
    lockBtn.Text = "Target Lock: " .. AimbotTargetPart
    notify(lockBtn.Text)
end)

posY += 35
local espBtn = createBtn("ESP: OFF", posY)
espBtn.MouseButton1Click:Connect(function()
    ESPOn = not ESPOn
    espBtn.Text = "ESP: " .. (ESPOn and "ON" or "OFF")
    notify(espBtn.Text)
end)

posY += 35
local espTeamBtn = createBtn("ESP Team: OFF", posY)
espTeamBtn.MouseButton1Click:Connect(function()
    ESPTeam = not ESPTeam
    espTeamBtn.Text = "ESP Team: " .. (ESPTeam and "ON" or "OFF")
    notify(espTeamBtn.Text)
end)

posY += 35
local espModeBtn = createBtn("ESP Model: Highlight", posY)
espModeBtn.MouseButton1Click:Connect(function()
    modeIndex = modeIndex % #espModes + 1
    ESPMode = espModes[modeIndex]
    espModeBtn.Text = "ESP Model: " .. ESPMode
    notify(espModeBtn.Text)
end)

posY += 35
local nameBtn = createBtn("Show Name: OFF", posY)
nameBtn.MouseButton1Click:Connect(function()
    ShowName = not ShowName
    nameBtn.Text = "Show Name: " .. (ShowName and "ON" or "OFF")
    notify(nameBtn.Text)
end)

posY += 35
local colorLabel = Instance.new("TextLabel", frame)
colorLabel.Size = UDim2.new(1, -20, 0, 25)
colorLabel.Position = UDim2.new(0, 10, 0, posY)
colorLabel.Text = "ESP Color (Red, Blue, Rainbow)"
colorLabel.Font = Enum.Font.GothamBold
colorLabel.TextScaled = true
colorLabel.TextColor3 = Color3.new(1,1,1)
colorLabel.BackgroundTransparency = 1

posY += 30
local colorBox = Instance.new("TextBox", frame)
colorBox.Size = UDim2.new(1, -20, 0, 30)
colorBox.Position = UDim2.new(0, 10, 0, posY)
colorBox.PlaceholderText = "Red"
colorBox.Font = Enum.Font.Gotham
colorBox.TextColor3 = Color3.new(1,1,1)
colorBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0, 8)

colorBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local val = colorBox.Text:lower()
    ESPRainbow = false
    if val == "red" then ESPColor = Color3.fromRGB(255,0,0)
    elseif val == "green" then ESPColor = Color3.fromRGB(0,255,0)
    elseif val == "blue" then ESPColor = Color3.fromRGB(0,0,255)
    elseif val == "yellow" then ESPColor = Color3.fromRGB(255,255,0)
    elseif val == "rainbow" then ESPRainbow = true
    else ESPColor = Color3.new(1,1,1) end
    notify("ESP Color: " .. val)
end)

-- === Aimbot & ESP ===
local highlights, boxes, names = {}, {}, {}
local CurrentTarget = nil

local function validTarget(p)
    return p and p.Character and p.Character:FindFirstChild(AimbotTargetPart)
       and p.Character:FindFirstChild("Humanoid")
       and p.Character.Humanoid.Health > 0
end

local function behindWall(p)
    local o = Camera.CFrame.Position
    local d = (p.Character[AimbotTargetPart].Position - o)
    local r = Ray.new(o, d)
    local hit = workspace:FindPartOnRay(r, player.Character)
    return hit and not p.Character:IsAncestorOf(hit)
end

local function getClosest()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and validTarget(p) and (not ESPTeam or p.Team ~= player.Team) then
            local screen, onScreen = Camera:WorldToViewportPoint(p.Character[AimbotTargetPart].Position)
            if onScreen then
                local mag = (Vector2.new(screen.X, screen.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    dist = mag
                    closest = p
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotOn then
        if not validTarget(CurrentTarget)
          or (not WallAimbot and behindWall(CurrentTarget)) then
            CurrentTarget = getClosest()
        end
        if CurrentTarget and validTarget(CurrentTarget) then
            local goal = CFrame.new(Camera.CFrame.Position, CurrentTarget.Character[AimbotTargetPart].Position)
            if SmoothAimbot then
                Camera.CFrame = Camera.CFrame:Lerp(goal, 0.2)
            else
                Camera.CFrame = goal
            end
        end
    else
        CurrentTarget = nil
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        local valid = validTarget(p) and (not ESPTeam or p.Team ~= player.Team)
        if ESPOn and valid then
            if not highlights[p] and ESPMode == "Highlight" then
                local h = Instance.new("Highlight", p.Character)
                h.Adornee = p.Character
                h.FillTransparency = 0.5
                highlights[p] = h
            elseif not boxes[p] and ESPMode == "BoxHighlight" then
                local b = Instance.new("BoxHandleAdornment", p.Character)
                b.Adornee = p.Character:FindFirstChild("HumanoidRootPart")
                b.Size = Vector3.new(4, 6, 2)
                b.AlwaysOnTop = true
                b.ZIndex = 5
                b.Transparency = 0.5
                boxes[p] = b
            end
            local c = ESPRainbow and getRainbowColor(tick()) or ESPColor
            if highlights[p] then highlights[p].FillColor = c end
            if boxes[p] then boxes[p].Color3 = c end
            if ShowName and not names[p] then
                local bb = Instance.new("BillboardGui", p.Character)
                bb.Adornee = p.Character:FindFirstChild("Head")
                bb.Size = UDim2.new(0, 200, 0, 50)
                bb.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.Text = p.DisplayName .. "(@" .. p.Name .. ")"
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextScaled = true
                names[p] = bb
            elseif not ShowName and names[p] then
                names[p]:Destroy()
                names[p] = nil
            end
        else
            if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
            if boxes[p] then boxes[p]:Destroy() boxes[p]=nil end
            if names[p] then names[p]:Destroy() names[p]=nil end
        end
    end
end)
