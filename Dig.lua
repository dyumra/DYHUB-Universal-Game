if game.PlaceId ~= 126244816328678 then
    return
end

-- =========================
local version = "4.6.4"
-- =========================

repeat task.wait() until game:IsLoaded()

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

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bersihkan kalau sudah ada sebelumnya
if playerGui:FindFirstChild("DYHUB") then
    playerGui.DYHUB:Destroy()
end

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DYHUB"
screenGui.Parent = playerGui

-- Buat TextLabel
local label = Instance.new("TextLabel")
label.Parent = screenGui
label.Size = UDim2.new(1, 0, 0.4, 0) -- besar
label.BackgroundTransparency = 1
label.Text = "" -- awal kosong
label.TextColor3 = Color3.fromRGB(255, 0, 0) -- 馃挍 kuning
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextStrokeTransparency = 0.8
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.Position = UDim2.new(0.5, 0, 1.2, 0) -- mulai di bawah layar
label.TextTransparency = 0

-- BlurEffect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game.Lighting

-- TweenService
local TweenService = game:GetService("TweenService")

-- 馃攰 Helper untuk mainkan suara
local function playSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://157636218" -- ID sound terbaru
    s.Volume = 1
    s.Parent = workspace
    s:Play()
    game.Debris:AddItem(s, 3) -- auto hilang
end

-- Tween naik huruf H ke tengah鈥揳tas
label.Text = "D"
local tweenUp = TweenService:Create(label, TweenInfo.new(
    1.2,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
), {
    Position = UDim2.new(0.5, 0, 0.4, 0) -- posisi lebih tinggi
})

-- Tween blur masuk
local tweenBlurIn = TweenService:Create(blur, TweenInfo.new(
    0.5,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
), {
    Size = 30
})

-- Tween blur keluar
local tweenBlurOut = TweenService:Create(blur, TweenInfo.new(
    0.5,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.In
), {
    Size = 0
})

-- Tween fade text keluar
local tweenFade = TweenService:Create(label, TweenInfo.new(
    1,
    Enum.EasingStyle.Linear
), {
    TextTransparency = 1,
    TextStrokeTransparency = 1
})

-- Jalankan animasi H naik
playSound()
tweenBlurIn:Play()
tweenUp:Play()

tweenUp.Completed:Connect(function()
    -- Setelah H sampai di atas, ketik huruf虏 berikut
    local fullText = "DYHUB"
    for i = 3, #fullText do
        label.Text = string.sub(fullText, 1, i)
        playSound()
        task.wait(0.08)
    end

    -- Tunggu 1 detik, lalu hilangkan
    task.wait(1)
    tweenFade:Play()
    tweenBlurOut:Play()
    tweenFade.Completed:Connect(function()
        blur:Destroy()
        screenGui:Destroy()
    end)
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "DIG | Premium Version",
    Folder = "DYHUB_DIG",
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
    Window:Tag({
        Title = version,
        Color = Color3.fromHex("#30ff6a")
    })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- 鉁� Tab dan UI
-- 馃寪 WindUI Tabs
local Tabs = {
    InfoTab = Window:Tab({ Title = "Information", Icon = "info" }),
    MainDivider = Window:Divider(),
    Main = Window:Tab({ Title = "Main", Icon = "rocket"  }),
    Cars = Window:Tab({ Title = "Cars", Icon = "car"  }),
    Shop = Window:Tab({ Title = "Shop", Icon = "store"  }),
    Sell = Window:Tab({ Title = "Inventory", Icon = "shopping-cart"  }),
    Setting = Window:Tab({ Title = "Misc/Player", Icon = "settings"  }),
    Magnets = Window:Tab({ Title = "Magnets", Icon = "magnet"  }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "map-pin"  }),
}

Window:SelectTab(1)

Tabs.Main:Section({ Title = "Auto Dig" })

-- Auto farm
-- 馃摝 Roblox Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Holes = Workspace:WaitForChild("World"):WaitForChild("Zones"):WaitForChild("_NoDig")

