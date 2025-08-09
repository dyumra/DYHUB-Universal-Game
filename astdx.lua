local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Script Configuration
local config = {
    -- Game Modes
    autoJoinStory = false,
    autoJoinRaid = false,
    autoJoinChallenge = false,
    autoJoinInfinity = false,
    
    -- Auto Functions
    autoPlay = false,
    autoNext = false,
    autoReplay = false,
    autoLeave = false,
    autoUpgrade = false,
    autoSell = false,
    
    -- Summoning
    autoSummon = false,
    summonDelay = 1,
    targetSummons = 10,
    
    -- Webhook
    webhookEnabled = false,
    webhookUrl = "",
    
    -- Macro
    macroEnabled = false,
    macroSpeed = 1,
    
    -- Misc
    skipWaves = false,
    autoClaimRewards = false,
    infiniteMode = false
}

-- Game State
local gameState = {
    scriptRunning = false,
    inGame = false,
    currentWave = 0,
    totalGames = 0,
    wins = 0,
    losses = 0
}

-- GUI Variables
local mainGui
local currentTab = "main"

-- Utility Functions
local function createTween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(object, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

local function sendWebhook(title, description, color)
    if not config.webhookEnabled or config.webhookUrl == "" then return end
    
    local data = {
        embeds = {
            {
                title = title or "DYHUB | ASTD X",
                description = description or "DYHUB (dsc.gg/dyhub)",
                color = color or 3447003,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                footer = {
                    text = "DYHUB - ASTD X | Execute @" .. player.Name
                }
            }
        }
    }
    
    spawn(function()
        pcall(function()
            HttpService:PostAsync(config.webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)
    end)
end

-- Toggle Switch Component
local function createToggle(parent, text, configKey, position, size)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = size or UDim2.new(1, -20, 0, 35)
    toggleFrame.Position = position or UDim2.new(0, 10, 0, 0)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 25)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleBg.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBg
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 21, 0, 21)
    toggleButton.Position = UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleBg
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleBg
    
    local function updateToggle()
        local isEnabled = config[configKey]
        
        if isEnabled then
            createTween(toggleBg, {BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)})
            createTween(toggleButton, {Position = UDim2.new(0, 27, 0, 2)})
        else
            createTween(toggleBg, {BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)})
            createTween(toggleButton, {Position = UDim2.new(0, 2, 0, 2)})
        end
    end
    
    clickDetector.MouseButton1Click:Connect(function()
        config[configKey] = not config[configKey]
        updateToggle()
    end)
    
    updateToggle()
    return toggleFrame
end

-- Slider Component
local function createSlider(parent, text, configKey, minVal, maxVal, position, size)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = size or UDim2.new(1, -20, 0, 50)
    sliderFrame.Position = position or UDim2.new(0, 10, 0, 0)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. config[configKey]
    label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((config[configKey] - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((config[configKey] - minVal) / (maxVal - minVal), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            
            local relativePos = math.clamp((mousePos.X - sliderPos) / sliderSize, 0, 1)
            local value = math.floor(minVal + (maxVal - minVal) * relativePos)
            
            config[configKey] = value
            label.Text = text .. ": " .. value
            
            createTween(sliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)})
            createTween(sliderButton, {Position = UDim2.new(relativePos, -8, 0.5, -8)})
        end
    end)
    
    return sliderFrame
end

-- Input Field Component
local function createInput(parent, text, configKey, position, size)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = size or UDim2.new(1, -20, 0, 60)
    inputFrame.Position = position or UDim2.new(0, 10, 0, 0)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = inputFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, 0, 0, 30)
    inputBox.Position = UDim2.new(0, 0, 0, 25)
    inputBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    inputBox.BorderSizePixel = 0
    inputBox.Text = config[configKey] or ""
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.TextScaled = true
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Enter " .. text:lower() .. "..."
    inputBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
    inputBox.Parent = inputFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = inputBox
    
    inputBox.FocusLost:Connect(function()
        config[configKey] = inputBox.Text
    end)
    
    return inputFrame
