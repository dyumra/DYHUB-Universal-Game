--[[

    💻 Game: 4KING HIGHCLASS
    🎉 Version: 2.50

--]]

--[[
local allowedUsersUrl = "https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/4KING-PREMIUM"
local allowedUsers = {}
local success, result = pcall(function()
    local code = game:HttpGet(allowedUsersUrl)
    local func = loadstring(code)
    if func then
        return func()
    else
        error("Cannot load function from code")
    end
end)

if success and type(result) == "table" then
    allowedUsers = result
    print("[System] Loaded allowed users successfully")
else
    warn("[System] Failed to load allowed users: ", result)
    allowedUsers = {}
end

-- Check LocalPlayer Permission
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not allowedUsers[LocalPlayer.Name] then
    local kickMessage = "[Warning] โปรดซื้อสคริปก่อนใช้งาน ราคา 150 บาท\n[Access Denied] คุณไม่มีสิทธิ์ใช้สคริปต์นี้: " .. LocalPlayer.Name
    warn(kickMessage)
    LocalPlayer:Kick(kickMessage)
    return
end
--]]

local RunService = game:GetService("RunService")

-- รายชื่อปลอมแบบ EN+TH
local fakeNamesEN = {
    "CaptainObvious","SpamMaster3000","KeyboardWarrior","PixelPotato",
    "SirLagsALot","N00bSlayer","Lagzilla","ButtonMasher",
    "CheeseWizard","EpicDuck","Toastinator","BaconSniper",
    "GlitchGoblin","PastaNinja","CrazyUnicorn"
}

local fakeNamesTH = {
    "สมศักดิ์","มะพร้าวแสบ","ข้าวเหนียวจอมซ่า","ไก่ทอดตัวแม่",
    "บักโจ๊ก","เจ้าเต้าหู้","หมูปิ้งนักสู้","ปิงปองบ้าพลัง",
    "ไข่เจียวสุดติ่ง","ต้มยำกุ้งเทพ","หมึกย่างสายฟ้า","น้องส้มโอ",
    "ลิงน้อยมหัศจรรย์","ผัดไทยโหด","เต่าเร็วจี๋"
}

