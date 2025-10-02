-- ======================
local version = "5.2.7"
-- ======================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
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

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local InsertService = game:GetService("InsertService") -- Make sure InsertService is defined
local StarterGui = game:GetService("StarterGui")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local FreeVersion = "Free Version"
local PremiumVersion = "Premium Version"

local function checkVersion(playerName)
    local url = "https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua"

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        return FreeVersion
    end

    local premiumData
    local func, err = loadstring(response)
    if func then
        premiumData = func()
    else
        return FreeVersion
    end

    if premiumData[playerName] then
        return PremiumVersion
    else
        return FreeVersion
    end
end

local player = Players.LocalPlayer
local userversion = checkVersion(player.Name)

local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Evade | " .. userversion,
    Folder = "DYHUB_EVADE",
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

--- Add UI Elements to GameTab ---

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local GameTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local MainlolkilDivider = Window:Divider()
local FakeTab = Window:Tab({ Title = "Other", Icon = "sparkles" })
local ReviveTab = Window:Tab({ Title = "Revive", Icon = "shield-plus" })
local MainlolDivider = Window:Divider()
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })
Window:SelectTab(1)

local headlessEnabled = false
local korbloxEnabled = false

local FullbrightEnabled = false
local NoFogEnabled = false
local SuperFullBrightnessEnabled = false
local VibrantEnabled = false

local ActiveAutoWin = false
local ActiveAutoFarmMoney = false
local AutoFarmSummerEvent = false
local AntiAfkEnabled = true
local AntiTp = true
local AntiBypass = true

local ValueSpeed = 16 
local ActiveCFrameSpeedBoost = false
local OriginalWalkSpeed = 16 

local cframeSpeedConnection = nil

PlayerTab:Section({ Title = "Feature Player", Icon = "rabbit" })

PlayerTab:Input({
    Title = "Set Base Speed",
    Placeholder = "Ex: 100",
    onChanged = function(value)
        local num = tonumber(value)
        if num and num >= 1 and num <= 5000 then
            ValueSpeed = num
            print("[DYHUB] Speed value set to: " .. ValueSpeed)
            if ActiveWalkSpeedBoost and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed
            end
        else
            ValueSpeed = 16 
            print("[DYHUB] Invalid speed value. Please enter a number between 1 and 100. Reverted to 16.")
        end
    end
})

PlayerTab:Toggle({
    Title = "Speed Boost (Cframe)",
    Callback = function(state)
        ActiveCFrameSpeedBoost = state
        if ActiveCFrameSpeedBoost then
            print("[DYHUB] CFrame Speed Boost Enabled!")
            
            if cframeSpeedConnection then
                cframeSpeedConnection:Disconnect()
                cframeSpeedConnection = nil
            end

            cframeSpeedConnection = RunService.RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local hrp = character and character:FindFirstChild("HumanoidRootPart")

                if character and humanoid and hrp then
                    local moveDir = humanoid.MoveDirection
                    if moveDir.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + moveDir * math.max(ValueSpeed, 1) * 0.080
                    end
                end
            end)
        else
            print("[DYHUB] CFrame Speed Boost Disabled!")
            if cframeSpeedConnection then
                cframeSpeedConnection:Disconnect()
                cframeSpeedConnection = nil
            end
        end
    end
})

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
    game.Lighting.Brightness = 15
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
    game.Lighting.ColorCorrection.Saturation = 0.8
    game.Lighting.ColorCorrection.Contrast = 0.4
end

local function removeVibrant()
    game.Lighting.ColorCorrection.Enabled = originalColorCorrectionEnabled
    game.Lighting.ColorCorrection.Saturation = originalSaturation
    game.Lighting.ColorCorrection.Contrast = originalContrast
end

local afk = true

MiscTab:Section({ Title = "Miscellaneous", Icon = "settings" })

MiscTab:Toggle({
    Title = "Anti-AFK",
    Default = true,
    Callback = function(state)
        afk = state -- อัปเดตตัวแปรหลัก
        if state then
            task.spawn(function()
                while afk do
                    if not LocalPlayer then return end
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(60)
                end
            end)
        else
            print("[DYHUB] Anti-AFK disabled.")
        end
    end
})

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