end

-- Button Component
local function createButton(parent, text, callback, position, size, color)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0.45, 0, 0, 40)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = color or Color3.new(0.2, 0.6, 1)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        createTween(button, {BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)})
    end)
    
    button.MouseLeave:Connect(function()
        createTween(button, {BackgroundColor3 = color})
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Create Main GUI
local function createMainGUI()
    -- Destroy existing GUI
    if mainGui then
        mainGui:Destroy()
    end
    
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "DYHUB-ASTDX"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = mainGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "DYHUB - ASTD X"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.2)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "─"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeButton
    
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            createTween(mainFrame, {Size = UDim2.new(0, 550, 0, 40)})
        else
            createTween(mainFrame, {Size = UDim2.new(0, 550, 0, 400)})
        end
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    local tabs = {"Main", "Auto Functions", "Summoning", "Webhook", "Stats"}
    local tabButtons = {}
    local tabFrames = {}
    
    -- Create Tab Buttons
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0.2, -4, 1, 0)
        tabButton.Position = UDim2.new((i-1) * 0.2, (i-1) * 2, 0, 0)
        tabButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.Gotham
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        tabButtons[tabName:lower():gsub(" ", "")] = tabButton
        
        -- Create Tab Content Frame
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, -20, 1, -100)
        tabFrame.Position = UDim2.new(0, 10, 0, 95)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 6
        tabFrame.ScrollBarImageColor3 = Color3.new(0.5, 0.5, 0.5)
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.Visible = false
        tabFrame.Parent = mainFrame
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = tabFrame
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
        
        tabFrames[tabName:lower():gsub(" ", "")] = tabFrame
    end
    
    -- Tab Switching Function
    local function switchTab(tabName)
        currentTab = tabName
        
        for name, button in pairs(tabButtons) do
            if name == tabName then
                createTween(button, {BackgroundColor3 = Color3.new(0.2, 0.6, 1), TextColor3 = Color3.new(1, 1, 1)})
                tabFrames[name].Visible = true
            else
                createTween(button, {BackgroundColor3 = Color3.new(0.2, 0.2, 0.2), TextColor3 = Color3.new(0.7, 0.7, 0.7)})
                tabFrames[name].Visible = false
            end
        end
    end
    
    -- Connect Tab Buttons
    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end
    
    -- Populate Tabs
    populateMainTab(tabFrames.main)
    populateAutoTab(tabFrames.autofunctions)
    populateSummoningTab(tabFrames.summoning)
    populateWebhookTab(tabFrames.webhook)
    populateStatsTab(tabFrames.stats)
    
    -- Show main tab by default
    switchTab("main")
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Populate Tab Functions
function populateMainTab(parent)
    local yPos = 0
    
    -- Game Mode Selection
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Size = UDim2.new(1, 0, 0, 25)
    modeLabel.Position = UDim2.new(0, 0, 0, yPos)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "🎮 Game Mode Selection"
    modeLabel.TextColor3 = Color3.new(1, 1, 1)
    modeLabel.TextScaled = true
    modeLabel.Font = Enum.Font.GothamBold
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.Parent = parent
    yPos = yPos + 30
    
    createToggle(parent, "Auto Join Story Mode", "autoJoinStory", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Join Raid Mode", "autoJoinRaid", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Join Challenge Mode", "autoJoinChallenge", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Join Infinity Mode", "autoJoinInfinity", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 50
    
    -- Control Buttons
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 50)
    buttonFrame.Position = UDim2.new(0, 0, 0, yPos)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = parent
    
    createButton(buttonFrame, "🚀 Start Script", function()
        gameState.scriptRunning = true
        sendWebhook("Script Started", "ASTD Auto Script has been activated!", 65280)
        startMainLoop()
    end, UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), Color3.new(0.2, 0.8, 0.2))
    
    createButton(buttonFrame, "⏹️ Stop Script", function()
        gameState.scriptRunning = false
        sendWebhook("Script Stopped", "ASTD Auto Script has been deactivated!", 16711680)
    end, UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), Color3.new(0.8, 0.2, 0.2))
