repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--// Settings
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

--// AutoFarm
local farmConnection, smoothConnection
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
            local offset = Vector3.new(0,0,0)

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

            -- Smooth movement
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(npcRoot.Position + offset), 0.3)
        end
    end)
end

function stopAutoFarm()
    getgenv().autoFarmActive = false
    if farmConnection then farmConnection:Disconnect() farmConnection=nil end
    if smoothConnection then smoothConnection:Disconnect() smoothConnection=nil end
end

--// Auto Attack/Skill/Door/Perk Loop
local attackLoop
function startAutoAttackLoop()
    if attackLoop then return end
    attackLoop = spawn(function()
        while getgenv().autoFarmActive do
            -- Auto Door
            if getgenv().AutoDoor then
                local args3 = { buffer.fromstring("\006\001"), {workspace:WaitForChild("School"):WaitForChild("Doors"):WaitForChild("HallwayDoor")} }
                ByteNetReliable:FireServer(unpack(args3))
            end

            -- Auto Attack
            if getgenv().AutoAttack then
                local args1 = { buffer.fromstring("\a\004\001"), {0} }
                ByteNetReliable:FireServer(unpack(args1))
            end

            -- Auto Skill
            if getgenv().AutoSkill then
                local skillArgs = { buffer.fromstring("\a\003\001"), buffer.fromstring("\a\005\001"), buffer.fromstring("\a\006\001") }
                for _, arg in ipairs(skillArgs) do
                    ByteNetReliable:FireServer(arg, {0})
                end
            end

            -- Auto Perk
            if getgenv().AutoPerk then
                local args = { buffer.fromstring("\v") }
                ByteNetReliable:FireServer(unpack(args))
                ReplicatedStorage:WaitForChild("getabilites"):InvokeServer()
            end

            task.wait(0.1)
        end
        attackLoop = nil
    end)
end

--// AutoCollect Items
spawn(function()
    while true do
        if getgenv().AutoCollect then
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
                        end
                        task.wait(0.05)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

--// AutoRadio / AutoHeli / AutoPower
local function activatePrompt(prompt)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local originalCFrame = hrp.CFrame
    hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0,3,0)
    task.wait(0.1)
    fireproximityprompt(prompt)
    task.wait(0.1)
    hrp.CFrame = originalCFrame
end

spawn(function()
    while true do
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Auto Radio
            if getgenv().AutoRadio then
                local radioPrompt = workspace:FindFirstChild("School") and workspace.School:FindFirstChild("Rooms") and workspace.School.Rooms:FindFirstChild("RooftopBoss") and workspace.School.Rooms.RooftopBoss:FindFirstChild("RadioObjective") and workspace.School.Rooms.RooftopBoss.RadioObjective:FindFirstChild("ProximityPrompt")
                if radioPrompt then activatePrompt(radioPrompt) end
            end
            -- Auto Helicopter
            if getgenv().AutoHeli then
                local heliPrompt = workspace:FindFirstChild("School") and workspace.School:FindFirstChild("Rooms") and workspace.School.Rooms:FindFirstChild("RooftopBoss") and workspace.School.Rooms.RooftopBoss:FindFirstChild("HeliObjective") and workspace.School.Rooms.RooftopBoss.HeliObjective:FindFirstChild("ProximityPrompt")
                if heliPrompt then activatePrompt(heliPrompt) end
            end
            -- Auto Power
            if getgenv().AutoPower then
                local powerPrompt = workspace:FindFirstChild("Sewers") and workspace.Sewers:FindFirstChild("Rooms") and workspace.Sewers.Rooms:FindFirstChild("BossRoom") and workspace.Sewers.Rooms.BossRoom:FindFirstChild("generator") and workspace.Sewers.Rooms.BossRoom.generator:FindFirstChild("gen") and workspace.Sewers.Rooms.BossRoom.generator.gen:FindFirstChild("pom")
                if powerPrompt then activatePrompt(powerPrompt) end
            end
        end
        task.wait(0.2)
    end
end)

--// ESP GUI
local Window = WindUI:CreateWindow({
    Title = "DYHUB | Hunty Zombie",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 1.6.0",
    Size = UDim2.fromOffset(500,300),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title="Main", Icon="rocket" })
local EspTab = Window:Tab({ Title="ESP", Icon="eye" })
local AutoTab = Window:Tab({ Title="Auto", Icon="crown" })

-- AutoFarm Controls
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
        if value then startAutoFarm(); startAutoAttackLoop() else stopAutoFarm() end
    end
})
MainTab:Toggle({
    Title="Auto Collect Items", 
    Default=false,
    Callback=function(value) getgenv().AutoCollect = value end
})

-- ESP Controls
EspTab:Section({ Title="Feature ESP", Icon="eye" })
EspTab:Toggle({
    Title = "Enable ESP",
    Default = getgenv().ESPEnabled,
    Callback = function(value) getgenv().ESPEnabled = value end
})
EspTab:Dropdown({
    Title = "ESP Type",
    Values = {"Highlight", "BoxHandleAdornment"},
    Default = getgenv().ESPType,
    Multi = false,
    Callback = function(value) getgenv().ESPType = value end
})
EspTab:Toggle({Title="Show Name", Default=true, Callback=function(value) getgenv().ESPShowName = value end})
EspTab:Toggle({Title="Show Distance", Default=true, Callback=function(value) getgenv().ESPShowDistance = value end})
EspTab:Slider({Title="Max Distance", Value={Min=1, Max=100, Default=getgenv().ESPDistance}, Step=1, Callback=function(val) getgenv().ESPDistance=val end})

-- Update ESP
RunService.RenderStepped:Connect(function()
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
            -- Name / Distance
            if getgenv().ESPShowName and not hrp:FindFirstChild("ESP_NameTag") then
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
            local label = hrp:FindFirstChild("ESP_NameTag") and hrp.ESP_NameTag:FindFirstChildOfClass("TextLabel")
            if label and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                label.Text = getgenv().ESPShowDistance and (getgenv().ESPName.." - ["..math.floor(dist).."m]") or getgenv().ESPName
                label.Visible = dist <= getgenv().ESPDistance
            end
        end
    end
end)
