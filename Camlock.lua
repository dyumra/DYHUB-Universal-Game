-- ================= V522 FIXED ==================
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ================= CONFIG =================
local Target = nil
local CamlockEnabled = false
local ThroughWalls = false
local MenuOpen = true
local LockedTarget = nil
local EspEnabled = false
local TeamCheck = true

local LockParts = {"Head","Torso","UpperTorso","LowerTorso","HumanoidRootPart"}
local LockIndex = 1
local LockPart = LockParts[LockIndex]

local Keybinds = {
    Camlock = Enum.KeyCode.V,
    LockPart = Enum.KeyCode.G,
    ThroughWalls = Enum.KeyCode.H,
    ESP = Enum.KeyCode.T,
    Team = Enum.KeyCode.K,
    Menu = Enum.KeyCode.End
}

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,200,0,280)
Frame.Position = UDim2.new(0.5,0,0.35,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Visible = MenuOpen
Frame.AnchorPoint = Vector2.new(0.5,0)
Frame.Parent = ScreenGui
Frame.ZIndex = 9999

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,15)
local Shadow = Instance.new("UIStroke", Frame)
Shadow.Thickness = 1.5
Shadow.Color = Color3.fromRGB(70,70,70)
Shadow.Transparency = 0.5

-- ================= DRAG =================
local dragging, startPos, startPosFrame
local function update(input)
    local delta = input.Position - startPos
    Frame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
end

local function startDrag(input)
    dragging = true
    startPos = input.Position
    startPosFrame = Frame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)
Frame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        update(input)
    end
end)

-- ================= UTILS =================
local function createButton(text,pos,parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,28)
    btn.Position = pos
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.BorderSizePixel = 0
    btn.ZIndex = 10000
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(65,65,65) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45,45,45) end)
    return btn
end

-- ================= MAIN BUTTONS =================
local ToggleBtn = createButton("Camlock: OFF", UDim2.new(0,10,0,10), Frame)
local ModeBtn = createButton("Lock Part: "..LockPart, UDim2.new(0,10,0,50), Frame)
local WallBtn = createButton("Through Walls: OFF", UDim2.new(0,10,0,90), Frame)
local EspBtn = createButton("ESP: OFF", UDim2.new(0,10,0,130), Frame)
local TeamBtn = createButton("Team: ON", UDim2.new(0,10,0,170), Frame)
local KeybindBtn = createButton("Keybinds", UDim2.new(0,10,0,210), Frame)

local MenuIcon = Instance.new("ImageButton")
MenuIcon.Size = UDim2.new(0,50,0,50)
MenuIcon.Position = UDim2.new(0,10,0,10)
MenuIcon.Image = "rbxassetid://104487529937663"
MenuIcon.BackgroundTransparency = 0
MenuIcon.BackgroundColor3 = Color3.fromRGB(40,40,40)
MenuIcon.ZIndex = 10000
MenuIcon.Parent = ScreenGui
Instance.new("UICorner", MenuIcon).CornerRadius = UDim.new(0.5,0)

MenuIcon.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Frame.Visible = MenuOpen
    MenuIcon.BackgroundColor3 = MenuOpen and Color3.fromRGB(60,120,60) or Color3.fromRGB(40,40,40)
end)

-- ================= KEYBINDS GUI =================
local KeyGui = Instance.new("Frame")
KeyGui.Size = UDim2.new(0,200,0,280)
KeyGui.Position = UDim2.new(0.5,-110,0.35,0)
KeyGui.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyGui.BackgroundTransparency = 0.15
KeyGui.Visible = false
KeyGui.ZIndex = 10000
KeyGui.Parent = ScreenGui
Instance.new("UICorner", KeyGui).CornerRadius = UDim.new(0,12)

local keyTexts = {}
local function createKeyText(name, pos)
    local txt = Instance.new("TextButton")
    txt.Size = UDim2.new(1,-20,0,28)
    txt.Position = pos
    txt.Text = name..": "..(Keybinds[name] and Keybinds[name].Name or "NONE")
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
    txt.TextColor3 = Color3.fromRGB(245,245,245)
    txt.BackgroundColor3 = Color3.fromRGB(50,50,50)
    txt.BorderSizePixel = 0
    txt.ZIndex = 10000
    txt.Parent = KeyGui
    Instance.new("UICorner", txt).CornerRadius = UDim.new(0,6)

    txt.MouseButton1Click:Connect(function()
        txt.Text = name..": ...."
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Backspace then
                    Keybinds[name] = nil
                    txt.Text = name..": NONE"
                else
                    Keybinds[name] = input.KeyCode
                    txt.Text = name..": "..input.KeyCode.Name
                end
                conn:Disconnect()
            end
        end)
    end)
    keyTexts[name] = txt
end

createKeyText("Camlock", UDim2.new(0,10,0,10))
createKeyText("LockPart", UDim2.new(0,10,0,50))
createKeyText("ThroughWalls", UDim2.new(0,10,0,90))
createKeyText("ESP", UDim2.new(0,10,0,130))
createKeyText("Team", UDim2.new(0,10,0,170))
createKeyText("Menu", UDim2.new(0,10,0,210))

KeybindBtn.MouseButton1Click:Connect(function()
    KeyGui.Visible = not KeyGui.Visible
end)

-- ================= BUTTON LOGIC =================
ToggleBtn.MouseButton1Click:Connect(function()
    CamlockEnabled = not CamlockEnabled
    ToggleBtn.Text = CamlockEnabled and "Camlock: ON" or "Camlock: OFF"
end)

