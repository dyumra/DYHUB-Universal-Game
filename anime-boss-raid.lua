-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Set Theme
WindUI:SetTheme("Dark")

-- Create Main Window
local Window = WindUI:CreateWindow({
    Title = "DYHUB (dsc.gg/dyhub)",
    Icon = "star",
    Author = "Fight Anime Bosses",
    Folder = "DYHUB",
    Size = UDim2.fromOffset(400, 360),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    Background = "",
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User button clicked")
        end,
    },
})

-- Open/Close Button
Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FFFFFF"),
        Color3.fromHex("000000")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Config Manager
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("AutoSettings")

task.spawn(function()
    task.wait(0.5)
    myConfig:Load()
    print("✅ Config loaded successfully")
end)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PackData = require(ReplicatedStorage.Modules.PackData)
local UnitData = require(ReplicatedStorage.Modules.UnitData)
local ReplicaClient = require(ReplicatedStorage.Modules.ReplicaClient)

-- Remotes
local AttemptSell = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("UnitService"):WaitForChild("RF"):WaitForChild("AttemptSell")
local SellArtifacts = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LootService"):WaitForChild("RF"):WaitForChild("SellArtifacts")

-- DataController Wait Function
local function waitForDataController()
    local controller = nil
    while not controller do
        pcall(function()
            controller = Knit.GetController("DataController")
        end)
        task.wait(0.2)
    end
    while not controller.Data do
        task.wait(0.2)
    end
    return controller
end

-- Buy Pack by Name
local function BuyPackByName(packName)
    local dataController = waitForDataController()
    local packsData = dataController.Data.Packs
    local stockTable = packsData.Stock
    local packService = Knit.GetService("PackService")
    local player = Knit.Player

    for packID, stockAmount in pairs(stockTable) do
        local info = PackData:GetInfoByID(tonumber(packID))
        if info and info.Name == packName then
            if stockAmount <= 0 then
                print("[DYHUB] Out of stock:", packName)
                return false
            end

            local price = PackData:GetPackPrice(player, info.Price)
            if not dataController:CanAffordGold(price) then
                print("[DYHUB] Cannot afford:", packName)
                return false
            end

            print(string.format("[DYHUB] Buying %s (ID %s) for %d", packName, packID, price))
            local result = packService:OpenPack(tonumber(packID), false)
            print("[DYHUB] Result:", result)
            return true
        end
    end

    print("[DYHUB] Pack not found:", packName)
    return false
end

-- Shop Tab
local ShopTab = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
})

-- Pack Dropdown
local selectedPacks = {}
local summonEnabled = false

local packDropdown = ShopTab:Dropdown({
    Title = "Select Packs",
    Values = {
        "Dragon Realm Pack",
        "Sorcerer Realm Pack",
        "Pirate Realm Pack",
        "Demon Realm Pack",
        "Hunter Realm Pack",
        "Shinobi Realm Pack"
    },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedPacks = selected
        myConfig:Save()
    end
})
myConfig:Register("packDropdown", packDropdown)

-- Summon Toggle
local summonToggle = ShopTab:Toggle({
    Title = "Auto Summon",
    Desc = "Automatically buy selected packs",
    Icon = "zap",
    Default = false,
    Callback = function(state)
        summonEnabled = state
        myConfig:Save()
    end
})
myConfig:Register("summonToggle", summonToggle)

-- Auto Buy Loop
task.spawn(function()
    while task.wait(1) do
        if summonEnabled and #selectedPacks > 0 then
            for _, packName in ipairs(selectedPacks) do
                BuyPackByName(packName)
            end
        end
    end
end)

-- Farm Tab
local FarmTab = Window:Tab({
    Title = "Farm",
    Icon = "shopping-bag",
})

local autoSellEnabled = false
local autoSellDelay = 10
local currentReplica = nil

ReplicaClient.OnNew("PlayerData", function(replica)
    currentReplica = replica
end)
ReplicaClient.RequestData()

-- Auto Sell Function
local function AutoSellAll(replica)
    local artifacts = replica.Data.Artifacts
    if not artifacts then return end

    local uuids = {}
    for _, artifactData in pairs(artifacts) do
        if artifactData.UID then
            table.insert(uuids, artifactData.UID)
        end
    end

    if #uuids > 0 then
        SellArtifacts:InvokeServer(uuids)
    end
end

-- Auto Sell Toggle
local autoSellToggle = FarmTab:Toggle({
    Title = "Auto Sell",
    Desc = "Automatically sell all artifacts",
    Icon = "refresh-cw",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        myConfig:Save()
    end
})
myConfig:Register("autoSellToggle", autoSellToggle)

