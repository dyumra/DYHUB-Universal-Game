repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Popup
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Bomb A Friend",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

-- Create Window
local Window = WindUI:CreateWindow({
    Title = "DYHUB - Bomb A Friend",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Dark",
})

-- Edit Open Button
Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local InfTab = Window:Tab({ Title = "Infinite", Icon = "infinity" })

-- Variables
local bombRunning, winsRunning, starRunning, rebirthRunning, upgradeRunning = false, false, false, false, false
local bombAmount, winAmount, starAmount = 0, 0, 0

-------------------------------------------------
-- Infinite Tab Inputs
-------------------------------------------------

InfTab:Input({
    Title = "Bomb Amount",
    Placeholder = "Enter Bomb Amount",
    Callback = function(text)
        bombAmount = tonumber(text) or 0
    end
})

InfTab:Toggle({
    Title = "Get Bomb",
    Default = false,
    Callback = function(state)
        bombRunning = state
        if state then
            task.spawn(function()
                while bombRunning do
                    if bombAmount > 0 then
                        ReplicatedStorage.Remotes.DataEvent:FireServer("Power", bombAmount)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

InfTab:Input({
    Title = "Wins Amount",
    Placeholder = "Enter Wins Amount",
    Callback = function(text)
        winAmount = tonumber(text) or 0
    end
})

InfTab:Toggle({
    Title = "Get Wins",
    Default = false,
    Callback = function(state)
        winsRunning = state
        if state then
            task.spawn(function()
                while winsRunning do
                    if winAmount > 0 then
                        ReplicatedStorage.Remotes.DataEvent:FireServer("Reward", winAmount)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

InfTab:Input({
    Title = "Star Amount",
    Placeholder = "Enter Star Amount",
    Callback = function(text)
        starAmount = tonumber(text) or 0
    end
})

InfTab:Toggle({
    Title = "Get Star",
    Default = false,
    Callback = function(state)
        starRunning = state
        if state then
            task.spawn(function()
                while starRunning do
                    if starAmount > 0 then
                        ReplicatedStorage.Remotes.DataEvent:FireServer("Gem", starAmount)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-------------------------------------------------
-- Main Tab Features
-------------------------------------------------

-- Auto Rebirth
MainTab:Toggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        rebirthRunning = state
        if state then
            task.spawn(function()
                while rebirthRunning do
                    ReplicatedStorage.Remotes.RebirthEvent:FireServer("Rebirth")
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Auto Upgrade All
MainTab:Toggle({
    Title = "Auto Upgrade All",
    Default = false,
    Callback = function(state)
        upgradeRunning = state
        if state then
            task.spawn(function()
                while upgradeRunning do
                    local upgrades = {
                        "RainbowCrafted",
                        "GoldenCrafted",
                        "Lucky",
                        "DoubleReward",
                        "MoreReward",
                        "MoreAcceleration",
                        "MoreStar",
                        "MorePower"
                    }
                    for _, upgrade in ipairs(upgrades) do
                        ReplicatedStorage.Remotes.UpgradeEvent:FireServer(upgrade)
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
})

-- Best Egg X8
MainTab:Button({
    Title = "Best Egg X8",
    Callback = function()
        local args = {
            "TryDrawPet",
            {
                Currency = "Reward",
                Count = 8,
                EggId = "Egg15",
                Price = 15000000000,
                PetRate = {
                    Egg15_3 = 1370000,
                    Egg15_5 = 20000,
                    Egg15_1 = 82130000,
                    Egg15_4 = 50000,
                    Egg15_2 = 16430000
                }
            },
            8
        }
        ReplicatedStorage.Remotes.PetEvent:FireServer(unpack(args))
    end
})
