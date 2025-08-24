repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Steal A Brainrot",
    Icon = "star",
    IconThemed = true,
    Content = "Join us at (https://dsc.gg/dyhub)",
    Buttons = {
        {
            Title = "Cancel",
            Variant = "Secondary",
            Callback = function()
                game.Players.LocalPlayer:Kick("FUCK YOU NIGGA CANCEL DYHUB????")
            end
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                Confirmed = true
            end
        }
    }
})

repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Folder = "DYHUB Scripts - SAB",
    Title = "DYHUB | Steal A Brainrot",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 3.17",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Transparent = false,
    HasOutline = true,
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

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    Hide = Window:Tab({ Title = "Visual", Icon = "eye-off" }),
    Jump = Window:Tab({ Title = "Shop", Icon = "shopping-basket" }),
    Random = Window:Tab({ Title = "Random Features", Icon = "dices" }),
    Brainrot = Window:Tab({ Title = "Brainrot Finder", Icon = "brain" }),
}

Window:SelectTab(Tabs.Main)

Tabs.Main:Button({
    Title = "Steal Helper (Collab)",
    Desc = "Opens Up A New Small Gui To Help Steal",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/erewe23/uitest.github.io/refs/heads/main/ere.lua"))()
    end,
})

local antiTrapGoodEnabled = false
local antiTrapGoodScript

Tabs.Main:Toggle({
    Title = "Anti Trap",
    Desc = "Removes trap hitboxes",
    Value = false,
    Callback = function(state)
        antiTrapGoodEnabled = state
        if state then
            if not antiTrapGoodScript then
                local BATCH_SIZE = 250
                local SEARCH_TRAPS_IN_GAME = false

                local function shouldRemoveTrapTouch(tt)
                    if not (tt:IsA("TouchTransmitter") and tt.Name == "TouchInterest") then return false end
                    local p = tt.Parent
                    if not (p and p:IsA("MeshPart") and p.Name == "Open") then return false end
                    local m = p:FindFirstAncestorOfClass("Model")
                    if not (m and m.Name == "Trap") then return false end
                    return true
                end

                local function removeTrapTouch(tt)
                    if tt.Parent then
                        tt:Destroy()
                    end
                end

                task.defer(function()
                    local root = SEARCH_TRAPS_IN_GAME and game or workspace
                    local all = root:GetDescendants()
                    for i = 1, #all do
                        local o = all[i]
                        if o:IsA("TouchTransmitter") and shouldRemoveTrapTouch(o) then
                            removeTrapTouch(o)
                        end
                        if i % BATCH_SIZE == 0 then task.wait() end
                    end
                end)

                workspace.DescendantAdded:Connect(function(obj)
                    if obj:IsA("TouchTransmitter") and shouldRemoveTrapTouch(obj) then
                        removeTrapTouch(obj)
                    end
                end)

                antiTrapGoodScript = true
            end
        else
            antiTrapGoodScript = nil
        end
    end
})






Tabs.Main:Section({Title = "Speed"})






local speedBoostEnabled = false
local speedConn = nil
local DEFAULT_SPEED = 16
local BOOSTED_SPEED = 50

Tabs.Main:Toggle({
    Title = "Boost Speed",
    Value = false,
    Callback = function(Value)
        speedBoostEnabled = Value
        if speedConn then
            speedConn:Disconnect()
            speedConn = nil
        end
        if Value then
            speedConn = RunService.Heartbeat:Connect(function()
                if not _G._lastSpeedBoostUpdate or (tick() - _G._lastSpeedBoostUpdate) >= 0.1 then
                    local character = LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
                            local moveDir = humanoid.MoveDirection
                            rootPart.Velocity = Vector3.new(
                                moveDir.X * BOOSTED_SPEED,
                                rootPart.Velocity.Y,
                                moveDir.Z * BOOSTED_SPEED
                            )
                        end
                    end
                    _G._lastSpeedBoostUpdate = tick()
                end
            end)
        end
    end
})




Tabs.Main:Section({Title = "AntiSteal"})

Tabs.Main:Button({
    Title = "Antisteal (OP)",
    Desc = "Leaves Game When Someone Enters Base",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/34wefwef/antisteal.github.io/refs/heads/main/ere.lua"))()
    end,
})




local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local infJumpEnabled = false
local lastJumpTime = 0
local COOLDOWN = 0.5
local JUMP_FORCE = 50
local JUMP_DURATION = 0.2