-- 馃攣 Shared State
local ENABLED = false
local digCount = 0
local connections = {}

-- 馃敡 Get tool
local function getTool()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
end

-- 鉂� Destroy hitbox
local function destroyHitbox()
    local hitbox = Holes:FindFirstChild(LocalPlayer.Name .. "_Crater_Hitbox")
    if hitbox then hitbox:Destroy() end
end

-- 馃獡 Activate shovel tool
local function activateTool()
    local tool = getTool()
    if tool then
        destroyHitbox()
        tool:Activate()
    end
end

-- 馃攣 Setup Auto Dig Events
local function setupEvents()
    table.insert(connections, LocalPlayer.PlayerGui.ChildAdded:Connect(function(v)
        if v.Name == "Dig" then
            local strong_bar = v.Safezone.Holder:FindFirstChild("Area_Strong")
            local player_bar = v.Safezone.Holder:FindFirstChild("PlayerBar")
            if strong_bar and player_bar then
                table.insert(connections, player_bar:GetPropertyChangedSignal("Position"):Connect(function()
                    if ENABLED then
                        player_bar.Position = strong_bar.Position
                        digCount += 1
                        activateTool()
                    end
                end))
            end
        end
    end))

    table.insert(connections, LocalPlayer:GetAttributeChangedSignal("IsDigging"):Connect(function()
        if ENABLED and not LocalPlayer:GetAttribute("IsDigging") then
            activateTool()
        end
    end))

    table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(function(v)
            if ENABLED and v:IsA("Tool") and v.Name:lower():find("shovel") then
                task.wait(0.1)
                activateTool()
            end
        end)
    end))

    if LocalPlayer.Character then
        table.insert(connections, LocalPlayer.Character.ChildAdded:Connect(function(v)
            if ENABLED and v:IsA("Tool") and v.Name:lower():find("shovel") then
                task.wait(0.1)
                activateTool()
            end
        end))
    end

    table.insert(connections, RunService.Heartbeat:Connect(function()
        if ENABLED and digCount >= 3 then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(2), 0)
                activateTool()
            end
        end
    end))
end

-- 馃攲 Cleanup connections
local function cleanupEvents()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    connections = {}
end

-- 馃 Auto Dig (Fast)
Tabs.Main:Toggle({
    Title = "Auto Dig (Fast)",
    Desc = "Automatically performs a digging minigame quickly",
    Value = false,
    Callback = function(Value)
        ENABLED = Value
        if Value then
            digCount = 0
            setupEvents()
        else
            cleanupEvents()
        end
    end
})

-- 馃З Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- 馃З Variables
local local_player = Players.LocalPlayer
local holes = Workspace:WaitForChild("World"):WaitForChild("Zones"):WaitForChild("_NoDig")

-- 馃實 Global toggle
getgenv().enabled = false

-- 馃О Get tool
local function get_tool()
    return local_player.Character and local_player.Character:FindFirstChildOfClass("Tool")
end

-- 馃П Destroy hitbox & activate
local function destroy_hitbox_and_activate()
    local hitbox = holes:FindFirstChild(local_player.Name .. "_Crater_Hitbox")
    if hitbox then hitbox:Destroy() end
    local tool = get_tool()
    if tool then tool:Activate() end
end

-- 馃 Listener: saat tool ditambahkan ke karakter
local_player.Character.ChildAdded:Connect(function(v)
    if getgenv().enabled and v:IsA("Tool") and v.Name:lower():find("shovel") then
        task.wait(1)
        destroy_hitbox_and_activate()
    end
end)

