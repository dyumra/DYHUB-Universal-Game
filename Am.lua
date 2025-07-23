repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService") -- Added TweenService for Abssy Miner features

local WindUI = nil
local success, errorMessage = pcall(function()
    local scriptContent = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    if scriptContent and scriptContent ~= "" then
        WindUI = loadstring(scriptContent)()
    else
        error("Failed to retrieve WindUI script content.")
    end
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. (errorMessage or "Unknown error"))
    game.StarterGui:SetCore("SendNotification", {
        Title = "DYHUB Error",
        Text = "The script does not support your executor!",
        Duration = 10,
        Button1 = "OK"
    })
    return
end

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Abssy Miner (Version: 1.0)",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})

repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - Abssy Miner",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

---
-- Abssy Miner Features Integrated into WindUI
---

local player = Players.LocalPlayer

local remoteHitBox = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("HitBox")
local remoteSell = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory")
local remoteBuyItem = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("BuyItem")
local remoteRankUpGui = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUpGui") -- Added remote for RankUp

local function getHRP()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:WaitForChild("HumanoidRootPart")
end

local pickaxes = {
    {damage = 10, name = "Rusty Pickaxe", multiplier = 1, hitboxType = "Standard"},
    {damage = 10, name = "Iron Pickaxe", multiplier = 1, hitboxType = "Standard"},
    {damage = 5, name = "Lead Pickaxe", multiplier = 1, hitboxType = "Standard"},
    {damage = 13, name = "Silver Pickaxe", multiplier = 0.85, hitboxType = "Standard"},
    {damage = 20, name = "Xplr. Pickaxe", multiplier = 0.85, hitboxType = "Standard"},
    {damage = 30, name = "Xplr. Pickaxe Tier-2", multiplier = 0.85, hitboxType = "Standard"},
    {damage = 45, name = "Heavy Pickaxe", multiplier = 1.3, hitboxType = "Heavy"},
    {damage = 100, name = "MXplr. Pickaxe", multiplier = 0.85, hitboxType = "Standard"},
    {damage = 150, name = "Heavy Pickaxe Tier-2", multiplier = 1.2, hitboxType = "Heavy"},
    {damage = 450, "Chasm Smasher", multiplier = 1.2, hitboxType = "Heavy"},
    {damage = 90, "[Relic]Spiral Drill of Abyss", multiplier = 0.2, hitboxType = "Drill"},
}

local additionalPickaxes = {
	"Black Steel Shovel",
	"Chasm Smasher",
	"Core Breaker",
	"Cragsplitter",
	"Drill Lance",
	"Drill Lance Tier-2",
	"Heavy Pickaxe Tier-2",
	"MXplr.Pickaxe",
	"MXplr.Pickaxe Tier-2",
	"PopperPickaxe",
	"[Relic]Spiral Drill of Abyss",
}

local pickaxeNameSet = {}
for _, p in ipairs(pickaxes) do
	pickaxeNameSet[p.name] = true
end

for _, name in ipairs(additionalPickaxes) do
	if not pickaxeNameSet[name] then
		table.insert(pickaxes, {name = name})
		pickaxeNameSet[name] = true
	end
end

local autoHitBoxEnabled = false
local autoSellEnabled = false
local autoLayer1Enabled = false
local autoTeleportEnabled = false -- For Cave2Stone
local autoMagmaEnabled = false
local autoHeatedMagmaEnabled = false
local autoQuartzStoneEnabled = false
local autoRemoveDeadPartsEnabled = false
local slowFallEnabled = false
local slowFallFactor = 0.15

local slowFallConnection

local function safeTeleportToPosition(hrp, targetCFrame)
	if not hrp or not targetCFrame then return end
	local distance = (hrp.Position - targetCFrame.Position).Magnitude
	local duration = math.clamp(distance / 50, 0.5, 3)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

local function autoHitBox()
	while autoHitBoxEnabled do
		task.wait(0.1)
		for _, pickaxe in ipairs(pickaxes) do
			if pickaxe.damage then
				local args = {
					pickaxe.damage,
					pickaxe.hitboxType or "Standard",
					false,
					pickaxe.name,
					pickaxe.multiplier
				}
				remoteHitBox:FireServer(unpack(args))
			end
		end
	end
end