MiscTab:Section({ Title = "FPS Boost", Icon = "cpu" })

local originalValues = {}

MiscTab:Toggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(state)
        if state then
            for _, v in pairs(game:GetDescendants()) do
                if v and v:IsA("BasePart") then
                    originalValues[v] = {
                        Material = v.Material,
                        Reflectance = v.Reflectance
                    }
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v and v:IsA("Decal") then
                    originalValues[v] = {
                        Transparency = v.Transparency
                    }
                    v.Transparency = 1
                end
            end
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            print("[DYHUB] FPS Boost enabled!")
        else
            for v, vals in pairs(originalValues) do
                if v and v:IsA("BasePart") and vals.Material and vals.Reflectance then
                    v.Material = vals.Material
                    v.Reflectance = vals.Reflectance
                elseif v and v:IsA("Decal") and vals.Transparency then
                    v.Transparency = vals.Transparency
                end
            end
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end)
            print("[DYHUB] FPS Boost disabled.")
        end
    end
})

GameTab:Section({ Title = "Auto Farm", Icon = "star" })

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
                            securityPart.CanCollide = true
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
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            print("[DYHUB] Revived for Auto Farm-Money!")
                            task.wait(0.5)
                        end

                        local downedPlayerFound = false
                        local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                        if playersInGame then
                            for _, v in pairs(playersInGame:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                    rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
                                    print("[DYHUB] Reviving player for Farm Money!")
                                    task.wait(0.5)
                                    downedPlayerFound = true
                                    break
                                end
                            end
                        end

                        if not downedPlayerFound then
                            print("[DYHUB] ⚠️ No downed player found for Auto Farm Money, waiting...")
                        end

                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = true
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)

                    else
                        print("[DYHUB] Character or HumanoidRootPart not found, waiting for spawn.")
                    end
                    task.wait(1)
                end
            end)
        else
            print("[DYHUB] Auto Farm Money Disabled!")
        end
    end
})

