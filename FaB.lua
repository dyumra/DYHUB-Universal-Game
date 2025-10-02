-- =========================
local version = "2.8.4"
-- =========================

repeat task.wait() until game:IsLoaded()

-- ====================== SETTINGS ======================
local settings = {
    autoFish = false,
    autoReel = false,
    autoCollect = false,
    autoBuyBait = false,
    autoBuySupplies = false,
    antiAFK = false 
}

local codelist = {
    "Release",
    "Tutorial"
}

-- ====================== FPS Unlock ======================
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
end

-- ====================== WINDUI ======================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Fish a Brainrot | Premium Version",
    Folder = "DYHUB_FaB",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- ====================== TABS ======================
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local BrainrotTab = Window:Tab({ Title = "Brainrot", Icon = "fish" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })
Window:SelectTab(1)

-- ====================== AUTO FARM ======================
Main:Section({ Title = "Fishing", Icon = "fish" })

Main:Toggle({
    Title = "Auto Reel",
    Default = settings.autoReel,
    Callback = function(state)
        settings.autoReel = state
        if state then
            task.spawn(function()
                local FishingRF = ReplicatedStorage
                    :WaitForChild("Packages")
                    :WaitForChild("_Index")
                    :WaitForChild("sleitnick_knit@1.7.0")
                    :WaitForChild("knit")
                    :WaitForChild("Services")
                    :WaitForChild("FishingService")
                    :WaitForChild("RF")
                
                local targetY = 0.76
                local epsilon = 0.1

                while settings.autoReel do
                    pcall(function()
                        local gui = LocalPlayer.PlayerGui:FindFirstChild("Fishing")
                        if gui then
                            local container = gui:FindFirstChild("Container")
                            if container then
                                local yPos = container.Position.Y.Scale
                                if yPos <= targetY + epsilon then
                                     task.wait(1.25)
                                    FishingRF:WaitForChild("ClaimCatch"):InvokeServer()
                           
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

Main:Section({ Title = "Money Collect", Icon = "coins" })

Main:Toggle({
    Title = "Auto Collect",
    Default = settings.autoCollect,
    Callback = function(state)
        settings.autoCollect = state
        if state then
            task.spawn(function()
                while settings.autoCollect do
                    pcall(function()
                        for i = 1, 11 do
                            local args = { "PlaceableArea_" .. i }
                            ReplicatedStorage
                                :WaitForChild("Packages")
                                :WaitForChild("_Index")
                                :WaitForChild("sleitnick_knit@1.7.0")
                                :WaitForChild("knit")
                                :WaitForChild("Services")
                                :WaitForChild("MoneyCollectionService")
                                :WaitForChild("RF")
                                :WaitForChild("CollectMoney")
                                :InvokeServer(unpack(args))
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ====================== SHOP ======================
local function createShopSection(title, icon, items, multi, serviceName, toggleSetting)
    local selectedItems = {}
    Shop:Section({ Title = title, Icon = icon })

    Shop:Dropdown({
        Title = "Select " .. title,
        Values = items,
        Multi = multi,
        Callback = function(values)
            selectedItems = values
        end
    })

    Shop:Toggle({
        Title = "Auto Buy Selected " .. title,
        Default = settings[toggleSetting],
        Callback = function(state)
            settings[toggleSetting] = state
            if state then
                task.spawn(function()
                    while settings[toggleSetting] do
                        pcall(function()
                            for _, item in ipairs(selectedItems) do
                                local args = { item }
                                ReplicatedStorage
                                    :WaitForChild("Packages")
                                    :WaitForChild("_Index")
                                    :WaitForChild("sleitnick_knit@1.7.0")
                                    :WaitForChild("knit")
                                    :WaitForChild("Services")
                                    :WaitForChild(serviceName)
                                    :WaitForChild("RF")
                                    :WaitForChild("PurchaseItem")
                                    :InvokeServer(unpack(args))
                            end
                        end)
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
end

-- Rod Shop
local Rods = {"WeakRod","WoodenRod","ReinforcedRod","CoralRod","LightningRod","FrozenRod","AstralRod","MagmaRod","CupidRod","DivineRod"}
Shop:Section({ Title = "Rod Shop", Icon = "fish" })
local selectedRod = nil
Shop:Dropdown({
    Title = "Select Rod",
    Values = Rods,
    Multi = false,
    Callback = function(value)
        selectedRod = value
    end
})
Shop:Button({
    Title = "Purchase Selected Rod",
    Callback = function()
        if not selectedRod or selectedRod == "" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "DYHUB",
                Text = "Please select a Rod before purchasing",
                Duration = 2
            })
            return
        end
        pcall(function()
            local args = { selectedRod }
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("RodService")
                :WaitForChild("RF")
                :WaitForChild("PurchaseRod")
                :InvokeServer(unpack(args))
        end)
    end
})

-- Bait Shop
createShopSection("Bait Shop", "fish", {
    "Worm","Shrimp","Eel","Kiwi","Banana","CoffeeBeans","Crab","Squid","Grape","Orange","Tophat","Watermelon","Dragonfruit","GoldenBanana"
}, true, "BaitService", "autoBuyBait")

-- Supplies Shop
createShopSection("Supplies Shop", "package", {
    "RustyWeightCharm","RustyMutationCharm","WeightCharm","MutationCharm","MutationStabilizer","EvolutionCrystal","OverfeedCharm","KeeperSeal"
}, true, "SuppliesService", "autoBuySupplies")

-- Boat Shop
local Boats = {"Rowboat","Motorboat","Speeder","Pontoon","Yacht"}
local selectedBoat = nil
Shop:Section({ Title = "Boat Shop", Icon = "ship" })
Shop:Dropdown({
    Title = "Select Boat",
    Values = Boats,
    Multi = false,
    Callback = function(value)
        selectedBoat = value
    end
})
Shop:Button({
    Title = "Purchase Selected Boat",
    Callback = function()
        if not selectedBoat or selectedBoat == "" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "DYHUB",
                Text = "Please select a Boat before purchasing",
                Duration = 2
            })
            return
        end
        pcall(function()
            local args = { selectedBoat }
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("BoatService")
                :WaitForChild("RF")
                :WaitForChild("PurchaseBoat")
                :InvokeServer(unpack(args))
        end)
    end
})

-- ====================== BRAINROT ======================
BrainrotTab:Section({ Title = "Sell Brainrot", Icon = "fish" })
BrainrotTab:Button({
    Title = "Sell Held Brainrots",
    Callback = function()
        pcall(function()
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("FishingService")
                :WaitForChild("RF")
                :WaitForChild("SellHeldItem")
                :InvokeServer()
        end)
    end
})
BrainrotTab:Button({
    Title = "Sell All Brainrots",
    Callback = function()
        pcall(function()
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("FishingService")
                :WaitForChild("RF")
                :WaitForChild("SellInventory")
                :InvokeServer()
        end)
    end
})

-- ====================== MISC TAB ======================
MiscTab:Section({ Title = "Code", Icon = "gift" })

MiscTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        task.spawn(function()
            pcall(function()
                for _, code in ipairs(codelist) do
                    local args = { code }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Packages")
                        :WaitForChild("_Index")
                        :WaitForChild("sleitnick_knit@1.7.0")
                        :WaitForChild("knit")
                        :WaitForChild("Services")
                        :WaitForChild("CodesService")
                        :WaitForChild("RF")
                        :WaitForChild("RedeemCode")
                        :InvokeServer(unpack(args))
                end
            end)
        end)
    end
})

MiscTab:Section({ Title = "Miscellaneous", Icon = "cog" })

MiscTab:Toggle({
    Title = "Anti AFK",
    Default = settings.antiAFK,
    Callback = function(state)
        settings.antiAFK = state
        if state then
            local player = game:GetService("Players").LocalPlayer
            local VirtualUser = game:GetService("VirtualUser")

            task.spawn(function()
                while settings.antiAFK do
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                    task.wait(120)
                end
            end)
        end
    end
})
