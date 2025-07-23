repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local WindUI = nil
local success, errorMessage = pcall(function()
    local scriptContent = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    if scriptContent and scriptContent ~= "" then
        WindUI = loadstring(scriptContent)()
    else
        error("Failed to retrieve WindUI script content.")
    end
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. (errorMessage or "Unknown error"))
    game.StarterGui:SetCore("SendNotification", {
        Title = "DYHUB Error",
        Text = "The script does not support your executor!",
        Duration = 10,
        Button1 = "OK"
    })
    return
end

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Evade (Version: 2.0)",
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
    Title = "DYHUB - Evade | V2.7",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local GameTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local VoteTab = Window:Tab({ Title = "Vote", Icon = "map" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local ReviveTab = Window:Tab({ Title = "Revive", Icon = "shield-plus" })
local FakeTab = Window:Tab({ Title = "Fake", Icon = "sparkles" })
local SkullTab = Window:Tab({ Title = "Best", Icon = "skull" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings-2" })

local ValueSpeed = 16
local ActiveSpeedBoost = false

PlayerTab:Input({
    Title = "Set Speed (1-100)",
    placeholder = "Set Speed on Fixing!",
    onChanged = function(value)
        local num = tonumber(value)
        if num and num >= 1 and num <= 100 then
            ValueSpeed = num
        else
            ValueSpeed = 16
            print("[DYHUB] Invalid speed value. Please enter a number between 1 and 100.")
        end
    end
})

PlayerTab:Toggle({
    Title = "Enable Speed Boost",
    Callback = function(state)
        ActiveSpeedBoost = state
        if ActiveSpeedBoost then
            print("[DYHUB] Speed Boost Enabled!")
            spawn(function()
                while ActiveSpeedBoost do
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")

                    if character and humanoid and hrp then
                        local lookVector = hrp.CFrame.LookVector
                        local newPos = hrp.Position + lookVector * (ValueSpeed / 10)
                        humanoid:MoveTo(newPos)
                    end
                    task.wait(0.1)
                end
            end)
        else
            print("[DYHUB] Speed Boost Disabled!")
        end
    end
})

local ActiveAutoWin = false
local ActiveAutoFarmMoney = false
local AutoFarmSummerEvent = false
local AntiAfkEnabled = true
local AntiTp = true
local AntiBypass = true

GameTab:Toggle({
    Title = "Auto Farm Win",
    Callback = function(state)
        ActiveAutoWin = state
        if ActiveAutoWin then
            print("[DYHUB] Auto Farm Win Enabled!")
            spawn(function()
                while ActiveAutoWin do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            print("[DYHUB] Revived for Auto Win!")
                            task.wait(0.5)
                        end

                        if not character:GetAttribute("Downed") then
                            local securityPart = Instance.new("Part")
                            securityPart.Name = "SecurityPartTemp"
                            securityPart.Size = Vector3.new(10, 1, 10)
                            securityPart.Position = Vector3.new(0, 500, 0)
                            securityPart.Anchored = true
                            securityPart.Transparency = 1
                            securityPart.CanCollide = false
                            securityPart.Parent = Workspace

                            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.5)
                            securityPart:Destroy()
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Win Disabled!")
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Money",
    Callback = function(state)
        ActiveAutoFarmMoney = state
        if ActiveAutoFarmMoney then
            print("[DYHUB] Auto Farm Money Enabled!")
            spawn(function()
                while ActiveAutoFarmMoney do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        -- Check if we are downed first
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            print("[DYHUB] Revived for Auto Farm-Money!")
                            task.wait(0.5)
                        end

                        -- Try to find a downed player to revive (if that's how money is earned)
                        local downedPlayerFound = false
                        local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                        if playersInGame then
                            for _, v in pairs(playersInGame:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                    -- Found a downed player, warp and revive
                                    rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
                                    print("[DYHUB] Reviving player for Farm Money!")
                                    task.wait(0.5) -- Wait after interaction
                                    downedPlayerFound = true
                                    break
                                end
                            end
                        end

                        if not downedPlayerFound then
                            print("[DYHUB] ⚠️ No downed player found for Auto Farm Money, waiting...")
                        end

                        -- Safety warp to sky to prevent getting stuck (if needed)
                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = false
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)

                    else
                        print("[DYHUB] Character or HumanoidRootPart not found, waiting for spawn.")
                    end
                    task.wait(1) -- Wait before next loop iteration
                end
            end)
        else
            print("[DYHUB] Auto Farm Money Disabled!")
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Summer Event",
    Callback = function(state)
        AutoFarmSummerEvent = state
        if AutoFarmSummerEvent then
            print("[DYHUB] Auto Farm Summer Event Enabled!")
            spawn(function()
                while AutoFarmSummerEvent do
                    local tickets = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
                    if tickets then
                        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if character and rootPart then
                            if character:GetAttribute("Downed") then
                                ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                                print("[DYHUB] Revived for Summer Event!")
                                task.wait(0.5)
                            end

                            for _, ticket in ipairs(tickets:GetChildren()) do
                                local ticketPart = ticket:FindFirstChild("HumanoidRootPart") or ticket.PrimaryPart
                                if ticketPart and rootPart then
                                    rootPart.CFrame = ticketPart.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.2)
                                end
                            end

                            local securityPart = Instance.new("Part")
                            securityPart.Name = "SecurityPartTemp"
                            securityPart.Size = Vector3.new(10, 1, 10)
                            securityPart.Position = Vector3.new(0, 500, 0)
                            securityPart.Anchored = true
                            securityPart.Transparency = 1
                            securityPart.CanCollide = false
                            securityPart.Parent = Workspace
                            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    else
                        print("[DYHUB] ⚠️ Tickets not found for Summer Event!")
                    end
                    task.wait(1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Summer Event Disabled!")
        end
    end
})

local ActiveEspPlayers = false
local ActiveEspBots = false
local ActiveEspSummerEvent = false
local ActiveDistanceEsp = false

local function CreateEsp(Char, Color, Text, ParentPart, YOffset)
    if not Char or not ParentPart or not ParentPart:IsA("BasePart") then return end
    if Char:FindFirstChild("ESP_Highlight") and ParentPart:FindFirstChild("ESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, YOffset, 0)
    billboard.Adornee = ParentPart
    billboard.Enabled = true
    billboard.Parent = ParentPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = tostring(Text) or ""
    label.TextColor3 = Color
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = billboard

    spawn(function()
        local Camera = Workspace.CurrentCamera
        while highlight.Parent and billboard.Parent and ParentPart.Parent and Camera do
            local cameraPosition = Camera.CFrame.Position
            local distance = (cameraPosition - ParentPart.Position).Magnitude
            local safeText = tostring(Text) or ""
            if ActiveDistanceEsp then
                label.Text = safeText .. " " .. tostring(math.floor(distance + 0.5)) .. " Studs"
            else
                label.Text = safeText
            end
            task.wait(0.1)
        end
        if highlight then highlight:Destroy() end
        if billboard then billboard:Destroy() end
    end)
end

local function RemoveEsp(Char, ParentPart)
    if Char then
        local highlight = Char:FindFirstChild("ESP_Highlight")
        if highlight then highlight:Destroy() end
    end
    if ParentPart then
        local billboard = ParentPart:FindFirstChild("ESP")
        if billboard then billboard:Destroy() end
    end
end

EspTab:Toggle({
    Title = "Players ESP",
    Callback = function(state)
        ActiveEspPlayers = state
        if ActiveEspPlayers then
            print("[DYHUB] Players ESP Enabled!")
            spawn(function()
                while ActiveEspPlayers do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                            CreateEsp(plr.Character, Color3.fromRGB(0, 255, 0), plr.Name, plr.Character.Head, 1)
                        end
                    end
                    task.wait(0.5)
                end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character and plr.Character:FindFirstChild("Head") then
                        RemoveEsp(plr.Character, plr.Character.Head)
                    end
                end
            end)
        else
            print("[DYHUB] Players ESP Disabled!")
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    RemoveEsp(plr.Character, plr.Character.Head)
                end
            end
        end
    end
})

EspTab:Toggle({
    Title = "Bots ESP",
    Callback = function(state)
        ActiveEspBots = state
        if ActiveEspBots then
            print("[DYHUB] Bots ESP Enabled!")
            spawn(function()
                while ActiveEspBots do
                    local botsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                    if botsFolder then
                        for _, bot in pairs(botsFolder:GetChildren()) do
                            if bot:IsA("Model") and bot:FindFirstChild("Hitbox") then
                                bot.Hitbox.Transparency = 0.5
                                CreateEsp(bot, Color3.fromRGB(255, 0, 0), bot.Name, bot.Hitbox, -2)
                            end
                        end
                    end
                    task.wait(0.5)
                end
                local botsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                if botsFolder then
                    for _, bot in pairs(botsFolder:GetChildren()) do
                        if bot:IsA("Model") and bot:FindFirstChild("Hitbox") then
                            bot.Hitbox.Transparency = 1
                            RemoveEsp(bot, bot.Hitbox)
                        end
                    end
                end
            end)
        else
            print("[DYHUB] Bots ESP Disabled!")
            local botsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
            if botsFolder then
                for _, bot in pairs(botsFolder:GetChildren()) do
                    if bot:IsA("Model") and bot:FindFirstChild("Hitbox") then
                        bot.Hitbox.Transparency = 1
                        RemoveEsp(bot, bot.Hitbox)
                    end
                end
            end
        end
    end
})

EspTab:Toggle({
    Title = "Summer Event ESP",
    Callback = function(state)
        ActiveEspSummerEvent = state
        if ActiveEspSummerEvent then
            print("[DYHUB] Summer Event ESP Enabled!")
            spawn(function()
                while ActiveEspSummerEvent do
                    local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
                    if ticketsFolder then
                        for _, ticket in pairs(ticketsFolder:GetChildren()) do
                            if ticket and ticket.PrimaryPart and ticket.Name == "Visual" then
                                CreateEsp(ticket, Color3.fromRGB(255, 255, 0), "Ticket", ticket.PrimaryPart, -2)
                            end
                        end
                    end
                    task.wait(0.5)
                end
                local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
                if ticketsFolder then
                    for _, ticket in pairs(ticketsFolder:GetChildren()) do
                        if ticket and ticket.PrimaryPart then
                            RemoveEsp(ticket, ticket.PrimaryPart)
                        end
                    end
                end
            end)
        else
            print("[DYHUB] Summer Event ESP Disabled!")
            local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
            if ticketsFolder then
                for _, ticket in pairs(ticketsFolder:GetChildren()) do
                    if ticket and ticket.PrimaryPart then
                        RemoveEsp(ticket, ticket.PrimaryPart)
                    end
                end
            end
        end
    end
})

EspTab:Toggle({
    Title = "Distance ESP",
    Callback = function(state)
        ActiveDistanceEsp = state
        if ActiveDistanceEsp then
            print("[DYHUB] Distance ESP Enabled!")
        else
            print("[DYHUB] Distance ESP Disabled!")
        end
    end
})

local autoReviveEnabled = false
local lastCheckTime = 0
local checkInterval = 5

ReviveTab:Button({
    Title = "Revive Yourself",
    Callback = function()
        local player = LocalPlayer
        local character = player.Character
        if character and character:GetAttribute("Downed") then
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
            print("[DYHUB] ✅ Revived!")
        else
            print("[DYHUB] ⚠️ You are not Downed yet!")
        end
    end
})

ReviveTab:Toggle({
    Title = "Auto Revive Yourself",
    Callback = function(state)
        autoReviveEnabled = state
        if autoReviveEnabled then
            print("[DYHUB] Auto Revive Enabled")
        else
            print("[DYHUB] Auto Revive Disabled")
        end
    end
})

RunService.Heartbeat:Connect(function()
    if autoReviveEnabled then
        if tick() - lastCheckTime >= checkInterval then
            lastCheckTime = tick()
            local player = LocalPlayer
            local character = player.Character
            if character and character:GetAttribute("Downed") then
                ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                print("[DYHUB] ✅ Auto-Revived!")
            end
        end
    end
end)

MiscTab:Toggle({
    Title = "Anti Bypassing (By rhy)",
    Default = true,
    Callback = function(state)
        AntiBypass = state
        if state then
            print("[DYHUB] Anti Bypassing Enabled (Hidden)")
        else
            print("[DYHUB] Anti Bypassing Disabled")
        end
    end
})

MiscTab:Toggle({
    Title = "Anti Teleport (By rhy)",
    Default = true,
    Callback = function(state)
        AntiTp = state
        if state then
            print("[DYHUB] Anti Teleport Enabled")
        else
            print("[DYHUB] Anti Teleport Disabled")
        end
    end
})

MiscTab:Toggle({
    Title = "Anti AFK",
    Default = true,
    Callback = function(state)
        AntiAfkEnabled = state
        if state then
            print("[DYHUB] Anti AFK Enabled")
        else
            print("[DYHUB] Anti AFK Disabled")
        end
    end
})

local FullbrightEnabled = false
local NoFogEnabled = false
local SuperFullBrightnessEnabled = false
local VibrantEnabled = false

local originalBrightness = game.Lighting.Brightness
local originalOutdoorAmbient = game.Lighting.OutdoorAmbient
local originalAmbient = game.Lighting.Ambient
local originalGlobalShadows = game.Lighting.GlobalShadows
local originalFogEnd = game.Lighting.FogEnd
local originalFogStart = game.Lighting.FogStart
local originalFogColor = game.Lighting.FogColor
local originalColorCorrectionEnabled = game.Lighting.ColorCorrection.Enabled
local originalSaturation = game.Lighting.ColorCorrection.Saturation
local originalContrast = game.Lighting.ColorCorrection.Contrast

local function applyFullBrightness()
    game.Lighting.Brightness = 2
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.GlobalShadows = false
end

local function removeFullBrightness()
    game.Lighting.Brightness = originalBrightness
    game.Lighting.OutdoorAmbient = originalOutdoorAmbient
    game.Lighting.Ambient = originalAmbient
    game.Lighting.GlobalShadows = originalGlobalShadows
end

local function applySuperFullBrightness()
    game.Lighting.Brightness = 5
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.GlobalShadows = false
end

local function applyNoFog()
    game.Lighting.FogEnd = 1000000
    game.Lighting.FogStart = 999999
end

local function removeNoFog()
    game.Lighting.FogEnd = originalFogEnd
    game.Lighting.FogStart = originalFogStart
end

local function applyVibrant()
    game.Lighting.ColorCorrection.Enabled = true
    game.Lighting.ColorCorrection.Saturation = 0.5
    game.Lighting.ColorCorrection.Contrast = 0.2
end

local function removeVibrant()
    game.Lighting.ColorCorrection.Enabled = originalColorCorrectionEnabled
    game.Lighting.ColorCorrection.Saturation = originalSaturation
    game.Lighting.ColorCorrection.Contrast = originalContrast
end

MiscTab:Toggle({
    Title = "Full Brightness",
    Default = false,
    Callback = function(state)
        FullbrightEnabled = state
        if state then
            applyFullBrightness()
        else
            removeFullBrightness()
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        NoFogEnabled = state
        if state then
            applyNoFog()
        else
            removeNoFog()
        end
    end
})

MiscTab:Toggle({
    Title = "Super Full Brightness",
    Default = false,
    Callback = function(state)
        SuperFullBrightnessEnabled = state
        if state then
            applySuperFullBrightness()
        else
            removeFullBrightness()
        end
    end
})

MiscTab:Toggle({
    Title = "Vibrant +200%",
    Default = false,
    Callback = function(state)
        VibrantEnabled = state
        if state then
            applyVibrant()
        else
            removeVibrant()
        end
    end
})

if FullbrightEnabled then
    applyFullBrightness()
end
if NoFogEnabled then
    applyNoFog()
end
if SuperFullBrightnessEnabled then
    applySuperFullBrightness()
end
if VibrantEnabled then
    applyVibrant()
end

-- ========= Skull Tab =======
local WhiteModeEnabled = false

local function getLocalPlayerCharacter()
    local player = Players.LocalPlayer
    if player then
        return player.Character or player.CharacterAdded:Wait()
    end
    return nil
end

function ApplyWhiteModeToCharacter()
    local myCharacter = getLocalPlayerCharacter()

    if myCharacter and WhiteModeEnabled then
        myCharacter:SetOutlineColor(Color.White)
        myCharacter:EnableOutline(true)
        myCharacter:SetMaterial("SolidWhiteMaterial")
        myCharacter:SetTintColor(Color.RGB(255, 255, 255))
        myCharacter:SetTransparency(0)
        myCharacter:SetRenderMode("UnlitSolidColor")
    end
end

function RemoveWhiteModeFromCharacter()
    local myCharacter = getLocalPlayerCharacter()

    if myCharacter then
        myCharacter:EnableOutline(false)
        myCharacter:ResetMaterial()
        myCharacter:SetTintColor(Color.None)
        myCharacter:SetTransparency(0)
        myCharacter:SetRenderMode("Default")
    end
end

SkullTab:Toggle({
    Title = "Anti Nigga",
    Default = false,
    Callback = function(state)
        WhiteModeEnabled = state
        if state then
            ApplyWhiteModeToCharacter()
        else
            RemoveWhiteModeFromCharacter()
        end
    end
})

Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if WhiteModeEnabled then
        task.wait(0.1)
        ApplyWhiteModeToCharacter()
    end
end)

if WhiteModeEnabled then
    ApplyWhiteModeToCharacter()
end

--- ====== Fake Tab ======
local headlessEnabled = false
local korbloxEnabled = false

local KORBLOX_RIGHT_LEG_ID = 139607718

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

local function getLocalPlayerCharacter()
    local player = Players.LocalPlayer
    if player then
        return player.Character or player.CharacterAdded:Wait()
    end
    return nil
end

local function applyHeadless()
    local character = getLocalPlayerCharacter()
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 1
            local face = head:FindFirstChildOfClass("Decal")
            if face then
                face.Transparency = 1
            end
            local mesh = head:FindFirstChildOfClass("SpecialMesh") or head:FindFirstChildOfClass("CylinderMesh")
            if mesh then
                mesh.MeshId = ""
            end
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("Accessory") and child.AccessoryType == Enum.AccessoryType.Face then
                    child.Handle.Transparency = 1
                end
            end
        end
    end
end

local function removeHeadless()
    local character = getLocalPlayerCharacter()
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            local face = head:FindFirstChildOfClass("Decal")
            if face then
                face.Transparency = 0
            end
        end
    end
end

local loadedKorbloxAccessory = nil

local function applyKorbloxRightLeg()
    local character = getLocalPlayerCharacter()
    if character and character:FindFirstChildOfClass("Humanoid") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if loadedKorbloxAccessory and loadedKorbloxAccessory.Parent == character then
            return
        end

        local success, asset = pcall(function()
            return InsertService:LoadAsset(KORBLOX_RIGHT_LEG_ID)
        end)

        if success and asset then
            local accessory = asset:FindFirstChildOfClass("Accessory")
            if accessory then
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Accessory") and child.Name == "Right Leg" then
                        child:Destroy()
                    end
                end
                humanoid:AddAccessory(accessory)
                loadedKorbloxAccessory = accessory
            end
        end
    end
end

local function removeKorbloxRightLeg()
    local character = getLocalPlayerCharacter()
    if character then
        if loadedKorbloxAccessory and loadedKorbloxAccessory.Parent == character then
            loadedKorbloxAccessory:Destroy()
            loadedKorbloxAccessory = nil
        else
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") and child.Handle and child.Handle:FindFirstChildOfClass("SpecialMesh") then
                    if child.Handle:FindFirstChildOfClass("SpecialMesh").MeshId == "rbxassetid://" .. KORBLOX_RIGHT_LEG_ID then
                        child:Destroy()
                    end
                end
            end
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local originalDescription = Players:GetHumanoidDescriptionFromUserId(Players.LocalPlayer.UserId)
            local newDescription = originalDescription:Clone()
            humanoid:ApplyDescription(newDescription)
        end
    end
end

local function removeAllHats()
    local character = getLocalPlayerCharacter()
    if character then
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Accessory") and (child.AccessoryType == Enum.AccessoryType.Hat or child.AccessoryType == Enum.AccessoryType.Hair or child.AccessoryType == Enum.AccessoryType.Face or child.AccessoryType == Enum.AccessoryType.Neck or child.AccessoryType == Enum.AccessoryType.Shoulder or child.AccessoryType == Enum.AccessoryType.Front or child.AccessoryType == Enum.AccessoryType.Back or child.AccessoryType == Enum.AccessoryType.Waist) then
                child:Destroy()
            end
        end
    end
end

FakeTab:Dropdown({
    Title = "Fake Bundle (Visual)",
    Options = {"Headless", "Korblox"},
    Multi = true,
    Callback = function(values)
        if table.find(values, "Headless") and not headlessEnabled then
            headlessEnabled = true
            applyHeadless()
        elseif not table.find(values, "Headless") and headlessEnabled then
            headlessEnabled = false
            removeHeadless()
        end

        if table.find(values, "Korblox") and not korbloxEnabled then
            korbloxEnabled = true
            applyKorbloxRightLeg()
        elseif not table.find(values, "Korblox") and korbloxEnabled then
            korbloxEnabled = false
            removeKorbloxRightLeg()
        end
    end
})

FakeTab:Button({
    Title = "Remove All Hats",
    Callback = function()
        removeAllHats()
    end
})

Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if headlessEnabled then
        task.wait(0.1)
        applyHeadless()
    end
    if korbloxEnabled then
        task.wait(0.1)
        applyKorbloxRightLeg()
    end
})

if Players.LocalPlayer.Character then
    if headlessEnabled then
        applyHeadless()
    end
    if korbloxEnabled then
        applyKorbloxRightLeg()
    end
end

--- ====== Vote Tab ======
local selectedMapNumber = 1 -- Default selected map
local autoVoteEnabled = false
local voteConnection = nil

local function fireVoteServer(mapNumber)
    local voteEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("Vote")
    local args = {
        [1] = mapNumber
    }
    voteEvent:FireServer(unpack(args))
end

VoteTab:Dropdown({
    Title = "Select Map",
    Options = {"Map 1", "Map 2", "Map 3", "Map 4"},
    Default = "Map 1",
    Callback = function(value)
        if value == "Map 1" then
            selectedMapNumber = 1
        elseif value == "Map 2" then
            selectedMapNumber = 2
        elseif value == "Map 3" then
            selectedMapNumber = 3
        elseif value == "Map 4" then
            selectedMapNumber = 4
        end
    end
})

VoteTab:Toggle({
    Title = "Vote",
    Default = false,
    Callback = function(state)
        if state then
            fireVoteServer(selectedMapNumber)
        end
    end
})

VoteTab:Toggle({
    Title = "Auto Vote",
    Default = false,
    Callback = function(state)
        autoVoteEnabled = state
        if autoVoteEnabled then
            voteConnection = game:GetService("RunService").Heartbeat:Connect(function()
                fireVoteServer(selectedMapNumber)
            end)
        else
            if voteConnection then
                voteConnection:Disconnect()
                voteConnection = nil
            end
        end
    end
})
