-- =========================
local version = "2.8.7"
-- =========================

repeat task.wait() until game:IsLoaded()

-- ====================== SETTINGS ======================
local settings = {
    autoFish = false,
    autoReel = false,
    autoCollect = false,
    autoBuyBait = false,
    autoBuySupplies = false,
    antiAFK = false 
}

local codelist = {
    "Release",
    "Tutorial"
}

-- ====================== FPS Unlock ======================
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

-- ====================== WINDUI ======================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ====================== WINDOW ======================
local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    IconThemed = true,
    Icon = "rbxassetid://104487529937663",
    Author = "Fish a Brainrot | Premium Version",
    Folder = "DYHUB_FaB",
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
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local BrainrotTab = Window:Tab({ Title = "Brainrot", Icon = "fish" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })
Window:SelectTab(1)

-- ====================== AUTO FARM ======================
Main:Section({ Title = "Fishing", Icon = "fish" })

Main:Toggle({
    Title = "Auto Reel",
    Default = settings.autoReel,
    Callback = function(state)
        settings.autoReel = state
        if state then
            task.spawn(function()
                local FishingRF = ReplicatedStorage
                    :WaitForChild("Packages")
                    :WaitForChild("_Index")
                    :WaitForChild("sleitnick_knit@1.7.0")
                    :WaitForChild("knit")
                    :WaitForChild("Services")
                    :WaitForChild("FishingService")
                    :WaitForChild("RF")
                
                local targetY = 0.76
                local epsilon = 0.1

                while settings.autoReel do
                    pcall(function()
                        local gui = LocalPlayer.PlayerGui:FindFirstChild("Fishing")
                        if gui then
                            local container = gui:FindFirstChild("Container")
                            if container then
                                local yPos = container.Position.Y.Scale
                                if yPos <= targetY + epsilon then
                                     task.wait(1.25)
                                    FishingRF:WaitForChild("ClaimCatch"):InvokeServer()
                           
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

Main:Section({ Title = "Money Collect", Icon = "coins" })

Main:Toggle({
    Title = "Auto Collect",
    Default = settings.autoCollect,
    Callback = function(state)
        settings.autoCollect = state
        if state then
            task.spawn(function()
                while settings.autoCollect do
                    pcall(function()
                        for i = 1, 11 do
                            local args = { "PlaceableArea_" .. i }
                            ReplicatedStorage
                                :WaitForChild("Packages")
                                :WaitForChild("_Index")
                                :WaitForChild("sleitnick_knit@1.7.0")
                                :WaitForChild("knit")
                                :WaitForChild("Services")
                                :WaitForChild("MoneyCollectionService")
                                :WaitForChild("RF")
                                :WaitForChild("CollectMoney")
                                :InvokeServer(unpack(args))
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ====================== SHOP ======================
local function createShopSection(title, icon, items, multi, serviceName, toggleSetting)
    local selectedItems = {}
    Shop:Section({ Title = title, Icon = icon })

    Shop:Dropdown({
        Title = "Select " .. title,
        Values = items,
        Multi = multi,
        Callback = function(values)
            selectedItems = values
        end
    })

    Shop:Toggle({
        Title = "Auto Buy Selected " .. title,
        Default = settings[toggleSetting],
        Callback = function(state)
            settings[toggleSetting] = state
            if state then
                task.spawn(function()
                    while settings[toggleSetting] do
                        pcall(function()
                            for _, item in ipairs(selectedItems) do
                                local args = { item }
                                ReplicatedStorage
                                    :WaitForChild("Packages")
                                    :WaitForChild("_Index")
                                    :WaitForChild("sleitnick_knit@1.7.0")
                                    :WaitForChild("knit")
                                    :WaitForChild("Services")
                                    :WaitForChild(serviceName)
                                    :WaitForChild("RF")
                                    :WaitForChild("PurchaseItem")
                                    :InvokeServer(unpack(args))
                            end
                        end)
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
end

-- Rod Shop
local Rods = {"WeakRod","WoodenRod","ReinforcedRod","CoralRod","LightningRod","FrozenRod","AstralRod","MagmaRod","CupidRod","DivineRod"}
Shop:Section({ Title = "Rod Shop", Icon = "fish" })
local selectedRod = nil
Shop:Dropdown({
    Title = "Select Rod",
    Values = Rods,
    Multi = false,
    Callback = function(value)
        selectedRod = value
    end
})
Shop:Button({
    Title = "Purchase Selected Rod",
    Callback = function()
        if not selectedRod or selectedRod == "" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "DYHUB",
                Text = "Please select a Rod before purchasing",
                Duration = 2
            })
            return
        end
        pcall(function()
            local args = { selectedRod }
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("RodService")
                :WaitForChild("RF")
                :WaitForChild("PurchaseRod")
                :InvokeServer(unpack(args))
        end)
    end
})

-- Bait Shop
createShopSection("Bait Shop", "fish", {
    "Worm","Shrimp","Eel","Kiwi","Banana","CoffeeBeans","Crab","Squid","Grape","Orange","Tophat","Watermelon","Dragonfruit","GoldenBanana"
}, true, "BaitService", "autoBuyBait")

-- Supplies Shop
createShopSection("Supplies Shop", "package", {
    "RustyWeightCharm","RustyMutationCharm","WeightCharm","MutationCharm","MutationStabilizer","EvolutionCrystal","OverfeedCharm","KeeperSeal"
}, true, "SuppliesService", "autoBuySupplies")

-- Boat Shop
local Boats = {"Rowboat","Motorboat","Speeder","Pontoon","Yacht"}
local selectedBoat = nil
Shop:Section({ Title = "Boat Shop", Icon = "ship" })
Shop:Dropdown({
    Title = "Select Boat",
    Values = Boats,
    Multi = false,
    Callback = function(value)
        selectedBoat = value
    end
})
Shop:Button({
    Title = "Purchase Selected Boat",
    Callback = function()
        if not selectedBoat or selectedBoat == "" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "DYHUB",
                Text = "Please select a Boat before purchasing",
                Duration = 2
            })
            return
        end
        pcall(function()
            local args = { selectedBoat }
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("BoatService")
                :WaitForChild("RF")
                :WaitForChild("PurchaseBoat")
                :InvokeServer(unpack(args))
        end)
    end
})

-- ====================== BRAINROT ======================
BrainrotTab:Section({ Title = "Sell Brainrot", Icon = "fish" })
BrainrotTab:Button({
    Title = "Sell Held Brainrots",
    Callback = function()
        pcall(function()
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("FishingService")
                :WaitForChild("RF")
                :WaitForChild("SellHeldItem")
                :InvokeServer()
        end)
    end
})
BrainrotTab:Button({
    Title = "Sell All Brainrots",
    Callback = function()
        pcall(function()
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("FishingService")
                :WaitForChild("RF")
                :WaitForChild("SellInventory")
                :InvokeServer()
        end)
    end
})

-- ====================== MISC TAB ======================
MiscTab:Section({ Title = "Code", Icon = "gift" })

MiscTab:Button({
    Title = "Redeem Code All",
    Callback = function()
        task.spawn(function()
            pcall(function()
                for _, code in ipairs(codelist) do
                    local args = { code }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Packages")
                        :WaitForChild("_Index")
                        :WaitForChild("sleitnick_knit@1.7.0")
                        :WaitForChild("knit")
                        :WaitForChild("Services")
                        :WaitForChild("CodesService")
                        :WaitForChild("RF")
                        :WaitForChild("RedeemCode")
                        :InvokeServer(unpack(args))
                end
            end)
        end)
    end
})

MiscTab:Section({ Title = "Miscellaneous", Icon = "cog" })

MiscTab:Toggle({
    Title = "Anti AFK",
    Default = settings.antiAFK,
    Callback = function(state)
        settings.antiAFK = state
        if state then
            local player = game:GetService("Players").LocalPlayer
            local VirtualUser = game:GetService("VirtualUser")

            task.spawn(function()
                while settings.antiAFK do
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                    task.wait(120)
                end
            end)
        end
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
