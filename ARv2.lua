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
--local EquipTab = Window:Tab({ Title = "Equip", Icon = "book-check" })
local GamepassTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- ======= Main =======
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
  "Hakai", "PridfulWarrior", "EarthWarrior", "GreatApe"
}

-- เก็บค่าของแต่ละ Input แยกกัน
local morphInputValue = ""
local classInputValue = ""
local auraInputValue = ""

-- Morph Input
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

-- Class Input
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
                event:FireServer("SetClassBuy", name, 0)
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

-- Aura Input
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
                event:FireServer("SetAuraBuy", name, 0)
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

-- Unlock All (Morph + Class + Aura)
MainTab:Button({
    Title = "Unlock All",
    Icon = "atom",
    Callback = function()
        for _, name in ipairs(dupeNames) do
            event:FireServer("SetMorphBuy", name, 0)
            event:FireServer("SetClassBuy", name, 0)
            event:FireServer("SetAuraBuy", name, 0)
            wait(0.05)
        end
        print("[DYHUB] All Morphs, Classes and Auras unlocked!")
    end,
})

-- ======= Gamepass =======
local selectedGamepass = "All" -- ค่าเริ่มต้น

GamepassTab:Dropdown({
    Title = "Select Gamepass",
    Values = {"All", "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin"},
    Multi = false,
    Callback = function(selected)
        selectedGamepass = selected -- เก็บตัวเลือกไว้ในตัวแปร
        print("[DYHUB] Selected Gamepass:", selectedGamepass)
    end,
})

GamepassTab:Button({
    Title = "Enter Unlock",
    Icon = "check",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local data = player:FindFirstChild("data")
        if not data then
            warn("[DYHUB] Data not found!")
            return
        end

        if selectedGamepass == "All" then
            local gamepasses = {"DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin"}
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

        -- แสดง Emotes GUI ถ้าเลือก Emote หรือ All
        if selectedGamepass == "Emote" or selectedGamepass == "All" then
            local emotes = player:FindFirstChild("PlayerGui"):FindFirstChild("HUD")
            if emotes and emotes:FindFirstChild("Emotes") then
                emotes.Emotes.Visible = true
            end
        end
    end,
})

-- ======= Cash =======
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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

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
    Rainbow = false
}

-- 💡 อัปเดต ESP Text บนหัวตัวละคร
local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local gui = head:FindFirstChild("DYESP") or Instance.new("BillboardGui", head)
            gui.Name = "DYESP"
            gui.Size = UDim2.new(0, 200, 0, 100)
            gui.StudsOffset = Vector3.new(0, 2.5, 0)
            gui.AlwaysOnTop = true

            -- ลบ Text เดิม
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end

            local function addLine(text, yOffset)
                local label = Instance.new("TextLabel", gui)
                label.Size = UDim2.new(1, 0, 0, 20)
                label.Position = UDim2.new(0, 0, 0, yOffset)
                label.BackgroundTransparency = 1
                label.TextColor3 = espOptions.Rainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or espOptions.HighlightColor
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Text = text
            end

            local data = target:FindFirstChild("data")
            local y = 0

            if espOptions.ShowName then
                addLine(target.Name, y)
                y += 20
            end

            if espOptions.ShowHealth and target.Character:FindFirstChild("Humanoid") then
                addLine("HP: "..math.floor(target.Character.Humanoid.Health), y)
                y += 20
            end

            if espOptions.ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                addLine("Dist: "..math.floor(dist), y)
                y += 20
            end

            if espOptions.ShowMorph and data and data:FindFirstChild("CurrMorph") then
                addLine("Morph: "..data.CurrMorph.Value, y)
                y += 20
            end

            if espOptions.ShowClass and data and data:FindFirstChild("CurrClass") then
                addLine("Class: "..data.CurrClass.Value, y)
                y += 20
            end

            if espOptions.ShowAura and data and data:FindFirstChild("CurrAura") then
                addLine("Aura: "..data.CurrAura.Value, y)
                y += 20
            end
        end
    end
end

-- ❌ ลบ ESP ทั้งหมด
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

-- 🔁 ฟังก์ชันเปิด/ปิด ESP
function toggleESP(state)
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

-- 🔔 เชื่อมเมื่อมีผู้เล่นใหม่
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        task.defer(function()
            player.CharacterAdded:Wait()
            updateESP()
        end)
    end
end)

----------------------------------------------------
-- 🧩 WindUI GUI: ปุ่ม ESP
----------------------------------------------------
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
        }

        if colorName == "Rainbow" then
            espOptions.Rainbow = true
        else
            espOptions.HighlightColor = colors[colorName] or Color3.fromRGB(0, 255, 0)
        end
    end,
})

PlayerTab:Toggle({ Title = "Show Name", Value = false, Callback = function(state) espOptions.ShowName = state end })
PlayerTab:Toggle({ Title = "Show Health", Value = false, Callback = function(state) espOptions.ShowHealth = state end })
PlayerTab:Toggle({ Title = "Show Distance", Value = false, Callback = function(state) espOptions.ShowDistance = state end })
PlayerTab:Toggle({ Title = "Show Morph", Value = false, Callback = function(state) espOptions.ShowMorph = state end })
PlayerTab:Toggle({ Title = "Show Class", Value = false, Callback = function(state) espOptions.ShowClass = state end })
PlayerTab:Toggle({ Title = "Show Aura", Value = false, Callback = function(state) espOptions.ShowAura = state end })

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
        print("[DYHUB] Anti Admin" .. (state and "Enabled" or "Disabled"))
        print("[DYHUB] Anti Moderator" .. (state and "Enabled" or "Disabled"))
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