local function autoSellInventory()
	while autoSellEnabled do
		task.wait(1)
		local npc = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Layer 1") and workspace.Map["Layer 1"]:FindFirstChild("Npcs") and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer")
		if npc then
			local rei = npc:FindFirstChild("Rei")
			if rei and rei:FindFirstChild("HumanoidRootPart") and rei.HumanoidRootPart:FindFirstChild("Dialogue") then
				local args = {rei, rei.HumanoidRootPart.Dialogue}
				pcall(function() remoteSell:FireServer(unpack(args)) end)
			end
		end
	end
end

local function autoTeleportLayer1()
	local hrp = getHRP()
	local layer = workspace:WaitForChild("Map"):WaitForChild("Layer 1")

	for _, model in ipairs(layer:GetChildren()) do
		local amountFolder = model:FindFirstChild("Amount")
		if amountFolder then
			for _, descendant in ipairs(amountFolder:GetDescendants()) do
				if not autoLayer1Enabled then return end
				if descendant:IsA("BasePart") then
					safeTeleportToPosition(hrp, descendant.CFrame + Vector3.new(0, 5, 0))
					task.wait(0.75)
				end
			end
		end
	end
end

local function teleportToAllNestedParts() -- For Cave2Stone
	local hrp = getHRP()
	if not hrp then return end

	local cave2Stone = workspace:FindFirstChild("OreArea") and workspace.OreArea:FindFirstChild("Cave2Stone")
	if not cave2Stone then return end

	for _, stoneArea in ipairs(cave2Stone:GetChildren()) do
		local amountFolder = stoneArea:FindFirstChild("Amount")
		if amountFolder then
			local function recurse(part)
				for _, c in ipairs(part:GetChildren()) do
					if not autoTeleportEnabled then return end
					if c:IsA("BasePart") then
						safeTeleportToPosition(hrp, c.CFrame + Vector3.new(0, 5, 0))
						task.wait(0.75)
					elseif #c:GetChildren() > 0 then
						recurse(c)
					end
				end
			end
			recurse(amountFolder)
		end
	end
end

local function autoTeleportStones() -- For Cave2Stone
	while autoTeleportEnabled do
		task.wait()
		teleportToAllNestedParts()
	end
end

local function autoTeleportQuartzStone()
	while autoQuartzStoneEnabled do
		local hrp = getHRP()
		local stoneArea = workspace:FindFirstChild("OreArea")
			and workspace.OreArea:FindFirstChild("Quartz-Cave")
			and workspace.OreArea["Quartz-Cave"]:FindFirstChild("StoneArea-Layer1")

		local amountFolder = stoneArea and stoneArea:FindFirstChild("Amount")
		if amountFolder then
			local function recurse(part)
				for _, c in ipairs(part:GetChildren()) do
					if not autoQuartzStoneEnabled then return end
					if c:IsA("BasePart") then
						safeTeleportToPosition(hrp, c.CFrame + Vector3.new(0, 5, 0))
						task.wait(0.8)
					elseif #c:GetChildren() > 0 then
						recurse(c)
					end
				end
			end
			recurse(amountFolder)
		end
		task.wait(1)
	end
end

local function autoTeleportMagma()
	local hrp = getHRP()
	local magmaRoot = workspace:FindFirstChild("OreArea") and workspace.OreArea:FindFirstChild("MagmaRock")
	if not magmaRoot then return end

	while autoMagmaEnabled do
		for _, magmaChild in ipairs(magmaRoot:GetChildren()) do
			local amountFolder = magmaChild:FindFirstChild("Amount")
			if amountFolder then
				local function recurse(part)
					for _, c in ipairs(part:GetChildren()) do
						if not autoMagmaEnabled then return end
						if c:IsA("BasePart") then
							safeTeleportToPosition(hrp, c.CFrame + Vector3.new(0, 5, 0))
							task.wait(0.75)
						elseif #c:GetChildren() > 0 then
							recurse(c)
						end
					end
				end
				recurse(amountFolder)
			end
		end
		task.wait(1)
	end
end

local function autoTeleportHeatedMagma()
	local hrp = getHRP()
	local heatedMagmaRoot = workspace:FindFirstChild("OreArea")
		and workspace.OreArea:FindFirstChild("Obsidian")
		and workspace.OreArea.Obsidian:FindFirstChild("HeatedMagmaRock")
	if not heatedMagmaRoot then return end

	local amountFolder = heatedMagmaRoot:FindFirstChild("Amount")
	if not amountFolder then return end

	while autoHeatedMagmaEnabled do
		local function recurse(part)
			for _, c in ipairs(part:GetChildren()) do
				if not autoHeatedMagmaEnabled then return end
				if c:IsA("BasePart") then
					safeTeleportToPosition(hrp, c.CFrame + Vector3.new(0, 5, 0))
					task.wait(0.75)
				elseif #c:GetChildren() > 0 then
					recurse(c)
				end
			end
		end
		recurse(amountFolder)
		task.wait(1)
	end
