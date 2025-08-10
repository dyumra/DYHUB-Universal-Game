local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Remote = game:GetService("ReplicatedStorage").RemoteEvents.RequestTakeDiamonds
local Interface = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface")
local DiamondCount = Interface:WaitForChild("DiamondCount"):WaitForChild("Count")

local chest, proxPrompt
local startTime

-- ฟังก์ชันเปลี่ยนสีรุ้ง
local function getRainbowColor(t)
    local f = 2
    local r = math.floor(math.sin(f * t + 0) * 127 + 128)
    local g = math.floor(math.sin(f * t + 2) * 127 + 128)
    local b = math.floor(math.sin(f * t + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

-- ฟังก์ชันเปลี่ยนเซิร์ฟเวอร์
local function hopServer()
    local gameId = game.PlaceId
    while true do
        local success, body = pcall(function()
            return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(gameId))
        end)
        if success then
            local data = HttpService:JSONDecode(body)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    while true do
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(gameId, server.id, LocalPlayer)
                        end)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.2)
    end
end

-- ถ้าเจอชื่อเราใน Characters ให้กระโดดเซิร์ฟ
task.spawn(function()
    while task.wait(1) do
        for _, char in pairs(workspace.Characters:GetChildren()) do
            if char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                if char:FindFirstChild("Humanoid").DisplayName == LocalPlayer.DisplayName then
                    hopServer()
                end
            end
        end
    end
end)

-- สร้าง GUI GemFarm
local gui2 = Instance.new("ScreenGui", game.CoreGui)
gui2.Name = "GemFarm"
gui2.ResetOnSpawn = false
gui2.IgnoreGuiInset = true

local black = Instance.new("Frame", gui2)
black.Size = UDim2.new(1, 0, 1, 0)
black.BackgroundColor3 = Color3.new(0, 0, 0)
black.BackgroundTransparency = 0.4

local mainFrame2 = Instance.new("Frame", gui2)
mainFrame2.Name = "mainFrame"
mainFrame2.Size = UDim2.new(0.4, 0, 0.2, 0)
mainFrame2.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame2.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame2.BackgroundTransparency = 1

local title2 = Instance.new("TextLabel", mainFrame2)
title2.Size = UDim2.new(0.8, 0, 0.3, 0)
title2.Position = UDim2.new(0.5, 0, 0.1, 0)
title2.AnchorPoint = Vector2.new(0.5, 0)
title2.BackgroundTransparency = 1
title2.Text = "Auto-Farm Gem | DYHUB"
title2.TextColor3 = Color3.new(1, 1, 1)
title2.TextScaled = true
title2.Font = Enum.Font.SourceSansBold

RunService.RenderStepped:Connect(function()
    title2.TextColor3 = getRainbowColor(tick())
end)

local bondCount = Instance.new("TextLabel", mainFrame2)
bondCount.Name = "GemCount"
bondCount.Size = UDim2.new(0.6, 0, 0.2, 0)
bondCount.Position = UDim2.new(0.5, 0, 0.6, 0)
bondCount.AnchorPoint = Vector2.new(0.5, 0)
bondCount.BackgroundTransparency = 1
bondCount.Text = "💎 Gems: N/A"
bondCount.TextColor3 = Color3.new(1, 1, 1)
bondCount.TextScaled = true
bondCount.Font = Enum.Font.SourceSans

Instance.new("BlurEffect", game:GetService("Lighting")).Size = 12

-- อัพเดทจำนวนเพชรบน GUI
task.spawn(function()
    while task.wait(0.2) do
        bondCount.Text = "💎 Gems: " .. DiamondCount.Text
    end
end)

-- รอให้ตัวละครโหลด
repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- หากล่องเพชร
chest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
if not chest then
    CoreGui:SetCore("SendNotification", {
        Title = "Notification",
        Text = "chest not found (my fault)",
        Duration = 3
    })
    hopServer()
    return
end

-- วาร์ปไปที่กล่อง
LocalPlayer.Character:PivotTo(CFrame.new(chest:GetPivot().Position))

-- หา ProximityPrompt
repeat
    task.wait(0.1)
    local prox = chest:FindFirstChild("Main")
    if prox and prox:FindFirstChild("ProximityAttachment") then
        proxPrompt = prox.ProximityAttachment:FindFirstChild("ProximityInteraction")
    end
until proxPrompt

-- กดใช้ ProximityPrompt
startTime = tick()
while proxPrompt and proxPrompt.Parent and (tick() - startTime) < 10 do
    pcall(function()
        fireproximityprompt(proxPrompt)
    end)
    task.wait(0.2)
end

-- ถ้า Stronghold เริ่มแล้วก็เปลี่ยนเซิร์ฟ
if proxPrompt and proxPrompt.Parent then
    CoreGui:SetCore("SendNotification", {
        Title = "Notification",
        Text = "stronghold is starting (auto coming soon) ",
        Duration = 3
    })
    hopServer()
    return
end

-- รอให้เพชรโผล่มา
repeat task.wait(0.1) until workspace:FindFirstChild("Diamond", true)

-- เก็บเพชรทั้งหมด
for _, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Model" and v.Name == "Diamond" then
        Remote:FireServer(v)
    end
end

CoreGui:SetCore("SendNotification", {
    Title = "Notification",
    Text = "take all the diamonds",
    Duration = 3
})

task.wait(1)
hopServer()