-- 馃 Listener: saat GUI "Dig" muncul
local_player.PlayerGui.ChildAdded:Connect(function(v)
    if getgenv().enabled and v.Name == "Dig" then
        local safezone = v:FindFirstChild("Safezone")
        if not safezone then return end

        local holder = safezone:FindFirstChild("Holder")
        local strong_bar = holder and holder:FindFirstChild("Area_Strong")
        local player_bar = holder and holder:FindFirstChild("PlayerBar")
        if not (strong_bar and player_bar) then return end

        player_bar:GetPropertyChangedSignal("Position"):Connect(function()
            if not getgenv().enabled then return end
            if math.abs(player_bar.Position.X.Scale - strong_bar.Position.X.Scale) <= 0.04 then
                local tool = get_tool()
                if tool then
                    tool:Activate()
                    task.wait()
                end
            end
        end)
    end
end)

-- 馃 Listener: IsDigging attribute
local_player:GetAttributeChangedSignal("IsDigging"):Connect(function()
    if not getgenv().enabled then return end
    if not local_player:GetAttribute("IsDigging") then
        destroy_hitbox_and_activate()
    end
end)

-- 鉁� Toggle UI (WindUI Style)
Tabs.Main:Toggle({
    Title = "Auto Dig (Slow)",
    Desc = "Automatically performs a slow digging minigame",
    Value = false,
    Callback = function(Value)
        getgenv().enabled = Value
    end
})

Tabs.Main:Section({ Title = "Dig Setting" })

-- 馃洜锔� Shovel Names
local shovelNames = {
    "Wooden Shovel", "Bejeweled Shovel", "Training Shovel", "Toy Shovel",
    "Copper Shovel", "Rock Shovel", "Lucky Shovel", "Ruby Shovel",
    "Abyssal Shovel", "Bell Shovel", "Magnet Shovel", "Jam Shovel",
    "Candlelight Shovel", "Spore Spade", "Slayers Shovel", "Arachnid Shovel",
    "Shortcake Shovel", "Pizza Roller", "Rock Splitter", "Archaic Shovel",
    "Frigid Shovel", "Venomous Shovel", "Gold Digger", "Obsidian Shovel",
    "Prismatic Shovel", "Beast Slayer", "Solstice Shovel", "Glinted Shovel",
    "Draconic Shovel", "Monstrous Shovel", "Starfire Shovel"
}

-- 馃О Equip shovel
local function equipAnyShovel()
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _, name in ipairs(shovelNames) do
                if tool.Name == name then
                    Remotes:WaitForChild("Backpack_Equip"):FireServer(tool)
                    return
                end
            end
        end
    end
end

-- 鉂� Unequip tool
local function unequip()
    Remotes:WaitForChild("Backpack_Equip"):FireServer(nil)
end

-- 鈾伙笍 Auto Equip Toggle
local backpackConn
Tabs.Main:Toggle({
    Title = "Auto Equip Shovel",
    Value = false,
    Desc = "Automatically equips any shovel from your backpack if available",
    Callback = function(state)
        ENABLED = state

        if ENABLED then
            equipAnyShovel()

            backpackConn = Backpack.ChildAdded:Connect(function(child)
                if ENABLED then
                    task.wait(0.1)
                    equipAnyShovel()
                end
            end)

            WindUI:Notify({
                Title = "Auto Equip",
                Content = "鉁� Auto Equip Shovel Enabled",
                Duration = 0
            })
        else
            unequip()

            if backpackConn then
                backpackConn:Disconnect()
                backpackConn = nil
            end

            WindUI:Notify({
                Title = "Auto Equip",
                Content = "鉂� Auto Equip Shovel Disabled",
                Duration = 0
            })
        end
    end
})

Tabs.Cars:Section({ Title = "Spawn Cars" })

-- Ini mechanic
-- 馃煢 Service & Remote
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local VehicleSpawn = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("Vehicle_Spawn")
local AvaRoot = workspace:WaitForChild("World"):WaitForChild("NPCs"):WaitForChild("Ava Carter"):WaitForChild("HumanoidRootPart")

