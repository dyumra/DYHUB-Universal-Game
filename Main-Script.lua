-- === DYHUB Aimbot & ESP | Compact FULL === --

local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Mouse = player:GetMouse()

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 3
        })
    end)
end

notify("🛡️ DYHUB | Join our (.gg/DYHUBGG)")

local function getRainbowColor(tick)
    local freq = 2
    return Color3.fromRGB(
        math.floor(math.sin(freq * tick + 0) * 127 + 128),
        math.floor(math.sin(freq * tick + 2) * 127 + 128),
        math.floor(math.sin(freq * tick + 4) * 127 + 128)
    )
end

-- === GUI ===
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "DYHUB | Aimbot & ESP"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local c = getRainbowColor(tick())
    stroke.Color = c
    title.TextColor3 = c
end)

local function createBtn(text, posY)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,30)
    b.Position = UDim2.new(0,10,0,posY)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Parent = mainFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local posY = 40
local AimbotEnabled, SmoothAimbot, ESPEnabled, ESPTeamOnly, ESPMyself, ShowName = false, false, false, false, false, false
local Target = nil
local FOV, AimbotTargetPart = 70, "Head"
local lockParts, lockIndex = {"Head","UpperTorso","Torso"}, 1
local espModels, espModelIndex, ESPModel = {"Highlight","BoxHighlight"}, 1, "Highlight"
local espCustomColor, espFillTransparency = Color3.fromRGB(255,255,255), 0.5
local espRainbowTick = 0

local aimbotBtn = createBtn("Aimbot: OFF", posY)
aimbotBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    aimbotBtn.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
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
local lockBtn = createBtn("Target Lock: Head", posY)
lockBtn.MouseButton1Click:Connect(function()
    lockIndex = lockIndex % #lockParts + 1
    AimbotTargetPart = lockParts[lockIndex]
    lockBtn.Text = "Target Lock: " .. AimbotTargetPart
    notify(lockBtn.Text)
end)

posY += 35
local espBtn = createBtn("ESP: OFF", posY)
espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    notify(espBtn.Text)
end)

posY += 35
local espTeamBtn = createBtn("ESP Team: OFF", posY)
espTeamBtn.MouseButton1Click:Connect(function()
    ESPTeamOnly = not ESPTeamOnly
    espTeamBtn.Text = "ESP Team: " .. (ESPTeamOnly and "ON" or "OFF")
    notify(espTeamBtn.Text)
end)

posY += 35
local espMyselfBtn = createBtn("ESP Myself: OFF", posY)
espMyselfBtn.MouseButton1Click:Connect(function()
    ESPMyself = not ESPMyself
    espMyselfBtn.Text = "ESP Myself: " .. (ESPMyself and "ON" or "OFF")
    notify(espMyselfBtn.Text)
end)

posY += 35
local espModelBtn = createBtn("ESP Model: Highlight", posY)
espModelBtn.MouseButton1Click:Connect(function()
    espModelIndex = espModelIndex % #espModels + 1
    ESPModel = espModels[espModelIndex]
    espModelBtn.Text = "ESP Model: " .. ESPModel
    notify(espModelBtn.Text)
end)

posY += 35
local showNameBtn = createBtn("Show Name: OFF", posY)
showNameBtn.MouseButton1Click:Connect(function()
    ShowName = not ShowName
    showNameBtn.Text = "Show Name: " .. (ShowName and "ON" or "OFF")
    notify(showNameBtn.Text)
end)

posY += 35
local colorLabel = Instance.new("TextLabel", mainFrame)
colorLabel.Size = UDim2.new(1,-20,0,25)
colorLabel.Position = UDim2.new(0,10,0,posY)
colorLabel.Text = "ESP Color (e.g Red,Rainbow)"
colorLabel.TextColor3 = Color3.new(1,1,1)
colorLabel.BackgroundTransparency = 1
colorLabel.Font = Enum.Font.GothamBold
colorLabel.TextScaled = true

posY += 25
local colorBox = Instance.new("TextBox", mainFrame)
colorBox.Size = UDim2.new(1,-20,0,30)
colorBox.Position = UDim2.new(0,10,0,posY)
colorBox.PlaceholderText = "White"
colorBox.Text = ""
colorBox.Font = Enum.Font.Gotham
colorBox.TextColor3 = Color3.new(1,1,1)
colorBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0,10)

colorBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = colorBox.Text:lower()
        if val == "red" then espCustomColor = Color3.fromRGB(255,0,0)
        elseif val == "green" then espCustomColor = Color3.fromRGB(0,255,0)
        elseif val == "blue" then espCustomColor = Color3.fromRGB(0,0,255)
        elseif val == "yellow" then espCustomColor = Color3.fromRGB(255,255,0)
        elseif val == "rainbow" then espCustomColor = "rainbow"
        else espCustomColor = Color3.fromRGB(255,255,255) end
        notify("ESP Color: " .. val)
    end
end)

local highlights = {}

local function getClosest()
    local closest, dist = nil, FOV
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild(AimbotTargetPart) then
            if ESPTeamOnly and p.Team == player.Team then continue end
            local part = p.Character[AimbotTargetPart]
            local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local m = (Vector2.new(screen.X,screen.Y) - Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                if m < dist then dist = m; closest = p end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        Target = getClosest()
        if Target and Target.Character and Target.Character:FindFirstChild(AimbotTargetPart) then
            local goal = CFrame.new(Camera.CFrame.Position, Target.Character[AimbotTargetPart].Position)
            Camera.CFrame = SmoothAimbot and Camera.CFrame:Lerp(goal, 0.2) or goal
        end
    end

    for _,p in pairs(Players:GetPlayers()) do
        if p.Character then
            local teammate = p.Team == player.Team
            if ESPTeamOnly and teammate then if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end continue end

            if ESPEnabled then
                if not highlights[p] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.FillTransparency = espFillTransparency
                    hl.Parent = p.Character
                    highlights[p] = hl
                end
                highlights[p].FillColor = espCustomColor ~= "rainbow" and espCustomColor or getRainbowColor(tick())
                if ShowName then
                    if not p.Character:FindFirstChild("DYHUB_Name") then
                        local bb = Instance.new("BillboardGui", p.Character)
                        bb.Name = "DYHUB_Name"
                        bb.Adornee = p.Character:FindFirstChild("Head")
                        bb.Size = UDim2.new(0,200,0,50)
                        bb.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Size = UDim2.new(1,0,1,0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = p.DisplayName.."(@"..p.Name..")"
                        lbl.TextColor3 = Color3.new(1,1,1)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextScaled = true
                    end
                else
                    local bb = p.Character:FindFirstChild("DYHUB_Name")
                    if bb then bb:Destroy() end
                end
            else
                if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
                local bb = p.Character:FindFirstChild("DYHUB_Name")
                if bb then bb:Destroy() end
            end
        end
    end
end)
