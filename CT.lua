-- =========================
local version = "2.4.3"
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
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/dyhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================== SERVICES ======================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Cut Trees | Premium Version",
    Folder = "DYHUB_CT",
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
    Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") })
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- ====================== TABS ======================
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local Shop = Window:Tab({ Title = "Collect", Icon = "gift" })
local Auto = Window:Tab({ Title = "Open", Icon = "gem" })
local TP = Window:Tab({ Title = "Teleport", Icon = "zap" })
local Misc = Window:Tab({ Title = "Misc", Icon = "settings" })
Window:SelectTab(1)

-- ====================== CHEST SYSTEM ======================
Shop:Section({ Title = "Collect Chest", Icon = "package" })

local selectedNormal, selectedGiant, selectedHuge = {}, {}, {}
local AutoCollectSelected = false

-- formatName
local function formatName(name)
    return string.gsub(name, "%s+", "")
end

-- findChest
local function findChest(name)
    local chestFolder = Workspace:FindFirstChild("ChestFolder")
    if not chestFolder then return nil end
    local cleanName = formatName(name)
    for _, chest in ipairs(chestFolder:GetChildren()) do
        if formatName(chest.Name) == cleanName then
            return chest
        end
    end
    return nil
end

-- collectChest
local function collectChest(chest)
    if not (chest and chest.Parent) then return false end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local pivotCFrame = (chest.PrimaryPart and chest.PrimaryPart.CFrame) or (chest:GetPivot())
    if not pivotCFrame then return false end

    local anchored = root.Anchored
    root.Anchored = true
    root.CFrame = pivotCFrame + Vector3.new(0,3,0)
    task.wait(0.05)
    root.Anchored = anchored

    -- find ProximityPrompt
    local prompt
    for _, obj in pairs(chest:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.ActionText == "Collect" then
            prompt = obj
            break
        end
    end
    if not prompt then return false end

    -- fire proximity
    for i = 1, 10 do
        if not chest.Parent then break end
        pcall(function() fireproximityprompt(prompt, 1) end)
        task.wait(0.02)
    end
    return true
end

-- getSelectedChestList
local function getSelectedChestList()
    local chestList = {}
    for _, v in ipairs(selectedNormal) do
        local chest = findChest(v)
        if chest then table.insert(chestList, chest) end
    end
    for _, v in ipairs(selectedGiant) do
        local chest = findChest(v.."_Giant")
        if chest then table.insert(chestList, chest) end
    end
    for _, v in ipairs(selectedHuge) do
        local chest = findChest(v.."_Huge")
        if chest then table.insert(chestList, chest) end
    end
    return chestList
end

-- Auto Collect
Shop:Toggle({
    Title = "Auto Collect Chests (Selected)",
    Default = false,
    Callback = function(state)
        AutoCollectSelected = state
        task.spawn(function()
            while AutoCollectSelected do
                local chestList = getSelectedChestList()
                for _, chest in ipairs(chestList) do
                    if not AutoCollectSelected then break end
                    collectChest(chest)
                    task.wait(0.1)
                end
                task.wait(0.5)
            end
        end)
    end
})

-- Dropdowns
Shop:Dropdown({
    Title = "Select Chest (Normal)",
    Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"},
    Multi = true,
    Callback = function(values) selectedNormal = values end
})
Shop:Dropdown({
    Title = "Select Chest (Giant)",
    Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"},
    Multi = true,
    Callback = function(values) selectedGiant = values end
})
Shop:Dropdown({
    Title = "Select Chest (Huge)",
    Values = {"Chest1","Chest2","Chest3","Chest4","Chest5","Chest6","Chest7","Chest8","Chest9"},
    Multi = true,
    Callback = function(values) selectedHuge = values end
})

-- ====================== GAME SYSTEM ======================
Main:Section({ Title = "Game System", Icon = "gamepad-2" })
local autoPlay = false
Main:Toggle({
    Title = "Auto Play",
    Default = false,
    Callback = function(state)
        autoPlay = state
        task.spawn(function()
            while autoPlay do
                pcall(function()
                    ReplicatedStorage.Signal.Game:FireServer("play")
                end)
                task.wait(0.8)
            end
        end)
    end
})

-- ======================= GP SYSTEM =======================
Main:Section({ Title = "Gamepass System", Icon = "star" })

Main:Toggle({
    Title = "Unlocked Gamepass",
    Default = false,
    Callback = function(state)
        local player = Players.LocalPlayer
        local gamepasses = {"X2WOOD", "X2POWER", "X2LOOT", "ULTRALUCKY", "XRAY"}
        local defaultSpeed, speedwalk = 16, 50

        local function unlockGamepasses()
            for _, gpName in ipairs(gamepasses) do
                local gp = player.GamepassFolder:FindFirstChild(gpName)
                if gp then
                    pcall(function()
                        if gp:IsA("BoolValue") then gp.Value = true
                        elseif gp:IsA("StringValue") then gp.Value = "true"
                        else gp.Value = true end
                    end)
                end
            end
        end

        local function setSpeed(char)
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = state and speedwalk or defaultSpeed
            end
        end

        unlockGamepasses()
        setSpeed(player.Character or player.CharacterAdded:Wait())
        if state then
            player.CharacterAdded:Connect(function(char)
                task.wait(0.1)
                unlockGamepasses()
                setSpeed(char)
            end)
        end
    end
})

-- ====================== TREE SYSTEM ======================
Main:Section({ Title = "Tree System", Icon = "tree-deciduous" })

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local autoTreeAura = false
local auraRange = 25

Main:Input({
    Title = "Set Range Cut Trees (Aura)",
    Default = tostring(auraRange),
    Placeholder = "Range (Ex: 25)",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            auraRange = num
        else
            warn("Entered an incorrect number!")
        end
    end
})

Main:Toggle({
    Title = "Auto Cut Trees (Aura)",
    Default = false,
    Callback = function(state)
        autoTreeAura = state
    end
})

task.spawn(function()
    while true do
        task.wait(0.05)

        if autoTreeAura then
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local treeFolder = Workspace:FindFirstChild("TreesFolder")
            local signalTree = ReplicatedStorage:FindFirstChild("Signal") and ReplicatedStorage.Signal:FindFirstChild("Tree")

            if root and treeFolder and signalTree then
                for _, tree in ipairs(treeFolder:GetChildren()) do
                    if tree:IsA("Model") then
                        local treePos = tree:FindFirstChild("HumanoidRootPart") 
                                       or tree:FindFirstChild("MainPart") 
                                       or tree.PrimaryPart
                                       or tree:FindFirstChildWhichIsA("BasePart")
                        if treePos then
                            local dist = (root.Position - treePos.Position).Magnitude
                            if dist <= auraRange then
                                local args = {"damage", tree.Name}
                                signalTree:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end
        end
    end
end)

local autoTreeAll = false
Main:Toggle({
    Title = "Auto Cut Trees (All)",
    Default = false,
    Callback = function(state)
        autoTreeAll = state
        task.spawn(function()
            while autoTreeAll do
                local treeFolder = Workspace:FindFirstChild("TreesFolder")
                local signalTree = ReplicatedStorage.Signal:FindFirstChild("Tree")
                if treeFolder and signalTree then
                    for _, tree in ipairs(treeFolder:GetChildren()) do
                        if not autoTreeAll then break end
                        pcall(function()
                            signalTree:FireServer("damage", tree.Name)
                        end)
                        task.wait(0.001)
                    end
                end
                task.wait(0.001)
            end
        end)
    end
})

-- ====================== WORLD TELEPORT ======================
TP:Section({ Title = "World Teleport", Icon = "map" })
TP:Button({ Title = "Teleport to World 1", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(-115, 3.5, -120)) end })
TP:Button({ Title = "Teleport to World 2", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(-1000, 3.5, -125)) end })

