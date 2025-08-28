-- dasdasdasdasdad

repeat task.wait() until game:IsLoaded()

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

-- โหลด WindUI ปลอดภัย
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

-- เริ่มตั้งค่า getgenv
getgenv().ESPEnabled = false
getgenv().ESPType = "Highlight"
getgenv().ESPShowName = true
getgenv().ESPShowDistance = true
getgenv().ESPDistance = 50
getgenv().ESPName = "NPC"

getgenv().AutoDoor = true
getgenv().AutoAttack = true
getgenv().AutoSkill = true
getgenv().AutoPerk = true

getgenv().AutoRadio = true
getgenv().AutoHeli = true
getgenv().AutoPower = true

getgenv().AutoCollect = true
getgenv().autoFarmActive = true
getgenv().DistanceValue = 10
getgenv().setPositionMode = "Above"
local spinAngle = 0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")

-- ฟังก์ชัน Auto Farm
local farmConnection, attackConnection

local function getClosestNPC()
    local entities = workspace:FindFirstChild("Entities")
    if not entities then return nil end
    for _, npc in ipairs(entities:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            return npc
        end
    end
    return nil
end

function startAutoFarm()
    stopAutoFarm()
    getgenv().autoFarmActive = true

    farmConnection = RunService.RenderStepped:Connect(function(dt)
        if not getgenv().autoFarmActive then return end
        local npc = getClosestNPC()
        if npc and npc:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local npcRoot = npc.HumanoidRootPart

            -- คำนวณ offset ตามโหมด
            local offset = Vector3.new(0,getgenv().DistanceValue,0)
            if getgenv().setPositionMode == "Above" then
                offset = Vector3.new(0,getgenv().DistanceValue,0)
            elseif getgenv().setPositionMode == "Under" then
                offset = Vector3.new(0,-getgenv().DistanceValue,0)
            elseif getgenv().setPositionMode == "Front" then
                offset = npcRoot.CFrame.LookVector * getgenv().DistanceValue
            elseif getgenv().setPositionMode == "Back" then
                offset = -npcRoot.CFrame.LookVector * getgenv().DistanceValue
            elseif getgenv().setPositionMode == "Spin" then
                spinAngle += dt * 2
                local radius = getgenv().DistanceValue
                offset = Vector3.new(math.cos(spinAngle) * radius, 0, math.sin(spinAngle) * radius)
            end

            -- ล็อกตัวละครให้นิ่ง ไม่กระตุก
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(npcRoot.Position + offset) -- วาร์ปตรง ๆ แบบนิ่ง
        end
    end)

    attackConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().autoFarmActive then return end
        local npc = getClosestNPC()
        if npc then
            -- ยิงเฉพาะ NPC เท่านั้น
            local args1 = { buffer.fromstring("\a\004\001"), {0} }
            local args2 = { buffer.fromstring("\a\003\001"), {0} }
            local args5 = { buffer.fromstring("\a\005\001"), {0} }
            local args6 = { buffer.fromstring("\a\006\001"), {0} }
            local args3 = { buffer.fromstring("\006\001"), {workspace:WaitForChild("School"):WaitForChild("Doors"):WaitForChild("HallwayDoor")} }
            ByteNetReliable:FireServer(unpack(args3))
            ByteNetReliable:FireServer(unpack(args1))
            ByteNetReliable:FireServer(unpack(args2))
            ByteNetReliable:FireServer(unpack(args5))
            ByteNetReliable:FireServer(unpack(args6))
        end
    end)
end

function stopAutoFarm()
    getgenv().autoFarmActive = false
    if farmConnection then farmConnection:Disconnect() farmConnection = nil end
    if attackConnection then attackConnection:Disconnect() attackConnection = nil end
end
-- สร้าง GUI
local Window = WindUI:CreateWindow({
    Title = "DYHUB | Hunty Zombie",
    IconThemed = true,
    Icon = "star",
    Author = "Version: AUTO FARM",
    Size = UDim2.fromOffset(500,300),
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
local EspTab = Window:Tab({ Title="Esp", Icon="eye" })
local AutoTab = Window:Tab({ Title="Auto", Icon="crown" })
Window:SelectTab(1)

-- ================= MainTab =================
MainTab:Section({ Title="Feature Farm", Icon="sword" })

MainTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=getgenv().setPositionMode,
    Multi=false,
    Callback=function(value) getgenv().setPositionMode = value end
})

MainTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=30, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue = val end
})

