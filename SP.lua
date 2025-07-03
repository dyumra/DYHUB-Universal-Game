local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local af = false
local delayTime = 0.1

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = txt,
            Duration = 3
        })
    end)
end

notify("✅ DYHUB Loaded for Spray Print")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | Spray Paint"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 150)
frame.Position = UDim2.new(0.5, -135, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "SPRAY PAINT | DYHUB"
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
Instance.new("UIStroke", toggleBtn).Thickness = 2

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

local function createBox(placeholder, posY, parentFrame, default)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.PlaceholderText = placeholder
    b.Text = tostring(default)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parentFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local function getRainbow(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f*t+0)*127+128),
        math.floor(math.sin(f*t+2)*127+128),
        math.floor(math.sin(f*t+4)*127+128)
    )
end

RunService.RenderStepped:Connect(function()
    local t = tick()
    local rainbow = getRainbow(t)
    title.TextColor3 = rainbow
    toggleBtn.TextColor3 = rainbow
    stroke.Color = rainbow
end)

local function sprayPaint()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Misc"):WaitForChild("SprayPaint"):FireServer()
end

local y = 40

local sprayBtn = createBtn("Spray Paint", y, frame)
sprayBtn.MouseButton1Click:Connect(sprayPaint)

y = y + 40

local delayBox = createBox("Delay (seconds)", y, frame, delayTime)
delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val > 0 then
        delayTime = val
        delayBox.Text = tostring(val)
    else
        delayBox.Text = tostring(delayTime)
    end
end)

y = y + 40

local autoBtn = createBtn("Auto Spray Paint: OFF", y, frame)
autoBtn.MouseButton1Click:Connect(function()
    af = not af
    autoBtn.Text = "Auto Spray Paint: " .. (af and "ON" or "OFF")
    if af then
        spawn(function()
            while af do
                sprayPaint()
                task.wait(delayTime)
            end
        end)
    end
end)
