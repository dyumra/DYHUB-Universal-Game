-- Notify function
local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 4,
        })
    end)
end

-- Fix Remote Names
for _, v in getgc() do
    if type(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        local function_name = debug.info(v, "n")
        local function_upvalues = getupvalues(v)
        if function_name == "GetHandler" and #function_upvalues >= 4 and typeof(function_upvalues[1]) == "table" then
            for _, val in function_upvalues[1].Event do
                if typeof(val.Remote) == "Instance" then
                    val.Remote.Name = val.Name
                end
            end
            for _, val in function_upvalues[1].Function do
                if typeof(val.Remote) == "Instance" then
                    val.Remote.Name = val.Name
                end
            end
        end
    end
end

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | Auto Collect | My Singing Brainrot"
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 120)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local borderStroke = Instance.new("UIStroke")
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3
borderStroke.Parent = mainFrame

local function getRainbowColor(t)
    local f = 2
    local r = math.floor(math.sin(f * t + 0) * 127 + 128)
    local g = math.floor(math.sin(f * t + 2) * 127 + 128)
    local b = math.floor(math.sin(f * t + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "My Singing Brainrot | DYHUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = mainFrame

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.7, 0, 0, 50)
toggleButton.Position = UDim2.new(0.15, 0, 0, 50)
toggleButton.Text = "Auto Collect: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    toggleStroke.Color = color
    toggleBtn.TextColor3 = color
    title.TextColor3 = color
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Logic Auto Collect
local collecting = false

toggleButton.MouseButton1Click:Connect(function()
    collecting = not collecting
    getgenv().autoCollect = collecting

    if collecting then
        toggleButton.Text = "Auto Collect: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        notify("✅ Auto Collect Enabled")

        task.spawn(function()
            while getgenv().autoCollect do
                for plotIndex = 1, 10 do
                    local plot = workspace.Main.Plots:FindFirstChild(tostring(plotIndex))
                    if plot and plot:FindFirstChild("Items") then
                        local items = plot.Items:GetChildren()
                        for _, item in ipairs(items) do
                            if string.match(item.Name, "^Item[1-15]$") then
                                task.spawn(function()
                                    local args = { [1] = item }
                                    ReplicatedStorage.Communication.Functions.CollectItem:InvokeServer(unpack(args))
                                end)
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        toggleButton.Text = "Auto Collect: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        notify("❌ Auto Collect Disabled")
    end
end)