-- 馃煢 Daftar nama mobil
local vehicleList = {
    "ATV", "Golf Cart", "Koi Truck", "Commander", "Silver",
    "Pulse", "Rumbler", "Tracer", "DMW M3", "Elite 6x6",
    "Forklift", "The Ox", "Roadster RS", "Tornado", "McBruce 700", "Monster Silver"
}

-- 馃煢 Variabel pilihan mobil
local selectedVehicle = vehicleList[1] -- default pilihan pertama

-- 馃煢 Dropdown untuk pilih mobil
Tabs.Cars:Dropdown({
    Title = "Select Cars",
    Values = vehicleList,
    Multi = false,
    Default = selectedVehicle,
    Callback = function(v)
        selectedVehicle = v
    end
})

-- 馃煢 Button untuk spawn
Tabs.Cars:Button({
    Title = "Spawn Cars",
    Desc = "Spawn selected vehicle near Ava Carter",
    Callback = function()
        if VehicleSpawn then
            VehicleSpawn:FireServer(selectedVehicle, AvaRoot, {})
            WindUI:Notify({
                Title = "Spawn Vehicle",
                Content = "鉁� Spawned: " .. selectedVehicle,
                Duration = 0
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Error dev Fix",
                Duration = 3
            })
        end
    end
})



-- Ini Shop
Tabs.Shop:Section({ Title = "Shovel" })

-- 馃摝 Services
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 馃摝 Noclip handler
local noclipConn
local function setNoclip(state)
    if state then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(11)
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end

-- 馃摝 Teleport function with noclip
local function tpWithNoclip(x, y, z, name)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        setNoclip(true)
        hrp.CFrame = CFrame.new(x, y, z)
        WindUI:Notify({
            Title = "Teleport",
            Content = "鉁� Teleported to: " .. name,
            Duration = 0
        })
        task.delay(0.5, function()
            setNoclip(false)
        end)
    end
end

-- 馃摝 Teleport locations
local teleports = {
    {"Bejeweled Shovel", 31.2093, 3.0318, 39.8111},
    {"Training Shovel", 2121.1235, 112.5746, -298.7560},
    {"Toy Shovel", 2119.4553, 113.6495, -298.0141},
    {"Copper Shovel", 15.2426, 61.0899, 4.8759},
    {"Rock Shovel", 2112.3464, 112.6290, -294.7606},
    {"Lucky Shovel", 2111.1553, 113.5927, -294.1081},
    {"Ruby Shovel", 1327.8562, 81.1430, 542.9059},
    {"Bell Shovel", 1329.5909, 83.6888, 541.6209},
    {"Magnet Shovel", 2853.4087, -360.5666, -883.8994},
    {"Jam Shovel", 3522.3616, 84.9355, 1528.2647},
    {"Candlelight Shovel", 17.4070, 3.7727, 146.4270},
    {"Spore Shovel", 3987.8251, 227.6757, -141.8380},
    {"Slayers Shovel", 2516.5246, 89.4888, 1301.1907},
    {"Arachnid Shovel", -822.2592, 17.3944, 1260.7221},
    {"Shortcake Shovel", 484.3059, 5.5491, -284.0187},
    {"Rock Splitter", 134.4634, 5.6453, -45.0966},
    {"Archaic Shovel", -6108.1030, 119.4773, -1907.2861},
    {"Frigid Shovel", 6523.1782, 2612.3432, -2949.0361},
    {"Venomous Shovel", 16.9659, 5.5344, 32.9641},
    {"Gold Digger", 62.6586, 5.3908, 51.6359},
    {"Obsidian Shovel", -8022.6240, 342.8148, -1791.4763},
    {"Prismatic Shovel", 5131.5590, 1113.0532, -2105.3071},
    {"Beast Slayer", 128.5010, 7.1945, 19.1139},
    {"Solstice Shovel", 5567.9575, -394.3601, -1912.5024},
    {"Glinted Shovel", -6177.6743, 1630.6092, -1842.7865},
    {"Draconic Shovel", -8571.2793, 391.2796, -2133.6345},
    {"Starline Shovel", -2.5368, -68.4143, 1.2173}
}

