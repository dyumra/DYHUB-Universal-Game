-- tettss

repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

local autoFarmActive = false
local MasteryAutoFarmActive = false
local flushAuraActive = false

local movementMode = "Teleport"
local setPositionMode = "Front"
getgenv().DistanceValue = 20

local visitedNPCs = {}
local pressCount = {}

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
    pressCount[npc] = nil
end

-- ฟังก์ชันปรับ ProximityPrompt
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

-- ฟังก์ชันหาตัว NPC
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

local function findNextNPCWithHumanoidNoProximity(maxDistance, referencePart)
    local lastDist = maxDistance
    local closestNPC = nil
    if workspace:FindFirstChild("Living") then
        for _, npc in pairs(workspace.Living:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(npc) and not isVisited(npc) then
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local hasProximity = false
                        for _, child in pairs(npc:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                hasProximity = true
                                break
                            end
                        end
                        if not hasProximity then
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
    end
    return closestNPC
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

-- ฟังก์ชันคำนวณตำแหน่งตาม Set Position + Distance
local function calculatePosition(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then return Vector3.new() end
    local hrp = npc.HumanoidRootPart
    local pos = hrp.Position
    local dist = getgenv().DistanceValue or 20
    if setPositionMode == "Above" then
        return pos + Vector3.new(0, dist, 0)
    elseif setPositionMode == "Under" then
        return pos - Vector3.new(0, dist, 0)
    elseif setPositionMode == "Back" then
        return pos - (hrp.CFrame.LookVector * dist)
    else
        return pos + (hrp.CFrame.LookVector * dist)
    end
end

-- ฟังก์ชันต่อย NPC
local function attackHumanoidNoProximity(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health>0 and autoFarmActive do
        teleportToTarget(calculatePosition(npc),0.5)
        LMBRemote:FireServer()
        task.wait(0.1)
    end
    removeSupportPart()
    removeVisited(npc)
end

function attackHumanoid(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return end
    local character = LocalPlayer.Character
    createSupportPart(character)
    while humanoid.Health>0 and MasteryAutoFarmActive do
        teleportToTarget(calculatePosition(npc),0.5)
        LMBRemote:FireServer()
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
                    local npc,prompt = findNextNPCWithFlushProximity(1000,hrp)
                    if npc and prompt and prompt.Parent then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health>0 then
                            local targetPos = calculatePosition(npc)
                            teleportToTarget(targetPos,0.5)
                            while (pressCount[npc] or 0)<3 do
                                prompt:InputHoldBegin()
                                task.wait(0.05)
                                prompt:InputHoldEnd()
                                pressCount[npc]=(pressCount[npc] or 0)+1
                                task.wait(0.15)
                            end
                            addVisited(npc)
                        else
                            removeVisited(npc)
                        end
                    else
                        local npc2=findNextNPCWithHumanoidNoProximity(1000,hrp)
                        if npc2 then
                            if not isVisited(npc2) then addVisited(npc2) end
                            attackHumanoidNoProximity(npc2)
                        else
                            visitedNPCs={}
                            pressCount={}
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- Mastery AutoFarm
local function MasteryAutoFarm()
    task.spawn(function()
        while MasteryAutoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local npc=findNextNPCWithHumanoid(1000,hrp)
                    if npc then
                        if not isVisited(npc) then addVisited(npc) end
                        attackHumanoid(npc)
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

local function toggleMasteryAutoFarm(state)
    MasteryAutoFarmActive = state
    if not state then removeSupportPart() else MasteryAutoFarm() end
end

-- Flush Aura
local function flushAura()
    task.spawn(function()
        while flushAuraActive do
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local nearbyParts = workspace:GetPartBoundsInRadius(hrp.Position,100,nil)
                for _,part in pairs(nearbyParts) do
                    local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.ActionText=="Flush" then
                        pcall(function()
                            prompt:InputHoldBegin()
                            task.wait(0.05)
                            prompt:InputHoldEnd()
                        end)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- UI
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - ST : Blockade Battlefront",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB TEAM - Join us at dsc.gg/dyhub",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed=true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - ST : Blockade Battlefront (Version: pre-2.61)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
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
local MasteryTab = Window:Tab({ Title="Mastery", Icon="award" })

MainTab:Section({ Title="Feature Farm", Icon="badge-dollar-sign" })
MasteryTab:Section({ Title="Feature Mastery", Icon="badge-dollar-sign" })

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
    Values={"Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

MasteryTab:Dropdown({
    Title="Set Position",
    Values={"Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

-- Slider Distance
MainTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=50, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})

MasteryTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=50, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
})

-- Toggles
MainTab:Toggle({
    Title="Auto Farm (Upgrade)",
    Default=false,
    Callback=function(value) autoFarmActive=value if value then startAutoFarm() end end
})

MainTab:Toggle({
    Title="Flush Aura (Upgrade)",
    Default=false,
    Callback=function(value)
        flushAuraActive=value
        if value then flushAura() end
    end
})

MasteryTab:Toggle({
    Title="Auto Mastery (ATK+Flush) (Beta)",
    Default=false,
    Callback=function(value)
        MasteryAutoFarmActive=value
        if value then MasteryAutoFarm() end
    end
})

MasteryTab:Toggle({
    Title="Auto Mastery (No Flush) (Beta)",
    Default=false,
    Callback=function(value) toggleMasteryAutoFarm(value) end
})
