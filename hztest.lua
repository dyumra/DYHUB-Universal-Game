-- [[ v888 ]]

local function destroyObjectCache(parent)
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == "ObjectCache" then
            obj:Destroy()
        else
            destroyObjectCache(obj)
        end
    end
end

destroyObjectCache(workspace.Terrain)

local WindUI
repeat
    task.wait(0.1)
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    if success then
        WindUI = result
    end
until WindUI

getgenv().ESPEnabled = false
getgenv().ESPType = "Highlight"
getgenv().ESPShowName = true
getgenv().ESPShowDistance = true
getgenv().ESPDistance = 50
getgenv().ESPName = "NPC"

getgenv().AutoDoor = false
getgenv().AutoAttack = false
getgenv().AutoSkill = false
getgenv().AutoPerk = false

getgenv().AutoRadio = false
getgenv().AutoHeli = false
getgenv().AutoPower = false

getgenv().AutoCollect = false
getgenv().autoFarmActive = false
getgenv().DistanceValue = 5
getgenv().setPositionMode = "Above"

local spinAngle = 0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")

-- ตัวแปร Auto Farm
local farmConnection, attackConnection

-- ฟังก์ชันดึง NPC ทั้งหมด
local function getAllNPCs()
    local entities = workspace:FindFirstChild("Entities"):FindFirstChild("Zombie")
    if not entities then return {} end
    return entities:GetChildren()
end