MainTab:Toggle({
    Title="Auto Farm",
    Default=false,
    Callback=function(value)
        if value then startAutoFarm() else stopAutoFarm() end
    end
})

MainTab:Toggle({
    Title="Auto Collect Items",
    Default=false,
    Callback=function(value)
        getgenv().AutoCollect = value
        if value then
            spawn(function()
                while getgenv().AutoCollect do
                    local entities = workspace:FindFirstChild("Entities")
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
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(item.Position + Vector3.new(0,3,0))
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
EspTab:Section({ Title="Feature ESP", Icon="eye" })

EspTab:Dropdown({
    Title = "ESP Type",
    Values = {"Highlight","BoxHandleAdornment"},
    Default = getgenv().ESPType,
    Multi = false,
    Callback = function(value) getgenv().ESPType = value end
})

EspTab:Toggle({
    Title = "Enable ESP",
    Default = getgenv().ESPEnabled,
    Callback = function(value) getgenv().ESPEnabled = value end
})

EspTab:Section({ Title="Settings ESP", Icon="settings" })

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
    Value = {Min=1, Max=100, Default=getgenv().ESPDistance},
    Step = 1,
    Callback = function(val) getgenv().ESPDistance = val end
})

-- ฟังก์ชัน update ESP
local function updateESP()
    if not getgenv().ESPEnabled then return end
    local entities = workspace:FindFirstChild("Entities")
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
                box.Size = hrp.Size or Vector3.new(2,2,1)
                box.Color3 = Color3.fromRGB(255,0,0)
                box.AlwaysOnTop = true
                box.Parent = hrp
            end

            -- Name + Distance
            if getgenv().ESPShowName then
                if not hrp:FindFirstChild("ESP_NameTag") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ESP_NameTag"
                    bill.Adornee = hrp
                    bill.Size = UDim2.new(0,120,0,50)
                    bill.AlwaysOnTop = true
                    bill.Parent = hrp

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.fromRGB(255,0,0)
                    text.TextScaled = true
                    text.Parent = bill
                end

                local label = hrp:FindFirstChild("ESP_NameTag"):FindFirstChildOfClass("TextLabel")
                if label and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist <= getgenv().ESPDistance then
                        if getgenv().ESPShowDistance then
                            label.Text = getgenv().ESPName.." - ["..math.floor(dist).."m]"
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
AutoTab:Section({ Title="Feature Collect", Icon="hand" })

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
    local targetCFrame = prompt.Parent.CFrame + Vector3.new(0,3,0)
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
AutoTab:Toggle({ Title="Auto Radio", Default=false, Callback=function(v) getgenv().AutoRadio=v end })
AutoTab:Toggle({ Title="Auto Helicopter", Default=false, Callback=function(v) getgenv().AutoHeli=v end })
AutoTab:Toggle({ Title="Auto Power", Default=false, Callback=function(v) getgenv().AutoPower=v end })

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
AutoTab:Section({ Title="Feature Auto", Icon="sword" })
AutoTab:Toggle({ Title="Auto Door", Default=false, Callback=function(v) getgenv().AutoDoor=v end })
AutoTab:Toggle({ Title="Auto Attack", Default=false, Callback=function(v) getgenv().AutoAttack=v end })
AutoTab:Toggle({ Title="Auto Skill", Default=false, Callback=function(v) getgenv().AutoSkill=v end })
AutoTab:Toggle({ Title="Auto Perk", Default=false, Callback=function(v) getgenv().AutoPerk=v end })

spawn(function()
    while true do
        if getgenv().AutoDoor then
            local args3 = { buffer.fromstring("\006\001"), {workspace:WaitForChild("School"):WaitForChild("Doors"):WaitForChild("HallwayDoor")} }
            ByteNetReliable:FireServer(unpack(args3))
        end
        if getgenv().AutoAttack then
            local args1 = { buffer.fromstring("\a\004\001"), {0} }
            ByteNetReliable:FireServer(unpack(args1))
        end
        if getgenv().AutoSkill then
            local args2 = { buffer.fromstring("\a\003\001"), {0} }
            ByteNetReliable:FireServer(unpack(args2))
            local args5 = { buffer.fromstring("\a\005\001"), {0} }
            ByteNetReliable:FireServer(unpack(args5))
            local args6 = { buffer.fromstring("\a\006\001"), {0} }
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

AutoTab:Section({ Title="Feature Farm", Icon="infinity" })
AutoTab:Button({
    Title = "Auto Farm (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Detail/refs/heads/main/Lua.lua"))()
    end
})
