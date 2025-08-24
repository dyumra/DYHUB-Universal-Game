repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

local autoFarmActive = false
local MasteryAutoFarmActive = false

local MMovementMode = "Teleport"

local movementMode = "Teleport"
local CharacterMode = "Used"
local ActionMode = "Default"

-- ======================= NEW CONFIG =======================
getgenv().AutoFarmPosMode = "Front"
getgenv().MasteryPosMode = "Front"

getgenv().AutoFarmDistance = 1
getgenv().MasteryDistance = 1
-- ===========================================================

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

-- ======================= NEW FUNCTION =======================
local function getPositionFromMode(npcHRP, mode, distance)
    local forward = npcHRP.CFrame.LookVector
    local up = npcHRP.CFrame.UpVector
    local back = -forward

    if mode == "Above" then
        return npcHRP.Position + (up * distance)
    elseif mode == "Back" then
        return npcHRP.Position + (back * distance)
    elseif mode == "Under" then
        return npcHRP.Position - (up * distance)
    else -- Front
        return npcHRP.Position + (forward * distance)
    end
end
-- ============================================================

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

local function findNextNPCWithHumanoidNoProximity2(maxDistance, referencePart)
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

local RunService = game:GetService("RunService")
local supportPart
local partConnection

local function createSupportPart(character)
    -- ลบของเก่าถ้ามี
    if supportPart then
        supportPart:Destroy()
        supportPart = nil
    end
    if partConnection then
        partConnection:Disconnect()
        partConnection = nil
    end

    supportPart = Instance.new("Part")
    supportPart.Size = Vector3.new(5, 1, 5) -- ขนาดแผ่น
    supportPart.Anchored = true
    supportPart.CanCollide = true
    supportPart.Transparency = 0.9 -- โปร่งใสหน่อย
    supportPart.Name = "AutoFarmSupport"
    supportPart.Parent = workspace

    -- อัปเดตตำแหน่งตลอดเวลา
    partConnection = RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            supportPart.Position = hrp.Position - Vector3.new(
                0,
                (hrp.Size.Y/1 + supportPart.Size.Y/1),
                0
            )
        end
    end)
end

local function removeSupportPart()
    if partConnection then
        partConnection:Disconnect()
        partConnection = nil
    end
    if supportPart then
        supportPart:Destroy()
        supportPart = nil
    end
end

-- ฟังก์ชันหลัก (เพิ่มระบบสร้าง part เข้าไป)
local function attackHumanoidNoProximity(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local character = game.Players.LocalPlayer.Character

    if humanoid and hrp and humanoid.Health > 0 then
        createSupportPart(character)
        while humanoid.Health > 0 and autoFarmActive do
            local pos = getPositionFromMode(hrp, getgenv().AutoFarmPosMode, getgenv().AutoFarmDistance)
            teleportToTarget(pos, 0.5)
            LMBRemote:FireServer()
            task.wait(0.1)
        end
        removeSupportPart()
        removeVisited(npc)
    end
end

-- ฟังก์ชันต่อย NPC (Mastery)
function attackHumanoid(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local character = LocalPlayer.Character

    if humanoid and hrp and humanoid.Health > 0 then
        createSupportPart(character)
        while humanoid.Health > 0 and MasteryAutoFarmActive do
            local pos = getPositionFromMode(hrp, getgenv().MasteryPosMode, getgenv().MasteryDistance)
            teleportToTarget(pos, 0.5)
            LMBRemote:FireServer()
            task.wait(0.1)
        end
        removeSupportPart()
        removeVisited(npc)
    end
end

-- ============= UI =============
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - ST : Blockade Battlefront",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB TEAM - Join us at dsc.gg/dyhub",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - ST : Blockade Battlefront (Version: pre-2.61)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
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

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local MasteryTab = Window:Tab({ Title = "Mastery", Icon = "award" })

-- ======================= Section AutoFarm =======================
MainTab:Section({ Title = "Feature Farm", Icon = "badge-dollar-sign" })

MainTab:Dropdown({
    Title = "Movement",
    Values = {"Teleport", "CFrame"},
    Default = movementMode,
    Multi = false,
    Callback = function(value)
        movementMode = value
    end,
})

-- 📌 NEW UI AutoFarm: Set Position + Distance
MainTab:Dropdown({
    Title = "Set Position (AutoFarm)",
    Values = {"Front", "Above", "Back", "Under"},
    Default = "Front",
    Multi = false,
    Callback = function(value)
        getgenv().AutoFarmPosMode = value
    end,
})

MainTab:Slider({
    Title = "Set Distance to NPC (AutoFarm)",
    Value = {Min = 0, Max = 10, Default = 1},
    Step = 1,
    Callback = function(val)
        getgenv().AutoFarmDistance = val
    end,
})

MainTab:Toggle({
    Title = "Auto Farm (Upgrade)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

MainTab:Toggle({
    Title = "Flush Aura (Upgrade)",
    Default = false,
    Callback = function(value)
        flushAuraActive = value
        if flushAuraActive then
            flushAura()
            task.spawn(function()
                while flushAuraActive do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end,
})

-- ======================= Section Mastery =======================
MasteryTab:Section({ Title = "Feature Mastery", Icon = "badge-dollar-sign" })

MasteryTab:Dropdown({
    Title = "Set Position (Mastery)",
    Values = {"Front", "Above", "Back", "Under"},
    Default = "Front",
    Multi = false,
    Callback = function(value)
        getgenv().MasteryPosMode = value
    end,
})

MasteryTab:Slider({
    Title = "Set Distance to NPC (Mastery)",
    Value = {Min = 0, Max = 10, Default = 1},
    Step = 1,
    Callback = function(val)
        getgenv().MasteryDistance = val
    end,
})

MasteryTab:Toggle({
    Title = "Auto Mastery (ATK+Flush) (Beta)",
    Default = false,
    Callback = function(value)
        autoFarmActive = value
        if autoFarmActive then
            startAutoFarm()
        end
    end,
})

MasteryTab:Toggle({
    Title = "Auto Mastery (No Flush) (Beta)",
    Default = false,
    Callback = function(value)
        toggleMasteryAutoFarm(value)
    end,
})
