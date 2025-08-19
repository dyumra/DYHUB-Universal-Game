local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable")
local plr = Players.LocalPlayer

local name = plr.Name
local plot = nil

for _, blot in ipairs(workspace:WaitForChild("Gameplay"):WaitForChild("Plots"):GetChildren()) do
    local label = blot.PlotLogic.PlotNameSign.PlayerInfoSign.PlayerNameSign.MainFrame.NameLabel
    if label.Text:find(name .. "'s") then
        plot = blot
        break
    end
end

if not plot then error("No plot found, disabling") return end

local coinHolder = workspace:WaitForChild("Gameplay"):WaitForChild("CoinHolder")
local customers = workspace:WaitForChild("Gameplay"):WaitForChild("Customers")
local containerHolder = plot:WaitForChild("PlotLogic"):WaitForChild("ContainerHolder")
local itemCache = plot.PlotLogic.ItemCache

local containerMap = {
    ["JunkContainer"] = string.char(13) .. "JunkContainer",
    ["ScratchedContainer"] = string.char(18) .. "ScratchedContainer",
    ["SealedContainer"] = string.char(15) .. "SealedContainer",
    ["MilitaryContainer"] = string.char(17) .. "MilitaryContainer",
    ["MetalContainer"] = string.char(14) .. "MetalContainer",
    ["FrozenContainer"] = string.char(15) .. "FrozenContainer",
    ["LavaContainer"] = string.char(13) .. "LavaContainer",
    ["CorruptedContainer"] = string.char(18) .. "CorruptedContainer",
    ["StormedContainer"] = string.char(16) .. "StormedContainer",
    ["LightningContainer"] = string.char(18) .. "LightningContainer",
    ["InfernalContainer"] = string.char(17) .. "InfernalContainer",
    ["MysticContainer"] = string.char(15) .. "MysticContainer",
    ["GlitchedContainer"] = string.char(17) .. "GlitchedContainer",
    ["AstralContainer"] = string.char(15) .. "AstralContainer",
    ["DreamContainer"] = string.char(14) .. "DreamContainer",
    ["CelestialContainer"] = string.char(18) .. "CelestialContainer",
    ["FireContainer"] = string.char(13) .. "FireContainer",
    ["GoldenContainer"] = string.char(15) .. "GoldenContainer",
    ["DiamondContainer"] = string.char(16) .. "DiamondContainer",
    ["EmeraldContainer"] = string.char(16) .. "EmeraldContainer",
    ["RubyContainer"] = string.char(13) .. "RubyContainer",
    ["SapphireContainer"] = string.char(17) .. "SapphireContainer",
    ["SpaceContainer"] = string.char(14) .. "SpaceContainer",
    ["DeepSpaceContainer"] = string.char(18) .. "DeepSpaceContainer"
}

local containerOptions = {
    "JunkContainer",
    "ScratchedContainer",
    "SealedContainer",
    "MilitaryContainer",
    "MetalContainer",
    "FrozenContainer",
    "LavaContainer",
    "CorruptedContainer",
    "StormedContainer",
    "LightningContainer",
    "InfernalContainer",
    "MysticContainer",
    "GlitchedContainer",
    "AstralContainer",
    "DreamContainer",
    "CelestialContainer",
    "FireContainer",
    "GoldenContainer",
    "DiamondContainer",
    "EmeraldContainer",
    "RubyContainer",
    "SapphireContainer",
    "SpaceContainer",
    "DeepSpaceContainer"
}

local flowerMap = {
    ["BasicFlowerContainer"] = string.char(20) .. "BasicFlowerContainer",
    ["GoodFlowerContainer"] = string.char(19) .. "GoodFlowerContainer"
}

local flowerOptions = {
    "BasicFlowerContainer",
    "GoodFlowerContainer"
}

local Window = Rayfield:CreateWindow({
    Name = "DYHUB | Container RNG",
    Icon = "star",
    LoadingTitle = "DYHUB Loaded! - Container RNG",
    LoadingSubtitle = "Join our dsc.gg/dyhub",
    Theme = "Dark Blue",
})

local Tab = Window:CreateTab("Main")

Tab:CreateSection("Main")

Tab:CreateToggle({
    Name = "Coin Collector",
    CurrentValue = false,
    Callback = function(Value)
        if not coinHolder then
            error("watafak no coin folder")
            return
        end
        _G.coin = Value
        while _G.coin do
            for _, coin in ipairs(coinHolder:GetChildren()) do
                remote:FireServer(buffer.fromstring("\6"), buffer.fromstring("\254\1\0\6".."0" .. coin.Name))
            end
            task.wait(0.01)
        end
    end,
})

local delete

