local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local main = Instance.new("ScreenGui")
main.Name = "DYHUB | Fly V4"
main.Parent = player:WaitForChild("PlayerGui")
main.ResetOnSpawn = false

local function styleButton(btn)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)
    local uistroke = Instance.new("UIStroke", btn)
    uistroke.Thickness = 1.8
    uistroke.Transparency = 0.6
    uistroke.Color = Color3.fromRGB(150, 150, 150)
end

local function setupHover(btn, colNormal, colHover)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = colHover
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = colNormal
    end)
end

-- สร้าง Main Frame
local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Size = UDim2.new(0, 280, 0, 90)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.BorderSizePixel = 0

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 18)
cornerMain.Parent = Frame

local stroke = Instance.new("UIStroke")
stroke.Parent = Frame
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.3

local gradient = Instance.new("UIGradient")
gradient.Parent = stroke
gradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(255, 255, 255))
gradient.Rotation = 45

-- Title Label
local title = Instance.new("TextLabel")
title.Parent = Frame
title.Text = "FLY GUI V4"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextScaled = true
title.TextWrapped = true
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 160, 0, 30)
title.Position = UDim2.new(0.03, 0, 0, 8)
title.ZIndex = 5

-- Speed Display Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = Frame
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "1"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Position = UDim2.new(0.6, 0, 0.3, 0)
speedLabel.Size = UDim2.new(0, 50, 0, 40)
speedLabel.ZIndex = 5
speedLabel.TextStrokeTransparency = 0.7

-- Credit Label
local creditLabel = Instance.new("TextLabel")
creditLabel.Parent = Frame
creditLabel.BackgroundTransparency = 0.5
creditLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
creditLabel.Position = UDim2.new(1, -90, 1, -22)
creditLabel.Size = UDim2.new(0, 80, 0, 18)
creditLabel.Font = Enum.Font.Gotham
creditLabel.Text = "© DYHUB"
creditLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditLabel.TextScaled = false
creditLabel.TextSize = 14
creditLabel.TextXAlignment = Enum.TextXAlignment.Right
creditLabel.TextYAlignment = Enum.TextYAlignment.Center
creditLabel.ClipsDescendants = true

local creditCorner = Instance.new("UICorner")
creditCorner.CornerRadius = UDim.new(0, 8)
creditCorner.Parent = creditLabel

-- ฟังก์ชันสร้างปุ่ม
local function createButton(name, text, posX, posY, width, height, colNormal, colHover)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = Frame
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, width, 0, height)
    btn.BackgroundColor3 = colNormal
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Text = text
    btn.TextScaled = true
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    styleButton(btn)
    setupHover(btn, colNormal, colHover)
    return btn
end

-- สร้างปุ่มทั้งหมด
local up = createButton("UpButton", "▲", 10, 40, 40, 40, Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 150, 255))
local down = createButton("DownButton", "▼", 10, 5, 40, 40, Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 150, 255))

local minus = createButton("MinusSpeed", "-", 60, 5, 40, 40, Color3.fromRGB(50, 50, 50), Color3.fromRGB(255, 100, 100))
local plus = createButton("PlusSpeed", "+", 120, 5, 40, 40, Color3.fromRGB(50, 50, 50), Color3.fromRGB(100, 255, 100))

local onoff = createButton("FlyToggle", "FLY", 190, 40, 70, 40, Color3.fromRGB(80, 80, 80), Color3.fromRGB(200, 200, 50))

local closeBtn = createButton("CloseButton", "X", 240, 5, 30, 30, Color3.fromRGB(220, 50, 50), Color3.fromRGB(255, 100, 100))
local minimizeBtn = createButton("MinimizeButton", "—", 200, 5, 30, 30, Color3.fromRGB(100, 100, 100), Color3.fromRGB(150, 150, 150))

-- ตัวแปรสถานะและค่าความเร็ว
local flyEnabled = false
local speedValue = 1

local function updateSpeedLabel()
    speedLabel.Text = tostring(speedValue)