local function safeAirJump()
    if not infJumpEnabled then return end
    local now = os.clock()
    if now - lastJumpTime < COOLDOWN then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    lastJumpTime = now
    if rootPart:CanSetNetworkOwnership() then
        rootPart:SetNetworkOwner(LocalPlayer)
    end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Velocity = Vector3.new(0, JUMP_FORCE, 0)
    bodyVelocity.Parent = rootPart
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if os.clock() - lastJumpTime >= JUMP_DURATION then
            bodyVelocity:Destroy()
            if rootPart:CanSetNetworkOwnership() then
                rootPart:SetNetworkOwner(nil)
            end
            connection:Disconnect()
        end
    end)
end

Tabs.Hide:Toggle({
    Title = "Infinite Jump (KINDA BUGGY)",
    Value = false,
    Callback = function(Value)
        infJumpEnabled = Value
        if Value then
            UserInputService.JumpRequest:Connect(safeAirJump)
        end
    end
})


Tabs.Hide:Section({Title = "ESP"})





local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false
local espUpdateConn = nil

local function addHighlightToCharacter(char)
    if not char or char == LocalPlayer.Character or char:FindFirstChild("HighlightESP") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "HighlightESP"
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0.5
    highlight.FillColor = Color3.new(0, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
end

local function removeHighlightFromCharacter(char)
    local highlight = char and char:FindFirstChild("HighlightESP")
    if highlight then
        highlight:Destroy()
    end
end

local function enableESP()
    if espEnabled then return end
    espEnabled = true
    espUpdateConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not espEnabled then return end
        if not _G._lastESPUpdate or (tick() - _G._lastESPUpdate) >= 0.1 then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    addHighlightToCharacter(player.Character)
                end
            end
            _G._lastESPUpdate = tick()
        end
    end)
end

local function disableESP()
    if not espEnabled then return end
    espEnabled = false
    if espUpdateConn then
        espUpdateConn:Disconnect()
        espUpdateConn = nil
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            removeHighlightFromCharacter(player.Character)
        end
    end
end

Tabs.Hide:Toggle({
    Title = "Player ESP",
    Value = false,
    Callback = function(state)
        if state then
            enableESP()
        else
            disableESP()
        end
    end
})







Tabs.Hide:Button({
    Title = "Esp Most Expensive Brainrot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/34t34t33/mostexpensive.github.io/refs/heads/main/rare.lua"))()
    end,
})





local plotTimers_Enabled = false
local plotTimers_RenderConnection = nil
local plotTimers_OriginalProperties = {}

local function disablePlotTimers()
    plotTimers_Enabled = false
    if plotTimers_RenderConnection then
        plotTimers_RenderConnection:Disconnect()
        plotTimers_RenderConnection = nil
    end
    for label, props in pairs(plotTimers_OriginalProperties) do
        pcall(function()
            if label and label.Parent then
                local bb = label:FindFirstAncestorWhichIsA("BillboardGui")
                if bb and bb.Parent then
                    bb.Enabled = props.bb_enabled
                    bb.AlwaysOnTop = props.bb_alwaysOnTop
                    bb.Size = props.bb_size
                    bb.MaxDistance = props.bb_maxDistance
                    label.TextScaled = props.label_textScaled
                    label.TextWrapped = props.label_textWrapped
                    label.AutomaticSize = props.label_automaticSize
                    label.Size = props.label_size
                    label.TextSize = props.label_textSize
                end
            end
        end)
    end
    table.clear(plotTimers_OriginalProperties)
end

