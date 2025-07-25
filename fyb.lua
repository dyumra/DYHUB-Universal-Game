-- Wait for game to fully load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Load libraries with error handling
local Fluent, SaveManager, InterfaceManager

local success1, result1 = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)
if success1 then
    Fluent = result1
end

local success2, result2 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
end)
if success2 then
    SaveManager = result2
end

local success3, result3 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)
if success3 then
    InterfaceManager = result3
end

-- Notification System
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlassmorphismNotifications"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

-- Notification container
local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotificationContainer"
notifContainer.Size = UDim2.new(0, 400, 1, 0)
notifContainer.Position = UDim2.new(1, -420, 0, 20)
notifContainer.BackgroundTransparency = 1
notifContainer.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Parent = notifContainer
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 12)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Notification counter for positioning
local notificationCount = 0
local activeNotifications = {}

-- Function to create glassmorphism effect
local function createGlassmorphismFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    -- Red outline stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 68, 68)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = frame
    
    -- Glassmorphism blur effect (simulated with gradient)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    gradient.Rotation = 45
    gradient.Parent = frame
    
    return frame
end

-- Function to create notification content
local function createNotificationContent(frame, title, content)
    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 20, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    -- Content label
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, -60, 0, 35)
    contentLabel.Position = UDim2.new(0, 20, 0, 35)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.TextSize = 13
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.Parent = frame
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 68, 68)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = frame
    
    -- Close button hover effect
    closeButton.MouseEnter:Connect(function()
        local tween = TweenService:Create(closeButton, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
            {TextColor3 = Color3.fromRGB(255, 100, 100)}
        )
        tween:Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        local tween = TweenService:Create(closeButton, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
            {TextColor3 = Color3.fromRGB(255, 68, 68)}
        )
        tween:Play()
    end)
    
    return closeButton
end

-- Function to animate notification appearance
local function animateNotificationIn(frame)
    local titleLabel = frame:FindFirstChild("Title")
    local contentLabel = frame:FindFirstChild("Content")
    local closeButton = frame:FindFirstChild("CloseButton")
    
    -- Initial state
    frame.Position = UDim2.new(1, 100, 0, 0)
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundTransparency = 1
    
    local stroke = frame:FindFirstChild("UIStroke")
    if stroke then
        stroke.Transparency = 1
    end
    
    -- Hide text elements initially
    if titleLabel then titleLabel.TextTransparency = 1 end
    if contentLabel then contentLabel.TextTransparency = 1 end
    if closeButton then closeButton.TextTransparency = 1 end
    
    -- Phase 1: Expand height smoothly
    local expandTween = TweenService:Create(frame,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 0, 80)}
    )
    
    -- Phase 2: Slide in with smooth easing
    local slideInTween = TweenService:Create(frame,
        TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)}
    )
    
    -- Phase 3: Fade in background
    local fadeTween = TweenService:Create(frame,
        TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.2}
    )
    
    -- Phase 4: Fade in stroke
    if stroke then
        local strokeTween = TweenService:Create(stroke,
            TweenInfo.new(0.5, Enum.EasingStyle.Sine),
            {Transparency = 0.3}
        )
        spawn(function()
            wait(0.2)
            strokeTween:Play()
        end)
    end
    
    -- Start animations
    expandTween:Play()
    spawn(function()
        wait(0.1)
        slideInTween:Play()
        fadeTween:Play()
    end)
    
    -- Phase 5: Fade in text elements with stagger
    spawn(function()
        wait(0.4)
        if titleLabel then
            local titleTween = TweenService:Create(titleLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Sine),
                {TextTransparency = 0}
            )
            titleTween:Play()
        end
        
        wait(0.1)
        if contentLabel then
            local contentTween = TweenService:Create(contentLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Sine),
                {TextTransparency = 0}
            )
            contentTween:Play()
        end
        
        wait(0.1)
        if closeButton then
            local buttonTween = TweenService:Create(closeButton,
                TweenInfo.new(0.5, Enum.EasingStyle.Sine),
                {TextTransparency = 0}
            )
            buttonTween:Play()
        end
    end)
    
    -- Subtle glow effect on the stroke
    if stroke then
        spawn(function()
            wait(0.8)
            local glowTween = TweenService:Create(stroke,
                TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = 0.1}
            )
            glowTween:Play()
            
            wait(3)
            glowTween:Cancel()
        end)
    end
end

-- Function to animate notification disappearance
local function animateNotificationOut(frame, callback)
    local stroke = frame:FindFirstChild("UIStroke")
    local titleLabel = frame:FindFirstChild("Title")
    local contentLabel = frame:FindFirstChild("Content")
    local closeButton = frame:FindFirstChild("CloseButton")
    
    -- Phase 1: Fade out text elements quickly
    if titleLabel then
        local titleTween = TweenService:Create(titleLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine),
            {TextTransparency = 1}
        )
        titleTween:Play()
    end
    
    if contentLabel then
        local contentTween = TweenService:Create(contentLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine),
            {TextTransparency = 1}
        )
        contentTween:Play()
    end
    
    if closeButton then
        local buttonTween = TweenService:Create(closeButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine),
            {TextTransparency = 1}
        )
        buttonTween:Play()
    end
    
    -- Phase 2: Fade out stroke
    if stroke then
        local strokeTween = TweenService:Create(stroke,
            TweenInfo.new(0.4, Enum.EasingStyle.Sine),
            {Transparency = 1}
        )
        spawn(function()
            wait(0.2)
            strokeTween:Play()
        end)
    end
    
    -- Phase 3: Slide out with smooth easing
    local slideOutTween = TweenService:Create(frame,
        TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {
            Position = UDim2.new(1, 100, frame.Position.Y.Scale, frame.Position.Y.Offset),
            BackgroundTransparency = 1
        }
    )
    
    -- Phase 4: Shrink height smoothly
    local shrinkTween = TweenService:Create(frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(1, 0, 0, 0)}
    )
    
    -- Start exit animation
    spawn(function()
        wait(0.3)
        slideOutTween:Play()
        
        slideOutTween.Completed:Connect(function()
            shrinkTween:Play()
            shrinkTween.Completed:Connect(function()
                if callback then callback() end
                frame:Destroy()
            end)
        end)
    end)
