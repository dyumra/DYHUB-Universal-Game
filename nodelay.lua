local function modifyProximityPrompts()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end
end

modifyProximityPrompts()
