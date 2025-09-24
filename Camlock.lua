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
local ThroughWalls = true
local SmoothCam = true
local SafeMode = false
local MenuOpen = true
local LockedTarget = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,200,0,150)
Frame.Position = UDim2.new(0.5,-100,0.7,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Visible = MenuOpen
Frame.AnchorPoint = Vector2.new(0.5,0)
Frame.Parent = ScreenGui
local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0,12)

local function createButton(text, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 28)
	btn.Position = pos
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	btn.Parent = Frame
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0,8)
	btn.ClipsDescendants = true
	return btn
end

local ToggleBtn = createButton("Camlock: OFF", UDim2.new(0,10,0,10))
local ModeBtn = createButton("Lock Part: HumanoidRootPart", UDim2.new(0,10,0,45))
local WallBtn = createButton("Through Walls: ON", UDim2.new(0,10,0,80))
local SmoothBtn = createButton("Smooth: ON", UDim2.new(0,10,0,115))
local SafeBtn = createButton("Safe Mode: OFF", UDim2.new(0,10,0,150))

local MenuIcon = Instance.new("ImageButton")
MenuIcon.Size = UDim2.new(0,40,0,40)
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
	if not ThroughWalls then
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist
		local res = Workspace:Raycast(root.Position, (part.Position - root.Position), rayParams)
		if res and res.Instance and not res.Instance:IsDescendantOf(char) then
			return false
		end
	end
	return true
end

local function FindNearestTarget()
	if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("Humanoid") and LockedTarget.Character.Humanoid.Health>0 then
		return LockedTarget
	end
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
			LockedTarget = Target
			local part = Target.Character[LockPart]
			if SmoothCam then
				local direction = (part.Position - Camera.CFrame.Position)
				Camera.CFrame = Camera.CFrame + CFrame.new(direction * 0.2).Position
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
			else
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
			end
			local health = math.floor(Target.Character.Humanoid.Health)
			StarterGui:SetCore("SendNotification", {
				Title = "DYHUB",
				Text = "Target: "..Target.Name.."\nHealth: "..health,
				Duration = 1
			})
		end
	end
end)