end

local function autoRemoveDeadParts()
	while autoRemoveDeadPartsEnabled do
		task.wait(3) -- every 3 seconds
		local deadPartParent = workspace:FindFirstChild("MapDeadPart")
		if deadPartParent then
			for _, child in ipairs(deadPartParent:GetChildren()) do
				if child and child:IsA("BasePart") then
					child:Destroy()
				end
			end
		end
	end
end

-- Slow Fall Functions
local function startSlowFall()
	if slowFallConnection then slowFallConnection:Disconnect() end
	slowFallConnection = RunService.Heartbeat:Connect(function()
		local character = player.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then return end

		if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			local velocity = hrp.Velocity
			if velocity.Y < 0 then
				hrp.Velocity = Vector3.new(velocity.X, velocity.Y * slowFallFactor, velocity.Z)
			end
		end
	end)
end

local function stopSlowFall()
	if slowFallConnection then
		slowFallConnection:Disconnect()
		slowFallConnection = nil
	end
end


-- New Feature: Save Positions and Toggle Walk Between A & B
local toggleWalkEnabled = false
local positionA = nil
local positionB = nil
local walkTween = nil

local function stopWalkTween()
	if walkTween then
		walkTween:Cancel()
		walkTween = nil
	end
end

local function walkBetweenPositions()
	local hrp = getHRP()
	if not hrp or not positionA or not positionB then return end

	while toggleWalkEnabled do
		-- Walk to position A
		walkTween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - positionA.Position).Magnitude / 30, Enum.EasingStyle.Linear), {CFrame = positionA})
		walkTween:Play()
		walkTween.Completed:Wait()
		if not toggleWalkEnabled then break end

		-- Walk to position B
		walkTween = TweenService:Create(hrp, TweenInfo.new((positionA.Position - positionB.Position).Magnitude / 30, Enum.EasingStyle.Linear), {CFrame = positionB})
		walkTween:Play()
		walkTween.Completed:Wait()
		if not toggleWalkEnabled then break end
	end
end

-- ESP Section
local espEnabled = false
local selectedOre = "All"

local oresForESP = {
	"All",
	"Cave2Stone",
	"Quartz-Cave",
	"MagmaRock",
	"HeatedMagmaRock",
	"Obsidian",
}

local oreColors = {
	["Cave2Stone"] = Color3.fromRGB(255, 165, 0),       -- Orange
	["Quartz-Cave"] = Color3.fromRGB(0, 191, 255),      -- Deep Sky Blue
	["MagmaRock"] = Color3.fromRGB(255, 69, 0),         -- Red Orange
	["HeatedMagmaRock"] = Color3.fromRGB(138, 43, 226), -- Blue Violet
	["Obsidian"] = Color3.fromRGB(75, 0, 130),          -- Indigo
}

local function createESPBox(part, color)
	local adorn = Instance.new("BoxHandleAdornment")
	adorn.Adornee = part
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 10
	adorn.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
	adorn.Transparency = 0.5
	adorn.Color3 = color or Color3.new(1, 1, 1)
	adorn.Parent = part
	return adorn
end

local espBoxes = {}

local function clearESP()
	for part, adorn in pairs(espBoxes) do
		if adorn and adorn.Parent then
			adorn:Destroy()
		end
	end
	espBoxes = {}
end

local function runESP()
	while espEnabled do
		task.wait(1)
		clearESP()

		local function addESPToOreFolder(oreFolderName)
			local oreArea = workspace:FindFirstChild("OreArea")
			if not oreArea then return end
			local oreFolder = nil

			-- Special case for Obsidian
			if oreFolderName == "Obsidian" then
				oreFolder = oreArea:FindFirstChild("Obsidian")
				if oreFolder then
					local heatedMagma = oreFolder:FindFirstChild("HeatedMagmaRock")
					if heatedMagma and heatedMagma:FindFirstChild("Amount") then
						oreFolder = heatedMagma.Amount
					else
						oreFolder = oreFolder
					end
				end
			else
				oreFolder = oreArea:FindFirstChild(oreFolderName)
			end

			if not oreFolder then return end

			local color = oreColors[oreFolderName] or Color3.new(1, 1, 1)

			local function recurseParts(parent)
				for _, child in ipairs(parent:GetChildren()) do
					if child:IsA("BasePart") then
						if not espBoxes[child] then
							espBoxes[child] = createESPBox(child, color)
						end
					elseif #child:GetChildren() > 0 then
						recurseParts(child)
					end
				end
			end

			recurseParts(oreFolder)
		end

		if selectedOre == "All" then
			for _, oreName in ipairs(oresForESP) do
				if oreName ~= "All" then
					addESPToOreFolder(oreName)
				end
			end
		else
			addESPToOreFolder(selectedOre)
		end
	end
	clearESP()
