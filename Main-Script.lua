-- [[ DYHUB Aimbot & ESP Advanced ]] --

local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local Mouse = player:GetMouse()

-- ===== Notify =====
local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 3
        })
    end)
    print("Notify:", text)
end

notify("🛡️ DYHUB'S TEAM\nJoin our (.gg/DYHUBGG)")

-- ===== Rainbow Color =====
local function getRainbowColor(tick)
    local frequency = 2
    local red = math.floor(math.sin(frequency * tick + 0) * 127 + 128)
    local green = math.floor(math.sin(frequency * tick + 2) * 127 + 128)
    local blue = math.floor(math.sin(frequency * tick + 4) * 127 + 128)
    return Color3.fromRGB(red, green, blue)
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "DupeDYHUBGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 600)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Dupe | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

-- ===== Config =====
local AimbotEnabled = false
local SmoothAimbot = false
local FOV = 70
local AimbotTargetPart = "Head"
local ESPEnabled = false
local ESPTeamOnly = false
local ESPModel = "Highlight"
local ShowName = false

local Target = nil

-- ===== FOV Circle =====
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Radius = FOV
fovCircle.Filled = false
fovCircle.Transparency = 0.5

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    fovCircle.Radius = FOV
    fovCircle.Visible = AimbotEnabled
end)

-- ===== Helpers =====
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = mainFrame
    return btn
end

local function createCycle(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = mainFrame
    return btn
end

local posY = 50

-- === Aimbot Toggle ===
local aimbotBtn = createButton("Aimbot: OFF", posY)
aimbotBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    aimbotBtn.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    notify("Aimbot: " .. (AimbotEnabled and "ON" or "OFF"))
end)

-- === Smooth Toggle ===
posY = posY + 50
local smoothBtn = createButton("Smooth Aimbot: OFF", posY)
smoothBtn.MouseButton1Click:Connect(function()
    SmoothAimbot = not SmoothAimbot
    smoothBtn.Text = "Smooth Aimbot: " .. (SmoothAimbot and "ON" or "OFF")
    notify("Smooth Aimbot: " .. (SmoothAimbot and "ON" or "OFF"))
end)

-- === Target Lock ===
posY = posY + 50
local lockParts = {"Head", "UpperTorso", "Torso"}
local lockIndex = 1
local lockBtn = createCycle("Target Lock: Head", posY)
lockBtn.MouseButton1Click:Connect(function()
    lockIndex += 1
    if lockIndex > #lockParts then lockIndex = 1 end
    AimbotTargetPart = lockParts[lockIndex]
    lockBtn.Text = "Target Lock: " .. AimbotTargetPart
    notify("Target Lock: " .. AimbotTargetPart)
end)

-- === ESP ===
posY = posY + 50
local espBtn = createButton("ESP: OFF", posY)
espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    notify("ESP: " .. (ESPEnabled and "ON" or "OFF"))
end)

-- === ESP Team ===
posY = posY + 50
local espTeamBtn = createButton("ESP Team: OFF", posY)
espTeamBtn.MouseButton1Click:Connect(function()
    ESPTeamOnly = not ESPTeamOnly
    espTeamBtn.Text = "ESP Team: " .. (ESPTeamOnly and "ON" or "OFF")
    notify("ESP Team: " .. (ESPTeamOnly and "ON" or "OFF"))
end)

-- === ESP Model ===
posY = posY + 50
local espModels = {"Highlight", "BoxHighlight"}
local espModelIndex = 1
local espModelBtn = createCycle("ESP Model: Highlight", posY)
espModelBtn.MouseButton1Click:Connect(function()
    espModelIndex += 1
    if espModelIndex > #espModels then espModelIndex = 1 end
    ESPModel = espModels[espModelIndex]
    espModelBtn.Text = "ESP Model: " .. ESPModel
    notify("ESP Model: " .. ESPModel)
end)

-- === Show Name ===
posY = posY + 50
local showNameBtn = createButton("Show Name: OFF", posY)
showNameBtn.MouseButton1Click:Connect(function()
    ShowName = not ShowName
    showNameBtn.Text = "Show Name: " .. (ShowName and "ON" or "OFF")
    notify("Show Name: " .. (ShowName and "ON" or "OFF"))
end)

-- ===== Aimbot Core =====
local highlights = {}

local function getClosestPlayer()
    local closest = nil
    local shortest = FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild(AimbotTargetPart) then
            if ESPTeamOnly and p.Team == player.Team then continue end
            local part = p.Character[AimbotTargetPart]
            local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        if not Target or not Target.Character or not Target.Character:FindFirstChild(AimbotTargetPart) then
            Target = getClosestPlayer()
        else
            local part = Target.Character[AimbotTargetPart]
            if not part or not part:IsDescendantOf(workspace) then
                Target = nil
            else
                local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500)
                local hit = workspace:FindPartOnRay(ray, player.Character)
                if hit and not hit:IsDescendantOf(Target.Character) then
                    Target = nil
                else
                    local goal = CFrame.new(Camera.CFrame.Position, part.Position)
                    if SmoothAimbot then
                        Camera.CFrame = Camera.CFrame:Lerp(goal, 0.15)
                    else
                        Camera.CFrame = goal
                    end
                end
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local isTeamMate = (p.Team == player.Team)
            if ESPTeamOnly and isTeamMate then
                if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
                continue
            end

            if ESPEnabled then
                if not highlights[p] then
                    local hl
                    if ESPModel == "Highlight" then
                        hl = Instance.new("Highlight")
                        hl.Adornee = p.Character
                        hl.Parent = p.Character
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    elseif ESPModel == "BoxHighlight" then
                        hl = Instance.new("BoxHandleAdornment")
                        hl.Adornee = p.Character:FindFirstChild("HumanoidRootPart")
                        hl.Size = Vector3.new(4, 6, 2)
                        hl.Color3 = Color3.new(1,0,0)
                        hl.AlwaysOnTop = true
                        hl.Parent = p.Character
                    end
                    highlights[p] = hl
                end

                if ShowName then
                    if not p.Character:FindFirstChild("DYHUB_Name") then
                        local bb = Instance.new("BillboardGui", p.Character)
                        bb.Name = "DYHUB_Name"
                        bb.Adornee = p.Character:FindFirstChild("Head")
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true

                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = Color3.new(1,1,1)
                        lbl.TextStrokeTransparency = 0
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextScaled = true
                        lbl.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                    end
                else
                    local bb = p.Character:FindFirstChild("DYHUB_Name")
                    if bb then bb:Destroy() end
                end
            else
                if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
                local bb = p.Character:FindFirstChild("DYHUB_Name")
                if bb then bb:Destroy() end
            end
        end
    end
end)
