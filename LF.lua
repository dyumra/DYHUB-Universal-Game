local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🐟 DYHUB | Loot Fish",
            Text = text,
            Duration = 3
        })
    end)
end

notify("✅ DYHUB Loaded! for Loot Fish")

-- Clear old GUI
local old = playerGui:FindFirstChild("DYHUB | Loot Fish")
if old then old:Destroy() end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DYHUB | Loot Fish"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 250)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

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
title.Text = "Loot Fish | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

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

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
    toggleBtn.TextColor3 = color
end)

-- Dupe Fish Button
local dupeFish = false
local dupeFishButton = Instance.new("TextButton", mainFrame)
dupeFishButton.Size = UDim2.new(0.8, 0, 0, 40)
dupeFishButton.Position = UDim2.new(0.1, 0, 0, 50)
dupeFishButton.Text = "Dupe Fish: Off"
dupeFishButton.Font = Enum.Font.GothamBold
dupeFishButton.TextScaled = true
dupeFishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeFishButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", dupeFishButton).CornerRadius = UDim.new(0, 10)

-- Auto Sell Button
local autoSell = false
local autoSellButton = Instance.new("TextButton", mainFrame)
autoSellButton.Size = UDim2.new(0.8, 0, 0, 40)
autoSellButton.Position = UDim2.new(0.1, 0, 0, 100)
autoSellButton.Text = "Auto Sell: Off"
autoSellButton.Font = Enum.Font.GothamBold
autoSellButton.TextScaled = true
autoSellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSellButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", autoSellButton).CornerRadius = UDim.new(0, 10)

-- Speed Button
local speedMode = false
local speedButton = Instance.new("TextButton", mainFrame)
speedButton.Size = UDim2.new(0.8, 0, 0, 40)
speedButton.Position = UDim2.new(0.1, 0, 0, 150)
speedButton.Text = "Walk Speed: Normal"
speedButton.Font = Enum.Font.GothamBold
speedButton.TextScaled = true
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", speedButton).CornerRadius = UDim.new(0, 10)

------------------------------
-- Dupe Fish Function
------------------------------
local function runDupeFish()
    task.spawn(function()
        local fish_base_class = require(ReplicatedStorage:FindFirstChild("Fish"):FindFirstChild("Script"):FindFirstChild("FishBaseClass"))
        if not fish_base_class then
            return print("Fish base class module not found!")
        end

        local fish = Workspace:FindFirstChild("FishModelList")
        if not fish then
            return print("Fish folder not found!")
        end

        while dupeFish do
            local fish_uids = {}
            for _, v in fish:GetChildren() do
                local success, fish_object = fish_base_class:GetFishObjectByModel(v)
                if success and fish_object then
                    local _, uid = fish_object:GetUId()
                    table.insert(fish_uids, uid)
                end
            end

            ReplicatedStorage:WaitForChild("Harpoon"):WaitForChild("Remote"):WaitForChild("ApplyCaptureResult"):InvokeServer({
                Radius = 9e999,
                Center = Vector3.new(0, 0, 0),
                FishList = fish_uids
            })

            task.wait(0.01) -- ✅ เร็วขึ้นมาก
        end
    end)
end

------------------------------
-- Auto Sell Function
------------------------------
local function runAutoSell()
    task.spawn(function()
        while autoSell do
            ReplicatedStorage:WaitForChild("StoreSystem"):WaitForChild("Remote"):WaitForChild("ApplySellProduct"):InvokeServer(true)
            task.wait(0.01)
        end
    end)
end

------------------------------
-- BUTTON LOGIC
------------------------------
dupeFishButton.MouseButton1Click:Connect(function()
    dupeFish = not dupeFish
    dupeFishButton.Text = dupeFish and "Dupe Fish: On" or "Dupe Fish: Off"
    notify("Dupe Fish: " .. (dupeFish and "✅ Enabled" or "❌ Disabled"))

    if dupeFish then
        runDupeFish()
    end
end)

autoSellButton.MouseButton1Click:Connect(function()
    autoSell = not autoSell
    autoSellButton.Text = autoSell and "Auto Sell: On" or "Auto Sell: Off"
    notify("Auto Sell: " .. (autoSell and "✅ Enabled" or "❌ Disabled"))

    if autoSell then
        runAutoSell()
    end
end)

speedButton.MouseButton1Click:Connect(function()
    speedMode = not speedMode
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedMode and 100 or 16
    end
    speedButton.Text = speedMode and "Walk Speed: MAX" or "Walk Speed: Normal"
    notify(speedMode and "💨 MAX Speed Enabled!" or "🚶 Normal Speed")
end)