end


---
-- WindUI Tabs for Abssy Miner Features
---

local AbyssMinerTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "crown" })
local TpTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings-2" })

AbyssMinerTab:Toggle({
    Title = "Auto HitBox",
    Callback = function(state)
        autoHitBoxEnabled = state
        if state then task.spawn(autoHitBox) end
    end
})

AbyssMinerTab:Toggle({
    Title = "Auto Sell Inventory",
    Callback = function(state)
        autoSellEnabled = state
        if state then task.spawn(autoSellInventory) end
    end
})

AbyssMinerTab:Toggle({
    Title = "Auto Remove Dead Parts",
    Callback = function(state)
        autoRemoveDeadPartsEnabled = state
        if state then task.spawn(autoRemoveDeadParts) end
    end
})

AbyssMinerTab:Toggle({
    Title = "Slow Fall",
    Callback = function(state)
        slowFallEnabled = state
        if slowFallEnabled then
            startSlowFall()
        else
            stopSlowFall()
        end
    end
})

AbyssMinerTab:Slider({
    Title = "Fall Speed (%)",
    Min = 0,
    Max = 50,
    Default = 15,
    Rounding = 0,
    Callback = function(value)
        slowFallFactor = value / 100
        if slowFallEnabled then
            startSlowFall() -- Reapply with new factor
        end
    end
})

FarmTab:Toggle({
    Title = "Auto Surface (Layer 1)",
    Callback = function(state)
        autoLayer1Enabled = state
        if state then task.spawn(autoTeleportLayer1) end
    end
})

FarmTab:Toggle({
    Title = "Auto Cave 2 (Stone)",
    Callback = function(state)
        autoTeleportEnabled = state
        if state then task.spawn(autoTeleportStones) end
    end
})

FarmTab:Toggle({
    Title = "Auto Quartz Stone",
    Callback = function(state)
        autoQuartzStoneEnabled = state
        if state then task.spawn(autoTeleportQuartzStone) end
    end
})

FarmTab:Toggle({
    Title = "Auto Magma Rock",
    Callback = function(state)
        autoMagmaEnabled = state
        if state then task.spawn(autoTeleportMagma) end
    end
})

FarmTab:Toggle({
    Title = "Auto Heated Magma Rock",
    Callback = function(state)
        autoHeatedMagmaEnabled = state
        if state then task.spawn(autoTeleportHeatedMagma) end
    end
})

local teleportOptions = {
	"Cave2Stone",
	"StoneInGreanHeaven",
	"Tire-2 Shop",
	"Tire-3 Shop",
	"QuartzStone",
	"Spawn Location",
	"Magma Rock",
	"Obsidian"
}