GameTab:Toggle({
    Title = "Auto Farm Ticket",
    Callback = function(state)
        AutoFarmSummerEvent = state
        if AutoFarmSummerEvent then
            print("[DYHUB] Auto Farm Ticket Event Enabled!")
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
                            securityPart.CanCollide = true
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

local function fireVoteServer(selectedMapNumber)
    local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
    if eventsFolder then
        local playerFolder = eventsFolder:WaitForChild("Player", 10)
        if playerFolder then
            local voteEvent = playerFolder:WaitForChild("Vote", 10)
            if voteEvent and typeof(voteEvent) == "Instance" and voteEvent:IsA("RemoteEvent") then
                local args = {
                    [1] = selectedMapNumber
                }
                voteEvent:FireServer(unpack(args))
            else
                warn("Vote RemoteEvent not found or is not a RemoteEvent.")
            end
        else
            warn("Player folder not found under Events.")
        end
    else
        warn("Events folder not found in ReplicatedStorage.")
    end
end

local selectedMapNumber = 1
local autoVoteEnabled = false
local voteConnection = nil

GameTab:Section({ Title = "Feature Vote", Icon = "badge-check" })

GameTab:Dropdown({
    Title = "Select Map",
    Values = {"1", "2", "3", "4"},
    Callback = function(value)
            selectedMapNumber = value
        end
    end
})

GameTab:Button({
    Title = "Vote!",
    Callback = function()
        fireVoteServer(selectedMapNumber)
    end
})

GameTab:Toggle({
    Title = "Auto Vote",
    Callback = function(state)
        autoVoteEnabled = state
        if autoVoteEnabled then
            if not voteConnection then
                voteConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    fireVoteServer(selectedMapNumber)
                end)
            end
        else
            if voteConnection then
                voteConnection:Disconnect()
                voteConnection = nil
            end
        end
    end
})

local loopFakeBundleConnection = nil
local loopFakeBundleEnabled = false
local Niggastats = true
local Admin = true

MiscTab:Section({ Title = "Feature Anti", Icon = "shield" })

MiscTab:Toggle({
    Title = "Anti-Lagging",
    Callback = function(state)
        Niggastats = state
        print("[DYHUB] Anti-Lagging")
    end
})

MiscTab:Toggle({
    Title = "Anti-Admin",
    Default = true,
    Callback = function(state)
        Admin = state -- อัปเดตตัวแปรหลัก
        if state then
            task.spawn(function()
                while Admin do
                    if not LocalPlayer then return end
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(60)
                end
            end)
        else
            print("[DYHUB] Anti-Admin disabled.")
        end
    end
})

local KORBLOX_RIGHT_LEG_ID = 139607718

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
            -- Re-apply original head mesh/appearance by applying the humanoid description
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local originalDescription = Players:GetHumanoidDescriptionFromUserId(Players.LocalPlayer.UserId)
                if originalDescription then
                    humanoid:ApplyDescription(originalDescription)
                end
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
            return -- Already applied
        end

        local success, asset = pcall(function()
            return InsertService:LoadAsset(KORBLOX_RIGHT_LEG_ID)
        end)

        if success and asset then
            local accessory = asset:FindFirstChildOfClass("Accessory")
            if accessory then
                -- Remove existing right leg accessories to prevent duplicates or conflicts
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Accessory") and child.Name == "Right Leg" then
                        child:Destroy()
                    end
                end
                humanoid:AddAccessory(accessory)
                loadedKorbloxAccessory = accessory
            end
        else
            warn("Failed to load Korblox Right Leg asset: " .. (asset or "Unknown error"))
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
            -- Fallback: if loadedKorbloxAccessory wasn't tracked, try to find and destroy by MeshId
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
            -- Re-apply the original character description to restore the default leg
            local originalDescription = Players:GetHumanoidDescriptionFromUserId(Players.LocalPlayer.UserId)
            if originalDescription then
                humanoid:ApplyDescription(originalDescription)
            end
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

FakeTab:Section({ Title = "Feature Visual", Icon = "gem" })

FakeTab:Dropdown({
    Title = "Fake Bundle (Visual)",
    Values = {"Headless", "Korblox (Bugs)"},
    Multi = true,
    Callback = function(values)
        if table.find(values, "Headless") and not headlessEnabled then
            headlessEnabled = true
            applyHeadless()
        elseif not table.find(values, "Headless") and headlessEnabled then
            headlessEnabled = false
            removeHeadless()
        end

        if table.find(values, "Korblox (Fixing)") and not korbloxEnabled then
            korbloxEnabled = true
            applyKorbloxRightLeg()
        elseif not table.find(values, "Korblox (Fixing)") and korbloxEnabled then
            korbloxEnabled = false
            removeKorbloxRightLeg()
        end
    end
})

FakeTab:Toggle({
    Title = "Loop Fake Bundle",
    Callback = function(state)
        loopFakeBundleEnabled = state
        if loopFakeBundleEnabled then
            if not loopFakeBundleConnection then
                loopFakeBundleConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    applyKorbloxRightLeg()
                    applyHeadless()
                end)
            end
        else
            if loopFakeBundleConnection then
                loopFakeBundleConnection:Disconnect()
                loopFakeBundleConnection = nil
            end
        end
    end
})

local removeAllHatw = false

FakeTab:Toggle({
    Title = "Remove All Hats",
    Callback = function(state)
        removeAllHatw = state
        if state then
            removeAllHats()
        end
    end
}) 

Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if headlessEnabled then
        task.wait(0.1) -- Small delay to ensure character fully loads
        applyHeadless()
    end
    if korbloxEnabled then
        task.wait(0.1) -- Small delay
        applyKorbloxRightLeg()
    end
end)

-- ===== Esp Tab
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

-- Function to handle creating ESP for a single player
local function handlePlayerEsp(player)
    if player ~= LocalPlayer and player.Character then
        local function createPlayerEspOnCharacter(character)
            if ActiveEspPlayers and character:FindFirstChild("Head") then
                CreateEsp(character, Color3.fromRGB(0, 255, 0), player.Name, character.Head, 1)
            end
        end

        -- Check current character
        createPlayerEspOnCharacter(player.Character)

        -- Connect to CharacterAdded for respawns
        player.CharacterAdded:Connect(function(newCharacter)
            task.wait(0.1) -- Small delay for character to fully load
            createPlayerEspOnCharacter(newCharacter)
        end)

        -- Connect to CharacterRemoving to clean up ESP when character is destroyed
        player.CharacterRemoving:Connect(function(oldCharacter)
            if oldCharacter:FindFirstChild("Head") then
                RemoveEsp(oldCharacter, oldCharacter.Head)
            end
        end)
    end
