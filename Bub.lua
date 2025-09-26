-- ============================== VERSION ==============================
local version = "3.6.5"

-- ============================== SERVICE ==============================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ============================== SETTINGS =============================
local scrollingFrame = Players.LocalPlayer.PlayerGui.Pages.Shop.Inner.Contents.ScrollingFrame

local function getButtonNames(frame)
    local names = {}
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") then
            table.insert(names, child.Name)
        end
    end
    return names
end

local crateOptions = getButtonNames(scrollingFrame)
local selectedCrate = {}
local autoBuyCrate = false

local blockOptions = getButtonNames(scrollingFrame)
local selectedBlock = {}
local autoBuyBlock = false

-- ============================== DATA ==============================
local Items = {
    Crate = {
        "WoodenCrate",
        "IronCrate",
        "GoldCrate",
        "ElectroCrate"
    },
    Defense = {
        "CrossbowTurret",
        "Spikes",
        "StoneSpikes",
        "Turret",
        "MetalSpikes",
        "DoubleTurret",
        "Flamethrower",
        "MinigunTurret"
    },
    Block = {
        "Block",
        "StoneBlock",
        "MetalBlock"
    },
    Decor = {
        "Window",
        "Wedge",
        "Stair",
        "LaserDoor",
        "StoneWedge",
        "StoneWindow",
        "StoneStair",
        "StoneLaserDoor",
        "MetalStair",
        "MetalWindow",
        "MetalWedge",
        "MetalLaserDoor"
    }
}

-- ============================== WINDOW ===============================
repeat task.wait() until game:IsLoaded()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Build ur Base | Premium Version",
    Folder = "DYHUB_BUB",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    BackgroundImageTransparency = 0.8,
    HasOutline = false,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false },
})
pcall(function() Window:Tag({ Title = version, Color = Color3.fromHex("#30ff6a") }) end)
Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30,30,30), Color3.fromRGB(255,255,255)),
    Draggable = true
})

-- ============================== TABS =================================
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local Event = Window:Tab({ Title = "Event", Icon = "party-popper" })
Window:SelectTab(1)

-- ============================== FEATURES ============================
Main:Section({ Title = "Auto Farm", Icon = "crown" })

Main:Toggle({
    Title = "Auto Farm (Beta)",
    Default = false,
    Callback = function(state)
        spawn(function()
            local lastLaunch = 0
            while state do
                task.wait(0.05)
                if tick() - lastLaunch >= 300 then
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes")
                            :WaitForChild("Functions")
                            :WaitForChild("LaunchVehicle")
                            :InvokeServer()
                    end)
                    lastLaunch = tick()
                end
                pcall(function()
                    ReplicatedStorage:WaitForChild("Remotes")
                        :WaitForChild("Events")
                        :WaitForChild("ToolState")
                        :FireServer(true)
                end)
            end
        end)
    end
})

Main:Section({ Title = "Feature Helper", Icon = "cross" })

Main:Toggle({
    Title = "Auto Start",
    Default = false,
    Callback = function(state)
        if state then
            task.wait(0.69)
            pcall(function()
                ReplicatedStorage:WaitForChild("Remotes")
                    :WaitForChild("Functions")
                    :WaitForChild("LaunchVehicle")
                    :InvokeServer()
            end)
        end
    end
})

