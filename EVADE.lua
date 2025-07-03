local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = txt,
            Duration = 3
        })
    end)
end

local function getRainbow(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f*t+0)*127+128),
        math.floor(math.sin(f*t+2)*127+128),
        math.floor(math.sin(f*t+4)*127+128)
    )
end

notify("✅ DYHUB Loaded")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | TICKET FARM"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 200)
frame.Position = UDim2.new(0.5, -135, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Text = "DYHUB | Ticket Farm"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

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
    frame.Visible = not frame.Visible
end)

local function createBtn(text, posY, parentFrame)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parentFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

getgenv().farm = false

local farmBtn = createBtn("Tickets Farm: OFF", 50, frame)

farmBtn.MouseButton1Click:Connect(function()
    if not ticketsFolder then
        notify("❌ Tickets Not Found!")
        return
    end
    getgenv().farm = not getgenv().farm
    if getgenv().farm then
        farmBtn.Text = "Tickets Farm: ON"
        notify("✅ Ticket Farm Started")
        task.spawn(function()
            while getgenv().farm do
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if character and humanoidRootPart then
                    for _, ticket in ipairs(ticketsFolder:GetChildren()) do
                        if ticket:IsA("BasePart") then
                            humanoidRootPart.CFrame = ticket.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        farmBtn.Text = "Tickets Farm: OFF"
        notify("🛑 Ticket Farm Stopped")
    end
end)
