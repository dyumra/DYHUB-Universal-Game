repeat task.wait() until game:IsLoaded()

-- รวม Services ไว้บรรทัดเดียว
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ฟังก์ชัน notify ใช้ได้ทั่วทั้งสคริปต์
local function notify(msg)
    WindUI:Notify({
        Title = "DYHUB - Notification",
        Content = msg,
        Duration = 2.5,
        Image = "info"
    })
end

local Confirmed = false

WindUI:Popup({
    Title = "DYHUB Loaded! - Evade",
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
    Title = "DYHUB - Evade",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local GameTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local ReviveTab = Window:Tab({ Title = "Revive", Icon = "shield-plus" })

-- ===== Player Tab =====
local ValueSpeed = 16
local ActiveSpeedBoost = false

PlayerTab:Input({
    text = "Set Speed (1-100)",
    placeholder = "Enter speed",
    onChanged = function(value)
        local num = tonumber(value)
        if num and num >= 1 and num <= 100 then
            ValueSpeed = num
        else
            ValueSpeed = 16 -- default fallback
        end
    end
})

PlayerTab:Toggle({
    text = "Enable Speed Boost",
    callback = function(state)
        ActiveSpeedBoost = state
    end
})

-- เคลื่อนที่ SpeedBoost ด้วย RunService Heartbeat
RunService.Heartbeat:Connect(function()
    if ActiveSpeedBoost then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
                local direction = hrp.CFrame.LookVector
                -- ใช้ Humanoid:MoveTo เพื่อหลีกเลี่ยงการติดวัตถุ
                local targetPos = hrp.Position + direction * (ValueSpeed / 10)
                humanoid:MoveTo(targetPos)
            end
        end
    end
end)

-- ===== Game Tab =====
local ActiveAutoWin = false
local ActiveAutoFarmMoney = false
local AutoFarmSummerEvent = false
local AntiAfkEnabled = true

-- เก็บ SecurityPart ไว้ใช้ซ้ำ
local SecurityPart = nil
local function CreateOrGetSecurityPart()
    if SecurityPart and SecurityPart.Parent then
        return SecurityPart
    else
        SecurityPart = Instance.new("Part")
        SecurityPart.Name = "SecurityPart"
        SecurityPart.Size = Vector3.new(10, 1, 10)
        SecurityPart.Position = Vector3.new(0, 500, 0)
        SecurityPart.Anchored = true
        SecurityPart.Transparency = 1
        SecurityPart.CanCollide = false
        SecurityPart.Parent = Workspace
        return SecurityPart
    end
end

GameTab:Toggle({
    text = "Auto Farm Win",
    callback = function(state)
        ActiveAutoWin = state
    end
})

GameTab:Toggle({
    text = "Auto Farm Money",
    callback = function(state)
        ActiveAutoFarmMoney = state
    end
})

GameTab:Toggle({
    text = "Auto Farm Summer Event",
    callback = function(state)
        AutoFarmSummerEvent = state
    end
})

GameTab:Toggle({
    text = "Anti AFK",
    Default = true,
    callback = function(state)
        AntiAfkEnabled = state
        if state then
            notify("✅ Anti AFK Enabled")
            -- เชื่อมต่อกับ Idled event
            Players.LocalPlayer.Idled:Connect(function()
                if AntiAfkEnabled then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        else
            notify("❌ Anti AFK Disabled")
        end
    end
})

-- Loop สำหรับ Auto Farm Win + Auto Farm Money + Auto Farm Summer Event ด้วย RunService Heartbeat
RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and not character:GetAttribute("Downed") then
        -- Auto Farm Win
        if ActiveAutoWin then
            local sp = CreateOrGetSecurityPart()
            character.HumanoidRootPart.CFrame = sp.CFrame + Vector3.new(0, 3, 0)
        end
        -- Auto Farm Money
        if ActiveAutoFarmMoney then
            local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
            if playersInGame then
                local downedPlayer = nil
                for _, v in pairs(playersInGame:GetChildren()) do
                    if v:GetAttribute("Downed") then
                        downedPlayer = v
                        break
                    end
                end
                if downedPlayer and downedPlayer:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = downedPlayer.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, downedPlayer)
                end
            end
        end
    end

    -- Auto Farm Summer Event
    if AutoFarmSummerEvent then
        local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
        if ticketsFolder then
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if character:GetAttribute("Downed") then
                ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
            end
            for _, ticket in ipairs(ticketsFolder:GetChildren()) do
                local ticketPart = ticket:FindFirstChild("HumanoidRootPart") or ticket.PrimaryPart
                if ticketPart and rootPart then
                    rootPart.CFrame = ticketPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
            local sp = CreateOrGetSecurityPart()
            rootPart.CFrame = sp.CFrame + Vector3.new(0, 3, 0)
        else
            WindUI:Notify({
                Title = "Auto Farm Summer",
                Text = "⚠️ Tickets not found!",
                Duration = 2,
            })
        end
    end
end)

-- ===== Esp Tab =====
local ActiveEspPlayers = false
local ActiveEspBots = false
local ActiveEspSummerEvent = false
local ActiveDistanceEsp = false

local function CreateEsp(Char, Color, Text, Parent, OffsetY)
    if not Char then return end
    if Char:FindFirstChild("ESP_Highlight") or Parent:FindFirstChild("ESP_Billboard") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, OffsetY, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    spawn(function()
        local Camera = Workspace.CurrentCamera
        while highlight.Parent and billboard.Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                if ActiveDistanceEsp then
                    label.Text = Text .. " " .. math.floor(distance + 0.5) .. " Stud"
                else
                    label.Text = Text
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function RemoveEsp(Char, Parent)
    local highlight = Char:FindFirstChild("ESP_Highlight")
    local billboard = Parent:FindFirstChild("ESP_Billboard")
    if highlight then highlight:Destroy() end
    if billboard then billboard:Destroy() end
end

EspTab:Toggle({
    text = "Players ESP",
    callback = function(state)
        ActiveEspPlayers = state
    end
})

EspTab:Toggle({
    text = "Bots ESP",
    callback = function(state)
        ActiveEspBots = state
    end
})

EspTab:Toggle({
    text = "Summer Event ESP",
    callback = function(state)
        ActiveEspSummerEvent = state
    end
})

EspTab:Toggle({
    text = "Distance ESP",
    callback = function(state)
        ActiveDistanceEsp = state
    end
})

-- ESP Update Loop
RunService.Heartbeat:Connect(function()
    -- Players ESP
    if ActiveEspPlayers then
        for _, plr in pairs(Players:GetPlayers()) do
            local char = plr.Character
            if char and char:FindFirstChild("Head") then
                local highlight = char:FindFirstChild("ESP_Highlight")
                local billboard = char.Head:FindFirstChild("ESP_Billboard")
                if not highlight and not billboard then
                    CreateEsp(char, Color3.fromRGB(0, 255, 0), plr.Name, char.Head, 1)
                end
            end
        end
    else
        -- Remove Players ESP
        for _, plr in pairs(Players:GetPlayers()) do
            local char = plr.Character
            if char and char:FindFirstChild("Head") then
                RemoveEsp(char, char.Head)
            end
        end
    end

    -- Bots ESP
    local botsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
    if ActiveEspBots and botsFolder then
        for _, bot in pairs(botsFolder:GetChildren()) do
            if bot:FindFirstChild("Hitbox") then
                local highlight = bot:FindFirstChild("ESP_Highlight")
                local billboard = bot.Hitbox:FindFirstChild("ESP_Billboard")
                if not highlight and not billboard then
                    bot.Hitbox.Transparency = 0
                    CreateEsp(bot, Color3.fromRGB(255, 0, 0), bot.Name, bot.Hitbox, -2)
                end
            end
        end
    elseif botsFolder then
        -- Remove Bots ESP
        for _, bot in pairs(botsFolder:GetChildren()) do
            if bot:FindFirstChild("Hitbox") then
                bot.Hitbox.Transparency = 1
                RemoveEsp(bot, bot.Hitbox)
            end
        end
    end

    -- Summer Event ESP
    local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
    if ActiveEspSummerEvent and ticketsFolder then
        for _, ticket in pairs(ticketsFolder:GetChildren()) do
            if ticket and ticket.PrimaryPart and ticket.Name == "Visual" then
                local highlight = ticket:FindFirstChild("ESP_Highlight")
                local billboard = ticket.PrimaryPart:FindFirstChild("ESP_Billboard")
                if not highlight and not billboard then
                    CreateEsp(ticket, Color3.fromRGB(255, 255, 0), "Tickets", ticket.PrimaryPart, -2)
                end
            end
        end
    elseif ticketsFolder then
        -- Remove Summer Event ESP
        for _, ticket in pairs(ticketsFolder:GetChildren()) do
            if ticket and ticket.PrimaryPart then
                RemoveEsp(ticket, ticket.PrimaryPart)
            end
        end
    end
end)

-- ===== Revive Tab =====
ReviveTab:Button({
    text = "Revive Yourself",
    callback = function()
        local player = LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        if character:GetAttribute("Downed") then
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
            notify("✅ Revived!")
        else
            notify("⚠️ You are not Downed yet!")
        end
    end
})

local autoReviveEnabled = false
local lastCheckTime = 0
local checkInterval = 5 -- เช็คทุก 5 วินาที

ReviveTab:Toggle({
    text = "Auto Revive Yourself",
    callback = function(state)
        autoReviveEnabled = state
        if autoReviveEnabled then
            notify("Auto Revive Enabled")
        else
            notify("Auto Revive Disabled")
        end
    end
})

RunService.Heartbeat:Connect(function()
    if autoReviveEnabled then
        if tick() - lastCheckTime >= checkInterval then
            lastCheckTime = tick()
            local player = LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            if character:GetAttribute("Downed") then
                ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                notify("✅ Revived!")
            end
        end
    end
end)