-- ฟังก์ชันหา NPC ใกล้ที่สุด
local function getClosestNPC()
    local npcs = getAllNPCs()
    local closest = nil
    local minDist = math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, npc in ipairs(npcs) do
        local npcRoot = npc:FindFirstChild("HumanoidRootPart")
        if npcRoot then
            local dist = (npcRoot.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = npc
            end
        end
    end
    return closest
end

-- เริ่ม Auto Farm
function startAutoFarm()
    stopAutoFarm()
    getgenv().autoFarmActive = true

    -- วาร์ปตัวละคร
    farmConnection = RunService.RenderStepped:Connect(function(dt)
        if not getgenv().autoFarmActive then return end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local targetNPC = getClosestNPC()
        if targetNPC and targetNPC:FindFirstChild("HumanoidRootPart") then
            local npcRoot = targetNPC.HumanoidRootPart
            local offset = Vector3.new(0,getgenv().DistanceValue or 3,0)

            if getgenv().setPositionMode == "Above" then
                offset = Vector3.new(0,getgenv().DistanceValue or 3,0)
            elseif getgenv().setPositionMode == "Under" then
                offset = Vector3.new(0,-(getgenv().DistanceValue or 3),0)
            elseif getgenv().setPositionMode == "Front" then
                offset = npcRoot.CFrame.LookVector * (getgenv().DistanceValue or 3)
            elseif getgenv().setPositionMode == "Back" then
                offset = -npcRoot.CFrame.LookVector * (getgenv().DistanceValue or 3)
            elseif getgenv().setPositionMode == "Spin" then
                spinAngle += dt * 2
                local radius = getgenv().DistanceValue or 3
                offset = Vector3.new(math.cos(spinAngle) * radius, 0, math.sin(spinAngle) * radius)
            end

            -- ล็อกตัวละครให้นิ่ง
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(npcRoot.Position + offset)
        end
    end)

    -- ยิงคำสั่งโจมตีใส่ target ที่ใกล้ที่สุด
    attackConnection = task.spawn(function()
        local interval = 1 / 500 -- 0.005 วินาที
        while getgenv().autoFarmActive do
            local targetNPC = getClosestNPC()
            local npcRoot = targetNPC and targetNPC:FindFirstChild("HumanoidRootPart")
            if npcRoot then
                for i = 0, 10 do
                    local args = { buffer.fromstring(string.char(8, i, 0)) }
                    ByteNetReliable:FireServer(unpack(args))
                    local f1 = { buffer.fromstring("\001\001"), {} }
                    ByteNetReliable:FireServer(unpack(f1))
                end
            end
            task.wait(interval)
        end
    end)
end

-- หยุด Auto Farm
function stopAutoFarm()
    getgenv().autoFarmActive = false
    if farmConnection then farmConnection:Disconnect() farmConnection = nil end
    if attackConnection then attackConnection = nil end
end


-- สร้าง GUI
local Window = WindUI:CreateWindow({
    Title = "DYHUB | Hunty Zombie",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 1.9.8",
    Size = UDim2.fromOffset(500, 300),
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
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local AutoTab = Window:Tab({ Title = "Gameplay", Icon = "crown" })
local JoinTab = Window:Tab({ Title = "Auto Party", Icon = "handshake" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "file-cog" })
Window:SelectTab(1)

-- ================= MainTab =================
MainTab:Section({ Title = "Feature Farm", Icon = "sword" })

MainTab:Dropdown({
    Title = "Set Position",
    Values = { "Spin", "Above", "Back", "Under", "Front" },
    Default = getgenv().setPositionMode,
    Multi = false,
    Callback = function(value) getgenv().setPositionMode = value end
})

MainTab:Slider({
    Title = "Set Distance to NPC",
    Value = { Min = 0, Max = 30, Default = getgenv().DistanceValue },
    Step = 1,
    Callback = function(val) getgenv().DistanceValue = val end
})

MainTab:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        if value then startAutoFarm() else stopAutoFarm() end
    end
})

MainTab:Toggle({
    Title = "Auto Collect Items",
    Default = false,
    Callback = function(value)
        getgenv().AutoCollect = value
        if value then
            spawn(function()
                while getgenv().AutoCollect do
                    local entities = workspace:FindFirstChild("Entities"):FindFirstChild("Zombie")
                    local hasNPC = false
                    if entities then
                        for _, npc in ipairs(entities:GetChildren()) do
                            if npc:FindFirstChild("HumanoidRootPart") then
                                hasNPC = true
                                break
                            end
                        end
                    end
                    if not hasNPC then
                        local drops = workspace:FindFirstChild("DropItems")
                        if drops then
                            for _, item in ipairs(drops:GetChildren()) do
                                if item:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(item.Position +
                                    Vector3.new(0, 3, 0))
                                    task.wait(0.05)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ================= ESP Tab =================
EspTab:Section({ Title = "Feature ESP", Icon = "eye" })

EspTab:Dropdown({
    Title = "ESP Type",
    Values = { "Highlight", "BoxHandleAdornment" },
    Default = getgenv().ESPType,
    Multi = false,
    Callback = function(value) getgenv().ESPType = value end
})

EspTab:Toggle({
    Title = "Enable ESP",
    Default = getgenv().ESPEnabled,
    Callback = function(value) getgenv().ESPEnabled = value end
})

EspTab:Section({ Title = "Settings ESP", Icon = "settings" })

EspTab:Toggle({
    Title = "Show Name",
    Default = getgenv().ESPShowName,
    Callback = function(value) getgenv().ESPShowName = value end
})

EspTab:Toggle({
    Title = "Show Distance",
    Default = getgenv().ESPShowDistance,
    Callback = function(value) getgenv().ESPShowDistance = value end
})

EspTab:Slider({
    Title = "Max Distance",
    Value = { Min = 1, Max = 100, Default = getgenv().ESPDistance },
    Step = 1,
    Callback = function(val) getgenv().ESPDistance = val end
})

-- ฟังก์ชัน update ESP
local function updateESP()
    if not getgenv().ESPEnabled then return end
    local entities = workspace:FindFirstChild("Entities"):FindFirstChild("Zombie")
    if not entities then return end
    for _, npc in ipairs(entities:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local hrp = npc.HumanoidRootPart

            -- Highlight / Box
            if getgenv().ESPType == "Highlight" and not hrp:FindFirstChild("ESP_Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.Adornee = npc
                highlight.Parent = hrp
            elseif getgenv().ESPType == "BoxHandleAdornment" and not hrp:FindFirstChild("ESP_Box") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESP_Box"
                box.Adornee = hrp
                box.Size = hrp.Size or Vector3.new(2, 2, 1)
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.AlwaysOnTop = true
                box.Parent = hrp
            end

            -- Name + Distance
            if getgenv().ESPShowName then
                if not hrp:FindFirstChild("ESP_NameTag") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ESP_NameTag"
                    bill.Adornee = hrp
                    bill.Size = UDim2.new(0, 120, 0, 50)
                    bill.AlwaysOnTop = true
                    bill.Parent = hrp

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(255, 0, 0)
                    text.TextScaled = true
                    text.Parent = bill
                end

                local label = hrp:FindFirstChild("ESP_NameTag"):FindFirstChildOfClass("TextLabel")
                if label and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist <= getgenv().ESPDistance then
                        if getgenv().ESPShowDistance then
                            label.Text = getgenv().ESPName .. " - [" .. math.floor(dist) .. "m]"
                        else
                            label.Text = getgenv().ESPName
                        end
                        label.Visible = true
                    else
                        label.Visible = false
                    end
                end
            else
                if hrp:FindFirstChild("ESP_NameTag") then
                    hrp.ESP_NameTag:Destroy()
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if getgenv().ESPEnabled then updateESP() end
end)

-- ================= Auto Tab =================
AutoTab:Section({ Title = "Feature Collect", Icon = "hand" })

local function activatePrompt(prompt)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local originalCFrame = hrp.CFrame

    -- ลด HoldDuration ของ ProximityPrompt ทั้งหมด
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end

    -- วาร์ปแบบนิ่ง ๆ ไปยัง Prompt
    local targetCFrame = prompt.Parent.CFrame + Vector3.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.Velocity = Vector3.zero
    hrp.RotVelocity = Vector3.zero
    hrp.CFrame = targetCFrame

    task.wait(0.05)
    fireproximityprompt(prompt)
    task.wait(0.05)

    -- กลับตำแหน่งเดิมแบบ Smooth / ไม่มีกระตุก
    hrp.CFrame = originalCFrame
end

-- Auto Radio / Heli / Power
AutoTab:Toggle({ Title = "Auto Radio", Default = false, Callback = function(v) getgenv().AutoRadio = v end })
AutoTab:Toggle({ Title = "Auto Helicopter", Default = false, Callback = function(v) getgenv().AutoHeli = v end })
AutoTab:Toggle({ Title = "Auto Power", Default = false, Callback = function(v) getgenv().AutoPower = v end })

spawn(function()
    while true do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if getgenv().AutoRadio then
                local radioPrompt = workspace:FindFirstChild("School")
                    and workspace.School:FindFirstChild("Rooms")
                    and workspace.School.Rooms:FindFirstChild("RooftopBoss")
                    and workspace.School.Rooms.RooftopBoss:FindFirstChild("RadioObjective")
                    and workspace.School.Rooms.RooftopBoss.RadioObjective:FindFirstChild("ProximityPrompt")
                if radioPrompt then activatePrompt(radioPrompt) end
            end

            if getgenv().AutoHeli then
                local heliPrompt = workspace:FindFirstChild("School")
                    and workspace.School:FindFirstChild("Rooms")
                    and workspace.School.Rooms:FindFirstChild("RooftopBoss")
                    and workspace.School.Rooms.RooftopBoss:FindFirstChild("HeliObjective")
                    and workspace.School.Rooms.RooftopBoss.HeliObjective:FindFirstChild("ProximityPrompt")
                if heliPrompt then activatePrompt(heliPrompt) end
            end

            if getgenv().AutoPower then
                local powerPrompt = workspace:FindFirstChild("Sewers")
                    and workspace.Sewers:FindFirstChild("Rooms")
                    and workspace.Sewers.Rooms:FindFirstChild("BossRoom")
                    and workspace.Sewers.Rooms.BossRoom:FindFirstChild("generator")
                    and workspace.Sewers.Rooms.BossRoom.generator:FindFirstChild("gen")
                    and workspace.Sewers.Rooms.BossRoom.generator.gen:FindFirstChild("pom")
                if powerPrompt then activatePrompt(powerPrompt) end
            end
        end
        task.wait(0.2)
    end
end)

-- Auto Door / Attack / Skill / Perk
AutoTab:Section({ Title = "Feature Auto", Icon = "sword" })
AutoTab:Toggle({ Title = "Auto Door", Default = false, Callback = function(v) getgenv().AutoDoor = v end })
AutoTab:Toggle({ Title = "Auto Attack", Default = false, Callback = function(v) getgenv().AutoAttack = v end })
AutoTab:Toggle({ Title = "Auto Skill", Default = false, Callback = function(v) getgenv().AutoSkill = v end })
AutoTab:Toggle({ Title = "Auto Perk", Default = false, Callback = function(v) getgenv().AutoPerk = v end })

spawn(function()
    while true do
        if getgenv().AutoDoor then
            local gg = { buffer.fromstring("\001\001"), {} }
            ByteNetReliable:FireServer(unpack(gg))
        end
        if getgenv().AutoAttack then
            local args1 = { buffer.fromstring("\a\004\001"), { 0 } }
            ByteNetReliable:FireServer(unpack(args1))
        end
        if getgenv().AutoSkill then
            local args2 = { buffer.fromstring("\a\003\001"), { 0 } }
            ByteNetReliable:FireServer(unpack(args2))
            local args5 = { buffer.fromstring("\a\005\001"), { 0 } }
            ByteNetReliable:FireServer(unpack(args5))
            local args6 = { buffer.fromstring("\a\006\001"), { 0 } }
            ByteNetReliable:FireServer(unpack(args6))
        end
        if getgenv().AutoPerk then
            local args = { buffer.fromstring("\v") }
            ByteNetReliable:FireServer(unpack(args))
            ReplicatedStorage:WaitForChild("getabilites"):InvokeServer()
        end
        task.wait(0.1)
    end
end)

getgenv().Player = 1

getgenv().Setting = getgenv().Setting or {
    Map = "School",
    Difficulty = "Normal",
    Mode = "None"
}

getgenv().AutoJoin = false

local AutoCreateRoom = true

--==[ GUI Setup ]==--
JoinTab:Section({ Title = "Feature Party", Icon = "party-popper" })

-- Set Map Dropdown
JoinTab:Dropdown({
    Title = "Set Map",
    Values = { "School", "Sewers" },
    Default = getgenv().Setting.Map,
    Multi = false,
    Callback = function(value)
        getgenv().Setting.Map = value
    end
})

-- Set Difficulty Dropdown
JoinTab:Dropdown({
    Title = "Set Difficulty",
    Values = { "Normal", "Hard", "Nightmare" },
    Default = getgenv().Setting.Difficulty,
    Multi = false,
    Callback = function(value)
        getgenv().Setting.Difficulty = value
    end
})

-- Set Mode Dropdown
JoinTab:Dropdown({
    Title = "Set Mode",
    Values = { "None", "Campain", "Endless" },
    Default = getgenv().Setting.Mode,
    Multi = false,
    Callback = function(value)
        getgenv().Setting.Mode = value
    end
})

-- Set Max Players Slider
JoinTab:Slider({
    Title = "Set maxPlayers",
    Min = 1,
    Max = 5,
    Default = getgenv().Player,
    Step = 1,
    Callback = function(val)
        getgenv().Player = val
    end
})

-- Auto Join Toggle
JoinTab:Toggle({
    Title = "Auto Join",
    Default = false,
    Callback = function(v)
        getgenv().AutoJoin = v
    end
})

-- Print Current Settings
for k, v in pairs(getgenv().Setting) do
    print("************* "..k, v)
end

--==[ Roblox Services & Player Info ]==--
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local HMNRT = character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera
local screenSize = Camera.ViewportSize
local plrGui = player:WaitForChild("PlayerGui")

--==[ Helper Functions ]==--

-- Check if other players are near a position
local function OtherPlayerNear(TargetPosition, NearValue)
    for _, v in ipairs(Players:GetChildren()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local Dis = (v.Character.HumanoidRootPart.Position - TargetPosition).Magnitude
            if Dis < NearValue then
                return false
            end
        end
    end
    return true
end

-- Click a mode/map button
local function Click_Mode(Grup, TargetButton)
    if Grup and TargetButton ~= "None" then
        for _, v in ipairs(Grup:GetChildren()) do
            local textLabel = v:FindFirstChild("TextLabel")
            if v:IsA("TextButton") and textLabel and textLabel.Text == TargetButton then
                firesignal(v.MouseButton1Click)
            end
        end
    end
end

--==[ Server Hop Functions ]==--
local PlaceId = game.PlaceId

local function getServerList()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        return result.data
    else
        warn("ไม่สามารถดึงข้อมูล server ได้")
        return nil
    end
end

local function findBestServer(maxPlayers)
    maxPlayers = maxPlayers or 5
    local servers = getServerList()
    if not servers then return nil end
    table.sort(servers, function(a, b) return a.playing < b.playing end)
    for _, server in ipairs(servers) do
        if server.id ~= game.JobId and server.playing <= maxPlayers and server.playing > 0 then
            return server
        end
    end
    return nil
end

local function hopToServer(targetServer)
    if not targetServer then
        warn("ไม่พบ server ที่เหมาะสม")
        return false
    end
    local success, errorMessage = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, targetServer.id, player)
    end)
    if not success then
        warn("ไม่สามารถ teleport ได้: " .. tostring(errorMessage))
        return false
    end
    return true
end

local function serverHop(maxPlayers)
    local targetServer = findBestServer(maxPlayers)
    if targetServer then
        return hopToServer(targetServer)
    else
        wait(2)
        targetServer = findBestServer(maxPlayers + 3)
        if targetServer then
            return hopToServer(targetServer)
        else
            warn("ไม่พบ server ที่เหมาะสมเลย")
            return false
        end
    end
end

_G.ServerHopper = {hop = serverHop, findBest = findBestServer, getServers = getServerList}

--==[ Auto Create Room Loop ]==--
task.spawn(function()
    local Match = workspace:WaitForChild("Match")
    local Created, TimeReTry = false, 0
    local SpawnCFrame = HMNRT.CFrame

    local StartPlaceRedo = plrGui:WaitForChild("GUI"):WaitForChild("StartPlaceRedo")
    local iContent = StartPlaceRedo:WaitForChild("Content"):WaitForChild("iContent")
    local Start_Button = iContent:WaitForChild("Button")
    local F_pls = iContent:WaitForChild("options"):WaitForChild("playerselect"):WaitForChild("F")
    local De_PlayerSize, Plus_PlayerSize = F_pls:WaitForChild("l"), F_pls:WaitForChild("r")

    local maps_select = iContent:WaitForChild("maps")
    local modes_select = iContent:WaitForChild("modes")
    local upmodes_select = iContent:WaitForChild("upmodes")

    while true do
        if AutoCreateRoom then
            print("AutoCreateRoom is Reapeat")
            repeat
                if TimeReTry >= 5 then
                    serverHop(15)
                end

                -- Move to Match Part
                if StartPlaceRedo.Visible == false and not Created then
                    for _, PartTouch in ipairs(Match:GetChildren()) do
                        if PartTouch:IsA("BasePart") and OtherPlayerNear(PartTouch.Position, 7) then
                            if not Created then
                                pcall(function()
                                    HMNRT.CFrame = CFrame.new(PartTouch.Position)
                                    wait(1.5)
                                    if StartPlaceRedo.Visible then
                                        Created = true
                                    end
                                end)
                            end
                        end
                    end
                    HMNRT.CFrame = SpawnCFrame * CFrame.new(0,5,0)
                    TimeReTry = TimeReTry + 1
                    task.wait(5)
                end

                -- Create Room
                if StartPlaceRedo.Visible then
                    for i=1,10 do
                        firesignal(De_PlayerSize.MouseButton1Click)
                        wait(0.05)
                    end
                    print("*** Map "..getgenv().Setting.Map.." Difficulty "..getgenv().Setting.Difficulty.." Mode "..getgenv().Setting.Mode)
                    wait(0.7)
                    if getgenv().Setting.Mode ~= "None" then
                        Click_Mode(upmodes_select, getgenv().Setting.Mode)
                    end
                    wait(0.7)
                    Click_Mode(maps_select, getgenv().Setting.Map)
                    wait(0.7)
                    Click_Mode(modes_select, getgenv().Setting.Difficulty)
                    wait(1)
                    firesignal(Start_Button.MouseButton1Click)
                    Created = true
                end
                wait(1)
            until not AutoCreateRoom
        end
        wait(1)
    end
end)

PlayerTab:Section({ Title = "Feature Player", Icon = "user" })

-- Player Tab Vars
getgenv().speedEnabled = false
getgenv().speedValue = 20

PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = {Min = 16, Max = 600, Default = 20},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50

PlayerTab:Slider({
    Title = "Set Jump Value",
    Value = {Min = 10, Max = 600, Default = 50},
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 50 end
    end
})

PlayerTab:Section({ Title = "Player Misc", Icon = "sliders-horizontal" })

local noclipConnection

PlayerTab:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

PlayerTab:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local uis = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer
        local infJumpConnection

        if state then
            infJumpConnection = uis.JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            getgenv().infJumpConnection = infJumpConnection
        else
            if getgenv().infJumpConnection then
                getgenv().infJumpConnection:Disconnect()
                getgenv().infJumpConnection = nil
            end
        end
    end
})

PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})