-- ====================== MISC TAB ======================
Misc:Section({ Title = "Misc", Icon = "settings" })
local AntiAFK = false
Misc:Toggle({
    Title = "Anti-AFK",
    Default = false,
    Callback = function(state)
        AntiAFK = state
        task.spawn(function()
            local vu = game:GetService("VirtualUser")
            while AntiAFK do
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(math.random(50,70))
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(math.random(50,70))
            end
        end)
    end
})

-- ====================== AUTO TAB ======================
Auto:Section({ Title = "Auto Open Chests", Icon = "package" })

local AutoOpenChests = false
local OpenChestType = {"Normal"}
local OpenChestLevel = {1,2,3,4,5,6,7,8,9}

Auto:Dropdown({
    Title = "Select Chest Type",
    Values = {"Normal","Giant","Huge"},
    Multi = true,
    Callback = function(values) OpenChestType = values end
})

Auto:Dropdown({
    Title = "Select Chest Level",
    Values = {"1","2","3","4","5","6","7","8","9"},
    Multi = true,
    Callback = function(values)
        OpenChestLevel = {}
        for _, v in ipairs(values) do
            table.insert(OpenChestLevel, tonumber(v))
        end
    end
})

Auto:Toggle({
    Title = "Auto Open Selected Chests",
    Default = false,
    Callback = function(state)
        AutoOpenChests = state
        task.spawn(function()
            while AutoOpenChests do
                local chestList = {}
                for _, t in ipairs(OpenChestType) do
                    for _, l in ipairs(OpenChestLevel) do
                        if t == "Normal" then
                            table.insert(chestList, "Chest"..l)
                        elseif t == "Giant" then
                            table.insert(chestList, "Chest"..l.."_Giant")
                        elseif t == "Huge" then
                            table.insert(chestList, "Chest"..l.."_Huge")
                        end
                    end
                end
                for _, chestName in ipairs(chestList) do
                    if not AutoOpenChests then break end
                    pcall(function()
                        ReplicatedStorage.Signal.ChestFunction:InvokeServer("Open", chestName)
                    end)
                    task.wait(0.2)
                end
                task.wait(0.5)
            end
        end)
    end
})

Info = InfoTab

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

-- Define the Request function that mimics ui.Creator.Request
ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
    -- Try different HTTP methods
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            -- Method 1: Use RequestAsync if available
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            -- Method 2: Fallback to GetAsync
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)
    
    if success then
        return result
    else
        error("HTTP Request failed: " .. tostring(result))
    end
end

-- Remove this line completely: Info = InfoTab
-- The Info variable is already correctly set above

local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Info:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    
                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
        print("Discord API Error:", result) -- Debug print
    end
end

LoadDiscordInfo()

Info:Divider()
Info:Section({ 
    Title = "DYHUB Information",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

local Owner = Info:Paragraph({
    Title = "Main Owner",
    Desc = "@dyumraisgoodguy#8888",
    Image = "rbxassetid://119789418015420",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
})

local Social = Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://guns.lol/DYHUB")
                print("Copied social media link to clipboard!")
            end,
        }
    }
})

local Discord = Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/jWNDPNMmyB")
                print("Copied discord link to clipboard!")
            end,
        }
    }
})
