repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Confirm Popup
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

-- สร้างหน้าต่างหลัก
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

-- ฟังก์ชันช่วย toggle UI
local function toggleGui(guiName)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(guiName)
    if gui then
        gui.Enabled = not gui.Enabled
    end
end

-- ฟังก์ชัน dupe (Shop / Capsule)
local function doDupe(itemName, remoteName, quantity)
    local remote = ReplicatedStorage.EventsAndFunctions.RemoteFunctions:FindFirstChild(remoteName)
    if remote then
        remote:InvokeServer(itemName, -quantity)
        task.wait(0.5)
        remote:InvokeServer(itemName, quantity)
        print("[DYHUB] Duped", quantity, itemName)
    end
end

-- ฟังก์ชันสร้างแทบ shop
local function createShopTab(tabTitle, icon, guiName, remoteName)
    local Tab = Window:Tab({ Title = tabTitle, Icon = icon })
    local morphInput, quantity = "", 1

    Tab:Input({
        Title = "Use the name from " .. tabTitle,
        Placeholder = "Item Name",
        Callback = function(text) morphInput = text end,
    })

    Tab:Input({
        Title = "Enter amount to dupe",
        Placeholder = "Quantity (1–10)",
        Callback = function(text)
            local number = tonumber(text)
            if number and number >= 1 and number <= 10 then
                quantity = number
            end
        end,
    })

    Tab:Button({
        Title = "Dupe",
        Icon = "crown",
        Callback = function()
            if morphInput == "" then return end
            doDupe(morphInput, remoteName, quantity)
        end,
    })

    Tab:Button({
        Title = "Open List Item (Toggle)",
        Icon = "list",
        Callback = function()
            toggleGui(guiName)
        end,
    })
end

-- สร้าง Shop Tabs
createShopTab("String Event", "shell", "SpringShop", "SpringShop")
createShopTab("Raid Event", "sword", "RaidShop", "RaidShop")
createShopTab("Dungeon Event", "shield", "DungeonShop", "DungeonShop")
createShopTab("Valentine Event", "heart", "ValentineShop", "ValentineShop")
createShopTab("Team Event", "users", "TeamEventShop", "TeamEventShop")
createShopTab("Halloween Event", "ghost", "HalloweenShop", "HalloweenShop")
createShopTab("Christmas Event", "gift", "ChristmasShop", "ChristmasShop")

-----------------------------------------------------
-- Capsule Tab
local CapsuleTab = Window:Tab({ Title = "Capsule", Icon = "package" })

local capsuleChoice = "Spring Capsule"
local capsuleQuantity = 1

CapsuleTab:Dropdown({
    Title = "Select Capsule",
    Values = { "Spring Capsule", "Halloween Capsule", "Christmas Capsule" },
    Multi = false,
    Callback = function(selected)
        capsuleChoice = selected
    end,
})

CapsuleTab:Input({
    Title = "Enter amount (1–10)",
    Placeholder = "Quantity",
    Callback = function(text)
        local number = tonumber(text)
        if number and number >= 1 and number <= 10 then
            capsuleQuantity = number
        end
    end,
})

CapsuleTab:Button({
    Title = "Spawn Capsule (Dupe)",
    Icon = "crown",
    Callback = function()
        local remoteName
        if capsuleChoice == "Spring Capsule" then
            remoteName = "SpringShop"
        elseif capsuleChoice == "Halloween Capsule" then
            remoteName = "HalloweenShop"
        elseif capsuleChoice == "Christmas Capsule" then
            remoteName = "ChristmasShop"
        else
            return
        end
        doDupe(capsuleChoice, remoteName, capsuleQuantity)
    end,
})
