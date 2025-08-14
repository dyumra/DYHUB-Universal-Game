local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "DYHUB - Dead Rails",
    LoadingTitle = "DYHUB Loaded! for Dead Rails",
    LoadingSubtitle = "DYHUB (dsc.gg/dyhub)",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local InfoTab = Window:CreateTab("Info", 4483362458)
local EspTab = Window:CreateTab("Esp", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local AutoStuffTab = Window:CreateTab("Auto Stuff", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

InfoTab:CreateParagraph({
    Title = "Welcome to DYHUB",
    Content = "It's beta, We are always updating this script"
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ESP Settings
local ESPFolder, tracerLines = {}, {}
local espSettings = {
    PlayerESP = false,
    TrainESP = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameSize = 16,
    HPBarSize = Vector2.new(60, 6)
}

-- Player Counter
local playerCounter = Drawing.new("Text")
playerCounter.Center = true
playerCounter.Outline = true
playerCounter.Size = 40
playerCounter.Font = 4
playerCounter.Color = Color3.fromRGB(255, 0, 0)
playerCounter.Position = Vector2.new(Camera.ViewportSize.X / 2, 8)
playerCounter.Visible = false

-- Tracers
for i = 1, 50 do
    local line = Drawing.new("Line")
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 1.5
    line.Visible = false
    tracerLines[i] = line
end

-- Create ESP for player
local function createPlayerESP(model)
    if ESPFolder[model] then return end
    local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    local name = Drawing.new("Text")
name.Size = espSettings.NameSize
name.Center = true
name.Outline = true
name.Color = espSettings.NameColor
name.Font = 2 -- Plex font
name.Visible = false

    local hpBack = Drawing.new("Square")
    hpBack.Color = Color3.fromRGB(0, 0, 0)
    hpBack.Filled = true
    hpBack.Transparency = 0.7
    hpBack.Visible = false

    local hpBar = Drawing.new("Square")
    hpBar.Color = Color3.fromRGB(0, 255, 0)
    hpBar.Filled = true
    hpBar.Transparency = 0.9
    hpBar.Visible = false

    ESPFolder[model] = {
        model = model,
        head = head,
        name = name,
        hpBar = hpBar,
        hpBack = hpBack
    }
end

-- Render Loop
RunService.RenderStepped:Connect(function()
    local screenMid = Vector2.new(Camera.ViewportSize.X / 2, 50)
    local visibleCount = 0
    for _, line in ipairs(tracerLines) do line.Visible = false end

    if espSettings.PlayerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                if not ESPFolder[char] then createPlayerESP(char) end
                local data = ESPFolder[char]
                local head = data.head
                if not head or not head:IsDescendantOf(workspace) then continue end

                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and pos.Z > 0 then
                    local dist = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
                    data.name.Text = player.Name .. " [" .. dist .. "m]"
                    data.name.Position = Vector2.new(pos.X, pos.Y - 25)
                    data.name.Visible = true

                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local w, h = espSettings.HPBarSize.X, espSettings.HPBarSize.Y
                        local barX = pos.X - w / 2
                        local barY = pos.Y - 6

                        data.hpBack.Position = Vector2.new(barX, barY)
                        data.hpBack.Size = Vector2.new(w, h)
                        data.hpBack.Visible = true

                        data.hpBar.Position = Vector2.new(barX, barY)
                        data.hpBar.Size = Vector2.new(w * pct, h)
                        data.hpBar.Color = Color3.new(1 - pct, pct, 0)
                        data.hpBar.Visible = true
                    end

                    local line = tracerLines[visibleCount + 1]
                    if line then
                        line.From = screenMid
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Visible = true
                    end

                    visibleCount += 1
                else
                    data.name.Visible = false
                    data.hpBar.Visible = false
                    data.hpBack.Visible = false
                end
            end
        end
        playerCounter.Text = tostring(visibleCount)
        playerCounter.Visible = true
    else
        for _, data in pairs(ESPFolder) do
            data.name.Visible = false
            data.hpBar.Visible = false
            data.hpBack.Visible = false
        end
        playerCounter.Visible = false
    end
end)

-- Auto-add Players
task.spawn(function()
    while true do
        task.wait(1)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not ESPFolder[p.Character] then
                createPlayerESP(p.Character)
            end
        end
    end
end)

-- Storage
local ItemESPEnabled = false
local ItemESPDrawings = {}

-- Custom display names
local CustomNames = {
    ["Model_Runner"] = "Zombie Body",
    ["Crate"] = "Loot Crate",
    ["LootBox"] = "Treasure Box",
    -- Add more if needed
}

-- Clear ESP
local function ClearItemESP()
    for _, v in pairs(ItemESPDrawings) do
        if v.Remove then v:Remove() end
    end
    table.clear(ItemESPDrawings)
end

-- Create ESP
local function CreateItemESP()
    ClearItemESP()

    local itemsFolder = workspace:FindFirstChild("RuntimeItems")
    if not itemsFolder then return end

    for _, item in ipairs(itemsFolder:GetChildren()) do
        local part = item:IsA("Model") and item.PrimaryPart or item
        if part and part:IsA("BasePart") then
            local tag = Drawing.new("Text")
            tag.Size = 16
            tag.Center = true
            tag.Outline = true
            tag.Color = Color3.fromRGB(255, 255, 0) -- Yellow
            tag.Font = 2
            tag.Visible = false

            table.insert(ItemESPDrawings, tag)

            RunService.RenderStepped:Connect(function()
                if ItemESPEnabled and item:IsDescendantOf(workspace) then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local name = CustomNames[item.Name] or item.Name
                        local dist = math.floor((Camera.CFrame.Position - part.Position).Magnitude)
                        tag.Text = name .. " [" .. dist .. "m]"
                        tag.Position = Vector2.new(pos.X, pos.Y - 20)
                        tag.Visible = true
                    else
                        tag.Visible = false
                    end
                else
                    tag.Visible = false
                end
            end)
        end
    end
end



-- UI Toggle Esp Toggles
EspTab:CreateSection("Main Esp")
EspTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        espSettings.PlayerESP = v
        playerCounter.Visible = v
    end
})

EspTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Callback = function(state)
        ItemESPEnabled = state
        if state then
            CreateItemESP()
        else
            ClearItemESP()
        end
    end
})

