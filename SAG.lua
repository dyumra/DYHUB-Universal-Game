-- ✅ DYHUB | STEAL A GARDEN!
if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")
local replicated_storage = game:GetService("ReplicatedStorage")
local proximity_prompt_service = game:GetService("ProximityPromptService")
local workspace = game:GetService("Workspace")

--// Notifier
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = txt,
            Duration = 3
        })
    end)
end

notify("✅ DYHUB Loaded for Steal a Garden")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DYHUB | Steal a Garden!"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 440)
frame.Position = UDim2.new(0.5, -140, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

local function getRainbow(t)
    local f = 2
    return Color3.fromRGB(
        math.floor(math.sin(f*t+0)*127+128),
        math.floor(math.sin(f*t+2)*127+128),
        math.floor(math.sin(f*t+4)*127+128)
    )
end

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "STEAL A GARDEN! | DYHUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0.6

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", toggleBtn).Thickness = 2

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    local rainbow = getRainbow(t)
    title.TextColor3 = rainbow
    toggleBtn.TextColor3 = rainbow
    stroke.Color = rainbow
end)

local function createBtn(text, posY, parentFrame)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parentFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local function createBox(placeholder, posY, parentFrame, default)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.PlaceholderText = placeholder
    b.Text = tostring(default)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parentFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

--// State
local flags = {
    pickup_aura = false,
    goto_nearest = false,
    auto_sell = false,
    always_gold = false,
    no_hold = false,
    remove_coins = false,
}

local pickup_aura_range = 25
local pickup_aura_delay = 0.1
local sell_delay = 0.1

--// Helpers
local function nearest_plant()
    local closest, shortest = nil, math.huge
    for _, plant in ipairs(workspace.Plants:GetChildren()) do
        if plant:IsA("Model") and plant.PrimaryPart and player.Character then
            local dist = (plant:GetPivot().Position - player.Character:GetPivot().Position).Magnitude
            if dist < shortest then
                closest = plant
                shortest = dist
            end
        end
    end
    return closest
end

local function start_pickup_aura()
    task.spawn(function()
        while flags.pickup_aura do
            for _, plant in ipairs(workspace.Plants:GetChildren()) do
                if plant:IsA("Model") and plant.PrimaryPart and player.Character and
                   (plant:GetPivot().Position - player.Character:GetPivot().Position).Magnitude < pickup_aura_range then
                    fireproximityprompt(plant.PrimaryPart:FindFirstChildOfClass("ProximityPrompt"))
                end
            end
            task.wait(pickup_aura_delay)
        end
    end)
end

local function start_tp_to_plant()
    task.spawn(function()
        while flags.goto_nearest do
            local target = nearest_plant()
            if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target:GetPivot() + Vector3.new(0, 5, 0)
            end
            task.wait(0.2)
        end
    end)
end

local function start_auto_sell()
    task.spawn(function()
        while flags.auto_sell do
            local crate = player.Character and player.Character:FindFirstChild("Crate")
            if crate then
                for _, item in ipairs(crate:GetChildren()) do
                    if item:IsA("Model") then
                        replicated_storage.Remotes.SellPlantFromCrate:FireServer({
                            IsGold = flags.always_gold,
                            Name = item.Name,
                            UID = item:GetAttribute("UID")
                        })
                    end
                end
            end
            task.wait(sell_delay)
        end
    end)
end

--// Buttons & Inputs
local y = 40

local pickupBtn = createBtn("Pickup Aura: OFF", y, frame)
pickupBtn.MouseButton1Click:Connect(function()
    flags.pickup_aura = not flags.pickup_aura
    pickupBtn.Text = "Pickup Aura: " .. (flags.pickup_aura and "ON" or "OFF")
    if flags.pickup_aura then start_pickup_aura() end
end)

y = y + 40

local tpBtn = createBtn("TP to Nearest: OFF", y, frame)
tpBtn.MouseButton1Click:Connect(function()
    flags.goto_nearest = not flags.goto_nearest
    tpBtn.Text = "TP to Nearest: " .. (flags.goto_nearest and "ON" or "OFF")
    if flags.goto_nearest then start_tp_to_plant() end
end)

y = y + 40

local autoSellBtn = createBtn("Auto Sell: OFF", y, frame)
autoSellBtn.MouseButton1Click:Connect(function()
    flags.auto_sell = not flags.auto_sell
    autoSellBtn.Text = "Auto Sell: " .. (flags.auto_sell and "ON" or "OFF")
    if flags.auto_sell then start_auto_sell() end
end)

y = y + 40

local goldBtn = createBtn("Always Gold: OFF", y, frame)
goldBtn.MouseButton1Click:Connect(function()
    flags.always_gold = not flags.always_gold
    goldBtn.Text = "Always Gold: " .. (flags.always_gold and "ON" or "OFF")
end)

y = y + 40

local noHoldBtn = createBtn("No Hold: OFF", y, frame)
noHoldBtn.MouseButton1Click:Connect(function()
    flags.no_hold = not flags.no_hold
    noHoldBtn.Text = "No Hold: " .. (flags.no_hold and "ON" or "OFF")
end)

y = y + 40

local coinBtn = createBtn("Destroy Coins: OFF", y, frame)
coinBtn.MouseButton1Click:Connect(function()
    flags.remove_coins = not flags.remove_coins
    coinBtn.Text = "Destroy Coins: " .. (flags.remove_coins and "ON" or "OFF")
    if flags.remove_coins then
        for _, v in ipairs(workspace:GetChildren()) do
            if v.Name == "Coin" then v:Destroy() end
        end
    end
end)

y = y + 40

-- Number Inputs with Clamp
local rangeBox = createBox("Pickup Aura Range [25–50]", y, frame, pickup_aura_range)
rangeBox.FocusLost:Connect(function()
    local val = tonumber(rangeBox.Text)
    if val then
        if val < 25 then val = 25 end
        if val > 50 then val = 50 end
        pickup_aura_range = val
        rangeBox.Text = tostring(val)
    end
end)

y = y + 40

local delayBox = createBox("Pickup Aura Delay [0.1–10]", y, frame, pickup_aura_delay)
delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val then
        if val < 0.1 then val = 0.1 end
        if val > 10 then val = 10 end
        pickup_aura_delay = val
        delayBox.Text = tostring(val)
    end
end)

y = y + 40

local sellBox = createBox("Sell Delay [0.1–10]", y, frame, sell_delay)
sellBox.FocusLost:Connect(function()
    local val = tonumber(sellBox.Text)
    if val then
        if val < 0.1 then val = 0.1 end
        if val > 10 then val = 10 end
        sell_delay = val
        sellBox.Text = tostring(val)
    end
end)

--// Connections
proximity_prompt_service.PromptButtonHoldBegan:Connect(function(prompt)
    if flags.no_hold then
        prompt.HoldDuration = 0
    end
end)

workspace.ChildAdded:Connect(function(child)
    if flags.remove_coins and child.Name == "Coin" then
        child:Destroy()
    end
end)
