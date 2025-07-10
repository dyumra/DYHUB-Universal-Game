local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local playerGui = player:WaitForChild("PlayerGui")

local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "DYHUB",
			Text = text,
			Duration = 4
		})
	end)
end

notify("✅ DYHUB Loaded! for Evade")

local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | Auto Ticket | Evade"
gui.ResetOnSpawn = false
gui.Enabled = true
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 240)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = mainFrame

local borderStroke = Instance.new("UIStroke")
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3
borderStroke.Parent = mainFrame

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local function getRainbowColor(t)
	local f = 2
	local r = math.floor(math.sin(f * t + 0) * 127 + 128)
	local g = math.floor(math.sin(f * t + 2) * 127 + 128)
	local b = math.floor(math.sin(f * t + 4) * 127 + 128)
	return Color3.fromRGB(r, g, b)
end

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Evade | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

RunService.RenderStepped:Connect(function()
	local color = getRainbowColor(tick())
	borderStroke.Color = color
	title.TextColor3 = color
    toggleBtn.TextColor3 = color
end)

local farmButton = Instance.new("TextButton")
farmButton.Name = "FarmButton"
farmButton.Size = UDim2.new(0.7, 0, 0, 50)
farmButton.Position = UDim2.new(0.15, 0, 0, 50)
farmButton.Text = "Auto Ticket: OFF"
farmButton.Font = Enum.Font.GothamBold
farmButton.TextScaled = true
farmButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
farmButton.TextColor3 = Color3.new(1, 1, 1)
farmButton.Parent = mainFrame

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 10)
farmCorner.Parent = farmButton

local reviveButton = Instance.new("TextButton")
reviveButton.Name = "ReviveButton"
reviveButton.Size = UDim2.new(0.7, 0, 0, 50)
reviveButton.Position = UDim2.new(0.15, 0, 0, 120)
reviveButton.Text = "Revive"
reviveButton.Font = Enum.Font.GothamBold
reviveButton.TextScaled = true
reviveButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
reviveButton.TextColor3 = Color3.new(1, 1, 1)
reviveButton.Parent = mainFrame

local reviveCorner = Instance.new("UICorner")
reviveCorner.CornerRadius = UDim.new(0, 10)
reviveCorner.Parent = reviveButton

local warnLabel = Instance.new("TextLabel")
warnLabel.Size = UDim2.new(0.9, 0, 0, 30)
warnLabel.Position = UDim2.new(0.05, 0, 0, 190)
warnLabel.Text = "⚠️ Revive only works when Downed!"
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextScaled = true
warnLabel.BackgroundTransparency = 1
warnLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
warnLabel.Parent = mainFrame

local farming = false

farmButton.MouseButton1Click:Connect(function()
	farming = not farming
	getgenv().farm = farming

	if farming then
		farmButton.Text = "Auto Ticket: ON"
		farmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		notify("✅ Auto Ticket Enabled")

		task.spawn(function()
			player.Idled:Connect(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)

			while getgenv().farm do
				local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
				if tickets then
					local character = player.Character or player.CharacterAdded:Wait()
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

					if character and humanoidRootPart then
						if character:GetAttribute("Downed") then
							ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
						end

						for _, ticket in ipairs(tickets:GetChildren()) do
							local ticketPart = ticket:FindFirstChild("HumanoidRootPart")
							if ticketPart then
								humanoidRootPart.CFrame = ticketPart.CFrame
								task.wait(0.1)
							end
						end
					end
				else
					notify("⚠️ Tickets not found!")
				end
				task.wait(1)
			end
		end)
	else
		farmButton.Text = "Auto Ticket: OFF"
		farmButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		notify("❌ Auto Ticket Disabled")
	end
end)

reviveButton.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	if character:GetAttribute("Downed") then
		ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
		notify("✅ Revived!")
	else
		notify("⚠️ You are not Downed yet!")
	end
end)
