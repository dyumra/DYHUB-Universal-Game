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
    Title = "DYHUB Loaded! - Build A Brainrot",
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
    Title = "DYHUB - Build A Brainrot",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local BuyTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- ======= Main =======
local cashInputValue = ""
local inf = "999999999999999999"
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
    Placeholder = "Set Cash Amount (e.g, 1000 or 1k)",
    Callback = function(text)
        cashInputValue = text
    end,
})

MainTab:Button({
    Title = "Enter Cash",
    Callback = function()
        local amt = parseShortNumber(cashInputValue)
        if amt then
            ReplicatedStorage.Remotes.giveRewards:FireServer("Cash", amt)
            print("[DYHUB] Added cash:", amt)
        else
            warn("[DYHUB] Invalid cash amount:", cashInputValue)
        end
    end,
})

MainTab:Button({
    Title = "Infinite Cash",
    Callback = function()
        ReplicatedStorage.Remotes.giveRewards:FireServer("Cash", inf)
        print("[DYHUB] Added cash:", inf)
    end,
})

MainTab:Toggle({
    Title = "Auto Rebirth",
    Value = false,
    Callback = function(state)
        autoRebirth = state
        if autoRebirth then
            spawn(function()
                while autoRebirth do
                    ReplicatedStorage.Remotes.giveRewards:FireServer("Cash", 69696969696969)
                    task.wait(2)
                end
            end)
        end
    end,
})

-- ======= Buy =======
BuyTab:Button({
    Title = "Buy All Tools",
    Callback = function()
        for _, tool in ipairs(ReplicatedStorage.Tools:GetChildren()) do
            ReplicatedStorage.Remotes.buyTool:FireServer(tool.Name)
        end
        print("[DYHUB] Bought all tools")
    end,
})

local autoBuyBuilds = false
local autoBuyBuildsThread = nil

BuyTab:Toggle({
    Title = "Auto Buy Builds (Best)",
    Value = false,
    Callback = function(state)
        autoBuyBuilds = state
        if state then
            if not autoBuyBuildsThread then
                autoBuyBuildsThread = task.spawn(function()
                    while autoBuyBuilds do
                        ReplicatedStorage.Remotes.buyPlaceable:FireServer("Turret")
                        task.wait(2)
                    end
                    autoBuyBuildsThread = nil
                end)
            end
        else
            autoBuyBuilds = false
            -- Stop if Loop Break
        end
    end,
})

-- ======= Player =======
local espEnabled = false
local espOptions = { ShowName = false, ShowHealth = false, ShowDistance = false }
local espHighlights = {}
local espBillboards = {}

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
    textLabel.TextColor3 = Color3.new(0, 1, 0)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.Parent = billboard

    billboard.Parent = player.Character
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
        if hum then healthStr = string.format(" HP: %.0f", hum.Health) end
    end
    local distStr = ""
    if espOptions.ShowDistance and player.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
        distStr = string.format(" Dist: %.1f", dist)
    end
    label.Text = nameStr .. healthStr .. distStr
end

local function removeBillboard(player)
    if espBillboards[player] then
        espBillboards[player]:Destroy()
        espBillboards[player] = nil
    end
end

local function updateESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not espHighlights[p] then
                local highlight = Instance.new("Highlight")
                highlight.Name = "DYHUB_ESP"
                highlight.Adornee = p.Character
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.new(0, 0, 0)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = workspace
                espHighlights[p] = highlight
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

local espUpdateConnection
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

-- ======= Misc Tab (Anti stuff) =======
local antiKick = false
local antiAfk = false
local antiAdmin = false

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

MiscTab:Toggle({
    Title = "Anti Kick",
    Value = false,
    Callback = function(state)
        antiKick = state
        print("[DYHUB] Anti Kick " .. (state and "Enabled" or "Disabled"))
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

-- (Anti Kick can be added here if you want to block kick events; placeholder for now)

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
                -- You can save other settings here if you want
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
            -- Update Main tab UI if needed
        else
            warn("[DYHUB] Config not found: " .. tostring(selectedConfig))
        end
    end,
})

print("[DYHUB] Full Build A Brainrot Loaded!")
