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
    Title = "DYHUB - Anime Rails @ Lobby (Final Version)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local CashTab = Window:Tab({ Title = "Cash", Icon = "circle-dollar-sign" })
--local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local PartyTab = Window:Tab({ Title = "Auto Join", Icon = "handshake" })
--local SpinTab = Window:Tab({ Title = "Spin", Icon = "ferris-wheel" })
local GUI = Window:Tab({ Title = "Equip", Icon = "flame" })
local GamepassTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "cog" })

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
                y += 20
            end

            if data and data:FindFirstChild("CurrClass") and data.CurrClass:IsA("StringValue") then
                addLine("Class: " .. data.CurrClass.Value, y)
                y += 20
            end

            if data and data:FindFirstChild("CurrClassSec") and data.CurrClassSec:IsA("StringValue") then
                addLine("Class Stol-2: " .. data.CurrClassSec.Value, y)
                y += 20
            end

            if data and data:FindFirstChild("CurrTitle") and data.CurrTitle:IsA("StringValue") then
                addLine("Title: " .. data.CurrTitle.Value, y)
                y += 20
            end

            if data and data:FindFirstChild("CurrSelect") and data.CurrSelect:IsA("StringValue") then
                addLine("Aura: " .. data.CurrSelect.Value, y)
                y += 20
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

RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Misc Tab
local antiAfkEnabled = false
local antiAdminEnabled = false
local fakeBypassEnabled = false

-- 🌌 Bypass Anti-Cheat (ปลอม)
MiscTab:Toggle({
    Title = "Bypass Anti-Cheat (By rhy)",
    Value = true,
    Callback = function(state)
        fakeBypassEnabled = state
        if fakeBypassEnabled then
            print("[DYHUB] Bypassing Anti-Cheat... ✅(DYHUB'S TEAM)")
            Notify({
                Title = "Bypass Enabled",
                Description = "Finished: bypass enabled. Just for looks 😉",
                Duration = 3
            })
        else
            print("[DYHUB] Bypass Anti-Cheat disabled.")
        end
    end,
})

-- 💤 Anti AFK
MiscTab:Toggle({
    Title = "Anti AFK",
    Value = false,
    Callback = function(state)
        antiAfkEnabled = state
        if antiAfkEnabled then
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(60)
                end
            end)
            print("[DYHUB] Anti AFK enabled")
        else
            print("[DYHUB] Anti AFK disabled")
        end
    end,
})

-- 👮 Anti Admin (Auto ServerHop ถ้าเจอ Roblox123)
MiscTab:Toggle({
    Title = "Anti Admin (Auto Hop)",
    Value = false,
    Callback = function(state)
        antiAdminEnabled = state
        if antiAdminEnabled then
            print("[DYHUB] Anti Admin enabled - Scanning players... (every: 15 sec)")
            task.spawn(function()
                while antiAdminEnabled do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Name == "Roblox123" then
                            print("[DYHUB] Detected admin: Roblox123, hopping server...")
                            Notify({
                                Title = "Anti Admin",
                                Description = "Detected admin 'Roblox123'. Hopping server...",
                                Duration = 3
                            })
                            task.wait(1)
                            TeleportService:Teleport(game.PlaceId, LocalPlayer)
                            return
                        end
                    end
                    task.wait(15) -- ตรวจสอบทุก 5 วินาที
                end
            end)
        else
            print("[DYHUB] Anti Admin disabled")
        end
    end,
})

