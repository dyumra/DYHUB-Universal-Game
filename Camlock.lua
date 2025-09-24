-- =========================
-- Version : V1.5
-- =========================

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables
local Target = nil
local LockPart = "HumanoidRootPart"
local CamlockEnabled = false
local ThroughWalls = false
local SmoothCam = true
local SafeMode = false
local MenuOpen = true
local LockedTarget = nil

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,180,0,130)
Frame.Position = UDim2.new(0.5,-90,0.7,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Visible = MenuOpen
Frame.AnchorPoint = Vector2.new(0.5,0)
Frame.Parent = ScreenGui
local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0,12)

-- Helper to create buttons
local function createButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 24)
    btn.Position = pos
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BorderSizePixel = 0
    btn.Parent = Frame
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,6)
    return btn
end

-- Buttons
local ToggleBtn = createButton("Camlock: OFF", UDim2.new(0,10,0,10))
local ModeBtn = createButton("Lock Part: HumanoidRootPart", UDim2.new(0,10,0,40))
local WallBtn = createButton("Through Walls: OFF", UDim2.new(0,10,0,70))
local SmoothBtn = createButton("Smooth: ON", UDim2.new(0,10,0,100))
local SafeBtn = createButton("Safe Mode: OFF", UDim2.new(0,10,0,130))

-- Menu icon
local MenuIcon = Instance.new("ImageButton")
MenuIcon.Size = UDim2.new(0,30,0,30)
MenuIcon.Position = UDim2.new(0,10,0,10)
MenuIcon.Image = "rbxassetid://104487529937663"
MenuIcon.BackgroundTransparency = 1
MenuIcon.Parent = ScreenGui

MenuIcon.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Frame.Visible = MenuOpen
end)

-- Button Callbacks
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

-- Hotkeys
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

-- Target Validation
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

    -- ตรวจสอบกำแพง
    if ThroughWalls then
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char} -- ข้ามตัวเองและเป้าหมาย
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local direction = part.Position - root.Position
        local res = Workspace:Raycast(root.Position, direction, rayParams)
        if res and res.Instance then
            -- ถ้ามีสิ่งกีดขวางขวางอยู่ จะไม่ถือว่า valid
            return false
        end
    end

    return true
end

-- Find nearest target
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

-- Camlock update
RunService.RenderStepped:Connect(function()
    if CamlockEnabled then
        Target = FindNearestTarget()
        if Target and Target.Character and Target.Character:FindFirstChild(LockPart) then
            -- Notification เฉพาะตอนล็อคเป้าหมายใหม่
            if LockedTarget ~= Target then
                LockedTarget = Target
                local health = math.floor(Target.Character.Humanoid.Health)
                StarterGui:SetCore("SendNotification", {
                    Title = "DYHUB Camlock",
                    Text = "Target: "..Target.Name.." | Health: "..health,
                    Duration = 2
                })
            end

            local part = Target.Character[LockPart]
            local camPos = Camera.CFrame.Position
            if SmoothCam then
                local direction = (part.Position - camPos)
                Camera.CFrame = CFrame.new(camPos + direction * 0.2, part.Position)
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