local function getRandomFakeName()
    if math.random() < 0.5 then
        return fakeNamesEN[math.random(#fakeNamesEN)]
    else
        return fakeNamesTH[math.random(#fakeNamesTH)]
    end
end

-- ฟังก์ชันปรับ Nametag & Rainbow Text
local function applyEffects(character)
    local nametag = character:FindFirstChild("Nametag")
    if not nametag then return end
    local playerNameLabel = nametag:FindFirstChild("PlayerName")
    if not playerNameLabel then return end

    local icons = nametag:FindFirstChild("Icons")
    if icons then
        if icons:FindFirstChild("Admin") then icons.Admin.Visible = true end
        if icons:FindFirstChild("Owner") then icons.Owner.Visible = true end
        if icons:FindFirstChild("Premium") then icons.Premium.Visible = true end
    end
end

    local messages = {
        "สคริปโตครดีซื้อที่ YJSCRIPT",
        "" -- ใส่ชื่อปลอมใน loop
    }

    local msgIndex = 1
    playerNameLabel.Text = messages[msgIndex]

    task.spawn(function()
        while character.Parent do
            msgIndex = (msgIndex % #messages) + 1
            if msgIndex == 2 then
                playerNameLabel.Text = "@" .. getRandomFakeName() .. " (YJSCRIPT)"
            else
                playerNameLabel.Text = messages[msgIndex]
            end
            task.wait(2)
        end
    end)

    local rainbowHue = 0
    RunService.RenderStepped:Connect(function(deltaTime)
        rainbowHue = (rainbowHue + deltaTime * 0.2) % 1
        playerNameLabel.TextColor3 = Color3.fromHSV(rainbowHue,1,1)
    end)
end

if LocalPlayer.Character then applyEffects(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(applyEffects)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiveItemAllEvent = ReplicatedStorage:WaitForChild("GiveItemAll")
local ReviveEvent = ReplicatedStorage:WaitForChild("ReviveSystem"):WaitForChild("Event")

-- Variables
local autoRespawn = false
local autoArmor = false
local autoMed = false
local autoClothes = false
local autoShootAll = false

local itemName = ""
local itemAmount = 0

local hitboxEnabled = false
local headSize = 1
local characterAddedConnections = {}

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
assert(WindUI, "[Error] Failed to load WindUI")

-- Confirmation Popup
local Confirmed = false
WindUI:Popup({
    Title = "YJSCRIPT Loaded! 4KING HIGHCLASS",
    Icon = "user",
    IconThemed = true,
    Content = "Script By YJSCRIPT",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Variant = "Primary", Callback = function() Confirmed = true end }
    }
})
repeat task.wait() until Confirmed

-- Create Main Window
local Window = WindUI:CreateWindow({
    Title = "4KING HIGHCLASS",
    IconThemed = true,
    Icon = "user",
    Author = "By YJSCRIPT",
    Size = UDim2.fromOffset(500, 300),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "OPEN SCRIPT",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local FeatureTab = Window:Tab({ Title = "Feature", Icon = "star" })
local AutoTab = Window:Tab({ Title = "Auto", Icon = "infinity" })
local FunTab = Window:Tab({ Title = "Fun", Icon = "crown" })
local HitboxTab = Window:Tab({ Title = "Hitbox", Icon = "sword" })

Window:SelectTab(1)

-- Utility Functions
local function GiveItem(name, amount)
    if typeof(name) == "string" and typeof(amount) == "number" and amount > 0 then
        GiveItemAllEvent:FireServer(name, amount)
        print(("[GiveAll] Gave item: %d x %s"):format(amount, name))
    else
        warn("[GiveAll] Invalid name or amount")
    end
end

local function ResizeHeads()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Head") then
                char.Head.Size = Vector3.new(headSize, headSize, headSize)
                local mesh = char.Head:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    mesh.Scale = Vector3.new(1,1,1) * headSize
                end
            end
        end
    end
end

local function ResetHeads()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Head") then
                char.Head.Size = Vector3.new(2,1,1)
                local mesh = char.Head:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    mesh.Scale = Vector3.new(1,1,1)
                end
            end
        end
    end
end

local function DisconnectAllConnections()
    for _, conn in pairs(characterAddedConnections) do
        conn:Disconnect()
    end
    characterAddedConnections = {}
end

local function ConnectCharacterAddedEvents()
    for _, player in pairs(Players:GetPlayers()) do
        local conn = player.CharacterAdded:Connect(function(char)
            if hitboxEnabled and player ~= LocalPlayer then
                local head = char:WaitForChild("Head")
                head.Size = Vector3.new(headSize, headSize, headSize)
                local mesh = head:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    mesh.Scale = Vector3.new(1,1,1) * headSize
                end
            end
        end)
        table.insert(characterAddedConnections, conn)
    end

    local playerAddedConn
    playerAddedConn = Players.PlayerAdded:Connect(function(player)
        local conn = player.CharacterAdded:Connect(function(char)
            if hitboxEnabled and player ~= LocalPlayer then
                local head = char:WaitForChild("Head")
                head.Size = Vector3.new(headSize, headSize, headSize)
                local mesh = head:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    mesh.Scale = Vector3.new(1,1,1) * headSize
                end
            end
        end)
        table.insert(characterAddedConnections, conn)
    end)
    table.insert(characterAddedConnections, playerAddedConn)
end

MainTab:Section({ Title = "Dupe Item", Icon = "apple" })

-- MainTab UI
MainTab:Input({
    Title = "Item Name",
    Placeholder = "Enter item name",
    Callback = function(text) itemName = text end,
})

MainTab:Input({
    Title = "Amount",
    Placeholder = "Enter amount",
    Callback = function(text) itemAmount = tonumber(text) or 0 end,
})

MainTab:Button({
    Title = "Give Item",
    Icon = "gift",
    Callback = function()
        if itemName ~= "" and itemAmount > 0 then
            GiveItem(itemName, itemAmount)
        else
            warn("[DUPE] Invalid name or amount")
        end
    end,
})

-- FeatureTab UI
FeatureTab:Section({ Title = "Feature & Misc", Icon = "star" })

-- Manual Respawn
FeatureTab:Button({
    Title = "Respawn (Manual)",
    Icon = "gift",
    Callback = function()
        ReviveEvent:FireServer("Respawn", LocalPlayer)
        print("[Respawn] Manual respawn executed")
    end,
})

AutoTab:Section({ Title = "Auto & Function", Icon = "repeat" })

-- Auto Respawn
AutoTab:Toggle({
    Title = "Auto Respawn (HP < 5)",
    Default = false,
    Callback = function(state)
        autoRespawn = state
        if autoRespawn then
            print("[AutoRespawn] Enabled")
            spawn(function()
                while autoRespawn do
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health < 5 then
                        ReviveEvent:FireServer("Respawn", LocalPlayer)
                        print("[AutoRespawn] Respawned because HP < 5")
                        task.wait(3)
                    end
                    task.wait(0.5)
                end
            end)
        else
            print("[AutoRespawn] Disabled")
        end
    end,
})

-- Auto Armor
AutoTab:Toggle({
    Title = "Auto Armor",
    Default = false,
    Callback = function(state)
        autoArmor = state
        if autoArmor then
            print("[AutoArmor] Enabled")
            spawn(function()
                while autoArmor do
                    local args = { "Use", "Armor", 1 }
                    ReplicatedStorage:WaitForChild("Inventory_Remotes"):WaitForChild("Event"):FireServer(unpack(args))
                    task.wait(2.5)
                end
            end)
        else
            print("[AutoArmor] Disabled")
        end
    end,
})

-- Auto Medicine
AutoTab:Toggle({
    Title = "Auto Medicine (HP < 90)",
    Default = false,
    Callback = function(state)
        autoMed = state
        if autoMed then
            print("[AutoMed] Enabled")
            spawn(function()
                while autoMed do
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health < 90 then
                        local args = { "Use", "MedicineV", 1 }
                        ReplicatedStorage:WaitForChild("Inventory_Remotes"):WaitForChild("Event"):FireServer(unpack(args))
                    end
                    task.wait(1)
                end
            end)
        else
            print("[AutoMed] Disabled")
        end
    end,
})

-- Auto Clothes
AutoTab:Toggle({
    Title = "Auto Clothes on Respawn",
    Default = false,
    Callback = function(state)
        autoClothes = state
        if autoClothes then
            print("[AutoClothes] Enabled")
            LocalPlayer.CharacterAdded:Connect(function()
                if autoClothes then
                    task.wait(1)
                    local args = { "Use", "Clothes", 1 }
                    ReplicatedStorage:WaitForChild("Inventory_Remotes"):WaitForChild("Event"):FireServer(unpack(args))
                end
            end)
        else
            print("[AutoClothes] Disabled")
        end
    end,
})

-- Combat Section
FunTab:Section({ Title = "Dupe Item", Icon = "wrench" })

-- Auto Shoot All
FunTab:Toggle({
    Title = "Auto Ragdoll All",
    Default = false,
    Callback = function(state)
        autoShootAll = state
        if autoShootAll then
            print("[Ragdoll-All] Enabled")
            spawn(function()
                while autoShootAll do
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local pos = player.Character.HumanoidRootPart.Position
                            local args = { "Fire", pos, workspace:WaitForChild("Garage"):WaitForChild("Part") }
                            ReplicatedStorage:WaitForChild("DeagleFunction"):InvokeServer(unpack(args))
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            print("[Ragdoll-All] Disabled")
        end
    end,
})

HitboxTab:Section({ Title = "Hitbox Options", Icon = "package" })

-- Hitbox Tab
HitboxTab:Slider({
    Title = "Head Size",
    Value = { Min = 1, Max = 50, Default = 1 },
    Callback = function(value)
        headSize = value
        if hitboxEnabled then
            ResizeHeads()
            print(("[Hitbox] Head size set to: %d"):format(headSize))
        end
    end,
})

HitboxTab:Toggle({
    Title = "Enable Hitbox",
    Icon = "package",
    Default = false,
    Callback = function(state)
        hitboxEnabled = state
        if hitboxEnabled then
            ResizeHeads()
            ConnectCharacterAddedEvents()
            print("[Hitbox] Enabled")
        else
            ResetHeads()
            DisconnectAllConnections()
            print("[Hitbox] Disabled and reset")
        end
    end,
})

print("[YJSCRIPT] 4KING HIGHCLASS loaded successfully")
