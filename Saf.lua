-- =========================
local version = "3.5.2"
-- =========================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ========================= SERVICES =========================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ========================= SETTINGS =========================
_G.AutoCollectMoney = false
_G.AutoLockBase = false
_G.NoHoldSteal = false
_G.Noclip = false

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Steal A Fish | Free Version",
    Folder = "DYHUB_SAF",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- ====================== Tabs ======================
local Tabs = {
    GameTab = Window:Tab({ Title = "Main", Icon = "rocket" }),
    PlayerTab = Window:Tab({ Title = "Player", Icon = "user" }),
    ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" }),
    TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
}
Window:SelectTab(1)

-- ====================== GameTab ======================
Tabs.GameTab:Toggle({
    Title = "Auto Collect (Money)",
    Default = false,
    Callback = function(state)
        _G.AutoCollectMoney = state
        if state then
            task.spawn(function()
                while _G.AutoCollectMoney do
                    for i = 1, 30 do
                        local success, err = pcall(function()
                            ReplicatedStorage:WaitForChild("voidSky")
                                :WaitForChild("Remotes")
                                :WaitForChild("Server")
                                :WaitForChild("Objects")
                                :WaitForChild("Trash")
                                :WaitForChild("Collect")
                                :FireServer(i)
                        end)
                        if not success then warn("AutoCollect Error:", err) end
                        task.wait(0.05)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- ====================== Auto Lock Base ======================
local function GetNearestTycoon()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local nearest, dist = nil, math.huge

    for _, tycoon in pairs(Workspace:WaitForChild("Map"):WaitForChild("Tycoons"):GetChildren()) do
        local tycoonMain = tycoon:FindFirstChild("Tycoon")
        if tycoonMain and tycoonMain:IsA("Model") then
            local base = tycoonMain:FindFirstChild("Base") or tycoonMain:FindFirstChild("MainPart") or tycoonMain:FindFirstChildWhichIsA("BasePart")
            if base then
                local d = (hrp.Position - base.Position).Magnitude
                if d < dist then
                    nearest = tycoon
                    dist = d
                end
            end
        end
    end
    return nearest
end

local function LockBase(tycoon)
    task.spawn(function()
        while _G.AutoLockBase do
            local success, err = pcall(function()
                local args = {
                    tycoon:WaitForChild("Tycoon")
                        :WaitForChild("ForcefieldFolder")
                        :WaitForChild("Buttons")
                        :WaitForChild("ForceFieldBuy")
                }
                ReplicatedStorage:WaitForChild("voidSky")
                    :WaitForChild("Remotes")
                    :WaitForChild("Server")
                    :WaitForChild("Objects")
                    :WaitForChild("BuyButton")
                    :FireServer(unpack(args))
            end)
            if not success then warn("LockBase Error:", err) end
            task.wait(1.7)
        end
    end)
end

Tabs.GameTab:Toggle({
    Title = "Auto Lock Base",
    Default = false,
    Callback = function(state)
        _G.AutoLockBase = state
        if state then
            local myTycoon = GetNearestTycoon()
            if myTycoon then
                print("🔒 Locking Tycoon:", myTycoon.Name)
                LockBase(myTycoon)
            else
                warn("❌ Tycoon not found near you")
            end
        end
    end
})

-- ====================== Steal (No Hold) ======================
Tabs.GameTab:Toggle({
    Title = "Steal (No Hold)",
    Default = false,
    Callback = function(state)
        _G.NoHoldSteal = state
        if state then
            task.spawn(function()
                while _G.NoHoldSteal do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end
})

-- ====================== ESP Tab ======================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPFolder:FindFirstChild(player.Name) then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    local function attachESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = player.Character
            billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    attachESP()
    player.CharacterAdded:Connect(function()
        task.wait(1)
        attachESP()
    end)

    highlight.Parent = ESPFolder
    billboard.Parent = ESPFolder
end

local function removeESP(player)
    local h = ESPFolder:FindFirstChild(player.Name)
    local b = ESPFolder:FindFirstChild(player.Name .. "_ESPLabel")
    if h then h:Destroy() end
    if b then b:Destroy() end
end

Tabs.ESPTab:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        if state then
            for _, plr in pairs(Players:GetPlayers()) do createESP(plr) end
            Players.PlayerAdded:Connect(createESP)
            Players.PlayerRemoving:Connect(removeESP)
        else
            ESPFolder:ClearAllChildren()
        end
    end
})

-- ====================== Teleport Tab ======================
local savedCFrame
task.delay(2, function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then savedCFrame = hrp.CFrame end
end)

Tabs.TeleportTab:Button({
    Title = "Teleport to Home",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and savedCFrame then
            hrp.CFrame = savedCFrame
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport",
                Text = "Spawn point not saved or character missing!",
                Duration = 5
            })
        end
    end
})
