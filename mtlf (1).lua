if getgenv().Multifarm then return end
getgenv().Multifarm = true

if LPH_OBFUSCATED == nil then
    local assert = assert
    local type   = type
    local G      = getgenv()
    local function encnum(toEncrypt, ...)
        assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
        return toEncrypt
    end
    local function encstr(toEncrypt, ...)
        assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
        return toEncrypt
    end
    local function jit(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
        return f
    end
    local function novirt(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
        return f
    end
    local function noupv(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
        return f
    end
    local function crash(...)
        assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
        return nil
    end
    rawset(G, "LPH_ENCNUM",        encnum)
    rawset(G, "LPH_NUMENC",        encnum)
    rawset(G, "LPH_ENCSTR",        encstr)
    rawset(G, "LPH_STRENC",        encstr)
    rawset(G, "LPH_JIT",           jit)
    rawset(G, "LPH_JIT_MAX",       jit)
    rawset(G, "LPH_NO_VIRTUALIZE", novirt)
    rawset(G, "LPH_NO_UPVALUES",   noupv)
    rawset(G, "LPH_CRASH",         crash)
end

local LoadStart = os.clock()

local ok, val = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/k7gi/poopo/refs/heads/main/thegoat.lua"))()
end)

if not ok or val ~= "ImKindaGuy" then
    return
end

repeat task.wait() until game:IsLoaded()
if not game:GetService("Players").LocalPlayer.Character then
    game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
end

local fireproximityprompt = fireproximityprompt
local Players             = cloneref(game:GetService("Players")) or game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local LogService          = cloneref(game:GetService("LogService"))
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local MemoryStoreService  = cloneref(game:GetService("MemoryStoreService")) or game:GetService("MemoryStoreService")
local Workspace           = game:GetService("Workspace")
local TeleportService     = game:GetService("TeleportService")
local RPC             = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RPC")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")

local Player         = Players.LocalPlayer
repeat task.wait() until Player.Character
local PlayerGui      = Player:WaitForChild("PlayerGui")
local Character      = Player.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

local function GetHumanoid()
    local c = Player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function EquipTool(tool)
    local h = GetHumanoid()
    if h and tool then h:EquipTool(tool) end
end
local function UnequipTools()
    local h = GetHumanoid()
    if h then h:UnequipTools() end
end
local tableFind
tableFind = table.find or function(t, v)
    for i = 1, #t do
        if t[i] == v then return i end
    end
end
local Random = Random.new()

if getgenv().AutoRejoinerEnabled then
    task.spawn(function()
        local IntroUI = PlayerGui:WaitForChild("IntroUI", 30)
        if not IntroUI then return end
        local SurfaceGui = IntroUI:FindFirstChild("SurfaceGui")
        if not SurfaceGui then return end
        local Frame = SurfaceGui:FindFirstChild("Frame")
        if not Frame then return end
        local PlayButton = Frame:FindFirstChild("Play")
        if not PlayButton then return end
        task.wait(15)
        repeat
            pcall(function()
                getconnections(PlayButton.MouseButton1Click)[1]:Fire()
            end)
            task.wait(0.25)
        until not PlayerGui:FindFirstChild("IntroUI")
    end)
end

-- HYPHON EMULATOR v4 (Zero Hook - South Bronx Bypass)
if getgenv().HyphonReady then
    -- already loaded
else
    local genv = getgenv()
    if not genv.HyphonReady then
        local MSS = game:GetService("MemoryStoreService")
        local RS = game:GetService("ReplicatedStorage")
        local Client = game:GetService("Players").LocalPlayer

        local HC_Remote = nil
        for _, v in pairs(MSS:GetChildren()) do
            if v.Name == "Hyphon_Check" and v:IsA("RemoteEvent") then HC_Remote = v; break end
        end
        if HC_Remote then
            local MainRF = nil
            for _, f in pairs(RS:GetChildren()) do
                if f:IsA("Folder") and #f.Name <= 4 then
                    local rf = f:FindFirstChildOfClass("RemoteFunction")
                    if rf then MainRF = rf; break end
                end
            end
            if MainRF then
                local EmuData = {T1=nil, T2=nil, CN=0, T3=nil, T4=nil, Tabs={}, SSL=nil, LF=nil, HC_Version=nil}
                genv.Emulator_Data = EmuData

                HC_Remote.OnClientEvent:Connect(function(...)
                    local a = {...}
                    if type(a[2]) == "string" and a[2]:find("Handshake") then
                        EmuData.HC_Version = a[2]
                    end
                end)

                MainRF.OnClientInvoke = function(...)
                    local a = {...}
                    if a[1] ~= nil and type(a[1]) == "string" then
                        EmuData.T2 = a[1]
                    end
                end

                local initialized = false
                for i = 1, 20 do
                    if HC_Remote then
                        HC_Remote:FireServer(tick(), "Handshake_V5")
                    end
                    task.wait(0.1)
                    if EmuData.HC_Version then
                        initialized = true
                        break
                    end
                end

                if initialized then
                    for i = 1, 5 do
                        local ok, resp = pcall(MainRF.InvokeServer, MainRF, {
                            math.random(1,999), math.random(1,999), nil,
                            [4] = "0", [5] = "__index", [6] = math.random(1,999),
                            [7] = math.random(1,999), [8] = tostring(os.time()), [9] = tick(),
                            [10] = math.random(1,999), [11] = math.random(1,999),
                            [12] = {CurrentTick=tostring(tick()), Tablets={}},
                            [13] = {SSL=nil, LuaFunction=nil, ["Metatable code"]="nil"}
                        })
                        if ok then
                            EmuData.T1 = EmuData.T1 or math.random(1,999)
                            EmuData.T3 = EmuData.T3 or math.random(1,999)
                            EmuData.T4 = EmuData.T4 or math.random(1,999)
                            break
                        end
                        task.wait(0.5)
                    end

                    task.spawn(function() while task.wait(9) do EmuData.Tabs[1]=tick(); EmuData.Tabs[2]=tick() end end)
                    task.spawn(function() while task.wait(10) do EmuData.Tabs[3]=tick() end end)
                    task.spawn(function() while task.wait(4) do EmuData.Tabs[4]=tick() end end)

                    task.spawn(function()
                        while true do
                            task.wait(9)
                            if HC_Remote then
                                HC_Remote:FireServer(tick(), EmuData.HC_Version or "Handshake_V5")
                                task.wait(0.1)
                                HC_Remote:FireServer()
                            end
                        end
                    end)

                    local cn = 0
                    task.spawn(function()
                        while true do
                            task.wait(35)
                            cn = cn + 1
                            EmuData.Tabs[5] = tick() - 0.5
                            EmuData.Tabs[6] = tick()
                            pcall(MainRF.InvokeServer, MainRF, {
                                EmuData.T1 or math.random(1,999),
                                EmuData.T2 or tostring(math.random(1,999)), nil,
                                [4] = tostring(cn), [5] = "__index",
                                [6] = EmuData.T3 or math.random(1,999),
                                [7] = math.random(1,999), [8] = tostring(os.time()),
                                [9] = tick(), [10] = math.random(1,999),
                                [11] = EmuData.T4 or math.random(1,999),
                                [12] = {CurrentTick=tostring(tick()), Tablets=EmuData.Tabs},
                                [13] = {LuaFunction=EmuData.LF, SSL=EmuData.SSL, ["Metatable code"]="nil"},
                            })
                        end
                    end)

                    genv.HyphonReady = true
                    print("Hyphon Emulator v4 loaded")
                end
            end
        end
    end
end

repeat task.wait() until HyphonReady == true

local Configuration = {
    Main_Settings = {
        ["Autofarming"]       = false,
        ["Auto Rob Casino"]   = false,
        ["Auto Anti Death"]   = true,
        ["Auto Rejoiner"]     = true,
        ["Performance Saver"] = false,
    },
    Statistics = {
        ["Times Rejoined"]    = 0,
        ["Runtime"]           = 0,
        ["Cash Made"]         = 0,
        ["Casino Robbed"]     = 0,
        ["Chips Fed"]         = 0,
        ["Cards Swiped"]      = 0,
        ["Marshmallows Sold"] = 0,
    },
    Goal_Settings = {
        ["Enabled"]       = false,
        ["Target Amount"] = 250000,
    },
    Webhook_Settings = {
        ["Send Webhooks"]     = false,
        ["Webhook Intervals"] = 5,
        ["Webhook Url"]       = "",
    },
    State = {
        ["Status"]      = "Idle",
        ["BikeSitting"] = false,
        ["BikeSpawned"] = false,
        ["IsHealing"]   = false,
        ["Apartment"]   = nil,
    },

}

local Locations = {
    SafeZone      = Vector3.new(-478.840, 24.000,  389.200),
    HotChipsMan   = Vector3.new( -41.000,  3.000,  -25.000),
    FakeID        = Vector3.new(217.841, 4.727, -331.714),
    BuyMarsh      = Vector3.new(510.817, 4.581, 601.048),
    BuyPotato     = Vector3.new(-759.197, 3.489, -194.846),
    ApplyForCard  = Vector3.new( -49.210,  4.000, -310.810),
    CollectCard   = Vector3.new( -39.090,  5.392, -329.700),
    SkiMask       = Vector3.new(-366.980,  3.528, -320.630),
    Healing       = Vector3.new(-769.000,  6.000,  654.000),
    Clipboard     = Vector3.new(-477.803, 4.855, -435.559),
    PotatoCutter  = Vector3.new(-456.320,  3.870, -466.840),
    PlasticBagLab = Vector3.new(-456.280,  3.654, -472.670),
    FlourBowl     = Vector3.new(-494.640,  3.579, -518.580),
}

local Labatory = Workspace.Map.Locations["The Laboratory"]

local Stove, CookPrompt, StoveTimer
local AvailablePot, PotPrompt, PotTimer

for _, Object in pairs(getgc(true)) do
    if typeof(Object) == "table" and typeof(rawget(Object, "Homeless")) == "table" then
        if rawget(Object.Homeless, "MaxDistance") then
            Object.Homeless.MaxDistance = 9e9
        end
    end
end

local function GetCommaValue(n)
    local s = tostring(math.floor(n))
    while true do
        local result, count = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = result
        if count == 0 then break end
    end
    return s
end

local function FormatRuntime(seconds)
    return string.format("%02d:%02d:%02d",
        math.floor(seconds / 3600),
        math.floor((seconds % 3600) / 60),
        seconds % 60
    )
end

local function GetCurrentCashAmount()
    local ok, n = pcall(function()
        return tonumber((PlayerGui.Main.Money.Amount.Text:gsub("%D+", ""))) or 0
    end)
    return (ok and n) or 0
end

local function GetCurrentCash()
    local n = GetCurrentCashAmount()
    if n > 0 then return "$" .. GetCommaValue(n) end
    return "N/A"
end

local function GetCharName()
    local ok, result = pcall(function()
        return Player.Character.Head:WaitForChild("NameTag", 5).MainFrame.NameLabel.Text
    end)
    return (ok and result) or "N/A"
end

local function GetETA()
    if not Configuration.Goal_Settings["Enabled"] then return "N/A" end
    local runtime    = Configuration.Statistics["Runtime"]
    local cashMade   = Configuration.Statistics["Cash Made"]
    if runtime <= 0 or cashMade <= 0 then return "N/A" end
    local remaining = Configuration.Goal_Settings["Target Amount"] - GetCurrentCashAmount()
    if remaining <= 0 then return "Goal Reached" end
    return FormatRuntime(math.floor(remaining / (cashMade / runtime)))
end

local function WaitForReady()
    repeat task.wait() until Configuration.Main_Settings["Autofarming"]
end

local function DoRejoin()
    if not Configuration.Main_Settings["Auto Rejoiner"] then return end
    Configuration.Main_Settings["Autofarming"] = false
    Configuration.Statistics["Times Rejoined"] += 1
    queue_on_teleport([[
       queue_on_teleport("task.wait(15)\ngetgenv().AutoRejoinerEnabled = true\nloadstring(game:HttpGet('https://pastefy.app/qswze7Pl/raw'))()")
    ]])
    TeleportService:Teleport(10179538382)
end

local function ScavengeInventory()
    UnequipTools()
    local Backpack = Player:WaitForChild("Backpack")    
    local Potato, Flour, Water, Gelatin, SugarBlockBag = 0, 0, 0, 0, 0
    for _, Object in next, Backpack:GetChildren() do
        if Object.Name == "Potato"          then Potato       += 1 end
        if Object.Name == "Flour"           then Flour        += 1 end
        if Object.Name == "Water"           then Water        += 1 end
        if Object.Name == "Gelatin"         then Gelatin      += 1 end
        if Object.Name == "Sugar Block Bag" then SugarBlockBag += 1 end
    end
    return Potato, Flour, Water, Gelatin, SugarBlockBag
end

local function FindAvailableApartments()
    local Available, Owned = {}, {}
    local Apartments       = { "WH1", "BH3", "BH2", "BH4", "BH1", "LT1" }
    local CasinoApartments = { "Home 1", "Home 2", "Home 3", "Home 4" }
    for _, Object in next, Workspace:WaitForChild("Map").APTS:GetChildren() do
        if Object:IsA("Model") and (table.find(Apartments, tostring(Object)) or table.find(CasinoApartments, tostring(Object))) then
            local Board = Object:FindFirstChild("Board", true)
            if Board then
                local Text = Board.name.SurfaceGui.TextLabel.Text
                if Text == "VACANT" then
                    table.insert(Available, Object)
                elseif Text == Player.Name then
                    table.insert(Owned, Object)
                end
            end
        end
    end
    if #Owned >= 1 then return Owned, "Owned" end
    return Available, "Not Owned"
end

local function FindAvailableATMs()
    for _, ATM in next, Workspace:WaitForChild("Map").ATMS:GetChildren() do
        if ATM:FindFirstChild("ATMScreen").Transparency == 0 then
            return ATM
        end
    end
end

local function FindAvailableHomeless()
    local Available = {}
    for _, Object in next, Workspace.Folders.HomelessPeople:GetChildren() do
        if Object:IsA("Model") then
            local Leg = Object:FindFirstChild("RightLowerLeg")
            if Leg and math.floor(Leg.Rotation.X) == 90 then
                table.insert(Available, Object)
            end
        end
    end
    return Available
end

local function SpawnAndSitOnBike()
    local BikeName     = string.format("%s's Car", Player.Name)
    local ExistingBike = Workspace:FindFirstChild(BikeName)

    if ExistingBike and ExistingBike:FindFirstChild("DriveSeat") and ExistingBike.DriveSeat.Occupant then
        Configuration.State["Status"]      = "[ BIKE ] : Already on bike"
        Configuration.State["BikeSitting"] = true
        Configuration.State["BikeSpawned"] = true
        return true
    end

    Configuration.State["Status"] = "[ BIKE ] : Spawning bike..."
    local Bike = Workspace:FindFirstChild(BikeName)

    if not Bike then
        RPC:FireServer(buffer.fromstring("\001"), "Spawn", "DirtBike")
        local SpawnStart = os.clock()
        repeat task.wait(0.1) until Workspace:FindFirstChild(BikeName) or (os.clock() - SpawnStart) > 4
        Bike = Workspace:FindFirstChild(BikeName)
    end

    if not Bike then
        Configuration.State["Status"] = "[ BIKE ] : Bike not found after spawn!"
        return false
    end

    local DriveSeat = Bike:WaitForChild("DriveSeat")

    Configuration.SpawningBike = true

    UnequipTools()
    Configuration.State["RespawnPending"] = true
    HumanoidRootPart.CFrame = CFrame.new(67^2, 10^10, 67^2)
    Player.CharacterAdded:Wait()
    Character        = Player.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local TargetCFrame = DriveSeat.CFrame * CFrame.new(3, 1, 0)
    task.wait(2)
    for _ = 1, 5 do
        HumanoidRootPart.CFrame = TargetCFrame
        task.wait(0.05)
    end
    task.wait(2.5)

    Configuration.SpawningBike = false

    if (HumanoidRootPart.Position - Bike:FindFirstChildWhichIsA("Part", true).Position).Magnitude > 25 then
        Configuration.State["RespawnPending"] = false
        Configuration.State["Status"] = "[ BIKE ] : Failed to teleport to bike!"
        return false
    end

    local Prompt = DriveSeat:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not Prompt then
        local Attachment = DriveSeat:FindFirstChild("Attachment")
        if Attachment then Prompt = Attachment:FindFirstChild("ProximityPrompt") end
    end

    if Prompt then
        Prompt.HoldDuration          = 0
        Prompt.RequiresLineOfSight   = false
        Prompt.MaxActivationDistance = 9e9
        fireproximityprompt(Prompt)
    end

    task.wait(1)
    Configuration.State["RespawnPending"] = false
    Configuration.State["Status"]      = "[ BIKE ] : Sitting on bike!"
    Configuration.State["BikeSitting"] = true
    Configuration.State["BikeSpawned"] = true
    return true
end

local function DirtBikeTeleport(TargetPosition)
    local c = Player.Character
    if not c then return false end

    local h = c:FindFirstChild("Humanoid")
    if not h then return false end

    if not h.SeatPart then
        Configuration.State["Status"] = "[ BIKE ] : Not on bike, attempting to re-sit..."
        if not SpawnAndSitOnBike() then return false end
        task.wait(0.3)
    end

    local DriveSeat = h.SeatPart
    if not DriveSeat or DriveSeat.Name ~= "DriveSeat" then return false end

    local Vehicle = DriveSeat.Parent
    if not Vehicle then return false end

    Vehicle:PivotTo(CFrame.new(TargetPosition))
    for _, Object in pairs(Vehicle:GetDescendants()) do
        if Object:IsA("BasePart") then Object.Anchored = false end
    end
    task.wait(0.51)
    for _, Object in pairs(Vehicle:GetDescendants()) do
        if Object:IsA("BasePart") then Object.Anchored = true end
    end

    return true
end

local function cekDarah(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    
    hum.HealthChanged:Connect(function(hp)
        if not Configuration.Main_Settings["Auto Anti Death"] then return end
        if Configuration.State["RespawnPending"] then return end
        
        if hp > 0 and hp < 95 then
            Configuration.State["Status"] = "[ ANTI-DEATH ] : Taking damage, teleporting to safe zone!"
            DirtBikeTeleport(Locations.Healing)

        end
    end)
end

if Player.Character then
    cekDarah(Player.Character)
end

local function StartMarshmallowFarm()
    WaitForReady()
    Configuration.State["Status"] = "[ APARTMENTS ] : Finding an apartment."
    local Apartments, Ownership = FindAvailableApartments()
    if #Apartments == 0 then
        Configuration.State["Status"] = "[ APARTMENTS ] : None available."
        return false
    end

    local Apartment = Ownership == "Owned" and Apartments[1] or Apartments[Random:NextInteger(1, #Apartments)]
    local IsHome    = tostring(Apartment):match("Home")
    if IsHome then
        Configuration.State["Apartment"] = Workspace.Map.Locations.Apartments:FindFirstChild(tostring(Apartment))
    else
        Configuration.State["Apartment"] = Workspace.Map.Houses:FindFirstChild(tostring(Apartment))
    end


    if Ownership == "Not Owned" then
        local Board  = Apartment:FindFirstChild("Board", true)
        local Prompt = Board.backboard.ProximityPrompt
        Prompt.MaxActivationDistance = 9e9
        WaitForReady()
        DirtBikeTeleport(Board.backboard.Position)
        Configuration.State["Status"] = "[ APARTMENTS ] : Purchasing apartment."
        fireproximityprompt(Prompt)
        task.wait(2)
        local BoardText = Board.name.SurfaceGui.TextLabel.Text
        if BoardText ~= tostring(Player) then
            return StartMarshmallowFarm()
        end
    end

    local Lock       = Apartment.Door.DoorLock
    local KnobPrompt = Apartment.Door.Interact.Attachment.ProximityPrompt

    if math.abs(Lock.Part.Rotation.Y) > 5 and math.abs(Lock.Part.Rotation.Y - 90) > 5 then
        WaitForReady()
        KnobPrompt.MaxActivationDistance = 9e9
        DirtBikeTeleport(Lock.Part.Position)
        Configuration.State["Status"] = "[ APARTMENTS ] : Closing door."
        task.wait(0.5)
        local CloseAttempts = 0
        repeat
            fireproximityprompt(KnobPrompt)
            task.wait(1)
            CloseAttempts += 1
        until math.abs(Lock.Part.Rotation.Y) < 5 or CloseAttempts >= 10
        task.wait(0.5)
    end

    if Lock.Part.Rotation.X ~= 90 then
        WaitForReady()
        local LockPrompt = Lock.Part.ProximityPrompt
        LockPrompt.MaxActivationDistance = 9e9
        DirtBikeTeleport(Lock.Part.Position)
        Configuration.State["Status"] = "[ APARTMENTS ] : Locking door."
        task.wait(0.5)
        local LockAttempts = 0
        repeat
            fireproximityprompt(LockPrompt)
            task.wait(0.5)
            LockAttempts += 1
        until Lock.Part.Rotation.X == 90 or LockAttempts >= 10
        if Lock.Part.Rotation.X ~= 90 then
            return StartMarshmallowFarm()
        end
    end

    Configuration.State["Status"] = "[ APARTMENTS ] : Apartment secured."
    return true
end

local function PurchaseMarshmallowIngredients()
    WaitForReady()
    local _, _, Water, Gelatin, SugarBlockBag = ScavengeInventory()
    if Water >= 1 and Gelatin >= 1 and SugarBlockBag >= 1 then
        return true
    end
    local MarshRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
    DirtBikeTeleport(Locations.BuyMarsh)
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Buying ingredients."
    task.wait(0.5)
    if Water < 1         then MarshRemote:FireServer("Water")           task.wait(0.5) end
    if Gelatin < 1       then MarshRemote:FireServer("Gelatin")         task.wait(0.5) end
    if SugarBlockBag < 1 then MarshRemote:FireServer("Sugar Block Bag") task.wait(0.5) end
    return true
end

local function PourWater()
    WaitForReady()
    local AptObj = Configuration.State["Apartment"]
    if tostring(AptObj):match("Home") then
        Stove = AptObj:FindFirstChild("Cooking Pot")
    else
        Stove = AptObj:WaitForChild("Interior"):FindFirstChild("Cooking Pot")
    end
    CookPrompt = Stove:FindFirstChild("Attachment").ProximityPrompt
    StoveTimer  = Stove:FindFirstChild("Timer").TextLabel

    DirtBikeTeleport(Stove.Position)
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Pouring water."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Water"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Water")
        or PlayerGui:WaitForChild("Main").BasicNotification.TextTransparency == 0
        or Safety >= 10
    local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
    if notif == "You do not have permission to cook in this apartment." then
        return false
    end
    return true
end

local function AddSugarAndGelatin()
    WaitForReady()
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Adding sugar."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Sugar Block Bag"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Sugar Block Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Empty Bag")
        or Safety >= 5

    Configuration.State["Status"] = "[ MARSHMALLOW ] : Adding gelatin."
    Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Gelatin"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Gelatin")
        or PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Let")
        or Safety >= 5
end

local function BagMarshmallowAndSell()
    WaitForReady()
    Configuration.State["Status"] = "[ WAITING ] : Waiting for marshmallow to finish."
    DirtBikeTeleport(Locations.SafeZone)
    repeat task.wait() until StoveTimer and StoveTimer.Text == "0"
    DirtBikeTeleport(Stove.Position)
    Configuration.State["Status"] = "[ MARSHMALLOW ] : Bagging."
    repeat
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Empty Bag"))
        task.wait(0.5)
        fireproximityprompt(CookPrompt)
        task.wait(0.5)
        UnequipTools()
        task.wait(0.25)
    until Player:WaitForChild("Backpack"):FindFirstChild("Small Marshmallow Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Medium Marshmallow Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Large Marshmallow Bag")

    repeat WaitForReady() DirtBikeTeleport(Locations.BuyMarsh) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Lamont Bell")

    Configuration.State["Status"] = "[ MARSHMALLOW ] : Selling."
    local LamontBell   = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Lamont Bell")
    local LamontPrompt = LamontBell.UpperTorso.ProximityPrompt
    UnequipTools()
    for _, Object in next, Player:WaitForChild("Backpack"):GetChildren() do
        if tostring(Object):find("Marshmallow") then
            WaitForReady()
            DirtBikeTeleport(Locations.BuyMarsh)
            EquipTool(Player:WaitForChild("Backpack"):FindFirstChild(tostring(Object)))
            task.wait(0.5)
            fireproximityprompt(LamontPrompt)
            task.wait(0.5)
        end
    end
    Configuration.Statistics["Marshmallows Sold"] += 1
end

local function BuySkiMask()
    WaitForReady()
    local CurrentChar = Player.Character
    if not CurrentChar then return end
    if CurrentChar:FindFirstChild("White Ski Mask") then
        return
    end

    if not Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask") then
        Configuration.State["Status"] = "[ SETUP ] : Buying ski mask."
        local SkiMaskRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
        DirtBikeTeleport(Locations.SkiMask)
        task.wait(0.5)
        repeat
            SkiMaskRemote:FireServer("White Ski Mask")
            task.wait(0.5)
        until Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask")
    end

    EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask"))
    task.wait(0.05)
    RPC:FireServer(buffer.fromstring("\005"), Player.Character:WaitForChild("White Ski Mask"))
    task.wait(0.05)
    UnequipTools()
end

local function PurchasePotatoIngredients()
    WaitForReady()
    local Potato, Flour = ScavengeInventory()
    if Potato >= 1 and Flour >= 1 then
        return true
    end
    local PotatoRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Buying ingredients."
    DirtBikeTeleport(Locations.BuyPotato)
    task.wait(0.5)
    if Flour < 1  then PotatoRemote:FireServer("Flour")  task.wait(0.5) end
    if Potato < 1 then PotatoRemote:FireServer("Potato") task.wait(0.5) end
    return true
end

local function StartPotatoJob()
    WaitForReady()
    local Clipboard       = Labatory.Prompts.Clipboard
    local ClipboardPrompt = Clipboard.ProximityPrompt
    ClipboardPrompt.MaxActivationDistance = 9e9
    DirtBikeTeleport(Locations.Clipboard)
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Claiming task."
    task.wait(0.5)
    local Attempts = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.Clipboard)
        task.wait(0.25)
        fireproximityprompt(ClipboardPrompt)
        task.wait(0.5)
        Attempts += 1
    until PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Task:")
        or PlayerGui:WaitForChild("Main").BasicNotification.Text == "You have already began your task."
end

local function CutPotato()
    WaitForReady()
    local PotatoCutter = Labatory["Cutting Boards"]:FindFirstChild("Potato Cutter").Model.Union
    local CutterPrompt = PotatoCutter.Attachment.ProximityPrompt
    CutterPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Cutting potato."
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.PotatoCutter)
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Potato"))
        task.wait(0.25)
        fireproximityprompt(CutterPrompt)
        task.wait(0.5)
        UnequipTools()
        task.wait(0.25)
        local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Potato")
        or notif == "You are at the wrong step."
        or Safety >= 20
end

local function BagPotato()
    WaitForReady()
    local PlasticBag = Labatory.Prompts["Plastic Bag"]
    local BagPrompt  = PlasticBag.Attachment.ProximityPrompt
    BagPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Bagging potato."
    if Player:WaitForChild("Backpack"):FindFirstChild("Potato") then
        return
    end
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.PlasticBagLab)
        task.wait(0.25)
        fireproximityprompt(BagPrompt)
        task.wait(0.5)
        Safety += 1
        if Safety >= 15 then
            break
        end
    until PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Head")
