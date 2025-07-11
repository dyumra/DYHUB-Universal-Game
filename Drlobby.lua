local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local function getRainbowColor(t)
    local f = 2
    local r = math.floor(math.sin(f * t + 0) * 127 + 128)
    local g = math.floor(math.sin(f * t + 2) * 127 + 128)
    local b = math.floor(math.sin(f * t + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Lobby"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local black = Instance.new("Frame", gui)
black.Size = UDim2.new(1, 0, 1, 0)
black.BackgroundColor3 = Color3.new(0, 0, 0)
black.BackgroundTransparency = 0.4
black.ZIndex = 0

local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "mainFrame"
mainFrame.Size = UDim2.new(0.4, 0, 0.2, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1
mainFrame.ZIndex = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(0.8, 0, 0.3, 0)
title.Position = UDim2.new(0.5, 0, 0.1, 0)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Lobby | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.ZIndex = 2

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    title.TextColor3 = color
end)

local bondCount = Instance.new("TextLabel", mainFrame)
bondCount.Name = "TextJoin"
bondCount.Size = UDim2.new(0.6, 0, 0.2, 0)
bondCount.Position = UDim2.new(0.5, 0, 0.6, 0)
bondCount.AnchorPoint = Vector2.new(0.5, 0)
bondCount.BackgroundTransparency = 1
bondCount.Text = "Join our (dsc.gg/dyhub)"
bondCount.TextColor3 = Color3.new(1, 1, 1)
bondCount.TextScaled = true
bondCount.Font = Enum.Font.SourceSans
bondCount.ZIndex = 2

local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 12
blur.Name = "Blur"

local args = {
    [1] = {
        ["isPrivate"] = true,
        ["maxMembers"] = 1,
        ["trainId"] = "default",
        ["gameMode"] = "Normal"
    }
}

local function isZoneOccupied(hitbox)
    local region = Region3.new(
        hitbox.Position - Vector3.new(5,5,5),
        hitbox.Position + Vector3.new(5,5,5)
    )
    local parts = workspace:FindPartsInRegion3(region, nil, math.huge)
    for _, part in ipairs(parts) do
        local model = part:FindFirstAncestorOfClass("Model")
        if model and Players:GetPlayerFromCharacter(model) and Players:GetPlayerFromCharacter(model) ~= player then
            return true
        end
    end
    return false
end

local function tryCreateParty()
    local zones = workspace:WaitForChild("PartyZones"):GetChildren()
    for _, zone in ipairs(zones) do
        local hitbox = zone:FindFirstChild("Hitbox")
        if hitbox and not isZoneOccupied(hitbox) then
            local character = player.Character or player.CharacterAdded:Wait()
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = hitbox.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.5)
                ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("CreateParty"):FireServer(unpack(args))
                return true
            end
        end
    end
    return false
end

while task.wait(0.5) do
    if tryCreateParty() then
        break
    end
end
