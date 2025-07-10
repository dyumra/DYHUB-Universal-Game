game:GetService("Players").LocalPlayer:Kick("Join discord for new loader");

------------- Game Load -------------
repeat 
    task.wait(); 
until game:IsLoaded();

------------- Super Global -------------
GG = (getgenv and getgenv()) or _G or shared or false;
GG.GG = GG;

if not GG then
    return game:GetService("Players").LocalPlayer:Kick("GG not found. Please report this bug in discord server and tell us your executor.");
end;
if not isfolder or not isfile or not makefolder or not writefile or not readfile then
    return game:GetService("Players").LocalPlayer:Kick("Your executor doesn't support file system. Please report this bug in discord server and tell us your executor.");
end;

GG.ScriptStatus = "Intializing API_M";

GG.LoaderSettings = ((GG.LoaderSettings and GG.LoaderSettings.ExecutedByUser) and GG.LoaderSettings) or {
    AllowThemeEdit = false;
    AllowGraphicsEditor = false;
    AllowMusic = true;
    AllowCache = false;
    AllowKickWithError = true;
    AllowGameTab = true;
    AllowPlayerTab = true;
};

GG.LoaderSettings.TheMimicLoader = GG.LoaderSettings.TheMimicLoader or {
    ["Load_Sections"] = true;
    ["Load_WithPlaceID_Checks"] = false;
};

GG.APINUMBER = "Luarify 2.9";

GG.Uni = "";
GG.API_K = "";
GG.API_Q = [[if not Configs then return; end;]];

GG.GameId = GG.GameId or game.GameId;
GG.PlaceId = GG.PlaceId or game.PlaceId;

------------- LPH Fixer -------------

GG.LPH_NO_VIRTUALIZE = GG.LPH_NO_VIRTUALIZE or function(...)
    return ...;
end;

------------- Replicated First -------------

if not GG.ReplicatedFirst_lc then

    GG.setc = setclipboard or toclipboard or function(...)
        return warn(...);
    end;

    GG.getinfo = getinfo or debug.getinfo or false;
    GG.clonefunction = clonefunction or clonefunc;
    GG.cloneref = cloneref or clonereference;

    if getinfo then
        if clonefunction and getinfo(clonefunction).what == "Lua" then
            GG.clonefunction = function(...)
                return ...;
            end;
        else
            GG.clonefunction = clonefunction or clonefunc;
        end;
        if cloneref and getinfo(cloneref).what == "Lua" then
            GG.clonefunction = function(...)
                return ...;
            end;
        else
            GG.clonefunction = clonefunction or clonefunc;
        end;
    end;

    GG.GetService = clonefunction(game.GetService);

    if GG.clonefunction then
        GG.getinfo = (getinfo and clonefunction(getinfo)) or (debug.getinfo and clonefunction(debug.getinfo));
        GG.pcall = clonefunction(pcall);
    else
        GG.getinfo = getinfo or debug.getinfo;
        GG.pcall = pcall;
    end;

    GG.tble = table;
    GG.tk = task;
    GG.str = string;
    GG.mmaths = math;
    GG.Col3 = Color3;
    GG.BCol = BrickColor;
    GG.Reg3 = Region3;
    GG.Instance = Instance;
    GG.UDim2 = UDim2;
    GG.Font = Font;

    GG.SecureEnv = {
        dumpheap = dumpheap or debug.dumpheap;
        getconstants = getconstants or debug.getconstants;
        getproto = getproto or debug.getproto;
        setmemorycategory = setmemorycategory or debug.setmemorycategory;
        profilebegin = profilebegin or debug.profilebegin;
        loadmodule = loadmodule or debug.loadmodule;
        traceback = traceback or debug.traceback;
        getinfo = getinfo or debug.getinfo;
        getstack = getstack or debug.getstack;
        isvalidlevel = isvalidlevel or debug.isvalidlevel;
        getupvalues = getupvalues or debug.getupvalues;
        getconstant = getconstant or debug.getconstant;
        getfenv = getfenv or debug.getfenv;
        getupvalue = getupvalue or debug.getupvalue;
        getmemorycategory = getmemorycategory or debug.getmemorycategory;
        resetmemorycategory = resetmemorycategory or debug.resetmemorycategory;
        getprotos = getprotos or debug.getprotos;
        dumpcodesize = dumpcodesize or debug.dumpcodesize;
        setstack = setstack or debug.setstack;
        profileend = profileend or debug.profileend;
        dumprefs = dumprefs or debug.dumprefs;
        validlevel = validlevel or debug.validlevel;
        setupvalue = setupvalue or debug.setupvalue;
        setconstant = setconstant or debug.setconstant;
        getregistry = getregistry or debug.getregistry;
        info = info or debug.info;

        wait = wait;
        delay = delay;
        spawn = spawn;
        tick = tick;

        tostring = tostring;
        tos = tostring;
        tonumber = tonumber;
        ton = tonumber;

        tablein = tble.insert;
        tablecl = tble.clear;
        tablef = tble.find;
        tsort = tble.sort;
        tconcat = tble.concat;
        tunpack = tble.unpack;
        tabler = tble.remove;

        twait = tk.wait;
        tdefer = tk.tdefer;
        tspawn = tk.spawn;
        tcancel = tk.cancel;
        tdelay = task.delay;
        tdesyn = tk.desynchronize;
        tsyn = tk.synchronize;

        strgsub = str.gsub;
        strsub = str.sub;
        strfind = str.find;
        strlen = str.len;
        strchar = str.char;
        strbyte = str.byte;
        strsplit = str.split;
        strmatch = str.match;
        strgmatch = str.gmatch;
        strupper = str.upper;
        strlower = str.lower;
        strformat = str.format;
        strpack = str.pack;
        strpacksize = str.packsize;
        strreverse = str.reverse;
        strunpack = str.unpack;
        strrep = str.rep;

        mlog = mmaths.log;
        mldexp = mmaths.ldexp;
        mdeg = mmaths.deg;
        mcosh = mmaths.cosh;
        mround = mmaths.round;
        mrandom = mmaths.random;
        mfrexp = mmaths.frexp;
        mtanh = mmaths.tanh;
        mfloor = mmaths.floor;
        mmax = mmaths.max;
        msqrt = mmaths.sqrt;
        mmodf = mmaths.modf;
        mhuge = mmaths.huge;
        mpow = mmaths.pow;
        macos = mmaths.acos;
        mtan = mmaths.tan;
        mcos = mmaths.cos;
        mpi = mmaths.pi;
        matan = mmaths.atan;
        mmap = mmaths.map;
        msign = mmaths.sign;
        mceil = mmaths.ceil;
        mclamp = mmaths.clamp;
        mnoise = mmaths.noise;
        mabs = mmaths.abs;
        mexp = mmaths.exp;
        msinh = mmaths.sinh;
        masin = mmaths.asin;
        mmin = mmaths.min;
        mrandomseed = mmaths.randomseed;
        mfmod = mmaths.fmod;
        mrad = mmaths.rad;
        matan2 = mmaths.atan2;
        mlog10 = mmaths.log10;
        msin = mmaths.sin;
        mlerp = mmaths.lerp;

        fromRGB = Color3.fromRGB;
        fromHex = Col3.fromHex;
        fromHSV = Col3.fromHSV;
        toHSV = Col3.toHSV;
        Col3new = Col3.new;

        BCol = BrickColor;
        BBlue = BCol.Blue;
        BWhite = BCol.White;
        BYellow = BCol.Yellow;
        BRed = BCol.Red;
        BGray = BCol.Gray;
        Bpalette = BCol.palette;
        BNew = BCol.New;
        BBlack = BCol.Black;
        BGreen = BCol.Green;
        BRandom = BCol.Random;
        BDarkGray = BCol.DarkGray;
        Brandom = BCol.random;
        Bnew = BCol.new;

        FfromId = Font.fromId;
        FfromEnum = Font.fromEnum;
        FfromName = Font.fromName;
        Fnew = Font.new;

        Regnew = Reg3.new;

        TwInfo = TweenInfo.new;

        Rectn = Rect.new;

        Vec3 = Vector3.new;
        Vec2 = Vector2.new;
        CF = CFrame.new;

        pir = pairs;
        ipir = ipairs;
        ipairs = ipairs;
        next = next;

        pcal = pcall;
        xpcal = xpcall;
        ypcal = ypcall;

        Instancen = Instance.new;
        fromExisting = Instance.fromExisting;

        Dim2 = UDim2.new;
        Dim2Off = UDim2.fromOffset;
        Dim2Scale = UDim2.fromScale;

        Dim = UDim.new;

        NSnew = NumberSequence.new;
        NSKnew = NumberSequenceKeypoint.new;

        CSnew = ColorSequence.new;
        CSKnew = ColorSequenceKeypoint.new;
        
        LowerC = hookfunction or hookfunc;
        UpperC = hookmetamethod;

        queueOT = queueonteleport or queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or on_teleport;
    };

    GG.SecureEnvS = {
        ProximityPromptService = "ProximityPromptService";
        VirtualInputManager = "VirtualInputManager";
        RbxAnalyticsService = "RbxAnalyticsService";
        CollectionService = "CollectionService";
        UserInputService = "UserInputService";
        TeleportService = "TeleportService";
        TextService = "TextChatService";
        TweenService = "TweenService";
        HttpService = "HttpService";
        StarterGui = "StarterGui";
        GuiService = "GuiService";
        R  = "ReplicatedStorage";
        VU = "VirtualUser";
        H = "RunService";
        W = "Workspace";
        L = "Lighting";
        P = "Players";
        C = "CoreGui";
    };

    GG.ReplicatedFirst_lc = true;

end;

------------- Global API Setup -------------

GG.Load_Icona = GG.Load_Icona or false;
GG.ScriptCache = GG.ScriptCache or {};
GG.ScriptCache.gcF = GG.ScriptCache.gcF or {};
GG.ScriptCache.userIdentify = GG.ScriptCache.userIdentify or {
    is_loaded_lc = false;

    device = nil;

    is_Internal = nil;
    is_executor_WhiteList = nil;

    gcF = false;

    unc_infos = false;
};

if type(GG.ScriptCache.userIdentify.gcF) ~= 'table' then
    GG.ScriptCache.userIdentify.gcF = {};
    GG.ScriptCache.userIdentify.gcF.is_Internal = function(...): boolean?
        return GG.ScriptCache.userIdentify.is_Internal;
    end;
    GG.ScriptCache.userIdentify.gcF.get_device = function(...): boolean?
        return GG.ScriptCache.userIdentify.device;
    end;
    GG.ScriptCache.userIdentify.gcF.is_exec_white = function(...): boolean?
        return GG.ScriptCache.userIdentify.is_executor_WhiteList;
    end;
    GG.ScriptCache.userIdentify.gcF.getunc_infos = function(...): boolean?
        return GG.ScriptCache.userIdentify.unc_infos;
    end;

    GG.ScriptCache.userIdentify.secureEnv = function(index: string, env: (...any) -> nil)
        if clonefunction and env and typeof(env) == 'function' then
            GG[index] = clonefunction(env);
        else
            if typeof(env) ~= 'function' then
                print(index, typeof(env));
            end;
            GG[index] = env;
        end;
    end;
    GG.ScriptCache.userIdentify.secureEnvS = function(index: string, service : string): userdata?
        if cloneref and service then
            GG[index] = cloneref(GetService(game, service));
        else
            GG[index] = service;
        end;
    end;
end;

