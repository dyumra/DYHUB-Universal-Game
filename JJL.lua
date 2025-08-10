if getgenv().DYHUBTHEBEST ~= "Join our (dsc.gg/dyhub)" then
    game.Players.LocalPlayer:Kick("Delete Credit?")
    return
end

local plr = game:GetService("Players").LocalPlayer

game:GetService("ReplicatedStorage"):WaitForChild("SetTechnique"):FireServer(
    getgenv().DYHUBTECHNIQUEOLD or "None",
    getgenv().DYHUBTECHNIQUE,
    1,
    0.001
)

game:GetService("ReplicatedStorage"):WaitForChild("SetClan"):FireServer(
    getgenv().DYHUBCLANOLD or "None",
    getgenv().DYHUBCLAN,
    1,
    0.001
)

game:GetService("ReplicatedStorage"):WaitForChild("SetRace"):FireServer(
    getgenv().DYHUBRACEOLD or "None",
    getgenv().DYHUBRACE,
    1,
    0.001
)

local traitVal = plr:FindFirstChild("Trait")
if not traitVal then
    traitVal = Instance.new("StringValue")
    traitVal.Name = "Trait"
    traitVal.Parent = plr
end
traitVal.Value = getgenv().DYHUBTRAIT

if getgenv().DYHUBGAMEPASS == true then
    local gpFolder = plr:FindFirstChild("OwnedGamepassFolder")
    if not gpFolder then
        gpFolder = Instance.new("Folder")
        gpFolder.Name = "OwnedGamepassFolder"
        gpFolder.Parent = plr
    end

    local gamepasses = {
        "Owned+10 Technique Storage",
        "Owned2x Drop",
        "Owned2x Mastery",
        "Owned2x Yen And Exp",
        "OwnedAuto Quest",
        "OwnedInfinite Spins",
        "OwnedInstant Spin"
    }

    for _, name in ipairs(gamepasses) do
        local val = gpFolder:FindFirstChild(name)
        if val then
            val.Value = true
        end
    end
end
