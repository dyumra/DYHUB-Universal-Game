repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- UI Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Confirmation popup
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Aether Adventure",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

-- Main Window
local Window = WindUI:CreateWindow({
    Title = "DYHUB - Aether Adventure @ Free Version",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "Open DYHUB",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local QuestTab = Window:Tab({ Title = "Auto Quest", Icon = "target" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local CodeTab = Window:Tab({ Title = "Code", Icon = "code" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })

-- Variables
local NPCsFolder = Workspace:WaitForChild("NPCs")
local farmRunning = false
local farmConnection = nil

local selectedMob = ""
local selectedWeapon = "Combat"
local positionMode = "Above"
local autoTurnIn = false
local autoReAccept = false

-- Auto Quest variables
local autoQuestEnabled = false
local selectedQuest = "Quest 1"

-- Speed variables
local desiredSpeed = 33
local enforceSpeed = true

-- Anti Kick / Server Hop connection holders
local antiKickConnection = nil
local serverHopConnection = nil
local autoServerHopEnabled = false

-- Functions

local function getMobList()
    local mobs = {}
    for _, folder in ipairs(NPCsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            table.insert(mobs, folder.Name)
        end
    end
    return mobs
end

local function findAnyAliveMob(name)
    for _, folder in ipairs(NPCsFolder:GetChildren()) do
        if folder.Name == name then
            for _, mob in ipairs(folder:GetChildren()) do
                local hum = mob:FindFirstChildOfClass("Humanoid")
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and hum and hum.Health > 0 then
                    return mob
                end
            end
        end
    end
    return nil
end

local function findWeapon(toolName)
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then
            return tool
        end
    end
    for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then
            return tool
        end
    end
    return nil
end

local function getOffset(mode)
    if mode == "Above" then
        return Vector3.new(0, 3, 0)
    elseif mode == "Under" then
        return Vector3.new(0, -3, 0)
    elseif mode == "Behind" then
        return Vector3.new(0, 0, -3)
    elseif mode == "Front" then
        return Vector3.new(0, 0, 3)
    else
        return Vector3.new(0, -3, 0)
    end
end

local function acceptQuest(q)
    local args = { [1] = "AcceptQuest", [2] = q or "Quest 1" }
    ReplicatedStorage.Remotes.UIReplicator:FireServer(unpack(args))
end

local function turnInQuest(q)
    local args = { [1] = "TurnInQuest", [2] = q or "Quest 1" }
    ReplicatedStorage.Remotes.UIReplicator:FireServer(unpack(args))
end

local function setupAntiKick()
    if antiKickConnection then return end
    antiKickConnection = VirtualUser.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0))
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0))
    end)
end

local function disableAntiKick()
    if antiKickConnection then
        antiKickConnection:Disconnect()
        antiKickConnection = nil
    end
end

local function setupServerHop()
    if serverHopConnection then return end
    serverHopConnection = Players.PlayerAdded:Connect(function(p)
        if autoServerHopEnabled and (p.Name == "Yolmar_43") then
            TeleportService:Teleport(game.PlaceId)
        end
    end)
end

local function startFarm()
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end

    farmRunning = true
    acceptQuest(selectedQuest)

    farmConnection = RunService.RenderStepped:Connect(function()
        if not farmRunning then return end
        local mob = findAnyAliveMob(selectedMob)
        if mob and mob:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Anti Fall
                if hrp.Position.Y < -50 then
                    hrp.CFrame = CFrame.new(0, 5, 0)
                end

                -- ลบการตั้ง CanCollide และ Anchored เพื่อให้ไม่กระตุกเวลาวาร์ป
                --[[
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                hrp.Anchored = true
                ]]

                -- Position & LookAt Mob (หมุนเฉพาะแกน Y)
                local mobRoot = mob.HumanoidRootPart
                local offset = getOffset(positionMode)
                local targetPos = mobRoot.Position + offset

                -- คำนวณหมุนแกน Y เท่านั้น
                local lookVector = (mobRoot.Position - targetPos)
                local yRotation = math.atan2(lookVector.X, lookVector.Z)
                local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(0, yRotation, 0)

                -- ใช้ Lerp ให้เคลื่อนที่นุ่มนวล ไม่กระตุกเวลาวาร์ป
                hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, 0.3)

                -- Equip weapon
                local tool = findWeapon(selectedWeapon)
                if tool and not tool.Parent:IsDescendantOf(LocalPlayer.Character) then
                    tool.Parent = LocalPlayer.Character
                end

                -- Attack
                ReplicatedStorage.Remotes.Attack:FireServer("M1", selectedWeapon, false)
            end
        else
            task.wait(0.3)
        end
    end)

    -- Auto Turn In
    task.spawn(function()
        while farmRunning and autoTurnIn do
            turnInQuest(selectedQuest)
            task.wait(5)
        end
    end)

    -- Auto Re-Accept
    task.spawn(function()
        while farmRunning and autoReAccept do
            acceptQuest(selectedQuest)
            task.wait(5)
        end
    end)