MiscTab:Section({ Title = "Feature Visual", Icon = "eye" })

local Lighting = game:GetService("Lighting")
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogStart = Lighting.FogStart
local oldFogEnd = Lighting.FogEnd
local oldFogColor = Lighting.FogColor

local fullBrightConnection
local noFogConnection

MiscTab:Toggle({
    Title = "FullBright",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 5
            Lighting.ClockTime = 14

            fullBrightConnection = RunService.RenderStepped:Connect(function()
                if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
                if Lighting.Brightness ~= 10 then Lighting.Brightness = 10 end
                if Lighting.Ambient ~= Color3.new(1,1,1) then Lighting.Ambient = Color3.new(1,1,1) end
            end)
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            Lighting.Ambient = oldAmbient
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e10
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)

            noFogConnection = RunService.RenderStepped:Connect(function()
                if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end
                if Lighting.FogEnd ~= 1e10 then Lighting.FogEnd = 1e10 end
                if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then Lighting.FogColor = Color3.fromRGB(255, 255, 255) end
            end)
        else
            if noFogConnection then
                noFogConnection:Disconnect()
                noFogConnection = nil
            end
            Lighting.FogStart = oldFogStart
            Lighting.FogEnd = oldFogEnd
            Lighting.FogColor = oldFogColor
        end
    end
})

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name = "VibrantEffect"
vibrantEffect.Saturation = 1
vibrantEffect.Contrast = 0.4
vibrantEffect.Brightness = 0.05
vibrantEffect.Enabled = false
vibrantEffect.Parent = Lighting

MiscTab:Toggle({
    Title = "Vibrant Colors",
    Default = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            vibrantEffect.Enabled = true
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            vibrantEffect.Enabled = false
        end
    end
})


local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 10), Color3.fromRGB(0, 255, 0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X - 100, 30), Color3.fromRGB(0, 255, 0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
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
                msText.Text = "Ew Wifi Ping: " .. ping .. " ms"
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)

MiscTab:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

MiscTab:Toggle({
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

MiscTab:Button({
    Title = "FPS Boost (Fixed)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("[Boost] FPS Boost Applied")
    end
})