-- 馃摝 Store selected location
local selectedTeleport = teleports[1]

-- 馃Л Dropdown menu
Tabs.Shop:Dropdown({
    Title = "Select Shovel Location",
    Values = (function()
        local names = {}
        for _, entry in ipairs(teleports) do
            table.insert(names, entry[1])
        end
        return names
    end)(),
    Multi = false,
    Default = 1,
    Callback = function(selected)
        for _, entry in ipairs(teleports) do
            if entry[1] == selected then
                selectedTeleport = entry
                break
            end
        end
    end
})

-- 馃敇 Teleport Button
Tabs.Shop:Button({
    Title = "Teleport Now",
    Desc = "Safely teleport to the selected shovel",
    Callback = function()
        if selectedTeleport then
            tpWithNoclip(selectedTeleport[2], selectedTeleport[3], selectedTeleport[4], selectedTeleport[1])
        else
            WindUI:Notify({
                Title = "Teleport Error",
                Content = "鉂� No location selected!",
                Duration = 1
            })
        end
    end
})

Tabs.Shop:Section({ Title = "Traveling Merchant" })

Tabs.Shop:Button({
    Title = "Teleport to Traveling Merchant",
    Desc = "Teleport directly to the Traveling Merchant NPC",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local merchant = workspace:FindFirstChild("World")
        if merchant then merchant = merchant:FindFirstChild("NPCs") end
        if merchant then merchant = merchant:FindFirstChild("Merchant Cart") end
        if merchant then merchant = merchant:FindFirstChild("Traveling Merchant") end

        if merchant and merchant:FindFirstChild("HumanoidRootPart") then
            humanoidRootPart.CFrame = merchant.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            WindUI:Notify({
                Title = "Teleported!",
                Content = "鉁� Successfully teleported to the Traveling Merchant.",
                Duration = 0
            })
        else
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "鉂� Traveling Merchant not found.",
                Duration = 3
            })
        end
    end
})

Tabs.Sell:Section({ Title = "Inventory" })

-- 馃摝 Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

-- 馃摝 Rocky NPC & Remote
local Rocky = workspace:WaitForChild("World"):WaitForChild("NPCs"):WaitForChild("Rocky")
local SellAllItems = ReplicatedStorage:WaitForChild("DialogueRemotes"):WaitForChild("SellAllItems")

-- 馃實 Global Variables
getgenv().autoSell = false
getgenv().sellDelay = 3

-- 鉁� UI Elements
Tabs.Sell:Toggle({
    Title = "Auto Sell",
    Desc = "Automatically sells items to Rocky",
    Value = false,
    Callback = function(value)
        getgenv().autoSell = value
    end
})

Tabs.Sell:Slider({
    Title = "Auto Sell Delay (seconds)",
    Desc = "Delay between each sell",
    Value = {
        Min = 1,
        Max = 60,
        Default = 3,
    },
    Suffix = "s",
    Callback = function(value)
        getgenv().sellDelay = value
    end
})

-- 馃攣 Looping Auto Sell
task.spawn(function()
    while task.wait(1) do
        if getgenv().autoSell then
            SellAllItems:FireServer(Rocky)
            task.wait(getgenv().sellDelay)
        end
    end
end)



Tabs.Setting:Section({ Title = "Staff" })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 馃敀 List of Staff UserIds
local staffIds = {
    12345678,
    98765432,
}

-- 馃寪 Global Flags
getgenv().StaffDetectionEnabled = true
getgenv().StaffAction = "Notify" -- default action

-- 鉁� Check if a player is staff
local function isStaff(player)
    for _, id in ipairs(staffIds) do
        if player.UserId == id then
            return true
        end
    end
    return false
end

