-- ============================== VERSION ==============================
local version = "3.5.1"

-- ============================== SERVICE ==============================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ============================== SETTINGS =============================
local cratesFrame = Players.LocalPlayer.PlayerGui.Pages.Shop.Inner.Contents.ScrollingFrame
local blockFrame = Players.LocalPlayer.PlayerGui.Pages.Shop.Inner.Contents.ScrollingFrame

local function getButtonNames(frame)
    local names = {}
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") then
            table.insert(names, child.Name)
        end
    end
    return names
end

local crateOptions = getButtonNames(cratesFrame)
local selectedCrate = {} -- table สำหรับหลายค่า
local autoBuyCrate = false

local blockOptions = getButtonNames(blockFrame)
local selectedBlock = {} -- table สำหรับหลายค่า
local autoBuyBlock = false

-- ============================== WINDOW ===============================
repeat task.wait() until game:IsLoaded()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Build ur Base | Free Version",
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
Window:SelectTab(1)

-- ============================== FEATURES ============================
Main:Section({ Title = "Auto Farm", Icon = "crown" })

Main:Toggle({
    Title = "Auto Farm (Beta)",
    Default = false,
    Callback = function(state)
        spawn(function()
            while state do
                task.wait(0.1)
                
                -- Auto Start
                pcall(function()
                    ReplicatedStorage:WaitForChild("Remotes")
                        :WaitForChild("Functions")
                        :WaitForChild("LaunchVehicle")
                        :InvokeServer()
                end)
                
                -- Auto Shoot All
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

Main:Section({ Title = "Auto Helper", Icon = "crown" })

Main:Toggle({
    Title = "Auto Start",
    Default = false,
    Callback = function(state)
        if state then
            task.wait(1.11)
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
                task.wait(0.25)
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

Main:Section({ Title = "Event", Icon = "moon" })

Main:Toggle({
    Title = "Auto Submit Lunar",
    Default = false,
    Callback = function(state)
        spawn(function()
            while state do
                task.wait(2)
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
Shop:Section({ Title = "Buy Crate", Icon = "gift" })

Shop:Dropdown({
    Title = "Select Crate",
    Values = crateOptions,
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
                    local args = {"Crates", selectedCrate}
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes")
                            :WaitForChild("Functions")
                            :WaitForChild("BuyStock")
                            :InvokeServer(unpack(args))
                    end)
                end
            end
        end)
    end
})

Shop:Section({ Title = "Buy Block", Icon = "package" })

Shop:Dropdown({
    Title = "Select Block",
    Values = blockOptions,
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
                    local args = {"Blocks", selectedBlock}
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes")
                            :WaitForChild("Functions")
                            :WaitForChild("BuyStock")
                            :InvokeServer(unpack(args))
                    end)
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
