local DYHUB_1_Players = game:GetService("Players")
local DYHUB_1_ReplicatedStorage = game:GetService("ReplicatedStorage")

local DYHUB_1_LocalPlayer = DYHUB_1_Players.LocalPlayer

if DYHUB_1_LocalPlayer.Name ~= "Yolmar_43" then
    DYHUB_1_LocalPlayer:Kick("This script is purchased from (dsc.gg/dyhub)")
    return
end

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
