-- =========================
local version = "1.2.9"
-- =========================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
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

-- ========================= SERVICES =========================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ========================= SETTINGS =========================
_G.AutoCollectMoney = false
_G.AutoLockBase = false
_G.NoHoldSteal = false
_G.Noclip = false
_G.speedEnabled = false

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Steal A Fish | Premium Version",
    Folder = "DYHUB_SAF",
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

-- ====================== Tabs ======================
local Tabs = {
    InfoTab = Window:Tab({ Title = "Information", Icon = "info" }),
    MainDivider = Window:Divider(),
    GameTab = Window:Tab({ Title = "Main", Icon = "rocket" }),
    PlayerTab = Window:Tab({ Title = "Player", Icon = "user" }),
    ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" }),
    TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
}
Window:SelectTab(1)

-- ====================== GameTab ======================
Tabs.GameTab:Section({ Title = "Collect", Icon = "dollar-sign" })

Tabs.GameTab:Toggle({
    Title = "Auto Collect (Money)",
    Default = false,
    Callback = function(state)
        _G.AutoCollectMoney = state
        if state then
            task.spawn(function()
                local collectRemote = game:GetService("ReplicatedStorage")
                    :WaitForChild("voidSky")
                    :WaitForChild("Remotes")
                    :WaitForChild("Server")
                    :WaitForChild("Objects")
                    :WaitForChild("Trash")
                    :WaitForChild("Collect")

                while _G.AutoCollectMoney do
                    for i = 1, 20 do
                        local args = {i}  -- ยิงทีละเลข
                        local success, err = pcall(function()
                            collectRemote:FireServer(unpack(args))
                        end)
                        if not success then warn("AutoCollect Error:", err) end
                        task.wait(0.001) -- รอเล็กน้อยก่อนยิงเลขถัดไป
                    end
                    task.wait(0.5) -- รอระหว่างรอบ
                end
            end)
        end
    end
})

-- ====================== Auto Lock Base ======================
local function GetNearestTycoon()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local nearest, dist = nil, math.huge

    for _, tycoon in pairs(Workspace:WaitForChild("Map"):WaitForChild("Tycoons"):GetChildren()) do
        local tycoonMain = tycoon:FindFirstChild("Tycoon")
        if tycoonMain and tycoonMain:IsA("Model") then
            local base = tycoonMain:FindFirstChild("Base") or tycoonMain:FindFirstChild("MainPart") or tycoonMain:FindFirstChildWhichIsA("BasePart")
            if base then
                local d = (hrp.Position - base.Position).Magnitude
                if d < dist then
                    nearest = tycoon
                    dist = d
                end
            end
        end
    end
    return nearest
end

local function LockBase(tycoon)
    task.spawn(function()
        while _G.AutoLockBase do
            local success, err = pcall(function()
                local args = {
                    tycoon:WaitForChild("Tycoon")
                        :WaitForChild("ForcefieldFolder")
                        :WaitForChild("Buttons")
                        :WaitForChild("ForceFieldBuy")
                }
                ReplicatedStorage:WaitForChild("voidSky")
                    :WaitForChild("Remotes")
                    :WaitForChild("Server")
                    :WaitForChild("Objects")
                    :WaitForChild("BuyButton")
                    :FireServer(unpack(args))
            end)
            if not success then warn("LockBase Error:", err) end
            task.wait(0.1)
        end
    end)
end

Tabs.GameTab:Section({ Title = "Lock", Icon = "lock" })

Tabs.GameTab:Toggle({
    Title = "Auto Lock Base",
    Default = false,
    Callback = function(state)
        _G.AutoLockBase = state
        if state then
            local myTycoon = GetNearestTycoon()
            if myTycoon then
                print("🔒 Locking Tycoon:", myTycoon.Name)
                LockBase(myTycoon)
            else
                warn("❌ Tycoon not found near you")
            end
        end
    end
})

-- ====================== Steal (No Hold) ======================
Tabs.GameTab:Section({ Title = "Steal", Icon = "drama" })

Tabs.GameTab:Toggle({
    Title = "Steal (No Hold)",
    Default = false,
    Callback = function(state)
        _G.NoHoldSteal = state
        if state then
            task.spawn(function()
                while _G.NoHoldSteal do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(2.5)
                end
            end)
        end
    end
})

-- ======= PlayerTab (Speed, Fly, Noclip) =======
Tabs.PlayerTab:Section({ Title = "Player", Icon = "user" })
getgenv().speedValue = 20

Tabs.PlayerTab:Slider({
    Title = "Set Speed Value",
    Value = { Min = 16, Max = 600, Default = 20 },
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if _G.speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

Tabs.PlayerTab:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(state)
        _G.speedEnabled = state
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.WalkSpeed = state and getgenv().speedValue or 16 end
    end
})

Tabs.PlayerTab:Section({ Title = "Power", Icon = "flame" })

Tabs.PlayerTab:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Dly"))()
    end
})

local noclipConnection
Tabs.PlayerTab:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char and _G.Noclip then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- ====================== ESP Tab ======================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPFolder:FindFirstChild(player.Name) then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    local function attachESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = player.Character
            billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    attachESP()
    player.CharacterAdded:Connect(function()
        task.wait(1)
        attachESP()
    end)

    highlight.Parent = ESPFolder
    billboard.Parent = ESPFolder
end

local function removeESP(player)
    local h = ESPFolder:FindFirstChild(player.Name)
    local b = ESPFolder:FindFirstChild(player.Name .. "_ESPLabel")
    if h then h:Destroy() end
    if b then b:Destroy() end
end

Tabs.ESPTab:Section({ Title = "Esp", Icon = "eye" })

Tabs.ESPTab:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        if state then
            for _, plr in pairs(Players:GetPlayers()) do createESP(plr) end
            Players.PlayerAdded:Connect(createESP)
            Players.PlayerRemoving:Connect(removeESP)
        else
            ESPFolder:ClearAllChildren()
        end
    end
})

-- ====================== Teleport Tab ======================
local savedCFrame
task.delay(2, function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then savedCFrame = hrp.CFrame end
end)

Tabs.TeleportTab:Section({ Title = "Teleport", Icon = "map-pin" })

Tabs.TeleportTab:Button({
    Title = "Teleport to Home",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and savedCFrame then
            hrp.CFrame = savedCFrame
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport",
                Text = "Spawn point not saved or character missing!",
                Duration = 5
            })
        end
    end
})



Info = Tabs.InfoTab

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
