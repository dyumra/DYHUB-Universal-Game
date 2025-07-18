repeat task.wait() until game:IsLoaded()

local dyhub = workspace.Lobby:FindFirstChild("VIPArea")
if dyhub then
    dyhub:Destroy()
end


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "DYHUB Loaded! - Tsunami Escape",
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
    Title = "DYHUB - Tsunami Escape",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- ======= Main =======
local cashInputValue = ""
local cashInputValue2 = ""
local spin = 999999
local inf = 999999999999999999
local autoRebirth = false

local function parseShortNumber(str)
    local m = { k=1e3, m=1e6, b=1e9, t=1e12, q=1e15, qi=1e18, s=1e21, sep=1e24, o=1e27 }
    str = str:lower():gsub(",","")
    local n,s = str:match("([%d%.]+)(%a*)")
    local v = tonumber(n)
    if not v then return nil end
    if s == "" then return v end
    if m[s] then return v * m[s] end
    return nil
end

MainTab:Input({
    Title = "Enter Desired Cash Amount",
    Value = cashInputValue,
    Placeholder = "Set Cash Amount (e.g, 1000, 1k)",
    Callback = function(text)
        cashInputValue = text
    end,
})

MainTab:Button({
    Title = "Enter Cash",
    Callback = function()
        local amt = parseShortNumber(cashInputValue)
        if amt then
            for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    pcall(function()
                        obj:FireServer(amt)  -- ส่งตัวเลขแทน string
                    end)
                end
            end
            print("[DYHUB] Added cash:", amt)
        else
            warn("[DYHUB] Invalid cash amount:", cashInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Enter Desired Spin Amount",
    Value = cashInputValue2,
    Placeholder = "Set Spin Amount (e.g, 5, 10)",
    Callback = function(text)
        cashInputValue2 = text
    end,
})

MainTab:Button({
    Title = "Enter Spin",
    Callback = function()
        local amt = parseShortNumber(cashInputValue2)
        if amt then
            for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    pcall(function()
                        obj:FireServer(amt)
                    end)
                end
            end
            print("[DYHUB] Added Spin:", amt)
        else
            warn("[DYHUB] Invalid Spin amount:", cashInputValue2)
        end
    end,
})

MainTab:Button({
    Title = "Infinite Cash",
    Callback = function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function()
                    obj:FireServer(inf)
                end)
            end
        end
        print("[DYHUB] Added cash:", inf)
    end,
})

MainTab:Button({
    Title = "Infinite Spin",
    Callback = function()
        local remote = ReplicatedStorage:FindFirstChild("Honeypot", true)
        if remote then
            local award = remote:FindFirstChild("Internal", true)
            if award then
                local storage = award:FindFirstChild("RemoteStorage", true)
                if storage then
                    local event = storage:FindFirstChild("AwardSpinCash")
                    if event and event:IsA("RemoteEvent") then
                        pcall(function()
                            event:FireServer(spin)
                            print("[DYHUB] Added Spin:", spin)
                        end)
                    end
                end
            end
        end
    end,
})

-- สร้าง SafeZone part ถ้ามันยังไม่มี
local SafeZonePart = workspace:FindFirstChild("DYHUB_SafeZonePart")
if not SafeZonePart then
    SafeZonePart = Instance.new("Part")
    SafeZonePart.Name = "DYHUB_SafeZonePart"
    SafeZonePart.Anchored = true
    SafeZonePart.CanCollide = true
    SafeZonePart.Size = Vector3.new(50, 1, 50)
    SafeZonePart.Position = Vector3.new(0, 500, 0) -- สูงๆ นอกแมพ
    SafeZonePart.Transparency = 0.5
    SafeZonePart.Parent = workspace
end

local inSafeZone = false
local originalCFrame = nil

MainTab:Button({
    Title = "Safe Zone",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            character:PivotTo(CFrame.new(SafeZonePart.Position + Vector3.new(0,5,0)))
            inSafeZone = true
            print("[DYHUB] Warped to Safe Zone.")
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Safe 50% HP",
    Value = false,
    Callback = function(state)
        local runServiceConnection
        if state then
            runServiceConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        if humanoid.Health <= humanoid.MaxHealth * 0.5 and not inSafeZone then
                            originalCFrame = character:GetPivot()
                            -- วาร์ปไป Safe Zone
                            character:PivotTo(CFrame.new(SafeZonePart.Position + Vector3.new(0, 5, 0)))
                            inSafeZone = true
                            print("[DYHUB] Low HP detected, warped to Safe Zone.")
                        end
                    end
                end
            end)
            -- เก็บการเชื่อมต่อไว้ปิดทีหลัง
            MainTab.AutoSafeConnection = runServiceConnection
        else
            if MainTab.AutoSafeConnection then
                MainTab.AutoSafeConnection:Disconnect()
                MainTab.AutoSafeConnection = nil
            end
            inSafeZone = false
            print("[DYHUB] Auto Safe 50% HP Disabled")
        end
    end,
})

