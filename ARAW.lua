-- V14

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🛡️ DYHUB | V2",
            Text = text,
            Duration = 3
        })
    end)
end

notify("DYHUB Loaded! for Anime Rails")

local looping = false
local moving = false

-- ✅ จุดวาร์ป
local targetCFrame = CFrame.new(-16436.0254, 167.425308, 21.7240829)
local finalCFrame = CFrame.new(-16413.0449, 168.362885, 36.4172363)
local finalCFrame2 = CFrame.new(-16710.6602, 576.828796, -20.0188751)

-- ✅ skill args
local skillArgs = {
	"Beserk",
	"TigerPlumit",
	vector.create(-16710.6602, 576.828796, -20.0188751)
}

local args2 = {
	"Beserk",
	"HollowNuke",
	vector.create(-16710.6602, 576.828796, -20.0188751)
}

local args1 = {
	{
		Key = "GojoDomain",
		Function = "Active"
	}
}


-- ✅ ฟังก์ชันกด ProximityPrompt อัตโนมัติ
local function activateProximityPrompts()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
            pcall(function()
                fireproximityprompt(obj)
            end)
        end
    end
end

-- ✅ ฟังก์ชันวาร์ปหลัก
local function startTeleport()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        local startPos = hrp.Position
        local duration = 10
        local elapsed = 0
        moving = true

        -- กันตก
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
            local newPos = startPos:Lerp(targetCFrame.Position, alpha)
            newPos = Vector3.new(newPos.X, newPos.Y + 50, newPos.Z)
            hrp.CFrame = CFrame.new(newPos)

            local distance = (newPos - targetCFrame.Position).Magnitude
            if distance < 10 then
                break
            end

            task.wait()
            elapsed += RunService.Heartbeat:Wait()
        end

        noclipConnection:Disconnect()
        platform:Destroy()

        notify("Arrived! Waiting 5 seconds...")
        task.wait(5)

        -- ✅ วาร์ปไปจุดแรก
        hrp.CFrame = finalCFrame
        notify("First Teleport Done!")

        -- ✅ กด ProximityPrompt
        activateProximityPrompts()
        notify("ProximityPrompt Activated! Waiting 5s...")
        task.wait(6.9)

        -- ✅ วาร์ปไปจุดสอง
        hrp.CFrame = finalCFrame2
        notify("Final Teleport Done!")

        -- ✅ ยิงสกิลรัวๆ (จนกว่าบอสจะตาย)
        task.spawn(function()
            while task.wait(0.25) do
                if not looping then break end
                ReplicatedStorage:WaitForChild("Events"):WaitForChild("Skill"):FireServer(unpack(skillArgs))
                task.wait(0.25)
                ReplicatedStorage:WaitForChild("Events"):WaitForChild("Skill"):FireServer(unpack(args2))
				task.wait(0.25)
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ServerRemote"):FireServer(unpack(args1))
            end
        end)

        moving = false
    end
end

-- ✅ GUI
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
warnLabel.Position = UDim2.new(0.05, 0, 0, 120)
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
