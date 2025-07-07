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

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "Dupe-MET | Inf-Cash | Millionaire Empire Tycoon"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 300)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
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
title.Text = "MET | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

-- ✅ NEW TextBox
local inputBox = Instance.new("TextBox", mainFrame)
inputBox.Size = UDim2.new(0.8, 0, 0, 40)
inputBox.Position = UDim2.new(0.1, 0, 0, 60)
inputBox.PlaceholderText = "Enter amount (100 ~ 10,000,000)"
inputBox.Text = ""
inputBox.Font = Enum.Font.Gotham
inputBox.TextScaled = true
inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 10)

-- ✅ NEW Enter Button
local enterButton = Instance.new("TextButton", mainFrame)
enterButton.Size = UDim2.new(0.5, 0, 0, 40)
enterButton.Position = UDim2.new(0.25, 0, 0, 110)
enterButton.Text = "Enter Amount"
enterButton.Font = Enum.Font.GothamBold
enterButton.TextScaled = true
enterButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
enterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", enterButton).CornerRadius = UDim.new(0, 10)

-- Inf Cash Button
local moneyButton = Instance.new("TextButton", mainFrame)
moneyButton.Size = UDim2.new(0.5, 0, 0, 40)
moneyButton.Position = UDim2.new(0.25, 0, 0, 170)
moneyButton.Text = "Get Inf Cash"
moneyButton.Font = Enum.Font.GothamBold
moneyButton.TextScaled = true
moneyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
moneyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", moneyButton).CornerRadius = UDim.new(0, 10)

local function getRedShade(tick)
    local frequency = 2
    local red = math.floor(math.sin(frequency * tick) * 127 + 128)
    return Color3.fromRGB(red, 0, 0)
end

RunService.RenderStepped:Connect(function()
    local color = getRedShade(tick())
    moneyButton.BackgroundColor3 = color
end)

-- Inf Cash Button Click
moneyButton.MouseButton1Click:Connect(function()
    local args = {
        [1] = 100000000000000000
    }
    ReplicatedStorage:WaitForChild("fewjnfejwb3"):FireServer(unpack(args))
    notify("✅ Money boosted!")
end)

-- ✅ Enter Button Click
enterButton.MouseButton1Click:Connect(function()
    local amount = tonumber(inputBox.Text)
    if amount and amount >= 100 and amount <= 10000000 then
        local args = {
            [1] = amount
        }
        ReplicatedStorage:WaitForChild("fewjnfejwb3"):FireServer(unpack(args))
        notify("✅ Sent amount: " .. amount)
    else
        notify("❌ Invalid! Please enter 100 ~ 10,000,000.")
    end
end)

-- Loading GUI
local key1InputGui = Instance.new("ScreenGui")
key1InputGui.Name = "LoadingMenu"
key1InputGui.ResetOnSpawn = false
key1InputGui.Parent = player:WaitForChild("PlayerGui")

local key1Frame = Instance.new("Frame")
key1Frame.Parent = key1InputGui
key1Frame.Size = UDim2.new(0, 320, 0, 180)
key1Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
key1Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
key1Frame.BackgroundTransparency = 0.2
key1Frame.BorderSizePixel = 0
key1Frame.ClipsDescendants = true

Instance.new("UICorner", key1Frame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", key1Frame).Thickness = 2

local key1Title = Instance.new("TextLabel", key1Frame)
key1Title.Size = UDim2.new(1, 0, 0, 50)
key1Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
key1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
key1Title.BackgroundTransparency = 0.5
key1Title.Font = Enum.Font.GothamBold
key1Title.TextSize = 22
key1Title.Text = "🛡️ DYHUB'S TEAM\n Join our (.gg/DYHUB)"
Instance.new("UICorner", key1Title).CornerRadius = UDim.new(0, 15)

local spinner = Instance.new("ImageLabel", key1Frame)
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
    key1InputGui.Enabled = false
    gui.Enabled = true
end)