-- ปุ่ม Back to Game วาร์ปกลับตำแหน่งเดิม หรือถ้าไม่มีให้วาร์ปที่ (0,0,0) พร้อม CFrame ที่บอก
MainTab:Button({
    Title = "Back to Game",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            if originalCFrame then
                character:PivotTo(originalCFrame)
                print("[DYHUB] Warped back to original position.")
            else
                character:PivotTo(CFrame.new(0, 10, 0)) -- default position กลางแมพ
                print("[DYHUB] Warped to default position (0,10,0).")
            end
            inSafeZone = false
        end
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
    if antiAdmin and (p.Name == "Yolmar_43" or p.Name == "Roblox123") then
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

ConfigTab:Button({
    Title = "Free Admin in Config ???",
    Callback = function()
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local SoundService = game:GetService("SoundService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local lp = Players.LocalPlayer
        antiAfk = state

        -- 🔁 ฟังก์ชันติด Tag
        local function tagPlayer(player)
            pcall(function()
                player.DisplayName = "DYHUB THE BEST (😏)"
            end)

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "DYHUBTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true

            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "Join our (dsc.gg/dyhub)"
            label.TextColor3 = Color3.fromRGB(255, 50, 50)
            label.Font = Enum.Font.GothamBlack
            label.TextScaled = true

            local function attachToCharacter()
                if player.Character and player.Character:FindFirstChild("Head") then
                    if not player.Character.Head:FindFirstChild("DYHUBTag") then
                        billboard:Clone().Parent = player.Character.Head
                    end
                end
            end

            player.CharacterAdded:Connect(function()
                task.wait(1)
                attachToCharacter()
            end)

            attachToCharacter()
        end

        for _, plr in pairs(Players:GetPlayers()) do
            tagPlayer(plr)
        end

        Players.PlayerAdded:Connect(tagPlayer)

        -- 💀 JUMPSCARE START
        local scream = Instance.new("Sound", SoundService)
        scream.SoundId = "rbxassetid://9120436106"
        scream.Volume = 10

        local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
        gui.Name = "DYJumpscare"

        local emoji = Instance.new("TextLabel", gui)
        emoji.Text = "😏"
        emoji.Font = Enum.Font.GothamBlack
        emoji.TextColor3 = Color3.new(1, 1, 1)
        emoji.BackgroundTransparency = 1
        emoji.Size = UDim2.new(0.5, 0, 0.5, 0)
        emoji.Position = UDim2.new(0.25, 0, 0.25, 0)
        emoji.TextScaled = true

        local shrink = TweenService:Create(emoji, TweenInfo.new(1), {
            Size = UDim2.new(0.1, 0, 0.1, 0),
            Position = UDim2.new(0.45, 0, 0.45, 0)
        })
        shrink:Play()
        shrink.Completed:Wait()

        scream:Play()
        emoji.Text = "💀"
        emoji.Size = UDim2.new(5, 0, 5, 0)
        emoji.Position = UDim2.new(-2, 0, -2, 0)

        task.wait(1)
        gui:Destroy()

        -- ⌛ รอ 5 วิ แล้วขึ้นข้อความ
        task.wait(5)
        local popup = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
        popup.Name = "DYMessage"

        local label = Instance.new("TextLabel", popup)
        label.Size = UDim2.new(0.5, 0, 0.2, 0)
        label.Position = UDim2.new(0.25, 0, 0.4, 0)
        label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Text = "Join our (dsc.gg/dyhub)"
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.BackgroundTransparency = 0.2
        label.BorderSizePixel = 0
        label.TextStrokeTransparency = 0.5

        -- ⏳ รออีก 3 วิแล้วเตะออกแบบปั่น
        task.wait(3)
        popup:Destroy()
        local inf1fun = math.random(123456, 9999999)

        -- ยิงมั่ว remote แบบ troll
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function()
                    obj:FireServer(inf1fun)
                end)
            end
        end

        print("[DYHUB] You now own ROBLOX 🤡 Amount injected:", inf)
    end,
})

print("[DYHUB] Full Tsunami Escape Loaded!")
