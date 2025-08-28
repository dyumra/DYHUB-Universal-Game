repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

getgenv().autoFarmActive = false
getgenv().DistanceValue = 5
getgenv().setPositionMode = "Above"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function getClosestNPC()
    local entities = workspace:FindFirstChild("Entities")
    if not entities then return nil end

    for _, npc in ipairs(entities:GetChildren()) do
        if npc:FindFirstChild("Head") then
            return npc
        end
    end
    return nil
end

local farmConnection

function startAutoFarm()
    if farmConnection then farmConnection:Disconnect() end
    getgenv().autoFarmActive = true

    farmConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().autoFarmActive then return end

        local npc = getClosestNPC()
        if npc and npc:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local head = npc.Head

            hrp.CFrame = head.CFrame * CFrame.new(0, 3, 0) 
        end
    end)
end

function stopAutoFarm()
    getgenv().autoFarmActive = false
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end
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
    Author = "Version: 1.3.7",
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

MainTab:Section({ Title="Feature Farm", Icon="badge-dollar-sign" })

MainTab:Dropdown({
    Title="Set Position",
    Values={"Spin","Above","Back","Under","Front"},
    Default=setPositionMode,
    Multi=false,
    Callback=function(value) setPositionMode=value end
})

MainTab:Slider({
    Title="Set Distance to NPC",
    Value={Min=0, Max=20, Default=getgenv().DistanceValue},
    Step=1,
    Callback=function(val) getgenv().DistanceValue=val end
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