-- Mob ESP Variables
local MobESPEnabled = false
local MobESPDrawings = {}

-- Custom Mob Names
local MobCustomNames = {
    ["Model_Runner"] = "Zombie",
    ["Model_Boss1"] = "Boss",
    ["Model_Grunt"] = "Grunt"
    -- Add more custom names if needed
}

-- Clear Mob ESP
local function ClearMobESP()
    for _, v in pairs(MobESPDrawings) do
        if v.Remove then v:Remove() end
    end
    table.clear(MobESPDrawings)
end

-- Clear Mob ESP
local function ClearMobESP()
    for _, obj in ipairs(MobESPDrawings) do
        if obj.tag then
            obj.tag:Remove()
        end
    end
    table.clear(MobESPDrawings)
end

-- Create Mob ESP
local function CreateMobESP()
    ClearMobESP()

    for _, mob in ipairs(workspace:GetDescendants()) do
        if mob:IsA("Model")
        and mob:FindFirstChild("Humanoid")
        and mob.PrimaryPart
        and not Players:GetPlayerFromCharacter(mob) then

            local tag = Drawing.new("Text")
            tag.Size = 16
            tag.Center = true
            tag.Outline = true
            tag.Color = Color3.fromRGB(255, 255, 255)
            tag.Font = 2
            tag.Visible = false

            table.insert(MobESPDrawings, {
                mob = mob,
                tag = tag,
                name = MobCustomNames[mob.Name] or mob.Name:gsub("Model_", "")
            })
        end
    end
end

