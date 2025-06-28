local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local VALID_KEY = "DYHUBTHEBEST"

-- ===== Notify =====
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

notify("🛡️ DYHUB'S TEAM\nJoin our (.gg/DYHUBGG)")

-- ===== Loading Menu =====
local loadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
loadingGui.Name = "LoadingMenu"
loadingGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame")
loadingFrame.Parent = loadingGui
loadingFrame.Size = UDim2.new(0, 320, 0, 180)
loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
loadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0

Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", loadingFrame).Thickness = 2

local loadingTitle = Instance.new("TextLabel", loadingFrame)
loadingTitle.Size = UDim2.new(1, 0, 0, 50)
loadingTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingTitle.BackgroundTransparency = 0.5
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextSize = 22
loadingTitle.Text = "🛡 DYHUB'S\n Loading..."
Instance.new("UICorner", loadingTitle).CornerRadius = UDim.new(0, 15)

local spinner = Instance.new("ImageLabel", loadingFrame)
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

wait(2) -- รอโหลด

loadingGui:Destroy()

-- ===== Key Menu =====
local keyGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
keyGui.Name = "KeyMenu"
keyGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame")
keyFrame.Parent = keyGui
keyFrame.Size = UDim2.new(0, 320, 0, 220)
keyFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyFrame.BackgroundTransparency = 0.2
keyFrame.BorderSizePixel = 0

Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", keyFrame).Thickness = 2

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1, 0, 0, 50)
keyTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.BackgroundTransparency = 0.5
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 22
keyTitle.Text = "🔑 DYHUB KEY"
Instance.new("UICorner", keyTitle).CornerRadius = UDim.new(0, 15)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0, 70)
keyBox.PlaceholderText = "Enter Key Here..."
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 18
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 10)

local submitBtn = Instance.new("TextButton", keyFrame)
submitBtn.Size = UDim2.new(0.8, 0, 0, 40)
submitBtn.Position = UDim2.new(0.1, 0, 0, 130)
submitBtn.Text = "Submit Key"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 18
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 10)

local dyhubonly = "dev"

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY or keyBox.Text == dyhubonly then
        notify("✅ Key Correct! Loading Script...")
        keyGui:Destroy()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/Main-Script.lua'))()
    else
        notify("❌ Key Incorrect!")
    end
end)
