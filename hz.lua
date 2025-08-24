repeat task.wait() until game:IsLoaded()

-- Load UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Settings
local autoFarmActive = false
local movementMode = "CFrame"
local setPositionMode = "Front"
getgenv().DistanceValue = 2

local visitedNPCs = {}
local spinAngle = 0

-- Anti-AFK (กันเด้งออกตอนเปิดทั้งคืน)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Utility
local function isVisited(npc)
    for _, v in ipairs(visitedNPCs) do
        if v == npc then return true end
    end
    return false
end

local function addVisited(npc)
    table.insert(visitedNPCs, npc)
end

local function removeVisited(npc)
    for i, v in ipairs(visitedNPCs) do
        if v == npc then
            table.remove(visitedNPCs, i)
            break
        end
    end
end

-- หา NPC
local function findNextNPC(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil
    if Workspace:FindFirstChild("Entities") then
        for _, npc in pairs(Workspace.Entities:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local dist = (npc.HumanoidRootPart.Position - referencePart.Position).Magnitude
                        if dist < lastDist then
                            closestNPC = npc
                            lastDist = dist
                        end
                    end
                end
            end
        end
    end
    return closestNPC
end

-- Teleport
local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPos)}
    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function teleportToTarget(targetPos)
    if movementMode == "CFrame" then
        smoothTeleportTo(targetPos, 0.3)
    else
        instantTeleportTo(targetPos)
    end
end

-- คำนวณตำแหน่งยืนรอบ NPC
local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then return Vector3.new() end
    local hrp = npc.HumanoidRootPart
    local pos = hrp.Position
    local dist = getgenv().DistanceValue or 2

    if setPositionMode == "Above" then
        return pos + Vector3.new(0, dist, 0)
    elseif setPositionMode == "Under" then
        return pos - Vector3.new(0, dist, 0)
    elseif setPositionMode == "Back" then
        return pos - (hrp.CFrame.LookVector * dist)
    elseif setPositionMode == "Spin" then
        spinAngle = spinAngle + math.rad(5)
        return pos + Vector3.new(math.cos(spinAngle) * dist, 0, math.sin(spinAngle) * dist)
    else
        return pos + (hrp.CFrame.LookVector * dist)
    end
end

-- โจมตี NPC (จำลองคลิกเมาส์)
local function attackNPC(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    while humanoid.Health > 0 and autoFarmActive do
        teleportToTarget(calculatePosition(npc))
        local viewport = Workspace.CurrentCamera.ViewportSize
        local centerX, centerY = viewport.X/2, viewport.Y/2
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
        task.wait(0.1)
    end

    removeVisited(npc)
end

-- Loop AutoFarm
local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc = findNextNPC(1000, hrp)
                    if npc then
                        addVisited(npc)
                        attackNPC(npc)
                    else
                        visitedNPCs = {}
                        task.wait(1)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- UI
local Window = WindUI:CreateWindow({
    Title = "DYHUB | AutoFarm",
    Icon = "sword",
    Theme = "Dark",
    Size = UDim2.fromOffset(480, 280),
})

local MainTab = Window:Tab({ Title="Main", Icon="rocket" })

MainTab:Dropdown({
    Title ="Movement",
    Values = {"Teleport","CFrame"},
    Default = movementMode,
    Callback = function(value) movementMode = value end
})

MainTab:Dropdown({
    Title ="Set Position",
    Values = {"Front","Back","Above","Under","Spin"},
    Default = setPositionMode,
    Callback = function(value) setPositionMode = value end
})

MainTab:Slider({
    Title = "Distance",
    Value = {Min=1, Max=20, Default=getgenv().DistanceValue},
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end
})

MainTab:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if value then
            startAutoFarm()
        end
    end
})
