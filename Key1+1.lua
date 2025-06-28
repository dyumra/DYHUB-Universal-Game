local allowedGames = {
    ["286090429"] = true, -- Arsenal
    ["14940775218"] = true, -- No-Scope Arcade
}

local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local VALID_KEY = "DYHUBTHEBEST"
local dyhubonly = "dev"

local placeId = tostring(game.PlaceId)
if not allowedGames[placeId] then
    StarterGui:SetCore("SendNotification", {
        Title = "DYHUB",
        Text = "❌ This script only works in allowed games!",
        Duration = 5
    })
    wait(2)
    player:Kick("⚠️ This script is not supported in this game.\n‼️ Please run the script in a game that we support.\n📊 Join our (.gg/DYHUBGG)")
    return
end

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "DYHUB_KeyGui"
keyGui.ResetOnSpawn = false
keyGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = keyGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔑 Enter Your Key"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local keyBox = Instance.new("TextBox")
keyBox.Parent = frame
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 50)
keyBox.PlaceholderText = "Enter key here..."
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 12)
keyBox.ClearTextOnFocus = false

local submitBtn = Instance.new("TextButton")
submitBtn.Parent = frame
submitBtn.Size = UDim2.new(1, -20, 0, 40)
submitBtn.Position = UDim2.new(0, 10, 0, 100)
submitBtn.Text = "Submit"
submitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
submitBtn.TextColor3 = Color3.new(1,1,1)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextScaled = true
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 12)

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

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY or keyBox.Text == dyhubonly then
        notify("✅ Key Correct! | Loading Script...")
        keyGui:Destroy()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/Main-Script.lua'))()
        notify("🎮 Game: " .. placeId .. " | Game has finished loading...")
    else
        notify("❌ Key Incorrect!")
    end
end)
