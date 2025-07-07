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
            Title = "🛡️ DYHUB",
            Text = text,
            Duration = 3
        })
    end)
end

notify("DYHUB Loaded! for Murder Mystery 2")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DYHUB | DUPE SKIN VISUAL | MM2"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 390)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

local function getRainbowColor(t)
    local frequency = 2
    local red = math.floor(math.sin(frequency * t + 0) * 127 + 128)
    local green = math.floor(math.sin(frequency * t + 2) * 127 + 128)
    local blue = math.floor(math.sin(frequency * t + 4) * 127 + 128)
    return Color3.fromRGB(red, green, blue)
end

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "MM2 | DYHUB"
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

local tpGunButton = Instance.new("TextButton", mainFrame)
tpGunButton.Size = UDim2.new(0.9, 0, 0, 40)
tpGunButton.Position = UDim2.new(0.05, 0, 0, 50)
tpGunButton.Text = "TELEPORT GUN"
tpGunButton.Font = Enum.Font.GothamBold
tpGunButton.TextScaled = true
tpGunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", tpGunButton).CornerRadius = UDim.new(0, 10)

local function getBlackRedColor(t)
    local freq = 2
    local red = math.floor((math.sin(freq * t) * 0.5 + 0.5) * 255)
    return Color3.fromRGB(red, 0, 0)
end

RunService.RenderStepped:Connect(function()
    tpGunButton.BackgroundColor3 = getBlackRedColor(tick())
end)

tpGunButton.MouseButton1Click:Connect(function()
    local gunDrop = Workspace:FindFirstChild("GunDrop")
    if gunDrop and player.Character then
        player.Character:SetPrimaryPartCFrame(gunDrop.CFrame + Vector3.new(0, 5, 0))
        notify("Teleported to Gun Drop")
    else
        notify("No Gun Drop Found!")
    end
end)

local function styleButton(button)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.TextColor3 = Color3.new(1, 1, 1)
end

local espToggle = Instance.new("TextButton", mainFrame)
espToggle.Size = UDim2.new(0.9, 0, 0, 40)
espToggle.Position = UDim2.new(0.05, 0, 0, 100)
espToggle.Text = "ESP: Off"
espToggle.Font = Enum.Font.GothamBold
espToggle.TextScaled = true
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 10)
styleButton(espToggle)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPHolder"
ESPFolder.Parent = game.CoreGui

local espEnabled = false
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ESP: On" or "ESP: Off"
    notify("ESP " .. (espEnabled and "Enabled" or "Disabled"))
end)

local highlights = {}
local rememberedMurderer = nil
local rememberedSheriff = nil
local currentMurderer = "Unknown"
local currentSheriff = "Unknown"

function createOrUpdateHighlight(target)
    if target == player then return end
    local highlight = highlights[target.Name]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0.01
        highlight.Parent = ESPFolder
        highlight.Adornee = target.Character
        highlights[target.Name] = highlight
    end
    highlight.Adornee = target.Character
    if target.Name == currentMurderer then
        highlight.FillColor = Color3.new(1, 0, 0)
    elseif target.Name == currentSheriff then
        highlight.FillColor = Color3.new(0, 0, 1)
    else
        highlight.FillColor = Color3.new(0, 1, 0)
    end
    highlight.Enabled = espEnabled
end

function createOrUpdateESPLabel(target)
    local billboard = ESPFolder:FindFirstChild(target.Name .. "Billboard")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = target.Name .. "Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = ESPFolder

        local text = Instance.new("TextLabel")
        text.Name = "Text"
        text.TextSize = 20
        text.Font = Enum.Font.GothamBold
        text.BackgroundTransparency = 1
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Parent = billboard
    end
    local head = target.Character and target.Character:FindFirstChild("Head")
    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local localHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local distance = "N/A"
    if hrp and localHRP then
        distance = math.floor((hrp.Position - localHRP.Position).Magnitude)
    end
    billboard.Adornee = head
    billboard.Enabled = espEnabled
    billboard.Text.Text = string.format("%s\nStud: %s", target.Name, distance)
    if target.Name == currentMurderer then
        billboard.Text.TextColor3 = Color3.new(1, 0, 0)
    elseif target.Name == currentSheriff then
        billboard.Text.TextColor3 = Color3.new(0, 0, 1)
    else
        billboard.Text.TextColor3 = Color3.new(0, 1, 0)
    end
end

local gunLabel = Instance.new("TextLabel", mainFrame)
gunLabel.Size = UDim2.new(1, 0, 0, 30)
gunLabel.Position = UDim2.new(0, 0, 0, 150)
gunLabel.Text = "Gun Status: Unknown"
gunLabel.Font = Enum.Font.GothamBold
gunLabel.TextScaled = true
gunLabel.TextColor3 = Color3.new(1, 1, 1)
gunLabel.BackgroundTransparency = 1

