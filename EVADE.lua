local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 4
        })
    end)
end

notify("✅ DYHUB Load! for Evade")

local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | Auto Ticket | Evade"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 240)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

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

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Evade | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    toggleBtn.TextColor3 = color
    title.TextColor3 = color
end)

local farmButton = Instance.new("TextButton", mainFrame)
farmButton.Size = UDim2.new(0.7, 0, 0, 50)
farmButton.Position = UDim2.new(0.15, 0, 0, 50)
farmButton.Text = "Auto Ticket: OFF"
farmButton.Font = Enum.Font.GothamBold
farmButton.TextScaled = true
farmButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", farmButton).CornerRadius = UDim.new(0, 10)

local reviveButton = Instance.new("TextButton", mainFrame)
reviveButton.Size = UDim2.new(0.7, 0, 0, 50)
reviveButton.Position = UDim2.new(0.15, 0, 0, 120)
reviveButton.Text = "Revive"
reviveButton.Font = Enum.Font.GothamBold
reviveButton.TextScaled = true
reviveButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
reviveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", reviveButton).CornerRadius = UDim.new(0, 10)

local warnLabel = Instance.new("TextLabel", mainFrame)
warnLabel.Size = UDim2.new(0.9, 0, 0, 30)
warnLabel.Position = UDim2.new(0.05, 0, 0, 190)
warnLabel.Text = "⚠️ Revive only works if you are Downed in the game!"
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextScaled = true
warnLabel.BackgroundTransparency = 1
warnLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

local farming = false

farmButton.MouseButton1Click:Connect(function()
    farming = not farming
    getgenv().farm = farming

    if farming then
        farmButton.Text = "Auto Ticket: ON"
        farmButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        notify("✅ Auto Ticket Enabled")

        task.spawn(function()
            local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")

            player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)

            if tickets then
                while getgenv().farm do
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
                    task.wait(1)
                end
            else
                notify("⚠️ Tickets not found in game!")
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
        notify("⚠️ You haven't been Downed yet!")
    end
end)