end

function populateAutoTab(parent)
    local yPos = 0
    
    local autoLabel = Instance.new("TextLabel")
    autoLabel.Size = UDim2.new(1, 0, 0, 25)
    autoLabel.Position = UDim2.new(0, 0, 0, yPos)
    autoLabel.BackgroundTransparency = 1
    autoLabel.Text = "⚡ Auto Functions"
    autoLabel.TextColor3 = Color3.new(1, 1, 1)
    autoLabel.TextScaled = true
    autoLabel.Font = Enum.Font.GothamBold
    autoLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoLabel.Parent = parent
    yPos = yPos + 30
    
    createToggle(parent, "Auto Play", "autoPlay", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Next Wave", "autoNext", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Replay", "autoReplay", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Leave", "autoLeave", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Upgrade", "autoUpgrade", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Sell", "autoSell", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Skip Waves", "skipWaves", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Auto Claim Rewards", "autoClaimRewards", UDim2.new(0, 0, 0, yPos))
end

function populateSummoningTab(parent)
    local yPos = 0
    
    local summonLabel = Instance.new("TextLabel")
    summonLabel.Size = UDim2.new(1, 0, 0, 25)
    summonLabel.Position = UDim2.new(0, 0, 0, yPos)
    summonLabel.BackgroundTransparency = 1
    summonLabel.Text = "🎯 Summoning & Macro"
    summonLabel.TextColor3 = Color3.new(1, 1, 1)
    summonLabel.TextScaled = true
    summonLabel.Font = Enum.Font.GothamBold
    summonLabel.TextXAlignment = Enum.TextXAlignment.Left
    summonLabel.Parent = parent
    yPos = yPos + 30
    
    createToggle(parent, "Auto Summon", "autoSummon", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 40
    createToggle(parent, "Macro Enabled", "macroEnabled", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 50
    
    createSlider(parent, "Summon Delay (seconds)", "summonDelay", 0.5, 10, UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 60
    createSlider(parent, "Target Summons", "targetSummons", 1, 50, UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 60
    createSlider(parent, "Macro Speed", "macroSpeed", 0.1, 5, UDim2.new(0, 0, 0, yPos))
end

function populateWebhookTab(parent)
    local yPos = 0
    
    local webhookLabel = Instance.new("TextLabel")
    webhookLabel.Size = UDim2.new(1, 0, 0, 25)
    webhookLabel.Position = UDim2.new(0, 0, 0, yPos)
    webhookLabel.BackgroundTransparency = 1
    webhookLabel.Text = "🔔 Webhook Settings"
    webhookLabel.TextColor3 = Color3.new(1, 1, 1)
    webhookLabel.TextScaled = true
    webhookLabel.Font = Enum.Font.GothamBold
    webhookLabel.TextXAlignment = Enum.TextXAlignment.Left
    webhookLabel.Parent = parent
    yPos = yPos + 30
    
    createToggle(parent, "Enable Webhook", "webhookEnabled", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 50
    
    createInput(parent, "Discord Webhook URL", "webhookUrl", UDim2.new(0, 0, 0, yPos))
    yPos = yPos + 70
    
    local testFrame = Instance.new("Frame")
    testFrame.Size = UDim2.new(1, 0, 0, 40)
    testFrame.Position = UDim2.new(0, 0, 0, yPos)
    testFrame.BackgroundTransparency = 1
    testFrame.Parent = parent
    
    createButton(testFrame, "🧪 Test Webhook", function()
        sendWebhook("Test Message", "This is a test message from ASTD Script!", 16776960)
    end, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Color3.new(0.8, 0.6, 0.2))
end

function populateStatsTab(parent)
    local yPos = 0
    
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, 0, 0, 25)
    statsLabel.Position = UDim2.new(0, 0, 0, yPos)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "📊 Statistics"
    statsLabel.TextColor3 = Color3.new(1, 1, 1)
    statsLabel.TextScaled = true
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.Parent = parent
    yPos = yPos + 40
    
    -- Create stats display
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 200)
    statsFrame.Position = UDim2.new(0, 0, 0, yPos)
    statsFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = parent
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsFrame
    
    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, -20, 1, -20)
    statsText.Position = UDim2.new(0, 10, 0, 10)
    statsText.BackgroundTransparency = 1
    statsText.Text = "Total Games: 0\nWins: 0\nLosses: 0\nWin Rate: 0%\nCurrent Wave: 0\nScript Status: Stopped"
    statsText.TextColor3 = Color3.new(1, 1, 1)
    statsText.TextScaled = true
    statsText.Font = Enum.Font.Gotham
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    statsText.Parent = statsFrame
    
    -- Update stats periodically
    spawn(function()
        while true do
            wait(1)
            local winRate = gameState.totalGames > 0 and math.floor((gameState.wins / gameState.totalGames) * 100) or 0
            local status = gameState.scriptRunning and "Running" or "Stopped"
            
            statsText.Text = string.format(
                "Total Games: %d\nWins: %d\nLosses: %d\nWin Rate: %d%%\nCurrent Wave: %d\nScript Status: %s",
                gameState.totalGames,
                gameState.wins,
                gameState.losses,
                winRate,
                gameState.currentWave,
                status
            )
        end
    end)
    
    yPos = yPos + 220
    
    local resetFrame = Instance.new("Frame")
    resetFrame.Size = UDim2.new(1, 0, 0, 40)
    resetFrame.Position = UDim2.new(0, 0, 0, yPos)
    resetFrame.BackgroundTransparency = 1
    resetFrame.Parent = parent
    
    createButton(resetFrame, "🔄 Reset Stats", function()
        gameState.totalGames = 0
        gameState.wins = 0
        gameState.losses = 0
        gameState.currentWave = 0
    end, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Color3.new(0.6, 0.6, 0.6))
end

-- Game Logic Functions
local function findAndClick(name, parent)
    parent = parent or playerGui
    local element = parent:FindFirstChild(name, true)
    
    if element and (element:IsA("GuiButton") or element:IsA("TextButton")) then
        if element.Visible and element.Active then
            element:Fire("MouseButton1Click")
            return true
        end
    end
    return false
end

local function joinGameMode()
    wait(2)
    
    if config.autoJoinStory and findAndClick("Story") then
        print("Joined Story Mode")
        return true
    elseif config.autoJoinRaid and findAndClick("Raid") then
        print("Joined Raid Mode")
        return true
    elseif config.autoJoinChallenge and findAndClick("Challenge") then
        print("Joined Challenge Mode")
        return true
    elseif config.autoJoinInfinity and findAndClick("Infinity") then
        print("Joined Infinity Mode")
        return true
    end
    
    return false
end

local function autoPlayGame()
    if not config.autoPlay then return end
    
    wait(3)
    if findAndClick("Play") or findAndClick("START") or findAndClick("Begin") then
        gameState.inGame = true
        gameState.currentWave = 1
        print("Game started automatically")
        return true
    end
    return false
end

local function autoNextWave()
    if not config.autoNext or not gameState.inGame then return end
    
    spawn(function()
        while gameState.inGame and config.autoNext and gameState.scriptRunning do
            wait(0.5)
            
            if findAndClick("Next") or findAndClick("NEXT") or findAndClick("NextWave") then
                gameState.currentWave = gameState.currentWave + 1
                wait(1)
            end
        end
    end)
end

local function autoSummonLoop()
    if not config.autoSummon then return end
    
    spawn(function()
        local summonCount = 0
        while gameState.inGame and config.autoSummon and gameState.scriptRunning do
            wait(config.summonDelay)
            
            if summonCount < config.targetSummons then
                if findAndClick("Summon") or findAndClick("SUMMON") or findAndClick("SummonButton") then
                    summonCount = summonCount + 1
                    print("Auto summoned: " .. summonCount .. "/" .. config.targetSummons)
                end
            else
                wait(5) -- Wait before trying to summon more
                summonCount = 0
            end
        end
    end)
end

local function runMacro()
    if not config.macroEnabled then return end
    
    spawn(function()
        while gameState.inGame and config.macroEnabled and gameState.scriptRunning do
            wait(1 / config.macroSpeed)
            
            -- Auto upgrade towers
            if config.autoUpgrade then
                findAndClick("Upgrade") or findAndClick("UPGRADE")
            end
            
            -- Auto sell weak towers
            if config.autoSell then
                findAndClick("Sell") or findAndClick("SELL")
            end
            
            -- Skip waves if enabled
            if config.skipWaves then
                findAndClick("Skip") or findAndClick("SKIP")
            end
            
            -- Claim rewards
            if config.autoClaimRewards then
                findAndClick("Claim") or findAndClick("CLAIM") or findAndClick("ClaimAll")
            end
        end
    end)
end

local function checkGameResult()
    spawn(function()
        while gameState.inGame and gameState.scriptRunning do
            wait(2)
            
            -- Check for victory
            if playerGui:FindFirstChild("Victory", true) or playerGui:FindFirstChild("Win", true) or playerGui:FindFirstChild("Success", true) then
                gameState.wins = gameState.wins + 1
                gameState.totalGames = gameState.totalGames + 1
                gameState.inGame = false
                
                local message = "🎉 Victory! Wave: " .. gameState.currentWave .. " | Total Wins: " .. gameState.wins
                print(message)
                sendWebhook("Victory!", message, 65280)
                
                handleGameEnd()
                break
                
            -- Check for defeat
            elseif playerGui:FindFirstChild("Defeat", true) or playerGui:FindFirstChild("Loss", true) or playerGui:FindFirstChild("Failed", true) then
                gameState.losses = gameState.losses + 1
                gameState.totalGames = gameState.totalGames + 1
                gameState.inGame = false
                
                local message = "💀 Defeat! Wave: " .. gameState.currentWave .. " | Total Losses: " .. gameState.losses
                print(message)
                sendWebhook("Defeat!", message, 16711680)
                
                handleGameEnd()
                break
            end
        end
    end)
end

local function handleGameEnd()
    wait(3)
    
    if config.autoReplay then
        if findAndClick("Replay") or findAndClick("REPLAY") or findAndClick("PlayAgain") then
            print("Auto replay activated")
            wait(5)
            startGameCycle()
        end
    elseif config.autoLeave then
        if findAndClick("Leave") or findAndClick("LEAVE") or findAndClick("Exit") then
            print("Auto leave activated")
        end
    end
end

-- Main Game Cycle
function startGameCycle()
    if not gameState.scriptRunning then return end
    
    print("🚀 Starting new game cycle...")
    gameState.currentWave = 0
    
    -- Join game mode
    if joinGameMode() then
        wait(2)
        
        -- Start the game
        if autoPlayGame() then
            -- Start all auto functions
            autoNextWave()
            autoSummonLoop()
            runMacro()
            checkGameResult()
        else
            print("❌ Failed to start game")
            wait(5)
            if gameState.scriptRunning then
                startGameCycle() -- Retry
            end
        end
    else
        print("❌ Failed to join game mode")
        wait(5)
        if gameState.scriptRunning then
            startGameCycle() -- Retry
        end
    end
end

-- Main Loop
function startMainLoop()
    spawn(function()
        while gameState.scriptRunning do
            if not gameState.inGame then
                startGameCycle()
            end
            wait(5)
        end
    end)
end

-- Initialize GUI
print("🌟 ASTD X Script Loaded!")

createMainGUI()

-- Auto-load notification

sendWebhook("Script Loaded", "ASTD Advanced Script has been loaded successfully! 🚀", 3447003)
