local DYHUB_1_Players = game:GetService("Players")
local DYHUB_1_ReplicatedStorage = game:GetService("ReplicatedStorage")

local DYHUB_1_LocalPlayer = DYHUB_1_Players.LocalPlayer
local PlayerGui = DYHUB_1_LocalPlayer:WaitForChild("PlayerGui")

task.delay(10, function()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiCheatWarning"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, 0, 1, 0)
    message.BackgroundTransparency = 1
    message.Text = "Detected Cheater"
    message.TextColor3 = Color3.new(1, 0, 0)
    message.TextScaled = true
    message.Font = Enum.Font.SourceSansBold
    message.TextStrokeColor3 = Color3.new(0, 0, 0)
    message.TextStrokeTransparency = 0.5
    message.TextWrapped = true
    message.Parent = screenGui
    message.AnchorPoint = Vector2.new(0.5, 0.5)
    message.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

task.delay(17, function()
    DYHUB_1_LocalPlayer:Kick("You have been detected by the Anti-Cheat system. Please refrain from such actions in the future. Failure to comply will result in a permanent ban.")
end)

local DYHUB_1_UnlockData = DYHUB_1_LocalPlayer:WaitForChild("UnlockData")
local DYHUB_1_PlayableCharacter = DYHUB_1_ReplicatedStorage:WaitForChild("PlayableCharacter")

local function DYHUB_1_Create(name)
    if not DYHUB_1_UnlockData:FindFirstChild(name) then
        local DYHUB_1_String = Instance.new("StringValue")
        DYHUB_1_String.Name = name
        DYHUB_1_String.Value = ""
        DYHUB_1_String.Parent = DYHUB_1_UnlockData
    end
end

local function DYHUB_1_Remove(name)
    local DYHUB_1_Existing = DYHUB_1_UnlockData:FindFirstChild(name)
    if DYHUB_1_Existing then
        DYHUB_1_Existing:Destroy()
    end
end

for _, DYHUB_1_Obj in ipairs(DYHUB_1_PlayableCharacter:GetChildren()) do
    DYHUB_1_Create(DYHUB_1_Obj.Name)
end

DYHUB_1_PlayableCharacter.ChildAdded:Connect(function(DYHUB_1_Child)
    DYHUB_1_Create(DYHUB_1_Child.Name)
end)

DYHUB_1_PlayableCharacter.ChildRemoved:Connect(function(DYHUB_1_Child)
    DYHUB_1_Remove(DYHUB_1_Child.Name)
end)

