repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "DYHUB Loaded! - Anime Rails",
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
    Title = "DYHUB - Anime Rails",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })

local player = LocalPlayer
local data = player:WaitForChild("Data") -- ensure data is loaded
local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ChangeValue")

local morphInputValue = ""
local classInputValue = ""
local auraInputValue = ""

-- ดึงชื่อทั้งหมดจาก Data
local function getDataNames()
    local names = {}
    for _, child in ipairs(data:GetChildren()) do
        table.insert(names, child.Name)
    end
    return names
end

MainTab:Button({
    Title = "Dupe All (Click me for All)",
    Icon = "atom",
    Callback = function()
        for _, name in ipairs(getDataNames()) do
            event:FireServer("SetMorphBuy", name, 0)
            wait(0.05)
        end
        print("[DYHUB] All Morphs, Classes and Auras unlocked from Data!")
    end,
})

MainTab:Input({
    Title = "Dupe Morph",
    Placeholder = "Use the name from Data.Morph",
    Callback = function(text)
        morphInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Morph",
    Icon = "crown",
    Callback = function()
        local found = false
        for _, name in ipairs(getDataNames()) do
            if name:lower() == morphInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Morph unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Morph:", morphInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Class",
    Placeholder = "Use the name from Data.Class",
    Callback = function(text)
        classInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Class",
    Icon = "swords",
    Callback = function()
        local found = false
        for _, name in ipairs(getDataNames()) do
            if name:lower() == classInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Class unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Class:", classInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Aura",
    Placeholder = "Use the name from Data.Aura",
    Callback = function(text)
        auraInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Aura",
    Icon = "flame",
    Callback = function()
        local found = false
        for _, name in ipairs(getDataNames()) do
            if name:lower() == auraInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Aura unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Aura:", auraInputValue)
        end
    end,
})
