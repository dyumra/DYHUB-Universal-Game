-- ================= V514 ==================
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Target = nil
local LockPart = "HumanoidRootPart"
local CamlockEnabled = false
local ThroughWalls = false
local MenuOpen = true
local LockedTarget = nil

local Keybinds = {
    Camlock = Enum.KeyCode.V,
    LockPart = Enum.KeyCode.G,
    ThroughWalls = Enum.KeyCode.H,
    Menu = Enum.KeyCode.End
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,200,0,180)
Frame.Position = UDim2.new(0.5,0,0.35,0)
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

local dragging, dragInput, startPos, startPosFrame
local function update(input)
    local delta = input.Position - startPos
    Frame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
end
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPos = input.Position
        startPosFrame = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Frame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        update(input)
    end
end)

local function createButton(text,pos,parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,28)
    btn.Position = pos
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,6)
    return btn
end

local ToggleBtn = createButton("Camlock: OFF", UDim2.new(0,10,0,10), Frame)
local ModeBtn = createButton("Lock Part: HumanoidRootPart", UDim2.new(0,10,0,50), Frame)
local WallBtn = createButton("Through Walls: OFF", UDim2.new(0,10,0,90), Frame)
local KeybindBtn = createButton("Keybinds", UDim2.new(0,10,0,130), Frame)

local MenuIcon = Instance.new("ImageButton")
MenuIcon.Size = UDim2.new(0,35,0,35)
MenuIcon.Position = UDim2.new(0,10,0,10)
MenuIcon.Image = "rbxassetid://104487529937663"
MenuIcon.BackgroundTransparency = 0
MenuIcon.BackgroundColor3 = Color3.fromRGB(40,40,40)
local iconCorner = Instance.new("UICorner", MenuIcon)
iconCorner.CornerRadius = UDim.new(1,0)
MenuIcon.Parent = ScreenGui
MenuIcon.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Frame.Visible = MenuOpen
end)

local KeyGui = Instance.new("Frame")
KeyGui.Size = UDim2.new(0,180,0,170)
KeyGui.Position = UDim2.new(0.5,-90,0.55,0)
KeyGui.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyGui.Visible = false
KeyGui.Parent = ScreenGui
local KeyCorner = Instance.new("UICorner", KeyGui)
KeyCorner.CornerRadius = UDim.new(0,12)

local keyTexts = {}
local function createKeyText(name, pos)
    local txt = Instance.new("TextButton")
    txt.Size = UDim2.new(1,-20,0,28)
    txt.Position = pos
    txt.Text = name..": "..Keybinds[name].Name
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextColor3 = Color3.fromRGB(245,245,245)
    txt.BackgroundColor3 = Color3.fromRGB(50,50,50)
    txt.BorderSizePixel = 0
    txt.Parent = KeyGui
    local corner = Instance.new("UICorner", txt)
    corner.CornerRadius = UDim.new(0,6)
    txt.MouseButton1Click:Connect(function()
        txt.Text = name..": ...."
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keybinds[name] = input.KeyCode
                txt.Text = name..": "..input.KeyCode.Name
                conn:Disconnect()
            end
        end)
    end)
    keyTexts[name] = txt
end

createKeyText("Camlock", UDim2.new(0,10,0,10))
createKeyText("LockPart", UDim2.new(0,10,0,50))
createKeyText("ThroughWalls", UDim2.new(0,10,0,90))
createKeyText("Menu", UDim2.new(0,10,0,130))

KeybindBtn.MouseButton1Click:Connect(function()
    KeyGui.Visible = not KeyGui.Visible
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

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Keybinds.Camlock then
            CamlockEnabled = not CamlockEnabled
            ToggleBtn.Text = CamlockEnabled and "Camlock: ON" or "Camlock: OFF"
        elseif input.KeyCode == Keybinds.LockPart then
            LockPart = (LockPart == "HumanoidRootPart") and "Head" or "HumanoidRootPart"
            ModeBtn.Text = "Lock Part: "..LockPart
        elseif input.KeyCode == Keybinds.ThroughWalls then
            ThroughWalls = not ThroughWalls
            WallBtn.Text = ThroughWalls and "Through Walls: ON" or "Through Walls: OFF"
        elseif input.KeyCode == Keybinds.Menu then
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
    if LockedTarget and IsValidTarget(LockedTarget) then
        return LockedTarget
    end
    local closest = nil
    local closestDist = math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if IsValidTarget(plr) then
            local part = plr.Character[LockPart]
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
            local d = (part.Position - root.Position).Magnitude
            if d < closestDist then
                closest = plr
                closestDist = d
            end
        end
    end
    LockedTarget = closest
    return closest
end

RunService.RenderStepped:Connect(function()
    if CamlockEnabled then
        Target = FindNearestTarget()
        if Target and Target.Character and Target.Character:FindFirstChild(LockPart) then
            local part = Target.Character[LockPart]
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
        else
            LockedTarget = nil
        end
    else
        LockedTarget = nil
    end
end)