Tab:CreateToggle({
    Name = "Item Collector",
    CurrentValue = false,
    Callback = function(Value)
        if not itemCache then
            error("watafak no item folder")
            return
        end

        _G.item = Value

        local housePart = plot:WaitForChild("PlotDecor"):WaitForChild("House"):WaitForChild("Part")

        while _G.item do
            for _, item in ipairs(itemCache:GetChildren()) do
                if item:IsA("Model") and item.PrimaryPart then
                    local itemPos = item.PrimaryPart.Position
                    local housePos = housePart.Position
                    local houseSize = housePart.Size

                    local inBounds =
                        math.abs(itemPos.X - housePos.X) <= houseSize.X / 2 and
                        math.abs(itemPos.Z - housePos.Z) <= houseSize.Z / 2 and
                        itemPos.Y >= housePos.Y

                    if not inBounds then
                        remote:FireServer(buffer.fromstring("\v"), buffer.fromstring("\254\1\0\6)" .. item.Name))
                    else 
                        if delete then 
                            item:Destroy()
                        end
                    end
                end
            end
            task.wait()
        end
    end,
})

Tab:CreateToggle({
    Name = "Delete Plot Items",
    CurrentValue = false,
    Callback = function(Value)
        print("It will get deleted when u enable item collector btw")
        delete = Value
    end,
})

Tab:CreateToggle({
    Name = "Auto Drop Items",
    CurrentValue = false,
    Callback = function(Value)
        _G.drop = Value

        if Value then
            local housePart = plot:WaitForChild("PlotDecor"):WaitForChild("House"):WaitForChild("Part")

            plr.Character.HumanoidRootPart.CFrame = housePart.CFrame + Vector3.new(0, 7, 0)

            while _G.drop do
                remote:FireServer(buffer.fromstring("\t"), buffer.fromstring("\254\0\0"))

                task.wait(0.1)
            end
        end
    end,
})

local speed
local speedV

Tab:CreateToggle({
    Name = "Customer Speed",
    CurrentValue = false,
    Callback = function(Value)
        speed = Value

        if speed and customers then
            for _, customer in ipairs(customers:GetChildren()) do
                customer:WaitForChild("Humanoid").WalkSpeed = Value
            end
        end
    end,
})

Tab:CreateSlider({
    Name = "Speed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        speedV = Value

        if speed and customers then
            for _, customer in ipairs(customers:GetChildren()) do
                customer:WaitForChild("Humanoid").WalkSpeed = Value
            end
        end
    end,
})

customers.ChildAdded:Connect(function(customer)
    if not speed or not speedV then return end
    customer:WaitForChild("Humanoid").WalkSpeed = speedV
end)

Tab:CreateButton({
    Name = "Toggle Notifications",
    Callback = function()
        local pask = plr.PlayerGui
        for _, thing in ipairs(pask:GetChildren()) do
            if thing:FindFirstChild("NotificationFrame") then
                local frame = thing:FindFirstChild("NotificationFrame")
                frame.Visible = not frame.Visible
            end
        end
    end,
})

local Container = Window:CreateTab("Container")

Container:CreateSection("Container")

Container:CreateToggle({
    Name = "Container Open",
    CurrentValue = false,
    Callback = function(Value)
        if not containerHolder then
            error("watafak no container folder")
            return
        end
        _G.container = Value
        while _G.container do
            for _, container in ipairs(containerHolder:GetChildren()) do
                remote:FireServer(buffer.fromstring("\28"), buffer.fromstring("\254\1\0\6." .. container.Name))
            end
            task.wait()
        end
    end,
})

local selectedContainer = "JunkContainer"

Container:CreateDropdown({
    Name = "Container",
    Options = containerOptions,
    CurrentOption = "JunkContainer",
    MultipleOptions = false,
    Callback = function(Option)
        selectedContainer = typeof(Option) == "table" and Option[1] or Option
    end,
})

local buyDelay
local maxContainers
local minMoney