-- Update loop for Mob ESP
RunService.RenderStepped:Connect(function()
    if not MobESPEnabled then
        for _, obj in ipairs(MobESPDrawings) do
            obj.tag.Visible = false
        end
        return
    end

    for _, obj in ipairs(MobESPDrawings) do
        local mob = obj.mob
        if mob and mob:IsDescendantOf(workspace) and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("Humanoid").Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(mob.PrimaryPart.Position)
            if onScreen then
                local dist = math.floor((Camera.CFrame.Position - mob.PrimaryPart.Position).Magnitude)
                obj.tag.Text = obj.name .. " [" .. dist .. "m]"
                obj.tag.Position = Vector2.new(pos.X, pos.Y - 20)
                obj.tag.Visible = true
            else
                obj.tag.Visible = false
            end
        else
            obj.tag.Visible = false
        end
    end
end)

-- Auto-refresh Mob ESP every 5 seconds
task.spawn(function()
    while true do
        task.wait(5)
        if MobESPEnabled then
            CreateMobESP()
        end
    end
end)

-- Mob Esp Toggle
EspTab:CreateToggle({
    Name = "Mob ESP",
    CurrentValue = false,
    Callback = function(state)
        MobESPEnabled = state
        if state then
            CreateMobESP()
        else
            ClearMobESP()
        end
    end
})

