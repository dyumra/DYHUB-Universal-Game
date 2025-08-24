repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer

local autoFarmActive = false
local movementMode = "CFrame"
local setPositionMode = "Front"
getgenv().DistanceValue = 1

local visitedNPCs = {}

-- ฟังก์ชันตรวจสอบ NPC
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

-- ฟังก์ชันหา NPC
local function findNextNPC(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil
    if workspace:FindFirstChild("Entities") then
        for _, npc in pairs(workspace.Entities:GetDescendants()) do
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

-- ฟังก์ชัน Teleport
local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPos)}
    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(targetPos)
end

local function teleportToTarget(targetPos, duration)
    if movementMode == "CFrame" then
        smoothTeleportTo(targetPos, duration or 0.5)
    else
        instantTeleportTo(targetPos)
    end
end

-- ฟังก์ชันสร้าง Support Part
local supportPart
local partConnection

local function createSupportPart(character)
    if supportPart then supportPart:Destroy() supportPart=nil end
    if partConnection then partConnection:Disconnect() partConnection=nil end
    supportPart = Instance.new("Part")
    supportPart.Size = Vector3.new(5,1,5)
    supportPart.Anchored = true
    supportPart.CanCollide = true
    supportPart.Transparency = 0.9
    supportPart.Name = "AutoFarmSupport"
    supportPart.Parent = workspace
    partConnection = RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            supportPart.Position = hrp.Position - Vector3.new(0,(hrp.Size.Y/1 + supportPart.Size.Y/1),0)
        end
    end)
end

local function removeSupportPart()
    if partConnection then partConnection:Disconnect() partConnection=nil end
    if supportPart then supportPart:Destroy() supportPart=nil end
end

local spinAngle = 0

local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then 
        return Vector3.new() 
    end

    local hrp = npc.HumanoidRootPart
    local pos = hrp.Position
    local dist = getgenv().DistanceValue or 1

    if setPositionMode == "Above" then
        return pos + Vector3.new(0, dist, 0)
    elseif setPositionMode == "Under" then
        return pos - Vector3.new(0, dist, 0)
    elseif setPositionMode == "Back" then
        return pos - (hrp.CFrame.LookVector * dist)
    elseif setPositionMode == "Spin" then
        spinAngle = spinAngle + math.rad(5)
        return pos + Vector3.new(
            math.cos(spinAngle) * dist,
            0,
            math.sin(spinAngle) * dist
        )
    else
        return pos + (hrp.CFrame.LookVector * dist)
    end
end

-- ฟังก์ชันต่อย NPC โดยการจำลองคลิกเมาส์กลางหน้าจอ
local function attackHumanoidWithClick(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health>0 and autoFarmActive do
        teleportToTarget(calculatePosition(npc),0.5)
        -- Simulate left mouse button click at screen center
        local viewport = workspace.CurrentCamera.ViewportSize
        local centerX, centerY = viewport.X/2, viewport.Y/2
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0) -- press
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0) -- release
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

-- AutoFarm
local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc=findNextNPC(1000,hrp)
                    if npc then
                        if not isVisited(npc) then addVisited(npc) end
                        attackHumanoidWithClick(npc)
                    else
                        visitedNPCs={}
                        task.wait(1)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- UI
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Hunty Zombie",
    Icon = "star",
    IconThemed = true,
    Content = "Join our at (https://dsc.gg/dyhub)",
    Buttons = {
        {
            Title = "Cancel",
            Variant = "Secondary",
            Callback = function()
                game.Players.LocalPlayer:Kick("Cancelled DYHUB")
            end
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                Confirmed = true
            end
        end
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB | Hunty Zombie",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 1.2.5",
    Size = UDim2.fromOffset(600,400),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0,6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30,30,30),Color3.fromRGB(255,255,255)),
    Draggable = true,
})

local MainTab = Window:Tab({ Title="Main", Icon="rocket" })

MainTab:Section({ Title="Feature Farm", Icon="badge-dollar-sign" })

-- Dropdown Movement
MainTab:Dropdown({
    Title="Movement",
    Values={"Teleport","CFrame"},
    Default=movementMode,
    Multi=false,
    Callback=function(value) movementMode=value end
})

-- Dropdown Set Position
MainTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

-- Slider Distance
MainTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=20, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})

-- Toggles
MainTab:Toggle({
    Title="Auto Farm",
    Default=false,
    Callback=function(value) 
        autoFarmActive=value 
        if value then startAutoFarm() end 
    end
})