Container:CreateToggle({
    Name = "Auto Buy Container",
    CurrentValue = false,
    Callback = function(Value)
        _G.buy = Value
        while _G.buy do
            local e = containerMap[selectedContainer]
            if not e then
                warn("Invalid container:", selectedContainer)
                break
            end

            local max = maxContainers or 8
            local containers = #containerHolder:GetChildren()

            local money = tonumber(plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Money") and plr.leaderstats.Money.Value) or 0

            if containers < max and (not minMoney or money >= minMoney) then
                remote:FireServer(buffer.fromstring("\26"), buffer.fromstring("\254\1\0\6" .. e))
            end
            
            task.wait(buyDelay or 0)
        end
    end,
})

Container:CreateSlider({
    Name = "Max Containers",
    Range = {1, 8},
    Increment = 1,
    CurrentValue = 8,
    Callback = function(Value)
        maxContainers = Value
    end,
})

Container:CreateInput({
   Name = "Min Money",
   CurrentValue = "0",
   PlaceholderText = "$",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
        local value = tonumber(Text)
        if value then
            minMoney = value
        else
            warn("Invalid money input")
        end
   end,
})

Container:CreateSlider({
    Name = "Buy Delay",
    Range = {0, 60},
    Increment = 0.1,
    CurrentValue = 0,
    Callback = function(Value)
        buyDelay = Value
    end,
})

local selectedFlower = "BasicFlowerContainer"

Container:CreateDropdown({
    Name = "Flower Container",
    Options = flowerOptions,
    CurrentOption = "BasicFlowerContainer",
    MultipleOptions = false,
    Callback = function(Option)
        selectedFlower = typeof(Option) == "table" and Option[1] or Option
    end,
})

local buyDelayFlower

Container:CreateToggle({
    Name = "Auto Buy Flower Container",
    CurrentValue = false,
    Callback = function(Value)
        _G.buyflower = Value
        while _G.buyflower do
            local e = flowerMap[selectedFlower]
            if not e then
                warn("Invalid container:", selectedFlower)
                break
            end

            remote:FireServer(buffer.fromstring("\26"), buffer.fromstring("\254\1\0\6" .. e))

            task.wait(buyDelayFlower or 0)
        end
    end,
})

Container:CreateSlider({
    Name = "Buy Delay",
    Range = {0, 60},
    Increment = 0.1,
    CurrentValue = 0,
    Callback = function(Value)
        buyDelayFlower = Value
    end,
})

local Upgrades = Window:CreateTab("Upgrades")

Upgrades:CreateSection("Upgrades")

Upgrades:CreateToggle({
    Name = "Upgrade Inventory Size",
    CurrentValue = false,
    Callback = function(Value)
        _G.upgradeinv = Value
        while _G.upgradeinv do
            remote:FireServer(buffer.fromstring("5"), buffer.fromstring("\254\1\0\6\17MaxInventoryItems"))

            task.wait(0.5)
        end
    end,
})

Upgrades:CreateToggle({
    Name = "Upgrade Max Flowers Placed",
    CurrentValue = false,
    Callback = function(Value)
        _G.upgradeflowers = Value
        while _G.upgradeflowers do
            remote:FireServer(buffer.fromstring("5"), buffer.fromstring("\254\1\0\6\16MaxFlowersPlaced"))

            task.wait(0.5)
        end
    end,
})

Upgrades:CreateToggle({
    Name = "Upgrade Max Customers",
    CurrentValue = false,
    Callback = function(Value)
        _G.upgradecustomers = Value
        while _G.upgradecustomers do
            remote:FireServer(buffer.fromstring("5"), buffer.fromstring("\254\1\0\6\fMaxCustomers"))

            task.wait(0.5)
        end
    end,
})

Upgrades:CreateToggle({
    Name = "Upgrade Max Containers",
    CurrentValue = false,
    Callback = function(Value)
        _G.upgradecontainers = Value
        while _G.upgradecontainers do
            remote:FireServer(buffer.fromstring("5"), buffer.fromstring("\254\1\0\6\rMaxContainers"))

            task.wait(0.5)
        end
    end,
})

Upgrades:CreateToggle({
    Name = "Upgrade Max Plot Items",
    CurrentValue = false,
    Callback = function(Value)
        _G.upgradepitems = Value
        while _G.upgradepitems do
            remote:FireServer(buffer.fromstring("5"), buffer.fromstring("\254\1\0\6\14MaxItemsOnPlot"))

            task.wait(0.5)
        end
    end,
})

local Event = Window:CreateTab("Event")

Event:CreateSection("Event")

Event:CreateButton({
    Name = "Buy Lavender [10M]",
    Callback = function()
        remote:FireServer(buffer.fromstring("\22"), buffer.fromstring("\254\1\0\6\bLavender"))
    end,
})

Event:CreateButton({
    Name = "Buy Lilly Pad [1B]",
    Callback = function()
        remote:FireServer(buffer.fromstring("\22"), buffer.fromstring("\254\1\0\6\bLillyPad"))
    end,
})

Event:CreateButton({
    Name = "Buy Cactus [250B]",
    Callback = function()
        remote:FireServer(buffer.fromstring("\22"), buffer.fromstring("\254\1\0\6\6Cactus"))
    end,
})

Event:CreateButton({
    Name = "Buy Palm Tree [1T]",
    Callback = function()
        remote:FireServer(buffer.fromstring("\22"), buffer.fromstring("\254\1\0\6\bPalmTree"))
    end,
})

local Misc = Window:CreateTab("Misc")

Misc:CreateSection("Misc")

Misc:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
        local e = workspace:FindFirstChild("MapDesign")
        if e then e:Destroy() end
    end,
})

Misc:CreateButton({
    Name = "Allow Reset",
    Callback = function()
        plr.PlayerScripts:FindFirstChild("ResetOff").Enabled = false
        game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
    end,
})

Misc:CreateButton({
    Name = "Free Container",
    Callback = function()
        remote:FireServer(buffer.fromstring("<"), buffer.fromstring("\254\0\0"))
    end,
})

Misc:CreateSlider({
    Name = "Walkspeed",
    Range = {24, 500},
    Increment = 1,
    CurrentValue = 24,
    Callback = function(Value)
        plr.Character.Humanoid.WalkSpeed = Value
    end,
})

Misc:CreateSlider({
    Name = "Jumppower",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        plr.Character.Humanoid.JumpPower = Value
        plr.Character.Humanoid.UseJumpPower = true
    end,
})

Misc:CreateSlider({
    Name = "Hip height",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(Value)
        plr.Character.Humanoid.HipHeight = Value
    end,
})

Misc:CreateToggle({
    Name = "Auto Rotate",
    CurrentValue = true,
    Callback = function(Value)
        plr.Character.Humanoid.AutoRotate = Value
    end,
})
