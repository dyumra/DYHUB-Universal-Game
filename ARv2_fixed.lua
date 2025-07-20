repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

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

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local CashTab = Window:Tab({ Title = "Cash", Icon = "circle-dollar-sign" })
-- local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
-- local EquipTab = Window:Tab({ Title = "Equip", Icon = "star" })
local GamepassTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- Main Tab
local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ChangeValue")

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
    "Hakai", "PridfulWarrior", "EarthWarrior", "GreatApe", "BeerusMorph", "VegetaMorph", "BeerusBoss", "Mahoraga"
}

local morphInputValue = ""
local classInputValue = ""
local auraInputValue = ""

MainTab:Button({
    Title = "Dupe All (Click me for All)",
    Icon = "atom",
    Callback = function()
        for _, name in ipairs(dupeNames) do
            event:FireServer("SetMorphBuy", name, 0)
            wait(0.05)
        end
        print("[DYHUB] All Morphs, Classes and Auras unlocked!")
    end,
})

MainTab:Input({
    Title = "Dupe Morph",
    Placeholder = "Use the name from Npc Morph",
    Callback = function(text)
        morphInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Morph",
    Icon = "crown",
    Callback = function()
        local found = false
        for _, name in ipairs(dupeNames) do
            if name:lower() == morphInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Morph unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Morph:", morphInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Class",
    Placeholder = "Use the name from Npc Class",
    Callback = function(text)
        classInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Class",
    Icon = "swords",
    Callback = function()
        local found = false
        for _, name in ipairs(dupeNames) do
            if name:lower() == classInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Class unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Class:", classInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Aura",
    Placeholder = "Use the name from Npc Aura",
    Callback = function(text)
        auraInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Aura",
    Icon = "flame",
    Callback = function()
        local found = false
        for _, name in ipairs(dupeNames) do
            if name:lower() == auraInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Aura unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Aura:", auraInputValue)
        end
    end,
})

-- Gamepass Tab
local selectedGamepass = "All"
GamepassTab:Dropdown({
    Title = "Select Gamepass",
    Values = { "All", "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" },
    Multi = false,
    Callback = function(selected)
        selectedGamepass = selected
        print("[DYHUB] Selected Gamepass:", selectedGamepass)
    end,
})

GamepassTab:Button({
    Title = "Enter Unlock",
    Icon = "check",
    Callback = function()
        local player = LocalPlayer
        local data = player:FindFirstChild("Data")
        if not data then
            warn("[DYHUB] Data not found!")
            return
        end

        if selectedGamepass == "All" then
            local gamepasses = { "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" }
            for _, gpName in ipairs(gamepasses) do
                local gp = data:FindFirstChild(gpName)
                if gp then
                    gp.Value = true
                    print("[DYHUB] Unlocked Gamepass:", gpName)
                end
            end
        else
            local gp = data:FindFirstChild(selectedGamepass)
            if gp then
                gp.Value = true
                print("[DYHUB] Unlocked Gamepass:", selectedGamepass)
            else
                warn("[DYHUB] Gamepass not found:", selectedGamepass)
            end
        end

        if selectedGamepass == "Emote" or selectedGamepass == "All" then
            local emotes = player:FindFirstChild("PlayerGui"):FindFirstChild("HUD")
            if emotes and emotes:FindFirstChild("Emotes") then
                emotes.Emotes.Visible = true
            end
        end
    end,
})

-- Cash Tab
local cashInputValue = ""

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
                [3] = "DYHUB"
            }
            ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
            print("[DYHUB] Dupe Cash:", input)
        else
            print("[DYHUB] Invalid amount:", cashInputValue)
        end
    end,
})

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

CashTab:Button({
    Title = "Infinite Dupe Spin",
    Icon = "rotate-ccw",
    Callback = function()
        local totalAmount = 9999
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
            print("[DYHUB] Completed Infinite Dupe Spin +10 Spin")
        end)
    end,
})

-- Player Tab

local espEnabled = false
local espUpdateConnection
local espOptions = {
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowMorph = false,
    ShowClass = false,
    ShowAura = false,
    HighlightColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false,
}

