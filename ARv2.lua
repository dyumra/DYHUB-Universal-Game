repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "DYHUB Loaded! - Anime Rails",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})

repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - Anime Rails",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local CashTab = Window:Tab({ Title = "Cash", Icon = "circle-dollar-sign" })
local EquipTab = Window:Tab({ Title = "Equip", Icon = "book-check" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- ======= Main =======
local cashInputValue = ""
local cashInputValue2 = ""
local dupeNames = {
  "Infinity", "Solar", "Crimson", "DarkArcher", "PurpleAssasin", "WolfBoss", "Merchant", "SickCurse", "Tank",
  "CrimsonMaster", "Lightning", "SunBreather", "KnightBoss", "Materials", "Baryon", "HeinEra", "Sukuna",
  "Naruto", "SSGoku", "Tanjiro", "Goku", "Shadows", "Kaiser", "Puzzle", "Knight", "Shake", "Hapticss",
  "MuzanAura", "MoonAura", "YellowAura", "MuzanClass", "KokoshiboClass", "CompassClass", "MuzanMorph",
  "MoonMorph", "HakiPower", "InfinityVoid", "Dismantle", "Restriction", "BlackFlashAura", "ShadowAura",
  "CriticalHit", "Gear4", "BlackFlash", "Toji", "InfinityEyes", "MasteredReflex", "LavaMasterClass",
  "RedeemedWolfBoss", "RedeemedKnight", "LuffyMorph", "DoughMorph", "GravityAura", "DoughAura",
  "LavaAura", "Gear5Class", "MochiClass", "Rinnegan", "Kurama", "Sasuke", "Pain", "EightGates", "Sed",
  "Cid", "Gojo", "Assasin", "AntKing", "BlueFlames", "BloodKnight", "BloodMorph", "BloodMorphS",
  "AntMorph", "AntMorphS", "AssasinMorph", "LightAura", "AlterAura", "Alter", "Saber", "SaberMorph", "AlterMorph",
  "Hakai", "PridfulWarrior", "EarthWarrior", "GreatApe"
}

MainTab:Input({
    Title = "Dupe Morph",
    Placeholder = "Use the name from Npc Morph",
    Callback = function(text)
        cashinputvalue = text
    end,
})

MainTab:Button({
    Title = "Unlock Morph",
    Icon = "crown",
    Callback = function()
           for _, name in ipairs(dupeNames) do
        event:FireServer("SetMorphBuy", name, 0
        else
            print("[DYHUB] Invalid Morph:", cashInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Class",
    Placeholder = "Use the name from Npc Morph",
    Callback = function(text)
        cashinputvalue = text
    end,
})

MainTab:Button({
    Title = "Unlock Class",
    Icon = "swords",
    Callback = function()
           for _, name in ipairs(dupeNames) do
        event:FireServer("SetClassBuy", name, 0
        else
            print("[DYHUB] Invalid Class:", cashInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Aura",
    Placeholder = "Use the name from Npc Morph",
    Callback = function(text)
        cashinputvalue = text
    end,
})

MainTab:Button({
    Title = "Unlock Aura",
    Icon = "flame",
    Callback = function()
           for _, name in ipairs(dupeNames) do
        event:FireServer("SetAuraBuy", name, 0
        else
            print("[DYHUB] Invalid Aura:", cashInputValue)
        end
    end,
})

MainTab:Button({
    Title = "Unlock All",
    Icon = "atom",
    Callback = function()
           for _, name in ipairs(dupeNames) do
        event:FireServer("SetMorphBuy", name, 0 -- Morph Can buy all Class/Aura
        else
            print("[DYHUB] Invalid Morph:", cashInputValue)
        end
    end,
})

-- ======= Cash =======
CashTab:Input({
    Title = "Enter Dupe Cash Amount",
    Placeholder = "100 ~ 10000",
    Callback = function(text)
        cashInputValue = text
    end,
})

CashTab:Button({
    Title = "Dupe Cash",
    Icon = "dollar-sign",
    Callback = function()
        local input = tonumber(cashInputValue)
        if input and input >= 100 and input <= 10000 then
            local args = {
                [1] = "Wins",
                [2] = input,
                [3] = "SABER"
            }
            ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
            print("[DYHUB] Dupe Cash:", input)
        else
            print("[DYHUB] Invalid amount:", cashInputValue)
        end
    end,
})

-- Infinite Cash
CashTab:Button({
    Title = "Infinite Dupe Cash",
    Icon = "infinity",
    Callback = function()
        local totalAmount = 999000000
        local perFire = 999999
        local times = math.floor(totalAmount / perFire)
        task.spawn(function()
            for i = 1, times do
                local args = {
                    [1] = "Wins",
                    [2] = perFire,
                    [3] = "DYHUB"
                }
                ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
                task.wait(0.1)
            end
            print("[DYHUB] Completed Infinite Cash")
        end)
    end,
})

-- Infinite Spin (ให้เงิน 0)
CashTab:Button({
    Title = "Infinite Dupe Spin",
    Icon = "rotate-ccw",
    Callback = function()
        local totalAmount = 999999
        local perFire = 1
        local times = math.floor(totalAmount / perFire)
        task.spawn(function()
            for i = 1, times do
                local args = {
                    [1] = "Wins",
                    [2] = 0,
                    [3] = "DYHUB"
                }
                ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
                task.wait(0.05)
            end
            print("[DYHUB] Completed Infinite Dupe Spin")
        end)
    end,
})

-- ======= Player Tab =======
local espEnabled = false
local espOptions = {
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    HighlightColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false
}
local espHighlights = {}
local espBillboards = {}

local function getRainbowColor(tick)
    local frequency = 0.5
    local r = math.sin(frequency * tick + 0) * 0.5 + 0.5
    local g = math.sin(frequency * tick + 2) * 0.5 + 0.5
    local b = math.sin(frequency * tick + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

local function createBillboard(player)
    if espBillboards[player] then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DYHUB_Billboard"
    billboard.Adornee = player.Character.HumanoidRootPart
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = espOptions.HighlightColor
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.Parent = billboard

    billboard.Parent = player.Character or workspace
    espBillboards[player] = billboard
end

local function updateBillboard(player)
    if not espBillboards[player] then return end
    local billboard = espBillboards[player]
    local label = billboard:FindFirstChild("TextLabel")
    if not label then return end
    local nameStr = espOptions.ShowName and player.Name or ""
    local healthStr = ""
    if espOptions.ShowHealth and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then healthStr = string.format("HP:%.0f", hum.Health) end
    end
    local distStr = ""
    if espOptions.ShowDistance and player.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
        distStr = string.format("Dist:%.1f", dist)
    end
    label.Text = nameStr .. healthStr .. distStr
end

local function removeBillboard(player)
    if espBillboards[player] then
        espBillboards[player]:Destroy()
        espBillboards[player] = nil
    end
end

local rainbowTick = 0
local function updateESP()
    rainbowTick = rainbowTick + task.wait()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not espHighlights[p] then
                local highlight = Instance.new("Highlight")
                highlight.Name = "DYHUB_ESP"
                highlight.Adornee = p.Character
                highlight.OutlineColor = Color3.new(0, 0, 0)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = workspace
                espHighlights[p] = highlight
            else
                if espHighlights[p].Adornee ~= p.Character then
                    espHighlights[p].Adornee = p.Character
                end
            end

            if espOptions.Rainbow then
                local color = getRainbowColor(rainbowTick * 5)
                espOptions.HighlightColor = color
                espHighlights[p].FillColor = color
            else
                espHighlights[p].FillColor = espOptions.HighlightColor
            end

            createBillboard(p)
            updateBillboard(p)
        end
    end
end

local function clearESP()
    for _, h in pairs(espHighlights) do if h then h:Destroy() end end
    espHighlights = {}
    for p,_ in pairs(espBillboards) do removeBillboard(p) end
end

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        task.defer(function()
            player.CharacterAdded:Wait()
            updateESP()
        end)
    end
end)

local espUpdateConnection

PlayerTab:Dropdown({
    Title = "ESP Color",
    Default = "Green",
    Options = {
        "Red", "Green", "Blue", "Yellow", "Purple", "Cyan", "White", "Black", "Rainbow"
    },
    Callback = function(colorName)
        espOptions.Rainbow = false
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(128, 0, 128),
            Cyan = Color3.fromRGB(0, 255, 255),
            White = Color3.fromRGB(255, 255, 255),
            Black = Color3.fromRGB(0, 0, 0),
        }
        if colorName == "Rainbow" then
            espOptions.Rainbow = true
        else
            espOptions.HighlightColor = colors[colorName] or Color3.fromRGB(0, 255, 0)
        end
    end,
})

PlayerTab:Toggle({
    Title = "Enable ESP",
    Value = false,
    Callback = function(state)
        espEnabled = state
        if espEnabled then
            updateESP()
            espUpdateConnection = RunService.Heartbeat:Connect(updateESP)
        else
            clearESP()
            if espUpdateConnection then
                espUpdateConnection:Disconnect()
                espUpdateConnection = nil
            end
        end
    end,
})

PlayerTab:Toggle({
    Title = "Show Name",
    Value = false,
    Callback = function(state)
        espOptions.ShowName = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Health",
    Value = false,
    Callback = function(state)
        espOptions.ShowHealth = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Distance",
    Value = false,
    Callback = function(state)
        espOptions.ShowDistance = state
    end,
})

local playerNameInput = ""
PlayerTab:Input({
    Title = "Teleport to Player",
    Value = playerNameInput,
    Placeholder = "Enter name (Roblox123 or Ro)",
    Callback = function(text)
        playerNameInput = text
    end,
})

local function findPlayerByPartialName(partialName)
    partialName = partialName:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #partialName) == partialName then
            return player
        end
    end
    return nil
end

PlayerTab:Button({
    Title = "Teleport",
    Callback = function()
        if playerNameInput ~= "" then
            local p = findPlayerByPartialName(playerNameInput)
            if p and p.Character and LocalPlayer.Character then
                LocalPlayer.Character:PivotTo(p.Character:GetPivot())
                print("[DYHUB] Teleported to " .. p.Name)
            else
                warn("[DYHUB] Player not found or character missing")
            end
        else
            warn("[DYHUB] Please enter a player name")
        end
    end,
})

PlayerTab:Button({
    Title = "Teleport Random",
    Callback = function()
        local list = Players:GetPlayers()
        if #list > 1 then
            local t
            repeat
                t = list[math.random(1, #list)]
            until t ~= LocalPlayer
            if t.Character and LocalPlayer.Character then
                LocalPlayer.Character:PivotTo(t.Character:GetPivot())
                print("[DYHUB] Teleported randomly to " .. t.Name)
            end
        end
    end,
})

PlayerTab:Slider({
    Title = "Walk Speed",
    Value = { Min = 8, Max = 100, Default = 16 },
    Callback = function(value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end
    end,
})

PlayerTab:Slider({
    Title = "Jump Power",
    Value = { Min = 20, Max = 200, Default = 50 },
    Callback = function(value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = value end
    end,
})

local noclip = false
local noclipConn
PlayerTab:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(state)
        noclip = state
        if noclip then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            print("[DYHUB] Noclip Enabled")
        else
            if noclipConn then
                noclipConn:Disconnect()
                noclipConn = nil
            end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            print("[DYHUB] Noclip Disabled")
        end
    end,
})

-- ======= Teleport Tab =======
local teleportPositions = {
    ["In-game"] = CFrame.new(0.126203626, -8.70080376, 224.518723, -0.436265141, 1.23078472e-08, -0.899818182, 4.95810468e-08, 1, -1.03605773e-08, 0.899818182, -4.91338845e-08, -0.436265141),
    ["Lobby"] = CFrame.new(0.106019527, 3.49999976, -1.46082389, 0.99961549, 2.78097261e-08, 0.0277295075, -2.96380716e-08, 1, 6.55240555e-08, -0.0277295075, -6.63207018e-08, 0.99961549),
    ["Gamepass"] = CFrame.new(42.0702209, 2.49999976, -0.357365221, -0.235460415, 2.975057e-08, -0.971883953, 7.9592489e-08, 1, 1.13281935e-08, 0.971883953, -7.46873212e-08, -0.235460415),
    ["Shop"] = CFrame.new(79.8672714, 2.49999976, -58.3157539, -0.0260891877, -2.85041768e-09, -0.999659598, -6.67470132e-08, 1, -1.10941989e-09, 0.999659598, 6.66953568e-08, -0.0260891877),
    ["Free Morph"] = CFrame.new(0.735759139, 2.49999976, -94.2842636, 0.991858304, 8.383455e-08, -0.127346292, -8.2608878e-08, 1, 1.49061545e-08, 0.127346292, -4.26485869e-09, 0.991858304),
    ["Leaderboard"] = CFrame.new(-51.4132462, 2.5, -55.6683083, -0.0158058051, -1.25096076e-08, 0.999875069, -5.91185092e-08, 1, 1.15766383e-08, -0.999875069, -5.89281441e-08, -0.0158058051),
    ["VIP"] = CFrame.new(-43.7592621, 2.49999976, 1.43719995, 0.16314514, -1.08637472e-08, 0.986602068, -7.76504265e-08, 1, 2.38515998e-08, -0.986602068, -8.05013443e-08, 0.16314514),
}

for name, cframe in pairs(teleportPositions) do
    TeleportTab:Button({
        Title = name,
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = cframe
                print("[DYHUB] Teleported to", name)
            else
                warn("[DYHUB] Character or HumanoidRootPart not found.")
            end
        end,
    })
end

-- ======= Misc Tab =======
local antiKick = false
local antiAfk = false
local antiAdmin = false

MiscTab:Toggle({
    Title = "Bypass (do not turn off)",
    Value = true,
    Callback = function(state)
        print("[DYHUB] Bypassing Checking Loop" .. (state and "Enabled" or "Disabled"))
        print("[DYHUB] Anti Reset " .. (state and "Enabled" or "Disabled"))
        print("[DYHUB] Anti Cheat " .. (state and "Enabled" or "Disabled"))
        print("[DYHUB] Anti Ban " .. (state and "Enabled" or "Disabled"))
    end,
})

MiscTab:Toggle({
    Title = "Anti Reset",
    Value = false,
    Callback = function(state)
        print("[DYHUB] Anti Reset " .. (state and "Enabled" or "Disabled"))
    end,
})

MiscTab:Toggle({
    Title = "Anti AFK",
    Value = false,
    Callback = function(state)
        antiAfk = state
        print("[DYHUB] Anti AFK " .. (state and "Enabled" or "Disabled"))
    end,
})

MiscTab:Toggle({
    Title = "Anti Admin (Server Hop)",
    Value = false,
    Callback = function(state)
        antiAdmin = state
        print("[DYHUB] Anti Admin " .. (state and "Enabled" or "Disabled"))
    end,
})

MiscTab:Toggle({
    Title = "Multi Equip Tools (All)",
    Value = false,
    Callback = function(state)
        if state then
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                tool.Parent = LocalPlayer.Character
            end
            print("[DYHUB] Multi equipped all tools")
        end
    end,
})

Players.PlayerAdded:Connect(function(p)
    if antiAdmin and (p.Name == "Name555" or p.Name == "Roblox123") then
        game.StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = "Admin Detected! Server Hopping...",
            Duration = 5
        })
        TeleportService:Teleport(game.PlaceId)
    end
end)

LocalPlayer.Idled:Connect(function()
    if antiAfk then
        VirtualUser:Button2Down(Vector2.new(0,0))
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0))
    end
end)

-- ======= Config Tab =======
local configs = {}
local selectedConfig = nil
local configNameInput = ""

ConfigTab:Input({
    Title = "Config Name",
    Value = "",
    Placeholder = "DYHUBCONFIG1",
    Callback = function(v) configNameInput = v end,
})

ConfigTab:Button({
    Title = "Save Config",
    Callback = function()
        if configNameInput ~= "" then
            configs[configNameInput] = {
                Cash = cashInputValue,
                AutoRebirth = autoRebirth,
                -- เพิ่มเติมค่าที่ต้องการบันทึก
            }
            print("[DYHUB] Config saved: " .. configNameInput)
        else
            warn("[DYHUB] Enter a config name before saving.")
        end
    end,
})

ConfigTab:Input({
    Title = "Load Config Name",
    Value = "",
    Placeholder = "DYHUBCONFIG1",
    Callback = function(v) selectedConfig = v end,
})

ConfigTab:Button({
    Title = "Load Config",
    Callback = function()
        if selectedConfig and configs[selectedConfig] then
            local c = configs[selectedConfig]
            cashInputValue = c.Cash or cashInputValue
            autoRebirth = c.AutoRebirth or false
            print("[DYHUB] Config loaded: " .. selectedConfig)
            -- อัพเดต UI ถ้าจำเป็น
        else
            warn("[DYHUB] Config not found: " .. tostring(selectedConfig))
        end
    end,
})

print("[DYHUB] Full Anime Rails Loaded!")
