local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "DYHUB",
			Text = text,
			Duration = 5
		})
	end)
	print("Notify:", text)
end

notify("🛡️ DYHUB'S TEAM\nJoin our Discord (dsc.gg/dyhub)")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | INF & DUPE | Grow a Mine"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 400)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

local function getRainbowColor(tick)
	local frequency = 2
	local red = math.floor(math.sin(frequency * tick + 0) * 127 + 128)
	local green = math.floor(math.sin(frequency * tick + 2) * 127 + 128)
	local blue = math.floor(math.sin(frequency * tick + 4) * 127 + 128)
	return Color3.fromRGB(red, green, blue)
end

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Grow a Mine | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
	local color = getRainbowColor(tick())
	borderStroke.Color = color
	title.TextColor3 = color
end)

-- ✅ BEST Upgrade TextBox + Button
local upgradeInput = Instance.new("TextBox", mainFrame)
upgradeInput.Size = UDim2.new(0.8, 0, 0, 40)
upgradeInput.Position = UDim2.new(0.1, 0, 0, 60)
upgradeInput.PlaceholderText = "Enter Upgrade Name"
upgradeInput.Text = ""
upgradeInput.Font = Enum.Font.Gotham
upgradeInput.TextScaled = true
upgradeInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
upgradeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", upgradeInput).CornerRadius = UDim.new(0, 10)

local upgradeButton = Instance.new("TextButton", mainFrame)
upgradeButton.Size = UDim2.new(0.5, 0, 0, 40)
upgradeButton.Position = UDim2.new(0.25, 0, 0, 110)
upgradeButton.Text = "Get Upgrade"
upgradeButton.Font = Enum.Font.GothamBold
upgradeButton.TextScaled = true
upgradeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
upgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", upgradeButton).CornerRadius = UDim.new(0, 10)

upgradeButton.MouseButton1Click:Connect(function()
	local upgradeName = upgradeInput.Text
	if upgradeName ~= "" then
		local args = {
			upgradeName,
			0
		}
		ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
		notify("✅ Bought Upgrade: " .. upgradeName)
	else
		notify("❌ Please enter Upgrade name!")
	end
end)

-- ✅ BEST Drill TextBox + Button
local drillInput = Instance.new("TextBox", mainFrame)
drillInput.Size = UDim2.new(0.8, 0, 0, 40)
drillInput.Position = UDim2.new(0.1, 0, 0, 170)
drillInput.PlaceholderText = "Enter Drill Name"
drillInput.Text = ""
drillInput.Font = Enum.Font.Gotham
drillInput.TextScaled = true
drillInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
drillInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", drillInput).CornerRadius = UDim.new(0, 10)

local drillButton = Instance.new("TextButton", mainFrame)
drillButton.Size = UDim2.new(0.5, 0, 0, 40)
drillButton.Position = UDim2.new(0.25, 0, 0, 220)
drillButton.Text = "Get Drill"
drillButton.Font = Enum.Font.GothamBold
drillButton.TextScaled = true
drillButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
drillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", drillButton).CornerRadius = UDim.new(0, 10)

drillButton.MouseButton1Click:Connect(function()
	local drillName = drillInput.Text
	if drillName ~= "" then
		local args = {
			drillName,
			0
		}
		ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
		notify("✅ Bought Drill: " .. drillName)
	else
		notify("❌ Please enter Drill name!")
	end
end)

-- ✅ Inf. Money Button (black ➜ red ➜ black loop)
local moneyButton = Instance.new("TextButton", mainFrame)
moneyButton.Size = UDim2.new(0.5, 0, 0, 40)
moneyButton.Position = UDim2.new(0.25, 0, 0, 280)
moneyButton.Text = "Inf. Money"
moneyButton.Font = Enum.Font.GothamBold
moneyButton.TextScaled = true
moneyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", moneyButton).CornerRadius = UDim.new(0, 10)

moneyButton.MouseButton1Click:Connect(function()
	local args = {
		"DYHUB | dsc.gg/dyhub",
		-9999999999999
	}
	ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
	notify("✅ Infinite Money Activated!")
end)

-- สีดำ-แดงไหล
RunService.RenderStepped:Connect(function()
	local tickTime = tick()
	local value = (math.sin(tickTime * 2) + 1) / 2 -- 0 to 1
	local red = math.floor(value * 255)
	moneyButton.BackgroundColor3 = Color3.fromRGB(red, 0, 0)
end)

-- Loading
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingMenu"
loadingGui.ResetOnSpawn = false
loadingGui.Parent = player:WaitForChild("PlayerGui")

local loadingFrame = Instance.new("Frame")
loadingFrame.Parent = loadingGui
loadingFrame.Size = UDim2.new(0, 320, 0, 180)
loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
loadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0
loadingFrame.ClipsDescendants = true

Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", loadingFrame).Thickness = 2

local loadingTitle = Instance.new("TextLabel", loadingFrame)
loadingTitle.Size = UDim2.new(1, 0, 0, 50)
loadingTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingTitle.BackgroundTransparency = 0.5
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextSize = 22
loadingTitle.Text = "🛡️ DYHUB TEAM\n Loading..."
Instance.new("UICorner", loadingTitle).CornerRadius = UDim.new(0, 15)

local spinner = Instance.new("ImageLabel", loadingFrame)
spinner.Size = UDim2.new(0, 60, 0, 60)
spinner.Position = UDim2.new(0.5, 0, 0.5, 10)
spinner.AnchorPoint = Vector2.new(0.5, 0.5)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://82285050019288"
spinner.ImageColor3 = Color3.fromRGB(255, 255, 255)

RunService.RenderStepped:Connect(function()
	spinner.Rotation = spinner.Rotation + 3
end)

task.delay(2, function()
	loadingGui.Enabled = false
	gui.Enabled = true
end)
