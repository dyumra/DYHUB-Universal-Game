-- ตรวจเครดิตก่อนทำงาน
if getgenv().DYHUBTHEBEST ~= "Join our (dsc.gg/dyhub)" then
    game.Players.LocalPlayer:Kick("Delete Credit?")
    return
end

local plr = game:GetService("Players").LocalPlayer

-- Apply Technique
game:GetService("ReplicatedStorage"):WaitForChild("SetTechnique"):FireServer(
    getgenv().DYHUBTECHNIQUEOLD or "None",
    getgenv().DYHUBTECHNIQUE,
    1,
    0.001
)

-- Apply Clan
game:GetService("ReplicatedStorage"):WaitForChild("SetClan"):FireServer(
    getgenv().DYHUBCLANOLD or "None",
    getgenv().DYHUBCLAN,
    1,
    0.001
)

-- Apply Race
game:GetService("ReplicatedStorage"):WaitForChild("SetRace"):FireServer(
    getgenv().DYHUBRACEOLD or "None",
    getgenv().DYHUBRACE,
    1,
    0.001
)

-- Create Trait StringValue
local traitVal = plr:FindFirstChild("Trait")
if not traitVal then
    traitVal = Instance.new("StringValue")
    traitVal.Name = "Trait"
    traitVal.Parent = plr
end
traitVal.Value = getgenv().DYHUBTRAIT

-- Create Gamepass Folder & BoolValues
if getgenv().DYHUBGAMEPASS == true then
    local gpFolder = plr:FindFirstChild("OwnedGamepassFolder")
    if not gpFolder then
        gpFolder = Instance.new("Folder")
        gpFolder.Name = "OwnedGamepassFolder"
        gpFolder.Parent = plr
    end

    local gamepasses = {
        "10 Technique Storage",
        "2x Drop",
        "2x Mastery",
        "2x Yen And Exp",
        "Auto Quest",
        "Infinite Spins",
        "Instant Spin"
    }

    for _, name in ipairs(gamepasses) do
        local val = gpFolder:FindFirstChild("Owned" .. name:gsub(" ", "")) or Instance.new("BoolValue")
        val.Name = "Owned" .. name:gsub(" ", "")
        val.Value = true
        val.Parent = gpFolder
    end
end
