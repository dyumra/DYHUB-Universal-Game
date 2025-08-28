repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

getgenv().autoFarmActive = false
getgenv().DistanceValue = 5
getgenv().setPositionMode = "Above"
local spinAngle = 0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")

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

local farmConnection
local attackConnection

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

            -- เลือกตำแหน่ง
            if getgenv().setPositionMode == "Above" then
                offset = Vector3.new(0, getgenv().DistanceValue, 0)
            elseif getgenv().setPositionMode == "Under" then
                offset = Vector3.new(0, -getgenv().DistanceValue, 0)
            elseif getgenv().setPositionMode == "Front" then
                offset = npcRoot.CFrame.LookVector * getgenv().DistanceValue
            elseif getgenv().setPositionMode == "Back" then
                offset = -npcRoot.CFrame.LookVector * getgenv().DistanceValue
            elseif getgenv().setPositionMode == "Spin" then
                spinAngle += dt * 2
                local radius = getgenv().DistanceValue
                offset = Vector3.new(math.cos(spinAngle) * radius, 0, math.sin(spinAngle) * radius)
            end

            hrp.CFrame = CFrame.new(npcRoot.Position + offset)
        end
    end)

    attackConnection = RunService.Heartbeat:Connect(function()
    if not getgenv().autoFarmActive then return end

    local args1 = {
        buffer.fromstring("\a\004\001"),
        {0}
    }
    local args2 = {
        buffer.fromstring("\a\003\001"),
        {0}
    }
    local args3 = {
        buffer.fromstring("\006\001"),
        {
            workspace:WaitForChild("School"):WaitForChild("Doors"):WaitForChild("HallwayDoor")
        }
    }

    ByteNetReliable:FireServer(unpack(args3))
    ByteNetReliable:FireServer(unpack(args1))
    ByteNetReliable:FireServer(unpack(args2))
end)

function stopAutoFarm()
    getgenv().autoFarmActive = false
    if farmConnection then farmConnection:Disconnect() farmConnection=nil end
    if attackConnection then attackConnection:Disconnect() attackConnection=nil end
end


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
                game.Players.LocalPlayer:Kick("FUCK YOU NIGGA CANCEL DYHUB????")
            end
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                Confirmed = true
            end
        }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB | Hunty Zombie",
    IconThemed = true,
    Icon = "star",
    Author = "Version: 1.5.2",
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

MainTab:Section({ Title="Feature Farm", Icon="sword" })

MainTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=getgenv().setPositionMode,
    Multi=false,
    Callback=function(value)
        getgenv().setPositionMode = value
    end
})

MainTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=30, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val)
        getgenv().DistanceValue = val
    end
})


MainTab:Toggle({
    Title="Auto Farm",
    Default=false,
    Callback=function(value)
        if value then
            startAutoFarm()
        else
            stopAutoFarm()
        end
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
                                if item:IsA("BasePart") then
                                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
        end
    end
})

EspTab:Section({ Title="Feature Esp", Icon="eye" })

EspTab:Dropdown({
    Title = "ESP Type",
    Values = {"Highlight", "BoxHandleAdornment"},
    Default = getgenv().ESPType,
    Multi = false,
    Callback = function(value)
        getgenv().ESPType = value
    end
})

EspTab:Toggle({
    Title = "Enable ESP",
    Default = getgenv().ESPEnabled,
    Callback = function(value)
        getgenv().ESPEnabled = value
    end
})

EspTab:Section({ Title="Settings ESP", Icon="settings" })

EspTab:Toggle({
    Title = "Show Name",
    Default = getgenv().ESPShowName,
    Callback = function(value)
        getgenv().ESPShowName = value
    end
})

EspTab:Toggle({
    Title = "Show Distance",
    Default = getgenv().ESPShowDistance,
    Callback = function(value)
        getgenv().ESPShowDistance = value
    end
})

EspTab:Slider({
    Title = "Max Distance",
    Value = {Min=1, Max=100, Default=getgenv().ESPDistance},
    Step = 1,
    Callback = function(val)
        getgenv().ESPDistance = val
    end
})

local function updateESP()
    if not getgenv().ESPEnabled then return end
    local entities = workspace:FindFirstChild("Entities")
    if not entities then return end

    for _, npc in ipairs(entities:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local hrp = npc.HumanoidRootPart

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
    if getgenv().ESPEnabled then
        updateESP()
    end
end)

AutoTab:Section({ Title="Feature Collect", Icon="flame" })

-- ฟังก์ชันวาร์ปไปกด ProximityPrompt แล้วกลับตำแหน่งเดิม
local function activatePrompt(prompt)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local originalCFrame = hrp.CFrame

    -- วาร์ปไปใกล้ prompt
    hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0,3,0)
    task.wait(0.1) -- รอให้สามารถใช้งาน

    -- Trigger ProximityPrompt
    fireproximityprompt(prompt)
    task.wait(0.1)

    -- กลับตำแหน่งเดิม
    hrp.CFrame = originalCFrame
