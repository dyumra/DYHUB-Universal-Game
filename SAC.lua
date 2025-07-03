local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local LockRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("LockGate")
local CollectRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("CollectEarnings")

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = txt,
            Duration = 2
        })
    end)
end

notify("✅ DYHUB Loaded for Steal a Car")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | Steal a Car"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
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
title.Text = "Steal a Car | DYHUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

local function createBtn(text, posY)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local AutoLock = false
local AutoCollect = false

local posY = 50

local btnLock = createBtn("Auto Lock: OFF", posY)
btnLock.MouseButton1Click:Connect(function()
    AutoLock = not AutoLock
    btnLock.Text = "Auto Lock: " .. (AutoLock and "ON" or "OFF")
    notify(btnLock.Text)
end)

posY = posY + 50

local btnCollect = createBtn("Auto Collect: OFF", posY)
btnCollect.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    btnCollect.Text = "Auto Collect: " .. (AutoCollect and "ON" or "OFF")
    notify(btnCollect.Text)
end)

posY = posY + 50

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(1, -20, 0, 35)
textbox.Position = UDim2.new(0, 10, 0, posY)
textbox.PlaceholderText = "Set WalkSpeed (e.g, 0-100)"
textbox.Text = ""
textbox.Font = Enum.Font.Gotham
textbox.TextScaled = true
textbox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.Parent = frame
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 8)

posY = posY + 45

local btnSetSpeed = createBtn("Set WalkSpeed", posY)
btnSetSpeed.MouseButton1Click:Connect(function()
    local speed = tonumber(textbox.Text)
    if speed then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            notify("WalkSpeed set to " .. speed)
        else
            notify("Humanoid not found!")
        end
    else
        notify("Please enter a valid number!")
    end
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    local f = 2
    local c = Color3.fromRGB(
        math.floor(math.sin(f * t + 0) * 127 + 128),
        math.floor(math.sin(f * t + 2) * 127 + 128),
        math.floor(math.sin(f * t + 4) * 127 + 128)
    )
    stroke.Color = c
    title.TextColor3 = c
end)

task.spawn(function()
    while true do
        if AutoLock then
            pcall(function()
                LockRemote:FireServer()
            end)
        end

        if AutoCollect then
            pcall(function()
                for i = 1, 10 do
                    local args = { "Earnings" .. i }
                    CollectRemote:FireServer(unpack(args))
                end
            end)
        end

        task.wait(1)
    end
end)
