repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Confirm Popup
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Protect the Stash",
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
    Title = "DYHUB - Protect the Stash (Beta)",
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

local autoStartRunning = false

MainTab:Toggle({
    Title = "Infinite level",
    Icon = "badge-dollar-sign",
    Default = false,
    Callback = function(state)
        autoStartRunning = state
        if state then
            task.spawn(function()
                while autoStartRunning do
                    ReplicatedStorage:WaitForChild("Events"):WaitForChild("LevelUp"):FireServer()
                    task.wait(0.001)
                end
            end)
        else
            print("[DYHUB] Infinite level stopped.")
        end
    end
})