local indexList = {
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

-- Dropdown สำหรับดู index ทั้งหมด
GUI:Dropdown({
    Title = "Index List",
    Values = indexList,
    Multi = false,
    Callback = function(value)
        print("[DYHUB] Selected index:", value)
    end,
})

-- ฟังก์ชันกลางสำหรับปุ่ม FireServer
local function fireChangeValue(key, value)
    local args = { key, value }
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ChangeValue"):FireServer(unpack(args))
    print("[DYHUB] Sent", key, value)
end

-- Input: SetCurrChar
GUI:Input({
    Title = "Set Character",
    Placeholder = "Type character name...",
    Callback = function(value)
        fireChangeValue("SetCurrChar", value)
    end,
})

-- Input: SetCurClass
GUI:Input({
    Title = "Set Class (Slot 1)",
    Placeholder = "Type class name...",
    Callback = function(value)
        fireChangeValue("SetCurClass", value)
    end,
})

-- Input: SetCurClass2 (Gamepass Slot 2)
GUI:Input({
    Title = "Set Class (Slot 2)",
    Placeholder = "Type class2 name...",
    Callback = function(value)
        fireChangeValue("SetCurClass2", value)
    end,
})

-- Input: SetCurAura
GUI:Input({
    Title = "Set Aura",
    Placeholder = "Type aura name...",
    Callback = function(value)
        fireChangeValue("SetCurAura", value)
    end,
})

-- auto join
-- ตัวแปรเริ่มต้น
local maxPlayers = 1
local allowFriend = true
local nightmareMode = false

-- Input สำหรับ Max Players
PartyTab:Input({
    Title = "Max Players",
    Placeholder = "Enter 1 ~ 8",
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 1 and num <= 8 then
            maxPlayers = num
            print("[DYHUB] Max Players set to:", maxPlayers)
        else
            warn("[DYHUB] Invalid max players input, must be between 1 and 8")
            -- หาก WindUI มี notify: WindUI:Notify("Invalid input", "Please enter a number from 1 to 8")
        end
    end,
})

-- Toggle สำหรับ Allow Friend Join
PartyTab:Toggle({
    Title = "Allow Friend Join",
    Default = true,
    Callback = function(state)
        allowFriend = state
        print("[DYHUB] Allow Friend Join:", state)
    end,
})

-- Toggle สำหรับ Nightmare Mode
PartyTab:Toggle({
    Title = "Nightmare Mode",
    Default = false,
    Callback = function(state)
        nightmareMode = state
        print("[DYHUB] Nightmare Mode:", state)
    end,
})

-- ปุ่ม Auto Join
PartyTab:Button({
    Title = "Auto Join",
    Callback = function()
        local args = {
            allowFriend,
            maxPlayers,
            nightmareMode
        }
        game:GetService("ReplicatedStorage"):WaitForChild("ApplyTP"):FireServer(unpack(args))
        print("[DYHUB] Auto Join sent:", allowFriend, maxPlayers, nightmareMode)
    end,
})

-- teleport 
TeleportTab:Button({
    Title = "Teleport to Aura Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-5.7536335, 188.169067, -131.537506, -0.10051205, 8.16659522e-08, 0.99493587, -3.84045897e-08, 1, -8.59613962e-08, -0.99493587, -4.68502606e-08, -0.10051205)
            print("[DYHUB] Teleported to Aura Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Class Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-3.96356249, 188.169052, -99.7206345, 0.217696652, 4.36522107e-08, 0.976016462, 1.9954145e-08, 1, -4.9175565e-08, -0.976016462, 3.0180928e-08, 0.217696652)
            print("[DYHUB] Teleported to Class Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Morph Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(8.6613245, 188.169067, -97.1435318, 0.779245794, -3.30689467e-08, -0.626718462, -1.24927118e-08, 1, -6.82983554e-08, 0.626718462, 6.10506206e-08, 0.779245794)
            print("[DYHUB] Teleported to Morph Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Npc Spin",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(8.35407925, 188.169067, -132.966141, -0.510008216, -1.13285189e-07, -0.86016953, 1.64339864e-09, 1, -1.32675396e-07, 0.86016953, -6.90791424e-08, -0.510008216)
            print("[DYHUB] Teleported to Spin")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Title Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-14.3617506, 188.169052, -27.776825, -0.999740958, 5.87875304e-09, -0.0227609444, 5.73739145e-09, 1, 6.27602681e-09, 0.0227609444, 6.14381257e-09, -0.999740958)
            print("[DYHUB] Teleported to Title Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Tutorial",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(1.71302092, 188.169052, -60.757412, -0.999253094, 9.66736309e-08, 0.0386431366, 9.36806828e-08, 1, -7.92618096e-08, -0.0386431366, -7.55824914e-08, -0.999253094)
            print("[DYHUB] Teleported to Tutorial")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to AFK World",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(18.6007061, 188.169052, -24.452446, -0.940061092, -3.15264685e-08, 0.34100607, -2.33052724e-08, 1, 2.82050365e-08, -0.34100607, 1.85672189e-08, -0.940061092)
            print("[DYHUB] Teleported to AFK World")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Battle Royale",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0.462113261, 188.169067, -142.787186, 0.987219155, 5.76863819e-08, -0.159368694, -5.34411058e-08, 1, 3.09239034e-08, 0.159368694, -2.20118288e-08, 0.987219155)
            print("[DYHUB] Teleported to Battle Royale")
        end
    end,
})

-- Config Tab
ConfigTab:Button({
    Title = "Save Config",
    Callback = function()
        Notify({
            Title = "Coming Soon!",
            Description = "Config Settings feature is not yet available.",
            Duration = 3, -- วินาที
        })
        print("[DYHUB] Config Settings, Coming Soon")
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Callback = function()
        Notify({
            Title = "Coming Soon!",
            Description = "Config Settings feature is not yet available.",
            Duration = 3, -- วินาที
        })
        print("[DYHUB] Config Settings, Coming Soon")
    end,
})

print("[DYHUB] Script loaded successfully!")