end

local function MixFlourAndPotato()
    WaitForReady()
    local Bowl       = Labatory.Bowls:FindFirstChildOfClass("UnionOperation") or Labatory.Bowls:FindFirstChildWhichIsA("BasePart")
    if not Bowl then
        Configuration.State["Status"] = "[ POTATO CHIPS ] : Bowl not found!"
        return false
    end
    local BowlPrompt = Bowl:FindFirstChildWhichIsA("ProximityPrompt") or Bowl:FindFirstChild("Attachment"):FindFirstChild("ProximityPrompt")
    BowlPrompt.MaxActivationDistance = 9e9
    BowlPrompt.HoldDuration = 0
    BowlPrompt.RequiresLineOfSight = false
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Mixing flour and potato."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Flour"))
        task.wait(0.25)
        DirtBikeTeleport(Bowl.Position)
        task.wait(0.25)
        fireproximityprompt(BowlPrompt)
        task.wait(0.5)
        UnequipTools()
        Safety += 1
        if Safety >= 10 then
            DirtBikeTeleport(Locations.FlourBowl)
            WaitForReady()
            fireproximityprompt(BowlPrompt)
            task.wait(0.5)
            UnequipTools()
        end
    until not Player:WaitForChild("Backpack"):FindFirstChild("Flour") or Safety >= 15
    task.wait(3.5)