end

-- Main notification function
local function createNotif(title, content, duration)
    duration = duration or 5
    notificationCount = notificationCount + 1
    
    -- Create notification frame
    local notifFrame = createGlassmorphismFrame()
    notifFrame.Name = "Notification_" .. notificationCount
    notifFrame.LayoutOrder = notificationCount
    notifFrame.Parent = notifContainer
    
    -- Add content
    local closeButton = createNotificationContent(notifFrame, title, content)
    
    -- Add to active notifications
    table.insert(activeNotifications, notifFrame)
    
    -- Animate in
    animateNotificationIn(notifFrame)
    
    -- Auto-remove after duration
    local function removeNotification()
        for i, notif in ipairs(activeNotifications) do
            if notif == notifFrame then
                table.remove(activeNotifications, i)
                break
            end
        end
        
        animateNotificationOut(notifFrame)
    end
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(removeNotification)
    
    -- Auto-remove timer using spawn and wait
    spawn(function()
        wait(duration)
        if notifFrame and notifFrame.Parent then
            removeNotification()
        end
    end)
    
    return notifFrame
end

-- Test notification (fixed - was outside a function)
createNotif("Notification", "Welcome to DYHUB Join our Discord Community for Update! ", 5)

-- Check if essential components loaded
if not Fluent then
    warn("Failed to load Fluent library")
    return
end

-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load notification
createNotif("DYHUB", "Script Loaded Successfully", 3)