TpTab:Dropdown({
    Title = "Teleport To",
    Options = teleportOptions,
    Default = 1,
    Callback = function(selected)
        local hrp = getHRP()
        if not hrp then
            warn("HumanoidRootPart not found")
            return
        end

        if selected == "Cave2Stone" then
            local stoneArea = workspace:FindFirstChild("OreArea") and workspace.OreArea:FindFirstChild("Cave2Stone") and workspace.OreArea.Cave2Stone:FindFirstChild("StoneArea")
            if stoneArea and stoneArea:IsA("BasePart") then
                hrp.CFrame = stoneArea.CFrame + Vector3.new(0, 5, 0)
            else
                warn("Cave2Stone StoneArea not found or invalid")
            end

        elseif selected == "StoneInGreanHeaven" then
            -- This relies on specific child indices, which can be fragile.
            -- Consider finding parts by name if possible.
            local parent214 = workspace:GetChildren()[214]
            if parent214 then
                local targetPart = parent214:GetChildren()[12]
                if targetPart and targetPart:IsA("BasePart") then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                else
                    warn("StoneInGreanHeaven target missing or not a BasePart")
                end
            else
                warn("workspace:GetChildren()[214] not found")
            end

        elseif selected == "Tire-2 Shop" then
            local model = workspace:GetChildren()[297]
            if model and model:FindFirstChild("Model") and model.Model:FindFirstChild("Part") then
                local part = model.Model.Part
                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
            else
                warn("Tire-2 Shop part not found")
            end

        elseif selected == "Tire-3 Shop" then
            local target = workspace:GetChildren()[1046]:GetChildren()[159]
            if target and target:IsA("BasePart") then
                hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
            else
                warn("Tire-3 Shop part not found or invalid")
            end

        elseif selected == "QuartzStone" then
            local target = workspace:GetChildren()[1982]
            if target and target:IsA("BasePart") then
                hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
            else
                warn("QuartzStone target not found or invalid")
            end

        elseif selected == "Spawn Location" then
            local spawn = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Spawnpoint") and workspace.Map.Spawnpoint:FindFirstChild("SpawnLocation")
            if spawn and spawn:IsA("BasePart") then
                hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            else
                warn("Spawn Location not found or invalid")
            end

        elseif selected == "Magma Rock" then
            local magma = workspace:GetChildren()[2885]
            if magma and magma:IsA("BasePart") then
                hrp.CFrame = magma.CFrame + Vector3.new(0, 5, 0)
            else
                warn("Magma Rock part not found or invalid")
            end

        elseif selected == "Obsidian" then
            local obsidian = workspace:GetChildren()[1466]
            if obsidian and obsidian:IsA("BasePart") then
                hrp.CFrame = obsidian.CFrame + Vector3.new(0, 5, 0)
            else
                warn("Obsidian part not found or invalid")
            end
        end
    end
})

ShopTab:Button({
    Title = "Open RankUp GUI",
    Callback = function()
        local karl = workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Karl")
        local dialogue = karl:WaitForChild("HumanoidRootPart"):WaitForChild("Dialogue")
        local args = {karl, dialogue}
        remoteRankUpGui:FireServer(unpack(args))
    end
})

local shopPickaxeNames = {}
for _, pickaxe in ipairs(pickaxes) do
	if pickaxe.name then
		table.insert(shopPickaxeNames, pickaxe.name)
	end
end

ShopTab:Dropdown({
    Title = "Buy Pickaxe",
    Options = shopPickaxeNames,
    Default = 1,
    Callback = function(selectedPickaxeName)
        if not selectedPickaxeName then return end
        pcall(function()
            remoteBuyItem:FireServer(selectedPickaxeName)
        end)
    end
})

MiscTab:Toggle({
    Title = "Remove Fog",
    Callback = function(value)
        if value then
            game.Lighting.FogEnd = 100000
        else
            game.Lighting.FogEnd = 1000
        end
    end
})

MiscTab:Toggle({
    Title = "Full Bright",
    Callback = function(value)
        if value then
            game.Lighting.ClockTime = 14
            game.Lighting.Brightness = 2
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            game.Lighting.ClockTime = 12
            game.Lighting.Brightness = 1
            game.Lighting.GlobalShadows = true
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

MiscTab:Button({
    Title = "Save Position A",
    Callback = function()
        local hrp = getHRP()
        if hrp then
            positionA = hrp.CFrame
            warn("Position A saved at: ", positionA)
        end
    end
})

MiscTab:Button({
    Title = "Save Position B",
    Callback = function()
        local hrp = getHRP()
        if hrp then
            positionB = hrp.CFrame
            warn("Position B saved at: ", positionB)
        end
    end
})

MiscTab:Toggle({
    Title = "Toggle Walk Between A & B",
    Callback = function(value)
        toggleWalkEnabled = value
        if toggleWalkEnabled then
            if not positionA or not positionB then
                warn("Please save both Position A and Position B before enabling.")
                toggleWalkEnabled = false
                return -- Disable toggle if positions aren't set
            end
            task.spawn(walkBetweenPositions)
        else
            stopWalkTween()
        end
    end
})

EspTab:Toggle({
    Title = "Enable ESP",
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            task.spawn(runESP)
        else
            clearESP()
        end
    end
})

EspTab:Dropdown({
    Title = "Select Ore for ESP",
    Options = oresForESP,
    Default = 1,
    Callback = function(selected)
        selectedOre = selected
        if espEnabled then
            task.spawn(runESP)
        end
    end
})