end

local function CookPotatoChips()
    WaitForReady()
    Configuration.State["Status"] = "[ POTATO CHIPS ] : Starting cook."
    AvailablePot = nil

    for _, Object in next, Labatory.Pots:GetChildren() do
        if AvailablePot then break end
        if Object:IsA("UnionOperation") then
            DirtBikeTeleport(Object.Position)
            task.wait(0.3)
            fireproximityprompt(Object.ProximityPrompt)
            task.wait(1)
            local Notif = PlayerGui:WaitForChild("Main").BasicNotification
            if Notif.TextTransparency == 0 then
                if Notif.Text:find("120 seconds") then
                    AvailablePot = Object
                    PotTimer     = Object.Timer.TextLabel
                    PotPrompt    = Object.ProximityPrompt
                end
                if Notif.Text:find("in use") then
                    repeat task.wait() until Notif.TextTransparency == 1
                end
            end
        end
    end

    if not AvailablePot then
        for _, Object in next, Labatory.Pots:GetChildren() do
            if AvailablePot then break end
            if Object:IsA("UnionOperation") then
                DirtBikeTeleport(Object.Position)
                task.wait(0.3)
                fireproximityprompt(Object.ProximityPrompt)
                task.wait(1)
                local Notif = PlayerGui:WaitForChild("Main").BasicNotification
                if Notif.TextTransparency == 0 and Notif.Text:find("120 seconds") then
                    AvailablePot = Object
                    PotTimer     = Object.Timer.TextLabel
                    PotPrompt    = Object.ProximityPrompt
                end
            end
        end
    end

    return AvailablePot ~= nil
end

local function ClaimPotatoChipsAndSell()
    WaitForReady()
    Configuration.State["Status"] = "[ WAITING ] : Waiting for potato chips to finish."
    DirtBikeTeleport(Locations.SafeZone)
    repeat task.wait() until PotTimer and PotTimer.Text == "0"

    Configuration.State["Status"] = "[ POTATO CHIPS ] : Claiming from pot."
    repeat
        WaitForReady()
        DirtBikeTeleport(AvailablePot.Position)
        fireproximityprompt(PotPrompt)
        task.wait(0.5)
    until Player:WaitForChild("Backpack"):FindFirstChild("Potato Chips")

    Configuration.State["Status"] = "[ POTATO CHIPS ] : Converting to hot chips."
    repeat WaitForReady() DirtBikeTeleport(Locations.HotChipsMan) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Poor Guy")

    local PoorGuy       = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Poor Guy")
    local PoorGuyPrompt = PoorGuy.UpperTorso.ProximityPrompt
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.HotChipsMan)
        fireproximityprompt(PoorGuyPrompt)
        UnequipTools()
        task.wait(0.05)
    until Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips")

    task.wait(3)

    Configuration.State["Status"] = "[ POTATO CHIPS ] : Giving to homeless."
    local AvailableHomeless = FindAvailableHomeless()
    if #AvailableHomeless == 0 then return false end

    for _, HomelessRef in next, AvailableHomeless do
        if not Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips") then break end
        local HomelessName = tostring(HomelessRef)
        repeat WaitForReady() DirtBikeTeleport(HomelessRef:FindFirstChild("UpperTorso").Position) task.wait(0.05)
        until Workspace:WaitForChild("Folders").HomelessPeople:FindFirstChild(HomelessName)
        local Homeless   = Workspace:WaitForChild("Folders").HomelessPeople:FindFirstChild(HomelessName)
        local UpperTorso = Homeless:FindFirstChild("UpperTorso")
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips"))
        task.wait(0.25)
        fireproximityprompt(UpperTorso.ProximityPrompt)
        task.wait(0.5)
        UnequipTools()
    end

    Configuration.Statistics["Chips Fed"] += 1
    return true
end