TeleportTab:CreateSection("Teleport To Places")
TeleportTab:CreateButton({
    Name = "Teleport to Train Seat",
    Callback = function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
                local controls = v.RequiredComponents:FindFirstChild("Controls")
                if controls and controls:FindFirstChild("ConductorSeat") and controls.ConductorSeat:FindFirstChild("VehicleSeat") then
                    local seat = controls.ConductorSeat.VehicleSeat
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(seat.CFrame)
                    break
                end
            end
        end
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Castle",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.Anchored = true
        task.wait(0.5)

        -- Teleport to Castle location
        hrp.CFrame = CFrame.new(57, 3, -9000)

        -- Wait until MaximGun is loaded
        repeat task.wait() until workspace:FindFirstChild("RuntimeItems") and workspace.RuntimeItems:FindFirstChild("MaximGun")
        task.wait(0.3)

        -- Enable VehicleSeats for MaximGun
        for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                v.VehicleSeat.Disabled = false
            end
        end

        -- Move player to the nearest MaximGun seat
        task.wait(0.5)
        for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                local seat = v.VehicleSeat
                if (hrp.Position - seat.Position).Magnitude < 400 then
                    hrp.CFrame = seat.CFrame
                    break
                end
            end
        end

        task.wait(1)
        hrp.Anchored = false
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Tesla Lab",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if not hrp or not hum then return end

        hrp.Anchored = true
        task.wait(0.5)

        -- Teleport to TeslaLab
        local teslaGen = workspace:FindFirstChild("TeslaLab") and workspace.TeslaLab:FindFirstChild("Generator")
        if teslaGen and teslaGen:FindFirstChild("Generator") then
            hrp.CFrame = teslaGen.Generator.CFrame
        else
            hrp.Anchored = false
            return warn("Tesla Generator not found.")
        end

        -- Wait for Chair to spawn
        repeat task.wait() until workspace:FindFirstChild("RuntimeItems") and workspace.RuntimeItems:FindFirstChild("Chair")
        task.wait(0.3)

        -- Enable Seat
        for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
            if v.Name == "Chair" and v:FindFirstChild("Seat") then
                v.Seat.Disabled = false
            end
        end

        task.wait(0.5)
        hrp.Anchored = false

        -- Try sitting on nearest chair
        repeat
            task.wait()
            for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "Chair" and v:FindFirstChild("Seat") then
                    if (hrp.Position - v.Seat.Position).Magnitude < 250 then
                        hrp.CFrame = v.Seat.CFrame
                    end
                end
            end
        until hum.Sit == true

        -- Stand up
        task.wait(0.5)
        hum.Sit = false
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To End",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-424, 30, -49041)
        repeat task.wait() until workspace.Baseplates:FindFirstChild("FinalBasePlate")
        BasePart = workspace.Baseplates:FindFirstChild("FinalBasePlate")
        OurLaw = BasePart:FindFirstChild("OutlawBase") 
        Sen = OurLaw:FindFirstChild("Sentries")
        if Sen:FindFirstChild("TurretSpot") and Sen.TurretSpot:FindFirstChild("MaximGun") and Sen.TurretSpot.MaximGun:FindFirstChild("VehicleSeat") then
            wait(1.5)
            for i, v in pairs(Sen:FindFirstChild("TurretSpot"):GetChildren()) do
                if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                    v.VehicleSeat.Disabled = false
                end
            end
            wait(0.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            repeat task.wait()
                for i, v in pairs(Sen:FindFirstChild("TurretSpot"):GetChildren()) do
                    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChild("VehicleSeat").CFrame
                    end
                end
            until game.Players.LocalPlayer.Character.Humanoid.Sit == true
            wait(0.5)
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
    end
})

AutoStuffTab:CreateSection("Auto Bond Farm")
AutoStuffTab:CreateButton({
    Name = "Auto Farm Bond V1 (Cooked)",
    Callback = function()
        loadstring([[
            if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingScreenPrefab") == nil
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)
if game.CoreGui:FindFirstChild("BondCheck") == nil then
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BondCheck"

local Frame = Instance.new("Frame")
Frame.Name = "Bond"
Frame.Size = UDim2.new(0.13, 0, 0.1, 0)
Frame.Position = UDim2.new(0.03, 0, 0.05, 0)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderColor3 = Color3.new(0, 0, 0)
Frame.BorderSizePixel = 1
Frame.Active = true
Frame.BackgroundTransparency = 0.3
Frame.Draggable = true
Frame.Parent = gui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Frame

local UICorner = Instance.new("UIStroke")
UICorner.Color = Color3.new(0, 0, 0)
UICorner.Thickness = 2.3
UICorner.Parent = Frame

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundColor3 = Color3.new(255, 255, 255)
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 1
TextLabel.Text = "Really"
TextLabel.TextSize = 20
TextLabel.FontFace = Font.new("rbxassetid://12187372175", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.Parent = Frame
end
_G.Bond = 0
workspace.RuntimeItems.ChildAdded:Connect(function(v)
	if v.Name:find("Bond") and v:FindFirstChild("Part") then
		v.Destroying:Connect(function()
			_G.Bond += 1
		end)
	end
end)
spawn(function()
repeat task.wait()
if game.CoreGui.BondCheck:FindFirstChild("Bond") and game.CoreGui.BondCheck.Bond:FindFirstChild("TextLabel") then
game.CoreGui.BondCheck.Bond:FindFirstChild("TextLabel").Text = "Bond (+".._G.Bond..")"
end
until game.CoreGui:FindFirstChild("BondCheck") == nil
end)
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
end
game.Players.LocalPlayer.CameraMode = "Classic"
game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
game.Players.LocalPlayer.CameraMinZoomDistance = 30
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
wait(0.5)
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(80, 3, -9000)
repeat task.wait() until workspace.RuntimeItems:FindFirstChild("MaximGun")
wait(0.3)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
v.VehicleSeat.Disabled = false
v.VehicleSeat:SetAttribute("Disabled", false)
v.VehicleSeat:Sit(game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"))
end
end
wait(0.5)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
end
end
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true
wait(0.5)
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
wait(0.5)
repeat task.wait()
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
end
end
until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true
wait(0.9)
for i, v in pairs(workspace:GetChildren()) do
if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
if v.RequiredComponents:FindFirstChild("Controls") and v.RequiredComponents.Controls:FindFirstChild("ConductorSeat") and v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat") then
TpTrain = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat").CFrame * CFrame.new(0, 20, 0)})
TpTrain:Play()
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
local bv = Instance.new("BodyVelocity")
bv.Name = "VelocityHandler"
bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
bv.MaxForce = Vector3.new(100000, 100000, 100000)
bv.Velocity = Vector3.new(0, 0, 0)
end
TpTrain.Completed:Wait()
end
end
end
wait(1)
while true do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true then
TpEnd = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(17, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = CFrame.new(0.5, -78, -49429)})
TpEnd:Play()
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
local bv = Instance.new("BodyVelocity")
bv.Name = "VelocityHandler"
bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
bv.MaxForce = Vector3.new(100000, 100000, 100000)
bv.Velocity = Vector3.new(0, 0, 0)
end
repeat task.wait() until workspace.RuntimeItems:FindFirstChild("Bond")
TpEnd:Cancel()
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
if v.Name:find("Bond") and v:FindFirstChild("Part") then
repeat task.wait()
if v:FindFirstChild("Part") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChild("Part").CFrame
game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
end
until v:FindFirstChild("Part") == nil
end
end
end
task.wait()
end

        ]])()
    end
})

AutoStuffTab:CreateButton({
    Name = "Auto Farm Bond V2 (Not Cooked)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if char and hrp then
            hrp.Anchored = true
            task.wait(0.5)
            hrp.CFrame = CFrame.new(80, 3, -9000)

            repeat task.wait() until workspace:FindFirstChild("RuntimeItems"):FindFirstChild("MaximGun")
            task.wait(0.3)

            for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                    v.VehicleSeat.Disabled = false
                    v.VehicleSeat:SetAttribute("Disabled", false)
                    v.VehicleSeat:Sit(char:FindFirstChild("Humanoid"))
                end
            end

            task.wait(0.5)

            for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and
                   (hrp.Position - v.VehicleSeat.Position).Magnitude < 400 then
                    hrp.CFrame = v.VehicleSeat.CFrame
                end
            end

            task.wait(1)
            hrp.Anchored = false

            repeat task.wait()
                for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and
                       (hrp.Position - v.VehicleSeat.Position).Magnitude < 400 then
                        hrp.CFrame = v.VehicleSeat.CFrame
                    end
                end
            until char:FindFirstChild("Humanoid").Sit == true

            task.wait(0.9)

            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("RequiredComponents") and
                   v.RequiredComponents:FindFirstChild("Controls") and
                   v.RequiredComponents.Controls:FindFirstChild("ConductorSeat") and
                   v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat") then

                    local ts = game:GetService("TweenService")
                    local tween = ts:Create(hrp, TweenInfo.new(25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                        {CFrame = v.RequiredComponents.Controls.ConductorSeat.VehicleSeat.CFrame * CFrame.new(0, 20, 0)}
                    )
                    tween:Play()

                    if not hrp:FindFirstChild("VelocityHandler") then
                        local bv = Instance.new("BodyVelocity", hrp)
                        bv.Name = "VelocityHandler"
                        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        bv.Velocity = Vector3.zero
                    end

                    tween.Completed:Wait()
                end
            end

            task.wait(1)

            if char:FindFirstChild("Humanoid").Sit then
                local tpEnd = game:GetService("TweenService"):Create(hrp,
                    TweenInfo.new(17, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {CFrame = CFrame.new(0.5, -78, -49429)}
                )
                tpEnd:Play()

                repeat task.wait() until workspace.RuntimeItems:FindFirstChild("Bond")

                tpEnd:Cancel()

                for _, bond in pairs(workspace.RuntimeItems:GetChildren()) do
                    if bond.Name:find("Bond") and bond:FindFirstChild("Part") then
                        repeat task.wait()
                            if bond:FindFirstChild("Part") then
                                hrp.CFrame = bond.Part.CFrame
                                game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(bond)
                            end
                        until not bond:FindFirstChild("Part")
                    end
                end
            end
        end
    end
})

AutoStuffTab:CreateButton({
    Name = "Auto Farm Bond (BY DYHUB)",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/DeadRails.lua"))()
        end)
        if not success then
            warn("❌ Failed to load script: "..err)
        end
    end
})

AutoStuffTab:CreateSection("Feature Auto Options")
-- Auto Fuel Toggle and Logic
AutoStuffTab:CreateToggle({
    Name = "Auto Fuel Train",
    CurrentValue = false,
    Callback = function(val)
        autoFuelEnabled = val
        _G.FuelTrain = val
        if val then
            task.spawn(function()
                while _G.FuelTrain do
                    for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("ObjectInfo") and v.PrimaryPart and 
                           (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude < 5 then
                            for _, info in pairs(v.ObjectInfo:GetChildren()) do
                                if info:IsA("TextLabel") and info.Text == "Fuel" then
                                    game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStartDrag:FireServer(v)
                                    task.wait(0.3)
                                    for _, k in pairs(workspace:GetChildren()) do
                                        if k:IsA("Model") and k:FindFirstChild("RequiredComponents") and k.RequiredComponents:FindFirstChild("FuelZone") then
                                            v:SetPrimaryPartCFrame(k.RequiredComponents.FuelZone.CFrame)
                                        end
                                    end
                                    task.wait(0.3)
                                    game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStopDrag:FireServer()
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
}) -- ← This closing parenthesis was missing in your version

AutoStuffTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(Value)
        _G.SellItem = Value
        if Value then
            task.spawn(function()
                while _G.SellItem do
                    pcall(function()
                        for _, v in pairs(workspace:WaitForChild("RuntimeItems"):GetChildren()) do
                            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if not hrp then continue end

                            if v.Name ~= "Rock" and v:FindFirstChild("ObjectInfo") and v.PrimaryPart and 
                               (hrp.Position - v.PrimaryPart.Position).Magnitude < 7 then

                                for _, m in pairs(v.ObjectInfo:GetChildren()) do
                                    if m.Name == "TextLabel" then
                                        local label = m.Text
                                        local zone = workspace:FindFirstChild("SafeZones") and workspace.SafeZones:FindFirstChild("SafeZone")
                                        local buildings = zone and zone:FindFirstChild("Buildings")
                                        if not buildings then continue end

                                        local isValuable = (label == "Valuable" or label == "Junk" or label == "Gun")
                                        local isBounty = (label == "Bounty")

                                        local targetBuilding = nil
                                        for _, j in pairs(buildings:GetChildren()) do
                                            if isValuable and j.Name:find("Trading") and j:FindFirstChild("BountySquare") then
                                                targetBuilding = j.BountySquare
                                                break
                                            elseif isBounty and j.Name:find("Sheriffs") and j:FindFirstChild("BountySquare") then
                                                targetBuilding = j.BountySquare
                                                break
                                            end
                                        end

                                        if targetBuilding then
                                            for _, w in pairs(targetBuilding:GetChildren()) do
                                                if w.Name == "Part" and w:FindFirstChild("SurfaceGui") then
                                                    local Remote = game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent
                                                    Remote.RequestStartDrag:FireServer(v)
                                                    task.wait(0.3)
                                                    spawn(function()
                                                        for i = 1, 60 do
                                                            if v.PrimaryPart then
                                                                v:SetPrimaryPartCFrame(w.CFrame)
                                                            end
                                                            task.wait()
                                                        end
                                                    end)
                                                    task.wait(0.3)
                                                    Remote.RequestStopDrag:FireServer()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

local collectSettings = {
    Enabled = false,
    Money = false,
    SnakeOil = false,
    Bandage = false,
    Bond = false,
    Ammo = false,
    HolyWater = false,
    Gun = false,
    Molotov = false,
    Melee = false
}

MiscTab:CreateSection("Auto Collect Options")
-- Master toggle
MiscTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(val)
        collectSettings.Enabled = val
    end
})

-- Individual toggles
MiscTab:CreateToggle({ Name = "Collect Money", CurrentValue = false, Callback = function(v) collectSettings.Money = v end })
MiscTab:CreateToggle({ Name = "Collect Snake Oil", CurrentValue = false, Callback = function(v) collectSettings.SnakeOil = v end })
MiscTab:CreateToggle({ Name = "Collect Bandage", CurrentValue = false, Callback = function(v) collectSettings.Bandage = v end })
MiscTab:CreateToggle({ Name = "Collect Bond", CurrentValue = false, Callback = function(v) collectSettings.Bond = v end })
MiscTab:CreateToggle({ Name = "Collect Ammo", CurrentValue = false, Callback = function(v) collectSettings.Ammo = v end })
MiscTab:CreateToggle({ Name = "Collect Holy Water", CurrentValue = false, Callback = function(v) collectSettings.HolyWater = v end })
MiscTab:CreateToggle({ Name = "Collect Gun", CurrentValue = false, Callback = function(v) collectSettings.Gun = v end })
MiscTab:CreateToggle({ Name = "Collect Molotov", CurrentValue = false, Callback = function(v) collectSettings.Molotov = v end })
MiscTab:CreateToggle({ Name = "Collect Melee", CurrentValue = false, Callback = function(v) collectSettings.Melee = v end })

-- Collection logic loop
task.spawn(function()
    while task.wait(0.5) do
        if not collectSettings.Enabled then continue end

        for _, v in ipairs(workspace:FindFirstChild("RuntimeItems"):GetChildren()) do
            local rootPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not rootPos then continue end
            local pos = rootPos.Position

            -- Money
            if collectSettings.Money and v.Name == "Moneybag" and v:FindFirstChild("MoneyBag") then
                local prompt = v.MoneyBag:FindFirstChild("CollectPrompt")
                if prompt and (pos - v.MoneyBag.Position).Magnitude <= 50 then
                    prompt.HoldDuration = 0
                    if fireproximityprompt then fireproximityprompt(prompt) end
                end
            end

            -- Simple pickup items
            local function pickIfNear(name)
                if v.Name == name then
                    for _, part in pairs(v:GetChildren()) do
                        if part:IsA("BasePart") and (pos - part.Position).Magnitude <= 20 then
                            game.ReplicatedStorage.Remotes.Tool.PickUpTool:FireServer(v)
                        end
                    end
                end
            end
            if collectSettings.SnakeOil then pickIfNear("Snake Oil") end
            if collectSettings.Bandage then pickIfNear("Bandage") end
            if collectSettings.HolyWater then pickIfNear("Holy Water") end
            if collectSettings.Molotov then pickIfNear("Molotov") end

            -- Bond
            if collectSettings.Bond and v.Name:find("Bond") then
                for _, part in pairs(v:GetChildren()) do
                    if part:IsA("BasePart") and (pos - part.Position).Magnitude <= 20 then
                        game.ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                    end
                end
            end

            -- Ammo
            if collectSettings.Ammo and (v.Name:find("Ammo") or v.Name:find("Shells")) then
                for _, part in pairs(v:GetChildren()) do
                    if part:IsA("BasePart") and (pos - part.Position).Magnitude <= 20 then
                        game.ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                    end
                end
            end

            -- Gun
            if collectSettings.Gun then
                if v:FindFirstChild("ServerWeaponState") then
                    pickIfNear(v.Name)
                elseif v:FindFirstChild("ObjectInfo") then
                    for _, label in pairs(v.ObjectInfo:GetChildren()) do
                        if label.Name == "TextLabel" and label.Text == "Gun" then
                            pickIfNear(v.Name)
                        end
                    end
                end
            end

            -- Melee
            if collectSettings.Melee and v:FindFirstChild("ObjectInfo") then
                for _, label in pairs(v.ObjectInfo:GetChildren()) do
                    if label.Name == "TextLabel" and label.Text == "Melee" then
                        pickIfNear(v.Name)
                    end
                end
            end
        end
    end
end)

MiscTab:CreateSection("Feature Player Options")
MiscTab:CreateToggle({
    Name = "No Cooldown",
    CurrentValue = false,
    Callback = function(Value)
        _G.NoCooldownProximity = Value

        if _G.NoCooldownProximity == true then
            for i, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
        else
            if CooldownProximity then
                CooldownProximity:Disconnect()
                CooldownProximity = nil
            end
        end

        CooldownProximity = workspace.DescendantAdded:Connect(function(desc)
            if _G.NoCooldownProximity and desc:IsA("ProximityPrompt") then
                desc.HoldDuration = 0
            end
        end)
    end
})

-- No Fog Toggle
MiscTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Callback = function(Value)
        _G.Nofog = Value
        task.spawn(function()
            while _G.Nofog do
                local lighting = game:GetService("Lighting")
                lighting.FogStart = 100000
                lighting.FogEnd = 200000
                for _, v in pairs(lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then
                        v.Density = 0
                        v.Haze = 0
                    end
                end
                task.wait()
            end
            local lighting = game:GetService("Lighting")
            lighting.FogStart = 0
            lighting.FogEnd = 1000
            for _, v in pairs(lighting:GetChildren()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0.3
                    v.Haze = 1
                end
            end
        end)
    end
})

MiscTab:CreateToggle({
    Name = "Bright (Night Vision)",
    CurrentValue = false,
    Callback = function(enabled)
        _G.NightVision = enabled

        if enabled then
            -- Make lighting bright
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").TimeOfDay = "14:00:00"
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)

            -- Disable effects
            for _, v in pairs(game:GetService("Lighting"):GetDescendants()) do
                if v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end
        else
            -- Reset to default
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").TimeOfDay = "00:00:00"
            game:GetService("Lighting").FogEnd = 1000
            game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)

            for _, v in pairs(game:GetService("Lighting"):GetDescendants()) do
                if v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = true
                end
            end
        end
    end
})

-- Noclip Toggle
MiscTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Callback = function(Value)
        _G.NoclipCharacter = Value
        task.spawn(function()
            while _G.NoclipCharacter do
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                task.wait()
            end
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
})

-- Camera/FOV Settings
local unlockCameraEnabled = false
local fovEnabled = false
local customFOV = 70

-- Unlock Camera (forces Classic mode + zoom out)
MiscTab:CreateButton({
    Name = "Unlock Camera",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end

        player.CameraMode = Enum.CameraMode.Classic
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 128
        print("Camera unlocked.")
    end
})

-- FOV Toggle
MiscTab:CreateToggle({
    Name = "Enable Custom FOV",
    CurrentValue = false,
    Callback = function(val)
        fovEnabled = val
        if val then
            workspace.CurrentCamera.FieldOfView = customFOV
        else
            workspace.CurrentCamera.FieldOfView = 70 -- default FOV
        end
    end
})

-- FOV Slider
MiscTab:CreateSlider({
    Name = "Custom FOV",
    Range = {30, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Callback = function(val)
        customFOV = val
        if fovEnabled then
            workspace.CurrentCamera.FieldOfView = val
        end
    end
})

MiscTab:CreateSection("Fps Boost , Fps meter , ms meter")

MiscTab:CreateButton({
    Name = "Max FPS Boost",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        -- Basic lighting optimization
        pcall(function()
            Lighting.Brightness = 0
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end)

        -- Remove visual effects
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
                v.Enabled = false
            end
        end

        -- Terrain optimization
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        -- Remove textures and decals
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            end
        end

        -- Reduce rendering quality
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        print("✅ Max FPS Boost Applied")
    end
})

-- FPS + Ping Drawing Setup
local showFPS = true
local showPing = true

local fpsText = Drawing.new("Text")
fpsText.Size = 16
fpsText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 100, 10)
fpsText.Color = Color3.fromRGB(0, 255, 0)
fpsText.Center = false
fpsText.Outline = true
fpsText.Visible = showFPS

local msText = Drawing.new("Text")
msText.Size = 16
msText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 100, 30)
msText.Color = Color3.fromRGB(0, 255, 0)
msText.Center = false
msText.Outline = true
msText.Visible = showPing

local fpsCounter = 0
local fpsLastUpdate = tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        -- Update FPS
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end

        -- Update Ping
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"

            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
            end

            msText.Visible = true
        else
            msText.Visible = false
        end

        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)

-- FPS + Ping Toggles
MiscTab:CreateToggle({
   Name = "Show FPS",
   CurrentValue = true,
   Callback = function(val)
      showFPS = val
      fpsText.Visible = val
   end
})

MiscTab:CreateToggle({
   Name = "Show Ping (ms)",
   CurrentValue = true,
   Callback = function(val)
      showPing = val
      Text.Visible = val
   end
})



