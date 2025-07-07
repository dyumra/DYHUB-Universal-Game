local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🛡️ DYHUB",
            Text = text,
            Duration = 3
        })
    end)
end

notify("DYHUB Loaded! for Anime Rails")

local looping = false
local moving = false

local targetCFrame = CFrame.new(
    -16436.0254, 167.425308, 21.7240829,
    -8.10623169e-05, 8.10623169e-05, 1,
    1, -8.10623169e-05, 8.10623169e-05,
    8.10623169e-05, 1, -8.10623169e-05
)
local targetPosition = targetCFrame.Position

local finalCFrame = CFrame.new(
    -16413.0449, 168.362885, 36.4172363,
    0.609278917, -5.05710762e-09, 0.792955995,
    2.53511234e-09, 1, 4.42964954e-09,
    -0.792955995, -6.88659518e-10, 0.609278917
)

local skillArgs = {
    [1] = "L",
    [2] = "FateStorm",
    [3] = CFrame.new(
        -1717.7021484375, 195.94349670410156, -392.0003662109375,
        0.662624716758728, -0.0859827920794487, 0.7439996004104614,
        -0, 0.9933881163597107, 0.11480420082807541,
        -0.7489516139030457, -0.07607210427522659, 0.6582435369491577
    )
}

local function startTeleport()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        local startPos = hrp.Position
        local duration = 10
        local elapsed = 0
        moving = true

        -- ยกสูง + ป้องกันตก
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(10, 1, 10)
        platform.Position = hrp.Position - Vector3.new(0, 3, 0)
        platform.Anchored = true
        platform.Transparency = 0.5
        platform.CanCollide = true
        platform.Parent = workspace

        local noclipConnection = RunService.Stepped:Connect(function()
            hum:ChangeState(11)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        while elapsed < duration and moving do
            local alpha = elapsed / duration
            local newPos = startPos:Lerp(targetPosition, alpha)
            newPos = Vector3.new(newPos.X, newPos.Y + 50, newPos.Z)
            hrp.CFrame = CFrame.new(newPos, newPos + targetCFrame.LookVector)

            local distance = (newPos - targetPosition).Magnitude
            if distance < 10 then
                break
            end

            task.wait()
            elapsed += RunService.Heartbeat:Wait()
        end

        noclipConnection:Disconnect()
        platform:Destroy()

        -- ✅ รอ 5 วิ ก่อนวาร์ปทับ
        notify("Arrived! Waiting 5 seconds...")
        task.wait(5)

        hrp.CFrame = finalCFrame
        notify("Final Teleport Done!")

        -- ✅ ยิง Skill 500 ครั้ง
        task.spawn(function()
            for i = 1, 500 do
                ReplicatedStorage:WaitForChild("Events"):WaitForChild("Skill"):FireServer(unpack(skillArgs))
                task.wait(2/500)
            end
        end)

        moving = false
    end
end

-- ปุ่มกดเดิม
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DYHUB | Auto Win | Anime Rails"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
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
title.Text = "Anime Rails | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

local autoWinButton = Instance.new("TextButton", mainFrame)
autoWinButton.Size = UDim2.new(0.6, 0, 0, 40)
autoWinButton.Position = UDim2.new(0.2, 0, 0, 60)
autoWinButton.Text = "Auto Win: Off"
autoWinButton.Font = Enum.Font.GothamBold
autoWinButton.TextScaled = true
autoWinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", autoWinButton).CornerRadius = UDim.new(0, 10)

RunService.RenderStepped:Connect(function()
    autoWinButton.BackgroundColor3 = getRainbowColor(tick())
end)

local warnLabel = Instance.new("TextLabel", mainFrame)
warnLabel.Size = UDim2.new(0.9, 0, 0, 40)
warnLabel.Position = UDim2.new(0.05, 0, 0, 230)
warnLabel.Text = "⚠️ Be careful, Please press only once for the Auto-Win to run."
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextScaled = true
warnLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
warnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", warnLabel).CornerRadius = UDim.new(0, 10)

autoWinButton.MouseButton1Click:Connect(function()
    looping = not looping
    autoWinButton.Text = looping and "Auto Win: On" or "Auto Win: Off"
    notify("Auto Win: " .. (looping and "Enabled" or "Disabled"))

    if looping then
        startTeleport()
    else
        moving = false
    end
end)