end

local function stopFarm()
    farmRunning = false
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end

    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum.WalkSpeed = 16 -- รีเซ็ตความเร็วให้ปกติ
    end

    print("[DYHUB] Stopped Farming!")
end

-- UI Elements --

-- Main Tab
MainTab:Dropdown({
    Title = "Select Mob",
    Values = getMobList(),
    Multi = false,
    Callback = function(v) selectedMob = v end,
})

-- สร้าง WeaponList

-- ตัวแปร
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local selectedWeapon = ""
local WeaponList = {}

-- ดึงของครั้งแรก
for _, tool in ipairs(Backpack:GetChildren()) do
    if tool:IsA("Tool") then
        table.insert(WeaponList, tool.Name)
    end
end
table.insert(WeaponList, 1, "NONE")

-- Dropdown ครั้งเดียว
MainTab:Dropdown({
    Title = "Select Weapon",
    Values = WeaponList,
    Multi = false,
    Callback = function(v)
        if v == "NONE" then
            selectedWeapon = ""
            print("[DYHUB] Cleared Weapon")
        else
            selectedWeapon = v
            print("[DYHUB] Selected Weapon:", selectedWeapon)
        end
    end,
})

-- ปุ่ม Refresh แค่พิมพ์ชื่อใหม่
MainTab:Button({
    Title = "Refresh Weapon List",
    Callback = function()
        WeaponList = {"NONE"}
        for _, tool in ipairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(WeaponList, tool.Name)
            end
        end
        print("[DYHUB] ⚡ Updated Weapon List:", table.concat(WeaponList, ", "))
        print("[DYHUB] ✅ NOTE: You have to reselect it yourself bc the dropdown doesn't refresh its values automatically.")
    end,
})


MainTab:Dropdown({
    Title = "Position Mode",
    Values = {"Above", "Under", "Behind", "Front"},
    Multi = false,
    Callback = function(v) positionMode = v end,
})

MainTab:Toggle({
    Title = "Start Farm",
    Value = false,
    Callback = function(state)
        if state then
            startFarm()
        else
            stopFarm()
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Turn-In",
    Value = false,
    Callback = function(state) autoTurnIn = state end,
})

MainTab:Toggle({
    Title = "Auto Re-Accept Quest",
    Value = false,
    Callback = function(state) autoReAccept = state end,
})

-- Auto Quest Tab

QuestTab:Dropdown({
    Title = "Select Quest",
    Values = {"Quest 1","Quest 2","Quest 3","Quest 4","Quest 5","Quest 6","Quest 7","Quest 8","Quest 9","Quest 10","Quest 11","Quest 12","Quest 13","Quest 14","Quest 15","Quest 16","Quest 17"},
    Multi = false,
    Callback = function(v) selectedQuest = v end,
})

QuestTab:Toggle({
    Title = "Auto Quest",
    Value = false,
    Callback = function(state)
        autoQuestEnabled = state
        if state then
            print("[DYHUB] Auto Quest Started")
            spawn(function()
                while autoQuestEnabled do
                    acceptQuest(selectedQuest)
                    task.wait(2)
                end
            end)
        else
            print("[DYHUB] Auto Quest Stopped")
        end
    end,
})

-- Teleport Tab
local locationList = {}
local questTargetList = {}

for _, loc in pairs(Workspace:WaitForChild("Location"):GetChildren()) do
    table.insert(locationList, loc.Name)
end
for _, q in pairs(Workspace:WaitForChild("QuestTargets"):GetChildren()) do
    table.insert(questTargetList, q.Name)