local function enablePlotTimers()
    disablePlotTimers()
    plotTimers_Enabled = true
    local camera = workspace.CurrentCamera
    local DISTANCE_THRESHOLD = 45
    local SCALE_START, SCALE_RANGE = 100, 300
    local MIN_TEXT_SIZE, MAX_TEXT_SIZE = 30, 36
    local lastUpdate = 0

    plotTimers_RenderConnection = RunService.RenderStepped:Connect(function()
        if not plotTimers_Enabled then return end
        if tick() - lastUpdate < 0.1 then return end
        lastUpdate = tick()

        for _, label in ipairs(workspace.Plots:GetDescendants()) do
            if label:IsA("TextLabel") and label.Name == "RemainingTime" then
                local bb = label:FindFirstAncestorWhichIsA("BillboardGui")
                if not bb then continue end
                local model = bb:FindFirstAncestorWhichIsA("Model")
                if not model then continue end
                local basePart = model:FindFirstChildWhichIsA("BasePart", true)
                if not basePart then continue end
                if not plotTimers_OriginalProperties[label] then
                    plotTimers_OriginalProperties[label] = {
                        bb_enabled = bb.Enabled,
                        bb_alwaysOnTop = bb.AlwaysOnTop,
                        bb_size = bb.Size,
                        bb_maxDistance = bb.MaxDistance,
                        label_textScaled = label.TextScaled,
                        label_textWrapped = label.TextWrapped,
                        label_automaticSize = label.AutomaticSize,
                        label_size = label.Size,
                        label_textSize = label.TextSize,
                    }
                end
                bb.MaxDistance = 10000
                bb.AlwaysOnTop = true
                bb.ClipsDescendants = false
                bb.Size = UDim2.new(0, 300, 0, 150)
                label.TextScaled = false
                label.TextWrapped = true
                label.ClipsDescendants = false
                label.Size = UDim2.new(1, 0, 0, 32)
                label.AutomaticSize = Enum.AutomaticSize.Y

                local distance = (camera.CFrame.Position - basePart.Position).Magnitude
                if distance > DISTANCE_THRESHOLD and basePart.Position.Y >= 0 then
                    bb.Enabled = false
                else
                    bb.Enabled = true
                    local t = math.clamp((distance - SCALE_START) / SCALE_RANGE, 0, 1)
                    local newTextSize = math.clamp(MIN_TEXT_SIZE + (MAX_TEXT_SIZE - MIN_TEXT_SIZE) * t, MIN_TEXT_SIZE, MAX_TEXT_SIZE)
                    label.TextSize = newTextSize
                    label.Size = UDim2.new(1, 0, 0, newTextSize + 6)
                end
            end
        end
    end)
end

Tabs.Hide:Toggle({
    Title = "View Base Lock Timers",
    Value = false,
    Callback = function(state)
        if state then
            enablePlotTimers()
        else
            disablePlotTimers()
        end
    end
})








Tabs.Jump:Section({Title = "Buy Items"})

local itemList = {
    "Slap",
    "Speed Coil",
    "Trap",
    "Iron Slap",
    "Gravity Coil",
    "Bee Launcher",
    "Gold Slap",
    "Coil Combo",
    "Rage Table",
    "Diamond Slap",
    "Grapple Hook",
    "Taser Gun",
    "Emerald Slap",
    "Invisibility Cloak",
    "Boogie Bomb",
    "Ruby Slap",
    "Medusa's Head",
    "Dark Matter Slap",
    "Web Slinger",
    "Flame Slap",
    "Quantum Cloner",
    "All Seeing Sentry",
    "Nuclear Slap",
    "Rainbowrath Sword",
    "Body Swap Potion",
    "Splatter Slap",
    "Paintball Gun"
}

local autobuy_selected = {}

Tabs.Jump:Dropdown({
    Title = "Select Which Items To Auto Buy",
    Values = itemList,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        autobuy_selected = selected
    end
})

Tabs.Jump:Button({
    Title = "Auto Buy Selected Items",
    Callback = function()
        for _, item in ipairs(autobuy_selected) do
            local args = { item }
            game:GetService("ReplicatedStorage")
                :WaitForChild("Packages")
                :WaitForChild("Net")
                :WaitForChild("RF/CoinsShopService/RequestBuy")
                :InvokeServer(unpack(args))
            wait(0.3)
        end
    end
})








Tabs.Random:Section({Title = "Server"})

-- Paragraph: Copy id
Tabs.Random:Paragraph({
    Title = "Copy id",
    Desc = game.JobId,
    Buttons = {
        {
            Title = "Copy",
            Callback = function()
                setclipboard(game.JobId)
            end
        }
    }
})

-- Input: Enter Job Id
Tabs.Random:Input({
    Title = "Enter Job Id",
    Callback = function(value)
        _G.JobId = value
    end
})

-- Button: Join Job Id
Tabs.Random:Button({
    Title = "Join Job Id",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobId)
    end
})




Tabs.Brainrot:Button({
    Title = "BRAINROT RARE JOINER",
    Desc = "Opens Up A New Gui To Join Rare Brainrots",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/erewe23/stealhelper.github.io/refs/heads/main/ere.lua"))()
    end,
})


Tabs.Brainrot:Section({Title = "SECRET BRAINROT ONLY"})



Tabs.Brainrot:Button({
    Title = "Pet Finder Secret Only",
    Desc = "Opens Up A New Gui To Join secret Brainrots",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/erewe23/stealhelper.github.io/refs/heads/main/ere.lua"))()
    end,
})


task.spawn(function()
    task.wait(1)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wedfwef3/ere.github.io/refs/heads/main/infyield.lua"))()
    end)

end)