local murdererLabel = Instance.new("TextLabel", mainFrame)
murdererLabel.Size = UDim2.new(1, 0, 0, 30)
murdererLabel.Position = UDim2.new(0, 0, 0, 180)
murdererLabel.Font = Enum.Font.GothamBold
murdererLabel.TextScaled = true
murdererLabel.TextColor3 = Color3.new(1, 0, 0)
murdererLabel.BackgroundTransparency = 1

local sheriffLabel = Instance.new("TextLabel", mainFrame)
sheriffLabel.Size = UDim2.new(1, 0, 0, 30)
sheriffLabel.Position = UDim2.new(0, 0, 0, 210)
sheriffLabel.Font = Enum.Font.GothamBold
sheriffLabel.TextScaled = true
sheriffLabel.TextColor3 = Color3.new(0, 0, 1)
sheriffLabel.BackgroundTransparency = 1

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    local color = getRainbowColor(t)
    toggleBtn.TextColor3 = color
end)

local function onPlayerWeaponCheck(p)
    local function checkTools()
        local bp = p:FindFirstChild("Backpack")
        local char = p.Character
        local hasKnife = (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife"))
        local hasGun = (bp and bp:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun"))
        if hasKnife then
            rememberedMurderer = p.Name
        elseif rememberedMurderer == p.Name then
            rememberedMurderer = nil
        end
        if hasGun then
            rememberedSheriff = p.Name
        elseif rememberedSheriff == p.Name then
            rememberedSheriff = nil
        end
        currentMurderer = rememberedMurderer or "Unknown"
        currentSheriff = rememberedSheriff or "Unknown"
        murdererLabel.Text = "Murderer: " .. currentMurderer
        sheriffLabel.Text = "Sheriff: " .. currentSheriff
        createOrUpdateHighlight(p)
        createOrUpdateESPLabel(p)
    end
    if p.Character then
        p.Character.ChildAdded:Connect(checkTools)
        p.Character.ChildRemoved:Connect(checkTools)
    end
    local bp = p:FindFirstChild("Backpack")
    if bp then
        bp.ChildAdded:Connect(checkTools)
        bp.ChildRemoved:Connect(checkTools)
    end
    p.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(checkTools)
        char.ChildRemoved:Connect(checkTools)
        checkTools()
    end)
    checkTools()
end

for _, p in pairs(Players:GetPlayers()) do
    onPlayerWeaponCheck(p)
end

Players.PlayerAdded:Connect(onPlayerWeaponCheck)
Players.PlayerRemoving:Connect(function(p)
    if highlights[p.Name] then
        highlights[p.Name]:Destroy()
        highlights[p.Name] = nil
    end
end)

local noclipEnabled = false

local noclipButton = Instance.new("TextButton", mainFrame)
noclipButton.Size = UDim2.new(0.9, 0, 0, 40)
noclipButton.Position = UDim2.new(0.05, 0, 0, 250)
noclipButton.Text = "Noclip: Off"
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextScaled = true
Instance.new("UICorner", noclipButton).CornerRadius = UDim.new(0, 10)
styleButton(noclipButton)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = "Noclip: " .. (noclipEnabled and "On" or "Off")
    notify("Noclip " .. (noclipEnabled and "Enabled" or "Disabled"))
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

local unlockEmoteButton = Instance.new("TextButton", mainFrame)
unlockEmoteButton.Size = UDim2.new(0.9, 0, 0, 40)
unlockEmoteButton.Position = UDim2.new(0.05, 0, 0, 300)
unlockEmoteButton.Text = "Unlock All Emotes"
unlockEmoteButton.Font = Enum.Font.GothamBold
unlockEmoteButton.TextScaled = true
Instance.new("UICorner", unlockEmoteButton).CornerRadius = UDim.new(0, 10)
styleButton(unlockEmoteButton)

unlockEmoteButton.MouseButton1Click:Connect(function()
    local PlayerGui = player:WaitForChild("PlayerGui")
    local Emotes = PlayerGui:WaitForChild("MainGUI"):WaitForChild("Game"):FindFirstChild("Emotes")
    if Emotes then
        local EmoteModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EmoteModule"))
        EmoteModule.GeneratePage(
            {"headless", "zombie", "zen", "ninja", "floss", "dab", "sit"},
            Emotes,
            "Free Emotes"
        )
        notify("✅ Successfully added emotes!")
    else
        notify("❌ Emotes not found!")
    end
end)