local function PurchaseFakeID()
    WaitForReady()
    Configuration.State["Status"] = "[ CARDS ] : Buying fake ID."
    repeat WaitForReady() DirtBikeTeleport(Locations.FakeID) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")

    local FakeIDSeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
    local BuyIDPrompt  = FakeIDSeller.UpperTorso.Attachment.ProximityPrompt
    repeat
        WaitForReady()
        repeat DirtBikeTeleport(Locations.FakeID) task.waitakeID) task(0.05)
        until Workspace:Wait.wait(0.05)
        untilForChild("Folders").NPCs Workspace:WaitForChild("Fold:FindFirstChilders").NPCs:FindFirstChild("FakeIDSeller")
        Fake("FakeIDSeller")
        FakeIDSeller = Workspace:WaitForChild("Folders").NPCs:IDSeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FindFirstChild("FakeIDSellerFakeIDSeller")
        BuyID")
        BuyIDPrompt  = FakePrompt  = FakeIDSeller.UpperTorso.Attachment.ProximityIDSeller.UpperTorso.Attachment.ProximityPrompt
        DPrompt
        DirtBikeTeleport(Locations.FakeID)
        local SkiMask = Player.irtBikeTeleport(Locations.FakeID)
       Character and Player. local SkiMask = Player.Character and Player.Character:FindFirstCharacter:FindFirstChild("White Ski Mask")
            or Player:WaitChild("White Ski Mask")
            orForChild("Backpack"):Find Player:WaitForChild("Backpack"):FindFirstChild("WhiteFirstChild("White Ski Mask")
        Ski Mask")
        if SkiMask then if SkiMask then
            EquipTool(SkiMask)
            task.wait
            EquipTool(SkiMask)
            task.wait(0.25(0.25)
)
        end        end
        fireproximityprompt(BuyIDPrompt
        fireproximityprompt(BuyIDPrompt)
        Unequip)
        UnequipTools()
        task.wait(4)
Tools()
        task.wait(4)
    until Player:WaitForChild    until Player:WaitForChild("Backpack"):FindFirstChild("Fake ID")
end("Backpack"):FindFirstChild("Fake ID")
end

local function ApplyForCard()


local function ApplyForCard()
    WaitForReady()
    Configuration.State["Status"] = "[ CARDS ] : Applying for credit card."
    repeat D    WaitForReady()
    Configuration.State["Status"] = "[ CARDS ] : Applying for credit card."
    repeat DirtBikeTeleirtBikeTeleport(Locations.ApplyForCardport(Locations.ApplyForCard) task.wait(0.05) task.wait(0.05)
    until Workspace:WaitForChild)
    until Workspace:WaitForChild("Folders").NPCs:Find("Folders").NPCs:FindFirstChild("Bank Teller")

FirstChild("Bank Teller")

    local BankTeller = Workspace    local BankTeller = Workspace:WaitForChild("Folders").NPCs:FindFirst:WaitForChild("Folders").NPCs:FindFirstChild("Bank Teller")
    localChild("Bank Teller")
    local BankPrompt = BankTeller.Upper BankPrompt = BankTeller.UpperTorso.Attachment.ProximityPrompt
    local Safety     = Torso.Attachment.ProximityPrompt
    local Safety     = 0
    repeat
        WaitForReady()
       0
    repeat
        WaitForReady()
        Dirt DirtBikeTeleport(Locations.ApplyForCardBikeTeleport(Locations.ApplyForCard)
        EquipTool(Player:)
        EquipTool(Player:WaitForChild("Backpack"):WaitForChild("Backpack"):FindFirstChild("Fake IDFindFirstChild("Fake ID"))
        task.wait("))
        task.wait(0.5)
        fireproximityprompt(BankPrompt)
       0.5)
        fireproximityprompt(BankPrompt)
        task.wait(0.5)
        task.wait(0.5)
        UnequipTools()
        Safety += UnequipTools()
        Safety += 1
    until not Player 1
    until not Player:WaitForChild:WaitForChild("Backpack"):FindFirstChild("Fake ID("Backpack"):FindFirstChild") or Safety >= 15

   ("Fake ID") or Safety >= 15

    if Safety >=  if Safety >= 15 then
        WaitForReady15 then
        WaitForReady()
        Configuration.State["Status"] =()
        Configuration.State["Status"] = "[ CARDS ] : Claiming card early "[ CARDS ] : Claiming card early."
        local Card       = Workspace:WaitFor."
        local Card       = Workspace:WaitForChild("CardPickChild("CardPickup")
        local CardPrompt = Card.Attachment.Proup")
        local CardPrompt = Card.Attachment.ProximityPromptximityPrompt
        for _ =
        for _ = 1,  1, 10 do
           10 do
            DirtBikeTeleport(Card.Position)
            DirtBikeTeleport(Card.Position)
            fireproxim fireproximityprompt(CardPrompt)
            task.wait(0.ityprompt(CardPrompt)
            task.wait(0.05)
            UnequipTools05)
            UnequipTools()
        end
   ()
        end
    end
end end
end

local function ClaimAndUseCard()
    WaitForReady

local function ClaimAndUseCard()
    WaitForReady()

    local()

    local function HasCard()
        local backpack = Player:FindFirstChild function HasCard()
        local backpack = Player:FindFirstChild("Backpack")
        if backpack and("Backpack")
        if backpack and backpack:FindFirstChild("Card backpack:FindFirstChild("Card") then return true end
       ") then return true end
        local char = Player.Character
        if local char = Player.Character
        if char and char: char and char:FindFindFirstChild("Card") then returnFirstChild("Card") then return true end
        return false
    true end
        return false
    end

    if HasCard() then end

    if HasCard() then
        Configuration.State["Status"] = "[ CARDS
        Configuration.State["Status"] = "[ CARDS ] : Card already owned, going to ATM ] : Card already owned, going to ATM."
    else
       ."
    else
        Configuration.State["Status"] = "[ CARDS ] : Teleporting to card Configuration.State["Status"] = "[ CARDS ] : Teleporting to card pickup."
        DirtBikeTele pickup."
        DirtBikeTeleport(Locations.CollectCardport(Locations.CollectCard)
        task.wait(1)
        local)
        task.wait(1)
        local Card = Workspace:FindFirst Card = Workspace:FindFirstChild("CardPickup")
        if not Card then
            forChild("CardPickup")
        if not Card then
            for _, obj _, obj in next, Workspace: in next, Workspace:GetDescendants() do
                ifGetDescendants() do
                if obj.Name == "Card obj.Name == "CardPickup" then Card = obj; break end
Pickup" then Card = obj;            end
        end
        if not break end
            end
        end
        if not Card then
            Card then
            Configuration.State["Status"] = "[ CARDS ] : Card Configuration.State["Status"] = "[ CARPickup not found!"
            return false
        end
DS ] : CardPickup not found!"
            return false        local CardPrompt
        if Card
        end
        local CardPrompt
        if Card:FindFirstChild:FindFirstChild("Attachment") then
            CardPrompt = Card.Attachment("Attachment") then
            CardPrompt = Card.Attachment:FindFirstChildWhichIsA("Proximity:FindFirstChildWhichIsA("ProximityPrompt")
        endPrompt")
        end
        if not CardPrompt then
            CardPrompt = Card
        if not CardPrompt then
            CardPrompt = Card:FindFirstChildWhichIsA("ProximityPrompt:FindFirstChildWhichIsA("ProximityPrompt", true)
        end
        if not CardPrompt then
           ", true)
        end
        if not CardPrompt then
            Configuration.State Configuration.State["Status"] = "[ CARDS ] : Card prompt not["Status"] = "[ CARDS ] : Card prompt not found!"
            return found!"
            return false
        end
        CardPrompt.MaxActivationDistance false
        end
        CardPrompt.MaxActivationDistance = 9e = 9e9
        CardPrompt.HoldDuration = 09
        CardPrompt.HoldDuration = 0
        CardPrompt.RequiresLineOf
        CardPrompt.RequiresLineOfSight = false
        local SafetySight = false
        local Safety = 0
        repeat
            = 0
        repeat
            WaitForReady()
            DirtBikeTeleport(Card:GetP WaitForReady()
            DirtBikeTeleport(Card:GetPivot().Position or Card.Position)
            task.wait(0.25ivot().Position or Card.Position)
            task.wait()
            fireproximityprompt(CardPrompt)
           0.25)
            fireproximityprompt(CardPrompt)
            task.wait(0.5)
            task.wait(0.5)
            Safety += 1
        until Has Safety += 1
        until HasCard()
            or PlayerGui:WaitForChild("MainCard()
            or PlayerGui:WaitForChild("Main").BasicNotification.Text:find").BasicNotification.Text:find("not on the wait list("not on the wait list")
            or Safety >= 15

       ")
            or Safety >= 15

        if not HasCard if not HasCard()
            and Player()
            and PlayerGui:WaitForGui:WaitForChild("Main").BasicNotification.Text:Child("Main").BasicNotification.Text:find("not on the wait list") then
           find("not on the wait list") then
            Configuration.State["Status Configuration.State["Status"] ="] = "[ CARDS ] : Not on wait list, skipping."
            return false
        end
    end

    if not "[ CARDS ] : Not on wait list, skipping."
            return false
        end
    end

    if not HasCard() then
        Configuration.State HasCard() then
        Configuration.State["Status"] = "[ CARDS ]["Status"] = "[ CARDS ] : No card to use."
        return : No card to use."
        return false
    end

    repeat
        local AvailableATM = FindAvailableAT false
    end

    repeat
        local AvailableATMMs()
        if not AvailableATM then
            Configuration.State = FindAvailableATMs()
        if not AvailableATM then
            Configuration.State["Status"] = "[ CARDS ]["Status"] = "[ CARDS ] : No available ATM."
            return false : No available ATM."
            return false
        end

        local ATMP
        end

        local ATMPrompt = AvailableATM.Attachment:rompt = AvailableATM.Attachment:FindFirstChildWhichIsA("FindFirstChildWhichIsA("ProximityPrompt")
        if not ATProximityPrompt")
        if not ATMPrompt thenMPrompt then
            Configuration.State["Status"] =
            Configuration.State["Status"] = "[ CARDS ] : ATM prompt not found "[ CARDS ] : ATM prompt not found."
            return false
        end
        ATMPrompt."
            return false
        end
        ATMPrompt.MaxActivationDistance.MaxActivationDistance = 9e = 9e9
        ATMPrompt.HoldDuration9
        ATMPrompt.HoldDuration = 0
        ATMP = 0
        ATMPrompt.RequiresLineOfSightrompt.RequiresLineOfSight = false
        WaitForReady()
        Configuration.State = false
        WaitForReady()
        Configuration.State["Status"] =["Status"] = "[ CARDS ] "[ CARDS ] : Using card at : Using card at ATM."
        local ATM."
        local OldATM OldATM = PlayerGui:FindFirst = PlayerGui:FindFirstChild("ATM")
        if OldChild("ATM")
        if OldATM then OldATM:Destroy() endATM then OldATM:Destroy() end
        repeat
            WaitForReady
        repeat
            WaitForReady()
            DirtBikeTeleport()
            DirtBikeTeleport(AvailableATM.Position)
           (AvailableATM.Position)
            fireproximityprompt(ATMPrompt)
            task.wait( fireproximityprompt(ATMPrompt)
            task.wait(0.05)
       0.05)
        until PlayerGui:FindFirstChild("ATM")
        EquipTool(Player until PlayerGui:FindFirstChild("ATM")
        EquipTool(Player:FindFirstChild("Backpack"):FindFirstChild("Card"))
       :FindFirstChild("Backpack"):FindFirstChild("Card"))
        task.wait(0.5)
        replicatesignal(PlayerGui:WaitFor task.wait(0.5)
        replicatesignal(PlayerGui:WaitForChild("ATM").Frame.SChild("ATM").Frame.Swipewipe.MouseButton1Click)
        Configuration.State["Status.MouseButton1Click)
        Configuration.State["Status"] ="] = "[ CARDS ] : "[ CARDS ] : Swiping card."
        task.wait( Swiping card."
        task.wait(0.5)
        UnequipTools()
    until not HasCard0.5)
        UnequipTools()
    until not HasCard()
    Configuration.Statistics["Cards Swiped"] += ()
    Configuration.Statistics["Cards Swiped"] += 1
end1
end

local AutofarmRunning = false

local function Main

local AutofarmRunning = false

local function MainAutofarmControllerAutofarmController()
    if Aut()
    if AutofarmRunning thenofarmRunning then return end
    AutofarmRunning = true

    return end
    while Configuration.Main_Settings AutofarmRunning = true

    while Configuration.Main_Settings["["Autofarming"]Autofarming"] do
        Wait do
        WaitForReady()

       ForReady()

        BuySkiMask()

        local ApartmentOk = Start BuySkiMask()

        local ApartmentOk = StartMMarshmallowFarm()
        ifarshmallowFarm()
        if not ApartmentOk then task.wait( not ApartmentOk then task.wait5) continue end

        PurchaseMarshmallowIngredients()

        local(5) continue end

        PurchaseMarshmallow WaterOk = PourWater()
        ifIngredients()

        local WaterOk = PourWater()
        if not WaterOk then not WaterOk then
            repeat Start
            repeat StartMarshmallowMarshmallowFarm() WaterOk = PourWaterFarm() WaterOk = PourWater() until WaterOk
        end

        PurchasePotatoIngredients()
        Start() until WaterOk
        end

        PurchasePotatoIngredients()
        StartPotatoJob()
        CutPotPotatoJob()
        CutPotato()
        BagPotato()
       ato()
        BagPotato()
        MixFlourAndPotato()
        MixFlourAndPotato()
        CookPotatoChips()

        PurchaseFakeID()
        ApplyForCard()

        AddSugarAndGelatin CookPotatoChips()

        PurchaseFakeID()
        ApplyForCard()

        AddSugarAndGelatin()

        Configuration.State()

        Configuration.State["Status"] = "[ WAITING ] : Waiting["Status"] = "[ WAITING ] : Waiting for card approval."
        local for card approval."
        local cardApproved = false
        repeat
            task.wait cardApproved = false
        repeat
            task.wait()
            local not()
            local notif = PlayerGuiif = PlayerGui:WaitForChild:WaitForChild("Main").BasicNotification.Text
            if not("Main").BasicNotification.Textif:find("successful") or
            if notif:find("successful") or notif:find notif:find("30 seconds") then
               ("30 seconds") then
                cardApproved = true
            end cardApproved = true
            end
        until cardApproved or Player
        until cardApproved or PlayerGui:WaitForChild("Main").TaskUpdate.TextGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:matchLabel.Text:match("Bag")

        if cardApproved then
            Configuration("Bag")

        if cardApproved then
            Configuration.State["Status"] = "[ MARSH.State["Status"] = "[ MARSHMALLOW ] : Doing marshmMALLOW ] : Doing marshmallow while card spawns..."
            Bagallow while card spawns..."
            BagMarshmallowAndSellMarshmallowAndSell()
            Configuration.State["Status"] =()
            Configuration.State["Status"] = "[ CARDS ] : Taking card."
            "[ CARDS ] : Taking card."
            DirtBikeTele DirtBikeTeleport(Lport(Locations.CollectCardocations.CollectCard)
            task.wait(0.5)
            ClaimAnd)
            task.wait(0.5)
            ClaimAndUseCard()
       UseCard()
        end
        ClaimPotato end
        ClaimPotatoChipsAndSell()

        AvailablePot = nilChipsAndSell()

        Available
        PotPromptPot = nil
        PotPrompt    = nil    = nil
        PotTimer    
        PotTimer     = nil
        = nil
        Stove        = Stove        = nil
 nil
        CookPrompt        CookPrompt   = nil
        StoveTimer   = nil   = nil
        StoveTimer   = nil
    end
    end

    AutofarmRunning = false
end

local function

    AutofarmRunning = false
end

local function SendWebhook()
    if Configuration.Webhook_Settings[" SendWebhook()
    if Configuration.Webhook_Settings["Webhook Url"]Webhook Url"] == "" then return == "" then return end

    local charName    = GetCharName end

    local charName   ()
    local currentCash = GetCurrent = GetCharName()
    local currentCash = GetCurrentCash()
    localCash()
    local runtime     = Configuration.Statistics["Runtime runtime     = Configuration.Statistics["Runtime"]

    local payload"]

    local payload = HttpService:JSONEncode({
        username = " = HttpService:JSONEncode({
        username = "Autofarm Webhook",
        embAutofarm Webhook",
        embeds = {{
            title = "eds = {{
            title = "Autofarm Webhook : ||" .. Player.Name .. "||Autofarm Webhook : ||" .. Player.Name .. "|| : " .. charName,
            color : " .. charName,
            color = 652 = 65280,
            fields = {
                { name = "[ ðŸ’³ ] Cards80,
            fields = {
                { name = "[ ðŸ’³ ] Cards Swiped",      value = GetCommaValue( Swiped",      value = GetCommaValue(Configuration.Statistics["Cards Swiped"]Configuration.Statistics["Cards Swiped"]),      inline = true },
                { name = "[ ðŸ),      inline = true },
                { name = "[ ðŸ ] Chips Fed",ŸŸ ] Chips Fed",          value = Get          value = GetCommaValue(Configuration.Statistics["Chips Fed"]CommaValue(Configuration.Statistics["Chips Fed"]),          inline =),          inline = true },
                { name = "[ ð true },
                { name = "[ ðŸ§‚ ] Marshmallows Sold", Ÿ§‚ ] Marshmall value = GetCommaValue(Configurationows Sold",  value = GetCommaValue(Configuration.Statistics["M.Statistics["Marshmallows Soldarshmallows Sold"]), inline ="]), inline = true },
                { true },
                { name = "[ ð name = "[ ðŸ’° ] Cash Made",          value = GetŸ’° ] Cash Made",CommaValue(Configuration          value = GetCommaValue(Configuration.Statistics["Cash Made"]),.Statistics["Cash Made"]),          inline = true },
                { name          inline = true },
                { name = "[ ðŸ’¸ ] = "[ ðŸ’¸ ] Current Cash",       value Current Cash",       value = currentCash,                                                   inline = true },
                = currentCash,                                                   inline = true },
                { name = { name = "[ ðŸ• ] Autofarm Runtime",   value = Format "[ ðŸ• ] Autofarm Runtime",   value = FormatRuntime(runtime),                                        inline = trueRuntime(runtime),                                        inline = true },
                { name = "[ â },
                { name = "[ âŒ› ] ETA Until Goal",     value = GetETA(),                                Œ› ] ETA Until Goal",     value = GetETA(),                                                      inline = true },
                {                      inline = true },
                { name = "[ ðŸ name = "[ ðŸ”„ï¸ ] Times Rejoined",    value =”„ï¸ ] Times Rejoined",    value = GetCommaValue(Configuration.Statistics["Times Rejoined"]),    inline GetCommaValue(Configuration.Statistics["Times Rejoined"]),    inline = true },
            },
        } = true },
            },
        }},
   },
    })

    local req = })

    local req = syn and syn.request syn and syn.request or http and or http and http.request or request
    pcall(req, {
        http.request or request
    pcall(req, {
        Url     = Configuration Url     = Configuration.Webhook_S.Webhook_Settings["Webhook Url"],
        Method  = "POSTettings["Webhook Url"],
        Method  = "POST",
        Head",
        Headers = { ["Content-Type"] = "application/json"ers = { ["Content-Type"] = "application/json" },
        Body    },
        Body    = payload,
    = payload,
    })
end })
end
local SafeFont = function(id, weight, style)
   
local SafeFont = function(id, weight, style)
    weight = weight or weight = weight or Enum.FontWeight.Regular
    style Enum.FontWeight.Reg = style or Enum.FontStyle.Normal
    local ok, font = pular
    style = style or Enum.FontStyle.Normal
    local okcall(Font.new, id, weight, font = pcall(Font.new, style)
    if ok then return, id, weight, style)
    if ok then return font end
    font end
    local ok2, local ok2, font2 = pcall(Font.fromId, id)
    if ok2 font2 = pcall(Font.fromId, id)
    if ok2 then return font2 end
    return then return font2 end
    return Font.new(id)
end
local Service Font.new(id)
end
local ServiceCache = {};
local Services = setCache = {};
local Services = setmetatable({}, {__index =metatable({}, {__index = function(Self, function(Self, Index)
    if not ServiceCache[Index] then
        ServiceCache Index)
    if not ServiceCache[Index] then
        ServiceCache[Index] = cloneref(game[Index] = cloneref(game:GetService(:GetService(Index));
    end;
    return ServiceIndex));
    end;
    return ServiceCache[Index];
end});
_G.Services = Services
-- Simple GUI replacedCache[Index];
end});
_G.Services = Services
-- Simple GUI replaced with Kiwisense
local Library = (function with Kiwisense
local Library = (function()
    local raw =()
    local raw = game:HttpGet("https://raw.githubusercontent.com/sam game:HttpGet("https://raw.githubusercontent.com/sametexe001/setexe001/sametlibs/refs/ametlibs/refs/heads/main/Kiwisense/Lheads/main/Kiwisense/Library.lua")
   ibrary.lua")
    raw = raw:gsub("%%f%%[%a%%] raw = raw:gsub("%%f%%[%a%%]Esp%%f%%[%AEsp%%f%%[%A%%]", "Kiwisense%%]", "KiwisenseEsp")
    raw = raw:gEsp")
    raw = raw:gsub("FromRGB%(196, sub("FromRGB%(196, 231, 255%)", "From231, 255%)", "FromRGB(244, 154, RGB(244, 154, 193)")
    raw = raw:gsub('Text = "keybinds193)")
    raw = raw:gsub('Text = "keybinds",', 'Text = "Key",', 'Text = "Keybinds",binds",')
    raw = raw:gsub('Text = "%("')
    raw = raw:gsub('Text = "%(" %.%. Key %.%. %.%. Key %.%. "%) % "%) %- "%.%. Name %.%. "",', '- "%.%. Name %.%. "",', 'Text = Key .. " - " ..Text = Key .. " - " .. Name,')
    raw = raw:gsub('New Name,')
    raw = raw:gsub('NewKey%.InstanceKey%.Instance%.Text =  "%(" %.%.%.Text =  "%(" %.%. Key %.%. "%) %- "%.%. Name %.%. ""', 'NewKey.Instance.Text Key %.%. "%) %- "%.%. Name %.%. ""', 'NewKey.Instance.Text = Key .. " - " .. Name')
    raw = Key .. " = raw:gsub('AnchorPoint = Vector2New%(1, - " .. Name')
    raw = raw:gsub('AnchorPoint = Vector2New 0%),', 'AnchorPoint = Vector2New(0%(1, 0%),', 'AnchorPoint = Vector2New(0, 0),')
    raw =, 0),')
    raw = raw:gsub('Position = U raw:gsub('Position = UDim2New%(1, 50, 0, 0%),',Dim2New%(1, 50, 0, 0%),', 'Position = UDim2New(1, 5, 0, 'Position = UDim2New(1, 5, 0, 0),')
    raw = raw 0),')
    raw = raw:gsub('function NewKey::gsub('function NewKey:SetStatus%(Status%)%s*NewKeyStatus%.InstanceSetStatus%(Status%)%s*NewKeyStatus%.Instance%.Text = Status%s*end', [[function NewKey:SetStatus(Status%.Text = Status%s*end', [[function NewKey:SetStatus(Status)
                    local formatted)
                    local formattedStatus = tostring(Status):gsub("^%%Status = tostring(Status):gsub("^%%l", string.upper)
                    NewKeyStatusl", string.upper)
                    NewKeyStatus.Instance.Instance.Text = "(".Text = "(" .. formattedStatus .. .. formattedStatus .. ")"
                ")"
                end]])
    raw = raw:g end]])
    raw = raw:gsub('if Keybind%.sub('if Keybind%.Mode == "holdMode == "hold" then%s*KeylistItem:" then%s*KeylistItem:SetStatus%(Keybind%.SetStatus%(Keybind%.Toggled and "holding" orToggled and "holding" or "off"%)%s*else%s*KeylistItem:SetStatus "off"%)%s*else%s*KeylistItem:SetStatus%(Keybind%.Toggled and%(Keybind%.Toggled and "on" or "off"%) "on" or "off%s*end',"%)%s*end', [[if Keybind.Mode == "hold [[if Keybind.Mode == "hold" then 
                   " then 
                    KeylistItem:SetStatus("hold KeylistItem:SetStatus("hold")
                else
                    KeylistItem")
                else
                    KeylistItem:SetStatus("toggle")
                end]])
    raw = raw:gsub:SetStatus("toggle")
                end]])
    raw = raw:gsub('AutomaticSize = Enum%.AutomaticSize%.X,%('AutomaticSize = Enums*BackgroundColor3 = From%.AutomaticSize%.X,%s*BackgroundColor3 = FromRGB%(16, 18,RGB%(16, 18, 21%)%s*}%) 21%)%s*}%)%s*Items%s*Items%["Version%["Version"%]:AddToTheme', [[Aut"%]:AddToTheme', [[AutomaticSize = Enum.AutomaticSize.X,
                    Visible = (Window.VersionomaticSize = Enum.AutomaticSize.X,
                    Visible = (Window.Version ~= nil and Window ~= nil and Window.Version ~.Version ~= "" and Window.Version ~= "nil"),
                   = "" and Window.Version ~= BackgroundColor3 = FromRGB(16 "nil"),
                    BackgroundColor3 = FromRGB(16, 18,, 18, 21)
                21)
                })  Items })  Items["Version"]:["Version"]:AddToThemeAddToTheme]])
    raw = raw:gsub(']])
    raw = raw:gsub('AutomaticSize%s*=%s*Enum%.AutomaticSize%.AutomaticSize%s*=%sX,%s*AnchorPoint%s**Enum%.AutomaticSize%.X,%s*AnchorPoint%s*=%s*Vector2New%s*%(%s=%s*Vector2New%s*%(%s**1,%s*1,%s*0%s*%),%s*Size%s*=%0%s*%),%s*s*UDim2New%s*Size%s*=%s*UDim2New%s*%(%s*%(%s*0,%s*0,%s*0,%s0,%s*0,%s*0,%s*15%s*%),%s*BackgroundTransparency%s**15%s*%),%s*BackgroundTransparency%s*=%s*1,%s*Position=%s*1,%s*Position%s*=%s*UDim2New%s*%(%s*1%s*=%s*UDim2New%s*%(%s*1,%s*0,%s*0,%s*0,%s*0,%s*0%s*%),', [[Visible = false,
                    AnchorPoint = Vector,%s*0%s*%),', [[Visible = false,
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(2New(1, 0),
                    Size = UDim2New(0, 0, 0, 0,0, 0, 15),
                    BackgroundTransparency = 15),
                    BackgroundTransparency = 1,
                    1,
                    Position = UDim Position = UDim2New(1, 0, 0, 2New(1, 0, 0, 0),]])
   0),]])
    return loadstring(raw)()