-- 鈿狅笍 Handle detected staff
local function handleStaff(player)
    if not getgenv().StaffDetectionEnabled then return end
    if not isStaff(player) then return end

    if getgenv().StaffAction == "Kick" then
        LocalPlayer:Kick("Staff detected: " .. player.Name)
    elseif getgenv().StaffAction == "Notify" then
        Rayfield:Notify({
            Title = "鈿狅笍 Staff Detected",
            Content = player.Name .. " (UserId: " .. player.UserId .. ") joined!",
            Duration = 6.5
        })
    end
end

-- 鉁� WindUI Toggle (Benar)
Tabs.Setting:Toggle({
    Title = "Anti Staff",
    Desc = "Enable staff detection and take action when staff joins.",
    Default = true,
    Callback = function(Value)
        getgenv().StaffDetectionEnabled = Value
        if Value then
            for _, player in ipairs(Players:GetPlayers()) do
                handleStaff(player)
            end
        end
    end
})

-- 鉁� WindUI Dropdown (Benar)
Tabs.Setting:Dropdown({
    Title = "Action On Staff Detected",
    Desc = "Choose what happens when a staff joins",
    Values = { "Kick", "Notify" },
    Default = "Notify",
    Callback = function(option)
        getgenv().StaffAction = option
    end
})

-- 馃攧 Listen for new players
Players.PlayerAdded:Connect(function(player)
    handleStaff(player)
end)

-- 鉁� Check players already in server
for _, player in ipairs(Players:GetPlayers()) do
    handleStaff(player)
end

Tabs.Setting:Section({ Title = "Music" })

local SoundService = game:GetService("SoundService")
local currentMusic = nil
local currentVolume = 0.5
local musicEnabled = true

-- Daftar lagu
local musicList = {
    ["One Piece Two Piece"] = "rbxassetid://1838028562",
    ["牍犽ジ 鞁滌澕 雮挫棎"] = "rbxassetid://108807600670194",
    ["Parry Gripp - Raining Tacos"] = "rbxassetid://142376088",
    ["Theme 4"] = "rbxassetid://9047132593",
    ["Theme 5"] = "rbxassetid://1838028562",
    ["Theme 6"] = "rbxassetid://3456789012",
    ["Theme 7"] = "rbxassetid://9047132593",
    ["Theme 8"] = "rbxassetid://1838028562",
    ["Theme 9"] = "rbxassetid://3456789012",
    ["Theme 10"] = "rbxassetid://9047132593",
    ["Theme 11"] = "rbxassetid://1838028562",
    ["Theme 12"] = "rbxassetid://3456789012"
}

-- Fungsi putar musik jika toggle aktif
local function playMusic(id)
    if currentMusic then
        currentMusic:Stop()
        currentMusic:Destroy()
    end

    local sound = Instance.new("Sound")
    sound.Name = "WindUIMusic"
    sound.SoundId = id
    sound.Volume = currentVolume
    sound.Looped = true
    sound.Parent = SoundService

    currentMusic = sound

    if musicEnabled then
        sound:Play()
    end
end

-- Dropdown untuk pilih musik
Tabs.Setting:Dropdown({
    Title = "Select Music",
    Desc = "Choose background music",
    Values = { "Theme 1", "Theme 2", "Theme 3" },
    Default = "Theme 1",
    Callback = function(option)
        playMusic(musicList[option])
    end
})

-- 鉁� Slider Volume (Perbaikan Versi WindUI Support)
Tabs.Setting:Slider({
    Title = "Volume",
    Desc = "Set music volume",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 50,
    },
    Callback = function(v)
        currentVolume = v / 1000
        if currentMusic then
            currentMusic.Volume = currentVolume
        end
    end
})

-- Toggle On/Off Musik
Tabs.Setting:Toggle({
    Title = "Music On/Off",
    Desc = "Enable or disable background music",
    Default = true,
    Callback = function(state)
        musicEnabled = state
        if currentMusic then
            if musicEnabled then
                currentMusic:Play()
            else
                currentMusic:Pause()
            end
        end
    end
})

Tabs.Magnets:Section({ Title = "Magnets" })

