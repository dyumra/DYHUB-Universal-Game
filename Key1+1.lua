local allowedGames = {
    ["286090429"] = "Arsenal",
    ["14940775218"] = "No-Scope Arcade (2021)",
    ["6407649031"] = "No-Scope Arcade",
}

local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local VALID_KEY = "DYHUBTHEBEST"
local dyhubonly = "dev"

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 4
        })
    end)
    print("Notify:", text)
end

notify("DYHUB'S TEAM | Join our (.gg/DYHUBGG)")

local placeId = tostring(game.PlaceId)
local gameName = allowedGames[placeId]

if not gameName then
    StarterGui:SetCore("SendNotification", {
        Title = "DYHUB",
        Text = "This script only works in allowed games!",
        Duration = 5
    })
    wait(2)
    player:Kick("!! This script is not supported in this game.\n !! Please run the script in a game that we support.\nJoin our (.gg/DYHUBGG)")
    return
end

local blur = Instance.new("BlurEffect")
blur.Size = 15
blur.Parent = game:GetService("Lighting")

local function createKeyGui()
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "DYHUB_KeyGui"
    keyGui.ResetOnSpawn = false
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keyGui.Parent = player:WaitForChild("PlayerGui")

    keyGui.Destroying:Connect(function()
        blur:Destroy()
    end)

    local bgOverlay = Instance.new("Frame")
    bgOverlay.Size = UDim2.new(1, 0, 1, 0)
    bgOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bgOverlay.BackgroundTransparency = 0.7
    bgOverlay.ZIndex = 1000
    bgOverlay.Parent = keyGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 210)
    frame.Position = UDim2.new(0.5, -175, 0.5, -105)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.ZIndex = 1001
    frame.Parent = keyGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.ZIndex = 1000
    shadow.Parent = frame

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "Access Key Required"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.RichText = true
    title.TextStrokeTransparency = 0.7
    title.ZIndex = 1002

    local subtitle = Instance.new("TextLabel")
    subtitle.Parent = frame
    subtitle.Size = UDim2.new(1, -40, 0, 30)
    subtitle.Position = UDim2.new(0, 20, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your access key below to continue"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 16
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.ZIndex = 1002

    local keyBox = Instance.new("TextBox")
    keyBox.Parent = frame
    keyBox.Size = UDim2.new(1, -40, 0, 40)
    keyBox.Position = UDim2.new(0, 20, 0, 80)
    keyBox.PlaceholderText = "Enter key here..."
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    keyBox.ClearTextOnFocus = false
    keyBox.Font = Enum.Font.GothamSemibold
    keyBox.TextSize = 20
    keyBox.ZIndex = 1002
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 15)

    local submitBtn = Instance.new("TextButton")
    submitBtn.Parent = frame
    submitBtn.Size = UDim2.new(1, -40, 0, 40)
    submitBtn.Position = UDim2.new(0, 20, 0, 122)
    submitBtn.Text = "Submit"
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 22
    submitBtn.ZIndex = 1002
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 15)

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Parent = frame
    getKeyBtn.Size = UDim2.new(1, -40, 0, 40)
    getKeyBtn.Position = UDim2.new(0, 20, 0, 165)
    getKeyBtn.Text = "Get Key"
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.TextSize = 18
    getKeyBtn.ZIndex = 1002
    Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 15)

    local TweenService = game:GetService("TweenService")
    local function clickTween(button)
        local goal = {BackgroundColor3 = button.BackgroundColor3:lerp(Color3.fromRGB(40,40,40), 0.5)}
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(button, tweenInfo, goal)
        tween:Play()
        tween.Completed:Wait()
        local tweenBack = TweenService:Create(button, tweenInfo, {BackgroundColor3 = button.BackgroundColor3})
        tweenBack:Play()
    end

    submitBtn.MouseButton1Click:Connect(function()
        clickTween(submitBtn)
        local enteredKey = keyBox.Text:lower():gsub("%s+", "")
        if enteredKey == VALID_KEY:lower() or enteredKey == dyhubonly then
            notify("Key Correct! | Loading Script...")
            keyGui:Destroy()
            blur.Size = 0

            local scriptURL
            if gameName:find("No%-Scope Arcade") then
                scriptURL = 'https://pastebin.com/raw/0xcSxSW4'
            else
                scriptURL = 'https://pastebin.com/raw/NeCbQB58'
            end

            loadstring(game:HttpGet(scriptURL))()
            notify("Game: " .. gameName .. " | Game has finished loading...")
        else
            notify("Key Incorrect! Please try again.")
            local flashGoal = {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}
            local normalGoal = {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}
            local flashTween = TweenService:Create(keyBox, TweenInfo.new(0.15), flashGoal)
            local normalTween = TweenService:Create(keyBox, TweenInfo.new(0.15), normalGoal)
            flashTween:Play()
            flashTween.Completed:Wait()
            normalTween:Play()
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        clickTween(getKeyBtn)
        pcall(function()
            setclipboard("https://pastebin.com/raw/iiQREtkr")
        end)
        notify("Link copied to clipboard!")
    end)

    return keyGui
end

local keyGui = player.PlayerGui:FindFirstChild("DYHUB_KeyGui") or createKeyGui()

player.CharacterAdded:Connect(function()
    wait(1)
    if keyGui and not keyGui.Enabled then
        keyGui.Enabled = true
    end
end)
