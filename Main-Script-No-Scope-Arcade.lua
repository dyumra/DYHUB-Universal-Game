-- === DYHUB | NO-SCOPE ARCADE ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")

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

notify("✅ DYHUB Loaded")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | Aimbot Menu | No-Scope Arcade"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 420)
frame.Position = UDim2.new(0.5, -125, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "NO-SCOPE ARCADE | DYHUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -50, 0, 10)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

RunService.RenderStepped:Connect(function()
    local c = getRainbow(tick())
    stroke.Color = c
    title.TextColor3 = c
    toggleBtn.TextColor3 = c
end)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function createBtn(text, posY)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 30)
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

local posY = 40
local Aimbot, Smooth, Wall, ESP, ESPTeam, ShowName = false, false, false, false, false, false
local TargetPart, parts, partIdx = "Head", {"Head", "UpperTorso", "Torso"}, 1
local ESPMode = "Highlight"
local ESPColor = Color3.new(1,1,1)
local Rainbow = false

local btn1 = createBtn("Aimbot: OFF", posY)
btn1.MouseButton1Click:Connect(function()
    Aimbot = not Aimbot
    btn1.Text = "Aimbot: " .. (Aimbot and "ON" or "OFF")
    notify(btn1.Text)
end)

posY += 35
local btn2 = createBtn("Smooth Aimbot: OFF", posY)
btn2.MouseButton1Click:Connect(function()
    Smooth = not Smooth
    btn2.Text = "Smooth Aimbot: " .. (Smooth and "ON" or "OFF")
    notify(btn2.Text)
end)

posY += 35
local btn3 = createBtn("Wall Aimbot: OFF", posY)
btn3.MouseButton1Click:Connect(function()
    Wall = not Wall
    btn3.Text = "Wall Aimbot: " .. (Wall and "ON" or "OFF")
    notify(btn3.Text)
end)

posY += 35
local btn4 = createBtn("Target Lock: Head", posY)
btn4.MouseButton1Click:Connect(function()
    partIdx = partIdx % #parts + 1
    TargetPart = parts[partIdx]
    btn4.Text = "Target Lock: " .. TargetPart
    notify(btn4.Text)
end)

posY += 35
local btn5 = createBtn("ESP: OFF", posY)
btn5.MouseButton1Click:Connect(function()
    ESP = not ESP
    btn5.Text = "ESP: " .. (ESP and "ON" or "OFF")
    notify(btn5.Text)
end)

posY += 35
local btn6 = createBtn("ESP Team: OFF", posY)
btn6.MouseButton1Click:Connect(function()
    ESPTeam = not ESPTeam
    btn6.Text = "ESP Team: " .. (ESPTeam and "ON" or "OFF")
    notify(btn6.Text)
end)

posY += 35
local btn7 = createBtn("Show Name: OFF", posY)
btn7.MouseButton1Click:Connect(function()
    ShowName = not ShowName
    btn7.Text = "Show Name: " .. (ShowName and "ON" or "OFF")
    notify(btn7.Text)
end)

posY += 35
local btn8 = createBtn("ESP Mode: Highlight", posY)
btn8.MouseButton1Click:Connect(function()
    ESPMode = ESPMode == "Highlight" and "Box" or "Highlight"
    btn8.Text = "ESP Mode: " .. ESPMode
    notify(btn8.Text)
end)

posY += 35
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -20, 0, 25)
label.Position = UDim2.new(0, 10, 0, posY)
label.Text = "ESP Color: red, blue, black, etc."
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundTransparency = 1

posY += 30
local colorBox = Instance.new("TextBox", frame)
colorBox.Size = UDim2.new(1, -20, 0, 30)
colorBox.Position = UDim2.new(0, 10, 0, posY)
colorBox.PlaceholderText = "Type color (e.g. black)"
colorBox.Text = ""
colorBox.Font = Enum.Font.Gotham
colorBox.TextColor3 = Color3.new(1,1,1)
colorBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0, 8)

colorBox.FocusLost:Connect(function(enter)
    if not enter then return end
    local v = colorBox.Text:lower()
    Rainbow = false
    if v == "red" then ESPColor = Color3.fromRGB(255,0,0)
    elseif v == "blue" then ESPColor = Color3.fromRGB(0,0,255)
    elseif v == "green" then ESPColor = Color3.fromRGB(0,255,0)
    elseif v == "yellow" then ESPColor = Color3.fromRGB(255,255,0)
    elseif v == "black" then ESPColor = Color3.fromRGB(0,0,0)
    elseif v == "white" then ESPColor = Color3.fromRGB(255,255,255)
    elseif v == "pink" then ESPColor = Color3.fromRGB(255,105,180)
    elseif v == "purple" then ESPColor = Color3.fromRGB(128,0,128)
    elseif v == "orange" then ESPColor = Color3.fromRGB(255,165,0)
    elseif v == "cyan" then ESPColor = Color3.fromRGB(0,255,255)
    elseif v == "rainbow" then Rainbow = true
    else ESPColor = Color3.new(1,1,1) end
    notify("ESP Color: " .. v)
end)

local highlights, boxes, names = {}, {}, {}
local CurrentTarget = nil

local function valid(p)
    return p and p.Character and p.Character:FindFirstChild(TargetPart)
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0
end

local function isBehind(p)
    local o = Camera.CFrame.Position
    local d = (p.Character[TargetPart].Position - o)
    local ray = Ray.new(o, d)
    local hit = workspace:FindPartOnRay(ray, player.Character)
    return hit and not p.Character:IsAncestorOf(hit)
end

local function getClosest()
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and valid(p) and p.Team ~= player.Team then
            if not Wall and isBehind(p) then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then dist, best = mag, p end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if Aimbot then
        local validTarget = valid(CurrentTarget)
        local sameTeam = CurrentTarget and CurrentTarget.Team == player.Team
        local behind = CurrentTarget and isBehind(CurrentTarget)

        if not validTarget or sameTeam or (not Wall and behind) then
            CurrentTarget = getClosest()
        end

        if CurrentTarget and valid(CurrentTarget) and CurrentTarget.Team ~= player.Team then
            local goal = CFrame.new(Camera.CFrame.Position, CurrentTarget.Character[TargetPart].Position)
            Camera.CFrame = Smooth and Camera.CFrame:Lerp(goal, 0.2) or goal
        else
            CurrentTarget = nil
        end
    else
        CurrentTarget = nil
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        local v = valid(p) and (not ESPTeam or p.Team ~= player.Team)
        if ESP and v then
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

            if ShowName and not names[p] then
                local bb = Instance.new("BillboardGui", p.Character)
                bb.Adornee = p.Character:FindFirstChild("Head")
                bb.Size = UDim2.new(0, 150, 0, 30)
                bb.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.Text = p.DisplayName.."(@"..p.Name..")"
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Font = Enum.Font.Gotham
                lbl.TextScaled = true
                names[p] = bb
            elseif not ShowName and names[p] then
                names[p]:Destroy() names[p] = nil
            end
        else
            if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
            if boxes[p] then boxes[p]:Destroy() boxes[p] = nil end
            if names[p] then names[p]:Destroy() names[p] = nil end
        end
    end
end)

