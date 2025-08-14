-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/133781619558477"))()

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "DYHUB - Steal a K-Pop Hunter", HidePremium = false, SaveConfig = true, ConfigFolder = "clock.lua.sakpdh"})
local StealTab = Window:MakeTab({
    Name = "Steal",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local BaseTab = Window:MakeTab({
    Name = "Base",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local CharTab = Window:MakeTab({
    Name = "Character",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Init --
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local bases = workspace.Map.Bases
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Char = LPlayer.Character
local HRP = Char.HumanoidRootPart

LPlayer.CharacterAdded:Connect(function(char)
    Char = LPlayer.Character
    HRP = Char.HumanoidRootPart
end)

-- Variables --
local SellAfter = true
local LockBool = true
local LockThread = nil
local CollectBool = false
local CollectThread = nil
local TrapsBool = true
local TrapsThread = nil
local NoClipRunning = nil
local anyStealRunning = false
local SpecificKPDH = "Rainbow Derpy Tiger"

if not getgenv().desiredWalkSpeed then
    getgenv().desiredWalkSpeed = 30

    RunService.Heartbeat:Connect(function()
        pcall(function()
            if LPlayer.Character and LPlayer.Character.Humanoid then
                LPlayer.Character.Humanoid.WalkSpeed = getgenv().desiredWalkSpeed
            end
        end)
    end)
end

if not getgenv().lolxdteleportyes then
    getgenv().lolxdteleportyes = true

    LPlayer.OnTeleport:Connect(function()
        if queue_on_teleport then
            queue_on_teleport("task.wait(1.5) loadstring(game:HttpGet('https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/133781619558477'))()")
        end
    end)
end

-- Functions --
local function getBase(playername)
    local result

    if Players:FindFirstChild(playername) then
        for _, base in ipairs(bases:GetChildren()) do
            local signtext = base.Important.Sign.SignPart.SurfaceGui.TextLabel.Text
            if string.find(signtext, playername, 1, true) then
                result = base.Name
                break
            end
        end
    end

    return result
end

local function getAllShits(basenumber)
    local shitstable = {}

    for _, chars in ipairs(workspace.Map.Bases[basenumber].Important.NPCPads:GetChildren()) do
        local charModel = chars:FindFirstChild("Character")
        if charModel and charModel:FindFirstChild("Head") then
            local attach = charModel.Head:FindFirstChild("OverHeadAttachment")
            if attach and attach:FindFirstChild("CharacterInfo") then
                local frame = attach.CharacterInfo:FindFirstChild("Frame")
                if frame and frame:FindFirstChild("UnitName") and frame:FindFirstChild("Price") then
                    table.insert(shitstable, {
                        object = chars,
                        name = frame.UnitName.Text,
                        price = frame.Price.Text
                    })
                end
            end
        end
    end

    return shitstable
end

local function stealFunction(shits, ownbase, stolecount)
    local shitcollect = shits.object.Collect

    repeat
        HRP.CFrame = CFrame.new(shitcollect.Position + Vector3.new(0, 3, 0))
        task.wait()
        if shits.object:FindFirstChild("Character") and not shits.object.Part:FindFirstChild("ProximityPrompt") then
            fireproximityprompt(shits.object.Character.HumanoidRootPart:WaitForChild("SlotPrompt"))
        end
    until shits.object.Part:FindFirstChild("ProximityPrompt") or not shits.object:FindFirstChild("Character")

    HRP.CFrame = bases[ownbase].Important.RobberyDeposit.CFrame
    stolecount = stolecount + 1
    return stolecount
end

local function stealSearchShit(shitsname)
    local ownbase = getBase(LPlayer.Name)
    local stolecount = 0

    for _, fplayers in pairs(Players:GetChildren()) do
        if fplayers ~= LPlayer then
            local currenttarget = getBase(fplayers.Name)
            if currenttarget then
                for _, shits in pairs(getAllShits(currenttarget)) do
                    if shits.name == shitsname then
                        stolecount = stealFunction(shits, ownbase, stolecount)
                        task.wait(0.1)
                    end
                end
            end
        end
    end

    return stolecount > 0, stolecount
end

local function stealAllShits(playername)
    local target = getBase(playername)
    local ownbase = getBase(LPlayer.Name)

    if target then
        for _, shits in getAllShits(target) do
            if Players:FindFirstChild(playername) then
                stealFunction(shits, ownbase, 0)
                task.wait(0.1)
            else
                continue
            end
        end
    end
end

local function sellAllPlayerShits()
    for _, shits in pairs(getAllShits(getBase(LPlayer.Name))) do
        local shitcollect = shits.object.Collect

        repeat
            task.wait()
            HRP.CFrame = CFrame.new(shitcollect.Position + Vector3.new(0, 3, 0))
            if shits.object:FindFirstChild("Character") and shits.object.Character.HumanoidRootPart:FindFirstChild("SlotPrompt") and not shits.object.Part:FindFirstChild("ProximityPrompt") then
                fireproximityprompt(shits.object.Character.HumanoidRootPart.SlotPrompt)
            end
        until not shits.object:FindFirstChild("Character") or shits.object.Part:FindFirstChild("ProximityPrompt")
    end
end

local function lockBase()
    while LockBool do task.wait()
        local playerbase = workspace.Map.Bases[getBase(LPlayer.Name)]
        local lockbutton = playerbase.Important.LockButton
        if lockbutton.BillboardAttachment.LockGui.ActionLabel.Visible then
            firetouchinterest(lockbutton,HRP,0)
            task.wait(0.05)
            firetouchinterest(lockbutton,HRP,1)
        end
    end
end

local function stealAll()
    for _, players in pairs(Players:GetChildren()) do
        if players.Name ~= LPlayer.Name then
            stealAllShits(players.Name)
            if SellAfter then
                sellAllPlayerShits()
            end
        end
    end
end

local function DisableTraps()
    while TrapsBool do
        for _, traps in workspace:GetChildren() do task.wait()
            if traps.Name == "Trap" then
                traps.HitBox.TouchInterest:Destroy()
                traps.Name = "TrapL"
            end
        end
    end
end

local function autoCollectCash()
    while CollectBool do
        for _, npcpad in pairs(workspace.Map.Bases[getBase(LPlayer.Name)].Important.NPCPads:GetChildren()) do task.wait()
            firetouchinterest(npcpad.Collect,HRP,0)
            task.wait(0.05)
            firetouchinterest(npcpad.Collect,HRP,1)
        end
    end
end

local function addSpacesToName(name)
    if not name or name == "" then
        return name
    end
    local result = ""
    for i = 1, #name do
        local char = name:sub(i, i)
        if i > 1 and char:match("%u") then
            result = result .. " "
        end
        result = result .. char
    end
    return result
end

local function getKPDH()
    local kpdhtable = {}

    for _, kpdh in pairs(ReplicatedStorage.Assets.Characters:GetChildren()) do
        table.insert(kpdhtable, addSpacesToName(kpdh.Name))
    end

    table.sort(kpdhtable)
    return kpdhtable
end

-- Tab Elements --

-- StealTab --
StealTab:AddButton({Name = "Steal All KPDH", Callback = function()
    if not anyStealRunning then
        anyStealRunning = true
        stealAll()
        anyStealRunning = false
    else
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "Wait until the previous steal is finished.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end})

StealTab:AddToggle({Name = "Sell After Stealing All",  Default = true,  Callback = function(bool)
    if bool then
        SellAfter = true
        OrionLib:MakeNotification({
            Name = "DYUUB",
            Content = "You will sell characters after stealing now.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        SellAfter = false
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "You won't sell characters after stealing now.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end})

StealTab:AddDropdown({Name = "Select KPDH", Default = "Rainbow Derpy Tiger", Options = getKPDH(), Callback = function(Value)
	SpecificKPDH = Value
end })

StealTab:AddButton({Name = "Steal Specific KPDH ^", Callback = function()
    if not anyStealRunning then
        anyStealRunning = true
        local feedback, stolecount = stealSearchShit(SpecificKPDH)
        if feedback then
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "Stolen "..stolecount.." of "..SpecificKPDH,
                Image = "rbxassetid://4483345998",
                Time = 3
            }) 
        else
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "No "..SpecificKPDH.." Found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })   
        end
        anyStealRunning = false
    else
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "Wait until the previous steal is finished.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end})

-- BaseTab --
BaseTab:AddButton({Name = "Sell All KPDH", Callback = function()
    sellAllPlayerShits()
end})

BaseTab:AddToggle({Name = "Auto Lock Base",  Default = true,  Callback = function(bool)
    LockBool = bool
    if LockBool then
        LockThread = task.spawn(lockBase)
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "Auto Locking is now enabled.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if LockThread then
            task.cancel(LockThread)
            LockThread = nil
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "Auto Locking is now disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

BaseTab:AddToggle({Name = "Auto Collect Cash",  Default = false,  Callback = function(bool)
    CollectBool = bool
    if CollectBool then
        CollectThread = task.spawn(autoCollectCash)
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "Auto Collect Cash is now enabled.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if CollectThread then
            task.cancel(CollectThread)
            CollectThread = nil
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "Auto Collect Cash is now disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

BaseTab:AddToggle({Name = "Auto Disable Traps",  Default = true,  Callback = function(bool)
    TrapsBool = bool
    if TrapsBool then
        TrapsThread = task.spawn(DisableTraps)
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "Auto Disable Traps is now enabled.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if TrapsThread then
            task.cancel(TrapsThread)
            TrapsThread = nil
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "Auto Disable Traps is now disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

-- CharTab --
CharTab:AddSlider({Name = "WalkSpeed", Min = 16, Max = 200, Default = 30, Color = Color3.fromRGB(255,255,255), Increment = 1, Callback = function(Value)
    getgenv().desiredWalkSpeed = Value
end})

CharTab:AddToggle({Name = "No Clip",  Default = false,  Callback = function(bool)
    if bool then
        local function NoclipLoop()
            if LPlayer.Character ~= nil then
                for _, child in pairs(LPlayer.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                    end
                end
            end
        end
        NoClipRunning = RunService.Stepped:Connect(NoclipLoop)
        OrionLib:MakeNotification({
            Name = "DYHUB",
            Content = "No Clip Enabled",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    else
        if NoClipRunning then
            NoClipRunning:Disconnect()
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "No Clip Disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end})

-- MiscTab --
MiscTab:AddLabel("Made with <3 by tokkendev")

MiscTab:AddToggle({Name = "Instant Proximity Prompt",  Default = false,  Callback = function(bool)
    if bool then
        if fireproximityprompt then
            PromptButtonHoldBegan = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
        else
            OrionLib:MakeNotification({
                Name = "DYHUB",
                Content = "Your exploit is incompatible with fireproximityprompt.",
                Image = "rbxassetid://4483345998",
                Time = 6
            })
        end
    else
        if PromptButtonHoldBegan then
            PromptButtonHoldBegan:Disconnect()
            PromptButtonHoldBegan = nil
        end
    end
end})

MiscTab:AddButton({Name = "Remove Fog", Callback = function()
	Lighting.FogEnd = 10000
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
end})

MiscTab:AddButton({Name = "Server Hop", Callback = function()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    local body = HttpService:JSONDecode(req)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    end
end})

OrionLib:Init()
