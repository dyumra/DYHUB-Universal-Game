local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 5
        })
    end)
    print("Notify:", text)
end

notify("🛡️ DYHUB'S TEAM\nJoin our (dsc.gg/dyhub)")

local key1InputGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
key1InputGui.Name = "LoadingMenu"
key1InputGui.ResetOnSpawn = false

local key1Frame = Instance.new("Frame")
key1Frame.Parent = key1InputGui
key1Frame.Size = UDim2.new(0, 320, 0, 180)
key1Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
key1Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
key1Frame.BackgroundTransparency = 0.2
key1Frame.BorderSizePixel = 0
key1Frame.ClipsDescendants = true
key1Frame.Visible = true

Instance.new("UICorner", key1Frame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", key1Frame).Thickness = 2

local key1Title = Instance.new("TextLabel", key1Frame)
key1Title.Size = UDim2.new(1, 0, 0, 50)
key1Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
key1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
key1Title.BackgroundTransparency = 0.5
key1Title.Font = Enum.Font.GothamBold
key1Title.TextSize = 22
key1Title.Text = "🛡 DYHUB\n Join our (dsc.gg/dyhub)"
Instance.new("UICorner", key1Title).CornerRadius = UDim.new(0, 15)

local spinner = Instance.new("ImageLabel", key1Frame)
spinner.Size = UDim2.new(0, 60, 0, 60)
spinner.Position = UDim2.new(0.5, 0, 0.5, 10)
spinner.AnchorPoint = Vector2.new(0.5, 0.5)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://82285050019288"
spinner.ImageColor3 = Color3.fromRGB(255, 255, 255)

spawn(function()
    while spinner and spinner.Parent do
        spinner.Rotation = spinner.Rotation + 3
        RunService.RenderStepped:Wait()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "DYHUB | Dupe MCA | Anime Rails"
gui.ResetOnSpawn = false
gui.Enabled = false

local guiReady = player:WaitForChild("PlayerGui", 10)
if not guiReady then warn("❌ PlayerGui not found!") return end
gui.Parent = guiReady

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Thickness = 3

local function getRainbowColor(tick)
    local frequency = 2
    local red = math.floor(math.sin(frequency * tick + 0) * 127 + 128)
    local green = math.floor(math.sin(frequency * tick + 2) * 127 + 128)
    local blue = math.floor(math.sin(frequency * tick + 4) * 127 + 128)
    return Color3.fromRGB(red, green, blue)
end

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Position = UDim2.new(1, -54, 0, 12)
toggleBtn.Text = "D"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    borderStroke.Color = getRainbowColor(tick())
    toggleBtn.TextColor3 = color
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Dupe | DYHUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

RunService.RenderStepped:Connect(function()
    local color = getRainbowColor(tick())
    borderStroke.Color = color
    title.TextColor3 = color
end)

local inputBox = Instance.new("TextBox", mainFrame)
inputBox.Size = UDim2.new(0.7, -5, 0, 35)
inputBox.Position = UDim2.new(0.05, 0, 0.10, 0)
inputBox.PlaceholderText = "Dupe Custom (e.g, Shadow)"
inputBox.Text = ""
inputBox.ClearTextOnFocus = false
inputBox.TextScaled = true
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.Font = Enum.Font.Gotham
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 10)

local singleDupeBtn = Instance.new("TextButton", mainFrame)
singleDupeBtn.Size = UDim2.new(0.2, 0, 0, 35)
singleDupeBtn.Position = UDim2.new(0.75, 0, 0.10, 0)
singleDupeBtn.Text = "✓"
singleDupeBtn.TextScaled = true
singleDupeBtn.Font = Enum.Font.GothamBold
singleDupeBtn.TextColor3 = Color3.new(1, 1, 1)
singleDupeBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
Instance.new("UICorner", singleDupeBtn).CornerRadius = UDim.new(0, 10)

local searchBox = Instance.new("TextBox", mainFrame)
searchBox.Size = UDim2.new(0.9, 0, 0, 30)
searchBox.Position = UDim2.new(0.05, 0, 0.18, 0)
searchBox.PlaceholderText = "Search"
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.TextScaled = true
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.Gotham
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 10)