if not GG.ScriptCache.userIdentify.is_loaded_lc then
    for i=1, 3 do
        local GlobalOneRunCall, GlobalOneRunError = pcall(function()
            GG.ScriptStatus = "Loading Secure Sequence";
            table.foreach(GG.SecureEnv, GG.ScriptCache.userIdentify.secureEnv);
            table.foreach(GG.SecureEnvS, GG.ScriptCache.userIdentify.secureEnvS);

            GG.SecureEnvR = {
                HttpGet = game.HttpGet;
                EnCodeJ = HttpService.JSONEncode;
                DeCodeJ = HttpService.JSONDecode;

                GetPivot = W.GetPivot;
                PivotTo = W.PivotTo;

                IsA = game.IsA;

                GetAttribute = game.GetAttribute;
                SetAttribute = game.SetAttribute;

                WaitForChild = game.WaitForChild;

                FindFirstChild = game.FindFirstChild;
                FindFirstChildOfClass = game.FindFirstChildOfClass;
                FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
                FindFirstAncestor = game.FindFirstAncestor;
                FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;
                FindFirstAncestorWhichIsA = game.FindFirstAncestorWhichIsA;

                GetChildren = game.GetChildren;
                GetDescendants = game.GetDescendants;

                Destroy = game.Destroy;

                Kick = P.LocalPlayer.Kick;
            };

            table.foreach(GG.SecureEnvR, GG.ScriptCache.userIdentify.secureEnv);

            GG.selff = P.LocalPlayer;
            GG.Cam = W.CurrentCamera;
            GG.cmdm = selff:GetMouse();
            GG.PSG = WaitForChild(selff, "PlayerGui", 999);
            GG.PlayerScripts = WaitForChild(selff, "PlayerScripts", 999);

            GG.selc = selff.Character;
            GG.Backpack = selff.Backpack;

            GG.HumRSelf = selc and FindFirstChild(selc, "HumanoidRootPart");
        end);

        if GlobalOneRunCall then
            GG.ScriptStatus = "Finished Loading Secure Sequence";
            GG.ScriptCache.userIdentify.is_loaded_lc = true;
        else
            if i >= 3 then
                game:GetService("Players").LocalPlayer:Kick("Please report this bug to discord server and provide your executor. : " .. GlobalOneRunError);
            end;
        end;
    end;
end;

GG.newcclosure = newcclosure or function(...)
    return ...;
end;

if type(GG.ScriptCache.userIdentify.device) == 'nil' then
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        GG.ScriptCache.userIdentify.device =  "Mobile";
    elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        GG.ScriptCache.userIdentify.device = "PC";
    elseif UserInputService.GamepadEnabled then
        GG.ScriptCache.userIdentify.device = "Console";
    else
        GG.ScriptCache.userIdentify.device = "Unknown";
    end;
end;

if type(GG.ScriptCache.userIdentify.unc_infos) ~= 'table' then
    GG.ScriptCache.userIdentify.unc_infos = {
        fireproximityprompt = (fireproximityprompt and getinfo(fireproximityprompt).what) or false;
        firetouchinterest = (firetouchinterest and getinfo(firetouchinterest).what) or false;
        isnetworkowner = (isnetworkowner and getinfo(isnetworkowner).what) or false;
        require = (require and getinfo(require).what) or false;
        request = (request and getinfo(request).what) or false;
        getgc = (getgc and getinfo(getgc).what) or false;
    };
end;

