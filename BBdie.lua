repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 🔔 Popup ยืนยัน
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Baddies",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

-- 🪟 สร้างหน้าต่าง UI
local Window = WindUI:CreateWindow({
    Title = "DYHUB - Baddies",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "atom" })

-- 🔁 ตัวแปรสถานะ
local autoFarmEnabled = false
local autoFarmConnection = nil

-- 🔨 ฟังก์ชัน Auto Farm
local function startAutoFarm()
    local Backpack = LocalPlayer:WaitForChild("Backpack")
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local stompEvent = ReplicatedStorage:WaitForChild("STOMPEVENT")

    local hitRemote1 = Net:WaitForChild("RE/BeachShovelHit")
    local hitRemote2 = Net:WaitForChild("RE/panHit")
    local hitRemote3 = Net:WaitForChild("RE/pinkStopSignalHit")
    local hitRemote4 = Net:WaitForChild("RE/baseballBatHit")

    -- ฟังก์ชันซื้อ Tool
    local function buyTool(toolName, buttonName)
        if Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName) then return end
        local button = workspace:FindFirstChild(buttonName, true)
        if not button then return end
        Character:PivotTo(button.CFrame + Vector3.new(0, 2, 0))
        local prompt = button:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not prompt then return end
        while not (Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName)) do
            fireproximityprompt(prompt)
            task.wait()
        end
    end

    buyTool("Pan", "Pan Buy button")
    buyTool("BeachShovel", "botonComprarShovel")

    local slayTarget = nil
    local isSlaying = false

    local function fireHits()
        pcall(function() hitRemote1:FireServer(1) end)
        pcall(function() hitRemote2:FireServer(1) end)
        pcall(function() hitRemote3:FireServer(1) end)
        pcall(function() hitRemote4:FireServer(1) end)
    end

    local function teleportToSky(character)
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(0, 1000, 0) end
    end

    local function fireSlay()
        pcall(function() stompEvent:FireServer() end)
    end

    local function moveNearbyPlayers(localRoot)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoid.Health <= 3 and humanoid.Health > 0 and root then
                    pcall(function()
                        root.CanCollide = false
                        root.Size = Vector3.new(20, 20, 20)
                        root.CFrame = localRoot.CFrame * CFrame.new(0, 0, -10)
                    end)
                end
            end
        end
    end

    task.spawn(function()
        while autoFarmEnabled do
            local foundTarget = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    local humanoid = char and char:FindFirstChild("Humanoid")
                    local torso = char and char:FindFirstChild("UpperTorso")
                    if humanoid and humanoid.Health <= 3 and humanoid.Health > 0 and torso then
                        foundTarget = player
                        break
                    end
                end
            end
            slayTarget = foundTarget
            isSlaying = foundTarget ~= nil
            task.wait(1)
        end
    end)

    autoFarmConnection = RunService.Heartbeat:Connect(function()
        if not autoFarmEnabled then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then return end
        if isSlaying and slayTarget and slayTarget.Character then
            local targetTorso = slayTarget.Character:FindFirstChild("UpperTorso")
            if targetTorso then
                pcall(function()
                    root.CFrame = CFrame.new(targetTorso.Position) * CFrame.new(0, 2.5, 0) * CFrame.Angles(0, math.rad(math.random(0, 359)), 0)
                end)
                fireSlay()
            end
        else
            fireHits()
            teleportToSky(char)
            moveNearbyPlayers(root)
        end
    end)

    -- 🥊 Spam Salon Punch
    for i = 1, 100 do
        pcall(function()
            ReplicatedStorage.Modules.Net["RF/SalonPunch"]:InvokeServer()
        end)
    end
end

local function stopAutoFarm()
    autoFarmEnabled = false
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
        autoFarmConnection = nil
    end
end

-- 🟢 Toggle
MainTab:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(state)
        autoFarmEnabled = state
        if autoFarmEnabled then
            startAutoFarm()
        else
            stopAutoFarm()
        end
    end,
})
