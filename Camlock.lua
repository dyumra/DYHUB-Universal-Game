local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Target = nil
local LockPart = "HumanoidRootPart"
local CamlockEnabled = false
local ThroughWalls = false
local SmoothCam = true
local SmoothSpeed = 0.25
local SafeMode = false
local MenuOpen = true
local LockedTarget = nil
local NotifyEnabled = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,200,0,200)
Frame.Position = UDim2.new(0.5,-100,0.65,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Visible = MenuOpen
Frame.AnchorPoint = Vector2.new(0.5,0)
Frame.Parent = ScreenGui
local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0,15)

local Shadow = Instance.new("UIStroke", Frame)
Shadow.Thickness = 1.5
Shadow.Color = Color3.fromRGB(70,70,70)
Shadow.Transparency = 0.5

local dragging, dragInput, mousePos, framePos
local function update(input)
    local delta = input.Position - mousePos
    Frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function createButton(text,pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,28)
    btn.Position = pos
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.BorderSizePixel = 0
    btn.Parent = Frame
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,6)
    return btn
end

local ToggleBtn = createButton("Camlock: OFF", UDim2.new(0,10,0,10))
local ModeBtn = createButton("Lock Part: HumanoidRootPart", UDim2.new(0,10,0,50))
local WallBtn = createButton("Through Walls: OFF", UDim2.new(0,10,0,90))
local SmoothBtn = createButton("Smooth: ON", UDim2.new(0,10,0,130))
local SafeBtn = createButton("Safe Mode: OFF", UDim2.new(0,10,0,170))
local NotifyBtn = createButton("Notify: ON", UDim2.new(0,10,0,210))

local MenuIcon = Instance.new("ImageButton")
MenuIcon.Size = UDim2.new(0,35,0,35)
MenuIcon.Position = UDim2.new(0,10,0,10)
MenuIcon.Image = "rbxassetid://104487529937663"
MenuIcon.BackgroundTransparency = 1
MenuIcon.Parent = ScreenGui

MenuIcon.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Frame.Visible = MenuOpen
end)

ToggleBtn.MouseButton1Click:Connect(function()
    CamlockEnabled = not CamlockEnabled
    ToggleBtn.Text = CamlockEnabled and "Camlock: ON" or "Camlock: OFF"
end)

ModeBtn.MouseButton1Click:Connect(function()
    LockPart = (LockPart == "HumanoidRootPart") and "Head" or "HumanoidRootPart"
    ModeBtn.Text = "Lock Part: "..LockPart
end)

WallBtn.MouseButton1Click:Connect(function()
    ThroughWalls = not ThroughWalls
    WallBtn.Text = ThroughWalls and "Through Walls: ON" or "Through Walls: OFF"
end)

SmoothBtn.MouseButton1Click:Connect(function()
    SmoothCam = not SmoothCam
    SmoothBtn.Text = SmoothCam and "Smooth: ON" or "Smooth: OFF"
end)

SafeBtn.MouseButton1Click:Connect(function()
    SafeMode = not SafeMode
    SafeBtn.Text = SafeMode and "Safe Mode: ON" or "Safe Mode: OFF"
end)

NotifyBtn.MouseButton1Click:Connect(function()
    NotifyEnabled = not NotifyEnabled
    NotifyBtn.Text = NotifyEnabled and "Notify: ON" or "Notify: OFF"
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.V then
            CamlockEnabled = not CamlockEnabled
            ToggleBtn.Text = CamlockEnabled and "Camlock: ON" or "Camlock: OFF"
        elseif input.KeyCode == Enum.KeyCode.End then
            MenuOpen = not MenuOpen
            Frame.Visible = MenuOpen
        end
    end
end)

local function IsValidTarget(plr)
    if not plr or plr == LocalPlayer then return false end
    local char = plr.Character
    if not char or not char:FindFirstChild("Humanoid") then return false end
    local part = char:FindFirstChild(LockPart)
    if not part then return false end
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not root then return false end
    local dist = (part.Position - root.Position).Magnitude
    if dist > 1000 then return false end
    if ThroughWalls then
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
    local best = nil
    local bestDist = math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if IsValidTarget(plr) then
            local part = plr.Character:FindFirstChild(LockPart)
            local d = (part.Position - Camera.CFrame.Position).Magnitude
            if d < bestDist then
                best = plr
                bestDist = d
            end
            if SafeMode and d <= 25 then
                best = plr
                break
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if CamlockEnabled then
        Target = FindNearestTarget()
        if Target and Target.Character and Target.Character:FindFirstChild(LockPart) then
            if LockedTarget ~= Target and NotifyEnabled then
                LockedTarget = Target
                local health = math.floor(Target.Character.Humanoid.Health)
                StarterGui:SetCore("SendNotification",{
                    Title="DYHUB Camlock",
                    Text="Target: "..Target.Name.." | Health: "..health,
                    Duration=2
                })
            end
            local part = Target.Character[LockPart]
            local camPos = Camera.CFrame.Position
            if SmoothCam then
                local direction = (part.Position - camPos)
                Camera.CFrame = CFrame.new(camPos + direction * SmoothSpeed, part.Position)
            else
                Camera.CFrame = CFrame.new(camPos, part.Position)
            end
        else
            LockedTarget = nil
        end
    else
        LockedTarget = nil
    end
end)