local listFrame = Instance.new("Frame", mainFrame)
listFrame.Size = UDim2.new(0.9, 0, 0.32, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.255, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

local scrolling = Instance.new("ScrollingFrame", listFrame)
scrolling.Size = UDim2.new(1, 0, 1, 0)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.BackgroundTransparency = 1
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", scrolling)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local dupeNames = {
  "Infinity", "Solar", "Crimson", "DarkArcher", "PurpleAssasin", "WolfBoss", "Merchant", "SickCurse", "Tank",
  "CrimsonMaster", "Lightning", "SunBreather", "KnightBoss", "Materials", "Baryon", "HeinEra", "Sukuna",
  "Naruto", "SSGoku", "Tanjiro", "Goku", "Shadows", "Kaiser", "Puzzle", "Knight", "Shake", "Hapticss",
  "MuzanAura", "MoonAura", "YellowAura", "MuzanClass", "KokoshiboClass", "CompassClass", "MuzanMorph",
  "MoonMorph", "HakiPower", "InfinityVoid", "Dismantle", "Restriction", "BlackFlashAura", "ShadowAura",
  "CriticalHit", "Gear4", "BlackFlash", "Toji", "InfinityEyes", "MasteredReflex", "LavaMasterClass",
  "RedeemedWolfBoss", "RedeemedKnight", "LuffyMorph", "DoughMorph", "GravityAura", "DoughAura",
  "LavaAura", "Gear5Class", "MochiClass", "Rinnegan", "Kurama", "Sasuke", "Pain", "EightGates", "Sed",
  "Cid", "Gojo", "Assasin", "AntKing", "BlueFlames", "BloodKnight", "BloodMorph", "BloodMorphS",
  "AntMorph", "AntMorphS", "AssasinMorph", "LightAura", "AlterAura", "Alter", "Saber", "SaberMorph", "AlterMorph"
}

local function fillScrollingList()
  for _, v in ipairs(dupeNames) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -15, 0, 22)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.Text = v
    label.Parent = scrolling
  end
  local count = #dupeNames
  scrolling.CanvasSize = UDim2.new(0, 0, 0, count * 26)
end

fillScrollingList()

local function updateDupeList(filter)
    filter = filter:lower()
    for _, label in ipairs(scrolling:GetChildren()) do
        if label:IsA("TextLabel") then
            label.Visible = label.Text:lower():find(filter) ~= nil
        end
    end
    local visibleCount = 0
    for _, label in ipairs(scrolling:GetChildren()) do
        if label:IsA("TextLabel") and label.Visible then
            visibleCount = visibleCount + 1
        end
    end
    scrolling.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 26)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateDupeList(searchBox.Text)
end)

local singleDupeBtnTweenLoop
local function startSingleDupeBtnTween()
    singleDupeBtnTweenLoop = true
    spawn(function()
        while singleDupeBtnTweenLoop and singleDupeBtn and singleDupeBtn.Parent do
            local tween1 = TweenService:Create(singleDupeBtn, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(0,0,0)})
            tween1:Play()
            tween1.Completed:Wait()
            local tween2 = TweenService:Create(singleDupeBtn, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60,160,60)})
            tween2:Play()
            tween2.Completed:Wait()
        end
    end)
end

startSingleDupeBtnTween()

singleDupeBtn.MouseButton1Click:Connect(function()
    local nameToDupe = inputBox.Text
    local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ChangeValue")
    if not event then
        notify("❌ Event ChangeValue not found")
        return
    end
    local found = false
    for _, name in ipairs(dupeNames) do
        if name:lower() == nameToDupe:lower() then
            event:FireServer("SetMorphBuy", name, 0)
            notify("✅ Dupe executed: "..name)
            found = true
            break
        end
    end
    if not found then
        notify("❌ Morph not found: "..nameToDupe)
    end
end)

local dupeAllBtn = Instance.new("TextButton", mainFrame)
dupeAllBtn.Size = UDim2.new(0.9, 0, 0, 35)
dupeAllBtn.Position = UDim2.new(0.05, 0, 0.63, 0)
dupeAllBtn.Text = "Dupe All"
dupeAllBtn.TextScaled = true
dupeAllBtn.Font = Enum.Font.GothamBold
dupeAllBtn.TextColor3 = Color3.new(1, 1, 1)
dupeAllBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
Instance.new("UICorner", dupeAllBtn).CornerRadius = UDim.new(0, 10)

spawn(function()
    while dupeAllBtn and dupeAllBtn.Parent do
        local tween1 = TweenService:Create(dupeAllBtn, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(0,0,0)})
        tween1:Play()
        tween1.Completed:Wait()
        local tween2 = TweenService:Create(dupeAllBtn, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(180,30,30)})
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

