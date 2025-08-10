local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local spawnRemote = ReplicatedStorage:WaitForChild("Network"):WaitForChild("Remotes"):WaitForChild("Spawn")

local args = { [1] = true }

local toggleAutoFarm = false
local currentTarget = nil

local lastShootTime = 0

local function isGreenText(part)
    local nameIndicator = part:FindFirstChild("NameIndicator")
    if nameIndicator and nameIndicator:FindFirstChild("TextLabel") then
        local c = nameIndicator.TextLabel.TextColor3
        if math.floor(c.R * 255) == 78 and math.floor(c.G * 255) == 255 and math.floor(c.B * 255) == 149 then
            return true
        end
    end
    return false
end

local function getValidMobs()
    local mobsFolder = workspace:FindFirstChild("Mobs")
    if not mobsFolder then return {} end
    local validMobs = {}
    for _, mob in pairs(mobsFolder:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            if not isGreenText(mob.HumanoidRootPart) then
                table.insert(validMobs, mob)
            end
        end
    end
    return validMobs
end

local function getValidPlayers()
    local validPlayers = {}
    for _, playerModel in pairs(workspace:GetChildren()) do
        if playerModel:IsA("Model") and Players:GetPlayerFromCharacter(playerModel) then
            local humanoid = playerModel:FindFirstChild("Humanoid")
            local hrp = playerModel:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and hrp and not isGreenText(hrp) then
                -- อย่าให้เป็นตัวเอง
                if playerModel ~= LocalPlayer.Character then
                    table.insert(validPlayers, playerModel)
                end
            end
        end
    end
    return validPlayers
end

local function getNearestTarget()
    local character = LocalPlayer.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local candidates = {}

    -- รวม mobs และ players
    for _, mob in pairs(getValidMobs()) do
        table.insert(candidates, mob)
    end
    for _, playerModel in pairs(getValidPlayers()) do
        table.insert(candidates, playerModel)
    end

    if #candidates == 0 then return nil end

    local nearest = nil
    local shortestDist = math.huge
    for _, target in pairs(candidates) do
        local targetHrp = target:FindFirstChild("HumanoidRootPart")
        if targetHrp then
            local dist = (targetHrp.Position - hrp.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearest = target
            end
        end
    end

    return nearest
end

local function teleportTo(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local targetHrp = target.HumanoidRootPart

    local offset = CFrame.new(0, 2, -5)
    hrp.CFrame = targetHrp.CFrame * offset
end

local function shootAt(target)
    if not target then return end
    local head = target:FindFirstChild("Head")
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not head or not hrp then return end

    local bullet = Instance.new("Part")
    bullet.Shape = Enum.PartType.Ball
    bullet.Material = Enum.Material.Neon
    bullet.BrickColor = BrickColor.new("Bright red")
    bullet.Size = Vector3.new(0.3, 0.3, 0.3)
    bullet.CFrame = hrp.CFrame
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.Parent = workspace

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = (head.Position - bullet.Position).Unit * 300
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = bullet

    Debris:AddItem(bullet, 3)
end

local function updateCamera(target)
    if not target then return end
    local head = target:FindFirstChild("Head")
    if not head then return end
    local camPos = Camera.CFrame.Position
    Camera.CFrame = CFrame.new(camPos, head.Position)
end

local function fireSpawn()
    spawnRemote:FireServer(unpack(args))
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local ButtonAutoFarm = Instance.new("TextButton")
ButtonAutoFarm.Size = UDim2.new(0, 200, 0, 50)
ButtonAutoFarm.Position = UDim2.new(0, 20, 0, 20)
ButtonAutoFarm.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ButtonAutoFarm.TextColor3 = Color3.new(1,1,1)
ButtonAutoFarm.Text = "Start Auto Farm"
ButtonAutoFarm.Font = Enum.Font.GothamBold
ButtonAutoFarm.TextScaled = true
ButtonAutoFarm.AutoButtonColor = false
ButtonAutoFarm.BorderSizePixel = 0
ButtonAutoFarm.Parent = ScreenGui

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 400, 0, 30)
StatusLabel.Position = UDim2.new(0, 20, 0, 90)
StatusLabel.BackgroundTransparency = 0.4
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 18
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Text = "Status: Idle"
StatusLabel.Parent = ScreenGui

ButtonAutoFarm.MouseEnter:Connect(function()
    ButtonAutoFarm.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
ButtonAutoFarm.MouseLeave:Connect(function()
    if toggleAutoFarm then
        ButtonAutoFarm.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        ButtonAutoFarm.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

local function updateButtonColor()
    if toggleAutoFarm then
        ButtonAutoFarm.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ButtonAutoFarm.Text = "Stop Auto Farm"
    else
        ButtonAutoFarm.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ButtonAutoFarm.Text = "Start Auto Farm"
    end
end

ButtonAutoFarm.MouseButton1Click:Connect(function()
    toggleAutoFarm = not toggleAutoFarm
    if toggleAutoFarm then
        currentTarget = nil
        StatusLabel.Text = "Auto Farm started"
    else
        StatusLabel.Text = "Idle"
    end
    updateButtonColor()
end)

RunService:BindToRenderStep("AutoFarmLoop", Enum.RenderPriority.Character.Value + 1, function(dt)
    if not toggleAutoFarm then
        StatusLabel.Text = "Status: DYHUB - Hypershot (BETA)"
        return
    end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or character.Humanoid.Health <= 0 then
        StatusLabel.Text = "Status: Waiting for character..."
        return
    end

    lastShootTime += dt

    if not currentTarget or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
        currentTarget = getNearestTarget()
    end

    if currentTarget then
        teleportTo(currentTarget)
        updateCamera(currentTarget)

        if lastShootTime >= 0.3 then
            shootAt(currentTarget)
            fireSpawn()
            lastShootTime = 0
        end

        StatusLabel.Text = "Target: "..currentTarget.Name
    else
        StatusLabel.Text = "No valid targets found"
    end
end)