end
updateSpeedLabel()

-- Toggle Fly
local function toggleFly()
    flyEnabled = not flyEnabled

    if flyEnabled then
        onoff.Text = "FLY ON"
        onoff.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
    else
        onoff.Text = "FLY"
        onoff.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end

local function increaseSpeed()
    speedValue = math.clamp(speedValue + 1, 1, 50)
    updateSpeedLabel()
end

local function decreaseSpeed()
    speedValue = math.clamp(speedValue - 1, 1, 50)
    updateSpeedLabel()
end

-- Fly Logic
local bg, bv, rootPart
local control = {f=0,b=0,l=0,r=0}
local moveConnection

local function startFly()
    if flyEnabled == false then return end

    local char = player.Character
    if not char then return end

    rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    humanoid.PlatformStand = true

    bg = Instance.new("BodyGyro", rootPart)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = workspace.CurrentCamera.CFrame

    bv = Instance.new("BodyVelocity", rootPart)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0,0,0)

    -- Keyboard Input
    local function onInput(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        local isDown = input.UserInputState == Enum.UserInputState.Begin
        if key == Enum.KeyCode.W then control.f = isDown and 1 or 0
        elseif key == Enum.KeyCode.S then control.b = isDown and -1 or 0
        elseif key == Enum.KeyCode.A then control.l = isDown and -1 or 0
        elseif key == Enum.KeyCode.D then control.r = isDown and 1 or 0
        elseif key == Enum.KeyCode.Space then control.u = isDown and 1 or 0
        elseif key == Enum.KeyCode.LeftControl then control.d = isDown and -1 or 0
        end
    end

    UserInputService.InputBegan:Connect(onInput)
    UserInputService.InputEnded:Connect(onInput)

    moveConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
            if moveConnection then moveConnection:Disconnect() end
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
            return
        end

        local speed = speedValue

        local moveVec = Vector3.new(control.l + control.r, (control.u or 0) + (control.d or 0), control.f + control.b)
        if moveVec.Magnitude > 0 then
            bv.Velocity = rootPart.CFrame:VectorToWorldSpace(moveVec.Unit) * speed
        else
            bv.Velocity = Vector3.new(0,0,0)
        end

        bg.CFrame = workspace.CurrentCamera.CFrame
    end)
end

local function stopFly()
    flyEnabled = false
end

-- เชื่อมปุ่มกับฟังก์ชัน
onoff.MouseButton1Click:Connect(function()
    toggleFly()
    if flyEnabled then
        startFly()
    else
        -- ปิด fly
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if moveConnection then moveConnection:Disconnect() end
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end)

plus.MouseButton1Click:Connect(increaseSpeed)
minus.MouseButton1Click:Connect(decreaseSpeed)

closeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(0.1, 0, 1.5, 0)})
    tween:Play()
    tween.Completed:Wait()
    main:Destroy()
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        -- ขยายกลับ
        local tweenSize = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 280, 0, 90)})
        tweenSize:Play()
        tweenSize.Completed:Wait()
        -- ปรับตำแหน่งปุ่มกลับมา
        up.Visible = true
        down.Visible = true
        minus.Visible = true
        plus.Visible = true
        speedLabel.Visible = true
        onoff.Visible = true
        minimized = false
    else
        -- ย่อ
        local tweenSize = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 120, 0, 40)})
        tweenSize:Play()
        tweenSize.Completed:Wait()
        -- ซ่อนปุ่มที่ไม่จำเป็น
        up.Visible = false
        down.Visible = false
        minus.Visible = false
        plus.Visible = false
        speedLabel.Visible = false
        onoff.Visible = false
        minimized = true
    end
end)

-- ให้ Frame เป็น draggable ด้วยเม้าส์
-- เพิ่มตรงนี้เพื่อความเสถียร (ถ้า Frame.Draggable = true ไม่ตอบโจทย์)

local dragging = false
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("FLY GUI V4 loaded. Use W,A,S,D + Space/Ctrl to move while flying.")
