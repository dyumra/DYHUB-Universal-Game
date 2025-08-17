repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Anime Royale",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - Anime Royale (Premium)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
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

local MainTab = Window:Tab({ Title = "String Event", Icon = "shell" })

Window:SelectTab(1)

MainTab:Section({ Title = "Dupe Item", Icon = "star" })

local morphInputValue = ""
local quantityValue = 1

MainTab:Input({
    Title = "Use the name from String Shop",
    Placeholder = "Item Name",
    Callback = function(text)
        morphInputValue = text
    end,
})

MainTab:Input({
    Title = "Enter amount to dupe",
    Placeholder = "Quantity (1–10)",
    Callback = function(text)
        local number = tonumber(text)
        if number and number >= 1 and number <= 10 then
            quantityValue = number
        end
    end,
})

MainTab:Button({
    Title = "Dupe",
    Icon = "crown",
    Callback = function()
        if morphInputValue == "" then return end
        local springShop = ReplicatedStorage:WaitForChild("EventsAndFunctions"):WaitForChild("RemoteFunctions"):WaitForChild("SpringShop")
        springShop:InvokeServer(morphInputValue, -quantityValue)
        task.wait(0.5)
        springShop:InvokeServer(morphInputValue, quantityValue)
    end,
})
