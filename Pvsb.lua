-- ======================
local version = "2.4.7"
-- ======================

repeat task.wait() until game:IsLoaded()

if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== SETTINGS ======================
local SellPlant = false
local SellBrainrot = false
local AutoBuyGear = false
local AutoBuySeed = false
local AutoBuyAllGear = false
local AutoBuyAllSeed = false
local selectedGears = {}
local selectedSeeds = {}

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Plant vs Brainrot | Premium Version",
    Folder = "DYHUB_PVSB_ESP",
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
    Window:Tag({
        Title = version,
        Color = Color3.fromHex("#30ff6a")
    })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local Sell = Window:Tab({ Title = "Sell", Icon = "dollar-sign" })
Window:SelectTab(1)

-- ====================== SELL ======================
Sell:Section({ Title = "Auto Sell", Icon = "dollar-sign" })

Sell:Toggle({
    Title = "Sell Brainrot All",
    Default = false,
    Callback = function(state)
        SellBrainrot = state
    end
})

Sell:Toggle({
    Title = "Sell Plants All",
    Default = false,
    Callback = function(state)
        SellPlant = state
    end
})

-- ====================== SHOP ======================
local gearList = {
    "Water Bucket",
    "Frost Grenade",
    "Banana Gun",
    "Frost Blower",
    "Carrot Launcher"
}

local seedList = {
    "Cactus Seed",
    "Strawberry Seed",
    "Pumpkin Seed",
    "Sunflower Seed",
    "Dragon Seed",
    "Eggplant Seed",
    "Watermelon Seed",
    "Cocotank Seed",
    "Carnivorous Plant Seed",
    "Mr Carrot Seed",
    "Tomatrio Seed"
}

Shop:Section({ Title = "Buy Gear", Icon = "package" })

Shop:Dropdown({
    Title = "Select Gear",
    Values = gearList,
    Multi = true,
    Callback = function(values)
        selectedGears = values
    end
})

Shop:Toggle({
    Title = "Auto Buy Gear (Selected)",
    Default = false,
    Callback = function(state)
        AutoBuyGear = state
    end
})

Shop:Toggle({
    Title = "Auto Buy All Gear",
    Default = false,
    Callback = function(state)
        AutoBuyAllGear = state
    end
})

Shop:Section({ Title = "Buy Seed", Icon = "leaf" })

Shop:Dropdown({
    Title = "Select Seed",
    Values = seedList,
    Multi = true,
    Callback = function(values)
        selectedSeeds = values
    end
})

Shop:Toggle({
    Title = "Auto Buy Seed (Selected)",
    Default = false,
    Callback = function(state)
        AutoBuySeed = state
    end
})

Shop:Toggle({
    Title = "Auto Buy All Seed",
    Default = false,
    Callback = function(state)
        AutoBuyAllSeed = state
    end
})

-- ====================== LOOPS ======================
task.spawn(function()
    while task.wait(5) do
        if SellBrainrot then
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ItemSell"):FireServer("Brainrot")
        end
        if SellPlant then
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ItemSell"):FireServer("Plants")
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if AutoBuyGear and #selectedGears > 0 then
            for _, gear in ipairs(selectedGears) do
                local args = { { gear, " " } }
                ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            end
        end
        if AutoBuySeed and #selectedSeeds > 0 then
            for _, seed in ipairs(selectedSeeds) do
                local args = { { seed, "\a" } }
                ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            end
        end
        if AutoBuyAllGear then
            for _, gear in ipairs(gearList) do
                local args = { { gear, " " } }
                ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            end
        end
        if AutoBuyAllSeed then
            for _, seed in ipairs(seedList) do
                local args = { { seed, "\a" } }
                ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            end
        end
    end
end)