if type(GG.Load_Icona) == 'boolean' then
    GG.Load_Icona = function(...)
        local Icons = {
            ["lucide"] = { Spritesheets = {
                ["1"] = "rbxassetid://131526378523863",
                ["10"] = "rbxassetid://98656588890340",
                ["11"] = "rbxassetid://122516128999742",
                ["12"] = "rbxassetid://136045238860745",
                ["13"] = "rbxassetid://138056954680929",
                ["14"] = "rbxassetid://139241675471365",
                ["15"] = "rbxassetid://120281540002144",
                ["16"] = "rbxassetid://122481504913348",
                ["2"] = "rbxassetid://125136326597802",
                ["3"] = "rbxassetid://132619645919851",
                ["4"] = "rbxassetid://124546836680911",
                ["5"] = "rbxassetid://138714413596023",
                ["6"] = "rbxassetid://95318701976229",
                ["7"] = "rbxassetid://87465848394141",
                ["8"] = "rbxassetid://77771201330939",
                ["9"] = "rbxassetid://126006375824005",
            }, Icons = {
                    ["a-arrow-down"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["a-arrow-up"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["a-large-small"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["accessibility"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["activity"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["air-vent"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["airplay"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["alarm-clock-check"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["alarm-clock-minus"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["alarm-clock-off"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["alarm-clock-plus"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["alarm-clock"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["alarm-smoke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["album"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-center-horizontal"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-center-vertical"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-center"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-end-horizontal"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-end-vertical"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-distribute-center"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-distribute-end"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-distribute-start"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-justify-center"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-justify-end"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-justify-start"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-space-around"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-horizontal-space-between"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-justify"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-left"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-right"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-start-horizontal"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-start-vertical"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-distribute-center"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-distribute-end"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-distribute-start"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-justify-center"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-justify-end"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-justify-start"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-space-around"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["align-vertical-space-between"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["ambulance"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["ampersand"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["ampersands"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["amphora"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["anchor"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["angry"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["annoyed"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["antenna"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["anvil"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["aperture"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["app-window-mac"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["app-window"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["apple"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["archive-restore"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["archive-x"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["archive"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["armchair"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-down-dash"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-down"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-left-dash"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-left"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-right-dash"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-right"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-up-dash"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-big-up"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-0-1"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-1-0"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-a-z"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-from-line"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-left"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-narrow-wide"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-right"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-to-dot"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-to-line"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-up"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-wide-narrow"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down-z-a"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-down"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-left-from-line"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-left-right"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-left-to-line"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-left"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-right-from-line"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-right-left"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-right-to-line"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-right"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-0-1"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-1-0"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-a-z"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-down"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-from-dot"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-from-line"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-left"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-narrow-wide"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-right"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-to-line"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-wide-narrow"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up-z-a"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrow-up"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["arrows-up-from-line"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                        },
                    ["asterisk"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["at-sign"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["atom"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["audio-lines"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["audio-waveform"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["award"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["axe"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["axis-3d"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["baby"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["backpack"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-alert"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-cent"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-check"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-dollar-sign"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-euro"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-help"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-indian-rupee"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-info"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-japanese-yen"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-minus"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-percent"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-plus"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-pound-sterling"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-russian-ruble"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-swiss-franc"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge-x"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["badge"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["baggage-claim"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["ban"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["banana"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bandage"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["banknote"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["barcode"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["baseline"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bath"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery-charging"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery-full"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery-low"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery-medium"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery-plus"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery-warning"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["battery"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["beaker"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bean-off"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bean"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bed-double"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bed-single"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bed"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["beef"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["beer-off"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["beer"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell-dot"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell-electric"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell-minus"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell-off"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell-plus"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell-ring"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bell"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["between-horizontal-end"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["between-horizontal-start"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["between-vertical-end"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["between-vertical-start"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["biceps-flexed"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bike"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["binary"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["binoculars"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["biohazard"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bird"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bitcoin"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["blend"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["blinds"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["blocks"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bluetooth-connected"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bluetooth-off"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bluetooth-searching"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bluetooth"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bold"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bolt"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bomb"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["bone"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-a"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-audio"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-check"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-copy"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-dashed"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-down"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-headphones"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-heart"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-image"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-key"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-lock"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-marked"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-minus"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-open-check"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-open-text"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-open"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-plus"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-text"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-type"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-up-2"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                        },
                    ["book-up"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["book-user"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["book-x"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["book"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bookmark-check"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bookmark-minus"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bookmark-plus"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bookmark-x"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bookmark"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["boom-box"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bot-message-square"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bot-off"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bot"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["box"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["boxes"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["braces"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["brackets"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["brain-circuit"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["brain-cog"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["brain"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["brick-wall"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["briefcase-business"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["briefcase-conveyor-belt"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["briefcase-medical"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["briefcase"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bring-to-front"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["brush"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bug-off"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bug-play"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bug"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["building-2"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["building"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bus-front"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["bus"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cable-car"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cable"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cake-slice"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cake"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calculator"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-1"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-arrow-down"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-arrow-up"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-check-2"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-check"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-clock"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-cog"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-days"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-fold"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-heart"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-minus-2"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-minus"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-off"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-plus-2"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-plus"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-range"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-search"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-sync"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-x-2"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar-x"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["calendar"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["camera-off"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["camera"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["candy-cane"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["candy-off"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["candy"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cannabis"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["captions-off"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["captions"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["car-front"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["car-taxi-front"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["car"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["caravan"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["carrot"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["case-lower"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["case-sensitive"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["case-upper"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cassette-tape"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cast"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["castle"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cat"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["cctv"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-area"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-bar-big"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-bar-decreasing"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-bar-increasing"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-bar-stacked"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-bar"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-candlestick"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-column-big"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-column-decreasing"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-column-increasing"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-column-stacked"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-column"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-gantt"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-line"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-network"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-no-axes-column-decreasing"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-no-axes-column-increasing"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-no-axes-column"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-no-axes-combined"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                        },
                    ["chart-no-axes-gantt"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chart-pie"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chart-scatter"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chart-spline"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["check-check"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["check"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chef-hat"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["cherry"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevron-down"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevron-first"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevron-last"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevron-left"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevron-right"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevron-up"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-down-up"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-down"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-left-right-ellipsis"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-left-right"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-left"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-right-left"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-right"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-up-down"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chevrons-up"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["chrome"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["church"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["cigarette-off"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["cigarette"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-alert"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-down"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-left"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-out-down-left"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-out-down-right"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-out-up-left"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-out-up-right"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-right"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-arrow-up"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-check-big"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-check"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-chevron-down"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-chevron-left"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-chevron-right"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-chevron-up"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-dashed"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-divide"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-dollar-sign"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-dot-dashed"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-dot"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-ellipsis"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-equal"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-fading-arrow-up"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-fading-plus"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-gauge"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-help"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-minus"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-off"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-parking-off"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-parking"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-pause"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-percent"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-play"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-plus"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-power"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-slash-2"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-slash"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-stop"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-user-round"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-user"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle-x"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circle"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["circuit-board"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["citrus"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clapperboard"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-check"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-copy"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-list"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-minus"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-paste"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-pen-line"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-pen"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-plus"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-type"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard-x"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clipboard"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-1"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-10"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-11"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-12"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-2"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-3"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-4"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-5"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-6"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-7"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-8"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-9"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-alert"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-arrow-down"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock-arrow-up"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["clock"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["cloud-alert"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                        },
                    ["cloud-cog"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-download"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-drizzle"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-fog"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-hail"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-lightning"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-moon-rain"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-moon"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-off"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-rain-wind"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-rain"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-snow"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-sun-rain"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-sun"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud-upload"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloud"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cloudy"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["clover"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["club"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["code-xml"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["code"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["codepen"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["codesandbox"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["coffee"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cog"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["coins"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["columns-2"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["columns-3"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["columns-4"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["combine"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["command"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["compass"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["component"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["computer"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["concierge-bell"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cone"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["construction"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["contact-round"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["contact"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["container"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["contrast"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cookie"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cooking-pot"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copy-check"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copy-minus"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copy-plus"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copy-slash"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copy-x"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copy"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copyleft"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["copyright"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-down-left"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-down-right"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-left-down"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-left-up"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-right-down"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-right-up"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-up-left"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["corner-up-right"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cpu"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["creative-commons"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["credit-card"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["croissant"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["crop"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cross"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["crosshair"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["crown"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cuboid"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cup-soda"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["currency"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["cylinder"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dam"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["database-backup"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["database-zap"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["database"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["delete"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dessert"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["diameter"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["diamond-minus"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["diamond-percent"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["diamond-plus"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["diamond"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dice-1"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dice-2"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dice-3"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dice-4"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dice-5"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dice-6"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dices"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["diff"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["disc-2"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["disc-3"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["disc-album"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["disc"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["divide"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dna-off"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dna"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dock"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dog"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["dollar-sign"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                        },
                    ["donut"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["door-closed"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["door-open"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["dot"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["download"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["drafting-compass"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["drama"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["dribbble"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["drill"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["droplet-off"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["droplet"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["droplets"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["drum"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["drumstick"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["dumbbell"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["ear-off"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["ear"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["earth-lock"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["earth"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["eclipse"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["egg-fried"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["egg-off"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["egg"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["ellipsis-vertical"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["ellipsis"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["equal-approximately"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["equal-not"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["equal"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["eraser"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["ethernet-port"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["euro"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["expand"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["external-link"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["eye-closed"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["eye-off"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["eye"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["facebook"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["factory"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["fan"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["fast-forward"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["feather"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["fence"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["ferris-wheel"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["figma"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-archive"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-audio-2"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-audio"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-axis-3d"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-badge-2"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-badge"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-box"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-chart-column-increasing"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-chart-column"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-chart-line"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-chart-pie"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-check-2"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-check"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-clock"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-code-2"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-code"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-cog"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-diff"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-digit"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-down"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-heart"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-image"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-input"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-json-2"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-json"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-key-2"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-key"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-lock-2"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-lock"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-minus-2"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-minus"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-music"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-output"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-pen-line"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-pen"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-plus-2"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-plus"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-question"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-scan"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-search-2"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-search"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-sliders"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-spreadsheet"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-stack"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-symlink"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-terminal"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-text"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-type-2"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-type"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-up"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-user"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-video-2"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-video"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-volume-2"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-volume"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-warning"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                        },
                    ["file-x-2"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["file-x"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["file"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["files"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["film"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["filter-x"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["filter"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fingerprint"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fire-extinguisher"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fish-off"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fish-symbol"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fish"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flag-off"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flag-triangle-left"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flag-triangle-right"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flag"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flame-kindling"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flame"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flashlight-off"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flashlight"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flask-conical-off"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flask-conical"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flask-round"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flip-horizontal-2"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flip-horizontal"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flip-vertical-2"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flip-vertical"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flower-2"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["flower"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["focus"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fold-horizontal"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fold-vertical"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-archive"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-check"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-clock"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-closed"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-code"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-cog"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-dot"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-down"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-git-2"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-git"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-heart"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-input"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-kanban"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-key"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-lock"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-minus"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-open-dot"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-open"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-output"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-pen"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-plus"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-root"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-search-2"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-search"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-symlink"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-sync"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-tree"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-up"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder-x"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folder"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["folders"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["footprints"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["forklift"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["forward"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["frame"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["framer"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["frown"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fuel"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["fullscreen"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gallery-horizontal-end"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gallery-horizontal"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gallery-thumbnails"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gallery-vertical-end"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gallery-vertical"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gamepad-2"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gamepad"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gauge"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gavel"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gem"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["ghost"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gift"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-branch-plus"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-branch"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-commit-horizontal"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-commit-vertical"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-compare-arrows"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-compare"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-fork"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-graph"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-merge"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-pull-request-arrow"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-pull-request-closed"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-pull-request-create-arrow"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-pull-request-create"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-pull-request-draft"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["git-pull-request"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["github"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["gitlab"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                        },
                    ["glass-water"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["glasses"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["globe-lock"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["globe"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["goal"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grab"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["graduation-cap"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grape"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grid-2x2-check"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grid-2x2-plus"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grid-2x2-x"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grid-2x2"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grid-3x3"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grip-horizontal"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grip-vertical"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["grip"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["group"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["guitar"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["ham"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hammer"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hand-coins"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hand-heart"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hand-helping"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hand-metal"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hand-platter"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hand"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["handshake"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hard-drive-download"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hard-drive-upload"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hard-drive"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hard-hat"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hash"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["haze"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hdmi-port"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading-1"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading-2"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading-3"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading-4"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading-5"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading-6"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heading"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["headphone-off"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["headphones"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["headset"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heart-crack"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heart-handshake"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heart-off"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heart-pulse"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heart"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["heater"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hexagon"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["highlighter"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["history"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hop-off"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hop"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hospital"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hotel"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["hourglass"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["house-plug"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["house-plus"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["house-wifi"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["house"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["ice-cream-bowl"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["ice-cream-cone"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["id-card"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-down"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-minus"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-off"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-play"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-plus"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-up"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image-upscale"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["image"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["images"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["import"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["inbox"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["indent-decrease"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["indent-increase"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["indian-rupee"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["infinity"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["info"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["inspection-panel"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["instagram"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["italic"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["iteration-ccw"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["iteration-cw"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["japanese-yen"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["joystick"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["kanban"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["key-round"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["key-square"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["key"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["keyboard-music"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["keyboard-off"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["keyboard"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["lamp-ceiling"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["lamp-desk"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["lamp-floor"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["lamp-wall-down"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["lamp-wall-up"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                        },
                    ["lamp"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["land-plot"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["landmark"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["languages"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["laptop-minimal-check"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["laptop-minimal"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["laptop"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lasso-select"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lasso"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["laugh"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layers-2"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layers"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layout-dashboard"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layout-grid"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layout-list"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layout-panel-left"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layout-panel-top"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["layout-template"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["leaf"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["leafy-green"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lectern"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["letter-text"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["library-big"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["library"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["life-buoy"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["ligature"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lightbulb-off"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lightbulb"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["link-2-off"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["link-2"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["link"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["linkedin"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-check"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-checks"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-collapse"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-end"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-filter-plus"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-filter"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-minus"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-music"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-ordered"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-plus"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-restart"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-start"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-todo"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-tree"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-video"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list-x"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["list"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["loader-circle"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["loader-pinwheel"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["loader"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["locate-fixed"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["locate-off"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["locate"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lock-keyhole-open"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lock-keyhole"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lock-open"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lock"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["log-in"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["log-out"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["logs"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["lollipop"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["luggage"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["magnet"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-check"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-minus"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-open"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-plus"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-question"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-search"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-warning"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail-x"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mail"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mailbox"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["mails"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-check-inside"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-check"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-house"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-minus-inside"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-minus"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-off"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-plus-inside"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-plus"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-x-inside"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin-x"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pin"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-pinned"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map-plus"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["map"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["martini"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["maximize-2"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["maximize"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["medal"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["megaphone-off"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["megaphone"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["meh"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["memory-stick"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["menu"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["merge"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                        },
                    ["message-circle-code"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-dashed"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-heart"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-more"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-off"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-plus"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-question"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-reply"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-warning"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle-x"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-circle"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-code"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-dashed"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-diff"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-dot"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-heart"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-lock"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-more"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-off"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-plus"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-quote"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-reply"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-share"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-text"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-warning"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square-x"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["message-square"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["messages-square"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mic-off"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mic-vocal"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mic"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["microchip"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["microscope"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["microwave"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["milestone"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["milk-off"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["milk"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["minimize-2"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["minimize"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["minus"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-check"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-cog"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-dot"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-down"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-off"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-pause"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-play"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-smartphone"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-speaker"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-stop"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-up"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor-x"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["monitor"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["moon-star"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["moon"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mountain-snow"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mountain"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mouse-off"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mouse-pointer-2"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mouse-pointer-ban"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mouse-pointer-click"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mouse-pointer"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["mouse"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-3d"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-diagonal-2"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-diagonal"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-down-left"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-down-right"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-down"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-horizontal"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-left"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-right"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-up-left"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-up-right"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-up"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move-vertical"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["move"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["music-2"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["music-3"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["music-4"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["music"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["navigation-2-off"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["navigation-2"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["navigation-off"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["navigation"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["network"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["newspaper"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["nfc"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["notebook-pen"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["notebook-tabs"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["notebook-text"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["notebook"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["notepad-text-dashed"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["notepad-text"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["nut-off"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["nut"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["octagon-alert"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["octagon-minus"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["octagon-pause"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["octagon-x"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                        },
                    ["octagon"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["omega"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["option"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["orbit"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["origami"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-2"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-check"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-minus"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-open"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-plus"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-search"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package-x"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["package"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["paint-bucket"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["paint-roller"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["paintbrush-vertical"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["paintbrush"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["palette"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-bottom-close"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-bottom-dashed"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-bottom-open"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-bottom"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-left-close"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-left-dashed"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-left-open"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-left"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-right-close"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-right-dashed"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-right-open"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-right"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-top-close"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-top-dashed"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-top-open"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panel-top"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panels-left-bottom"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panels-right-bottom"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["panels-top-left"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["paperclip"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["parentheses"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["parking-meter"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["party-popper"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pause"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["paw-print"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pc-case"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pen-line"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pen-off"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pen-tool"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pen"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pencil-line"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pencil-off"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pencil-ruler"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pencil"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pentagon"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["percent"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["person-standing"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["philippine-peso"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone-call"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone-forwarded"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone-incoming"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone-missed"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone-off"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone-outgoing"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["phone"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pi"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["piano"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pickaxe"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["picture-in-picture-2"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["picture-in-picture"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["piggy-bank"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pilcrow-left"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pilcrow-right"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pilcrow"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pill-bottle"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pill"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pin-off"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pin"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pipette"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pizza"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plane-landing"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plane-takeoff"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plane"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["play"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plug-2"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plug-zap"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plug"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["plus"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pocket-knife"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pocket"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["podcast"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pointer-off"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pointer"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["popcorn"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["popsicle"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["pound-sterling"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["power-off"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["power"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["presentation"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["printer-check"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["printer"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["projector"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 11,
                        },
                    ["proportions"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["puzzle"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["pyramid"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["qr-code"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["quote"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rabbit"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radar"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radiation"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radical"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radio-receiver"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radio-tower"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radio"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["radius"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rail-symbol"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rainbow"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rat"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["ratio"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-cent"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-euro"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-indian-rupee"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-japanese-yen"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-pound-sterling"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-russian-ruble"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-swiss-franc"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt-text"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["receipt"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rectangle-ellipsis"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rectangle-horizontal"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rectangle-vertical"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["recycle"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["redo-2"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["redo-dot"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["redo"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["refresh-ccw-dot"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["refresh-ccw"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["refresh-cw-off"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["refresh-cw"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["refrigerator"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["regex"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["remove-formatting"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["repeat-1"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["repeat-2"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["repeat"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["replace-all"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["replace"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["reply-all"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["reply"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rewind"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["ribbon"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rocket"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rocking-chair"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["roller-coaster"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rotate-3d"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rotate-ccw-square"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rotate-ccw"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rotate-cw-square"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rotate-cw"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["route-off"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["route"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["router"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rows-2"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rows-3"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rows-4"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["rss"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["ruler"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["russian-ruble"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["sailboat"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["salad"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["sandwich"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["satellite-dish"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["satellite"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["save-all"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["save-off"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["save"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scale-3d"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scale"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scaling"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-barcode"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-eye"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-face"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-heart"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-line"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-qr-code"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-search"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan-text"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scan"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["school"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scissors-line-dashed"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scissors"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["screen-share-off"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["screen-share"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scroll-text"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["scroll"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["search-check"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["search-code"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["search-slash"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["search-x"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["search"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["section"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["send-horizontal"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 12,
                        },
                    ["send-to-back"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["send"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["separator-horizontal"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["separator-vertical"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["server-cog"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["server-crash"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["server-off"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["server"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["settings-2"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["settings"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shapes"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["share-2"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["share"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sheet"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shell"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-alert"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-ban"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-check"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-ellipsis"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-half"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-minus"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-off"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-plus"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-question"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield-x"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shield"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["ship-wheel"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["ship"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shirt"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shopping-bag"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shopping-basket"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shopping-cart"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shovel"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shower-head"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shrink"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shrub"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["shuffle"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sigma"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signal-high"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signal-low"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signal-medium"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signal-zero"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signal"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signature"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signpost-big"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["signpost"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["siren"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["skip-back"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["skip-forward"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["skull"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["slack"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["slash"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["slice"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sliders-horizontal"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sliders-vertical"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["smartphone-charging"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["smartphone-nfc"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["smartphone"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["smile-plus"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["smile"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["snail"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["snowflake"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sofa"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["soup"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["space"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["spade"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sparkle"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sparkles"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["speaker"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["speech"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["spell-check-2"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["spell-check"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["spline"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["split"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["spray-can"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["sprout"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-activity"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-down-left"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-down-right"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-down"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-left"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-out-down-left"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-out-down-right"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-out-up-left"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-out-up-right"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-right"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-up-left"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-up-right"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-arrow-up"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-asterisk"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-bottom-dashed-scissors"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-chart-gantt"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-check-big"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-check"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-chevron-down"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-chevron-left"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-chevron-right"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-chevron-up"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-code"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-dashed-bottom-code"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 13,
                        },
                    ["square-dashed-bottom"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-dashed-kanban"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-dashed-mouse-pointer"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-dashed"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-divide"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-dot"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-equal"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-function"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-kanban"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-library"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-m"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-menu"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-minus"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-mouse-pointer"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-parking-off"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-parking"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-pen"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-percent"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-pi"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-pilcrow"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-play"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-plus"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-power"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-radical"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-scissors"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-sigma"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-slash"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-split-horizontal"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-split-vertical"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-square"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-stack"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-terminal"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-user-round"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-user"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square-x"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["square"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["squircle"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["squirrel"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["stamp"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["star-half"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["star-off"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["star"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["step-back"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["step-forward"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["stethoscope"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sticker"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sticky-note"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["store"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["stretch-horizontal"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["stretch-vertical"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["strikethrough"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["subscript"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sun-dim"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sun-medium"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sun-moon"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sun-snow"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sun"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sunrise"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sunset"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["superscript"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["swatch-book"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["swiss-franc"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["switch-camera"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["sword"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["swords"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["syringe"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-2"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-cells-merge"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-cells-split"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-columns-split"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-of-contents"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-properties"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table-rows-split"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["table"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tablet-smartphone"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tablet"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tablets"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tag"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tags"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tally-1"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tally-2"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tally-3"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tally-4"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tally-5"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tangent"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["target"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["telescope"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tent-tree"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["tent"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["terminal"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["test-tube-diagonal"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["test-tube"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["test-tubes"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["text-cursor-input"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["text-cursor"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["text-quote"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["text-search"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["text-select"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["text"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["theater"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 14,
                        },
                    ["thermometer-snowflake"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["thermometer-sun"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["thermometer"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["thumbs-down"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["thumbs-up"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket-check"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket-minus"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket-percent"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket-plus"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket-slash"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket-x"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ticket"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tickets-plane"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tickets"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["timer-off"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["timer-reset"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["timer"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["toggle-left"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["toggle-right"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["toilet"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tornado"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["torus"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["touchpad-off"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["touchpad"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tower-control"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["toy-brick"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tractor"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["traffic-cone"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["train-front-tunnel"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["train-front"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["train-track"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tram-front"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trash-2"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trash"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tree-deciduous"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tree-palm"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tree-pine"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trees"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trello"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trending-down"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trending-up-down"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trending-up"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["triangle-alert"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["triangle-dashed"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["triangle-right"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["triangle"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["trophy"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["truck"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["turtle"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tv-minimal-play"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tv-minimal"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["tv"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["twitch"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["twitter"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["type-outline"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["type"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["umbrella-off"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["umbrella"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["underline"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["undo-2"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["undo-dot"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["undo"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["unfold-horizontal"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["unfold-vertical"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["ungroup"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["university"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["unlink-2"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["unlink"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["unplug"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["upload"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["usb"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-check"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-cog"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-minus"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-pen"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-plus"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-check"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-cog"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-minus"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-pen"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-plus"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-search"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round-x"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-round"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-search"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user-x"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["user"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["users-round"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["users"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["utensils-crossed"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["utensils"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["utility-pole"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["variable"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["vault"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["vegan"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["venetian-mask"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["vibrate-off"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["vibrate"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["video-off"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["video"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 15,
                        },
                    ["videotape"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["view"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["voicemail"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["volleyball"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["volume-1"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["volume-2"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["volume-off"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["volume-x"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["volume"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["vote"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wallet-cards"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wallet-minimal"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wallet"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wallpaper"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wand-sparkles"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wand"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["warehouse"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["washing-machine"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["watch"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["waves-ladder"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["waves"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["waypoints"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["webcam"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["webhook-off"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["webhook"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["weight"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wheat-off"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wheat"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["whole-word"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wifi-high"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wifi-low"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wifi-off"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wifi-zero"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wifi"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wind-arrow-down"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wind"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wine-off"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wine"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["workflow"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["worm"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wrap-text"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["wrench"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["x"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["youtube"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["zap-off"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["zap"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["zoom-in"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                    ["zoom-out"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 16,
                        },
                }
            },
            ["craft"] = { Spritesheets = {
                ["1"] = "rbxassetid://70631241282259",
                ["2"] = "rbxassetid://90196769916139",
                ["3"] = "rbxassetid://77139486329738",
                ["4"] = "rbxassetid://116504596652500",
                ["5"] = "rbxassetid://122943914188262",
                ["6"] = "rbxassetid://91799809699230",
                ["7"] = "rbxassetid://98948000058600",
                ["8"] = "rbxassetid://130202200859762",
                ["9"] = "rbxassetid://107947096000444",
                ["10"] = "rbxassetid://74032637954135",
            }, Icons = {
                    ["2d-axis-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["3d-axis-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["Allah-stroke-1"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["Allah-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["accessibility-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["add-bottom-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["add-plus-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["add-plus-square-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["add-plus-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["add-top-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["air-conditionar-ac-off-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["air-conditionar-ac-on-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["airbnb-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["airplay-stroke-1"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["airplay-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["airpods-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alarm-add-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alarm-check-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alarm-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alarm-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alarm-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alert-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alert-hexagon-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["alert-triangle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-bottom-left-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-bottom-right-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-center-horizontal-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-center-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-center-vertical-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-corner-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-corner-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-distribute-center-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-distribute-end-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-distribute-start-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-justify-center-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-justify-end-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-justify-start-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-space-around-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-space-between-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-horizontal-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-left-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-right-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-top-left-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-top-right-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-distribute-center-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-distribute-end-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-distribute-start-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-justify-center-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-justify-end-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-justify-start-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-space-around-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-space-between-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["align-vertical-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["anchor-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["angle-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["anker-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["anonymous-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["apple-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["apple-watch-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["arabic-letter-ayin-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["arabic-letter-ta-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["archive-box-download-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["archive-box-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["archive-box-upload-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["arrow-demarge-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["arrow-merge-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["asterisk-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["at-the-rate-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["atm-card-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["attachment-paperclip-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["back-to-start-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["backspace-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["backward-item-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bank-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["barbell-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["barchart-down-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["barchart-line-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["barchart-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["barchart-up-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["baseline-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bathtub-shower-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["battery-alert-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["battery-charging-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["battery-empty-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["battery-full-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["battery-low-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["battery-medium-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["beaker-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["beaker-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["beaker-03-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["beaker-04-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bed-double-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bed-single-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bed-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["beer-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["behance-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bike-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["binance-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["binary-numberes-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bing-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 1,
                    },
                    ["bitcoin-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bitcoin-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["blender-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bluetooth-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bluetooth-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bluetooth-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bluetooth-network-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bold-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bolt-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bolt-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bolt-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bomb-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bone-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-02-check-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-02-search-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-audiobook-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-dictionary-bookmark-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-dictionary-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["book-text-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-add-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-add-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-multiple-01-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-multiple-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-remove-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-remove-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bookmark-time-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bottom-align-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bottom-align-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bottom-align-03-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bottom-align-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["box-package-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["box-package-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["box-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["briefcase-job-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["briefcase-job-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-add-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-chec-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-dots-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-heart-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-text-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bubble-chat-unread-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["bug-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["building-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["building-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["building-03-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["building-04-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["building-05-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["building-06-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["burger-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calculator-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-add-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-add-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-check-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-check-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-cross-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-cross-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-cross-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-download-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-heart-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-remove-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-remove-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-search-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-sticker-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-text-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-time-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["calendar-upload-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["camera-image-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["camera-image-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["camera-lens-snap-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["camera-lens-snap-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["cancel-forbidden-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["capsul-tablet-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["car-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["car-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chart-line-down-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chart-line-horizontal-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chart-line-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chart-line-up-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["check-square-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["check-square-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["check-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-down-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-down-square-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-left-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-left-square-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-right-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-right-square-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-up-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chevron-up-square-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["choice-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 2,
                    },
                    ["chrome-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["circle-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["circle-sticker-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-edit-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-export-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-import-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-save-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-search-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["clipboard-text-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-bolt-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-bolt-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-mist-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-moon-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-multiple-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-multiple-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-rain-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-rain-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-set-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-snow-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-sun-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-sun-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-sun-03-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-sun-04-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-sun-05-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cloud-sun-06-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["code-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["code-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["code-03-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["code-04-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["code-05-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["code-chat-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["codepen-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coffee-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cog-settings-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cog-settings-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cog-settings-03-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cog-settings-04-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cog-settings-05-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coin-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coins-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coins-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coins-one-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coins-stack-01-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["coins-stack-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["color-palette-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["color-palette-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["color-roller-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["color-roller-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["command-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["comment-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["comment-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["comment-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["component-child-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["component-parent-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["computer-monitor-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["computer-monitor-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["computer-monitor-03-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["computer-monitor-chat-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["connection"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["contrast-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["copy-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["copy-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["copy-check-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["copy-sticker-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cpu-chip-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-add-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-check-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-download-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-edit-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-lock-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-refresh-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-search-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-card-upload-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["credit-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cricket-ball-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["croissant-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cross-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cross-hexagon-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cross-multiply-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cross-multiply-square-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cross-multiply-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cross-token-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["crosshair-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cruptocurrency-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cruptocurrency-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cube-box-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cube-box-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["cup-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["currency-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["dashboard-01-add-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["dashboard-01-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["dashboard-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["dashboard-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["dashboard-vertical-1-2-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 3,
                    },
                    ["dashboard-vertical-2-1-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["data-flow-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["data-flow-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["data-transfer-horizontal-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["data-transfer-horizontal-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["data-transfer-vertical-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["data-transfer-vertical-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["database-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["delete-bin-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["delete-bin-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["details-grid-more-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["details-horizontal-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["details-vertical-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["diamond-shield-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dice-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dice-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dice-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dice-04-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dice-05-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dice-06-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["discord-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dislike-thumbsdown-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["divert-left-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["divert-right-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["divide-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["divide-square-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["divide-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dollar-currncy-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["double-check-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["double-down-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["double-left-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["double-right-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["double-up-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-big-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-left-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-left-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-left-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-return-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-right-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-right-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["down-right-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["download-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["download-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["download-cloud-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["drag-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["drag-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dribbble-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dropbox-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dual-simcard-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["dumbbell -stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["duplicate-add-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["duplicate-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["edit-pen-01-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["edit-pen-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["edit-pencil-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["edit-pencil-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["edit-pencil-03-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["edit-pencil-04-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["egg-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["egg-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["enter-login-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["enter-login-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["enter-login-03-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["envato-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["equal-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["equal-square-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["equal-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["eraser-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["eraser-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["eraser-03-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["euro-currncy-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["exit-logout-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["exit-logout-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["exit-logout-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-03-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-corner-01-stroke-1"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-corner-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-corner-02-stroke-1"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-corner-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-horizontal-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-horizontal-stroke-1"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-horizontal-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-vertical-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-vertical-stroke-1"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["expand-vertical-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["eye-close-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["eye-view-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["facebook-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["facebook-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["figma-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["film-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["film-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["film-03-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["film-04-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["filter-sort-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["fire-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["flag-01-stroke-1"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 4,
                    },
                    ["flag-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flag-02-stroke-1"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flag-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flag-03-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flex-align-bottom-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flex-align-left-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flex-align-right-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flex-align-top-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["flower-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-add-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-cros-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-delete-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-search-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["folder-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["football-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["forward-item-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["frame-01-stroke-1"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["frame-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["framer-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gift-sadaqa-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gift-sadaqa-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-branch-add-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-branch-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-branch-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-branch-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-commit-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-compare-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-fork-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-fork-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-pull-request-closed-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-pull-request-draft-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["git-pull-request-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["github-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gitlab-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["globe-web-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["globe-web-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["google-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gps-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gps-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["graduation-hat-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["grave-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-bottom-left-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-bottom-middle-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-bottom-right-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-middle-left-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-middle-middle-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-middle-right-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-top-left-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-top-middle-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["gravity-top-right-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["grid-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["halal-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["hamburger-menu-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["hammar-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["hash-tag-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-03-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-04-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-05-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-06-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heading-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heart-rate-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heart-rate-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heart-react-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["heart-react-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["hell-fire-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["highlight-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["highlight-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-03-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-04-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-05-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-06-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["home-07-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["icon-candy-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["imac-computer-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["image-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["image-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["image-03-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["image-add-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["image-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["image-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["import-export-horizontal-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["import-export-horizontal-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["import-export-vertical-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["import-export-vertical-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["import-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["inbox-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["inbox-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["inbox-in-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["inbox-out-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["info-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["info-hexagon-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["info-triangle-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["instagram-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["iphone-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 5,
                    },
                    ["italic-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["juice-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["kaaba-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["kaaba-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["kaaba-03-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["key-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["keyboard-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["king-crown-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lamp-ceiling-light-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lamp-floor-light-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lamp-light-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lamp-ramadan-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["laptop-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["leetcode-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-align-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-align-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-align-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-align-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-big-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-down-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-return-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-right-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["left-up-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lemon-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["library-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["library-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["library-03-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lightbulb-idea-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lightbulb-idea-02-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lightbulb-idea-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["like-thumbsup-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["link-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["link-02-stroke-1"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["link-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["link-03-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["linked-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["loading-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["loading-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["location-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["location-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lock-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["lock-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["luggage-01-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["luggage-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["luggage-03-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["mac-mini-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["mac-studio-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["macbook-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["madina-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["map-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["map-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["map-pin-area-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["map-pin-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["maximize-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["maximize-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["maximize-03-placeholder-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["meal-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["medical-sign-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["medical-sign-square-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["medical-sign-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["medicine-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-add-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-alart-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-check-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-dots-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-03-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-add-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-export-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-import-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-open-01-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-open-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-open-note-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-search-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-unread-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-email-write-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-heart-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-question-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-add-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-chec-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-dots-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-stroke-1"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-square-text-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-text-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["message-unread-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["messenger-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["meta-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["micro-bus-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 6,
                    },
                    ["microphone-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["microphone-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["microphone-mute-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["minimize-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["minimize-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["minimize-horizontal-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["minimize-vertical-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mirroring-screen-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mobile-chat-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mobile-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["money-bag-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["money-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["moon-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["moon-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["moon-star-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mosque-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mountain-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-left-click-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-right-click-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-scroll-down-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-scroll-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-scroll-up-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-signal-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["mouse-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["multiple-cards-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["muslim-family-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["muslim-female-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["muslim-male-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["nft-add-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["nft-export-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["nft-import-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["nft-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["nft-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["not-equal-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["not-equal-square-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["not-equal-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-01-check-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-01-edit-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-01-search-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-01-text-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-02-bookmark-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-02-check-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-02-delete-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-02-edit-stroke-1"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-02-edit-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-02-sticker-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-03-check-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-03-download-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-03-search-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-03-sticker-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-03-text-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-03-upload-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["note-question"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notebook-edit-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notebook-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notebook-text-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-add-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-add-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-alarm-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-check-01-stroke-1"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-check-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-cross-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-cross-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-live-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-mute-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-remove-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-remove-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notification-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["notion-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["numberes-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["one-layer-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["openai-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["opera-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["paint-brush-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["paint-brush-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["passport-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pause-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pause-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pause-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pause-square-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pdf-note-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pendrive-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["people-add-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["people-group-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["people-group-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["people-message-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["people-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["perfume-atar-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-add-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-calling-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-cancel-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-incoming-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-missed-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-outgoing-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["phone-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pie-chart-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pie-chart-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pie-chart-03-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pin-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 7,
                    },
                    ["pin-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["pin-03-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["pins-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["pinterest-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["pizza-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["place-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["plane-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["play-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["play-play-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["play-square-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["play-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["plus-minus-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["plus-minus-square-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["plus-minus-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["pray-dua-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prayer-mat-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["printer-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-cup-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-first-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-medal-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-medal-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-medal-03-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-second-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prize-third-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["profile-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["profile-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["profile-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["profile-04-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["profile-05-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prophet-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["prophet-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["puzzle-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["puzzle-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["qr-code-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["qr-scan-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["queen-crown-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["question-help-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["question-help-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["quran-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["quran-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["quran-tafsir-01-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["quran-tafsir-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["radio-check-circle-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["radio-check-circle-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["radio-circle-selected-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["radio-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rain-moon-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rain-sun-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["receipt-check-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["receipt-download-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["receipt-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["receipt-text-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["receipt-upload-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["record-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-align-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-align-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-align-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-align-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-big-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-down-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-return-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["right-up-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["robot-stroke-1"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["robot-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rocket-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-acw-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-acw-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-acw-03-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-acw-04-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-cw-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-cw-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-cw-03-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-cw-04-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rotate-cw-dotted-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["ruble-currncy-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["rupee-currncy-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["sandwatch-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["sandwatch-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["save-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["scale-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["scale-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["scan-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["scissors-01-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["scissors-02-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["scissors-cut-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["sdcard-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["search-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-backward-10s-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-backward-15s-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-backward-5s-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-backward-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-forward-10s-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-forward-15s-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-forward-5s-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["seek-forward-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["send-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["send-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 8,
                    },
                    ["send-03-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["send-04-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["server-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["share-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["share-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["share-03-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["share-04-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["share-05-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-alert-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-check-02-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-cross-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-cross-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shield-search-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["ship-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shop-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shop-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shoping-bag-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shoping-bag-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shopping-cart-add-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shopping-cart-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["shopping-cart-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sidebar-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sidebar-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sidebar-03-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sidebar-04-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sidebar-hide-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sidebar-open-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["simcard-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sketch-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["skip-next-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["skip-previous-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["skip-to-end-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["slack-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sofa-seat-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-03-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-04-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-05-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-06-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-07-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sort-08-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["soundbox-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["space-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sparkle-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sparkle-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["speedmeter-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["speedmeter-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["speedmeter-03-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["star-rate-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["stethoscope-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["stone-grave-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["stop-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["stop-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["subtract-minus-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["subtract-minus-square-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["subtract-minus-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sun-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sun-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["sunset-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["swap-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["swap-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tablet-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tablets-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tag-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tag-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["taka-currncy-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tble-lamp-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tea-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["telegram-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["tennis-ball-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["terminal-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["terminal-square-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["text-center-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["text-left-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["text-right-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["threads-stroke-1"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["threads-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["three-layer-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["ticket-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["ticket-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-02-stroke-1"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-03-stroke-1"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-03-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-04-stroke-1"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-04-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-05-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-06-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-07-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-08-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-09-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-10-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-11-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["time-clock-12-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["timer-add-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["timer-remove-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 9,
                    },
                    ["timer-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["toggle-switch-off-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["toggle-switch-off-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["toggle-switch-off-03-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["toggle-switch-on-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["toggle-switch-on-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["toggle-switch-on-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["top-align-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["top-align-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["top-align-03-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 0),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["top-align-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["translate-language-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["trend-donw-square-stroeke"] = {
                        ImageRectPosition = Vector2.new(192, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["trend-down-presentation-stroeke"] = {
                        ImageRectPosition = Vector2.new(288, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["trend-down-stroeke"] = {
                        ImageRectPosition = Vector2.new(384, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["trend-up-presentation-stroeke"] = {
                        ImageRectPosition = Vector2.new(480, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["trend-up-square-stroeke"] = {
                        ImageRectPosition = Vector2.new(576, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["trend-up-stroeke"] = {
                        ImageRectPosition = Vector2.new(672, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["triangle-down-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["triangle-left-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 96),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["triangle-right-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["triangle-up-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["truck-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["tshirt-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["tune-music-01-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["tune-music-02-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["tune-music-03-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["tv-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["twitch-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["twitter-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 192),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["two-layer-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["uncheck-square-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["unlink-01-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["unlink-02-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["unlock-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["unpin-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-big-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 288),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-down-chevron-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-left-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-left-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-left-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-return-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-right-arrow-circle-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-right-arrow-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["up-right-flow-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["upload-01-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["upload-02-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 384),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["upload-cloud-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vanishing-bottom-left-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vanishing-bottom-right-left-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vanishing-square-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vanishing-top-left-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vanishing-top-right-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["verified-check-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["verified-check-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["verified-check-03-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-add-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 480),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-add-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-cross-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-cross-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-remove-01-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-remove-02-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["video-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["virus-01-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["virus-02-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["virus-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vision-pro-screen-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 576),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vision-pro-screen-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vision-pro-screen-03-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vision-pro-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["vision-pro-user-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["volume-cross-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["volume-high-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["volume-low-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["volume-medium-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["volume-mute-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wall-lamp-01-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 672),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wall-lamp-02-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wallet-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wallet-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wallet-03-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["water-glass-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["waterdrop-multiple-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["waterdrop-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["watermelon-01-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["watermelon-02-stroke"] = {
                        ImageRectPosition = Vector2.new(768, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["whatsapp-stroke"] = {
                        ImageRectPosition = Vector2.new(864, 768),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["windows-stroke"] = {
                        ImageRectPosition = Vector2.new(0, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wrist-watch-01-stroke"] = {
                        ImageRectPosition = Vector2.new(96, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["wrist-watch-02-stroke"] = {
                        ImageRectPosition = Vector2.new(192, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["x-twitter-stroke"] = {
                        ImageRectPosition = Vector2.new(288, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["yen-currncy-stroke"] = {
                        ImageRectPosition = Vector2.new(384, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["youtube-stroke"] = {
                        ImageRectPosition = Vector2.new(480, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["zoom-in-stroke"] = {
                        ImageRectPosition = Vector2.new(576, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                    ["zoom-out-stroke"] = {
                        ImageRectPosition = Vector2.new(672, 864),
                        ImageRectSize = Vector2.new(96, 96),
                        Image = 10,
                    },
                }
            }
        };
        
        local IconModule = {
            IconsType = "lucide"
        };
        
        function IconModule.SetIconsType(iconType)
            IconModule.IconsType = iconType;
        end;
        
        function IconModule.Icon(Icon, Type)
            local iconType = Icons[Type or IconModule.IconsType];
            
            if iconType.Icons[Icon] then
                return { iconType.Spritesheets[tos(iconType.Icons[Icon].Image)], iconType.Icons[Icon] };
            end;
            return nil;
        end;
        
        return IconModule;
    end;
end;

if not GG.loadsource then
    GG.loadsource = function(source : string): any
        local returnValue = nil;
        for attempt = 1, 3 do
            local success, result = pcal(function()
                return loadstring(source)();
            end);

            if success then
                return result;
            else
                warn(strformat("[Flow] : loadsource_err (Attempt %d): %s", attempt, result));
                twait();
            end;
        end;

        return returnValue;
    end;
end;
if not GG.loadScriptFromCache then
    GG.loadScriptFromCache = function( srcName : string , fileName : string , noload : boolean , custom_time : number , is_ignore : boolean )
        if LoaderSettings.AllowCache then
            local CD = custom_time or 600;
            local versionFile =  "FlowXSVersion.json"
            local cacheFile = "FlowXS/" .. fileName;
            local no_write = is_ignore;

            if GG.ALLVersion == nil then
                GG.ALLVersion = {};
            end;
        
            if GG.ALLVersion[fileName] == nil then
                GG.ALLVersion[fileName] = tos(tick());
            end;
        
            if tick() - ton(ALLVersion[fileName]) >= CD then
                local source = HttpGet(game, srcName);
                GG.ALLVersion[fileName] = tos(tick());

                writefile(cacheFile, source);

                if not no_write then
                    local versionContent = EnCodeJ(HttpService, GG.ALLVersion);
                    writefile(versionFile, versionContent);
                end;

                warn("[Flow] : Loaded " .. fileName .. " from GitHub via auto-update");

                if noload then
                    return source
                end;
                return loadsource(source);
            else
                if isfolder("FlowXS") then
                    local cachedSource = isfile(cacheFile) and readfile(cacheFile);

                    if not cachedSource or not isfile(versionFile) then
                        local source = HttpGet(game, srcName);
                        GG.ALLVersion[fileName] = tos(tick());

                        writefile(cacheFile, source);

                        if not no_write then
                            local versionContent = EnCodeJ(HttpService, GG.ALLVersion);
                            writefile(versionFile, versionContent);
                        end;

                        warn("[Flow] : Loaded " .. fileName .. " from GitHub");

                        if noload then
                            return source
                        end;
                        return loadsource(source);
                    else
                        warn("[Flow] : Loaded " .. fileName .. " from device and NOT GitHub");

                        if noload then
                            return cachedSource;
                        end;
                        return loadsource(cachedSource);
                    end;
                else
                    return Kick(selff, "isfolder check failed, try rejoining before reporting the bug");
                end;
            end;
        else
            local source = HttpGet(game, srcName);
            if noload then
                return source;
            end;

            warn("[Flow] : Loaded " .. fileName .. " via nowrite.2");

            return loadsource(source);
        end;
    end;
end;

if UpperC and LowerC then
    if PlaceId == 15962819441 or PlaceId == 96354063422506 then
        local a = nil;
        a = UpperC(game, "__namecall", function(self, ...)
            local args = {...};
            local method = getnamecallmethod();
            local tos_self = tos(self);

            if method == "FireServer" then
                if tos_self == "Sender" or tos_self == "Sender2" then
                    return wait(9e9);
                end;
            end;

            return a(self, ...);
        end);
    end;
    if PlaceId == 96354063422506 then
        local ml = {
            GS = "GetService",
            jfoik = "Players",
            nIJM = "LocalPlayer",
            mhfd = "PlayerGui",
            j6yr = "ChildAdded",
            paosd = "game",
            mkas = "next",
            p0ms = "getconnections",
            nsjkd = 'Disable',
            X19uYW1lY2FsbA = "__namecall",
            X19pbmRleA = "__index",
            mksdsdds = "Bypassed Anti Cheat [sUNC + Specific]",
        };
        
        local k,osi = getfenv(),getgenv();
        local p = k[ml.paosd];
        local s = k[ml.mkas];
        local kd = osi[ml.p0ms];
        local meta = "ReplicatedFirst.Loading.LocalScript";
        
        for i,v in s , kd(p[ml.GS](p,ml.jfoik)[ml.nIJM][ml.mhfd][ml.j6yr]) do
            if v then
                v[ml.nsjkd](v);
            end;
        end;
        
        local old = nil;
        old = UpperC(p,ml.X19uYW1lY2FsbA, newcclosure(function(self , ...)
            local traceBACK = debug.traceback();
        
            if strfind(traceBACK,meta,1,true) then
                return error(ml.mksdsdds);
            end;
        
            if getnamecallmethod() == "FireServer" and not checkcaller() then
                if strfind(tos(self),"Sender",1,true) then
                    return error(ml.mksdsdds);
                end;
            end;
            return old(self , ...)
        end));
        
        local old_ind = nil;
        old_ind = UpperC(p,ml.X19pbmRleA, newcclosure(function(self , i , v)
            local traceBACK = debug.traceback();
        
            if strfind(traceBACK,meta,1,true) then
                return error(ml.mksdsdds);
            end;
        
            if strfind(tos(self),"Sender",1,true) and not checkcaller() then
                return error(ml.mksdsdds);
            end;
        
            return old_ind(self , i , v)
        end));
        
        do
            local oldfire = nil;
            oldfire = LowerC(Instance.new("RemoteEvent").FireServer, newcclosure(function(self,...)
                local traceBACK = debug.traceback();
        
                if strfind(traceBACK,meta,1,true) then
                    return error(ml.mksdsdds);
                end;
        
                if strfind(tos(self),"Sender",1,true) then
                    return error(ml.mksdsdds);
                end;
        
                return oldfire(self, ...)
            end));
        end;
        
        do
            local oldfire = nil;
            oldfire = LowerC(Instance.new("UnreliableRemoteEvent").FireServer, newcclosure(function(self,...)
                local traceBACK = debug.traceback();
        
                if strfind(traceBACK,meta,1,true) then
                    return error(ml.mksdsdds);
                end;
        
                if strfind(tos(self),"Sender",1,true) then
                    return error(ml.mksdsdds);
                end;
        
                return oldfire(self, ...)
            end));
        end;
    end;
end;

if GameId == 2294168059 then
    for i=1, 6 do
        pcal(function()
            local AC1 = FindFirstChild(selff, "AntiFly", true) or FindFirstChild(selff, "Anti-Fly", true) or FindFirstChild(selff, "Anti-Speed", true) or FindFirstChild(selff, "AntiSpeed", true)
            local AC2 = FindFirstChild(selc, "AntiFly", true) or FindFirstChild(selc, "Anti-Fly", true) or FindFirstChild(selc, "Anti-Speed", true) or FindFirstChild(selc, "AntiSpeed", true)
            if AC1 then
                AC1:Destroy();
            end;
            if AC2 then
                AC2:Destroy();
            end;
        end);
        twait();
    end;
end;

------------- Script Asset / Script Cache 2 -------------

GG.ApplyLanguage = function(...)
    return ...;
end;

GG.CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0};

if GG.ScriptCache.userIdentify.device == "Mobile" then
    pcal(function()
        GG.controlModule = GG.controlModule or require(PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"));
    end);
end;

GG.UploadToGlobal_Key = GG.UploadToGlobal_Key or function( arg : {} )
    local modules : {} = {};
    local emptyfunction = function(...)
        return;
    end;

    function modules:new( arg )
        local G2L = {};
        local tbl = {};
        local configu = {
            Auth = arg.Auth or emptyfunction;
            GetKey = arg.GetKey or emptyfunction;
        };

        local G2L = {};

        G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
        G2L["1"]["IgnoreGuiInset"] = true;
        G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.None;
        G2L["1"]["Name"] = [[FlowAuth]];
        G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
        G2L["1"]["ResetOnSpawn"] = false;


        -- StarterGui.FlowAuth.ImageLabel
        G2L["2"] = Instance.new("ImageLabel", G2L["1"]);
        G2L["2"]["ZIndex"] = 9999;
        G2L["2"]["BorderSizePixel"] = 0;
        G2L["2"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["2"]["SliceScale"] = 0.08594;
        G2L["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["2"]["AutomaticSize"] = Enum.AutomaticSize.XY;
        G2L["2"]["ImageColor3"] = Color3.fromRGB(25, 25, 28);
        G2L["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
        G2L["2"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["2"]["BackgroundTransparency"] = 1;
        G2L["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


        -- StarterGui.FlowAuth.ImageLabel.Frame
        G2L["3"] = Instance.new("Frame", G2L["2"]);
        G2L["3"]["ZIndex"] = 99999;
        G2L["3"]["BorderSizePixel"] = 0;
        G2L["3"]["BackgroundColor3"] = Color3.fromRGB(25, 25, 28);
        G2L["3"]["AutomaticSize"] = Enum.AutomaticSize.Y;
        G2L["3"]["Size"] = UDim2.new(0, 430, 0, 0);
        G2L["3"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.UIPadding
        G2L["4"] = Instance.new("UIPadding", G2L["3"]);



        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame
        G2L["5"] = Instance.new("Frame", G2L["3"]);
        G2L["5"]["BorderSizePixel"] = 0;
        G2L["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["5"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["5"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame
        G2L["6"] = Instance.new("Frame", G2L["5"]);
        G2L["6"]["BorderSizePixel"] = 0;
        G2L["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["6"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["6"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.UIListLayout
        G2L["7"] = Instance.new("UIListLayout", G2L["6"]);
        G2L["7"]["Padding"] = UDim.new(0, 18);
        G2L["7"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame
        G2L["8"] = Instance.new("Frame", G2L["6"]);
        G2L["8"]["BorderSizePixel"] = 0;
        G2L["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["8"]["AutomaticSize"] = Enum.AutomaticSize.Y;
        G2L["8"]["Size"] = UDim2.new(1, 0, 0, 0);
        G2L["8"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.Frame
        G2L["9"] = Instance.new("Frame", G2L["8"]);
        G2L["9"]["BorderSizePixel"] = 0;
        G2L["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["9"]["AutomaticSize"] = Enum.AutomaticSize.XY;
        G2L["9"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.Frame.UIListLayout
        G2L["a"] = Instance.new("UIListLayout", G2L["9"]);
        G2L["a"]["Padding"] = UDim.new(0, 14);
        G2L["a"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
        G2L["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
        G2L["a"]["FillDirection"] = Enum.FillDirection.Horizontal;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.Frame.Frame
        G2L["b"] = Instance.new("Frame", G2L["9"]);
        G2L["b"]["BorderSizePixel"] = 0;
        G2L["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["b"]["Size"] = UDim2.new(0, 24, 0, 24);
        G2L["b"]["LayoutOrder"] = -1;
        G2L["b"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.Frame.Frame.ImageLabel
        G2L["c"] = Instance.new("ImageLabel", G2L["b"]);
        G2L["c"]["BorderSizePixel"] = 0;
        G2L["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["c"]["ScaleType"] = Enum.ScaleType.Crop;
        G2L["c"]["Image"] = [[rbxassetid://77771201330939]];
        G2L["c"]["ImageRectSize"] = Vector2.new(96, 96);
        G2L["c"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["c"]["BackgroundTransparency"] = 1;
        G2L["c"]["ImageRectOffset"] = Vector2.new(0, 768);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.Frame.Frame.ImageLabel.UICorner
        G2L["d"] = Instance.new("UICorner", G2L["c"]);
        G2L["d"]["CornerRadius"] = UDim.new(0, 18);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.Frame.TextLabel
        G2L["e"] = Instance.new("TextLabel", G2L["9"]);
        G2L["e"]["BorderSizePixel"] = 0;
        G2L["e"]["TextSize"] = 20;
        G2L["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["e"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        G2L["e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["e"]["BackgroundTransparency"] = 1;
        G2L["e"]["RichText"] = true;
        G2L["e"]["Text"] = [[Authentication]];
        G2L["e"]["AutomaticSize"] = Enum.AutomaticSize.XY;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.TextLabel
        G2L["f"] = Instance.new("TextLabel", G2L["6"]);
        G2L["f"]["TextWrapped"] = true;
        G2L["f"]["BorderSizePixel"] = 0;
        G2L["f"]["TextSize"] = 18;
        G2L["f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
        G2L["f"]["TextTransparency"] = 0.2;
        G2L["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["f"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        G2L["f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["f"]["BackgroundTransparency"] = 1;
        G2L["f"]["RichText"] = true;
        G2L["f"]["Size"] = UDim2.new(1, 0, 0, 0);
        G2L["f"]["Text"] = [[We are very <font color="rgb(0, 255, 135)">s</font><font color="rgb(19, 251, 159)">o</font><font color="rgb(38, 248, 183)">r</font><font color="rgb(57, 245, 207)">r</font><font color="rgb(76, 242, 231)">y</font>, to have this auth or key system but this means a lot to us, this is where you support our project.
        ]];
        G2L["f"]["AutomaticSize"] = Enum.AutomaticSize.Y;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame
        G2L["10"] = Instance.new("Frame", G2L["6"]);
        G2L["10"]["BorderSizePixel"] = 0;
        G2L["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["10"]["Size"] = UDim2.new(1, 0, 0, 42);
        G2L["10"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.UIListLayout
        G2L["11"] = Instance.new("UIListLayout", G2L["10"]);
        G2L["11"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right;
        G2L["11"]["Padding"] = UDim.new(0, 9);
        G2L["11"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
        G2L["11"]["FillDirection"] = Enum.FillDirection.Horizontal;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton
        G2L["12"] = Instance.new("TextButton", G2L["10"]);
        G2L["12"]["BorderSizePixel"] = 0;
        G2L["12"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["12"]["AutoButtonColor"] = false;
        G2L["12"]["TextSize"] = 14;
        G2L["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["12"]["AutomaticSize"] = Enum.AutomaticSize.X;
        G2L["12"]["Size"] = UDim2.new(0, 0, 1, 0);
        G2L["12"]["BackgroundTransparency"] = 1;
        G2L["12"]["LayoutOrder"] = 2;
        G2L["12"]["Text"] = [[]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Squircle
        G2L["13"] = Instance.new("ImageLabel", G2L["12"]);
        G2L["13"]["BorderSizePixel"] = 0;
        G2L["13"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["13"]["SliceScale"] = 0.03906;
        G2L["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["13"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["13"]["ImageTransparency"] = 1;
        G2L["13"]["ImageColor3"] = Color3.fromRGB(83, 83, 92);
        G2L["13"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["13"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["13"]["BackgroundTransparency"] = 1;
        G2L["13"]["Name"] = [[Squircle]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Special
        G2L["14"] = Instance.new("ImageLabel", G2L["12"]);
        G2L["14"]["BorderSizePixel"] = 0;
        G2L["14"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["14"]["SliceScale"] = 0.03906;
        G2L["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["14"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["14"]["ImageTransparency"] = 0.95;
        G2L["14"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["14"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["14"]["BackgroundTransparency"] = 1;
        G2L["14"]["Name"] = [[Special]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Shadow
        G2L["15"] = Instance.new("ImageLabel", G2L["12"]);
        G2L["15"]["BorderSizePixel"] = 0;
        G2L["15"]["SliceCenter"] = Rect.new(512, 512, 512, 512);
        G2L["15"]["SliceScale"] = 0.01953;
        G2L["15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["15"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["15"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
        G2L["15"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
        G2L["15"]["Image"] = [[rbxassetid://84825982946844]];
        G2L["15"]["Size"] = UDim2.new(1, 3, 1, 3);
        G2L["15"]["BackgroundTransparency"] = 1;
        G2L["15"]["Name"] = [[Shadow]];
        G2L["15"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.ImageLabel
        G2L["16"] = Instance.new("ImageLabel", G2L["12"]);
        G2L["16"]["BorderSizePixel"] = 0;
        G2L["16"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["16"]["SliceScale"] = 0.03906;
        G2L["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["16"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["16"]["ImageTransparency"] = 0.85;
        G2L["16"]["Image"] = [[rbxassetid://117788349049947]];
        G2L["16"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["16"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame
        G2L["17"] = Instance.new("ImageLabel", G2L["12"]);
        G2L["17"]["BorderSizePixel"] = 0;
        G2L["17"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["17"]["SliceScale"] = 0.03906;
        G2L["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["17"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["17"]["ImageTransparency"] = 1;
        G2L["17"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["17"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["17"]["BackgroundTransparency"] = 1;
        G2L["17"]["Name"] = [[Frame]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.UIPadding
        G2L["18"] = Instance.new("UIPadding", G2L["17"]);
        G2L["18"]["PaddingRight"] = UDim.new(0, 12);
        G2L["18"]["PaddingLeft"] = UDim.new(0, 12);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.UIListLayout
        G2L["19"] = Instance.new("UIListLayout", G2L["17"]);
        G2L["19"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
        G2L["19"]["Padding"] = UDim.new(0, 8);
        G2L["19"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
        G2L["19"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
        G2L["19"]["FillDirection"] = Enum.FillDirection.Horizontal;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.TextLabel
        G2L["1a"] = Instance.new("TextLabel", G2L["17"]);
        G2L["1a"]["BorderSizePixel"] = 0;
        G2L["1a"]["TextSize"] = 18;
        G2L["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1a"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        G2L["1a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1a"]["BackgroundTransparency"] = 1;
        G2L["1a"]["RichText"] = true;
        G2L["1a"]["Text"] = [[Cancel]];
        G2L["1a"]["AutomaticSize"] = Enum.AutomaticSize.XY;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton
        G2L["1b"] = Instance.new("TextButton", G2L["10"]);
        G2L["1b"]["BorderSizePixel"] = 0;
        G2L["1b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1b"]["AutoButtonColor"] = false;
        G2L["1b"]["TextSize"] = 14;
        G2L["1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1b"]["AutomaticSize"] = Enum.AutomaticSize.X;
        G2L["1b"]["Size"] = UDim2.new(0, 0, 1, 0);
        G2L["1b"]["BackgroundTransparency"] = 1;
        G2L["1b"]["LayoutOrder"] = 3;
        G2L["1b"]["Text"] = [[]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Squircle
        G2L["1c"] = Instance.new("ImageLabel", G2L["1b"]);
        G2L["1c"]["BorderSizePixel"] = 0;
        G2L["1c"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["1c"]["SliceScale"] = 0.03906;
        G2L["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1c"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["1c"]["ImageColor3"] = Color3.fromRGB(83, 83, 92);
        G2L["1c"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["1c"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["1c"]["BackgroundTransparency"] = 1;
        G2L["1c"]["Name"] = [[Squircle]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Special
        G2L["1d"] = Instance.new("ImageLabel", G2L["1b"]);
        G2L["1d"]["BorderSizePixel"] = 0;
        G2L["1d"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["1d"]["SliceScale"] = 0.03906;
        G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1d"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["1d"]["ImageTransparency"] = 1;
        G2L["1d"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["1d"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["1d"]["BackgroundTransparency"] = 1;
        G2L["1d"]["Name"] = [[Special]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Shadow
        G2L["1e"] = Instance.new("ImageLabel", G2L["1b"]);
        G2L["1e"]["BorderSizePixel"] = 0;
        G2L["1e"]["SliceCenter"] = Rect.new(512, 512, 512, 512);
        G2L["1e"]["SliceScale"] = 0.01953;
        G2L["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1e"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["1e"]["ImageTransparency"] = 1;
        G2L["1e"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
        G2L["1e"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
        G2L["1e"]["Image"] = [[rbxassetid://84825982946844]];
        G2L["1e"]["Size"] = UDim2.new(1, 3, 1, 3);
        G2L["1e"]["BackgroundTransparency"] = 1;
        G2L["1e"]["Name"] = [[Shadow]];
        G2L["1e"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.ImageLabel
        G2L["1f"] = Instance.new("ImageLabel", G2L["1b"]);
        G2L["1f"]["BorderSizePixel"] = 0;
        G2L["1f"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["1f"]["SliceScale"] = 0.03906;
        G2L["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["1f"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["1f"]["ImageTransparency"] = 0.95;
        G2L["1f"]["Image"] = [[rbxassetid://117788349049947]];
        G2L["1f"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["1f"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame
        G2L["20"] = Instance.new("ImageLabel", G2L["1b"]);
        G2L["20"]["BorderSizePixel"] = 0;
        G2L["20"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["20"]["SliceScale"] = 0.03906;
        G2L["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["20"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["20"]["ImageTransparency"] = 1;
        G2L["20"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["20"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["20"]["BackgroundTransparency"] = 1;
        G2L["20"]["Name"] = [[Frame]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.UIPadding
        G2L["21"] = Instance.new("UIPadding", G2L["20"]);
        G2L["21"]["PaddingRight"] = UDim.new(0, 12);
        G2L["21"]["PaddingLeft"] = UDim.new(0, 12);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.UIListLayout
        G2L["22"] = Instance.new("UIListLayout", G2L["20"]);
        G2L["22"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
        G2L["22"]["Padding"] = UDim.new(0, 8);
        G2L["22"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
        G2L["22"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
        G2L["22"]["FillDirection"] = Enum.FillDirection.Horizontal;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.ImageLabel
        G2L["23"] = Instance.new("ImageLabel", G2L["20"]);
        G2L["23"]["BorderSizePixel"] = 0;
        G2L["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["23"]["ImageColor3"] = Color3.fromRGB(162, 162, 171);
        G2L["23"]["Image"] = [[rbxassetid://131526378523863]];
        G2L["23"]["ImageRectSize"] = Vector2.new(96, 96);
        G2L["23"]["Size"] = UDim2.new(0, 21, 0, 21);
        G2L["23"]["BackgroundTransparency"] = 1;
        G2L["23"]["ImageRectOffset"] = Vector2.new(480, 768);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.TextLabel
        G2L["24"] = Instance.new("TextLabel", G2L["20"]);
        G2L["24"]["BorderSizePixel"] = 0;
        G2L["24"]["TextSize"] = 18;
        G2L["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["24"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        G2L["24"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["24"]["BackgroundTransparency"] = 1;
        G2L["24"]["RichText"] = true;
        G2L["24"]["Text"] = [[Continue]];
        G2L["24"]["AutomaticSize"] = Enum.AutomaticSize.XY;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextBox
        G2L["25"] = Instance.new("TextBox", G2L["10"]);
        G2L["25"]["BorderSizePixel"] = 0;
        G2L["25"]["TextSize"] = 14;
        G2L["25"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["25"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        G2L["25"]["ClipsDescendants"] = true;
        G2L["25"]["PlaceholderText"] = [[Enter Key...]];
        G2L["25"]["Size"] = UDim2.new(0.17, 0, 1, 0);
        G2L["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
        G2L["25"]["Text"] = [[]];
        G2L["25"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextBox.Frame
        G2L["26"] = Instance.new("ImageLabel", G2L["25"]);
        G2L["26"]["BorderSizePixel"] = 0;
        G2L["26"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["26"]["SliceScale"] = 0.03906;
        G2L["26"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["26"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["26"]["ImageTransparency"] = 1;
        G2L["26"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["26"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["26"]["BackgroundTransparency"] = 1;
        G2L["26"]["Name"] = [[Frame]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextBox.ImageLabel
        G2L["27"] = Instance.new("ImageLabel", G2L["25"]);
        G2L["27"]["BorderSizePixel"] = 0;
        G2L["27"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["27"]["SliceScale"] = 0.03906;
        G2L["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["27"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["27"]["ImageTransparency"] = 0.85;
        G2L["27"]["Image"] = [[rbxassetid://117788349049947]];
        G2L["27"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["27"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextBox.Shadow
        G2L["28"] = Instance.new("ImageLabel", G2L["25"]);
        G2L["28"]["BorderSizePixel"] = 0;
        G2L["28"]["SliceCenter"] = Rect.new(512, 512, 512, 512);
        G2L["28"]["SliceScale"] = 0.01953;
        G2L["28"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["28"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["28"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
        G2L["28"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
        G2L["28"]["Image"] = [[rbxassetid://84825982946844]];
        G2L["28"]["Size"] = UDim2.new(1, 3, 1, 3);
        G2L["28"]["BackgroundTransparency"] = 1;
        G2L["28"]["Name"] = [[Shadow]];
        G2L["28"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextBox.Special
        G2L["29"] = Instance.new("ImageLabel", G2L["25"]);
        G2L["29"]["BorderSizePixel"] = 0;
        G2L["29"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["29"]["SliceScale"] = 0.03906;
        G2L["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["29"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["29"]["ImageTransparency"] = 0.95;
        G2L["29"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["29"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["29"]["BackgroundTransparency"] = 1;
        G2L["29"]["Name"] = [[Special]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextBox.Squircle
        G2L["2a"] = Instance.new("ImageLabel", G2L["25"]);
        G2L["2a"]["BorderSizePixel"] = 0;
        G2L["2a"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["2a"]["SliceScale"] = 0.03906;
        G2L["2a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2a"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["2a"]["ImageTransparency"] = 1;
        G2L["2a"]["ImageColor3"] = Color3.fromRGB(83, 83, 92);
        G2L["2a"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["2a"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["2a"]["BackgroundTransparency"] = 1;
        G2L["2a"]["Name"] = [[Squircle]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton
        G2L["2b"] = Instance.new("TextButton", G2L["10"]);
        G2L["2b"]["BorderSizePixel"] = 0;
        G2L["2b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2b"]["AutoButtonColor"] = false;
        G2L["2b"]["TextSize"] = 14;
        G2L["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2b"]["AutomaticSize"] = Enum.AutomaticSize.X;
        G2L["2b"]["Size"] = UDim2.new(0, 0, 1, 0);
        G2L["2b"]["BackgroundTransparency"] = 1;
        G2L["2b"]["LayoutOrder"] = 1;
        G2L["2b"]["Text"] = [[]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Squircle
        G2L["2c"] = Instance.new("ImageLabel", G2L["2b"]);
        G2L["2c"]["BorderSizePixel"] = 0;
        G2L["2c"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["2c"]["SliceScale"] = 0.03906;
        G2L["2c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2c"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["2c"]["ImageTransparency"] = 1;
        G2L["2c"]["ImageColor3"] = Color3.fromRGB(83, 83, 92);
        G2L["2c"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["2c"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["2c"]["BackgroundTransparency"] = 1;
        G2L["2c"]["Name"] = [[Squircle]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Special
        G2L["2d"] = Instance.new("ImageLabel", G2L["2b"]);
        G2L["2d"]["BorderSizePixel"] = 0;
        G2L["2d"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["2d"]["SliceScale"] = 0.03906;
        G2L["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2d"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["2d"]["ImageTransparency"] = 0.95;
        G2L["2d"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["2d"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["2d"]["BackgroundTransparency"] = 1;
        G2L["2d"]["Name"] = [[Special]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Shadow
        G2L["2e"] = Instance.new("ImageLabel", G2L["2b"]);
        G2L["2e"]["BorderSizePixel"] = 0;
        G2L["2e"]["SliceCenter"] = Rect.new(512, 512, 512, 512);
        G2L["2e"]["SliceScale"] = 0.01953;
        G2L["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2e"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["2e"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
        G2L["2e"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
        G2L["2e"]["Image"] = [[rbxassetid://84825982946844]];
        G2L["2e"]["Size"] = UDim2.new(1, 3, 1, 3);
        G2L["2e"]["BackgroundTransparency"] = 1;
        G2L["2e"]["Name"] = [[Shadow]];
        G2L["2e"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.ImageLabel
        G2L["2f"] = Instance.new("ImageLabel", G2L["2b"]);
        G2L["2f"]["BorderSizePixel"] = 0;
        G2L["2f"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["2f"]["SliceScale"] = 0.03906;
        G2L["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["2f"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["2f"]["ImageTransparency"] = 0.85;
        G2L["2f"]["Image"] = [[rbxassetid://117788349049947]];
        G2L["2f"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["2f"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame
        G2L["30"] = Instance.new("ImageLabel", G2L["2b"]);
        G2L["30"]["BorderSizePixel"] = 0;
        G2L["30"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["30"]["SliceScale"] = 0.03906;
        G2L["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["30"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["30"]["ImageTransparency"] = 1;
        G2L["30"]["Image"] = [[rbxassetid://80999662900595]];
        G2L["30"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["30"]["BackgroundTransparency"] = 1;
        G2L["30"]["Name"] = [[Frame]];


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.UIPadding
        G2L["31"] = Instance.new("UIPadding", G2L["30"]);
        G2L["31"]["PaddingRight"] = UDim.new(0, 12);
        G2L["31"]["PaddingLeft"] = UDim.new(0, 12);


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.UIListLayout
        G2L["32"] = Instance.new("UIListLayout", G2L["30"]);
        G2L["32"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
        G2L["32"]["Padding"] = UDim.new(0, 8);
        G2L["32"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
        G2L["32"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
        G2L["32"]["FillDirection"] = Enum.FillDirection.Horizontal;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.Frame.TextButton.Frame.TextLabel
        G2L["33"] = Instance.new("TextLabel", G2L["30"]);
        G2L["33"]["BorderSizePixel"] = 0;
        G2L["33"]["TextSize"] = 18;
        G2L["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["33"]["FontFace"] = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
        G2L["33"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["33"]["BackgroundTransparency"] = 1;
        G2L["33"]["RichText"] = true;
        G2L["33"]["Text"] = [[Copy Link]];
        G2L["33"]["AutomaticSize"] = Enum.AutomaticSize.XY;


        -- StarterGui.FlowAuth.ImageLabel.Frame.Frame.Frame.UIPadding
        G2L["34"] = Instance.new("UIPadding", G2L["6"]);
        G2L["34"]["PaddingTop"] = UDim.new(0, 16);
        G2L["34"]["PaddingRight"] = UDim.new(0, 16);
        G2L["34"]["PaddingLeft"] = UDim.new(0, 16);
        G2L["34"]["PaddingBottom"] = UDim.new(0, 16);


        -- StarterGui.FlowAuth.ImageLabel.UIScale
        G2L["35"] = Instance.new("UIScale", G2L["2"]);



        -- StarterGui.FlowAuth.ImageLabel.ImageLabel
        G2L["36"] = Instance.new("ImageLabel", G2L["2"]);
        G2L["36"]["BorderSizePixel"] = 0;
        G2L["36"]["SliceCenter"] = Rect.new(256, 256, 256, 256);
        G2L["36"]["SliceScale"] = 0.08594;
        G2L["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        G2L["36"]["ScaleType"] = Enum.ScaleType.Slice;
        G2L["36"]["ImageTransparency"] = 0.9;
        G2L["36"]["Image"] = [[rbxassetid://117788349049947]];
        G2L["36"]["Size"] = UDim2.new(1, 0, 1, 0);
        G2L["36"]["BackgroundTransparency"] = 1;


        -- StarterGui.FlowAuth.ImageLabel.ImageLabel.UIGradient
        G2L["37"] = Instance.new("UIGradient", G2L["36"]);
        G2L["37"]["Rotation"] = 90;
        G2L["37"]["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0.000, 0),NumberSequenceKeypoint.new(1.000, 1)};
        
        function tbl:fade_in()

        end;

        G2L["1b"].MouseButton1Click:Connect(function()
            return configu.Auth(G2L["25"].Text);
        end);
        G2L["2b"].MouseButton1Click:Connect(configu.GetKey);
        G2L["12"].MouseButton1Click:Connect(function()
            G2L["1"]:Destroy(true);
            G2L = nil;
        end);

        return G2L, tbl;
    end;

    return modules;
end;

if not ScriptCache.error_handler then
    ScriptCache.error_handler = function(...)
        return warn("[Flow] : Error : " .. ...);
    end;
end;

if not GG.dist then
    GG.dist = function( position : Vector3 )
        return selff:DistanceFromCharacter(position);
    end;
end;

if not GG.FProximityPrompt then

    local originalUNC = fireproximityprompt;

    GG.FProximityPrompt = function()
        local unc = {
            Prompts = {};
        }
    
        local Execonce = FindFirstChild(W, "RegisiteryVarup2") or Instancen('Part');
    
        Execonce.Anchored = true;
        Execonce.CanTouch = false;
        Execonce.CanCollide = false;
        Execonce.CanQuery = false;
        Execonce.CastShadow = false;
        Execonce.Size = Vec3(0.01,0.01,0.01);
        Execonce.Parent = workspace;
        Execonce.Name = 'RegisiteryVarup2';
        Execonce.Transparency = 1;
    
        function unc.fireprompt(ProximityPrompt, ...)
            if not unc[ProximityPrompt] then
                local Information = {};
                
                Information.HoldDuration = ProximityPrompt.HoldDuration;
                Information.MaxActivationDistance = ProximityPrompt.MaxActivationDistance;
                Information.RequiresLineOfSight = ProximityPrompt.RequiresLineOfSight;
                Information.Parent = ProximityPrompt.Parent;
                
                unc[ProximityPrompt] = Information;
            end;
            
            local Init = function()
                
            
                Execonce.CFrame = Cam.CFrame * CF(0,0,-4);
                
                ProximityPrompt.HoldDuration = -5;
                ProximityPrompt.MaxActivationDistance = 250;
                ProximityPrompt.Enabled = true;
                ProximityPrompt.RequiresLineOfSight = false;
                ProximityPrompt.Parent = Execonce;
                
                local spam = tspawn(function()
                    while true do 
                        twait(0.000001/9)
                        Execonce.CFrame = Cam.CFrame * CF(0,0,-4);
                        ProximityPrompt:InputHoldBegin();
                        
                        H.RenderStepped:Wait();
                        
                        Execonce.CFrame = Cam.CFrame * CF(0,0,-4);
                        ProximityPrompt:InputHoldEnd();
                    end;
                end)
                
                ProximityPrompt.Triggered:Wait();
                
                repeat
                    KAWKWDKDK, WDAJDUWAY2waWDW = pcal(function()
                        tcancel(spam);
                    end);
                    twait();
                until KAWKWDKDK
                
                local Loaded = unc[ProximityPrompt];
                
                ProximityPrompt.HoldDuration = Loaded.HoldDuration;
                ProximityPrompt.MaxActivationDistance = Loaded.MaxActivationDistance;
                ProximityPrompt.RequiresLineOfSight = Loaded.RequiresLineOfSight;
                ProximityPrompt.Parent = Loaded.Parent;
            end;
            
            local option = {...};
            
            if typeof(option[1]) == 'number' then
                for i=1,option[1] do
                    Init();
                end;
            end;
        end;
    
        return unc;
    end;
end;

if not ScriptCache.createParagraph_Wel or not ScriptCache.createSection_Wel or not ScriptCache.fetchDiscordInfo_Wel then
    ScriptCache.createParagraph_Wel = function(tab, title, desc, image, imageSize, color)
        return tab:Paragraph({
            Title = title,
            Desc = desc,
            Image = image,
            ImageSize = imageSize,
            Color = color or nil,
        });
    end;

    ScriptCache.createSection_Wel = function(tab, title)
        return tab:Section({ Title = title, TextXAlignment = "Center" });
    end;

    ScriptCache.fetchDiscordInfo_Wel = function(url, wind)
        local res = nil;
        pcal(function()
            res = DeCodeJ(HttpService, request({
                Url = url,
                Method = "GET",
                Headers = { ["Accept"] = "application/json" }
            }).Body);
        end);
        return res or {};
    end;
end;

GG.WelcomeHandler = function(tab: WelcomeTab, wind: WindUI): any
    ScriptCache.InviteCode = ScriptCache.InviteCode or "flows";
    local DiscordAPI = "https://discord.com/api/v10/invites/" .. ScriptCache.InviteCode .. "?with_counts=true&with_expiration=true";
    
    local Response = ScriptCache.fetchDiscordInfo_Wel(DiscordAPI, wind);

    if Response and Response.guild then
        local desc = 
            ' <font color="#52525b">•</font> Member Count : ' .. tos(Response.approximate_member_count) ..
            '\n <font color="#16a34a">•</font> Online Count : ' .. tos(Response.approximate_presence_count);

        local img = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024";
        local DiscordInfo = ScriptCache.createParagraph_Wel(tab, Response.guild.name, desc, img, 42);

        tab:Button({
            Title = "Update Info",
            Callback = function()
                local u = ScriptCache.fetchDiscordInfo_Wel(DiscordAPI, wind);
                if u and u.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">•</font> Member Count : ' .. tos(u.approximate_member_count) ..
                        '\n <font color="#16a34a">•</font> Online Count : ' .. tos(u.approximate_presence_count)
                    );
                end;
            end;
        });
    else
        ScriptCache.createParagraph_Wel(tab, "Error when receiving information about the Discord server", EnCodeJ(HttpService, Response), "triangle-alert", 26, "Red");
    end;

    ScriptCache.createSection_Wel(tab, "✨ Script Infos ✨");

    ScriptCache.createParagraph_Wel(tab, "The Mimic",
        "Flow has a Mimic script that includes client features, ESP, and auto gameplay. Flow also has an auto-play system used to grind coins from the start to the end of Book 2, Chapter 3 on Nightmare difficulty. We've been developing this script for 4 years. Need to play The Mimic? You need Flow.",
        "ghost");

    ScriptCache.createParagraph_Wel(tab, "Dragon Adventure",
        "Flow has a <b>Dragon Adventures</b> script packed with many <b>OP features</b> like <b>dragon godmode</b>. It also includes an <b>auto-farm system</b> to grind coins, treasures, mobs, and more. Flow isn’t limited to dragon features — it also offers client tools like <b>fly</b>, <b>noclip</b>, <b>walkspeed</b>, and more. <i>Need to play Dragon Adventures? You need Flow.</i><br/><br/><font color=\"#FF0000\"><b>Dragon Adventures has a powerful Anti-Cheat system</b></font>, and some configurations may be detected. Please read the documentation at <u>https://ttjy-hub.gitbook.io/flow-together</u>",
        "bird");

    ScriptCache.createParagraph_Wel(tab, "Anime Saga",
        "Flow has an <b>Anime Saga</b> script that includes client features, auto gameplay, auto heal, and modded abilities.\n<b>Anime Saga</b> is currently in development mode, and <font color=\"#FF0000\">due to script security, we can't create the <b>bypass</b> for World, Act, or Difficulty yet.</font>\n<font color=\"#FF0000\">However, in the next update, we will have the <b>bypass</b> for those, so we can finally join any mode or chapter we want without having to <b>unlock</b> them.</font>",
        "globe");

    ScriptCache.createSection_Wel(tab, "💖 About Us 💖");

    ScriptCache.createParagraph_Wel(tab, "TTJY",
        "TTJY is a Luau developer who also created the official Flow site. With 4 years of scripting experience (TTJY Hub – NeuronX – Flow), TTJY manages all Flow APIs. If you need to report a bug, you can report it directly to TTJY.",
        "user");

    ScriptCache.createParagraph_Wel(tab, "Ironic",
        "Ironic is the founder of Flow. He usually manages Flow products like cheap Robux, accounts for sale, and oversees the community.",
        "user");

    ScriptCache.createParagraph_Wel(tab, "Contact Us",
        "Discord : discord.gg/flows",
        "contact"
    );
end;

------------- FlowXS -------------

if LoaderSettings.AllowCache then
    if not isfolder("FlowXS") then
        makefolder("FlowXS");
    end;
end;

if not GG.ALLVersion then
    if isfile("FlowXSVersion.json") then
        local FlowXSVersion = readfile("FlowXSVersion.json");
        if FlowXSVersion then
            GG.ALLVersion = DeCodeJ(HttpService, FlowXSVersion);
        else
            GG.ALLVersion = {["MagicCity"] = true};
        end;
    else
        GG.ALLVersion = {["MagicCity"] = true};
    end;
end;
if GG.ALLVersion["MainLoader"] == nil then
    GG.ALLVersion["MainLoader"] = tos(tick());
end;

GG.ScriptStatus = "Finish Intializing API_M";
warn("[Flow] : Loaded Main.lua via execution");

------------- Source Loader -------------

if GG.API_Only then return; end;

if GG.LSecureLoad and GG.LSecureUI and GG.Functions then
    return GG.LSecureLoad();
else
    GG.ScriptStatus = "Intializing API_P";
    local srcName : string = "https://raw.githubusercontent.com/Yumiara/Secure-Sequence/refs/heads/main/Main/API/API_K.lua";
    return loadScriptFromCache(srcName, "API_P", false, 600, true);
end;