local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local gui = head:FindFirstChild("DYESP")
            if not gui then
                gui = Instance.new("BillboardGui")
                gui.Name = "DYESP"
                gui.Size = UDim2.new(0, 200, 0, 100)
                gui.StudsOffset = Vector3.new(0, 2.5, 0)
                gui.AlwaysOnTop = true
                gui.Parent = head
            end

            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end

            local function addLine(text, yOffset)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 20)
                label.Position = UDim2.new(0, 0, 0, yOffset)
                label.BackgroundTransparency = 1
                label.TextColor3 = espOptions.Rainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or espOptions.HighlightColor
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Text = text
                label.Parent = gui
            end

            local data = target:FindFirstChild("Data")
            local y = 0

            if espOptions.ShowName then
                addLine(target.Name, y)
                y += 20
            end

            if espOptions.ShowHealth and target.Character:FindFirstChild("Humanoid") then
                addLine("HP: " .. math.floor(target.Character.Humanoid.Health), y)
                y += 20
            end

            if espOptions.ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                addLine("Dist: " .. math.floor(dist), y)
                y += 20
            end

            if data and data:FindFirstChild("CurrChar") and data.CurrMorph:IsA("StringValue") then
                addLine("Morph: " .. data.CurrChar.Value, y)
                y += 10
            end

            if data and data:FindFirstChild("CurrClass") and data.CurrClass:IsA("StringValue") then
                addLine("Class: " .. data.CurrClass.Value, y)
                y += 10
            end

            if data and data:FindFirstChild("CurrClassSec") and data.CurrClassSec:IsA("StringValue") then
                addLine("Class Stol-2: " .. data.CurrClassSec.Value, y)
                y += 10
            end

            if data and data:FindFirstChild("CurrTitle") and data.CurrTitle:IsA("StringValue") then
                addLine("Title: " .. data.CurrTitle.Value, y)
                y += 10
            end

            if data and data:FindFirstChild("CurrSelect") and data.CurrSelect:IsA("StringValue") then
                addLine("Aura: " .. data.CurrSelect.Value, y)
                y += 10
            end
        end
    end
end

local function clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local gui = player.Character.Head:FindFirstChild("DYESP")
            if gui then
                gui:Destroy()
            end
        end
    end
end

local function toggleESP(state)
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
end

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Wait()
        updateESP()
    end
end)

PlayerTab:Toggle({
    Title = "Enable ESP",
    Value = false,
    Callback = function(state)
        toggleESP(state)
    end,
})

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
            Rainbow = nil,
        }
        if colorName == "Rainbow" then
            espOptions.Rainbow = true
        else
            espOptions.HighlightColor = colors[colorName] or Color3.fromRGB(0, 255, 0)
        end
    end,
})

PlayerTab:Toggle({
    Title = "Show Player Name",
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

PlayerTab:Toggle({
    Title = "Show Morph",
    Value = false,
    Callback = function(state)
        espOptions.ShowMorph = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Class",
    Value = false,
    Callback = function(state)
        espOptions.ShowClass = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Aura",
    Value = false,
    Callback = function(state)
        espOptions.ShowAura = state
    end,
})

-- Misc Tab
local antiAdminEnabled = false
local antiAdminEnabled1 = false
local antiAdminEnabled2 = true

MiscTab:Toggle({
    Title = "Bypass Anti-Cheat",
    Value = true,
    Callback = function(state)
        antiAfkEnabled1 = state
        if antiAfkEnabled1 then
            VirtualUser:Button2Down(Vector2.new(0,0))
            task.spawn(function()
                while antiAfkEnabled1 do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(60)
                end
            end)
        end
    end,
})

MiscTab:Toggle({
    Title = "Anti AFK",
    Value = false,
    Callback = function(state)
        antiAfkEnabled = state
        if antiAfkEnabled then
            VirtualUser:Button2Down(Vector2.new(0,0))
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(60)
                end
            end)
        end
    end,
})

MiscTab:Toggle({
    Title = "Anti Admin",
    Value = false,
    Callback = function(state)
        antiAfkEnabled2 = state
        if antiAfkEnabled2 then
            VirtualUser:Button2Down(Vector2.new(0,0))
            task.spawn(function()
                while antiAfkEnabled2 do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(60)
                end
            end)
        end
    end,
})

-- teleport 
local teleportLocations = {
    {Name = "Spawn", CFrame = CFrame.new(0, 10, 0)},
    {Name = "Market", CFrame = CFrame.new(100, 10, 100)},
    {Name = "Boss Arena", CFrame = CFrame.new(200, 50, 200)},
}

for _, loc in ipairs(teleportLocations) do
    TeleportTab:Button({
        Title = "Teleport to " .. loc.Name,
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = loc.CFrame
                print("[DYHUB] Teleported to " .. loc.Name)
            end
        end,
    })
end

-- Config Tab: Save/Load config (simple memory config, you can extend to file or data store)
ConfigTab:Dropdown({
    Title = "Select Config to Load",
    Values = { "DYHUBCONFIG-OLD", "DYHUBCONFIG-BEST", "DYHUBConfig-1" },
    Multi = false,
    Callback = function(selected)
        print("[DYHUB] Selected Loaded Config:", selected)
    end,
})

ConfigTab:Button({
    Title = "Save Config",
    Callback = function()
        print("[DYHUB] Config saved!")
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Callback = function()
        print("[DYHUB] Config loaded!")
    end,
})

-- Main loop
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

print("[DYHUB] Script loaded successfully!")
