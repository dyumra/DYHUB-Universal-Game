-- === DYHUB Aimbot & ESP | Highlight ONLY === --

local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Mouse = player:GetMouse()

local function notify(text)
    StarterGui:SetCore("SendNotification", {Title = "DYHUB", Text = text, Duration = 3})
end

notify("✅ DYHUB Loaded | Join our (.gg/DYHUBGG)")

local function getRainbowColor(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f * t + 0) * 127 + 128),
        math.floor(math.sin(f * t + 2) * 127 + 128),
        math.floor(math.sin(f * t + 4) * 127 + 128)
    )
end

-- === GUI ===
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DYHUB | Aimbot + ESP"
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local c = getRainbowColor(tick())
    stroke.Color = c
    title.TextColor3 = c
end)

local function createBtn(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 30)
    b.Position = UDim2.new(0, 10, 0, y)
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
local Aimbot, Smooth, ESP, TeamOnly, ShowName = false, false, false, false, false
local FOV, TargetPart = 100, "Head"
local lockParts, lockIndex = {"Head","UpperTorso","Torso"}, 1
local espCustomColor = Color3.fromRGB(255,255,255)
local highlights = {}

local aimBtn = createBtn("Aimbot: OFF", posY)
aimBtn.MouseButton1Click:Connect(function()
    Aimbot = not Aimbot
    aimBtn.Text = "Aimbot: " .. (Aimbot and "ON" or "OFF")
    notify(aimBtn.Text)
end)

posY += 35
local smoothBtn = createBtn("Smooth: OFF", posY)
smoothBtn.MouseButton1Click:Connect(function()
    Smooth = not Smooth
    smoothBtn.Text = "Smooth: " .. (Smooth and "ON" or "OFF")
    notify(smoothBtn.Text)
end)

posY += 35
local lockBtn = createBtn("Target: Head", posY)
lockBtn.MouseButton1Click:Connect(function()
    lockIndex = lockIndex % #lockParts + 1
    TargetPart = lockParts[lockIndex]
    lockBtn.Text = "Target: " .. TargetPart
    notify(lockBtn.Text)
end)

posY += 35
local espBtn = createBtn("ESP: OFF", posY)
espBtn.MouseButton1Click:Connect(function()
    ESP = not ESP
    espBtn.Text = "ESP: " .. (ESP and "ON" or "OFF")
    notify(espBtn.Text)
end)

posY += 35
local teamBtn = createBtn("Team Only: OFF", posY)
teamBtn.MouseButton1Click:Connect(function()
    TeamOnly = not TeamOnly
    teamBtn.Text = "Team Only: " .. (TeamOnly and "ON" or "OFF")
    notify(teamBtn.Text)
end)

posY += 35
local showBtn = createBtn("Show Name: OFF", posY)
showBtn.MouseButton1Click:Connect(function()
    ShowName = not ShowName
    showBtn.Text = "Show Name: " .. (ShowName and "ON" or "OFF")
    notify(showBtn.Text)
end)

posY += 35
local box = Instance.new("TextBox", mainFrame)
box.Size = UDim2.new(1,-20,0,30)
box.Position = UDim2.new(0,10,0,posY)
box.PlaceholderText = "Color: red, rainbow..."
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

box.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = box.Text:lower()
        if val == "red" then espCustomColor = Color3.fromRGB(255,0,0)
        elseif val == "green" then espCustomColor = Color3.fromRGB(0,255,0)
        elseif val == "blue" then espCustomColor = Color3.fromRGB(0,0,255)
        elseif val == "yellow" then espCustomColor = Color3.fromRGB(255,255,0)
        elseif val == "rainbow" then espCustomColor = "rainbow"
        else espCustomColor = Color3.fromRGB(255,255,255) end
        notify("ESP Color: " .. val)
    end
end)

local function getClosest()
    local closest, dist = nil, FOV
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamOnly and p.Team == player.Team then continue end
            local part = p.Character[TargetPart]
            local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local m = (Vector2.new(screen.X,screen.Y) - Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                if m < dist then dist = m; closest = p end
            end
        end
    end
    return closest
end

local target = nil

RunService.RenderStepped:Connect(function()
    if Aimbot then
        target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(TargetPart) then
            local goal = CFrame.new(Camera.CFrame.Position, target.Character[TargetPart].Position)
            Camera.CFrame = Smooth and Camera.CFrame:Lerp(goal, 0.2) or goal
        end
    end

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local isTeam = p.Team == player.Team
            if ESP then
                if TeamOnly and isTeam then
                    if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
                    continue
                end
                if not highlights[p] then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Adornee = p.Character
                    hl.FillTransparency = 0.4
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