end

-- Store connections to disconnect them cleanly
local playerAddedConnection = nil
local playerRemovingConnections = {}
local characterAddedConnections = {}
local characterRemovingConnections = {}
local botLoopConnection = nil
local summerEventLoopConnection = nil

EspTab:Section({ Title = "Feature ESP", Icon = "eye" })

EspTab:Toggle({
    Title = "Players ESP",
    Callback = function(state)
        ActiveEspPlayers = state
        if ActiveEspPlayers then
            print("[DYHUB] Players ESP Enabled!")
            -- Apply ESP to all existing players
            for _, plr in pairs(Players:GetPlayers()) do
                handlePlayerEsp(plr)
            end

            -- Connect to PlayerAdded for new players
            playerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
                handlePlayerEsp(newPlayer)
            end)

            -- Connect to PlayerRemoving to clean up ESP for leaving players
            playerRemovingConnections[playerAddedConnection] = Players.PlayerRemoving:Connect(function(leavingPlayer)
                if leavingPlayer.Character and leavingPlayer.Character:FindFirstChild("Head") then
                    RemoveEsp(leavingPlayer.Character, leavingPlayer.Character.Head)
                end
            end)

        else
            print("[DYHUB] Players ESP Disabled!")
            -- Disconnect PlayerAdded listener
            if playerAddedConnection then
                playerAddedConnection:Disconnect()
                playerAddedConnection = nil
            end
            -- Disconnect PlayerRemoving listener
            if playerRemovingConnections[playerAddedConnection] then
                playerRemovingConnections[playerAddedConnection]:Disconnect()
                playerRemovingConnections[playerAddedConnection] = nil
            end
            
            -- Remove ESP from all current players
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    RemoveEsp(plr.Character, plr.Character.Head)
                end
            end
        end
    end
})

EspTab:Toggle({
    Title = "NextBots ESP",
    Callback = function(state)
        ActiveEspBots = state
        if ActiveEspBots then
            print("[DYHUB] NextBots ESP Enabled!")
            botLoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local botsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                if botsFolder then
                    for _, bot in pairs(botsFolder:GetChildren()) do
                        if bot:IsA("Model") and bot:FindFirstChild("Hitbox") then
                            bot.Hitbox.Transparency = 0.5
                            CreateEsp(bot, Color3.fromRGB(255, 0, 0), bot.Name, bot.Hitbox, -2)
                        end
                    end
                end
            end)
        else
            print("[DYHUB] NextBots ESP Disabled!")
            if botLoopConnection then
                botLoopConnection:Disconnect()
                botLoopConnection = nil
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
        end
    end
})

EspTab:Toggle({
    Title = "Tickets ESP",
    Callback = function(state)
        ActiveEspSummerEvent = state
        if ActiveEspSummerEvent then
            print("[DYHUB] Summer Event ESP Enabled!")
            summerEventLoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local ticketsFolder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Effects") and Workspace.Game.Effects:FindFirstChild("Tickets")
                if ticketsFolder then
                    for _, ticket in pairs(ticketsFolder:GetChildren()) do
                        if ticket and ticket.PrimaryPart and ticket.Name == "Visual" then
                            CreateEsp(ticket, Color3.fromRGB(255, 255, 0), "Ticket", ticket.PrimaryPart, -2)
                        end
                    end
                end
            end)
        else
            print("[DYHUB] Summer Event ESP Disabled!")
            if summerEventLoopConnection then
                summerEventLoopConnection:Disconnect()
                summerEventLoopConnection = nil
            end
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

EspTab:Section({ Title = "Setting ESP", Icon = "settings" })

EspTab:Toggle({
    Title = "Show Distance",
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

ReviveTab:Section({ Title = "Feature Revive", Icon = "cross" })

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

Info = InfoTab

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