end

local selectedLocation = locationList[1]
local selectedQuestTarget = questTargetList[1]

TeleportTab:Dropdown({
    Title = "Location",
    Values = locationList,
    Multi = false,
    Callback = function(v) selectedLocation = v end,
})

TeleportTab:Button({
    Title = "Teleport to Location",
    Callback = function()
        local target = Workspace.Location:FindFirstChild(selectedLocation)
        if target and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            LocalPlayer.Character:SetPrimaryPartCFrame(target.CFrame)
        end
    end,
})

TeleportTab:Dropdown({
    Title = "Quest Target",
    Values = questTargetList,
    Multi = false,
    Callback = function(v) selectedQuestTarget = v end,
})

TeleportTab:Button({
    Title = "Teleport to Quest Target",
    Callback = function()
        local target = Workspace.QuestTargets:FindFirstChild(selectedQuestTarget)
        if target and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            LocalPlayer.Character:SetPrimaryPartCFrame(target.CFrame)
        end
    end,
})

-- Player Tab

-- Speed enforcement loop
RunService.RenderStepped:Connect(function()
    if enforceSpeed and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= desiredSpeed then
            hum.WalkSpeed = desiredSpeed
        end
    end
end)

-- Reset WalkSpeed on CharacterAdded
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if enforceSpeed and hum.WalkSpeed ~= desiredSpeed then
            hum.WalkSpeed = desiredSpeed
        end
    end)
end)

PlayerTab:Slider({
    Title = "Walk Speed",
    Value = { Min = 8, Max = 100, Default = desiredSpeed },
    Callback = function(value)
        desiredSpeed = value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = desiredSpeed end
    end,
})

PlayerTab:Slider({
    Title = "Jump Power",
    Value = { Min = 20, Max = 200, Default = 50 },
    Callback = function(value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = value end
    end,
})

-- Misc Tab

MiscTab:Toggle({
    Title = "Anti Afk",
    Value = false,
    Callback = function(state)
        if state then
            setupAntiKick()
        else
            disableAntiKick()
        end
    end,
})

MiscTab:Toggle({
    Title = "Anti Admin",
    Value = false,
    Callback = function(state)
        autoServerHopEnabled = state
        if state then
            setupServerHop()
        end
    end,
})

-- Shop Tab 
local UnlockList = { "Geppo", "Aura", "Observation" }
local selectedAbilities = {} -- เก็บสิ่งที่เลือก

ShopTab:Dropdown({
    Title = "Select Abilities",
    Values = UnlockList,
    Multi = true,
    Callback = function(list)
        selectedAbilities = list
        print("[DYHUB] Selected abilities:", table.concat(selectedAbilities, ", "))
    end,
})

-- selectedAbilities
ShopTab:Button({
    Title = "Unlock Free",
    Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local abilities = plr:FindFirstChild("Abilities")

        if abilities then
            for _, abilityName in ipairs(selectedAbilities) do
                local ability = abilities:FindFirstChild(abilityName)
                if ability and ability:IsA("BoolValue") then
                    ability.Value = true
                    print("[DYHUB] Unlocked:", abilityName)
                else
                    warn("[DYHUB] Missing or invalid:", abilityName)
                end
            end
        else
            warn("[DYHUB] Abilities folder not found!")
        end
    end,
})

-- Code
local CodesFolder = game:GetService("Players").LocalPlayer:WaitForChild("Codes")
local CodeList = {}

for _, code in ipairs(CodesFolder:GetChildren()) do
    table.insert(CodeList, code.Name)
end

local selectedCode = {}

-- Dropdown
CodeTab:Dropdown({
    Title = "Select Code",
    Values = CodeList,
    Multi = true,
    Callback = function(list)
        selectedCode = list
        print("[DYHUB] Selected Codes:", table.concat(selectedCode, ", "))
    end,
})

-- Button Redeem
CodeTab:Button({
    Title = "Redeem Code",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CodeSystem")

        for _, codeName in ipairs(selectedCode) do
            local args = {
                [1] = "RedeemCode",
                [2] = codeName
            }
            Remote:FireServer(unpack(args))
            print("[DYHUB] Redeemed code:", codeName)
        end
    end,
})



print("[DYHUB] Loaded! for Aether Adventure")