end

-- Toggle Auto Radio
AutoTab:Toggle({
    Title = "Auto Radio",
    Default = false,
    Callback = function(value)
        getgenv().AutoRadio = value
    end
})

-- Toggle Auto Helicopter
AutoTab:Toggle({
    Title = "Auto Helicopter",
    Default = false,
    Callback = function(value)
        getgenv().AutoHeli = value
    end
})

-- Toggle Auto Power
AutoTab:Toggle({
    Title = "Auto Power",
    Default = false,
    Callback = function(value)
        getgenv().AutoPower = value
    end
})

-- Loop ตรวจสอบ ProximityPrompt
spawn(function()
    while true do
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then

            -- Auto Radio
            if getgenv().AutoRadio then
                local radioPrompt = workspace:FindFirstChild("School") 
                    and workspace.School:FindFirstChild("Rooms")
                    and workspace.School.Rooms:FindFirstChild("RooftopBoss")
                    and workspace.School.Rooms.RooftopBoss:FindFirstChild("RadioObjective")
                    and workspace.School.Rooms.RooftopBoss.RadioObjective:FindFirstChild("ProximityPrompt")
                if radioPrompt then
                    activatePrompt(radioPrompt)
                end
            end

            -- Auto Helicopter
            if getgenv().AutoHeli then
                local heliPrompt = workspace:FindFirstChild("School") 
                    and workspace.School:FindFirstChild("Rooms")
                    and workspace.School.Rooms:FindFirstChild("RooftopBoss")
                    and workspace.School.Rooms.RooftopBoss:FindFirstChild("HeliObjective")
                    and workspace.School.Rooms.RooftopBoss.HeliObjective:FindFirstChild("ProximityPrompt")
                if heliPrompt then
                    activatePrompt(heliPrompt)
                end
            end

            -- Auto Power
            if getgenv().AutoPower then
                local powerPrompt = workspace:FindFirstChild("Sewers")
                    and workspace.Sewers:FindFirstChild("Rooms")
                    and workspace.Sewers.Rooms:FindFirstChild("BossRoom")
                    and workspace.Sewers.Rooms.BossRoom:FindFirstChild("generator")
                    and workspace.Sewers.Rooms.BossRoom.generator:FindFirstChild("gen")
                    and workspace.Sewers.Rooms.BossRoom.generator.gen:FindFirstChild("pom")
                if powerPrompt then
                    activatePrompt(powerPrompt)
                end
            end

        end
        task.wait(0.2)
    end
end)

AutoTab:Section({ Title="Feature Auto", Icon="sword" })

-- Toggle Auto Door
AutoTab:Toggle({
    Title = "Auto Door",
    Default = false,
    Callback = function(value)
        getgenv().AutoDoor = value
    end
})

-- Toggle Auto Attack
AutoTab:Toggle({
    Title = "Auto Attack",
    Default = false,
    Callback = function(value)
        getgenv().AutoAttack = value
    end
})

-- Toggle Auto Skill
AutoTab:Toggle({
    Title = "Auto Skill",
    Default = false,
    Callback = function(value)
        getgenv().AutoSkill = value
    end
})

-- Toggle Auto Perk
AutoTab:Toggle({
    Title = "Auto Perk",
    Default = false,
    Callback = function(value)
        getgenv().AutoPerk = value
    end
})

-- Loop ตรวจสอบและส่ง args
spawn(function()
    local RepStorage = game:GetService("ReplicatedStorage")
    local ByteNetReliable = RepStorage:WaitForChild("ByteNetReliable")
    while true do
        -- Auto Door
        if getgenv().AutoDoor then
            local args3 = {
                buffer.fromstring("\006\001"),
                {workspace:WaitForChild("School"):WaitForChild("Doors"):WaitForChild("HallwayDoor")}
            }
            ByteNetReliable:FireServer(unpack(args3))
        end

        -- Auto Attack
        if getgenv().AutoAttack then
            local args1 = {
                buffer.fromstring("\a\004\001"),
                {0}
            }
            ByteNetReliable:FireServer(unpack(args1))
        end

        -- Auto Skill
        if getgenv().AutoSkill then
            local args2 = {
                buffer.fromstring("\a\003\001"),
                {0}
            }
            ByteNetReliable:FireServer(unpack(args2))
        end

        -- Auto Perk
        if getgenv().AutoPerk then
            local args = { buffer.fromstring("\v") }
            ByteNetReliable:FireServer(unpack(args))
            RepStorage:WaitForChild("getabilites"):InvokeServer()
        end

        task.wait(0.1)
    end
end)