-- Auto Sell Delay Input
local delayInput = FarmTab:Input({
    Title = "Delay",
    Desc = "Set delay between auto sell (seconds)",
    Value = tostring(autoSellDelay),
    InputIcon = "clock",
    Type = "Input",
    Placeholder = "10",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            autoSellDelay = math.floor(num)
        end
        myConfig:Save()
    end
})
myConfig:Register("delayInput", delayInput)

-- Auto Sell Loop
task.spawn(function()
    while task.wait(1) do
        if autoSellEnabled and currentReplica then
            AutoSellAll(currentReplica)
            task.wait(autoSellDelay)
        end
    end
end)

local CodesTab = Window:Tab({
    Title = "Codes",
    Icon = "bird",
})

-- AutoClean Tab
local CleanTab = Window:Tab({
    Title = "Auto Clean",
    Icon = "trash-2",
})

local rarityMap = { Rare = 1, Epic = 2, Legendary = 3, Mythic = 4, Secret = 5 }
local selectedRarities = {}
local autoCleanEnabled = false

local rarityDropdown = CleanTab:Dropdown({
    Title = "Select Rarity",
    Values = { "Rare", "Epic", "Legendary", "Mythic", "Secret" },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedRarities = selected
        myConfig:Save()
    end
})
myConfig:Register("rarityDropdown", rarityDropdown)

local autoCleanToggle = CleanTab:Toggle({
    Title = "Auto Clean",
    Desc = "Automatically sell units of selected rarity",
    Icon = "zap",
    Default = false,
    Callback = function(state)
        autoCleanEnabled = state
        myConfig:Save()
    end
})
myConfig:Register("autoCleanToggle", autoCleanToggle)

local function AutoCleanUnits()
    if #selectedRarities == 0 then return end
    local dataController = waitForDataController()
    local units = dataController.Data.Units
    if not units then return end

    local uidsToDelete = {}
    for _, unit in ipairs(units) do
        if unit.Locked or (unit.Equipped ~= false and unit.Equipped ~= nil) then continue end
        local baseInfo = UnitData:GetInfoByID(unit.ID)
        if baseInfo then
            for _, rarityName in ipairs(selectedRarities) do
                if baseInfo.Rarity == rarityMap[rarityName] then
                    table.insert(uidsToDelete, tostring(unit.UID))
                    print("[DYHUB] Cleaning Unit:", baseInfo.DisplayName, "Rarity:", rarityName, "UID:", unit.UID)
                end
            end
        end
    end

    if #uidsToDelete > 0 then
        AttemptSell:InvokeServer(uidsToDelete)
    end
end

task.spawn(function()
    while task.wait(5) do
        if autoCleanEnabled then
            AutoCleanUnits()
        end
    end
end)

-- AntiAFK Tab
local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "file-cog",
})

local antiAfkEnabled = false

local antiAfkToggle = MiscTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevent being flagged as AFK",
    Icon = "user-check",
    Default = false,
    Callback = function(state)
        antiAfkEnabled = state
        myConfig:Save()
        if state then
            print("[DYHUB] Anti-AFK enabled")
        else
            print("[DYHUB] Anti-AFK disabled")
        end
    end
})
myConfig:Register("antiAfkToggle", antiAfkToggle)

task.spawn(function()
    while task.wait(1) do
        if antiAfkEnabled then
            local delayTime = math.random(180, 300)
            task.wait(delayTime)
            if antiAfkEnabled then
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.Jump = true
                    print("[DYHUB] Jump executed to prevent AFK")
                end
            end
        else
            task.wait(5)
        end
    end
end)

local redeemCodes = {
    "160KLIKES",
    "DUNGEONS",
    "150KLIKES",
}

local selectedCodes = {}

CodesTab:Dropdown({
    Title = "Select Redeem Codes",
    Multi = true,
    Values = redeemCodes,
    Callback = function(value)
        selectedCodes = value or {}
    end,
})

CodesTab:Button({
    Title = "Redeem Selected Codes",
    Callback = function()
        for _, codeKey in ipairs(selectedCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CodeService"):WaitForChild("RF"):WaitForChild("Redeem"):InvokeServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

CodesTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        for _, codeKey in ipairs(redeemCodes) do
            local code = codeKey
            pcall(function()
                ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CodeService"):WaitForChild("RF"):WaitForChild("Redeem"):InvokeServer(code)
                task.wait(0.2)
            end)
        end
    end,
})

Window:SelectTab(1)