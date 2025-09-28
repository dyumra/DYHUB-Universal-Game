-- =========================
local version = "1.2.9"
-- =========================

repeat task.wait() until game:IsLoaded()

if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Jujutsu Legacy | Free Version",
    Folder = "DYHUB_JJL",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
    Window:Tag({
        Title = version,
        Color = Color3.fromHex("#30ff6a")
    })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local Gamepass = Window:Tab({ Title = "Gamepass", Icon = "star" })
Window:SelectTab(1)

-- ====================== DATA ======================
local shop = {
    raceList = { "Human", "Death Paiting", "Cursed Spirit", "Angel", "Fallen Angel" },
    techniqueList = { "Ratio", "Blood Manipulation", "Disaster Flames", "Divergent Fist", "Disaster Tides", "Cursed Speech", "Boogie Woogie", "Star Rage", "Sound Amplification", "Blast Energy", "Moon Dregs", "Straw Doll", "Jackpot", "Infinity", "Idle Transfiguration", "Deadly Sentencing", "Projection", "Ice Formation", "Comedian", "Anti Gravity", "Ten Shadows", "Heavenly Restriction", "Rika", "Curse Manipulation" },
    clanList = { "Itadori", "Todo", "Nanami", "Geto", "Kamo", "Zenin", "Okkotsu", "Fushiguro", "Gojo", "Rejected Zenin", "Ryomen" },
    traitList = { "Soon" },
}

local selectedRace, selectedTechnique, selectedClan, selectedTrait
local selectedGamepasses = {}

getgenv().DYHUBGAMEPASS = false

-- ====================== RACE ======================
Main:Section({ Title = "Race", Icon = "rabbit" })

Main:Dropdown({
    Title = "Select Race",
    Values = shop.raceList,
    Multi = false,
    Callback = function(value)
        selectedRace = value
    end
})

Main:Button({
    Title = "Dupe Race",
    Callback = function()
        if selectedRace then
            game:GetService("ReplicatedStorage"):WaitForChild("SetRace"):FireServer(
                getgenv().DYHUBRACEOLD or "None",
                selectedRace,
                1,
                0.001
            )
            print("[DYHUB] Race duped:", selectedRace)
        else
            print("[DYHUB] Please select a race first!")
        end
    end,
})

-- ====================== TECHNIQUE ======================
Main:Section({ Title = "Technique", Icon = "cpu" })
Main:Dropdown({
    Title = "Select Technique",
    Values = shop.techniqueList,
    Multi = false,
    Callback = function(value)
        selectedTechnique = value
    end
})

Main:Button({
    Title = "Dupe Technique",
    Callback = function()
        if selectedTechnique then
            game:GetService("ReplicatedStorage"):WaitForChild("SetTechnique"):FireServer(
                getgenv().DYHUBTECHNIQUEOLD or "None",
                selectedTechnique,
                1,
                0.001
            )
            print("[DYHUB] Technique duped:", selectedTechnique)
        else
            print("[DYHUB] Please select a technique first!")
        end
    end,
})

-- ====================== CLAN ======================
Main:Section({ Title = "Clan", Icon = "shield" })
Main:Dropdown({
    Title = "Select Clan",
    Values = shop.clanList,
    Multi = false,
    Callback = function(value)
        selectedClan = value
    end
})

Main:Button({
    Title = "Dupe Clan",
    Callback = function()
        if selectedClan then
            game:GetService("ReplicatedStorage"):WaitForChild("SetClan"):FireServer(
                getgenv().DYHUBCLANOLD or "None",
                selectedClan,
                1,
                0.001
            )
            print("[DYHUB] Clan duped:", selectedClan)
        else
            print("[DYHUB] Please select a clan first!")
        end
    end,
})

-- ====================== TRAIT ======================
Main:Section({ Title = "Trait", Icon = "gem" })
Main:Dropdown({
    Title = "Select Trait",
    Values = shop.traitList,
    Multi = false,
    Callback = function(value)
        selectedTrait = value
    end
})

Main:Button({
    Title = "Dupe Trait",
    Callback = function()
        if selectedTrait then
            local plr = game:GetService("Players").LocalPlayer
            local traitVal = plr:FindFirstChild("Trait")
            if not traitVal then
                traitVal = Instance.new("StringValue")
                traitVal.Name = "Trait"
                traitVal.Parent = plr
            end
            traitVal.Value = selectedTrait
            print("[DYHUB] Trait duped:", selectedTrait)
        else
            print("[DYHUB] Please select a trait first!")
        end
    end,
})

-- ====================== GAMEPASS ======================
Gamepass:Section({ Title = "Gamepass", Icon = "star" })
local gamepassList = {
    "Owned+10 Technique Storage",
    "Owned2x Drop",
    "Owned2x Mastery",
    "Owned2x Yen And Exp",
    "OwnedAuto Quest",
    "OwnedInfinite Spins",
    "OwnedInstant Spin"
}

Gamepass:Dropdown({
    Title = "Select Gamepasses",
    Values = gamepassList,
    Multi = true,
    Callback = function(values)
        selectedGamepasses = values
    end
})

Gamepass:Toggle({
    Title = "Unlocked Gamepass",
    Default = false,
    Callback = function(state)
        getgenv().DYHUBGAMEPASS = state
        local plr = game:GetService("Players").LocalPlayer
        local gpFolder = plr:FindFirstChild("OwnedGamepassFolder")

        if not gpFolder then
            gpFolder = Instance.new("Folder")
            gpFolder.Name = "OwnedGamepassFolder"
            gpFolder.Parent = plr
        end

        for _, name in ipairs(gamepassList) do
            local val = gpFolder:FindFirstChild(name)
            if not val then
                val = Instance.new("BoolValue")
                val.Name = name
                val.Parent = gpFolder
            end
            val.Value = table.find(selectedGamepasses, name) ~= nil and state or false
        end

        print("[DYHUB] Gamepass:", state, "| Selected:", table.concat(selectedGamepasses, ", "))
    end
})