end)()

local executorName return loadstring(raw)()
end)()

local executorName = (identifyexecutor or getexecutorn = (identifyexecutor or getexecutorname or function() return "Unknown" end)()
local Window = Library:ame or function() return "Unknown" end)()
local Window = Library:Window({
    Name = "PhantomWindow({
    Name = "Phantom - MultiFarm",
    Version = - MultiFarm",
    Version = "",
    Logo = " "",
    Logo = "135215559087473",
    FadeSpeed = 0.25135215559087473",
    FadeSpeed = 0.25,
})

local Watermark = Library:Watermark(executorName .. ",
})

local Watermark = Library:Watermark(executorName .. " - " .. Player.Name .. " - " .. os.date("%I:%M - " .. Player.Name .. " - " .. os.date("%I:%M %p"), "135215559087 %p"), "135215559087473")
Watermark473")
Watermark:SetVisibility(true:SetVisibility(true)
local Keybind)
local KeybindList = Library:KeybindsList()
KeybindListList = Library:KeybindsList()
KeybindList:SetVisibility(true:SetVisibility(true)

local Pages =)

local Pages = {
    ["Mult {
    ["Multifarm"] = Window:Page({
        Name = "ifarm"] = Window:Page({
        Name = "MultifarmMultifarm",
        Icon = "109463522861706",
       ",
        Icon = "109463522 Columns = 2
    }),
   861706",
        Columns = 2
    }),
    ["Settings"] = ["Settings"] = Window:Page({
        Name = "Settings",
        Icon Window:Page({
        Name = "Settings",
        Icon = "137300 = "137300573942266573942266",
        Columns = 2,
        SubPages = true",
        Columns = 2,
        SubPages = true
    })
}

local SettingsSection = Pages["Mult
    })
}