-- Create Fluent window
local Window = Fluent:CreateWindow({
    Title = "DYHUB - Feed Your Brainrot (dsc.gg/dyhub)",
    SubTitle = "Powered by DYHUB TEAM",
    TabWidth = 100,
    Size = UDim2.fromOffset(540, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Auto = Window:AddTab({ Title = "Main", Icon = "rocket" }),
    AutoBuy = Window:AddTab({ Title = "Auto Buy", Icon = "shopping-cart" }),
    AutoUpgrade = Window:AddTab({ Title = "Auto Upgrade", Icon = "arrow-up" }),
    Info = Window:AddTab({ Title = "Misc", Icon = "file-cog" }),
    Settings = Window:AddTab({ Title = "Config", Icon = "cog" })
}

-- Variables
local buySelectedEnabled = false
local autoBuyAllEnabled = false
local selectedPotions = {}
local autoBuyConnection = nil
local buyAllConnection = nil

local buySelectedRelicsEnabled = false
local autoBuyAllRelicsEnabled = false
local selectedRelics = {}
local autoBuyRelicsConnection = nil
local buyAllRelicsConnection = nil

-- Upgrade variables
local autoUpgradeBaseFarmEnabled = false
local autoUpgradeBaseSpecialEnabled = false
local autoUpgradeLassoEnabled = false
local baseFarmUpgradeConnection = nil
local baseSpecialUpgradeConnection = nil
local lassoUpgradeConnection = nil

-- Auto Tab Features
local AutoClickLassoEnabled = false
local AutoPumpFruitEnabled = false
local AutoPickUpPumpedFruitEnabled = false
local AutoSellEnabled = false
local AutoPickUpPlantFruitEnabled = false
local AutoCollectEnabled = false

-- Farm configurations (updated to support tier 1-20)
local farmTiers = {}
for i = 1, 20 do
    table.insert(farmTiers, "Farm" .. i)
end

local specialUpgradeTypes = {"Multiplier", "Cooldown", "MutationChance", "MutationRate"}
local maxUpgradeLevels = {
    Multiplier = 20,
    Cooldown = 20,
    MutationChance = 20,
    MutationRate = 20
}

-- Speed variables
local AutoClickLassoSpeed = 0.1
local AutoPumpFruitSpeed = 0.05
local AutoPickUpPumpedFruitSpeed = 1
local AutoPickUpPlantFruitSpeed = 1
local AutoCollectSpeed = 1

-- Lasso configuration (updated to support level 1-50)
local maxLassoLevel = 50

-- Options
local potionOptions = {
    "Wet",
    "Lightning", 
    "Bloodrot",
    "Glitch",
    "Rainbow"
}

local relicOptions = {
    "ChampionStatue",
    "PeacePond",
    "SakuraBlossom",
    "HoneyHaven",
    "LegendStatue",
    "AncientPrism",
    "EternalEmber",
    "ChainedGalaxy"
}

-- HOME TAB
Tabs.Info:AddParagraph({
    Title = "Join Our DYHUB",
    Content = "DYHUB • Discord: (dsc.gg/dyhub)"
})

Tabs.Info:AddButton({
    Title = "Copy Link Discord",
    Callback = function() 
        pcall(function()
            setclipboard("dsc.gg/dyhub")
            if createNotif then
                createNotif("Copied!", "Discord link copied to clipboard", 3)
            end
        end)
    end
})

-- AUTOBUY TAB - Fixed tab references
local PotionDropdown = Tabs.AutoBuy:AddDropdown("PotionDropdown", {
    Title = "Select Potions",
    Values = potionOptions,
    Multi = true,
    Default = {},
    Callback = function(Value)
        selectedPotions = Value or {}
        if createNotif then
            if #selectedPotions > 0 then
                createNotif("DYHUB", "Potions Selected!", 3)
            else
                createNotif("DYHUB", "No potions selected!", 2)
            end
        end
    end
})

local BuySelectedToggle = Tabs.AutoBuy:AddToggle("BuySelectedPotion", {
    Title = "Buy Selected Potions",
    Default = false,
    Callback = function(Value)
        buySelectedEnabled = Value
        
        if buySelectedEnabled then
            if #selectedPotions == 0 then
                if createNotif then
                    createNotif("Error", "Please select at least one potion first!", 3)
                end
                BuySelectedToggle:SetValue(false)
                return
            end
            
            if createNotif then
                createNotif("DYHUB", "Buy Selected Potions On!", 3)
            end
            
            autoBuyConnection = RunService.Heartbeat:Connect(function()
                if buySelectedEnabled and #selectedPotions > 0 then
                    for _, potionName in ipairs(selectedPotions) do
                        pcall(function()
                            local args = { potionName }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PurchasePotion"):FireServer(unpack(args))
                        end)
                        task.wait(0.1)
                    end
                    task.wait(1)
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "Buy Selected Potions Off", 3)
            end
            
            if autoBuyConnection then
                autoBuyConnection:Disconnect()
                autoBuyConnection = nil
            end
        end
    end
})

local AutoBuyAllToggle = Tabs.AutoBuy:AddToggle("AutoBuyAllPotions", {
    Title = "AutoBuy All Potions",
    Default = false,
    Callback = function(Value)
        autoBuyAllEnabled = Value
        
        if autoBuyAllEnabled then
            if createNotif then
                createNotif("DYHUB", "AutoBuy All Potions Started!", 3)
            end
            
            buyAllConnection = RunService.Heartbeat:Connect(function()
                if autoBuyAllEnabled then
                    for _, potionName in ipairs(potionOptions) do
                        pcall(function()
                            local args = { potionName }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PurchasePotion"):FireServer(unpack(args))
                        end)
                        task.wait(0.1)
                    end
                    task.wait(1)
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "AutoBuy All Potions Off", 3)
            end
            
            if buyAllConnection then
                buyAllConnection:Disconnect()
                buyAllConnection = nil
            end
        end
    end
})

local RelicDropdown = Tabs.AutoBuy:AddDropdown("RelicDropdown", {
    Title = "Select Relics",
    Values = relicOptions,
    Multi = true,
    Default = {},
    Callback = function(Value)
        selectedRelics = Value or {}
        if createNotif then
            if #selectedRelics > 0 then
                createNotif("DYHUB", "Relics Selected!", 3)
            else
                createNotif("DYHUB", "No relics selected", 2)
            end
        end
    end
})

local BuySelectedRelicsToggle = Tabs.AutoBuy:AddToggle("BuySelectedRelics", {
    Title = "Buy Selected Relics",
    Default = false,
    Callback = function(Value)
        buySelectedRelicsEnabled = Value
        
        if buySelectedRelicsEnabled then
            if #selectedRelics == 0 then
                if createNotif then
                    createNotif("Error", "Please select at least one relic first!", 3)
                end
                BuySelectedRelicsToggle:SetValue(false)
                return
            end
            
            if createNotif then
                createNotif("DYHUB", "Buy Selected Relics On", 3)
            end
            
            autoBuyRelicsConnection = RunService.Heartbeat:Connect(function()
                if buySelectedRelicsEnabled and #selectedRelics > 0 then
                    for _, relicName in ipairs(selectedRelics) do
                        pcall(function()
                            local args = { relicName }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PurchaseRelic"):FireServer(unpack(args))
                        end)
                        task.wait(0.1)
                    end
                    task.wait(1)
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "Buy Selected Relics Off", 3)
            end
            
            if autoBuyRelicsConnection then
                autoBuyRelicsConnection:Disconnect()
                autoBuyRelicsConnection = nil
            end
        end
    end
})

local AutoBuyAllRelicsToggle = Tabs.AutoBuy:AddToggle("AutoBuyAllRelics", {
    Title = "AutoBuy All Relics",
    Default = false,
    Callback = function(Value)
        autoBuyAllRelicsEnabled = Value
        
        if autoBuyAllRelicsEnabled then
            if createNotif then
                createNotif("DYHUB", "AutoBuy All Relics Started!", 3)
            end
            
            buyAllRelicsConnection = RunService.Heartbeat:Connect(function()
                if autoBuyAllRelicsEnabled then
                    for _, relicName in ipairs(relicOptions) do
                        pcall(function()
                            local args = { relicName }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PurchaseRelic"):FireServer(unpack(args))
                        end)
                        task.wait(0.1)
                    end
                    task.wait(1)
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "AutoBuy All Relics Stopped!", 3)
            end
            
            if buyAllRelicsConnection then
                buyAllRelicsConnection:Disconnect()
                buyAllRelicsConnection = nil
            end
        end
    end
})

-- AUTOUPGRADE TAB - Fixed with correct RemoteEvent calls and extended support
local AutoUpgradeBaseFarmToggle = Tabs.AutoUpgrade:AddToggle("AutoUpgradeAllBaseFarm", {
    Title = "AutoUpgrade BaseFarm",
    Description = "All BaseFarm will be upgrade to max when you have enough money",
    Default = false,
    Callback = function(Value)
        autoUpgradeBaseFarmEnabled = Value
        
        if autoUpgradeBaseFarmEnabled then
            if createNotif then
                createNotif("DYHUB", "AutoUpgrade Base Farm On", 3)
            end
            
            baseFarmUpgradeConnection = RunService.Heartbeat:Connect(function()
                if autoUpgradeBaseFarmEnabled then
                    -- Upgrade all farm tiers (1-20)
                    for _, farmTier in ipairs(farmTiers) do
                        pcall(function()
                            local args = { farmTier }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("BaseFarmUpgrade"):FireServer(unpack(args))
                        end)
                        task.wait(0.05) -- Reduced wait time for faster processing
                    end
                    task.wait(1) -- Wait between full cycles
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "AutoUpgrade Base Farm Off", 3)
            end
            
            if baseFarmUpgradeConnection then
                baseFarmUpgradeConnection:Disconnect()
                baseFarmUpgradeConnection = nil
            end
        end
    end
})

local AutoUpgradeBaseSpecialToggle = Tabs.AutoUpgrade:AddToggle("AutoUpgradeBaseSpecialUpgrade", {
    Title = "AutoUpgrade SpecialUpgrade",
    Description = "All BaseSpecial upgrades will be upgraded",
    Default = false,
    Callback = function(Value)
        autoUpgradeBaseSpecialEnabled = Value
        
        if autoUpgradeBaseSpecialEnabled then
            if createNotif then
                createNotif("DYHUB", "AutoUpgrade Base SpecialUpgrade On", 3)
            end
            
            baseSpecialUpgradeConnection = RunService.Heartbeat:Connect(function()
                if autoUpgradeBaseSpecialEnabled then
                    -- Upgrade all farm tiers with all special upgrade types (1-20)
                    for _, farmTier in ipairs(farmTiers) do
                        for _, upgradeType in ipairs(specialUpgradeTypes) do
                            local maxLevel = maxUpgradeLevels[upgradeType] or 20
                            for level = 1, maxLevel do
                                pcall(function()
                                    local args = { farmTier, upgradeType, level }
                                    ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("BaseSpecialUpgrade"):FireServer(unpack(args))
                                end)
                                task.wait(0.02) -- Very small delay for processing
                            end
                        end
                        task.wait(0.1) -- Small delay between farm tiers
                    end
                    task.wait(2) -- Longer wait between full cycles
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "AutoUpgrade Base Special Off", 3)
            end
            
            if baseSpecialUpgradeConnection then
                baseSpecialUpgradeConnection:Disconnect()
                baseSpecialUpgradeConnection = nil
            end
        end
    end
})

local AutoUpgradeLassoToggle = Tabs.AutoUpgrade:AddToggle("AutoUpgradeLasso", {
    Title = "AutoUpgrade Lasso",
    Description = "AutoUpgradeLasso",
    Default = false,
    Callback = function(Value)
        autoUpgradeLassoEnabled = Value
        
        if autoUpgradeLassoEnabled then
            if createNotif then
                createNotif("DYHUB", "AutoUpgrade Lasso On", 3)
            end
            
            lassoUpgradeConnection = RunService.Heartbeat:Connect(function()
                if autoUpgradeLassoEnabled then
                    -- Upgrade lasso from level 1 to 50
                    for level = 1, maxLassoLevel do
                        pcall(function()
                            local args = { level }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("LassoUpgrade"):FireServer(unpack(args))
                        end)
                        task.wait(0.02)
                    end
                    task.wait(1) -- Wait between cycles
                end
            end)
        else
            if createNotif then
                createNotif("DYHUB", "AutoUpgrade Lasso Off", 3)
            end
            
            if lassoUpgradeConnection then
                lassoUpgradeConnection:Disconnect()
                lassoUpgradeConnection = nil
            end
        end
    end
})

-- Individual farm upgrade toggles (improved function)
local function createFarmToggle(farmName)
    return Tabs.AutoUpgrade:AddToggle("AutoUpgrade" .. farmName, {
        Title = "AutoUpgrade " .. farmName,
        Description = "Upgrade " .. farmName .. " all of it",
        Default = false,
        Callback = function(Value)
            if Value then
                if createNotif then
                    createNotif("Viper", farmName .. " Upgrade Started!", 2)
                end
                
                local farmConnection = RunService.Heartbeat:Connect(function()
                    if Value then -- Check if still enabled
                        pcall(function()
                            -- Base farm upgrade
                            local args = { farmName }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("BaseFarmUpgrade"):FireServer(unpack(args))
                            
                            -- Special upgrades
                            for _, upgradeType in ipairs(specialUpgradeTypes) do
                                local maxLevel = maxUpgradeLevels[upgradeType] or 20
                                for level = 1, maxLevel do
                                    local specialArgs = { farmName, upgradeType, level }
                                    ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("BaseSpecialUpgrade"):FireServer(unpack(specialArgs))
                                    task.wait(0.02)
                                end
                            end
                        end)
                        task.wait(1.5)
                    else
                        if farmConnection then
                            farmConnection:Disconnect()
                        end
                    end
                end)
            else
                if createNotif then
                    createNotif("DYHUB", farmName .. " AutoUpgrade Off", 2)
                end
            end
        end
    })
end

-- Create toggles for first 4 farms (commonly used)
for i = 1, 4 do
    createFarmToggle("Farm" .. i)
end

-- AutoClickLasso Toggle
local AutoClickLassoToggle = Tabs.Auto:AddToggle("AutoClickLasso", {
    Title = "AutoClickLasso",
    Description = "Auto click lasso battle",
    Default = false
})

AutoClickLassoToggle:OnChanged(function(Value)
    AutoClickLassoEnabled = Value
    if AutoClickLassoEnabled then
        spawn(function()
            while AutoClickLassoEnabled do
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("LassoBattle"):WaitForChild("Click"):FireServer()
                wait(AutoClickLassoSpeed)
            end
        end)
    end
end)

-- AutoPumpFruit Toggle and Slider
local AutoPumpFruitToggle = Tabs.Auto:AddToggle("AutoPumpFruit", {
    Title = "AutoPumpFruit",
    Description = "Auto pump fruit",
    Default = false
})

local AutoPumpFruitSlider = Tabs.Auto:AddSlider("AutoPumpFruitSpeed", {
    Title = "AutoPumpFruit Speed",
    Description = "Adjust speed for auto pump fruit",
    Default = 0.05,
    Min = 0.05,
    Max = 10,
    Rounding = 2
})

AutoPumpFruitToggle:OnChanged(function(Value)
    AutoPumpFruitEnabled = Value
    if AutoPumpFruitEnabled then
        spawn(function()
            while AutoPumpFruitEnabled do
                local success, error = pcall(function()
                    local player = game.Players.LocalPlayer
                    local playerPlot = workspace.PlayerPlots:FindFirstChild(player.Name .. "_Plot")
                    if playerPlot then
                        local farmButton = playerPlot:FindFirstChild("Farm1Folder")
                        if farmButton and farmButton:FindFirstChild("Button") and farmButton.Button:FindFirstChild("Click") then
                            local prompt = farmButton.Button.Click:FindFirstChild("FarmPumpPrompt")
                            if prompt and prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end)
                if not success then
                    print("AutoPumpFruit Error:", error)
                end
                wait(AutoPumpFruitSpeed)
            end
        end)
    end
end)

AutoPumpFruitSlider:OnChanged(function(Value)
    AutoPumpFruitSpeed = Value
end)

-- AutoPickUpPumpedFruit Toggle and Slider
local AutoPickUpPumpedFruitToggle = Tabs.Auto:AddToggle("AutoPickUpPumpedFruit", {
    Title = "AutoPickUpPumpedFruit",
    Description = "Only pump fruit it would pick up",
    Default = false
})

local AutoPickUpPumpedFruitSlider = Tabs.Auto:AddSlider("AutoPickUpPumpedFruitSpeed", {
    Title = "AutoPickUpPumpedFruit Speed",
    Description = "Adjust speed for auto pickup pumped fruit",
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0
})

AutoPickUpPumpedFruitToggle:OnChanged(function(Value)
    AutoPickUpPumpedFruitEnabled = Value
    if AutoPickUpPumpedFruitEnabled then
        spawn(function()
            while AutoPickUpPumpedFruitEnabled do
                local success, error = pcall(function()
                    local player = game.Players.LocalPlayer
                    local playerPlot = workspace.PlayerPlots:FindFirstChild(player.Name .. "_Plot")
                    if playerPlot then
                        local farm1 = playerPlot:FindFirstChild("Farm1Folder")
                        if farm1 and farm1:FindFirstChild("Farm1") and farm1.Farm1:FindFirstChild("PlantPlot") then
                            local prompt = farm1.Farm1.PlantPlot:FindFirstChild("PickupPrompt")
                            if prompt and prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end)
                if not success then
                    print("AutoPickUpPumpedFruit Error:", error)
                end
                wait(AutoPickUpPumpedFruitSpeed)
            end
        end)
    end
end)

AutoPickUpPumpedFruitSlider:OnChanged(function(Value)
    AutoPickUpPumpedFruitSpeed = Value
end)

-- AutoSell Toggle
local AutoSellToggle = Tabs.Auto:AddToggle("AutoSell", {
    Title = "AutoSell",
    Description = "AutoSellCharacter",
    Default = false
})

AutoSellToggle:OnChanged(function(Value)
    AutoSellEnabled = Value
    if AutoSellEnabled then
        spawn(function()
            while AutoSellEnabled do
                local success, error = pcall(function()
                    local player = game.Players.LocalPlayer
                    local playerPlot = workspace.PlayerPlots:FindFirstChild(player.Name .. "_Plot")
                    if playerPlot then
                        local seller = playerPlot:FindFirstChild("CharacterSeller")
                        if seller and seller:FindFirstChild("Seller") and seller.Seller:FindFirstChild("HumanoidRootPart") then
                            local prompt = seller.Seller.HumanoidRootPart:FindFirstChild("SellPrompt")
                            if prompt and prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end)
                if not success then
                    print("AutoSell Error:", error)
                end
                wait(1) -- Default wait time for selling
            end
        end)
    end
end)

-- AutoPickUpPlantFruit Toggle and Slider
local AutoPickUpPlantFruitToggle = Tabs.Auto:AddToggle("AutoPickUpPlantFruit", {
    Title = "AutoPickUpPlantFruit",
    Description = "Collects all planted fruit",
    Default = false
})

local AutoPickUpPlantFruitSlider = Tabs.Auto:AddSlider("AutoPickUpPlantFruitSpeed", {
    Title = "AutoPickUpPlantFruit Speed",
    Description = "Adjust speed for collecting fruit",
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0
})

AutoPickUpPlantFruitToggle:OnChanged(function(Value)
    AutoPickUpPlantFruitEnabled = Value
    if AutoPickUpPlantFruitEnabled then
        spawn(function()
            while AutoPickUpPlantFruitEnabled do
                local success, error = pcall(function()
                    local player = game.Players.LocalPlayer
                    local playerPlot = workspace.PlayerPlots:FindFirstChild(player.Name .. "_Plot")
                    if playerPlot then
                        local farm2 = playerPlot:FindFirstChild("Farm2Folder")
                        if farm2 and farm2:FindFirstChild("Farm2") then
                            -- Fire for PlantPlot2, PlantPlot3, and PlantPlot4 (NOT PlantPlot1)
                            for i = 2, 4 do
                                local plantPlot = farm2.Farm2:FindFirstChild("PlantPlot" .. i)
                                if plantPlot then
                                    local prompt = plantPlot:FindFirstChild("PickupPrompt")
                                    if prompt and prompt:IsA("ProximityPrompt") then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end)
                if not success then
                    print("AutoPickUpPlantFruit Error:", error)
                end
                wait(AutoPickUpPlantFruitSpeed)
            end
        end)
    end
end)

AutoPickUpPlantFruitSlider:OnChanged(function(Value)
    AutoPickUpPlantFruitSpeed = Value
end)

-- AutoCollect Toggle and Slider
local AutoCollectToggle = Tabs.Auto:AddToggle("AutoCollect", {
    Title = "AutoCollect",
    Description = "Collect all money",
    Default = false
})

local AutoCollectSlider = Tabs.Auto:AddSlider("AutoCollectSpeed", {
    Title = "AutoCollect Speed",
    Description = "Adjust collection speed",
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0
})

AutoCollectToggle:OnChanged(function(Value)
    AutoCollectEnabled = Value
    if AutoCollectEnabled then
        spawn(function()
            while AutoCollectEnabled do
                local success, error = pcall(function()
                    local player = game.Players.LocalPlayer
                    local playerPlot = workspace.PlayerPlots:FindFirstChild(player.Name .. "_Plot")
                    if playerPlot then
                        -- Look for all Plot objects with CollectPrompt
                        for _, child in pairs(playerPlot:GetChildren()) do
                            if child.Name:match("Plot") and child:FindFirstChild("Plot4Pad") then
                                local moneyCollect = child.Plot4Pad:FindFirstChild("MoneyCollect")
                                if moneyCollect then
                                    local prompt = moneyCollect:FindFirstChild("CollectPrompt")
                                    if prompt and prompt:IsA("ProximityPrompt") then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end)
                if not success then
                    print("AutoCollect Error:", error)
                end
                wait(AutoCollectSpeed)
            end
        end)
    end
end)

AutoCollectSlider:OnChanged(function(Value)
    AutoCollectSpeed = Value
end)

-- SETTINGS TAB
if SaveManager and InterfaceManager then
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
    SaveManager:LoadAutoloadConfig()
end

Window:SelectTab(1)

-- Mobile Toggle Function - Optimized for 2K-5K Operations
local function createMiniToggle()
    local success, err = pcall(function()
        -- Remove existing toggle
        local existing = playerGui:FindFirstChild("DYHUBToggle")
        if existing then
            existing:Destroy()
        end
        
        -- Create main ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DYHUBToggle"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui

        -- Main toggle frame with glassmorphism
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "ToggleFrame"
        toggleFrame.Size = UDim2.new(0, 50, 0, 50)
        toggleFrame.Position = UDim2.new(1, -65, 0.5, -100)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        toggleFrame.BackgroundTransparency = 0.3
        toggleFrame.BorderSizePixel = 0
        toggleFrame.ZIndex = 100
        toggleFrame.Parent = screenGui

        -- Corner radius for modern look
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = toggleFrame

        -- Red outline stroke
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 50, 50)
        stroke.Thickness = 2
        stroke.Transparency = 0.2
        stroke.Parent = toggleFrame

        -- Glassmorphism gradient overlay
        local glassGradient = Instance.new("UIGradient")
        glassGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 30))
        }
        glassGradient.Rotation = 45
        glassGradient.Parent = toggleFrame

        -- Inner glow effect
        local innerFrame = Instance.new("Frame")
        innerFrame.Size = UDim2.new(1, -6, 1, -6)
        innerFrame.Position = UDim2.new(0, 3, 0, 3)
        innerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        innerFrame.BackgroundTransparency = 0.95
        innerFrame.BorderSizePixel = 0
        innerFrame.ZIndex = 101
        innerFrame.Parent = toggleFrame

        local innerCorner = Instance.new("UICorner")
        innerCorner.CornerRadius = UDim.new(0, 9)
        innerCorner.Parent = innerFrame

        -- Toggle button
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.BackgroundTransparency = 1
        toggleButton.Text = "D"
        toggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.TextScaled = true
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.ZIndex = 102
        toggleButton.Parent = toggleFrame

        -- Add text stroke for better visibility
        local textStroke = Instance.new("UIStroke")
        textStroke.Color = Color3.fromRGB(0, 0, 0)
        textStroke.Thickness = 1
        textStroke.Transparency = 0.5
        textStroke.Parent = toggleButton

        -- Input handling variables - Optimized for high volume
        local isDragging = false
        local dragStart = nil
        local startPos = nil
        local isVisible = true
        local debounce = false
        local dragThreshold = 10
        
        -- Optimized connection management - Fixed size pool
        local connections = {}
        local connectionCount = 0
        local MAX_CONNECTIONS = 20 -- Prevent memory bloat
        
        -- Performance optimization variables
        local lastFrameTime = 0
        local frameRateLimit = 1/60 -- 60 FPS limit
        local batchProcessingActive = false
        local operationQueue = {}
        local queueSize = 0
        local MAX_QUEUE_SIZE = 5000
        local BATCH_SIZE = 50
        
        -- Memory management
        local tweenPool = {}
        local activeTweens = {}
        local tweenCount = 0
        local MAX_ACTIVE_TWEENS = 10
        
        -- Efficient tween pooling system
        local function getTween(object, tweenInfo, properties)
            local tween = table.remove(tweenPool)
            if not tween then
                tween = TweenService:Create(object, tweenInfo, properties)
            else
                -- Reuse existing tween
                tween = TweenService:Create(object, tweenInfo, properties)
            end
            
            if tweenCount < MAX_ACTIVE_TWEENS then
                activeTweens[tween] = true
                tweenCount = tweenCount + 1
            else
                -- Clean oldest tween
                local oldestTween = next(activeTweens)
                if oldestTween then
                    oldestTween:Cancel()
                    activeTweens[oldestTween] = nil
                    tweenCount = tweenCount - 1
                end
                activeTweens[tween] = true
                tweenCount = tweenCount + 1
            end
            
            return tween
        end
        
        -- Return tween to pool
        local function returnTween(tween)
            if activeTweens[tween] then
                activeTweens[tween] = nil
                tweenCount = tweenCount - 1
                table.insert(tweenPool, tween)
            end
        end
        
        -- Optimized connection management
        local function addConnection(connection)
            if connectionCount < MAX_CONNECTIONS then
                connections[connectionCount + 1] = connection
                connectionCount = connectionCount + 1
            else
                -- Replace oldest connection
                if connections[1] and typeof(connections[1]) == "RBXScriptConnection" then
                    connections[1]:Disconnect()
                end
                table.remove(connections, 1)
                connections[connectionCount] = connection
            end
        end
        
        -- Batch processing for high-volume operations
        local function processBatch()
            if batchProcessingActive or queueSize == 0 then return end
            batchProcessingActive = true
            
            local processed = 0
            while queueSize > 0 and processed < BATCH_SIZE do
                local operation = table.remove(operationQueue, 1)
                if operation then
                    pcall(operation)
                    queueSize = queueSize - 1
                    processed = processed + 1
                end
            end
            
            batchProcessingActive = false
            
            -- Continue processing if queue still has items
            if queueSize > 0 then
                task.spawn(processBatch)
            end
        end
        
        -- Queue operation for batch processing
        local function queueOperation(operation)
            if queueSize < MAX_QUEUE_SIZE then
                table.insert(operationQueue, operation)
                queueSize = queueSize + 1
                
                if not batchProcessingActive then
                    task.spawn(processBatch)
                end
            end
        end
        
        -- Frame rate limited updates
        local function updateWithFrameLimit(updateFunc)
            local currentTime = tick()
            if currentTime - lastFrameTime >= frameRateLimit then
                updateFunc()
                lastFrameTime = currentTime
            else
                queueOperation(updateFunc)
            end
        end

        -- Optimized toggle function
        local function toggleWindow()
            if debounce then return end
            debounce = true
            
            queueOperation(function()
                pcall(function()
                    isVisible = not isVisible
                    if Window and Window.Root then
                        Window.Root.Visible = isVisible
                    end
                    
                    -- Optimized pulse animation with pooling
                    local pulseIn = getTween(toggleFrame, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 45, 0, 45)
                    })
                    
                    pulseIn:Play()
                    pulseIn.Completed:Connect(function()
                        returnTween(pulseIn)
                        
                        local pulseOut = getTween(toggleFrame, TweenInfo.new(0.1), {
                            Size = UDim2.new(0, 50, 0, 50)
                        })
                        
                        pulseOut:Play()
                        pulseOut.Completed:Connect(function()
                            returnTween(pulseOut)
                        end)
                    end)
                end)
            end)
            
            task.wait(0.2)
            debounce = false
        end

        -- Optimized input handling with frame limiting
        addConnection(toggleButton.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Touch or 
               input.UserInputType == Enum.UserInputType.MouseButton1 then
                
                updateWithFrameLimit(function()
                    isDragging = false
                    dragStart = input.Position
                    startPos = toggleFrame.Position
                end)
            end
        end))

        addConnection(toggleButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or 
               input.UserInputType == Enum.UserInputType.MouseMovement then
                
                updateWithFrameLimit(function()
                    if dragStart and not isDragging then
                        local distance = (input.Position - dragStart).Magnitude
                        if distance > dragThreshold then
                            isDragging = true
                        end
                    end
                    
                    if isDragging and startPos then
                        local delta = input.Position - dragStart
                        toggleFrame.Position = UDim2.new(
                            startPos.X.Scale, startPos.X.Offset + delta.X, 
                            startPos.Y.Scale, startPos.Y.Offset + delta.Y
                        )
                    end
                end)
            end
        end))

        addConnection(toggleButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or 
               input.UserInputType == Enum.UserInputType.MouseButton1 then
                
                queueOperation(function()
                    if isDragging then
                        -- Optimized snap to edges
                        local screenSize = workspace.CurrentCamera.ViewportSize
                        local framePos = toggleFrame.AbsolutePosition
                        
                        local targetPos
                        if framePos.X < screenSize.X / 2 then
                            targetPos = UDim2.new(0, 15, toggleFrame.Position.Y.Scale, toggleFrame.Position.Y.Offset)
                        else
                            targetPos = UDim2.new(1, -65, toggleFrame.Position.Y.Scale, toggleFrame.Position.Y.Offset)
                        end
                        
                        local snapTween = getTween(toggleFrame, TweenInfo.new(0.3), {Position = targetPos})
                        snapTween:Play()
                        snapTween.Completed:Connect(function()
                            returnTween(snapTween)
                        end)
                    else
                        toggleWindow()
                    end
                    
                    isDragging = false
                    dragStart = nil
                    startPos = nil
                end)
            end
        end))

        -- Optimized hover effects with pooling
        addConnection(toggleButton.MouseEnter:Connect(function()
            if not isDragging then
                queueOperation(function()
                    local hoverTween1 = getTween(toggleFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, 55, 0, 55),
                        BackgroundTransparency = 0.1
                    })
                    local hoverTween2 = getTween(stroke, TweenInfo.new(0.2), {
                        Thickness = 3,
                        Transparency = 0
                    })
                    
                    hoverTween1:Play()
                    hoverTween2:Play()
                    
                    hoverTween1.Completed:Connect(function()
                        returnTween(hoverTween1)
                    end)
                    hoverTween2.Completed:Connect(function()
                        returnTween(hoverTween2)
                    end)
                end)
            end
        end))

        addConnection(toggleButton.MouseLeave:Connect(function()
            if not isDragging then
                queueOperation(function()
                    local leaveTween1 = getTween(toggleFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, 50, 0, 50),
                        BackgroundTransparency = 0.3
                    })
                    local leaveTween2 = getTween(stroke, TweenInfo.new(0.2), {
                        Thickness = 2,
                        Transparency = 0.2
                    })
                    
                    leaveTween1:Play()
                    leaveTween2:Play()
                    
                    leaveTween1.Completed:Connect(function()
                        returnTween(leaveTween1)
                    end)
                    leaveTween2.Completed:Connect(function()
                        returnTween(leaveTween2)
                    end)
                end)
            end
        end))

        -- Enhanced cleanup with memory management
        addConnection(screenGui.AncestryChanged:Connect(function()
            if not screenGui.Parent then
                -- Clean all connections
                for i = 1, connectionCount do
                    local connection = connections[i]
                    if connection and typeof(connection) == "RBXScriptConnection" then
                        connection:Disconnect()
                    end
                end
                
                -- Clean all active tweens
                for tween, _ in pairs(activeTweens) do
                    if tween then
                        tween:Cancel()
                    end
                end
                
                -- Clear pools and queues
                table.clear(tweenPool)
                table.clear(activeTweens)
                table.clear(operationQueue)
                table.clear(connections)
                
                -- Reset counters
                connectionCount = 0
                tweenCount = 0
                queueSize = 0
                
                -- Force garbage collection
                task.spawn(function()
                    task.wait(1)
                    collectgarbage("collect")
                end)
            end
        end))
        
        -- Periodic memory cleanup - runs every 30 seconds
        task.spawn(function()
            while screenGui.Parent do
                task.wait(30)
                
                -- Clean completed tweens from pool
                if #tweenPool > 20 then
                    for i = #tweenPool, 21, -1 do
                        table.remove(tweenPool, i)
                    end
                end
                
                -- Process any remaining queued operations
                if queueSize > 0 and not batchProcessingActive then
                    task.spawn(processBatch)
                end
                
                -- Suggest garbage collection
                collectgarbage("collect")
            end
        end)
    end)
    
    if not success then
        warn("Toggle creation error:", err)
    end
end

-- Initialize mobile toggle with delay
task.spawn(function()
    task.wait(2)
    createMiniToggle()
end)

-- Final notification
if createNotif then
    createNotif("DYHUB", "High-performance script loaded! Optimized for 2K-5K operations", 3)
end

-- Enhanced cleanup on player leaving
game.Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        -- Disconnect all major connections
        if autoBuyConnection then autoBuyConnection:Disconnect() end
        if buyAllConnection then buyAllConnection:Disconnect() end
        if autoBuyRelicsConnection then autoBuyRelicsConnection:Disconnect() end
        if buyAllRelicsConnection then buyAllRelicsConnection:Disconnect() end
        if baseFarmUpgradeConnection then baseFarmUpgradeConnection:Disconnect() end
        if baseSpecialUpgradeConnection then baseSpecialUpgradeConnection:Disconnect() end
        if lassoUpgradeConnection then lassoUpgradeConnection:Disconnect() end
        
        -- Force final cleanup
        collectgarbage("collect")
    end
end)
