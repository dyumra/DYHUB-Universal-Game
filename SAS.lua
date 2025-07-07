local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
if not player then
    player = Players.PlayerAdded:Wait()
end

while true do
    task.wait(0.05)
    local bases = workspace:FindFirstChild("Bases")
    local remote = ReplicatedStorage.Events:FindFirstChild("AddWeaponToBase")

    for i = 1, 10 do
        remote:FireServer("Heavens Halberd")
    end

    for _, base in ipairs(bases:GetChildren()) do
        local title = base:FindFirstChild("Title")
        local nameGui = title:FindFirstChild("NameGui")
        local textLabel = nameGui:FindFirstChild("TextLabel")

        if textLabel.Text == player.DisplayName then
            for _, descendant in ipairs(base:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    descendant.HoldDuration = 0
                    descendant.MaxActivationDistance = 9999
                    fireproximityprompt(descendant)
                end
            end
        end
    end
end