dupeAllBtn.MouseButton1Click:Connect(function()
    local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ChangeValue")
    if not event then
        notify("❌ Event ChangeValue not found")
        return
    end
    for _, name in ipairs(dupeNames) do
        event:FireServer("SetMorphBuy", name, 0)
        wait(0.05)
    end
    notify("✅ Dupe All executed!")
end)

local hideMorphBtn = Instance.new("TextButton", mainFrame)
hideMorphBtn.Size = UDim2.new(0.9, 0, 0, 30)
hideMorphBtn.Position = UDim2.new(0.05, 0, 0.73, 0)
hideMorphBtn.Text = "HideMorph: Off"
hideMorphBtn.TextScaled = true
hideMorphBtn.Font = Enum.Font.Gotham
hideMorphBtn.TextColor3 = Color3.new(1, 1, 1)
hideMorphBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", hideMorphBtn).CornerRadius = UDim.new(0, 10)

hideMorphBtn.MouseButton1Click:Connect(function()
    local data = player:FindFirstChild("Data")
    if data and data:FindFirstChild("HideMorph") then
        data.HideMorph.Value = not data.HideMorph.Value
        hideMorphBtn.Text = "HideMorph: " .. (data.HideMorph.Value and "On" or "Off")
        notify("🔁 HideMorph: " .. tostring(data.HideMorph.Value))
    else
        notify("❌ HideMorph BoolValue not found")
    end
end)

local gamepassBtn = Instance.new("TextButton", mainFrame)
gamepassBtn.Size = UDim2.new(0.9, 0, 0, 30)
gamepassBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
gamepassBtn.Text = "Unlock Gamepass (Press Everytime)"
gamepassBtn.TextScaled = true
gamepassBtn.Font = Enum.Font.Gotham
gamepassBtn.TextColor3 = Color3.new(1, 1, 1)
gamepassBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", gamepassBtn).CornerRadius = UDim.new(0, 10)

gamepassBtn.MouseButton1Click:Connect(function()
    local data = player:FindFirstChild("Data")
    if data then
        local gamepasses = {"DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin"}
        for _, gpName in ipairs(gamepasses) do
            local gp = data:FindFirstChild(gpName)
            if gp then
                gp.Value = true
            end
        end
        notify("🔎 Bypass - Checking Gamepass")
wait(4)
        notify("🔒 Bypass - Finished!")
wait(0.5)
        notify("🔓 Bypass - Gamepasses Unlocked!")

        wait(0.5)

        notify("🔓 SkipSpin unlocked!")
wait(1)

        notify("🔓 DoubleCash unlocked!")
wait(1)
        notify("🔓 2-Class Slots unlocked!")
wait(1)
        notify("🔓 Emote unlocked!")
        local e = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Emotes
        e.Visible = true
wait(1)
        notify("🔓 CriticalHit unlocked!")
wait(1)
notify("🎁 Gamepasses unlocked - All!")
    else
        notify("❌ Data folder not found")
    end
end)

local function adjustGuiSize(scale)
    local newWidth = math.clamp(mainFrame.Size.X.Offset + scale, 300, 700)
    local newHeight = math.clamp(mainFrame.Size.Y.Offset + scale * 1.2, 400, 800)
    mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
end

local plusBtn = Instance.new("TextButton", mainFrame)
plusBtn.Size = UDim2.new(0, 30, 0, 30)
plusBtn.Position = UDim2.new(1, -35, 1, -35)
plusBtn.AnchorPoint = Vector2.new(0, 0)
plusBtn.Text = "+"
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextColor3 = Color3.new(1, 1, 1)
plusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 5)

local minusBtn = Instance.new("TextButton", mainFrame)
minusBtn.Size = UDim2.new(0, 30, 0, 30)
minusBtn.Position = UDim2.new(1, -70, 1, -35)
minusBtn.AnchorPoint = Vector2.new(0, 0)
minusBtn.Text = "-"
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextColor3 = Color3.new(1, 1, 1)
minusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 5)

plusBtn.MouseButton1Click:Connect(function()
    adjustGuiSize(20)
end)

minusBtn.MouseButton1Click:Connect(function()
    adjustGuiSize(-20)
end)

task.spawn(function()
    wait(5)
    key1InputGui:Destroy()
notify("🎮 Game: [UPDATE] Anime Rails [Alpha]")
wait(1.5)
notify("📊 Version: v762 (Final Version)")
    gui.Enabled = true
end)