local SettingsSection =ifarm"]:Section({Name = "Main Settings", Side = 1 Pages["Multifarm"]:Section({Name = "Main Settings", Side = 1})
local GoalSection = Pages["Multifarm"]:Section({Name = "})
local GoalSection = Pages["Multifarm"]:Section({Name = "Goal Settings", Side = 1Goal Settings", Side = 1})
local StatsSection = Pages["Multif})
local StatsSection = Pages["Multifarm"]:Section({Name = "arm"]:Section({Name = "Statistics", Side = 2})
localStatistics", Side = 2})
local WebhookSection = Pages["Multif WebhookSection = Pages["Multifarm"]:Section({Name = "arm"]:Section({Name = "Webhook Settings", Side = 2})

local AutofarmToggle =Webhook Settings", Side = 2})

local AutofarmToggle = SettingsSection:Toggle SettingsSection:Toggle({
    Name({
    Name = "Autofarming",
    Flag = "Autofarming = "Autofarming",
    Flag = "Autofarming",
    Default = Configuration.Main_S",
    Default =ettings["Autofarming"],
    Call Configuration.Main_Settings["Autofarming"],
    Callback = function(back = function(Value)
        Configuration.Main_Settings["AutofarmingValue)
        Configuration.Main_Settings"] = Value
        if Value then["Autofarming"] = Value
            task.spawn(function()
               
        if Value then
            task.spawn(function()
                repeat task.wait(0.5) repeat task.wait(0.5) until SpawnAndSitOnBike() or not Configuration.Main_S until SpawnAndSitOnBettings["Autofarming"]
                ifike() or not Configuration.Main_Settings["Autofarming"]
                if Configuration.Main_Settings["Autof Configuration.Main_Settings["Autofarming"] then
                    MainAutofarming"] then
                    MainAutofarmController()
                end
            endarmController()
                end
            end)
        end)
        end
    end
})

SettingsSection:Toggle({
    Name =
    end
})

SettingsSection:Toggle({
    Name = "Auto Rob Casino "Auto Rob Casino",
    Flag = "AutoRobCasino",
    Default",
    Flag = "AutoRobCasino",
    Default = Configuration = Configuration.Main_Settings.Main_S["ettings["AutoAuto Rob Casino"],
    Callback = function(Value)
        Configuration.Main_Settings["Auto Rob Casino"] = Value
    end
})

 Rob Casino"],
    Callback = function(Value)
        Configuration.Main_Settings["Auto Rob Casino"] = Value
    end
})

SettingsSection:Toggle({
    Name = "Auto Anti DeathSettingsSection:Toggle({
    Name = "Auto Anti Death",
    Flag = "AutoAntiDeath",
    Default = Configuration.Main",
    Flag = "AutoAntiDeath",
    Default = Configuration.Main_Settings["Auto Anti Death"],
    Callback = function_Settings["Auto Anti Death"],
    Callback = function(Value)
       (Value)
        Configuration.Main_Settings["Auto Anti Configuration.Main_Settings["Auto Anti Death"] = Value Death"] = Value
    end
})

SettingsSection:Toggle({
    Name
    end
})

SettingsSection:Toggle({
    Name = "Auto Rejoiner",
    Flag = "Auto = "Auto Rejoiner",
    Flag = "AutoRejoinerRejoiner",
    Default = Configuration.Main_Settings["Auto Rejo",
    Default = Configuration.Main_Settings["Auto Rejoiner"],
    Calliner"],
    Callback = function(Value)
        Configuration.Mainback = function(Value)
        Configuration.Main_Settings["Auto Rejo_Settings["Auto Rejoiner"] = Value
    endiner"] = Value
    end
})

SettingsSection:
})

SettingsSection:Toggle({
    NameToggle({
    Name = "Performance Sa = "Performance Saver",
    Flagver",
    Flag = "PerformanceSaver",
    Default = Configuration.Main_Settings["Performance Saver"],
    = "PerformanceSaver",
    Default = Configuration.Main_Settings["Performance Saver"],
    Callback = function Callback = function(Value)
        Configuration.Main_Settings["Performance Sa(Value)
        Configuration.Main_Settings["Performance Saver"] = Value
        if setver"] = Value
        if setfpscap then setfpscap(Value and 15 or 100fpscap then setfpscap(Value and 15 or 1000) end
        RunService:0) end
        RunService:Set3dRenderingEnabled(notSet3dRenderingEnabled(not Value)
    end
})

SettingsSection:Button({
    Name = "Purchase Value)
    end
})

SettingsSection:Button({
    DirtBike ($35000 Name = "Purchase DirtBike ($35000)",
    Callback)",
    Callback = function()
        local Event = game = function()
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.RPC
        Event::GetService("ReplicatedStorage").RemoteEvents.RPC
        Event:FireServer(buffer.fromstring("\x01FireServer(buffer.fromstring("\x01"), "Purchase", "DirtBike")
    end
})

GoalSection"), "Purchase", "DirtBike")
    end
:Label("How this system works:",})

GoalSection:Label("How this system works:", "Left")
Goal "Left")
GoalSection:Label("Make the target amount > kick clientSection:Label("Make the target amount > kick client.", "Left")

GoalSection:Toggle.", "Left")

GoalSection:Toggle({
    Name = "Enabled",
   ({
    Name = "Enabled",
    Flag = "GoalEnabled",
    Default Flag = "GoalEnabled",
    Default = Configuration.Goal_Settings[" = Configuration.Goal_Settings["Enabled"],
    Callback = function(Enabled"],
    Callback = function(Value)
        ConfigurationValue)
        Configuration.Goal_Settings["Enabled"] = Value
    end
})

local Target.Goal_Settings["Enabled"] = Value
    end
})

local TargetAmountSlider
local TargetAmountTextboxAmountSlider
local TargetAmountTextbox

TargetAmountSlider = GoalSection:Slider({
    Name = "

TargetAmountSlider = GoalSection:Slider({
    Name = "Target Amount",
    Flag = "TargetTarget Amount",
    Flag = "TargetAmountSlider",
    Min = 0AmountSlider",
    Min = 0,
    Max = 1750000,
    Default = Configuration.Goal_S,
    Max = 1750000,
    Default = Configuration.Goal_Settings["Target Amount"],
    Suffix = " dollarsettings["Target Amount"],
    Suffix = " dollars",
    Decimals = 1",
    Decimals = 1,
    Callback = function(Value,
    Callback = function(Value)
        local num = math.floor(Value)
        Configuration.Goal_Settings[")
        local num = math.floor(Value)
        Configuration.Goal_Settings["Target Amount"] = num
        ifTarget Amount"] = num
        if TargetAmountTextbox and TargetAmountText TargetAmountTextbox and TargetAmountTextbox:Get() ~= tostring(num) thenbox:Get() ~= tostring(num) then
            TargetAmountText
            TargetAmountTextbox:Set(tostring(num))
        endbox:Set(tostring(num))
        end
    end

    end
})
TargetAmountTextbox})
TargetAmountTextbox = GoalSection:Textbox = GoalSection:Textbox({
    Name = "Target Amount",
   ({
    Name = "Target Amount",
    Flag = "TargetAmount",
    Flag = "TargetAmount",
    Placeholder = "250000",
    Default Placeholder = "250000",
    Default = tostring( = tostring(Configuration.Goal_Settings["Target Amount"]),
    CallConfiguration.Goal_Settings["Target Amount"]),
    Callback = function(Value)
        local num = tonback = function(Value)
        local num = tonumber(Value)
        if num then
            Configuration.umber(Value)
        if num then
            Configuration.Goal_SGoal_Settings["Target Amount"] = num
            ifettings["Target Amount"] = num
            if TargetAmountSlider and TargetAmountSlider and TargetAmountSlider:Get() ~= num then
                TargetAmountSlider:Get() ~= num then
                TargetAmountSlider:Set(num)
            end
        end TargetAmountSlider:Set(num)
            end
        end
    end
    end
})

WebhookSection
})

WebhookSection:Toggle({
    Name = "Send Webhooks",
    Flag = "SendWebhooks",
   :Toggle({
    Name = "Send Webhooks",
    Flag = "Send Default = Configuration.WebWebhooks",
    Default = Configuration.Webhook_Settings["hook_Settings["Send Webhooks"],
    Callback = function(Value)
        ConfigurationSend Webhooks"],
    Callback = function(Value)
        Configuration.Webhook.Webhook_Settings["Send Webhooks"] = Value
   _Settings["Send Webhooks"] = Value
 end
})

WebhookSection:Slider({
    Name = "    end
})

WebhookSection:Slider({
    Name = "Webhook IntervalsWebhook Intervals",
    Flag = "WebhookIntervals",
    Min",
    Flag = "WebhookIntervals",
    Min = 1,
    Max = 60,
    Default = 1,
    Max = 60,
    Default = Configuration.Webhook_Settings["Web = Configuration.Webhook_Settings["Webhook Intervals"],
    Suffix = "m",
   hook Intervals"],
    Suffix = "m",
    Decimals = 1,
    Callback = function(Value Decimals = 1,
    Callback = function(Value)
        Configuration.Web)
        Configuration.Webhook_Settings["hook_Settings["Webhook Intervals"] = math.floor(Value)
    end
})

WebhookSection:Webhook Intervals"] = math.floor(Value)
    end
Textbox({
    Name = "Webhook Url",
   })

WebhookSection:Textbox({
    Name = "Webhook Url",
    Flag = "Web Flag = "WebhookUrl",
    Placeholder = "...",
    Default =hookUrl",
    Placeholder = "...",
    Default = Configuration.Webhook_S Configuration.Webhook_Settings["Webhook Url"],
    Callback = function(ettings["Webhook Url"],
    CallValue)
        Configuration.Webhook_Settings["Webhook Url"] =back = function(Value)
        Configuration.Webhook_Settings["Webhook Url Value
    end
"] = Value
    end
})

WebhookSection:Button({
    Name = "Send Test Webhook",
   })

WebhookSection:Button({
    Name = "Send Test Webhook",
    Callback = function()
        task.sp Callback = function()
        task.spawn(SendWebhook)
    end
})

local timesRejoinedLabel =awn(SendWebhook)
    end
})

local timesRejoinedLabel = StatsSection:Label("[🔄] Times Rejoined: 0 StatsSection:Label("[🔄] Times Rejoined: 0", "", "Left")
local runtimeLabel = StatsSection:LabelLeft")
local runtimeLabel = StatsSection:Label("[⏰] Runtime("[⏰] Runtime: 00:00:00", "Left")
local: 00:00:00", cashMadeLabel = StatsSection:Label "Left")
local cashMadeLabel = StatsSection:Label("[💸] Cash Made: ("[💸] Cash Made: 0", "Left")
local casinoRob0", "Left")
local casinoRobbedLabel = StatsbedLabel = StatsSection:Label("[♣️] Casino Robbed:Section:Label("[♣️] Casino Robbed: 0", "Left")
local chipsFedLabel = Stats 0", "Left")
local chipsFedLabel = StatsSection:Label("[🍟] Chips Fed: Section:Label("[🍟] Chips Fed: 0", "Left")
local cards0", "Left")
local cardsSwipedLabel = StatsSection:LabelSwipedLabel = StatsSection:Label("[💳] Cards Swiped: 0", "Left")
local marsh("[💳] Cards Swiped: 0", "Left")
local marshmallowsSoldLabel = StatsSection:Label("[🧂mallowsSoldLabel = StatsSection:Label("[🧂] Marshmallows Sold: 0", "Left] Marshmallows Sold: 0", "Left")

local function GetLabel")

local function GetLabelTextObject(labelObj)
    if notTextObject(labelObj)
    if not labelObj or not labelObj.Page then labelObj or not labelObj.Page then return nil end
    local pageSearch return nil end
    local pageSearch = Library.SearchItems[labelObj.Page]
    if pageSearch then
        = Library.SearchItems[labelObj.Page]
    if pageSearch then
        for _, data in ipairs(pageSearch for _, data in ipairs(pageSearch) do
            if data.Name ==) do
            if data.Name == labelObj.Name and labelObj.Name and data.Item then
                local frame = data.Item.Instance data.Item then
                local frame = data.Item.Instance
                if frame then
                if frame then
                    local textLabel = frame:FindFirstChildOf
                    local textLabel = frame:FindFirstChildOfClass("TextLabel")
                    if textClass("TextLabel")
                    if textLabel then
                       Label then
                        return textLabel, data
                    end
                end
            end
        end
    return textLabel, data
                    end
                end
            end
        end
    return nil
end

local function UpdateLabelText end
    end
    return nil
end

local function UpdateLabelText(labelObj, labelTextObj, search(labelObj, labelTextObj, searchData, newText)
    if labelTextObj then
        labelTextObjData, newText)
    if labelTextObj then
        labelTextObj.Text = newText
    end.Text = newText
    end
    if searchData then
        search
    if searchData then
        searchData.Name = newText
    end
    if labelData.Name = newText
    end
    if labelObj then
Obj then
        labelObj.Name = newText
    end
end        labelObj.Name = newText
    end
end

local timesRejoinedLabelText, times

local timesRejoinedLabelText, timesRejoinedSearch
local runtimeLabelRejoinedSearch
local runtimeLabelText, runtimeSearch
local cashText, runtimeSearch
local cashMadeLabelText,MadeLabelText, cashMadeSearch
local casinoRobbed cashMadeSearch
local casinoRobbedLabelText, casinoRobbedSearchLabelText, casinoRobbedSearch
local chipsFedLabelText, chipsFed
local chipsFedLabelText, chipsFedSearch
local cardsSwipedLabelText, cardsSwipedSearch
local marshmallowsSoldLabelTextSearch
local cardsSwipedLabelText, cardsSwipedSearch
local marshmallowsSoldLabelText, marshmall, marshmallowsSoldSearchowsSoldSearch


local Subpages =


local Subpages = {
    ["Configs"] = Pages["Settings"] {
    ["Configs"] = Pages["Settings"]:SubPage:SubPage({
        Name = "({
        Name = "configs", 
        Icon = "964912245configs", 
        Icon = "96491224522405",22405", 
        Columns = 2
    }),
    ["The 
        Columns = 2
    }),
    ["Theming"] = Pages["Settings"]:SubPage({
        Name = "ming"] = Pages["Settings"]:SubPage({
        Name = "theming", 
        Icon = "103863157706913", 
        Columns = 2theming", 
        Icon = "103863157706913", 
        Columns = 2
    }),
    ["Configuration"] =
    }),
    ["Configuration"] = Pages["Settings"] Pages["Settings"]:SubPage({
        Name = "configuration", 
        Icon = "137300573942:SubPage({
        Name = "configuration", 
        Icon = "137300573942266", 
        Columns = 2
    })
}

do -- The266", 
        Columns = 2
    })
}

doming
    local ThemingSection = Subpages["Theming"]:Section -- Theming
    local ThemingSection = Subpages["Theming"]:Section({Name = "theming", Icon = "103863157706913", Side = 1({Name = "theming", Icon = "103863157706913", Side = 1})
    local The})
    local ThemingProfiles = Subpages["ThemingmingProfiles = Subpages[""]:Section({Name = "profiles", Icon = "964912Theming"]:Section({Name = "profiles", Icon = "96491224522405", Side = 2})
    local AutoloadSection24522405", Side = 2})
    local AutoloadSection = Subpages[" = Subpages["Theming"]:Section({Name = "autoload", Icon = "137623872Theming"]:Section({Name = "autoload", Icon = "137623872962804", Side = 2962804", Side = 2})

    for Index,})

    for Index, Value in Library.Theme do 
        Library.ThemeColorpickers[Index] = Theming Value in Library.Theme do 
        Library.ThemeColorpickers[IndexSection:Label(Index, "Left"):Color] = ThemingSection:Label(Index, "Left"):Colorpicker({
            Name = "Colorpickerpicker({
            Name",
            Flag = "ColorpickerTheme" .. Index,
            Default = Value = "Colorpicker",
            Flag = "ColorpickerTheme" .. Index,
            Default = Value,
            Alpha =,
            Alpha = 0,
            Callback = function(Color, Alpha 0,
            Callback = function)
                Library.Theme[Index] = Color
                Library:ChangeTheme(Color, Alpha)
                Library.Theme[Index] = Color
                Library:ChangeTheme(Index, Color)
            end
        })
    end

    Theming(Index, Color)
            end
        })
    end

    ThemingProfiles:Dropdown({
        Name = "preset themes",
        Items =Profiles:Dropdown({
        Name = "preset themes",
        Items = { "Preset", "Hall { "Preset", "Halloween", "Aqua", "One Tapoween", "Aqua", "One Tap" },
        Default = "Preset",
        Multi = false,
        Callback = function(" },
        Default = "Preset",
        Multi = false,
        Callback = function(Value)
            local ThemeData = Library.Themes[Value]
            if notValue)
            local ThemeData = Library.Themes[Value]
            if not ThemeData then return end
            for Index, Value ThemeData then return end
            for Index, Value in Library.Theme in Library.Theme do 
                Library.Theme[Index] = ThemeData do 
                Library.Theme[Index] = ThemeData[Index]
               [Index]
                Library:ChangeTheme Library:ChangeTheme(Index, Theme(Index, ThemeData[Index])
                Library.ThemeColorpData[Index])
                Library.Themeickers[Index]:SetColorpickers[Index]:(ThemeData[Index])
           Set(ThemeData[Index])
            end
            task end
            task.wait(0..wait(0.3)
            Library3)
            Library:Thread(function:Thread(function()
                for Index,()
                for Index, Value in Library.Theme do 
                    Library.Theme Value in Library.Theme do 
                    Library.Theme[Index] = Library[Index] = Library.Flags["ColorpickerTheme" .. Index].Color
                    Library:.Flags["ColorpickerTheme" .. Index].Color
                    Library:ChangeTheme(IndexChangeTheme(Index, Library.Flags["ColorpickerTheme" .. Index, Library.Flags["ColorpickerTheme" .. Index].Color)
               ].Color)
                end    
            end)
        end
    })

    local ThemeSelected 
    local ThemeName end    
            end)
        end
    })

    local ThemeSelected 
    local ThemeName

    local Themes

    local ThemesDropdown =Dropdown = ThemingProfiles:Dropdown({
        Name = "the ThemingProfiles:Dropdown({
        Name = "themes", 
        Flag = "Themes", 
        Flag = "ThemesList",mesList", 
        Items = { }, 
        Multi = false,
        Callback = function 
        Items = { }, 
        Multi = false,
        Callback = function(Value)
           (Value)
            ThemeSelected = Value ThemeSelected = Value

        end
    })

    ThemingProfiles:Textbox({
               end
    })

    The Name = "theme name", 
       mingProfiles:Textbox({
        Name = "theme name", 
        Default = "", 
        Flag = "ThemeName", 
        Placeholder = Default = "", 
        Flag = "ThemeName", 
        Placeholder = "enter text", 
        Callback "enter text", 
        Callback = function(Value)
            ThemeName = Value
        end
    = function(Value)
            ThemeName = Value
        end
    })

    ThemingProfiles:Button })

    ThemingProfiles:Button({
        Name = "save",
        Callback = function({
        Name = "save",
        Callback = function()
            if ThemeName and ThemeName ~()
            if ThemeName and ThemeName ~= "" then
                writefile(L= "" then
                writefile(Library.Folders.Themes .. "/ibrary.Folders.Themes .. "/" .. ThemeName .. ".json", Library:GetTheme())
                Library:" .. ThemeName .. ".json", Library:GetThemeRefreshThemesList(ThemesDropdown())
                Library:RefreshThemesList)
            end
        end
    })

    ThemingProfiles:Button({
        Name = "(ThemesDropdown)
            end
        end
    })

    ThemingProfiles:Button({
        Name = "load",
        Callback = functionload",
        Callback = function()
            if ThemeSelected()
            if ThemeSelected then
                local Success, Result = Library:Load then
                local Success, Result = Library:LoadTheme(readfile(LTheme(readfile(Library.Folders.Themes .. "/" .. ThemeSelectedibrary.Folders.Themes .. "/))
                if Success then 
                    Library:Notification({
                        Name = "Success" .. ThemeSelected))
                if Success then 
                    Library:Notification({
                       ",
                        Description = "Succes Name = "Success",
                        Description = "Succesfully loaded themefully loaded theme: ".. ThemeSelected,
                        Duration =: ".. ThemeSelected,
                        Duration = 5,
                        5,
                        Icon = "116 Icon = "116339777339777575852",
                        IconColor = Color3.fromRGB(575852",
                        IconColor = Color52, 255, 1643.fromRGB(52, 255, 164)
                    })
                    task)
                    })
                    task.wait(0.3)
                    Library:.wait(0.3)
                    LibraryThread(function()
                        for Index, Value in Library:Thread(function()
                        for Index, Value in Library.The.Theme do 
                            Library.Theme[Index] = Library.Flagsme do 
                            Library.Theme[Index] = Library.Flags["ColorpickerTheme" .. Index].Color
                            Library:["ColorpickerTheme"ChangeTheme(Index, Library.Fl .. Index].Color
                            Library:ChangeTheme(Index, Library.Flags["ColorpickerTheme" .. Index].Color)
                        end    
                    endags["ColorpickerTheme" .. Index].Color)
                       )
                else
                    Library:Notification end    
                    end)
                else
                    Library:Notification({
                        Name({
                        Name = "Error!",
                        Description = = "Error!",
                        Description = "Failed to load theme",
                        Duration = 5,
                        Icon = " "Failed to load theme",
                        Duration = 5,
                        Icon = "97118059177470",
                       97118059177470",
                        IconColor = Color3.fromRGB(255, 120, 120 IconColor = Color3.fromRGB(255, 120)
                    })
                end
            end, 120)
                    })
                end
        end
    })

    AutoloadSection:Button
            end
        end
    })

    AutoloadSection:Button({
        Name =({
        Name = "set selected theme as autoload",
        Callback = function "set selected theme as autoload",
        Callback = function()
            if ThemeSelected then 
                write()
            if ThemeSelected then 
                writefile(Library.Folders.Directoryfile(Library.Folders.Directory .. "/AutoLoadTheme (do .. "/AutoLoadTheme (do not modify this).json", read not modify this).json", readfile(Library.Folders.Themesfile(Library.F .. "/" .. ThemeSelectedolders.Themes .. "/" .. ThemeSelected))
            end
       ))
            end
        end
    })

    AutoloadSection:Button end
    })

    Autoload({
        Name = "set current theme as autoload",
        Callback = function()
            writefile(Library.FSection:Button({
        Name = "set current theme as autoload",
        Callback =olders.Directory .. "/AutoLoadTheme (do not modify this).json function()
            writefile(Library.Folders.Directory .. "/AutoLoad", Library:GetTheme())
        end
   Theme (do not modify this).json", Library:GetTheme())
        })

    AutoloadSection:Button({
        Name = "remove autoload end
    })

    AutoloadSection:Button({
        Name = " theme",
        Callback = functionremove autoload theme",
        Callback = function()
()
            writefile(Library.Folders.Directory .. "/AutoLoadTheme (            writefile(Library.Folders.Directory .. "/AutoLoadTheme (do not modify this).json", "")
        end
   do not modify this).json", })

    Library:RefreshThemesList "")
        end
    })

    Library:RefreshThemesList(ThemesDropdown(ThemesDropdown)
end

do --)
end

do -- Configs
    Configs
    local ConfigsSection = Subpages["Configs"] local ConfigsSection = Subpages["Configs"]:Section({Name = "profiles:Section({Name = "profiles", Icon = "96491224522405", Side = 1})
    local AutoloadSection = Sub", Icon = "96491224522405", Side = 1})
    local AutoloadSection =pages["Configs"]:Section({ Subpages["Configs"]:Section({Name = "autName = "autoload", Iconoload", Icon = "137623 = "137623872962804872962804", Side = 2})

    local ConfigSelected", Side = 2})

    local 
    local ConfigName

    local Config ConfigSelected 
    local ConfigName

    local ConfigsDropdown = ConfigsDropdown = ConfigsSection:Dropdown({
        Name = "configsSection:Dropdown({
        Name =s", 
        Flag = "ConfigsList", 
        Items = { }, 
        Multi = "configs", 
        Flag = "ConfigsList", 
        Items = { }, 
        Multi = false,
        Call false,
        Callback = function(back = function(Value)
            ConfigValue)
            ConfigSelected = ValueSelected = Value
        end
   
        end
    })

    Configs })

    ConfigsSection:TextboxSection:Textbox({
        Name = "config name",({
        Name = "config name", 
        Default = "", 
        Flag 
        Default = "", 
        Flag = "ConfigName", 
        Place = "ConfigName", 
        Placeholder = "enter text", 
       holder = "enter text", 
        Callback = function Callback = function(Value)
            ConfigName = Value
(Value)
            ConfigName = Value
        end        end
    })

    ConfigsSection:Button
    })

    ConfigsSection:Button({
        Name = "create",
       ({
        Name = "create",
        Callback = function()
            if Callback = function()
            if Config ConfigName and ConfigNameName and ConfigName ~= "" then ~= "" then
                writefile
                writefile(Library.Fold(Library.Folders.Configs ..ers.Configs .. "/" .. Config "/" .. ConfigName .. ".jsonName .. ".json", Library:", Library:GetConfig())
               GetConfig())
                Library:RefreshConfig Library:RefreshConfigsList(ConfigsList(ConfigsDropdown)
           sDropdown)
            end
        end end
        end
   
    })

    ConfigsSection })

    ConfigsSection:Button({
       :Button({
        Name = "delete Name = "delete",
        Callback",
        Callback = function()
            = function()
            if ConfigSelected then if ConfigSelected then
                Library:
                Library:DeleteConfig(ConfigDeleteConfig(ConfigSelected)
                LibrarySelected)
                Library:RefreshConfigs:RefreshConfigsList(ConfigsList(ConfigsDropdown)
            endDropdown)
            end
        end
        end
    })

    Config
    })

    ConfigsSection:ButtonsSection:Button({
        Name = "load",
       ({
        Name = "load",
        Callback = function()
            if Config Callback = function()
            if ConfigSelected then
                local Success, ResultSelected then
                local Success, Result = Library:Load = Library:LoadConfig(readfile(Library.FConfig(readfile(Library.Folders.Configs .. "/"olders.Configs .. "/" .. ConfigSelected))
                if Success then .. ConfigSelected))
                if Success then 
                    Library:Notification({
                        Name 
                    Library:Notification({
                        Name = "Success",
                        Description = " = "Success",
                        Description = "Succesfully loaded config: "Succesfully loaded config: ".. ConfigSelected,
                       .. ConfigSelected,
                        Duration = 5,
                        Icon Duration = 5,
                        Icon = "116339777 = "116339777575852",
                       575852",
                        IconColor = Color3.fromRGB( IconColor = Color3.fromRGB(52, 255, 16452, 255, 164)
                    })
                    task.wait(0.)
                    })
                    task.wait(0.3)
                    Library:Thread3)
                    Library(function:Thread(function()
                        for Index, Value in Library()
                        for Index, Value in Library.The.Theme do 
                            Library.Thememe do 
                            Library.Theme[Index] = Library[Index] = Library.Flags["ColorpickerTheme".Flags["ColorpickerTheme" .. Index].Color .. Index].Color
                            Library:
                            Library:ChangeTheme(IndexChangeTheme(Index, Library.Fl, Library.Flags["Colorpickerags["ColorpickerTheme" .. IndexTheme" .. Index].Color)
                        end    
                    end].Color)
                        end    
                    end)
                else
                    Library:Notification)
                else
                    Library:Notification({
                        Name = "Error!({
                        Name = "Error!",
                        Description = "Failed to load",
                        Description = "Failed to load config",
                        Duration config",
                        Duration = 5,
                        Icon = " = 5,
                        Icon = "97118059177470",
                       97118059177470",
                        IconColor = Color3.fromRGB( IconColor = Color3.fromRGB(255, 120, 120255, 120, 120)
                    })
                end
            end)
                    })
                end
            end
        end
    })

    Configs
        end
    })

    ConfigsSection:Button({
        Name = "Section:Button({
        Name = "save",
        Callback = function()
            if ConfigSelectedsave",
        Callback = function()
            if ConfigSelected then
                Library:SaveConfig(ConfigSelected)
            then
                Library:SaveConfig(ConfigSelected)
            end
        end end
        end
   
    })

    ConfigsSection })

    ConfigsSection:Button({
       :Button({
        Name = "refresh Name = "refresh list",
        Call list",
        Callback = function()
            Library:Refreshback = function()
            Library:RefreshConfigsList(ConfigsDropdownConfigsList(ConfigsDropdown)
        end
    })

)
        end
       AutoloadSection:Button({
        Name = })

    AutoloadSection:Button({
        Name = "set selected config "set selected config as autoload as autoload",
        Callback",
        Callback = function()
            = function()
            if ConfigSelected then 
                writefile(Library.Folders.Directory .. "/Auto if ConfigSelected then 
                writefile(Library.Folders.Directory .. "/AutoLoadConfig (do not modify this).json", readfile(LibraryLoadConfig (do not modify this).json", readfile(Library.Fold.Folders.Configs .. "/" .. ConfigSelected))
            enders.Configs .. "/" .. ConfigSelected))
            end
        end
        end
    })

    AutoloadSection:Button({
        Name
    })

    AutoloadSection:Button({
        Name = "set current = "set current config as autol config as autoload",
oad",
        Callback = function        Callback = function()
            writefile(Library.Folders()
            writefile(Library.Folders.Directory .. "/AutoLoadConfig (.Directory .. "/AutoLoadConfig (do not modify this).json", Librarydo not modify this).json", Library:GetConfig())
        end
    })

    AutoloadSection::GetConfig())
        end
    })

    AutoloadSection:Button({
        Name = "remove autoload config",
        Callback = functionButton({
        Name = "remove autoload config",
        Callback = function()
            writefile(L()
            writefile(Library.Foldibrary.Folders.Directory ..ers.Directory .. "/AutoLoadConfig "/AutoLoadConfig (do not modify (do not modify this).json this).json", "")
        end", "")
        end
    })

    Library:RefreshConfigsList(ConfigsDropdown)
end
    })

    Library:RefreshConfigsList(ConfigsDropdown)
end

do -- Configuration
    local MenuSection = Sub

do -- Configuration
    local MenuSection = Subpages["Configurationpages["Configuration"]:Section({Name = "menu", Icon ="]:Section({Name = "menu", Icon = "930078703 "93007870315593", Side = 115593", Side = 1})
    local TweeningSection = Sub})
    local TweeningSection = Subpages["Configuration"]:Section({Namepages["Configuration"]:Section({Name = "tweening", Icon = = "tweening", Icon = "130045183 "130045183204879", Side204879", Side = 2})

    MenuSection:Label("menu key = 2})

    MenuSection:Label("menu keybind", "Left"):Keybindbind", "Left"):Keybind({
        Name = "Menu({
        Name = "MenuKeybind",
        Flag = "MenuKeybind",
        ModeKeybind",
        Flag = "MenuKeybind",
        Mode = " = "toggle",
        Default = Library.MenuKeybind,
        Calltoggle",
        Default = Library.MenuKeybind,
        Callback = functionback = function()
            Library.MenuKeybind = Library.Flags["()
            Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
        end
    })

    MenuSection:MenuKeybind"].Key
        end
    })

    MenuSection:Toggle({
        Name = "keybindToggle({
        Name = " list",
        Flagkeybind list",
        Flag = "keybind list",
        Default = false,
        = "keybind list",
        Default = false,
        Callback = function Callback = function(Value)
            KeybindList:(Value)
            KeybindList:SetVisibility(Value)
        endSetVisibility(Value)
        end
    })

    MenuSection:Toggle
    })

    MenuSection:Toggle({
        Name = "Global chat",
       ({
        Name = "Global chat",
        Flag = "Global chat",
        Default Flag = "Global chat = true,
        Callback = function",
        Default = true,
       (Value)
            -- Global chat is Callback = function(Value)
            handled in library itself if visibility changes -- Global chat is handled in library itself if visibility changes
        end
   
        end
    })
    
 })
    
    MenuSection:Toggle    Menu({
        Name = "watermark",
       Section:Toggle({
        Name = " Flag = "watermark",
watermark",
               Default = false,
        Flag = "watermark",
        Default Callback = function(Value)
            = false,
        Callback = function Watermark:SetVisibility(Value(Value)
            Watermark:Set)
        end
    })

    MenuSectionVisibility(Value)
        end
   :Button({
        Name = "un })

    MenuSection:Button({
       load",
        Callback = function Name = "unload",
        Call()
            Library:Unload()
        endback = function()
            Library:Un
    })

    Tload()
        end
    })

    TweeningSection:SliderweeningSection:Slider({
        Name = "({
        Name = "time",
        Flagtime",
        Flag = "Tween = "TweenTime",
        DefaultTime",
        Default = Library.T = Library.Tween.Time,
       ween.Time,
        Min Min = 0,
        =  Max = 5,
        Decimals = 00,
        Max = 5,
       .01,
        Callback Decimals = 0 = function(Value)
            Library.Tween.Time.01,
        Callback = function = Value
        end
   (Value)
            Library.Tween.Time })

    TweeningSection:Dropdown = Value
        end
   ({
        Name = " })

    TweeningSection:Dropdownstyle",
        Flag = "Tween({
        Name = "style",
        FlagStyle",
        Default = "Cubic = "Tween",
        Items = {"Linear", "Style",
        Default = "Cubic",
        Items = {"Linear", "Sine", "Quad", "CubicSine", "Quad", "Cubic", "Quart", "Quint", "Quart", "Quint", "Exponential", "Circular", "Exponential", "Circular", "Back", "Elastic",", "Back", "Elastic", "Bounce"},
        MaxSize = "Bounce"},
        MaxSize = 150,
        Callback = function 150,
       (Value)
            Library.Tween Callback = function(Value)
           .S Library.Tween.Style = Enum.Etyle = Enum.EasingStyle[ValueasingStyle[Value]
        end]
        end
   
    })

    TweeningSection: })

    TweeningSection:Dropdown({
        NameDropdown({
        Name = "direction = "direction",
        Flag = "",
        Flag = "TweenDirectionTweenDirection",
        MaxSize =",
        MaxSize = 55,
 55,
        Default = "Out        Default = "Out",
        Items = {"In", "",
        Items = {"In", "Out", "InOut"},
        CallOut", "InOut"},
        Callback = function(Value)
            Libraryback = function(Value)
            Library.Tween.Direction = Enum.Easing.Tween.Direction = Enum.EasingDirection[ValueDirection[Value]
        end
   ]
        end
    })
end

task })
end

task.spawn(function.spawn(function()
    task.wait()
    task.wait(2.0(2.0) -- Wait for) -- Wait for library search items to library search items to populate before resolving labels populate before resolving labels
    timesRejoinedLabelText
    timesRejoinedLabelText, timesRejoinedSearch = GetLabel, timesRejoinedSearch = GetLabelTextObject(timesRejoinedLabel)
    runtimeLabelTextTextObject(timesRejoinedLabel, runtimeSearch = GetLabelTextObject)
    runtimeLabelText(runtimeLabel)
    cashMadeLabel, runtimeSearch = GetLabelTextObject(runtimeLabelText, cashMadeSearch = GetLabel)
    cashMadeLabelText, cashMadeTextObject(cashMadeLabel)
   Search = GetLabel casinoRobbedLabelText, casinoRobTextObject(cashMadeLabel)
   bedSearch = GetLabel casinoRobbedLabelText, casinoRobbedSearch = GetLabelTextObject(cTextObject(casinoRobbedLabel)
    chipsasinoRobbedLabel)
    chipsFedLabelText, chipsFedSearch =FedLabelText, chipsFedSearch = GetLabelTextObject GetLabelTextObject(chipsFedLabel(chipsFedLabel)
    cards)
    cardsSwipedLabelTextSwipedLabelText, cardsSwiped, cardsSwipedSearch = GetLabelSearch = GetLabelTextObject(cardsTextObject(cardsSwipedLabelSwipedLabel)
    marshmallows)
    marshmallowsSoldLabelText,SoldLabelText, marshmallowsSold marshmallowsSoldSearch = GetLabelSearch = GetLabelTextObject(marshTextObject(marshmallowsSoldLabelmallowsSoldLabel)

)

    local lastCash = Get    local lastCash = GetCurrentCashAmount()
    while task.waitCurrentCashAmount()
    while task.wait(1) do
(1) do
        Configuration.        Configuration.Statistics["Runtime"] += 1Statistics["Runtime"] +=
        local cur = GetCurrentCashAmount 1
        local cur =()
        if cur GetCurrentCashAmount()
        if cur > lastCash then
            Configuration. > lastCash then
            Configuration.Statistics["Cash Made"] += cur -Statistics["Cash Made"] += cur - lastCash
        end
        last lastCash
        end
        lastCash = cur
        
        UpdateLabelTextCash = cur
        
        UpdateLabelText(timesRejoinedLabel, times(timesRejoinedLabel, timesRejoinedLabelText, timesRejoinedRejoinedLabelText, timesRejoinedSearch, "[🔄] Times ReSearch, "[🔄] Times Rejoined: " .. GetCommaValuejoined: " .. GetCommaValue(Configuration.Statistics["Times(Configuration.Statistics["Times Rejoined"]))
        Update Rejoined"]))
        UpdateLabelText(runtimeLabelText(runtimeLabel, runtimeLabelLabel, runtimeLabelText, runtimeSearchText, runtimeSearch,, "[⏰] Runtime "[⏰] Runtime: " .. Format: " .. FormatRuntime(Configuration.Runtime(Configuration.Statistics["Runtime"]Statistics["Runtime"]))
        UpdateLabel))
        UpdateLabelText(cashMadeText(cashMadeLabel, cashMadeLabel, cashMadeLabelText, cashLabelText, cashMadeSearch,MadeSearch, "[💸] Cash "[💸] Cash Made: " .. Made: " .. GetCommaValue(Configuration.Statistics GetCommaValue(Configuration.Statistics["Cash Made"]))
        UpdateLabel["Cash Made"]))
        UpdateLabelText(casinoRobbedLabel,Text(casinoRobbedLabel, casinoRobbedLabelText, casinoRob casinoRobbedLabelText, casinoRobbedSearch, "[bedSearch, "[♣️]♣️] Casino Robbed: Casino Robbed: " .. GetCom " .. GetCommaValue(ConfigurationmaValue(Configuration.Statistics["Cas.Statistics["Casino Robbed"]ino Robbed"] or 0 or 0))
        UpdateLabelText))
        UpdateLabelText(chipsFedLabel, chipsFedLabel(chipsFedLabel, chipsFedLabelText, chipsFedSearch,Text, chipsFedSearch, "[🍟] Chips Fed: " .. "[🍟] Chips Fed: " .. GetCommaValue(Configuration.Statistics GetCommaValue(Configuration.Statistics["Chips Fed["Chips Fed"]))
        Update"]))
        UpdateLabelText(cardsLabelText(cardsSwipedLabel,SwipedLabel, cardsSwipedLabelText, cardsSw cardsSwipedLabelText, cardsSwipedSearch, "[💳] CardsipedSearch, "[💳] Cards Swiped: " .. GetComma Swiped: " .. GetComValue(Configuration.maValue(Configuration.Statistics["Cards Swiped"]))
       Statistics["Cards Swiped"]))
        UpdateLabelText(marshmallowsSold UpdateLabelText(marshmallowsSoldLabel, marshmallowsSoldLabelTextLabel, marshmallowsSoldLabelText, marshmallowsSoldSearch,, marshmallowsSoldSearch, "[🧂] Marsh "[🧂] Marshmallows Sold:mallows Sold: " .. GetCommaValue(Configuration " .. GetCommaValue(Configuration.Statistics["Marshmallows Sold.Statistics["Marshmallows Sold"]))
        
        -- Update Watermark"]))
        
        -- Update Watermark dynamically
        Watermark dynamically
        Watermark:SetText:SetText(executorName(executorName .. " - " .. " - " .. Player.Name .. .. Player.Name .. " " - " .. os.date("%I -:%M %p"))
    end " .. os.date("%I:%M %p
end)

task.spawn(function()
   "))
    end local timer =
end)

task.spawn(function()
    0
    while local timer = 0
    while task.wait(1) do
        task.wait(1) do
        if Configuration.Web if Configuration.Webhook_Settings["hook_Settings["Send Webhooks"]Send Webhooks"] and Configuration.Webhook and Configuration.Webhook_Settings["Web_Settings["Webhook Url"] ~hook Url"] ~= "" then= "" then
           
            timer = timer + 1 timer = timer + 1
            if timer >=
            if timer >= Configuration.Webhook_S Configuration.Webhook_Settings["Webhookettings["Webhook Intervals"] Intervals"] * 60 then * 60 then
                timer = 0
                task
                timer = 0
                task.spawn(SendWebhook.spawn(SendWebhook)
            end
        else
            timer)
            end
        else
            timer = 0
        end
    = 0
        end
    end
end)

task.spawn(function end
end)

task.spawn(function()
    while task.wait(60)()
    while task.wait( do
        pcall(function()
           60) do
        p game:GetService("VirtualUsercall(function()
            game:GetService"):CaptureController()
("VirtualUser"):CaptureController            game:GetService("Virtual()
            game:GetService("VirtualUser"):ClickButton2(VectorUser"):ClickButton2(Vector2.new())
        end)
    end2.new())
        end)
    end
end)

task.spawn(function
end)

task.spawn(function()
    local conn
    conn = Log()
    local conn
    conn = LogService.MessageOut:Connect(function(msgService.MessageOut:Connect(function(msg, mtype)
        if, mtype)
        if mtype mtype == Enum.MessageType.MessageError then
            if == Enum.MessageType.MessageError then
            if msg:find msg:find("Kicked")("Kicked") or msg: or msg:find("Disconnected")find("Disconnected") or msg:find or msg:find("Idle")("Idle") then
                if conn then conn: then
                if conn then conn:Disconnect() end
                task.spDisconnect() end
                task.spawn(DoReawn(DoRejoin)
            endjoin)
            end
        end
        end
    end)
end
    end)
end)

if getgen)

if getgenv().AutoRev().AutoRejoinerEnabled thenjoinerEnabled then
    getgen
    getgenv().AutoRev().AutoRejoinerEnabledjoinerEnabled = nil
    task =.spawn(function()
        task.wait( nil
    task.spawn(function20)
        if Autofarm()
        task.wait(Toggle then
           20)
        if Autofarm AutofarmToggle:Set(trueToggle then
            AutofarmToggle)
        else
            Configuration.Main_S:Set(true)
        else
           ettings["Autofarming"] = Configuration.Main_Settings["Aut true
            repeat task.wait(0ofarming"] = true
            repeat.5) until SpawnAnd task.wait(0.5) untilSitOnBike() or not SpawnAndSitOnB Configuration.Main_Settings["Autofike() or not Configuration.Main_Sarming"]
            ifettings["Autofarming"]
            if Configuration.Main_Settings["Autof Configuration.Main_Settings["Autofarming"] then
                MainAutofarming"] then
                MainAutofarmController()
            end
        endarmController()
            end
        end
    end)
end

local function
    end)
end

local function ConnectDeathHandler(char ConnectDeathHandler(char)
    local humanoid)
    local humanoid = char:Wait = char:WaitForChild("HumanForChild("Humanoid", 5oid", 5)
    if not)
    if not humanoid humanoid then return end
    human thenoid.Died:Connect(function()
        return end
    human if Configuration.State["RespawnPending"]oid.Died:Connect(function()
        then return end
        if Configuration.M if Configuration.State["RespawnPending"]ain_Settings[" then return end
        if Configuration.MAutofarming"] and Configuration.Mainain_Settings["_Settings["Auto RejoinerAutofarming"] and Configuration.Main_Settings["Auto Rejoiner"] then
"] then
            task.wait(3            task.wait(3)
            Do)
            DoRejoin()
        endRejoin()
        end
    end)
end

ConnectDeath
    end)
end

ConnectDeathHandler(Player.Character)
Player.Handler(Player.Character)
Player.CharacterAdded:Connect(ConnectDeathHandlerCharacterAdded:Connect(ConnectDeathHandler)

Player)

Player.Idled:.Idled:Connect(function()
    ifConnect(function()
    if Configuration.Main_Settings["Autof Configuration.Main_Settings["Autofarming"] then
        local VirtualUserarming"] then
        local VirtualUser = cloneref(game = cloneref(game:GetService(":GetService("VirtualUser"))
        VirtualUser:CaptureVirtualUser"))
        VirtualUser:CaptureController()
        VirtualUser:ClickButtonController()
        VirtualUser:ClickButton2(Vector2.new())
    end2(Vector2.new())
    end
end)

Library:Init()