ModeBtn.MouseButton1Click:Connect(function()
    LockIndex = (LockIndex % #LockParts) + 1
    LockPart = LockParts[LockIndex]
    ModeBtn.Text = "Lock Part: " .. LockPart
end)

WallBtn.MouseButton1Click:Connect(function()
    ThroughWalls = not ThroughWalls
    WallBtn.Text = ThroughWalls and "Through Walls: ON" or "Through Walls: OFF"
end)

EspBtn.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    EspBtn.Text = EspEnabled and "ESP: ON" or "ESP: OFF"
end)

TeamBtn.MouseButton1Click:Connect(function()
    TeamCheck = not TeamCheck
    TeamBtn.Text = TeamCheck and "Team: ON" or "Team: OFF"
end)

-- ================= INPUT KEYBINDS =================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    for action, key in pairs(Keybinds) do
        if key and input.KeyCode == key then
            if action == "Camlock" then
                CamlockEnabled = not CamlockEnabled
                ToggleBtn.Text = CamlockEnabled and "Camlock: ON" or "Camlock: OFF"
            elseif action == "LockPart" then
                LockIndex = (LockIndex % #LockParts) + 1
                LockPart = LockParts[LockIndex]
                ModeBtn.Text = "Lock Part: " .. LockPart
            elseif action == "ThroughWalls" then
                ThroughWalls = not ThroughWalls
                WallBtn.Text = ThroughWalls and "Through Walls: ON" or "Through Walls: OFF"
            elseif action == "ESP" then
                EspEnabled = not EspEnabled
                EspBtn.Text = EspEnabled and "ESP: ON" or "ESP: OFF"
            elseif action == "Team" then
                TeamCheck = not TeamCheck
                TeamBtn.Text = TeamCheck and "Team: ON" or "Team: OFF"
            elseif action == "Menu" then
                MenuOpen = not MenuOpen
                Frame.Visible = MenuOpen
                MenuIcon.BackgroundColor3 = MenuOpen and Color3.fromRGB(60,120,60) or Color3.fromRGB(40,40,40)
            end
        end
    end
end)

-- ================= TARGET SYSTEM =================
local function IsValidTarget(plr)
    if not plr or plr == LocalPlayer then return false end
    if TeamCheck and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
        return false
    end
    local char = plr.Character
    if not char or not char:FindFirstChild("Humanoid") then return false end
    local part = char:FindFirstChild(LockPart)
    if not part then return false end
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return false end

    local dist = (part.Position - root.Position).Magnitude
    if dist > 99999 then return false end

    if not ThroughWalls then
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local direction = part.Position - root.Position
        local res = Workspace:Raycast(root.Position, direction, rayParams)
        if res and res.Instance then return false end
    end
    return true
end

local function FindNearestTarget()
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return nil end
    local closest, closestDist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsValidTarget(plr) then
            local part = plr.Character[LockPart]
            local d = (part.Position - root.Position).Magnitude
            if d < closestDist then
                closest = plr
                closestDist = d
            end
        end
    end
    return closest
end

Players.PlayerRemoving:Connect(function(plr)
    if LockedTarget == plr then
        LockedTarget = nil
    end
end)

-- ================= CAMERA =================
RunService.RenderStepped:Connect(function()
    if CamlockEnabled then
        if not LockedTarget or not IsValidTarget(LockedTarget) then
            LockedTarget = FindNearestTarget()
        end
        if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild(LockPart) then
            local part = LockedTarget.Character[LockPart]
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
        end
    else
        LockedTarget = nil
    end
end)

-- ================= ESP =================
local ESPs = {}

local function getTeamColor(plr)
    if plr.Team == LocalPlayer.Team and TeamCheck and LocalPlayer.Team then
        return Color3.fromRGB(255,255,255)
    elseif plr.TeamColor then
        return plr.TeamColor.Color
    else
        return Color3.fromRGB(255,0,0)
    end
end

local function createESP(plr)
    if ESPs[plr] then return end
    local char = plr.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not rootPart then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPGui"
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0,100,0,50)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = getTeamColor(plr)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Text = plr.Name.."\n["..(char:FindFirstChild("Humanoid") and math.floor(char.Humanoid.Health) or 0).." HP]\n["..math.floor((rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude).." MM]"
    label.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillColor = getTeamColor(plr)
    highlight.FillTransparency = 0.85
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.Parent = ScreenGui

    ESPs[plr] = {Billboard = billboard, Highlight = highlight, Label = label}
end

local function removeESP(plr)
    if ESPs[plr] then
        ESPs[plr].Billboard:Destroy()
        ESPs[plr].Highlight:Destroy()
        ESPs[plr] = nil
    end
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            if EspEnabled then
                createESP(plr)
                local esp = ESPs[plr]
                local char = plr.Character
                local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                esp.Label.Text = plr.Name.."\n["..(char:FindFirstChild("Humanoid") and math.floor(char.Humanoid.Health) or 0).." HP]\n["..math.floor((rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude).." D]"
                esp.Label.TextColor3 = getTeamColor(plr)
                esp.Highlight.FillColor = getTeamColor(plr)
            else
                removeESP(plr)
            end
        else
            removeESP(plr)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if EspEnabled then
            createESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

RunService.RenderStepped:Connect(function()
    updateESP()
end)