local player = game.Players.LocalPlayer
local playerName = player.Name

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage:WaitForChild("Remotes")

-- Function to equip magnet by name
local function equipMagnet(magnetName)
    local magnet = replicatedStorage:WaitForChild("PlayerStats")
        :WaitForChild(playerName)
        :WaitForChild("Inventory")
        :WaitForChild("Magnets")
        :FindFirstChild(magnetName)

    if magnet then
        remotes:WaitForChild("Magnet_Equip"):FireServer(magnet)
    end
end

-- List of available magnets
local magnetList = {
    "Prismatic Magnet",
    "Crimsonsteel Magnet",
    "Magic Magnet",
    "Golden Horseshoe",
    "Legendary Magnet",
    "Fossil Brush",
    "Fortuned Magnet",
    "Brass Magnet",
    "Ghost Magnet",
    "Odd Mushroom",
    "Green Magnet",
    "Light Bulb",
    "Red Magnet",
    "Basic Magnet"
}

local selectedMagnet = magnetList[1] -- default magnet

-- 鉁� WindUI-style Dropdown
Tabs.Magnets:Dropdown({
    Title = "Select Magnet",
    Values = magnetList,
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedMagnet = value
    end
})

-- 鉁� WindUI-style Button
Tabs.Magnets:Button({
    Title = "Equip Selected Magnet",
    Desc = "Equip the selected magnet from dropdown",
    Callback = function()
        equipMagnet(selectedMagnet)
    end
})



