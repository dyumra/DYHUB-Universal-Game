-- =========================
local version = "1.3.1"
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

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainDivider = Window:Divider()
local Main = Window:Tab({ Title = "Main", Icon = "rocket" })
local Gamepass = Window:Tab({ Title = "Gamepass", Icon = "star" })
Window:SelectTab(1)

-- ====================== DATA ======================
local shop = {
    raceList = { "Human", "Death Paiting", "Cursed Spirit", "Angel", "Fallen Angel" },
    techniqueList = { "Ratio", "Blood Manipulation", "Disaster Flames", "Divergent Fist", "Disaster Tides", "Cursed Speech", "Boogie Woogie", "Star Rage", "Sound Amplification", "Blast Energy", "Moon Dregs", "Straw Doll", "Jackpot", "Infinity", "Idle Transfiguration", "Deadly Sentencing", "Projection", "Ice Formation", "Comedian", "Anti Gravity", "Ten Shadows", "Heavenly Restriction", "Rika", "Curse Manipulation", "Super Senior Infinity", "Super Senior Shrine" },
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
