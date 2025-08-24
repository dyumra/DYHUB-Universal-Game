-- dasdasd

repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game.Workspace
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

-- Variables
local autoFarmActive = false
local MasteryAutoFarmActive = false
local movementMode = "Teleport"
local PositionMode = "Font" -- ค่าเริ่มต้น
getgenv().DistanceValue = 20

local visitedNPCs = {}
local pressCount = {}

-- Utility functions
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
    pressCount[npc] = nil
end

-- Keep ProximityPrompt HoldDuration = 0
local function keepModifyProximityPrompts()
    spawn(function()
        while true do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.HoldDuration ~= 0 then
                        obj.HoldDuration = 0
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end
keepModifyProximityPrompts()

-- Teleport functions
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

-- Support part
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
            supportPart.Position = hrp.Position - Vector3.new(0, (hrp.Size.Y/1 + supportPart.Size.Y/1), 0)
        end
    end)
end

local function removeSupportPart()
    if partConnection then partConnection:Disconnect() partConnection=nil end
    if supportPart then supportPart:Destroy() supportPart=nil end
end

-- NPC Finder
local function findNextNPCWithFlushProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC, closestPrompt = nil, nil
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                for _, prompt in pairs(npc:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Flush" then
                        if (pressCount[npc] or 0) < 3 then
                            local dist = (prompt.Parent.Position - referencePart.Position).Magnitude
                            if dist < lastDist then
                                closestNPC, closestPrompt = npc, prompt
                                lastDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return closestNPC, closestPrompt
end

local function findNextNPCWithHumanoid(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
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

-- Calculate position according to dropdown
local function calculatePosition(npc)
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    if not hrp then return Vector3.new(0,0,0) end
    local pos = hrp.Position
    local offset = getgenv().DistanceValue
    if PositionMode == "Above" then
        pos = pos + Vector3.new(0, 5 + offset, 0)
    elseif PositionMode == "Back" then
        pos = pos - hrp.CFrame.LookVector * (5 + offset)
    elseif PositionMode == "Under" then
        pos = pos - Vector3.new(0, 5 + offset, 0)
    elseif PositionMode == "Font" then
        pos = pos + hrp.CFrame.LookVector * (5 + offset)
    end
    return pos
end

-- AutoFarm functions
local function attackHumanoidNoProximity(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health > 0 and autoFarmActive do
        teleportToTarget(calculatePosition(npc),0.5)
        LMBRemote:FireServer()
        -- flush
        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.ActionText=="Flush" then
            pcall(function() prompt:InputHoldBegin() task.wait(0.05) prompt:InputHoldEnd() end)
        end
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc, prompt = findNextNPCWithFlushProximity(1000, hrp)
                    if npc then
                        attackHumanoidNoProximity(npc)
                    else
                        local npc2 = findNextNPCWithHumanoid(1000, hrp)
                        if npc2 then attackHumanoidNoProximity(npc2)
                        else visitedNPCs={} pressCount={} task.wait(1) end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- Mastery AutoFarm ATK+Flush
function attackHumanoidATKFlush(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health>0 and MasteryAutoFarmActive do
        local targetPos = calculatePosition(npc)
        teleportToTarget(targetPos,0.5)
        LMBRemote:FireServer()
        -- flush
        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.ActionText=="Flush" then
            pcall(function() prompt:InputHoldBegin() task.wait(0.05) prompt:InputHoldEnd() end)
        end
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

function MasteryAutoFarmATKFlush()
    task.spawn(function()
        while MasteryAutoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc = findNextNPCWithHumanoid(1000, hrp)
                    if npc then
                        attackHumanoidATKFlush(npc)
                    else
                        visitedNPCs={}
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- GUI
local Confirmed=false
WindUI:Popup({
    Title="DYHUB Loaded! - ST : Blockade Battlefront",
    Icon="star",
    IconThemed=true,
    Content="DYHUB TEAM - Join us at dsc.gg/dyhub",
    Buttons={
        {Title="Cancel",Variant="Secondary",Callback=function() end},
        {Title="Continue",Icon="arrow-right",Callback=function() Confirmed=true end,Variant="Primary"}
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title="DYHUB - ST : Blockade Battlefront (Version: pre-2.61)",
    IconThemed=true,
    Icon="star",
    Author="DYHUB (dsc.gg/dyhub)",
    Size=UDim2.fromOffset(600,400),
    Transparent=true,
    Theme="Dark",
})

local MainTab = Window:Tab({Title="Main",Icon="rocket"})
local MasteryTab = Window:Tab({Title="Mastery",Icon="award"})
local PlayerTab = Window:Tab({Title="Player",Icon="user"})

-- Main Tab
MainTab:Section({Title="Feature Farm",Icon="badge-dollar-sign"})
MainTab:Dropdown({
    Title="Movement",
    Values={"Teleport","CFrame"},
    Default=movementMode,
    Multi=false,
    Callback=function(value) movementMode=value end
})
MainTab:Dropdown({
    Title="Set Position",
    Values={"Above","Back","Under","Font"},
    Default=PositionMode,
    Multi=false,
    Callback=function(value) PositionMode=value end
})
MainTab:Slider({
    Title="Set Distance to Npc",
    Value={Min=0,Max=50,Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})
MainTab:Toggle({
    Title="Auto Farm (Upgrade)",
    Default=false,
    Callback=function(value)
        autoFarmActive=value
        if autoFarmActive then startAutoFarm() end
    end
})

-- Mastery Tab
MasteryTab:Section({Title="Feature Mastery",Icon="badge-dollar-sign"})
MasteryTab:Dropdown({
    Title="Set Position",
    Values={"Above","Back","Under","Font"},
    Default=PositionMode,
    Multi=false,
    Callback=function(value) PositionMode=value end
})
MasteryTab:Slider({
    Title="Set Distance to Npc",
    Value={Min=0,Max=50,Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})
MasteryTab:Toggle({
    Title="Auto Mastery (ATK+Flush) (Beta)",
    Default=false,
    Callback=function(value)
        MasteryAutoFarmActive=value
        if MasteryAutoFarmActive then MasteryAutoFarmATKFlush() end
    end
})