Tabs.Teleport:Section({ Title = "Npc" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local npcsFolder = workspace:WaitForChild("World"):WaitForChild("NPCs")

-- Function to teleport to selected NPC
local function teleportToNPC(npcName)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    for _, npc in ipairs(npcsFolder:GetDescendants()) do
        if npc:IsA("Model") and npc.Name:lower():match(npcName:lower()) then
            local targetPart = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
            if targetPart then
                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
            end
            break
        end
    end
end

-- List of available NPCs
local npcNames = {
    "Sydney", "Roger Star", "Ava Carter", "Berry Dust", "Cole Blood", "Cave Worker", "Carly Enzo", "Malcom Wheels",
    "Annie Rae", "Magnus", "Mushroom Azali", "Penguin Mechanic", "Banker", "Gary Bull", "Tribes Mate", "Discoshroom",
    "John", "Mark Lever", "Max", "Ethan Bands", "Jane", "Blueshroom", "Brooke Kali", "Smith", "Dani Snow", "Grant Thorn",
    "Will", "Stranded Steve", "Drawstick Liz", "Ferry Conductor", "Steve Levi", "Sam Colby", "Mushroom Researcher",
    "Tom Baker", "Penguin Customer", "Pete R.", "Arthur Dig", "Granny Glenda", "Collin", "Cindy", "Jenn Diamond",
    "Tribe Leader", "Mourning Family Member", "Young Guitarist", "Bu Ran", "Billy Joe", "Andy", "Soten Ran", "Mrs.Salty",
    "Merchant Cart.Traveling Merchant", "Rocky", "Nate", "Blueshroom Merchant", "Barry", "Kira Pale", "Kei Ran", "Hale",
    "Darren", "Jim Diamond", "Ben Bones.Ben Bones", "Andrew", "Old Blueshroom", "Jie Ran", "Silver", "O'Myers", "Erin Field",
    "Pizza Penguin", "Lexi Star", "Ninja Deciple", "Mrs.Tiki", "Purple Imp", "Albert"
}

-- Default selected NPC
local selectedNPC = npcNames[1]

-- 鉁� WindUI Dropdown (Correct)
Tabs.Teleport:Dropdown({
    Title = "Select NPC",
    Desc = "Choose an NPC to teleport to",
    Values = npcNames,
    Default = 1,
    Callback = function(value)
        selectedNPC = value
    end
})

-- 鉁� WindUI Button (Correct)
Tabs.Teleport:Button({
    Title = "Teleport to Selected NPC",
    Desc = "Teleports you to the chosen NPC above",
    Callback = function()
        teleportToNPC(selectedNPC)
    end
})

Tabs.Teleport:Section({ Title = "Island" })

-- 馃摝 Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RootPart = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
RootPart = RootPart:WaitForChild("HumanoidRootPart")

-- 馃實 Teleport Locations
local locationCFrames = {
    ["Mount Cinder"] = CFrame.new(4532.7417, 1101.18176, -1689.43616, 0.749915659, -5.64403457e-08, -0.661533475, -3.06035659e-08, 1, -1.20009716e-07, 0.661533475, 1.10242446e-07, 0.749915659),
    ["Rooftop Woodlands"] = CFrame.new(3888.36108, 225.724136, -360.665222, 0.0672813058, -1.63528906e-08, -0.99773407, -3.44779161e-09, 1, 1.6622259e-08, 0.99773407, 4.55836435e-09, 0.0672813058),
    ["Verdant Vale"] = CFrame.new(3778.50977, 81.9500809, 1665.49854, -0.328049302, -8.14578414e-08, -0.944660604, -2.52909764e-08, 1, -7.74470266e-08, 0.944660604, -1.51505364e-09, -0.328049302),
    ["Fox Town"] = CFrame.new(2018.89087, 112.049995, -358.086761, -0.289423496, 4.1994131e-08, -0.957201123, 5.52061972e-08, 1, 2.71797938e-08, 0.957201123, -4.49770639e-08, -0.289423496),
    ["Cinder Shores"] = CFrame.new(1572.10986, 76.1001053, -136.280136, -0.827068925, 8.16707626e-08, -0.56210053, 2.42646543e-08, 1, 1.09592897e-07, 0.56210053, 7.7001701e-08, -0.827068925),
    ["Fernhill Forest"] = CFrame.new(2543.40283, 81.9500885, 1276.43262, 0.961085558, -6.8614078e-08, -0.276250839, 7.53299148e-08, 1, 1.36991876e-08, 0.276250839, -3.39760433e-08, 0.961085558),
}

-- 馃Л List of location names
local locationNames = {}
for name in pairs(locationCFrames) do
    table.insert(locationNames, name)
end

local selectedLocation = locationNames[1]

-- 鉁� WindUI Dropdown
Tabs.Teleport:Dropdown({
    Title = "Select Location",
    Desc = "Choose a teleport destination",
    Values = locationNames,
    Default = 1,
    Callback = function(selected)
        selectedLocation = selected
    end
})

-- 鉁� WindUI Button
Tabs.Teleport:Button({
    Title = "Teleport!",
    Desc = "Teleport to the selected location",
    Callback = function()
        local cf = locationCFrames[selectedLocation]
        if cf then
            RootPart.CFrame = cf
        else
            warn("No location selected!")
        end
    end
})

Info = Tabs.InfoTab

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

-- Define the Request function that mimics ui.Creator.Request
ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
    -- Try different HTTP methods
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            -- Method 1: Use RequestAsync if available
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            -- Method 2: Fallback to GetAsync
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)
    
    if success then
        return result
    else
        error("HTTP Request failed: " .. tostring(result))
    end
end

-- Remove this line completely: Info = InfoTab
-- The Info variable is already correctly set above

local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Info:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    
                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
        print("Discord API Error:", result) -- Debug print
    end
end

LoadDiscordInfo()

Info:Divider()
Info:Section({ 
    Title = "DYHUB Information",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

local Owner = Info:Paragraph({
    Title = "Main Owner",
    Desc = "@dyumraisgoodguy#8888",
    Image = "rbxassetid://119789418015420",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
})

local Social = Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://guns.lol/DYHUB")
                print("Copied social media link to clipboard!")
            end,
        }
    }
})

local Discord = Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/jWNDPNMmyB")
                print("Copied discord link to clipboard!")
            end,
        }
    }
})