Main:Toggle({
    Title = "Auto Shoot All",
    Default = false,
    Callback = function(state)
        spawn(function()
            while state do
                task.wait(0.005)
                pcall(function()
                    ReplicatedStorage:WaitForChild("Remotes")
                        :WaitForChild("Events")
                        :WaitForChild("ToolState")
                        :FireServer(true)
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "Disable Notify",
    Default = false,
    Callback = function(state)
        local hints = Players.LocalPlayer.PlayerGui:FindFirstChild("Hints")
        if hints then
            hints.Enabled = not state
        end
    end
})

Event:Section({ Title = "Event", Icon = "moon" })

Event:Toggle({
    Title = "Auto Submit Lunar",
    Default = false,
    Callback = function(state)
        spawn(function()
            while state do
                task.wait(1)
                pcall(function()
                    local args = {"LunarEclipse"}
                    ReplicatedStorage:WaitForChild("Remotes")
                        :WaitForChild("Functions")
                        :WaitForChild("ProgressEventSubmit")
                        :InvokeServer(unpack(args))
                end)
            end
        end)
    end
})

Event:Toggle({
    Title = "Auto Collect Lunar",
    Default = false,
    Callback = function(state)
        spawn(function()
            while state do
                task.wait(1)
                pcall(function()
                    local args = {"LunarEclipse"}
                    ReplicatedStorage:WaitForChild("Remotes")
                        :WaitForChild("Functions")
                        :WaitForChild("ProgressEventSubmit")
                        :InvokeServer(unpack(args))
                end)
            end
        end)
    end
})

-- ============================== SHOP ================================

-- ===== CRATE =====
Shop:Section({ Title = "Buy Crate", Icon = "gift" })

Shop:Dropdown({
    Title = "Select Crate",
    Values = Items.Crate,
    Multi = true,
    Callback = function(values)
        selectedCrate = values
    end
})

Shop:Toggle({
    Title = "Auto Buy Crate",
    Default = false,
    Callback = function(state)
        autoBuyCrate = state
        spawn(function()
            while autoBuyCrate do
                task.wait(1)
                if selectedCrate and #selectedCrate > 0 then
                    for _, crate in ipairs(selectedCrate) do
                        local args = {"Crates", crate}
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes")
                                :WaitForChild("Functions")
                                :WaitForChild("BuyStock")
                                :InvokeServer(unpack(args))
                        end)
                    end
                end
            end
        end)
    end
})

-- ===== DEFENSE =====
Shop:Section({ Title = "Buy Defense", Icon = "shield" })

Shop:Dropdown({
    Title = "Select Defense",
    Values = Items.Defense,
    Multi = true,
    Callback = function(values)
        selectedDefense = values
    end
})

Shop:Toggle({
    Title = "Auto Buy Defense",
    Default = false,
    Callback = function(state)
        autoBuyDefense = state
        spawn(function()
            while autoBuyDefense do
                task.wait(1)
                if selectedDefense and #selectedDefense > 0 then
                    for _, defense in ipairs(selectedDefense) do
                        local args = {"Blocks", defense}
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes")
                                :WaitForChild("Functions")
                                :WaitForChild("BuyStock")
                                :InvokeServer(unpack(args))
                        end)
                    end
                end
            end
        end)
    end
})

-- ===== BLOCK =====
Shop:Section({ Title = "Buy Block", Icon = "package" })

Shop:Dropdown({
    Title = "Select Block",
    Values = Items.Block,
    Multi = true,
    Callback = function(values)
        selectedBlock = values
    end
})

Shop:Toggle({
    Title = "Auto Buy Block",
    Default = false,
    Callback = function(state)
        autoBuyBlock = state
        spawn(function()
            while autoBuyBlock do
                task.wait(1)
                if selectedBlock and #selectedBlock > 0 then
                    for _, block in ipairs(selectedBlock) do
                        local args = {"Blocks", block}
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes")
                                :WaitForChild("Functions")
                                :WaitForChild("BuyStock")
                                :InvokeServer(unpack(args))
                        end)
                    end
                end
            end
        end)
    end
})

-- ===== DECOR =====
Shop:Section({ Title = "Buy Decor", Icon = "cuboid" })

Shop:Dropdown({
    Title = "Select Decor",
    Values = Items.Decor,
    Multi = true,
    Callback = function(values)
        selectedDecor = values
    end
})

Shop:Toggle({
    Title = "Auto Buy Decor",
    Default = false,
    Callback = function(state)
        autoBuyDecor = state
        spawn(function()
            while autoBuyDecor do
                task.wait(1)
                if selectedDecor and #selectedDecor > 0 then
                    for _, decor in ipairs(selectedDecor) do
                        local args = {"Blocks", decor}
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes")
                                :WaitForChild("Functions")
                                :WaitForChild("BuyStock")
                                :InvokeServer(unpack(args))
                        end)
                    end
                end
            end
        end)
    end
})

-- ============================== DISCORD ==============================
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
