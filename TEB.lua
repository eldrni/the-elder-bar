TEB = {} 
TEB.name = "TEB"
TEB.settingsRev = 6
TEB.version = "10.0.2"

local LAM2 = LibAddonMenu2
local LFDB = LIB_FOOD_DRINK_BUFF
local screenWidth = GuiRoot:GetWidth()
local screenHeight = GuiRoot:GetHeight()
local lockMessage = true
local blacksmithTimerVisible = false
local jewelryTimerVisible = false
local woodworkingTimerVisible = false
local clothingTimerVisible = false
local bountyTimerVisible = false
local bountyTimerRunning = false
local isVampire = false
local ftTimerVisible = false
local etHasTickets = false
local mailUnread = false
local enlightenmentVisible = false
local mountTimerVisible = false
local addonInitialized = false
local inCombat = false
local combatAlpha = 0
local pulseType = "fade out"
local combatIndicator = true
local refreshTimer = 99
local centerTimer = 60 * 1000 * 5
local pulseTimer = 120
local pulseList = {}
local barAlpha = 1
local hideBar = false
local topBarAlphaList = {}
local lastTopBarAlpha = 1
local showCombatOpacity = 0
local pvpMode = false
local kills = 0
local killingBlows = 0
local deaths = 0
local movingGadget = ""
local movingGadgetName = ""
local playerName = GetUnitName("player")
local foodBuffWasActive = false
local foodTimerRunning = false
local foodTimerVisible = false
account = GetDisplayName("player")
local trackerDropdown = {}

local backdropOpacity = 0
local combatOpacity = 0
local barPosition = "top"
local barWidth = "dynamic"
local barY = 0
local controlsPosition = ""
local bumpCompass = true
local bumpActionBar = true
local gadgets = {}
local highestFPS = 0
local lowestFPS = 10000
local barLocked = true
local gadgetsLocked = true
local ap_SessionStart = os.time()
local ap_SessionStartPoints = GetCurrencyAmount(CURT_ALLIANCE_POINTS, CURRENCY_LOCATION_CHARACTER)
local scale = 100
local barLayer = 0

local pulseWhenCritical = false
local clock_TwentyFourHourClock = true
local clock_DisplayPreference = "local time"
local soulgems_DisplayPreference = "total filled/empty"
local soulgems_ColorCrown = false
local soulgems_ColorNormal = false
local skyshards_DisplayPreference = "collected/unspent points"
local durability_DisplayPreference = "durability %"
local durability_Warning = 50
local durability_Danger = 25
local durability_Critical = 10
local durability_Good = true
local research_DisplayPreference = "simple"
local research_Dynamic = true
local research_DisplayAllSlots = true
local research_ShowShortest = false
local research_FreeText = "--"
local gold_DisplayPreference = "gold on character"
local latency_Warning = 100
local latency_Danger = 500
local latency_Good = true
local latency_Fixed = false
local latency_FixedLength = 100
local fps_Warning = 30
local fps_Danger = 15
local fps_Good = true
local fps_Fixed = false
local fps_FixedLength = 100
local level_DisplayPreferenceMax = "[CP Icon] Champion Points (Unspent Points)"
local level_DisplayPreferenceNotMax = "[Class Icon] Character Level"
local bag_DisplayPreference = "slots used/total slots"
local bag_Good = true
local bag_Warning = 50
local bag_Danger = 75
local bag_Critical = 90
local bank_DisplayPreference = "slots used/total slots"
local bank_Good = true
local bank_Warning = 50
local bank_Danger = 75
local bank_Critical = 90
local enlightenment_Warning = 200000
local enlightenment_Danger = 100000
local enlightenment_Critical = 50000
local enlightenment_Dynamic = false
local experience_DisplayPreference = "% towards next level/CP"
local autohide_GameMenu = true
local autohide_Chatter = true
local autohide_Crafting = true
local autohide_Bank = true
local autohide_GuildBank = true
local wc_Good = true
local wc_Warning = 50
local wc_Danger = 25
local wc_Critical = 10
local wc_AutoPoison = true
local wc_PoisonWarning = 20
local wc_PoisonDanger = 10
local wc_PoisonCritical = 5
local wc_NoPoisonBad = false
local location_DisplayPreference = "(x, y) Zone Name"
local tt_Danger = 10
local tt_Warning = 25
local tt_Good = true
local tt_DisplayPreference = "stolen treasures/stolen goods (lockpicks)"
local memory_Good = true
local memory_Warning = 512
local memory_Danger = 768
local tt_InvWarning = 50
local tt_InvDanger = 75
local ft_DisplayPreference = "time left/cost"
local ft_TimerDisplayPreference = "simple"
local ft_Dynamic = true
local ft_Good = false
local thousandsSeparator = true
local kc_DisplayPreference = "Killing Blows/Deaths (Kill Ratio)"
local ap_DisplayPreference = "Total Points"
local level_Dynamic = true
local et_Dynamic = true
local et_DisplayPreference = "tickets"
local et_Warning = 9
local et_Danger = 12
local food_Dynamic = true
local food_Warning = 15
local food_Danger = 7
local food_Critical = 2
local food_PulseAfter = true
local food_Dynamic = true
local food_DisplayPreference = "simple"
local bounty_Dynamic = true
local bounty_DisplayPreference = "simple"
local mount_DisplayPreference = "simple"
local mount_Dynamic = true
local mount_Good = false
local mount_Critical = false
local mail_Dynamic = true
local mail_Good = false
local mail_Critical = false
local bounty_Warning = "yellow"
local bounty_Danger = "orange"
local bounty_Critical = "red"
local bounty_Good = "normal"
local vampirism_DisplayPreference = "Stage (Timer)"
local vampirism_TimerPreference = "simple"
local vampirism_Dynamic = true
local vampirism_StageColor = {
    [1] = "normal",
    [2] = "yellow",
    [3] = "orange",
    [4] = "red"
}
local font = "Univers57"

local gadgetSettings = {}
local mount_Tracker = {}
local gold_Tracker = {}

local icons_Mode = "White"
local gadgetText = {}
local iconIndicator = {}

local mundusStoneReference ={
    ["001"] = "Warrior",
    ["002"] = "Mage",
    ["003"] = "Thief",
    ["004"] = "Serpent",
    ["005"] = "Lady",
    ["006"] = "Steed",
    ["007"] = "Lord",
    ["008"] = "Apprentice",
    ["009"] = "Atronach",
    ["010"] = "Ritual",
    ["011"] = "Lover",
    ["012"] = "Shadow",
    ["013"] = "Tower"
}

local equipSlotReference = {
    [0] = "head",
    [2] = "chest",
    [3] = "shoulders",
    [6] = "waist",
    [8] = "legs",
    [9] = "feet",
    [16] = "hands"
}

local traitReference = {
    [18] = "Divines",
    [17] = "Exploration",
    [12] = "Inpenetrable",
    [16] = "Infused",
    [20] = "Intricate",
    [25] = "Nirnhoned",
    [19] = "Ornate",
    [17] = "Invigorating",
    [13] = "Reinforced",
    [11] = "Sturdy",
    [15] = "Training",
    [14] = "Well Fitted",
    [22] = "Arcane",
    [31] = "Bloodthirsty",
    [29] = "Harmony",
    [21] = "Healthy",
    [33] = "Infused",
    [27] = "Intricate",
    [24] = "Ornate",
    [32] = "Protective",
    [23] = "Robust",
    [28] = "Swift",
    [30] = "Triune",
    [2] = "Charged",
    [8] = "Decisive",
    [5] = "Defending",
    [4] = "Infused",
    [9] = "Intricate",
    [26] = "Nirnhoned",
    [10] = "Ornate",
    [1] = "Powered",
    [3] = "Precise",
    [7] = "Sharpened",
    [6] = "Training"
}
local iconReference = {
    ["TEBTopLatencyIcon"] = "Latency",
    ["TEBTopLevelIcon"] = "Level",
    ["TEBTopGoldIcon"] = "Gold",
    ["TEBTopTelvarIcon"] = "Tel Var Stones",
    ["TEBTopTCIcon"] = "Transmute Crystals",
    ["TEBTopWritIcon"] = "Writ Vouchers",
    ["TEBTopSoulGemsIcon"] = "Soul Gems",
    ["TEBTopAPIcon"] = "Alliance Points",
    ["TEBTopBagIcon"] = "Bag Space",
    ["TEBTopMountIcon"] = "Mount Timer",
    ["TEBTopXPIcon"] = "Experience",
    ["TEBTopTimeIcon"] = "Clock",
    ["TEBTopSkyShardsIcon"] = "Sky Shards",
    ["TEBTopDurabilityIcon"] = "Durability",
    ["TEBTopResearchBlacksmithingIcon"] = "Blacksmithing Research Timer",
    ["TEBTopResearchWoodworkingIcon"] = "Woodworking Research Timer",
    ["TEBTopResearchClothingIcon"] = "Clothing Research Timer",
    ["TEBTopResearchJewelryCraftingIcon"] = "Jewelry Crafting Research Timer",
    ["TEBTopBankIcon"] = "Bank Space",
    ["TEBTopFPSIcon"] = "FPS",
    ["TEBTopWCIcon"] = "Weapon Charge",
    ["TEBTopLocationIcon"] = "Location",
    ["TEBTopTTIcon"] = "Thief's Tools",
    ["TEBTopMemoryIcon"] = "Memory Usage",
    ["TEBTopFTIcon"] = "Fast Travel Timer",
    ["TEBTopKillsIcon"] = "Kill Counter",
    ["TEBTopEnlightenmentIcon"] = "Enlightenment",
    ["TEBTopMailIcon"] = "Unread Mail",
    ["TEBTopETIcon"] = "Event Tickets",
    ["TEBTopFoodIcon"] = "Food Buff Timer",
    ["TEBTopMundusIcon"] = "Mundus Stone",
    ["TEBTopBountyIcon"] = "Bounty Timer",
    ["TEBTopVampirismIcon"] = "Vampirism" 
}

local gadgetReference = {
}

local defaultGadgets = {"Level", "Gold", "Tel Var Stones", "Transmute Crystals", "Writ Vouchers", "Soul Gems", "Alliance Points", "Bag Space", "Mount Timer", "Experience", "Clock", "Sky Shards", "Durability", "Blacksmithing Research Timer", "Clothing Research Timer", "Woodworking Research Timer", "Jewelry Crafting Research Timer", "Bank Space", "Latency", "FPS", "Weapon Charge", "Location", "Thief's Tools", "Memory Usage", "Fast Travel Timer", "Kill Counter", "Enlightenment", "Unread Mail", "Event Tickets", "Food Buff Timer", "Mundus Stone", "Bounty Timer", "Vampirism" }

for i=1, #defaultGadgets do
    local gadgetName = defaultGadgets[i]
    gadgetText[gadgetName] = true
    iconIndicator[gadgetName] = false
end

local originalCompassTop = 0
local originalTargetUnitFrameTop = 0

------------------------------------------------------
-- OnAddOnLoaded
------------------------------------------------------
function TEB.OnAddOnLoaded(event, addOnName)
    if addOnName ~= TEB.name then return end
    if addOnName == TEB.name then
        ZO_CreateStringId("SI_BINDING_NAME_RUN_TEB", GetString(SI_CWA_KEY_BINDING))        
        TEB:Initialize()
    end
end

------------------------------------------------------
-- Initialize
------------------------------------------------------
function TEB:Initialize()
    TEBTooltip:SetHidden(true)
    
    originalTargetUnitFrameTop = ZO_TargetUnitFramereticleover:GetTop()
    originalCompassTop = ZO_CompassFrame:GetTop()
    originalActionBarTop = ZO_ActionBar1:GetTop()
    originalHealthTop = ZO_PlayerAttributeHealth:GetTop()
    originalMagickaTop = ZO_PlayerAttributeMagicka:GetTop()
    originalStaminaTop = ZO_PlayerAttributeStamina:GetTop()
    originalMountStaminaTop = ZO_PlayerAttributeMountStamina:GetTop()
    originalBountyTop = ZO_HUDInfamyMeter:GetTop()
    
    
    -- 1. Icon Object (object)
    -- 2. Text Object (object)
    -- 3. Icon File Base (string)
    -- 4. Icon Object (string)
    -- 5. Current Icon Texture (string)
    -- 6. Gadget Is Pulsing
    gadgetReference = {
        ["Alliance Points"] = {TEBTopAPIcon, TEBTopAP, "ap", "TEBTopAPIcon", "", false},
        ["Bag Space"] = {TEBTopBagIcon, TEBTopBag, "bag", "TEBTopBagIcon", "", false},
        ["Bank Space"] = {TEBTopBankIcon, TEBTopBank, "bank", "TEBTopBankIcon", "", false},
        ["Blacksmithing Research Timer"] = {TEBTopResearchBlacksmithingIcon, TEBTopResearchBlacksmithing, "blacksmithing", "TEBTopResearchBlacksmithingIcon", "", false},
        ["Bounty Timer"] = {TEBTopBountyIcon, TEBTopBounty, "bounty", "TEBTopBountyIcon", "", false},
        ["Clock"] = {TEBTopTimeIcon, TEBTopTime, "clock", "TEBTopTimeIcon", "", false},
        ["Clothing Research Timer"] = {TEBTopResearchClothingIcon, TEBTopResearchClothing, "clothing", "TEBTopResearchClothingIcon", "", false},
        ["Durability"] = {TEBTopDurabilityIcon, TEBTopDurability, "durability", "TEBTopDurabilityIcon", "", false},
        ["Enlightenment"] = {TEBTopEnlightenmentIcon, TEBTopEnlightenment, "enlightenment", "TEBTopEnlightenmentIcon", "", false},
        ["Event Tickets"] = {TEBTopETIcon, TEBTopET, "eventtickets", "TEBTopETIcon", "", false},
        ["Experience"] = {TEBTopXPIcon, TEBTopXP, "experience", "TEBTopXPIcon", "", false},
        ["Fast Travel Timer"] = {TEBTopFTIcon, TEBTopFT, "ft", "TEBTopFTIcon", "", false},
        ["Food Buff Timer"] = {TEBTopFoodIcon, TEBTopFood, "foodbuff", "TEBTopFoodIcon", "", false},
        ["FPS"] = {TEBTopFPSIcon, TEBTopFPS, "fps", "TEBTopFPSIcon", "", false},
        ["Gold"] = {TEBTopGoldIcon, TEBTopGold, "gold", "TEBTopGoldIcon", "", false},
        ["Kill Counter"] = {TEBTopKillsIcon, TEBTopKills, "kc", "TEBTopKillsIcon", "", false},
        ["Latency"] = {TEBTopLatencyIcon, TEBTopLatency, "latency", "TEBTopLatencyIcon", "", false},
        ["Level"] = {TEBTopLevelIcon, TEBTopLevel, "cp", "TEBTopLevelIcon", "", false},
        ["Location"] = {TEBTopLocationIcon, TEBTopLocation, "location", "TEBTopLocationIcon", "", false},
        ["Jewelry Crafting Research Timer"] = {TEBTopResearchJewelryCraftingIcon, TEBTopResearchJewelryCrafting, "jewelry", "TEBTopResearchJewelryCraftingIcon", "", false},
        ["Memory Usage"] = {TEBTopMemoryIcon, TEBTopMemory, "ram", "TEBTopMemoryIcon", "", false},
        ["Mount Timer"] = {TEBTopMountIcon, TEBTopMount, "mount", "TEBTopMountIcon", "", false},
        ["Mundus Stone"] = {TEBTopMundusIcon, TEBTopMundus, "mundus", "TEBTopMundusIcon", "", false},
        ["Sky Shards"] = {TEBTopSkyShardsIcon, TEBTopSkyShards, "skyshards", "TEBTopSkyShardsIcon", "", false},
        ["Soul Gems"] = {TEBTopSoulGemsIcon, TEBTopSoulGems, "soulgem", "TEBTopSoulGemsIcon", "", false},
        ["Tel Var Stones"] = {TEBTopTelvarIcon, TEBTopTelvar, "telvar", "TEBTopTelvarIcon", "", false},
        ["Thief's Tools"] = {TEBTopTTIcon, TEBTopTT, "tt", "TEBTopTTIcon", "", false},
        ["Transmute Crystals"] = {TEBTopTCIcon, TEBTopTC, "transmute", "TEBTopTCIcon", "", false},
        ["Unread Mail"] = {TEBTopMailIcon, TEBTopMail, "mail", "TEBTopMailIcon", "", false},
        ["Vampirism"] = {TEBTopVampirismIcon, TEBTopVampirism, "vampirism", "TEBTopVampirismIcon", "", false},
        ["Weapon Charge"] = {TEBTopWCIcon, TEBTopWC, "wc", "TEBTopWCIcon", "", false},
        ["Woodworking Research Timer"] = {TEBTopResearchWoodworkingIcon, TEBTopResearchWoodworking, "woodworking", "TEBTopResearchWoodworkingIcon", "", false},
        ["Writ Vouchers"] = {TEBTopWritIcon, TEBTopWrit, "writs", "TEBTopWritIcon", "", false},
    }    
    
    local defaults = {
        backdropOpacity = 100,
        barPosition = "top",
        barWidth = "dynamic",
        barY = 0,
        barLocked = true,
        pulseType = "fade out",
        gadgetsLocked = true,
        lockMessage = true,
        controlsPosition = "center",
        bumpCompass = true,
        gadgets = {"Level", "Experience", "Bag Space", "Gold", "Mount Timer", "Durability", "Weapon Charge", "Bounty Timer"},  
        gadgets_pvp = {"Level", "Experience", "Bag Space", "Gold", "Mount Timer", "Durability", "Weapon Charge"},
        mount_Tracker = { },
        gold_Tracker = { },
        clock_TwentyFourHourClock = true,
        clock_DisplayPreference = "local time",
        soulgems_DisplayPreference = "total filled/empty",      
        soulgems_ColorCrown = true,
        soulgems_ColorNormal = true,
        skyshards_DisplayPreference = "collected/unspent points",
        durability_DisplayPreference = "durability %",
        durability_Warning = 50,
        durability_Danger = 25,
        durability_Critical = 10,
        durability_Good = true,
        research_DisplayPreference = "simple",
        research_Dynamic = true,
        research_DisplayAllSlots = true,
        research_ShowShortest = false,
        research_FreeText = "--",
        gold_DisplayPreference = "gold on character",
        latency_Warning = 100,
        latency_Danger = 500,
        latency_Good = true,
        latency_Fixed = false,
        latency_FixedLength = 100,
        combatIndicator = true,
        fps_Warning = 30,
        fps_Danger = 15,
        fps_Good = true,
        fps_Fixed = false,
        fps_FixedLength = 100,
        level_DisplayPreferenceMax = "[CP Icon] Champion Points (Unspent Points)",
        level_DisplayPreferenceNotMax = "[Class Icon] Character Level (Unspent Points)",
        bag_DisplayPreference = "slots used/total slots",
        bag_Good = true,
        bag_Warning = 50,
        bag_Danger = 75,   
        bag_Critical = 90,                    
        bank_DisplayPreference = "slots used/total slots",
        bank_Good = true,
        bank_Warning = 50,
        bank_Danger = 75,
        bank_Critical = 90,
        enlightenment_Warning = 200000,
        enlightenment_Danger = 100000,
        enlightenment_Critical = 500000,
        enlightenment_Dynamic = false,
        experience_DisplayPreference = "% towards next level/CP",
        autohide_GameMenu = true,
        autohide_Chatter = true,
        autohide_Crafting = true,
        autohide_Bank = true,
        autohide_GuildBank = true,
        bumpActionBar = true,
        combatOpacity = 100,
        wc_Good = true,
        wc_Warning = 50,
        wc_Danger = 25,
        wc_Critical = 10,
        wc_AutoPoison = true,
        wc_PoisonWarning = 20,
        wc_PoisonDanger = 10,
        wc_PoisonCritical = 5,       
        location_DisplayPreference = "(x, y) Zone Name",
        tt_Danger = 10,
        tt_Warning = 25,
        tt_Good = true,
        tt_DisplayPreference = "stolen treasures/stolen goods (lockpicks)",
        memory_Good = true,
        memory_Warning = 512,
        memory_Danger = 768,
        tt_InvDanger = 75,
        tt_InvWarning = 50,
        ft_DisplayPreference = "time left/cost",
        ft_TimerDisplayPreference = "simple",
        ft_Dynamic = true,
        ft_Good = false,
        thousandsSeparator = true,
        kc_DisplayPreference = "Killing Blows/Deaths (Kill Ratio)",
        ap_DisplayPreference = "Total Points",
        scale = 100,
        level_Dynamic = true,
        mount_Dynamic = true,
        mount_DisplayPreference = "simple",
        mount_Good = false,     
        mount_Critical = false,
        mount_Tracker = {},   
        gold_Tracker = { },
        mail_Dynamic = true,
        mail_Good = false,
        mail_Critical = false,        
        icons_Mode = "white",
        gadgetText = gadgetText,
        et_Dynamic = true,
        et_DisplayPreference = "tickets",
        et_Warning = 9,
        et_Danger = 12,       
        iconIndicator = iconIndicator,
        food_Dynamic = true,
        food_Warning = 15,
        food_Danger = 7,
        food_Critical = 2,
        food_PulseAfter = false,
        food_Dynamic = true,
        food_DisplayPreference = "simple",
        bounty_Dynamic = true,
        bounty_DisplayPreference = "simple",
        bounty_Warning = "yellow",
        bounty_Danger = "orange",
        bounty_Critical = "red",
        bounty_Good = "normal",
        vampirism_DisplayPreference = "Stage (Timer)",
        vampirism_TimerPreference = "simple",
        vampirism_StageColor = {
            [1] = "normal",
            [2] = "yellow",
            [3] = "orange",
            [4] = "red"
        },
        vampirism_Dynamic = true,
        font = "Univers57",
        pulseWhenCritical = false,
        barLayer = 0
    }
    
    TEB.CreateSettingsWindow()  
    TEBTop:SetWidth(screenWidth)
    TEBTop:SetHidden(false)
    TEB.savedVariables = ZO_SavedVars:NewAccountWide("TEBSavedVariables", TEB.settingsRev, nil, defaults)
    
    backdropOpacity = TEB.savedVariables.backdropOpacity
    combatOpacity = TEB.savedVariables.combatOpacity
    barPosition = TEB.savedVariables.barPosition
    barWidth = TEB.savedVariables.barWidth
    barY = TEB.savedVariables.barY
    barLocked = TEB.savedVariables.barLocked
    gadgetsLocked = TEB.savedVariables.gadgetsLocked
    lockMessage = TEB.savedVariables.lockMessage

    controlsPosition = TEB.savedVariables.controlsPosition
    bumpCompass = TEB.savedVariables.bumpCompass
    gadgets = TEB.savedVariables.gadgets
    gadgets_pvp = TEB.savedVariables.gadgets_pvp
    pulseType = TEB.savedVariables.pulseType
        
    TEB.DefragGadgets()
    
    clock_TwentyFourHourClock = TEB.savedVariables.clock_TwentyFourHourClock
    clock_DisplayPreference = TEB.savedVariables.clock_DisplayPreference
    soulgems_DisplayPreference = TEB.savedVariables.soulgems_DisplayPreference
    soulgems_ColorCrown = TEB.savedVariables.soulgems_ColorCrown
    soulgems_ColorNormal = TEB.savedVariables.soulgems_ColorNormal
    skyshards_DisplayPreference = TEB.savedVariables.skyshards_DisplayPreference
    durability_DisplayPreference = TEB.savedVariables.durability_DisplayPreference
    durability_Warning = TEB.savedVariables.durability_Warning
    durability_Danger = TEB.savedVariables.durability_Danger
    durability_Good = TEB.savedVariables.durability_Good
    durability_Critical = TEB.savedVariables.durability_Critical
    research_DisplayPreference = TEB.savedVariables.research_DisplayPreference
    research_Dynamic = TEB.savedVariables.research_Dynamic
    research_DisplayAllSlots = TEB.savedVariables.research_DisplayAllSlots
    research_ShowShortest = TEB.savedVariables.research_ShowShortest
    research_FreeText = TEB.savedVariables.research_FreeText
    gold_DisplayPreference = TEB.savedVariables.gold_DisplayPreference
    if gold_DisplayPreference == "total gold" then
        gold_DisplayPreference = "character+bank gold"
        TEB.savedVariables.gold_DisplayPreference = "character+bank gold"
    end
    gold_Tracker = TEB.savedVariables.gold_Tracker
    latency_Warning = TEB.savedVariables.latency_Warning
    latency_Danger = TEB.savedVariables.latency_Danger
    latency_Good = TEB.savedVariables.latency_Good
    latency_Fixed = TEB.savedVariables.latency_Fixed
    latency_FixedLength = TEB.savedVariables.latency_FixedLength
    combatIndicator = TEB.savedVariables.combatIndicator
    fps_Warning = TEB.savedVariables.fps_Warning
    fps_Danger = TEB.savedVariables.fps_Danger
    fps_Good = TEB.savedVariables.fps_Good
    fps_Fixed = TEB.savedVariables.fps_Fixed
    fps_FixedLength = TEB.savedVariables.fps_FixedLength
    level_DisplayPreferenceMax = TEB.savedVariables.level_DisplayPreferenceMax
    level_DisplayPreferenceNotMax = TEB.savedVariables.level_DisplayPreferenceNotMax
    bag_DisplayPreference = TEB.savedVariables.bag_DisplayPreference
    bag_Good = TEB.savedVariables.bag_Good
    bag_Warning = TEB.savedVariables.bag_Warning
    bag_Danger = TEB.savedVariables.bag_Danger
    bag_Critical = TEB.savedVariables.bag_Critical
    bank_DisplayPreference = TEB.savedVariables.bank_DisplayPreference
    bank_Good = TEB.savedVariables.bank_Good
    bank_Warning = TEB.savedVariables.bank_Warning
    bank_Danger = TEB.savedVariables.bank_Danger
    bank_Critical = TEB.savedVariables.bank_Critical
    enlightenment_Warning = TEB.savedVariables.enlightenment_Warning
    enlightenment_Danger = TEB.savedVariables.enlightenment_Danger
    enlightenment_Critical = TEB.savedVariables.enlightenment_Critical
    enlightenment_Dynamic = TEB.savedVariables.enlightenment_Dynamic
    experience_DisplayPreference = TEB.savedVariables.experience_DisplayPreference
    autohide_GameMenu = TEB.savedVariables.autohide_GameMenu
    autohide_Chatter = TEB.savedVariables.autohide_Chatter
    autohide_Crafting = TEB.savedVariables.autohide_Crafting
    autohide_Bank = TEB.savedVariables.autohide_Bank
    autohide_GuildBank = TEB.savedVariables.autohide_GuildBank
    bumpActionBar = TEB.savedVariables.bumpActionBar
    wc_Good = TEB.savedVariables.wc_Good
    wc_Warning = TEB.savedVariables.wc_Warning
    wc_Danger = TEB.savedVariables.wc_Danger
    wc_Critical = TEB.savedVariables.wc_Critical
    wc_AutoPoison = TEB.savedVariables.wc_AutoPoison
    wc_PoisonWarning = TEB.savedVariables.wc_PoisonWarning
    wc_PoisonDanger = TEB.savedVariables.wc_PoisonDanger
    wc_PoisonCritical = TEB.savedVariables.wc_PoisonCritical  
    location_DisplayPreference = TEB.savedVariables.location_DisplayPreference
    tt_Good = TEB.savedVariables.tt_Good
    tt_Warning = TEB.savedVariables.tt_Warning
    tt_Danger = TEB.savedVariables.tt_Danger
    tt_DisplayPreference = TEB.savedVariables.tt_DisplayPreference
    memory_Good = TEB.savedVariables.memory_Good
    memory_Warning = TEB.savedVariables.memory_Warning
    memory_Danger = TEB.savedVariables.memory_Danger
    tt_InvWarning = TEB.savedVariables.tt_InvWarning
    tt_InvDanger = TEB.savedVariables.tt_InvDanger
    ft_DisplayPreference = TEB.savedVariables.ft_DisplayPreference
    ft_TimerDisplayPreference = TEB.savedVariables.ft_TimerDisplayPreference
    ft_Dynamic = TEB.savedVariables.ft_Dynamic
    ft_Good = TEB.savedVariables.ft_Good
    et_Dynamic = TEB.savedVariables.et_Dynamic
    et_DisplayPreference = TEB.savedVariables.et_DisplayPreference
    et_Warning = TEB.savedVariables.et_Warning
    et_Danger = TEB.savedVariables.et_Danger
    thousandsSeparator = TEB.savedVariables.thousandsSeparator
    kc_DisplayPreference = TEB.savedVariables.kc_DisplayPreference
    ap_DisplayPreference = TEB.savedVariables.ap_DisplayPreference
    scale = TEB.savedVariables.scale
    level_Dynamic = TEB.savedVariables.level_Dynamic
    mount_DisplayPreference = TEB.savedVariables.mount_DisplayPreference
    mount_Dynamic = TEB.savedVariables.mount_Dynamic
    mount_Good = TEB.savedVariables.mount_Good
    mount_Critical = TEB.savedVariables.mount_Critical
    mount_Tracker = TEB.savedVariables.mount_Tracker
    mail_Dynamic = TEB.savedVariables.mail_Dynamic
    mail_Good = TEB.savedVariables.mail_Good
    mail_Critical = TEB.savedVariables.mail_Critical
    icons_Mode = TEB.savedVariables.icons_Mode
    if icons_Mode == "black \& white" then
         icons_Mode = "white"
         TEB.savedVariables.icons_Mode = "white"
    end
    gadgetText = TEB.savedVariables.gadgetText
    iconIndicator = TEB.savedVariables.iconIndicator
    food_Dynamic = TEB.savedVariables.food_Dynamic
    food_Warning = TEB.savedVariables.food_Warning
    food_Danger = TEB.savedVariables.food_Danger
    food_Critical = TEB.savedVariables.food_Critical
    food_PulseAfter = TEB.savedVariables.food_PulseAfter
    food_Dynamic = TEB.savedVariables.food_Dynamic
    food_DisplayPreference = TEB.savedVariables.food_DisplayPreference 
    bounty_Dynamic = TEB.savedVariables.bounty_Dynamic
    bounty_DisplayPreference = TEB.savedVariables.bounty_DisplayPreference
    bounty_Warning = TEB.savedVariables.bounty_Warning
    bounty_Danger = TEB.savedVariables.bounty_Danger
    bounty_Critical = TEB.savedVariables.bounty_Critical    
    bounty_Good = TEB.savedVariables.bounty_Good
    vampirism_DisplayPreference = TEB.savedVariables.vampirism_DisplayPreference
    vampirism_TimerPreference = TEB.savedVariables.vampirism_TimerPreference
    vampirism_StageColor = TEB.savedVariables.vampirism_StageColor
    font = TEB.savedVariables.font
    pulseWhenCritical = TEB.savedVariables.pulseWhenCritical
    barLayer = TEB.savedVariables.barLayer

    TEB.SetFPSFixed()        
    TEB.SetLatencyFixed() 
            
    addonInitialized = true
    
    TEBTop:ClearAnchors()
    TEBTop:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 0, barY)
    
    TEB.SetBarLayer()
    TEB.LockUnlockBar(barLocked)
    TEB.LockUnlockGadgets(gadgetsLocked)

    TEB.ConvertGadgetSettings()
    TEB.CalculateBagItems()    
    TEB:SetBackdropOpacity()
    TEB:SetBarPosition()
    TEB:SetBarWidth()
    TEB:RebuildBar()
    TEB:UpdateControlsPosition()
    TEB.ResizeBar()
    
    TEB.AddToMountDatabase(GetUnitName("player"))
    TEB.AddToGoldDatabase(GetUnitName("player"))
end

------------------------------------------------------
-- SetlatencyFixed
------------------------------------------------------
function TEB.SetLatencyFixed()
    if latency_Fixed then
        TEBTopLatency:SetHeight(TEBTopLatency:GetHeight())
        TEBTopLatency:SetWidth(latency_FixedLength)  
    else
        if addonInitialized then
            ReloadUI("ingame")
        end
    end
end

------------------------------------------------------
-- SetFPSFixed
------------------------------------------------------
function TEB.SetFPSFixed()
    if fps_Fixed then
        TEBTopFPS:SetHeight(TEBTopFPS:GetHeight())
        TEBTopFPS:SetWidth(fps_FixedLength)  
    else
        if addonInitialized then
            ReloadUI("ingame")
        end
    end
end

------------------------------------------------------
-- SetBarLayer
------------------------------------------------------
function TEB.SetBarLayer()
    TEBTop:SetDrawLayer(barLayer)
    TEBTooltip:SetDrawLayer(4)
end
------------------------------------------------------
-- HideBar
------------------------------------------------------
function TEB.HideBar()
    if autohide_GameMenu then hideBar = true end
end

------------------------------------------------------
-- ShowBar
------------------------------------------------------
function TEB.ShowBar()
    hideBar = false
end

------------------------------------------------------
-- ChatterHideBar
------------------------------------------------------
function TEB.ChatterHideBar()
    if autohide_Chatter then hideBar = true end
end

------------------------------------------------------
-- CraftingHideBar
------------------------------------------------------
function TEB.CraftingHideBar()
    if autohide_Crafting then hideBar = true end
end

------------------------------------------------------
-- BankHideBar
------------------------------------------------------
function TEB.BankHideBar()
    if autohide_Bank then hideBar = true end
end

------------------------------------------------------
-- GuildBankHideBar
------------------------------------------------------
function TEB.GuildBankHideBar()
    if autohide_GuildBank then hideBar = true end
end

------------------------------------------------------
-- SetBackdropOpacity
------------------------------------------------------
function TEB:SetBackdropOpacity()
    local alpha = backdropOpacity/100
    TEBTopBG:SetAlpha(alpha)
end

------------------------------------------------------
-- RebuildBar
------------------------------------------------------
function TEB:RebuildBar()
    if addonInitialized then

        TEB.DefragGadgets()

        if pvpMode then
            gadgetList = gadgets_pvp
        else
            gadgetList = gadgets
        end
        
        local lastGadget = TEBTopInfoAnchor
        local firstGadgetAdded = false
    
        for k, v in pairs(gadgetReference) do
            if ignoreGadget ~= gadgetReference[k][4] then
                gadgetReference[k][1]:ClearAnchors()
                gadgetReference[k][2]:ClearAnchors()
                gadgetReference[k][1]:SetHidden(true)
                gadgetReference[k][2]:SetHidden(true)            
            end
        end                   

        for i=1, #defaultGadgets do
            if gadgetList[i] ~= "(None)" then
                TEB.SetIcon(gadgetList[i], "normal")                                                             
            end               
            
            if gadgetList[i] == "Latency" then
                lastGadget, firstGadgetAdded = TEB:RebuildLatency(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Level" then
                lastGadget, firstGadgetAdded = TEB:RebuildLevel(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Gold" then
                lastGadget, firstGadgetAdded = TEB:RebuildGold(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Tel Var Stones" then
                lastGadget, firstGadgetAdded = TEB:RebuildTelvarStones(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Transmute Crystals" then
                lastGadget, firstGadgetAdded = TEB:RebuildTC(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Writ Vouchers" then
                lastGadget, firstGadgetAdded = TEB:RebuildWrit(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Soul Gems" then
                lastGadget, firstGadgetAdded = TEB:RebuildSoulGems(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Alliance Points" then
                lastGadget, firstGadgetAdded = TEB:RebuildAP(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Bag Space" then
                lastGadget, firstGadgetAdded = TEB:RebuildBag(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Mount Timer" and (mountTimerNotMaxed or not mount_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildMountTimer(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Experience" then
                lastGadget, firstGadgetAdded = TEB:RebuildXP(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Clock" then
                lastGadget, firstGadgetAdded = TEB:RebuildClock(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Sky Shards" then
                lastGadget, firstGadgetAdded = TEB:RebuildSkyShards(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Durability" then
                lastGadget, firstGadgetAdded = TEB:RebuildDurability(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Blacksmithing Research Timer" and (blackSmithingTimerRunning or not research_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildBlacksmithingResearchTimer(lastGadget, firstGadgetAdded)
            end        
            if gadgetList[i] == "Clothing Research Timer" and (clothingTimerRunning or not research_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildClothingResearchTimer(lastGadget, firstGadgetAdded)
            end  
            if gadgetList[i] == "Woodworking Research Timer" and (woodWorkingTimerRunning or not research_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildWoodworkingResearchTimer(lastGadget, firstGadgetAdded)
            end  
            if gadgetList[i] == "Jewelry Crafting Research Timer" and (jewelryTimerRunning or not research_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildJewelryResearchTimer(lastGadget, firstGadgetAdded)
            end  
            if gadgetList[i] == "Bank Space" then
                lastGadget, firstGadgetAdded = TEB:RebuildBank(lastGadget, firstGadgetAdded)
            end  
            if gadgetList[i] == "FPS" then
                lastGadget, firstGadgetAdded = TEB:RebuildFPS(lastGadget, firstGadgetAdded)
            end  
            if gadgetList[i] == "Weapon Charge" then
                lastGadget, firstGadgetAdded = TEB:RebuildWC(lastGadget, firstGadgetAdded)
            end  
            if gadgetList[i] == "Location" then
                lastGadget, firstGadgetAdded = TEB:RebuildLocation(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Thief's Tools" then
                lastGadget, firstGadgetAdded = TEB:RebuildTT(lastGadget, firstGadgetAdded)
            end                              
            if gadgetList[i] == "Memory Usage" then
                lastGadget, firstGadgetAdded = TEB:RebuildMemory(lastGadget, firstGadgetAdded)
            end                              
            if gadgetList[i] == "Fast Travel Timer" and (ftTimerRunning or not ft_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildFT(lastGadget, firstGadgetAdded)
            end   
            if gadgetList[i] == "Kill Counter" then
                lastGadget, firstGadgetAdded = TEB:RebuildKillCounter(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Enlightenment" and (enlightenmentVisible or not enlightenment_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildEnlightenment(lastGadget, firstGadgetAdded)
            end 
            if gadgetList[i] == "Unread Mail" and (mailUnread or not mail_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildMail(lastGadget, firstGadgetAdded)
            end 
            if gadgetList[i] == "Event Tickets" and (etHasTickets or not et_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildET(lastGadget, firstGadgetAdded)
            end   
            if gadgetList[i] == "Food Buff Timer" and ((foodTimerRunning or not food_Dynamic or not gadgetsLocked) or (food_PulseAfter and foodBuffWasActive)) then
                lastGadget, firstGadgetAdded = TEB:RebuildFood(lastGadget, firstGadgetAdded)
            end   
            if gadgetList[i] == "Mundus Stone" then
                lastGadget, firstGadgetAdded = TEB:RebuildMundus(lastGadget, firstGadgetAdded)
            end
            if gadgetList[i] == "Bounty Timer" and (bountyTimerRunning or not bounty_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildBountyTimer(lastGadget, firstGadgetAdded)
            end   
            if gadgetList[i] == "Vampirism" and (isVampire or not vampirism_Dynamic or not gadgetsLocked) then
                lastGadget, firstGadgetAdded = TEB:RebuildVampirism(lastGadget, firstGadgetAdded)
            end                               
        end
    
        TEBTopEndingAnchor:ClearAnchors()
        TEBTopEndingAnchor:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0)
        
    end
    
    TEB:UpdateControlsPosition()
end

------------------------------------------------------
-- AddToGoldDatabase
------------------------------------------------------
function TEB.AddToGoldDatabase(character)
    local foundCharacter = false
    for k, v in pairs(gold_Tracker) do
        if k == character then
            foundCharacter = true
        end
    end
    local goldCharacter = GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_CHARACTER)

    if not foundCharacter then       
        gold_Tracker[character] = {true, goldCharacter} 
    else
        local characterTracked = gold_Tracker[character][1]
        gold_Tracker[character] = {characterTracked, goldCharacter}
    end
end

------------------------------------------------------
-- AddToMountDatabase
------------------------------------------------------
function TEB.AddToMountDatabase(character)
    local foundCharacter = false
    for k, v in pairs(mount_Tracker) do
        if k == character then
            foundCharacter = true
        end
    end
    local mountTimeLeft = GetTimeUntilCanBeTrained() / 1000
    local trainTime = os.time() + mountTimeLeft

    if not foundCharacter then
        if not STABLE_MANAGER:IsRidingSkillMaxedOut() then        
            mount_Tracker[character] = {true, trainTime}
        end  
    else
        local characterTracked = mount_Tracker[character][1]
        local savedTrainTime = mount_Tracker[character][2]
        if not STABLE_MANAGER:IsRidingSkillMaxedOut() and savedTrainTime ~= -1 then        
            mount_Tracker[character] = {characterTracked, trainTime}
        else
            mount_Tracker[character] = {false, -1}
        end                      
    end
end

------------------------------------------------------
-- RebuildMountTrackerList
------------------------------------------------------
function TEB.RebuildMountTrackerList()
    trackerDropdown = {}
    trackerDropdown[1] = "(choose a character)"
    local index = 2
    for k, v in pairs(mount_Tracker) do
        if v[2] ~= -1 then
            if v[1] then               
                trackerDropdown[index] = k.." (tracked)"
            else
                trackerDropdown[index] = k.." (untracked)"
            end
            index = index + 1
        end
    end
end

------------------------------------------------------
-- DisableMountTracker
------------------------------------------------------
function TEB.DisableMountTracker()
    if mount_Tracker[playerName] then
        return false
    else
        return true
    end
end

------------------------------------------------------
-- DisableGoldTracker
------------------------------------------------------
function TEB.DisableGoldTracker()
    if gold_Tracker[playerName] then
        return false
    else
        return true
    end
end

------------------------------------------------------
-- GetCharacterGoldTracked
------------------------------------------------------
function TEB.GetCharacterGoldTracked()
    if gold_Tracker[playerName] then
        return gold_Tracker[playerName][1]
    else
        return false
    end
end

------------------------------------------------------
-- GetCharacterMountTracked
------------------------------------------------------
function TEB.GetCharacterMountTracked()
    if mount_Tracker[playerName] then
        return mount_Tracker[playerName][1]
    else
        return false
    end
end

------------------------------------------------------
-- SetCharacterMountTracked
------------------------------------------------------
function TEB.SetCharacterMountTracked(track)
    if mount_Tracker[playerName] then
        local mountTimeLeft = GetTimeUntilCanBeTrained() / 1000
        local trainTime = os.time() + mountTimeLeft
        mount_Tracker[playerName][1] = track
        mount_Tracker[playerName][2] = trainTime
    end
end

------------------------------------------------------
-- SetCharacterGoldTracked
------------------------------------------------------
function TEB.SetCharacterGoldTracked(track)
    if gold_Tracker[playerName] then
        local goldCharacter = GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_CHARACTER)
        gold_Tracker[playerName][1] = track
        gold_Tracker[playerName][2] = goldCharacter
    end
end

------------------------------------------------------
-- SetIcon
------------------------------------------------------
function TEB.SetIcon(gadgetName, iconStyle)
    if addonInitialized then
        gadgetData = gadgetReference[gadgetName]
        local colorTag = ""
        if iconStyle == "normal" then
            if icons_Mode == "white" then colorTag = "white" end
            if icons_Mode == "color" then colorTag = "color" end
        else
            colorTag = iconStyle
        end
        local fileName = gadgetData[3].."_"..colorTag..".dds"
        if TEB.IconDifferent(gadgetName, fileName) then
            gadgetData[1]:SetNormalTexture("TEB/Images/"..fileName)
            gadgetReference[gadgetName][5] = fileName
        end
    end
end

------------------------------------------------------
-- IconDifferent
------------------------------------------------------
function TEB.IconDifferent(gadgetName, fileName)
    if gadgetReference[gadgetName][5] ~= fileName then
        return true
    else
        return false
    end
end

------------------------------------------------------
-- RebuildLatency
------------------------------------------------------
function TEB:RebuildLatency(lastGadget, firstGadgetAdded)
    TEBTopLatencyIcon:SetHidden(false)
    TEBTopLatency:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopLatencyIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopLatencyIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopLatency:SetAnchor(TOPLEFT, TEBTopLatencyIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopLatency
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildVampirism
------------------------------------------------------
function TEB:RebuildVampirism(lastGadget, firstGadgetAdded)
    TEBTopVampirismIcon:SetHidden(false)
    TEBTopVampirism:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopVampirismIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopVampirismIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopVampirism:SetAnchor(TOPLEFT, TEBTopVampirismIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopVampirism
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildLevel
------------------------------------------------------
function TEB:RebuildLevel(lastGadget, firstGadgetAdded)
    
    -- 1 = Dragon Knight
    -- 2 = Sorcerer
    -- 3 = Night Blade
    -- 4 = Warden
    -- 5 = Necromancer
    -- 6 = Templar
    
    local classIconObject = ""
    local playerClass = GetUnitClassId("player")
    local showClassIcon = false
    
    if lvl == 50 then    
        if string.match(level_DisplayPreferenceMax, "%[CP Icon%]") then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/cp_white.dds")
        else
            showClassIcon = true
        end
    end
    if lvl < 50 then    
        if string.match(level_DisplayPreferenceNotMax, "%[CP Icon%]") then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/cp_color.dds")
        else
            showClassIcon = true
        end
    end
    
    if playerClass == 1 then playerClassName = "Dragon Knight" end
    if playerClass == 3 then playerClassName = "Night Blade" end
    if playerClass == 2 then playerClassName = "Sorcerer" end
    if playerClass == 6 then playerClassName = "Templar" end
    if playerClass == 4 then playerClassName = "Warden" end
    if playerClass == 5 then playerClassName = "Necromancer" end

    if showClassIcon then
        local colorTag = "white"
        if icons_Mode == "color" then colorTag = "color" end
        if playerClass == 1 then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/class_dragonknight_"..icons_Mode..".dds")
        end
        if playerClass == 3 then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/class_nightblade_"..icons_Mode..".dds")
        end
        if playerClass == 2 then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/class_sorcerer_"..icons_Mode..".dds")
        end
        if playerClass == 6 then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/class_templar_"..icons_Mode..".dds")
        end
        if playerClass == 4 then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/class_warden_"..icons_Mode..".dds")
        end
        if playerClass == 5 then
            TEBTopLevelIcon:SetNormalTexture("TEB/Images/class_necromancer_"..icons_Mode..".dds")
        end        
    end
    
    TEBTopLevelIcon:SetHidden(false)
    TEBTopLevel:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopLevelIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopLevelIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopLevel:SetAnchor(TOPLEFT, TEBTopLevelIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopLevel   
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildGold
------------------------------------------------------
function TEB:RebuildGold(lastGadget, firstGadgetAdded)
    TEBTopGoldIcon:SetHidden(false)
    TEBTopGold:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopGoldIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopGoldIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopGold:SetAnchor(TOPLEFT, TEBTopGoldIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopGold     
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildMundus
------------------------------------------------------
function TEB:RebuildMundus(lastGadget, firstGadgetAdded)
    TEBTopMundusIcon:SetHidden(false)
    TEBTopMundus:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopMundusIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopMundusIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopMundus:SetAnchor(TOPLEFT, TEBTopMundusIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopMundus     
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildTelvarStones
------------------------------------------------------
function TEB:RebuildTelvarStones(lastGadget, firstGadgetAdded)
    TEBTopTelvarIcon:SetHidden(false)
    TEBTopTelvar:SetHidden(false)

    if not firstGadgetAdded then
        TEBTopTelvarIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopTelvarIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopTelvar:SetAnchor(TOPLEFT, TEBTopTelvarIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopTelvar     
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildTC
------------------------------------------------------
function TEB:RebuildTC(lastGadget, firstGadgetAdded)
    TEBTopTCIcon:SetHidden(false)
    TEBTopTC:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopTCIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopTCIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopTC:SetAnchor(TOPLEFT, TEBTopTCIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopTC     
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildWrit
------------------------------------------------------
function TEB:RebuildWrit(lastGadget, firstGadgetAdded)
    TEBTopWritIcon:SetHidden(false)
    TEBTopWrit:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopWritIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopWritIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopWrit:SetAnchor(TOPLEFT, TEBTopWritIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopWrit     
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildSoulGems
------------------------------------------------------
function TEB:RebuildSoulGems(lastGadget, firstGadgetAdded)
    TEBTopSoulGemsIcon:SetHidden(false)
    TEBTopSoulGems:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopSoulGemsIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopSoulGemsIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopSoulGems:SetAnchor(TOPLEFT, TEBTopSoulGemsIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopSoulGems
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildAP
------------------------------------------------------
function TEB:RebuildAP(lastGadget, firstGadgetAdded)
    TEBTopAPIcon:SetHidden(false)
    TEBTopAP:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopAPIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopAPIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopAP:SetAnchor(TOPLEFT, TEBTopAPIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopAP
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildBag
------------------------------------------------------
function TEB:RebuildBag(lastGadget, firstGadgetAdded)
    TEBTopBagIcon:SetHidden(false)
    TEBTopBag:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopBagIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopBagIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopBag:SetAnchor(TOPLEFT, TEBTopBagIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopBag
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildBank
------------------------------------------------------
function TEB:RebuildBank(lastGadget, firstGadgetAdded)
    TEBTopBankIcon:SetHidden(false)
    TEBTopBank:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopBankIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopBankIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopBank:SetAnchor(TOPLEFT, TEBTopBankIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopBank
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildFPS
------------------------------------------------------
function TEB:RebuildFPS(lastGadget, firstGadgetAdded)
    TEBTopFPSIcon:SetHidden(false)
    TEBTopFPS:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopFPSIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopFPSIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopFPS:SetAnchor(TOPLEFT, TEBTopFPSIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopFPS
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildMountTimer
------------------------------------------------------
function TEB:RebuildMountTimer(lastGadget, firstGadgetAdded)
    TEBTopMountIcon:SetHidden(false)
    TEBTopMount:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopMountIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopMountIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopMount:SetAnchor(TOPLEFT, TEBTopMountIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopMount
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildXP
------------------------------------------------------
function TEB:RebuildXP(lastGadget, firstGadgetAdded)
    TEBTopXPIcon:SetHidden(false)
    TEBTopXP:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopXPIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopXPIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopXP:SetAnchor(TOPLEFT, TEBTopXPIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopXP
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildClock
------------------------------------------------------
function TEB:RebuildClock(lastGadget, firstGadgetAdded)
    TEBTopTimeIcon:SetHidden(false)
    TEBTopTime:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopTimeIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopTimeIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopTime:SetAnchor(TOPLEFT, TEBTopTimeIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopTime
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildSkyShards
------------------------------------------------------
function TEB:RebuildSkyShards(lastGadget, firstGadgetAdded)
    TEBTopSkyShardsIcon:SetHidden(false)
    TEBTopSkyShards:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopSkyShardsIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopSkyShardsIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopSkyShards:SetAnchor(TOPLEFT, TEBTopSkyShardsIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopSkyShards
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildDurability
------------------------------------------------------
function TEB:RebuildDurability(lastGadget, firstGadgetAdded)
    TEBTopDurabilityIcon:SetHidden(false)
    TEBTopDurability:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopDurabilityIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopDurabilityIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopDurability:SetAnchor(TOPLEFT, TEBTopDurabilityIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopDurability
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildBlacksmithingResearchTimer
------------------------------------------------------
function TEB:RebuildBlacksmithingResearchTimer(lastGadget, firstGadgetAdded)
    TEBTopResearchBlacksmithingIcon:SetHidden(false)
    TEBTopResearchBlacksmithing:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopResearchBlacksmithingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopResearchBlacksmithingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopResearchBlacksmithing:SetAnchor(TOPLEFT, TEBTopResearchBlacksmithingIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopResearchBlacksmithing
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildClothinggResearchTimer
------------------------------------------------------
function TEB:RebuildClothingResearchTimer(lastGadget, firstGadgetAdded)
    TEBTopResearchClothingIcon:SetHidden(false)
    TEBTopResearchClothing:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopResearchClothingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopResearchClothingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopResearchClothing:SetAnchor(TOPLEFT, TEBTopResearchClothingIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopResearchClothing
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildWoodworkingResearchTimer
------------------------------------------------------
function TEB:RebuildWoodworkingResearchTimer(lastGadget, firstGadgetAdded)
    TEBTopResearchWoodworkingIcon:SetHidden(false)
    TEBTopResearchWoodworking:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopResearchWoodworkingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopResearchWoodworkingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopResearchWoodworking:SetAnchor(TOPLEFT, TEBTopResearchWoodworkingIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopResearchWoodworking
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildJewelryResearchTimer
------------------------------------------------------
function TEB:RebuildJewelryResearchTimer(lastGadget, firstGadgetAdded)
    TEBTopResearchJewelryCraftingIcon:SetHidden(false)
    TEBTopResearchJewelryCrafting:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopResearchJewelryCraftingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopResearchJewelryCraftingIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopResearchJewelryCrafting:SetAnchor(TOPLEFT, TEBTopResearchJewelryCraftingIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopResearchJewelryCrafting
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildWC
------------------------------------------------------
function TEB:RebuildWC(lastGadget, firstGadgetAdded)
    TEBTopWCIcon:SetHidden(false)
    TEBTopWC:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopWCIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopWCIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopWC:SetAnchor(TOPLEFT, TEBTopWCIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopWC
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildLocation
------------------------------------------------------
function TEB:RebuildLocation(lastGadget, firstGadgetAdded)
    TEBTopLocationIcon:SetHidden(false)
    TEBTopLocation:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopLocationIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopLocationIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopLocation:SetAnchor(TOPLEFT, TEBTopLocationIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopLocation
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildTT
------------------------------------------------------
function TEB:RebuildTT(lastGadget, firstGadgetAdded)
    TEBTopTTIcon:SetHidden(false)
    TEBTopTT:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopTTIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopTTIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopTT:SetAnchor(TOPLEFT, TEBTopTTIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopTT
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildMemory
------------------------------------------------------
function TEB:RebuildMemory(lastGadget, firstGadgetAdded)
    TEBTopMemoryIcon:SetHidden(false)
    TEBTopMemory:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopMemoryIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopMemoryIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopMemory:SetAnchor(TOPLEFT, TEBTopMemoryIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopMemory
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildFT
------------------------------------------------------
function TEB:RebuildFT(lastGadget, firstGadgetAdded)
    TEBTopFTIcon:SetHidden(false)
    TEBTopFT:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopFTIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopFTIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopFT:SetAnchor(TOPLEFT, TEBTopFTIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopFT
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildKillCounter
------------------------------------------------------
function TEB:RebuildKillCounter(lastGadget, firstGadgetAdded)
    TEBTopKillsIcon:SetHidden(false)
    TEBTopKills:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopKillsIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopKillsIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopKills:SetAnchor(TOPLEFT, TEBTopKillsIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopKills
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildEnlightenment
------------------------------------------------------
function TEB:RebuildEnlightenment(lastGadget, firstGadgetAdded)
    TEBTopEnlightenmentIcon:SetHidden(false)
    TEBTopEnlightenment:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopEnlightenmentIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopEnlightenmentIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopEnlightenment:SetAnchor(TOPLEFT, TEBTopEnlightenmentIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopEnlightenment
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildMail
------------------------------------------------------
function TEB:RebuildMail(lastGadget, firstGadgetAdded)
    TEBTopMailIcon:SetHidden(false)
    TEBTopMail:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopMailIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopMailIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopMail:SetAnchor(TOPLEFT, TEBTopMailIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopMail
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildET
------------------------------------------------------
function TEB:RebuildET(lastGadget, firstGadgetAdded)
    TEBTopETIcon:SetHidden(false)
    TEBTopET:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopETIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopETIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopET:SetAnchor(TOPLEFT, TEBTopETIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopET
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildFood
------------------------------------------------------
function TEB:RebuildFood(lastGadget, firstGadgetAdded)
    TEBTopFoodIcon:SetHidden(false)
    TEBTopFood:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopFoodIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopFoodIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopFood:SetAnchor(TOPLEFT, TEBTopFoodIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopFood
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- RebuildBountyTimer
------------------------------------------------------
function TEB:RebuildBountyTimer(lastGadget, firstGadgetAdded)
    TEBTopBountyIcon:SetHidden(false)
    TEBTopBounty:SetHidden(false)
    if not firstGadgetAdded then
        TEBTopBountyIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 0, 0) 
        firstGadgetAdded = true
    else
        TEBTopBountyIcon:SetAnchor(TOPLEFT, lastGadget, TOPRIGHT, 20, 0) 
    end
    TEBTopBounty:SetAnchor(TOPLEFT, TEBTopBountyIcon, TOPRIGHT, 0, 0) 
    lastGadget = TEBTopBounty
    return lastGadget, firstGadgetAdded
end

------------------------------------------------------
-- UpdateControlsPosition
------------------------------------------------------
function TEB:UpdateControlsPosition()
    
    local controlsWidth = TEBTopEndingAnchor:GetLeft() - TEBTopInfoAnchor:GetLeft()
    local controlsWidthHalf = controlsWidth / 2
    local newX = ( screenWidth / 2 ) - controlsWidthHalf
    if controlsPosition == "left" then
        newX = 20
    end
    if controlsPosition == "right" then
        newX = screenWidth - controlsWidth - 20
    end
    TEBTopInfoAnchor:SetAnchor(TOPLEFT, TEBTop, TOPLEFT, newX, newY)    
end

------------------------------------------------------
-- ResizeBar
------------------------------------------------------
function TEB.ResizeBar()
    local fontPath = "EsoUI/Common/Fonts/"..font..".otf"
    local fontSize = 18 * (scale / 100)
    local fontOutline = "shadow"
    local barHeight = 22 * (scale / 100)
    for k, v in pairs(gadgetReference) do
        gadgetLabel = gadgetReference[k][2]
        gadgetIcon = gadgetReference[k][1] 
        gadgetLabel:SetFont(fontPath .. "|" .. fontSize .. "|" ..  fontOutline)
        gadgetIcon:SetScale(scale/100)
    end    
    TEBTop:SetHeight(barHeight)
    if (barWidth == "dynamic") then
        barWidth = "screen width"
        TEB:SetBarWidth()
        barWidth = "dynamic"
        TEB:SetBarWidth()
    end
    
--    local barWidth = (100 / scale) * screenWidth
--    local barScale = (scale / 100)
--    TEBTop:SetScale(barScale)
    --TEBTop:SetWidth(barWidth)
--    TEBTopCombatBG:SetWidth(barWidth)
end

------------------------------------------------------
-- SetBarPosition
------------------------------------------------------
function TEB:SetBarWidth()
    if (barWidth == "screen width") then
        TEBTopBG:SetAnchor(TOPLEFT, TEBTop, TOPLEFT, -5, -7)
        TEBTopBG:SetAnchor(BOTTOMRIGHT, TEBTop, BOTTOMRIGHT, 5, 7)
        TEBTopCombatBG:SetAnchor(TOPLEFT, TEBTop, TOPLEFT, -5, -7)
        TEBTopCombatBG:SetAnchor(BOTTOMRIGHT, TEBTop, BOTTOMRIGHT, 5, 7)  
    else 
        TEBTopBG:SetAnchor(TOPLEFT, TEBTopInfoAnchor, TOPLEFT, -20, -7)
        TEBTopBG:SetAnchor(BOTTOMRIGHT, TEBTopEndingAnchor, TOPRIGHT, 20, TEBTop:GetHeight()+7)
        TEBTopCombatBG:SetAnchor(TOPLEFT, TEBTopInfoAnchor, TOPLEFT, -20, -7)
        TEBTopCombatBG:SetAnchor(BOTTOMRIGHT, TEBTopEndingAnchor, TOPRIGHT, 20, TEBTop:GetHeight()+7)
    end
end

------------------------------------------------------
-- SetBarPosition
------------------------------------------------------
function TEB:SetBarPosition()
    
	ZO_CompassFrame:ClearAnchors()
    ZO_TargetUnitFramereticleover:ClearAnchors()
    if bumpCompass then
	    if barPosition == "top" then
		    ZO_CompassFrame:SetAnchor( TOP, GuiRoot, TOP, 0, originalCompassTop + 24 + barY)
		    ZO_TargetUnitFramereticleover:SetAnchor( TOP, GuiRoot, TOP, 0, originalTargetUnitFrameTop + 24 + barY)
	    else
    		ZO_CompassFrame:SetAnchor( TOP, GuiRoot, TOP, 0, originalCompassTop)
		    ZO_TargetUnitFramereticleover:SetAnchor( TOP, GuiRoot, TOP, 0, originalTargetUnitFrameTop)
    
        end
    end

    if bumpActionBar then
        ZO_ActionBar1:ClearAnchors()
    end
	
	local RootWidth	= GuiRoot:GetWidth()
	
	local bottomBump = screenHeight - barY 
	
    if bumpActionBar then
        if barPosition == "bottom" then
            ZO_ActionBar1:SetAnchor( TOP, GuiRoot, TOP, 0, originalActionBarTop - 6 - bottomBump )
            ZO_PlayerAttributeHealth:SetAnchor( TOP, GuiRoot, TOP, 0, originalHealthTop - 6 - bottomBump )
            ZO_PlayerAttributeMagicka:SetAnchor( TOPRIGHT, GuiRoot, TOPRIGHT, ZO_PlayerAttributeMagicka:GetRight() - RootWidth, originalMagickaTop - 6 - bottomBump)
            ZO_PlayerAttributeStamina:SetAnchor( TOPLEFT, GuiRoot, TOPLEFT, ZO_PlayerAttributeStamina:GetLeft(), originalStaminaTop - 6 - bottomBump)
            ZO_PlayerAttributeMountStamina:SetAnchor(TOPLEFT, ZO_PlayerAttributeStamina, BOTTOMLEFT, 0, 0)
            ZO_HUDInfamyMeter:SetAnchor( TOPLEFT, GuiRoot, TOPLEFT, ZO_HUDInfamyMeter:GetLeft(), originalBountyTop - 46 - bottomBump )
        else
            ZO_ActionBar1:SetAnchor( TOP, GuiRoot, TOP, 0, originalActionBarTop)
            ZO_PlayerAttributeHealth:SetAnchor( TOP, GuiRoot, TOP, 0, originalHealthTop)
            ZO_PlayerAttributeMagicka:SetAnchor( TOPRIGHT, GuiRoot, TOPRIGHT, ZO_PlayerAttributeMagicka:GetRight() - RootWidth, originalMagickaTop)
            ZO_PlayerAttributeStamina:SetAnchor( TOPLEFT, GuiRoot, TOPLEFT, ZO_PlayerAttributeStamina:GetLeft(), originalStaminaTop)
            ZO_PlayerAttributeMountStamina:SetAnchor(TOPLEFT, ZO_PlayerAttributeStamina, BOTTOMLEFT, 0, 0)
            ZO_HUDInfamyMeter:SetAnchor( TOPLEFT, GuiRoot, TOPLEFT, ZO_HUDInfamyMeter:GetLeft(), originalBountyTop )
        end    
    end
end 


function TEB.StopMovingBar()
    barY = TEBTop:GetTop()
    TEB.savedVariables.barY = barY
    if barY < 72 then barPosition = "top" end
    if barY > screenHeight - 144 then barPosition = "bottom" end
    if barY >= 72 and barY <= screenHeight - 144 then barPosition = "middle" end
    TEB.savedVariables.barPosition = barPosition
    TEB:SetBarPosition()
end

function TEB.AddPulseItem(itemName)
    gadgetReference[itemName][6] = true
    table.insert(pulseList, itemName)
end

function TEB.RemovePulseItem(itemName)
    gadgetReference[itemName][6] = false
    for i=1, #pulseList do
        if pulseList[i] == itemName then
            table.remove(pulseList, i)
        end
    end
    gadgetReference[itemName][1]:SetAlpha(1)
    gadgetReference[itemName][2]:SetAlpha(1)
end

function TEB.KeyLockUnlockBar()
    TEB.LockUnlockBar(not barLocked)
end

function TEB.KeyLockUnlockGadgets()
    TEB.LockUnlockGadgets(not gadgetsLocked)
end

function TEB.LockUnlockBar(newValue)
    TEB.savedVariables.barLocked = newValue
    barLocked = newValue
    TEBTop:SetMovable(not newValue)
    if lockMessage then
        if newValue then
            d("|c2A8FEEThe Elder Bar is now |cFFFFFFLOCKED.")
        else
            d("|c2A8FEEThe Elder Bar is now |cFFFFFFUNLOCKED.")
        end
    end
end

function TEB.LockUnlockGadgets(newValue)
    TEB.savedVariables.gadgetsLocked = newValue
    gadgetsLocked = newValue
    for k,v in pairs(gadgetReference) do
        gadgetReference[k][1]:SetMovable(not newValue)
    end
    TEB:RebuildBar()
    if lockMessage then
        if newValue then
            d("|c2A8FEEThe Elder Bar gadgets are now |cFFFFFFLOCKED.")
        else
            d("|c2A8FEEThe Elder Bar gadgets are now |cFFFFFFUNLOCKED.")
        end
    end
end

function TEB.GetNumberGadgets()
    local lastItem = 0
    for i=1, #defaultGadgets do
        if gadgets[i] == "(None)" then
            lastItem = i
            break
        end
    end
    return lastItem
end

function TEB.UpdateGadgetList(gadgetName, whichBar)
    if whichBar == "Off" then
        for i=1, #defaultGadgets do
            if gadgets[i] == gadgetName then
               gadgets[i] = "(None)"
               TEB.savedVariables.gadgets[i] = "(None)"
            end              
            if gadgets_pvp[i] == gadgetName then
               gadgets_pvp[i] = "(None)"
               TEB.savedVariables.gadgets_pvp[i] = "(None)"
            end              
        end
    end
    if whichBar == "PvE Bar" then
        local alreadyOnPVE = false
        for i=1, #defaultGadgets do
            if gadgets[i] == gadgetName then alreadyOnPVE = true end
            if gadgets_pvp[i] == gadgetName then
               gadgets_pvp[i] = "(None)"
               TEB.savedVariables.gadgets_pvp[i] = "(None)"
            end                
        end
        if not alreadyOnPVE then
            gadgets[TEB.GetNumberGadgets()+1] = gadgetName
            TEB.savedVariables.gadgets[TEB.GetNumberGadgets()+1] = gadgetName
        end               
    end
    if whichBar == "PvP Bar" then
        local alreadyOnPVP = false
        for i=1, #defaultGadgets do
            if gadgets_pvp[i] == gadgetName then alreadyOnPVP = true end
            if gadgets[i] == gadgetName then
               gadgets[i] = "(None)"
               TEB.savedVariables.gadgets[i] = "(None)"
            end                
        end
        if not alreadyOnPVP then
            gadgets_pvp[TEB.GetNumberGadgets()+1] = gadgetName
            TEB.savedVariables.gadgets_pvp[TEB.GetNumberGadgets()+1] = gadgetName
        end               
    end
    if whichBar == "Both Bars" then
        local alreadyOnPVE = false
        local alreadyOnPVP = false
        for i=1, #defaultGadgets do
            if gadgets_pvp[i] == gadgetName then alreadyOnPVP = true end
            if gadgets[i] == gadgetName then alreadyOnPVE = true end               
        end
        if not alreadyOnPVP then
            gadgets_pvp[TEB.GetNumberGadgets()+1] = gadgetName
            TEB.savedVariables.gadgets_pvp[TEB.GetNumberGadgets()+1] = gadgetName
        end               
        if not alreadyOnPVE then
            gadgets[TEB.GetNumberGadgets()+1] = gadgetName
            TEB.savedVariables.gadgets[TEB.GetNumberGadgets()+1] = gadgetName
        end               
    end
    
    TEB:RebuildBar()
end

function TEB.ConvertGadgetSettings()
    gadgetSettings = {}
    for i=1, #defaultGadgets do
        local gadgetName = defaultGadgets[i]
        gadgetSettings[gadgetName] = "Off"
    end

    for i=1, #defaultGadgets do    
        for k,v in pairs(gadgetReference) do
            if gadgets[i] == k then gadgetSettings[k] = "PvE Bar" end
        end
    end
    
    for i=1, #defaultGadgets do
        for k,v in pairs(gadgetReference) do
            if gadgets_pvp[i] == k then
                if gadgetSettings[k] == "PvE Bar" then
                    gadgetSettings[k] = "Both Bars"
                else
                    gadgetSettings[k] = "PvP Bar"
                end
            end
        end
    end            
end

function TEB.StartMovingGadget(self)
    local gadgetTop = self:GetTop()
    local gadgetLeft = self:GetLeft()
    movingGadget = self
    ignoreGadget = self:GetName()
    local findGadget = iconReference[ignoreGadget]
    if pvpMode then
        gadgetList = gadgets_pvp
    else
        gadgetList = gadgets
    end    
    for i=1, #defaultGadgets do
        if gadgetList[i] == findGadget then
            movingGadgetName = gadgetList[i]            
            gadgetList[i] = "(None)"
        end
    end
    TEB:RebuildBar()
    self:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, gadgetLeft, gadgetTop)
end

function TEB.StopMovingGadget(self)
    local foundGadget = ""
    local testGadgetObject = ""
    local targetGadgetNumber = 0
    if pvpMode then
        gadgetList = gadgets_pvp
    else
        gadgetList = gadgets
    end     
    for i=1, #defaultGadgets do
        for k,v in pairs(gadgetReference) do
            if gadgetList[i] == k then testGadgetObject = gadgetReference[k][2] end
        end
        
        if gadgetList[i] ~= "(None)" then
            if movingGadget:GetLeft() <= testGadgetObject:GetLeft() and targetGadgetNumber == 0 then
                local goodTarget = true
                if testGadgetObject:IsHidden() then goodTarget = false end
                if goodTarget then
                    targetGadgetNumber = i
                end
            end
        end
    end
    if targetGadgetNumber == 0 then targetGadgetNumber = TEB.GetNumberGadgets()+1 end
    
    for i=#defaultGadgets-1, targetGadgetNumber, -1 do
        if pvpMode then
            gadgets_pvp[i+1] = gadgets_pvp[i]
        else
            gadgets[i+1] = gadgets[i]
        end
    end

    if pvpMode then
        gadgets_pvp[targetGadgetNumber] = movingGadgetName
    else
        gadgets[targetGadgetNumber] = movingGadgetName
    end
    ignoreGadget = ""
    TEB:RebuildBar()
end

--====================================================
-- TOOLTIPS
--====================================================
------------------------------------------------------
-- Name
------------------------------------------------------
function TEB.ShowToolTipNameLevel(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = "|cffffff"..playerName.."|ccccccc\n\n"
    local toolTipRight = "\n\n"

    toolTipLeft = toolTipLeft..playerClassName.." Level\n"
    toolTipLeft = toolTipLeft.."Champion Points\n\n"
    toolTipRight = toolTipRight .. string.format(lvl).."\n"
    toolTipRight = toolTipRight .. string.format(cp).."\n\n"

    toolTipLeft = toolTipLeft .. "Unspent Warrior Points\nUnspent Thief Points\nUnspent Mage Points\nTotal Unspent Points"
    toolTipRight = toolTipRight .. "|CD6660C|t18:18:esoui/art/champion/champion_points_health_icon.dds|t"..string.format(unspentWarrior).."\n"
    toolTipRight = toolTipRight .."|C51AB0D|t18:18:esoui/art/champion/champion_points_stamina_icon.dds|t"..string.format(unspentThief).."\n"
    toolTipRight = toolTipRight .."|C1970C9|t18:18:esoui/art/champion/champion_points_magicka_icon.dds|t"..string.format(unspentMage).."\n"
    toolTipRight = toolTipRight .."|CFFFFAA|t18:18:TEB/Images/cp_color.dds|t"..string.format(unspentTotal).."|r"

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end

end

------------------------------------------------------
-- Bag
------------------------------------------------------
function TEB.ShowToolTipMundus(self)
    TEBTooltip:SetHidden(false)
       
    FormatTooltip("Mundus Stone.\n\n|cffffff"..mundus, "")
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Bag
------------------------------------------------------
function TEB.ShowToolTipBag(self)
    TEBTooltip:SetHidden(false)
       
    FormatTooltip("Bag space used / maximum size:\n|cffffff"..bagInfo, "")
    if bag_DisplayPreference == "used%" then    
        FormatTooltip("Percentage of bag space used:\n|cffffff"..bagInfo, "")
    end
    if bag_DisplayPreference == "slots free/total slots" then    
        FormatTooltip("Bag space free / maximum size:\n|cffffff"..bagInfo, "")
    end
    if bag_DisplayPreference == "slots free" then    
        FormatTooltip("Bag space free:\n|cffffff"..bagInfo, "")
    end
    if bag_DisplayPreference == "free%" then    
        FormatTooltip("Percentage of bag space free:\n|cffffff"..bagInfo, "")
    end
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Vampirism
------------------------------------------------------
function TEB.ShowToolTipVampirism(self)
    TEBTooltip:SetHidden(false)
       
    FormatTooltip("Stage\nTime until stage expires", vampTooltipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Bank
------------------------------------------------------
function TEB.ShowToolTipBank(self)
    TEBTooltip:SetHidden(false)
         
    FormatTooltip("Bank space used / maximum size.", "")
    if bank_DisplayPreference == "used%" then    
        FormatTooltip("Percentage of bank space used.", "")
    end
    if bank_DisplayPreference == "slots free/total slots" then    
        FormatTooltip("Bank space free / maximum size.", "")
    end
    if bank_DisplayPreference == "slots free" then    
        FormatTooltip("Bank space free.", "")
    end
    if bank_DisplayPreference == "free%" then    
        FormatTooltip("Percentage of bank space free.", "")
    end
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Mail
------------------------------------------------------
function TEB.ShowToolTipMail(self)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = "Unread Mail"
    local toolTipRight = unread_mail
    
    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Food Buff
------------------------------------------------------
function TEB.ShowToolTipFood(self)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = "Food/Drink Buff Remaining"
    local toolTipRight = food
    
    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Infamy
------------------------------------------------------
function TEB.ShowToolTipInfamy(self)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = "Heat Time Left\nBounty Time Left\nInfamy\nPayoff"

    local toolTipRight = heatTimerText.."\n"..bountyTimerText.."\n"..infamyText.."\n".."|t18:18:TEB/Images/gold_color.dds|t"..string.format(bountyPayoff)
    
    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Latency
------------------------------------------------------
function TEB.ShowToolTipLatency(self)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = "Current network latency"
    local toolTipRight = latency.."ms"
    
    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Location
------------------------------------------------------
function TEB.ShowToolTipLocation(self)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = ""
    if location_DisplayPreference == "(x, y) Zone Name" then
        toolTipLeft = toolTipLeft .. "(Coordinates) Zone Name.\n\n"
    end
    if location_DisplayPreference == "Zone Name (x, y)" then
        toolTipLeft = toolTipLeft .. "Zone Name (Coordinates).\n\n"
    end
    if location_DisplayPreference == "Zone Name" then
        toolTipLeft = toolTipLeft .. "Current zone Name.\n\n"
    end
    if location_DisplayPreference == "x, y" then
        toolTipLeft = toolTipLeft .. "Current coordinates.\n\n"
    end
    toolTipLeft = toolTipLeft .. zoneName.."\n".."("..coordinates..")"    
    local toolTipRight = ""
    
    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Thief's Tools
------------------------------------------------------
function TEB.ShowToolTipTT(self)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = "Thief's Tools.\n\n"
    local toolTipRight = "\n\n"
    
    toolTipLeft = toolTipLeft .. "Lockpicks\n"
    toolTipRight = toolTipRight .. string.format(lockpicks).."\n"
    toolTipLeft = toolTipLeft .. "Stolen Treasures\n"
    toolTipLeft = toolTipLeft .. "Other Stolen Items\n\n"
    toolTipRight = toolTipRight .. string.format(treasures).."\n"
    toolTipRight = toolTipRight .. string.format(not_treasures).."\n\n"
    toolTipLeft = toolTipLeft .. "Fence Interactions\n"
    toolTipRight = toolTipRight .. string.format(sellsUsed).."/"..string.format(totalSells).."\n"
    toolTipLeft = toolTipLeft .. "Launder Interactions"
    toolTipRight = toolTipRight .. string.format(laundersUsed).."/"..string.format(totalLaunders)
    
    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Gold
------------------------------------------------------
function TEB.ShowToolTipGold(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n"

    if gold_DisplayPreference == "gold on character" then
        toolTipLeft =  "Gold on your character.\n"
    end
    if gold_DisplayPreference == "gold on character/gold in bank" then
        toolTipLeft = "Gold on your character/gold in the bank.\n\n"
    end
    if gold_DisplayPreference == "gold on character (gold in bank)" then
        toolTipLeft = "Gold on your character (gold in the bank).\n\n"
    end
    if gold_DisplayPreference == "character+bank gold" then
        toolTipLeft = "Gold on your character + gold in the bank.\n\n"
    end
    if gold_DisplayPreference == "tracked gold" then
        toolTipLeft =  "Gold on all tracked characters.\n"
    end   
    if gold_DisplayPreference == "tracked+bank gold" then
        toolTipLeft =  "Gold on all tracked characters + bank.\n"
    end    
    
    local tempKeys = {}
    for k in pairs(gold_Tracker) do table.insert(tempKeys, k) end
    table.sort(tempKeys)
    
    local totalGold = 0
    
    for _, k in ipairs(tempKeys) do
        local rowColor = "|cdddddd"
        v = gold_Tracker[k] 
        if v[1] and k ~= "LocalPlayer" then
            totalGold = totalGold + v[2]
            local goldAmount
            if thousandsSeparator then
                goldAmount = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(v[2]))         
            else
                goldAmount = string.format(v[2])
            end            
            if k == playerName then rowColor = "|cffffff" end
            toolTipLeft = toolTipLeft .. "\n"..rowColor..k
            toolTipRight = toolTipRight .. "\n"..rowColor..goldAmount
        end
    end
        
    toolTipLeft = toolTipLeft .. "|cdddddd\n\nGold in bank\n______________________\n\n"
    toolTipLeft = toolTipLeft .. "Total gold"
    toolTipRight = toolTipRight .. "\n\n"..string.format(goldBank).."\n______\n\n"
    totalGold = totalGold + goldBankUnformatted
    if thousandsSeparator then
        totalGold = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(totalGold))         
    else
        totalGold = string.format(totalGold)
    end            
    toolTipRight = toolTipRight .. string.format(totalGold)

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- FPS
------------------------------------------------------
function TEB.ShowToolTipFPS(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""

    toolTipLeft =  "Current frames per second.\n\n"

    toolTipLeft = toolTipLeft .. "Lowest FPS this session\n"
    toolTipLeft = toolTipLeft .. "Highest FPS this session"
    
    toolTipRight = "\n\n"
    toolTipRight = toolTipRight .. string.format(lowestFPS).."\n"
    toolTipRight = toolTipRight .. string.format(highestFPS)

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Currencies
------------------------------------------------------
function TEB.ShowToolTipCurrencies(self, currentCurrency)
    TEBTooltip:SetHidden(false)
    
    local toolTipLeft = ""
    toolTipRight = "\n\n" 
        
    if currentCurrency == "ap" then
        if ap_DisplayPreference == "Total Points" then
            toolTipLeft = toolTipLeft .. "Total Alliance Points.\n\n"
        end
        if ap_DisplayPreference == "Session Points" then
            toolTipLeft = toolTipLeft .. "Session Alliance Points.\n\n"
        end
        if ap_DisplayPreference == "Points Per Hour" then
            toolTipLeft = toolTipLeft .. "Alliance Points/hour.\n\n"
        end
        if ap_DisplayPreference == "Total Points/Points Per Hour" then
            toolTipLeft = toolTipLeft .. "Total Alliance Points/Points hr.\n\n"
        end
        if ap_DisplayPreference == "Session Points/Points Per Hour" then
            toolTipLeft = toolTipLeft .. "Session Points/Points hr.\n\n"
        end
        if ap_DisplayPreference == "Total Points/Session Points" then
            toolTipLeft = toolTipLeft .. "Total Alliance Points/Session Points.\n\n"
        end
        if ap_DisplayPreference == "Total Points/Session Points (Points Per Hour)" then
            toolTipLeft = toolTipLeft .. "Total Points/Session Points (Points/hr).\n\n"
        end
        if ap_DisplayPreference == "Total Points/Session Points/Points Per Hour" then
            toolTipLeft = toolTipLeft .. "Total Points/Session Points/Points hr.\n\n"
        end
            toolTipLeft = toolTipLeft .. "Points gained this session\n"
            toolTipLeft = toolTipLeft .. "Points gained per hour\n"

        toolTipRight = toolTipRight .. ap_Session.."\n"
        toolTipRight = toolTipRight .. ap_Hour.."\n\n"
    end


    
    if currentCurrency == "telvar" then toolTipLeft = "Tel Var Stones in your possession.\n" end
    if currentCurrency == "writs" then toolTipLeft = "Writ Vouchers earned.\n" end
    if currentCurrency == "tc" then toolTipLeft = "Transmute Crystals in your possession.\n" end
    if currentCurrency == "et" then toolTipLeft = "Event Tickets in your possession.\n" end
    toolTipLeft = toolTipLeft .. "\n"

    local telvarColor = "|ccccccc"
    local tcColor = "|ccccccc"
    local writsColor = "|ccccccc"
    local apColor = "|ccccccc"
    local etColor = "|ccccccc"
    if currentCurrency == "telvar" then telvarColor = "|cffffff" end
    if currentCurrency == "ap" then apColor = "|cffffff" end
    if currentCurrency == "writs" then writsColor = "|cffffff" end
    if currentCurrency == "tc" then tcColor = "|cffffff" end
    if currentCurrency == "et" then etColor = "|cffffff" end
    
    toolTipLeft = toolTipLeft .. apColor .. "Alliance Points\n"
    toolTipLeft = toolTipLeft .. etColor .. "Event Tickets\n"
    toolTipLeft = toolTipLeft .. telvarColor .. "Telvar Stones\n"
    toolTipLeft = toolTipLeft .. tcColor .. "Transmute Crystals\n"
    toolTipLeft = toolTipLeft .. writsColor .. "Writ Vouchers"
       
    toolTipRight = toolTipRight .. "|t18:18:TEB/Images/ap_color.dds|t"..apColor..string.format(ap).."\n"
    toolTipRight = toolTipRight .. "|t18:18:TEB/Images/eventtickets_color.dds|t"..etColor..string.format(eventtickets).."\n"
    toolTipRight = toolTipRight .. telvarColor .."|t18:18:TEB/Images/telvar_color.dds|t"..string.format(telvar).."\n"
    toolTipRight = toolTipRight .. tcColor .."|t18:18:TEB/Images/transmute_color.dds|t"..string.format(crystal).."\n"
    toolTipRight = toolTipRight .. writsColor.."|t18:18:TEB/Images/writs_color.dds|t"..string.format(writs)

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Mount Timer
------------------------------------------------------
function TEB.ShowToolTipM(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "|CFFFFFF\n"

    toolTipLeft = toolTipLeft .. "|c2A8FEECurrent Training:\n"
    toolTipLeft = toolTipLeft .. "|CEEEEEESpeed\n"
    toolTipLeft = toolTipLeft .. "Stamina\n"
    toolTipLeft = toolTipLeft .. "Carry Capacity\n\n"
    
    carry, carryMax, stamina, staminaBonus, speed, speedMax = GetRidingStats() 
    
    toolTipRight = toolTipRight .. string.format(speed).."/60\n"
    toolTipRight = toolTipRight .. string.format(stamina).."/60\n"
    toolTipRight = toolTipRight .. string.format(carry).."/60\n\n"

    toolTipLeft = toolTipLeft .. "|c2A8FEEMount Training Tracker:"
    
    local tempKeys = {}
    for k in pairs(mount_Tracker) do table.insert(tempKeys, k) end
    table.sort(tempKeys)
    
    for _, k in ipairs(tempKeys) do
        v = mount_Tracker[k] 
        if v[1] and v[2] ~= -1 and k ~= "LocalPlayer" then
            local timeLeft = v[2] - os.time() 
            local rowColor = "|ceeeeee"
            if k == playerName then rowColor = "|cffffff" end
            if timeLeft <=0 then
                timeLeft="TRAIN!"
                rowColor = "|c00ee00"               
                if k == playerName then rowColor = "|c22ff22" end
            else
                timeLeft = TEB.ConvertSeconds(mount_DisplayPreference, timeLeft)
            end
            toolTipLeft = toolTipLeft .. "\n"..rowColor..k
            toolTipRight = toolTipRight .. "\n"..rowColor..timeLeft
        end
    end


    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- Memory
------------------------------------------------------
function TEB.ShowToolTipMemory(self)
    TEBTooltip:SetHidden(false)

    FormatTooltip("Memory usage of all loaded addons.", "")
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- XP
------------------------------------------------------
function TEB.ShowToolTipXP(self)
    TEBTooltip:SetHidden(false)

    local levelThing = "level"    
    if lvl == 50 then levelThing = "champion point" end

    if experience_DisplayPreference == "% towards next level/CP" then
        FormatTooltip("Experience towards next "..levelThing..":\n|cffffff"..gxpString, "")
    end
    if experience_DisplayPreference == "% needed for next level/CP" then
        FormatTooltip("Experience needed for next "..levelThing..":\n|cffffff"..gxpString, "")
    end
    if experience_DisplayPreference == "current XP" then
        FormatTooltip("Current experience:\n|cffffff"..gxpString, "")
    end
    if experience_DisplayPreference == "needed XP" then
        FormatTooltip("Needed experience for next "..levelThing..":\n|cffffff"..gxpString, "")
    end
    if experience_DisplayPreference == "current XP/total needed" then
        FormatTooltip("Current experience/total experience needed:\n|cffffff"..gxpString, "")
    end
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end
end

-- Clock
------------------------------------------------------
function TEB.ShowToolTipClock(self)
    TEBTooltip:SetHidden(false)

    FormatTooltip("Current local time:\n|cffffff"..currentTime.."\n\n|cccccccIngame Time:\n|cffffff"..ingameTime, "")
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end
-- Soul Gems
------------------------------------------------------
function TEB.ShowToolTipSoulGems(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""

    if soulgems_DisplayPreference == "total filled/empty" then
        toolTipLeft = "Total filled / empty soul gems."
    end
    if soulgems_DisplayPreference == "total filled (crown)/empty" then
        toolTipLeft = "Total filled (crown filled) / empty soul gems."
    end
    if soulgems_DisplayPreference == "total filled (empty)" then
        toolTipLeft = "Total filled (empty) soul gems."
    end
    if soulgems_DisplayPreference == "regular filled/crown/empty" then
        toolTipLeft = "Regular filled / crown / empty soul gems."
    end            
    if soulgems_DisplayPreference == "total filled" then
        toolTipLeft = "Total filled soul gems."
    end
    if soulgems_DisplayPreference == "regular filled" then
        toolTipLeft = "Regular filled soul gems."
    end

    toolTipLeft = toolTipLeft .. "\n"..soulGemsToolTipLeft
    
    toolTipRight = "\n"..soulGemsToolTipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Sky Shards
------------------------------------------------------
function TEB.ShowToolTipSkyShards(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""

    if skyshards_DisplayPreference == "collected/unspent points" then
        toolTipLeft = "Collected skyshards / unspent skill points.\n\n"
    end
    if skyshards_DisplayPreference == "collected" then
        toolTipLeft = "Collected skyshards.\n\n"
    end
    if skyshards_DisplayPreference == "collected/total needed (unspent points)" then
        toolTipLeft = "Collected skyshards/total needed for skill point (unspent skill points).\n\n"
    end
    if skyshards_DisplayPreference == "needed/unspent points" then
        toolTipLeft = "Needed skyshards / unspent skill points.\n\n"
    end
    if skyshards_DisplayPreference == "needed" then
        toolTipLeft = "Needed skyshards.\n\n"
    end
    
    toolTipLeft = toolTipLeft .. "Collected Sky Shards\nUnspent Skill Points"

    toolTipRight = "\n\n"..string.format(skyShards).."/3\n"..string.format(availablePoints)

    FormatTooltip(toolTipLeft, toolTipRight)   
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end     
end

-- Durability
------------------------------------------------------
function TEB.ShowToolTipDurability(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n\n"

    toolTipLeft =  "Armor durability.\n"..durabilityTooltipLeft
    toolTipRight = "\n"..durabilityTooltipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Kill Counter
------------------------------------------------------
function TEB.ShowToolTipKills(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = "Kill Counter.\n\n"
    local toolTipRight = "\n\n"

    toolTipLeft = toolTipLeft .. "Killing Blows\nAssists\nDeaths\n\nKill/Death Ratio"
    toolTipRight = toolTipRight .. string.format(killingBlows).."\n"..string.format(kills).."\n"..string.format(deaths).."\n\n"..killRatio

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Enlightenment
------------------------------------------------------
function TEB.ShowToolTipEnlightenment(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = "Current enlightenment:\n|cffffff"..enlightenment
    local toolTipRight = ""

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Fast Travel
------------------------------------------------------
function TEB.ShowToolTipFT(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = ""

    if ft_DisplayPreference == "time left" then
        toolTipLeft =  "Recall time left until cheapest.\n"
    end
    if ft_DisplayPreference == "cost" then
        toolTipLeft =  "Recall current cost.\n"
    end
    if ft_DisplayPreference == "time left/cost" then
        toolTipLeft = "Recall time left until cheapest/cost.\n"
    end

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Weapon Charge
------------------------------------------------------
function TEB.ShowToolTipWC(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n\n"

    toolTipLeft =  wcTooltipLeft
    toolTipRight = wcTooltipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Blacksmith Timer
------------------------------------------------------
function TEB.ShowToolTipBlacksmith(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n\n"

    toolTipLeft = "Time until blacksmithing research is complete.\n"
    toolTipLeft = toolTipLeft .. blackSmithToolTipLeft
    toolTipRight = "\n"..blackSmithToolTipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Jewelry Timer
------------------------------------------------------
function TEB.ShowToolTipJewelry(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n\n"

    toolTipLeft = "Time until jewelry crafting research is complete.\n"
    toolTipLeft = toolTipLeft .. jewelryToolTipLeft
    toolTipRight = "\n"..jewelryToolTipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Woodworking Timer
------------------------------------------------------
function TEB.ShowToolTipWoodworking(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n\n"

    toolTipLeft = "Time until woodworking research is complete.\n"
    toolTipLeft = toolTipLeft .. woodWorkingToolTipLeft
    toolTipRight = "\n"..woodWorkingToolTipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

-- Clothing Timer
------------------------------------------------------
function TEB.ShowToolTipClothing(self)
    TEBTooltip:SetHidden(false)

    local toolTipLeft = ""
    local toolTipRight = "\n\n"

    toolTipLeft = "Time until clothing research is complete.\n"
    toolTipLeft = toolTipLeft .. clothingToolTipLeft
    toolTipRight = "\n"..clothingToolTipRight

    FormatTooltip(toolTipLeft, toolTipRight)
    if self:GetTop() > screenHeight / 2 then
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,-12 - TEBTop:GetHeight() - TEBTooltip:GetHeight())
    else
        TEBTooltip:SetAnchor(TOPLEFT, self, BOTTOMRIGHT, -12,12)
    end    
end

------------------------------------------------------
-- HideTooltip
------------------------------------------------------
function TEB.HideTooltip(self)
    TEBTooltip:SetHidden(true)
    --ClearTooltip(InformationTooltip)
end

------------------------------------------------------
-- playername
------------------------------------------------------
function TEB.playername()
    playerName = TEB.fixname(GetUnitName("player"))
end

------------------------------------------------------
-- memory
------------------------------------------------------
function TEB.memory()
    memory = string.format(math.floor(collectgarbage("count") / 1024 + 0.5)).."MB"
end

------------------------------------------------------
-- enlightenment
------------------------------------------------------
function TEB.enlightenment()
    local enlightenment_amount = 0
    if IsEnlightenedAvailableForCharacter() then
        enlightenment_amount = GetEnlightenedPool()
        if thousandsSeparator then
            enlightenment = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(enlightenment_amount))         
        else
            enlightenment = string.format(enlightenment_amount)
        end
    else
        enlightenment = "--"
    end
    
    if enlightenment_amount > 0 and not enlightenmentVisible then
        if not enlightenmentVisible then
            enlightenmentVisible = true
            TEB:RebuildBar()
        end
    end
    if enlightenment_amount == 0 and enlightenmentVisible then
        if enlightenmentVisible then
            enlightenmentVisible = false
            TEB:RebuildBar()
        end
    end       
    
    
    local enlightenmentColor = "|ccccccc"
    iconColor = "normal"
    if enlightenment_amount < enlightenment_Warning then
        enlightenmentColor = "|cffff00"
        iconColor = "caution"
    end
    if enlightenment_amount < enlightenment_Danger then
        enlightenmentColor = "|cff8000"
        iconColor = "warning"
    end    
    if enlightenment_amount < enlightenment_Danger then
        enlightenmentColor = "|cff0000"
        iconColor = "danger"
    end    

    enlightenment = enlightenmentColor .. enlightenment

    if iconIndicator["Enlightenment"] and iconColor ~= "normal" then
        TEB.SetIcon("Enlightenment", iconColor)
    else
        TEB.SetIcon("Enlightenment", "normal")
    end
    
end


------------------------------------------------------
-- PVP
------------------------------------------------------
function TEB.pvp()
    pvp = IsUnitPvPFlagged("player")
    if pvp ~= pvpMode then
        pvpMode = pvp
        TEB.ShowBar()
        TEB:RebuildBar()
        if pvpMode then
            kills = 0
            killingBlows = 0
            deaths = 0
        end
    end

    killRatio = 0
    if deaths == 0 then
        killRatio = string.format(killingBlows)
    else
        killRatio = string.format(round(killingBlows/deaths, 1))..":1"
    end
    if kc_DisplayPreference == "Assists/Killing Blows/Deaths (Kill Ratio)" then
        killCount = string.format(kills).."/"..string.format(killingBlows).."/"..string.format(deaths).." ("..killRatio..")"
    end
    if kc_DisplayPreference == "Assists/Killing Blows/Deaths" then
        killCount = string.format(kills).."/"..string.format(killingBlows).."/"..string.format(deaths)
    end
    if kc_DisplayPreference == "Killing Blows/Deaths (Kill Ratio)" then
        killCount = string.format(killingBlows).."/"..string.format(deaths).." ("..killRatio..")"
    end
    if kc_DisplayPreference == "Killing Blows/Deaths" then
        killCount = string.format(killingBlows).."/"..string.format(deaths)
    end
    if kc_DisplayPreference == "Kill Ratio" then
        killCount = killRatio
    end
end

------------------------------------------------------
-- recall
------------------------------------------------------
function TEB.recall()
    local remain, duration = GetRecallCooldown()
    cost = GetRecallCost()
    
    if remain > 0 then 
        ftTimerRunning = true
    else
        ftTimerRunning = false
    end
    
    if ftTimerRunning and not ftTimerVisible then
        ftTimerVisible = true
        TEB:RebuildBar()
    end
    if not ftTimerRunning and ftTimerVisible then
        ftTimerVisible = false
        TEB:RebuildBar()
    end       
    
    seconds = math.floor(remain / 1000)
    
    timeLeft = TEB.ConvertSeconds("simple", seconds)   
    if thousandsSeparator then
        cost = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(cost)) 
    else
        cost = string.format(cost)
    end
    
    if timeLeft == "" then timeLeft = "--" end
    
    if ft_DisplayPreference == "time left" then
        ft = timeLeft
    end
    if ft_DisplayPreference == "cost" then
        ft = cost.."g"
    end
    if ft_DisplayPreference == "time left/cost" then
        ft = timeLeft.."/"..cost.."g"
    end
end

------------------------------------------------------
-- balance
------------------------------------------------------
function TEB.balance()
    telvarc = GetCurrencyAmount(CURT_TELVAR_STONES, CURRENCY_LOCATION_CHARACTER)
    telvarb = GetCurrencyAmount(CURT_TELVAR_STONES, CURRENCY_LOCATION_BANK)
    telvar = telvarc + telvarb
    goldCharacter = GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_CHARACTER)
    goldBank = GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_BANK)
    goldTotal = goldCharacter + goldBank
    eventtickets = GetCurrencyAmount(CURT_EVENT_TICKETS, CURRENCY_LOCATION_ACCOUNT)
    maxeventtickets = 12
    goldBankUnformatted = goldBank
    
    if eventtickets > 0 then
        etHasTickets = true
    else
        etHasTickets = false
    end
    
    if thousandsSeparator then
        goldCharacter = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(goldCharacter))
        goldBank = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(goldBank))
        goldTotal = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(goldTotal))
        telvar = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(telvar))
    else
        goldCharacter = string.format(goldCharacter)
        goldBank = string.format(goldBank)
        goldTotal = string.format(goldTotal)        
        telvar = string.format(telvar)        
    end

    local trackedGold = 0
            
    if gold_DisplayPreference == "gold on character" then
        gold = goldCharacter
    end
    if gold_DisplayPreference == "gold on character/gold in bank" then
        gold = goldCharacter.."/".. goldBank
    end
    if gold_DisplayPreference == "gold on character (gold in bank)" then
        gold = goldCharacter.." ("..goldBank..")"
    end
    if gold_DisplayPreference == "character+bank gold" then
        gold = goldTotal
    end
    if gold_DisplayPreference == "tracked gold" or gold_DisplayPreference == "tracked+bank gold" then
        for k, v in pairs(gold_Tracker) do
            if v[1] then
                trackedGold = trackedGold + v[2]
            end
        end   
    end            

    if gold_DisplayPreference == "tracked gold" then
        if thousandsSeparator then     
            gold = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(trackedGold))
        else
            gold = goldBankUnformatted + trackedGold
        end
    end        
    if gold_DisplayPreference == "tracked+bank gold" then
        if thousandsSeparator then     
            gold = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(goldBankUnformatted + trackedGold))
        else
            gold = goldBankUnformatted + trackedGold
        end
    end
    
    ap = GetCurrencyAmount(CURT_ALLIANCE_POINTS, CURRENCY_LOCATION_CHARACTER)
    crystal = GetCurrencyAmount(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
    writs = GetCurrencyAmount(CURT_WRIT_VOUCHERS, CURRENCY_LOCATION_CHARACTER)

    ap_Session = ap - ap_SessionStartPoints
    ap_Hour = 0
    if os.time() - ap_SessionStart > 0 then
        if os.time() - ap_SessionStart < 3600 then
            ap_Hour = math.floor(ap_Session)
        else
            ap_Hour = math.floor(ap_Session / ((os.time() - ap_SessionStart) / 3600))
        end            
    end
    
    if thousandsSeparator then
        ap = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(ap))
        ap_Session = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(ap_Session))
        ap_Hour = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(ap_Hour))
        crystal = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(crystal))
        writs = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(writs))
    else
        ap = string.format(ap) 
        ap_Session = string.format(ap_Session) 
        ap_Hour = string.format(ap_Hour) 
        crystal = string.format(crystal) 
        writs = string.format(writs) 
    end
    
    local etIcon = "normal"
    local etColor = "|ccccccc"
    if eventtickets >= et_Warning then
        etColor = "|cffdf00"
        etIcon = "warning"
    end
    if eventtickets <= et_Danger then
        etColor = "|ccc0000"
        etIcon = "danger"
    end
    TEB.SetIcon("Event Tickets", etIcon)
    
    eventtickets = etColor..string.format(eventtickets)
    if et_DisplayPreference == "tickets/max" then
        eventtickets = eventtickets.."/12"
    end
    
    if ap_DisplayPreference == "Total Points" then
        apString = ap
    end
    if ap_DisplayPreference == "Session Points" then
        apString = ap_Session
    end
    if ap_DisplayPreference == "Points Per Hour" then
        apString = ap_Hour
    end
    if ap_DisplayPreference == "Total Points/Points Per Hour" then
        apString = ap.."/"..ap_Hour
    end
    if ap_DisplayPreference == "Session Points/Points Per Hour" then
        apString = ap_Session.."/"..ap_Hour
    end
    if ap_DisplayPreference == "Total Points/Session Points" then
        apString = ap.."/"..ap_Session
    end
    if ap_DisplayPreference == "Total Points/Session Points (Points Per Hour)" then
        apString = ap.."/"..ap_Session.." ("..ap_Hour..")"
    end
    if ap_DisplayPreference == "Total Points/Session Points/Points Per Hour" then
        apString = ap.."/"..ap_Session.."/"..ap_Hour
    end
    
    lvl = GetUnitLevel("player")
    cp = GetPlayerChampionPointsEarned()
    
    lvlText = ""

	unspentWarrior = GetNumUnspentChampionPoints( 1 )
	unspentMage = GetNumUnspentChampionPoints( 2 )
    unspentThief = GetNumUnspentChampionPoints( 3 )
    unspentTotal = unspentWarrior + unspentMage + unspentThief
	local hasUnspentPoints = false
	if unspentTotal > 0 then
    	hasUnspentPoints = true
    end
    
    local showUnspent = false
    
    if lvl < 50 then
        if string.match(level_DisplayPreferenceNotMax, "Character Level") then
            lvlText = string.format(lvl)
        end
        if string.match(level_DisplayPreferenceNotMax, "Champion Points") then
            lvlText = string.format(cp)
        end
        if string.match(level_DisplayPreferenceNotMax, "Character Level%/Champion Points") then
            lvlText = string.format(lvl).."/"..string.format(cp)
        end
        if string.match(level_DisplayPreferenceNotMax, "%(Unspent Points%)") and ((hasUnspentPoints and level_Dynamic) or not level_Dynamic) then
            showUnspent = true
        end
    end          
    if lvl == 50 then
        if string.match(level_DisplayPreferenceMax, "Character Level") then
            lvlText = string.format(lvl)
        end
        if string.match(level_DisplayPreferenceMax, "Champion Points") then
            lvlText = string.format(cp)
        end
        if string.match(level_DisplayPreferenceMax, "Character Level%/Champion Points") then
            lvlText = string.format(lvl).."/"..string.format(cp)
        end
        if string.match(level_DisplayPreferenceMax, "%(Unspent Points%)") and ((hasUnspentPoints and level_Dynamic) or not level_Dynamic) then
            showUnspent = true
        end        
    end
    
    if showUnspent then
        lvlText = lvlText .. " ("
        if unspentWarrior > 0 or not level_Dynamic then
            lvlText = lvlText .. "|CD6660C|t18:18:esoui/art/champion/champion_points_health_icon.dds|t"..string.format(unspentWarrior)
        end
        if unspentThief > 0 or not level_Dynamic then
            lvlText = lvlText .."|C51AB0D|t18:18:esoui/art/champion/champion_points_stamina_icon.dds|t"..string.format(unspentThief)
        end
        if unspentMage > 0 or not level_Dynamic then
            lvlText = lvlText .."|C1970C9|t18:18:esoui/art/champion/champion_points_magicka_icon.dds|t"..string.format(unspentMage)
        end
        lvlText = lvlText .."|CCCCCCC)"
    end
    
end

------------------------------------------------------
-- mounttimer
------------------------------------------------------    
function TEB.mounttimer()
    mountTimeLeft = GetTimeUntilCanBeTrained() / 1000
    if STABLE_MANAGER:IsRidingSkillMaxedOut() then
        mountlbltxt = "Maxed" 
        mountTimerNotMaxed = false
    else
        mountTimerNotMaxed = true
        if mountTimeLeft == 0 then
            mountlbltxt = "TRAIN!"
        else    
            mountlbltxt = TEB.ConvertSeconds(mount_DisplayPreference, mountTimeLeft)
        end
    end
    
    if mountlbltxt == "Maxed" and not mountTimerVisible then
        mountTimerVisible = true
        TEB:RebuildBar()
    end
    if mountlbltxt ~= "Maxed" and mountTimerVisible then
        mountTimerVisible = false
        TEB:RebuildBar()
    end     
    
    if mountlbltxt == "TRAIN!" then
        if mount_Good then mountlbltxt = "|c00e900"..mountlbltxt end
        if mount_Good and iconIndicator["Mount Timer"] then
            TEB.SetIcon("Mount Timer", "good")
        end
    else
        if addonInitialized then
            if gadgetReference["Mount Timer"][6] then 
                TEB.RemovePulseItem("Mount Timer")
            end           
        end
        if mount_Good and iconIndicator["Mount Timer"] then
            TEB.SetIcon("Mount Timer", "normal")
        end
    end
end

------------------------------------------------------
-- currenttime
------------------------------------------------------    
function TEB.currenttime()
	local localTime = GetTimeString()
	local hh, mm, ss = localTime:match("([^:]+):([^:]+):([^:]+)")
    ampm = ""
    
    local igSecondsPerDay = 20955
    local rlTimeStamp = GetTimeStamp()
    local inGameTimeSeconds = (rlTimeStamp % igSecondsPerDay) * 86400 / igSecondsPerDay
    local inGameTimeString = FormatTimeSeconds(inGameTimeSeconds, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR, TIME_FORMAT_DIRECTION_NONE)
    if not clock_TwentyFourHourClock then
        local ighh, igmm = inGameTimeString:match("^(.+):(.+)$")
    	ighh = ighh + 0
    	if ighh < 12 then
            igampm = " AM"
        else
            igampm = " PM"
        end
        if ighh > 12 then
            ighh = ighh - 12
        end
        if ighh == 0 then
            ighh = 12
        end
        ingameTime = ighh..":"..igmm..igampm
    else
        ingameTime = inGameTimeString
    end
  	
	if not clock_TwentyFourHourClock then
    	hh = hh + 0
    	if hh < 12 then
            ampm = " AM"
        else
            ampm = " PM"
        end
        if hh > 12 then
            hh = hh - 12
        end
        if hh == 0 then
            hh = 12
        end
    end
    currentTime = hh..":"..mm..ampm
    clock = currentTime
    if clock_DisplayPreference == "ingame time" then
        clock = ingameTime
    end
    if clock_DisplayPreference == "local time/ingame time" then
        clock = currentTime.."/"..ingameTime
    end
end

------------------------------------------------------
-- experience
------------------------------------------------------
function TEB.experience()
	if IsUnitChampion("player") then
		gcp = GetUnitChampionPoints("player")
		if gcp < GetChampionPointsPlayerProgressionCap() then
			gcp = GetChampionPointsPlayerProgressionCap()
		end
		gmaxxp = GetNumChampionXPInChampionPoint(gcp)
    else
	  	gmaxxp = GetUnitXPMax("player")
    end      
	
    if IsUnitChampion("player") then
        gxp = GetPlayerChampionXP()
    else
       gxp = GetUnitXP("player")
    end  
  
    gxpCurrentPercentage = (gxp/gmaxxp)*100
    gxpCurrentPercentage = round(gxpCurrentPercentage, 1)
    gxpperc = 100 - gxpCurrentPercentage
    gxpneeded = gmaxxp - gxp
    
    if thousandsSeparator then
        gxp = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(gxp))
        gmaxxp = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(gmaxxp))
        gxpneeded = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(gxpneeded))
    else
        gxp = string.format(gxp)
        gmaxxp = string.format(gmaxxp)       
        gxpneeded = string.format(gxpneeded)       
    end
     
    if experience_DisplayPreference == "% towards next level/CP" then
        gxpString = string.format(gxpCurrentPercentage).."%"
    end
    if experience_DisplayPreference == "% needed for next level/CP" then
        gxpString = string.format(gxpperc).."%"
    end
    if experience_DisplayPreference == "current XP" then
        gxpString = gxp
    end
    if experience_DisplayPreference == "needed XP" then
        gxpString = gxpneeded
    end
    if experience_DisplayPreference == "current XP/total needed" then
        gxpString = gxp.."/"..gmaxxp
    end

end

------------------------------------------------------
-- zone
------------------------------------------------------
function TEB.zone()
	local x, y, heading = GetMapPlayerPosition("player")
	x = round(x * 100,0)
	y = round(y * 100,0)
	zoneName = GetPlayerActiveSubzoneName()
	if zoneName == "" then zoneName = GetUnitZone("player") end
	
	zoneName = TEB.fixname(zoneName)
	coordinates = string.format(x)..", "..string.format(y)
	
	if location_DisplayPreference == "(x, y) Zone Name" then
    	location = "("..coordinates..") "..zoneName
    end
	if location_DisplayPreference == "Zone Name (x, y)" then
    	location = zoneName.." ("..coordinates..")"
    end
	if location_DisplayPreference == "Zone Name" then
    	location = zoneName
    end
	if location_DisplayPreference == "x, y" then
    	location = coordinates
    end
end
	
------------------------------------------------------
-- bags
------------------------------------------------------
function TEB.bags()
  	bagUsedSlots, bagMaxSlots = PLAYER_INVENTORY:GetNumSlots(INVENTORY_BACKPACK)
  	
  	local bagPercentUsed = math.floor((bagUsedSlots / bagMaxSlots) * 100)
  	local bagPercentFree = math.floor(((bagMaxSlots - bagUsedSlots) / bagMaxSlots) * 100)
  	local freeSlots = bagMaxSlots - bagUsedSlots

    local bagColor = "|ccccccc"
    iconColor = "normal"
    if bagPercentUsed >= bag_Warning then
        bagColor = "|cffff00"
        iconColor = "caution"
    end
    if bagPercentUsed >= bag_Danger then
        bagColor = "|cff8000"
        iconColor = "warning"
    end    
    if bagPercentUsed >= bag_Critical then
        bagColor = "|cff0000"
        iconColor = "danger"
    end   

    if iconIndicator["Bag Space"] and iconColor ~= "normal" then
        TEB.SetIcon("Bag Space", iconColor)
    else
        TEB.SetIcon("Bag Space", "normal")
    end

    if addonInitialized then
        if bagPercentUsed > bag_Critical and pulseWhenCritical then 
            TEB.AddPulseItem("Bag Space")
        end
        if bagPercentUsed <= bag_Critical or not pulseWhenCritical then        
            TEB.RemovePulseItem("Bag Space")
        end
    end

 
    bagInfo = bagColor..string.format(bagUsedSlots).."/"..string.format(bagMaxSlots)
    if bag_DisplayPreference == "used%" then    
        bagInfo = bagColor..string.format(bagPercentUsed).."%%"
    end
    if bag_DisplayPreference == "slots free/total slots" then    
        bagInfo = bagColor..string.format(freeSlots).."/"..string.format(bagMaxSlots)
    end
    if bag_DisplayPreference == "slots free" then    
        bagInfo = bagColor..string.format(freeSlots)
    end
    if bag_DisplayPreference == "free%" then    
        bagInfo = bagColor..string.format(bagPercentFree).."%%"
    end
end

------------------------------------------------------
-- bank
------------------------------------------------------
function TEB.bank()
  	usedSlots, maxSlots = PLAYER_INVENTORY:GetNumSlots(INVENTORY_BANK)

  	local bankPercentUsed = math.floor((usedSlots / maxSlots) * 100)
  	local bankPercentFree = math.floor(((maxSlots - usedSlots) / maxSlots) * 100)
  	local freeSlots = maxSlots - usedSlots

    if addonInitialized then
        if bankPercentUsed > bank_Critical and pulseWhenCritical then 
            TEB.AddPulseItem("Bank Space")
        end
        if bankPercentUsed <= bank_Critical or not pulseWhenCritical then        
            TEB.RemovePulseItem("Bank Space")
        end
    end

    local bankColor = "|ccccccc"
    iconColor = "normal"
    if bankPercentUsed >= bank_Warning then
        bankColor = "|cffff00"
        iconColor = "caution"
    end
    if bankPercentUsed >= bank_Danger then
        bankColor = "|cff8000"
        iconColor = "warning"
    end    
    if bankPercentUsed >= bank_Critical then
        bankColor = "|cff0000"
        iconColor = "danger"
    end    

    if iconIndicator["Bank Space"] and iconColor ~= "normal" then
        TEB.SetIcon("Bank Space", iconColor)
    else
        TEB.SetIcon("Bank Space", "normal")
    end

    bankInfo = bankColor..string.format(usedSlots).."/"..string.format(maxSlots)
    if bank_DisplayPreference == "used%" then    
        bankInfo = bankColor..string.format(bankPercentUsed).."%"
    end
    if bank_DisplayPreference == "slots free/total slots" then    
        bankInfo = bankColor..string.format(freeSlots).."/"..string.format(maxSlots)
    end
    if bank_DisplayPreference == "slots free" then    
        bankInfo = bankColor..string.format(freeSlots)
    end
    if bank_DisplayPreference == "free%" then    
        bankInfo = bankColor..string.format(bankPercentFree).."%"
    end
end

------------------------------------------------------
-- latency
------------------------------------------------------
function TEB.latency()
  	local latencyValue = GetLatency()
    local latencyColor = "|ccccccc"
    local iconColor = "normal"    
    if icons_Mode == "color" and latencyValue < latency_Warning and latencyValue < latency_Danger then
        latencyColor = "|c00cc00"
        iconColor = "good"
    end
    if latencyValue >= latency_Warning then
        latencyColor = "|cffff00"
        iconColor = "caution"
    end
    if latencyValue >= latency_Danger then
        latencyColor = "|cff80000"
        iconColor = "warning"
    end    
    if latencyValue >= latency_Danger then
        latencyColor = "|cff0000"
        iconColor = "danger"
    end 
    latency = latencyColor..string.format(latencyValue)
  	
    if iconIndicator["Latency"] and iconColor ~= "normal" then
        TEB.SetIcon("Latency", iconColor)
    else
        TEB.SetIcon("Latency", "normal")
    end  	
end

------------------------------------------------------
-- fps
------------------------------------------------------
function TEB.fps()
  	local fpsValue = math.floor(GetFramerate())
  	
  	if fpsValue < lowestFPS then lowestFPS = fpsValue end
  	if fpsValue > highestFPS then highestFPS = fpsValue end
  	
    local fpsColor = "|ccccccc"
    local iconColor = "normal"
    if fpsValue <= fps_Warning then
        fpsColor = "|cffff00"
        iconColor = "caution"
    end
    if fpsValue <= fps_Danger then
        fpsColor = "|cff8000"
        iconColor = "warning"
    end    
    if fpsValue <= fps_Danger then
        fpsColor = "|cff0000"
        iconColor = "danger"
    end  
    fps = fpsColor..string.format(fpsValue)
  	
    if iconIndicator["FPS"] and iconColor ~= "normal" then
        TEB.SetIcon("FPS", iconColor)
    else
        TEB.SetIcon("FPS", "normal")
    end     	
end

------------------------------------------------------
-- weaponcharge
------------------------------------------------------
function TEB.weaponcharge()
    local activeWeaponPair, locked = GetActiveWeaponPairInfo()
    
    local mainHandChargePerc = 0
    local offHandChargePerc = 0
    local mainHandHasPoison = false
    local mainHandPoisonCount = 0
    local backupMainHandChargePerc = 0
    local backupOffHandChargePerc = 0

    local mainHandHasPoison, mainHandPoisonCount = getpoisoncount(EQUIP_SLOT_MAIN_HAND)
    local backupMainHandHasPoison, backupMainHandPoisonCount = getpoisoncount(EQUIP_SLOT_BACKUP_MAIN)

    mainHandChargePerc = getitemcharge(EQUIP_SLOT_MAIN_HAND)
    offHandChargePerc = getitemcharge(EQUIP_SLOT_OFF_HAND)
    backupMainHandChargePerc = getitemcharge(EQUIP_SLOT_BACKUP_MAIN)
    backupOffHandChargePerc = getitemcharge(EQUIP_SLOT_BACKUP_OFF)
    
    if activeWeaponPair == 0 then
        wcToolTipLeft = "|cffffffWeapon Charge:|cccccc\nNo weapons are equipped."
        wcToolTipRight = ""
        weaponCharge = "--"
        return
    end
    if activeWeaponPair == 1 then
        mainCharge = mainHandChargePerc
        offCharge = offHandChargePerc
        hasPoison = mainHandHasPoison
        poisonCount = mainHandPoisonCount
    end
    if activeWeaponPair == 2 then
        mainCharge = backupMainHandChargePerc
        offCharge = backupOffHandChargePerc
        hasPoison = backupMainHandHasPoison
        poisonCount = backupMainHandPoisonCount
    end
    
    local leastPerc = mainCharge
    if offCharge < mainCharge then leastPerc = offCharge end
    
    local wcColor, iconColor, poisonColor = getWCColor(leastPerc, hasPoison, poisonCount)
    if hasPoison and wc_AutoPoison then
        weaponCharge = poisonColor..string.format(poisonCount)
    else
        if leastPerc == 10000 then
            weaponCharge = wcColor.."--"
        else
            weaponCharge = wcColor..string.format(leastPerc).."%"
        end        
    end
    
    if iconIndicator["Weapon Charge"] and iconColor ~= "normal" then
        TEB.SetIcon("Weapon Charge", iconColor)
    else
        TEB.SetIcon("Weapon Charge", "normal")
    end

    if addonInitialized then
        if hasPoison and wc_AutoPoison then
            if poisonCount < wc_PoisonCritical and pulseWhenCritical then 
                TEB.AddPulseItem("Weapon Charge")
            end
            if poisonCount >= wc_PoisonCritical or not pulseWhenCritical then        
                TEB.RemovePulseItem("Weapon Charge")
            end            
        else
            if leastPerc < wc_Critical and pulseWhenCritical then 
                TEB.AddPulseItem("Weapon Charge")
            end
            if leastPerc >= wc_Critical or not pulseWhenCritical then        
                TEB.RemovePulseItem("Weapon Charge")
            end
        end
    end

    wcTooltipLeft = "|cffffffWeapon Charge:|cccccc\n"
    wcTooltipRight = ""

    if mainHandChangePerc ~= 10000 and mainHandChargePerc then
        local wcColor, iconColor, poisonColor = getWCColor(mainHandChargePerc, mainHandHasPoison, mainHandPoisonCount)
        wcTooltipLeft = wcTooltipLeft .. "\n"..wcColor..TEB.fixname(GetItemName(BAG_WORN, EQUIP_SLOT_MAIN_HAND))
        wcTooltipRight = wcTooltipRight .. "\n"..wcColor..string.format(mainHandChargePerc).."%"
    end
    if offHandChargePerc ~= 10000 and offHandChargePerc then
        local wcColor, iconColor, poisonColor = getWCColor(offHandChargePerc, mainHandHasPoison, mainHandPoisonCount)
        wcTooltipLeft = wcTooltipLeft .. "\n"..wcColor..TEB.fixname(GetItemName(BAG_WORN, EQUIP_SLOT_OFF_HAND))
        wcTooltipRight = wcTooltipRight .. "\n"..wcColor..string.format(offHandChargePerc).."%"
    end
    if backupMainHandChargePerc ~= 10000 and backupMainHandChargePerc then
        local wcColor, iconColor, poisonColor = getWCColor(backupMainHandChargePerc, backupMainHandHasPoison, backupMainHandPoisonCount)
        wcTooltipLeft = wcTooltipLeft .. "\n"..wcColor..TEB.fixname(GetItemName(BAG_WORN, EQUIP_SLOT_BACKUP_MAIN))
        wcTooltipRight = wcTooltipRight .. "\n"..wcColor..string.format(backupMainHandChargePerc).."%"
    end
    if backupOffHandChargePerc ~= 10000 and backupOffHandChargePerc then
        local wcColor, iconColor, poisonColor = getWCColor(backupOffHandChargePerc, backupMainHandHasPoison, backupMainHandPoisonCount)
        wcTooltipLeft = wcTooltipLeft .. "\n"..wcColor..TEB.fixname(GetItemName(BAG_WORN, EQUIP_SLOT_BACKUP_OFF))
        wcTooltipRight = wcTooltipRight .. "\n"..wcColor..string.format(backupOffHandChargePerc).."%"
    end

    if mainHandHasPoison or backupMainHandHasPoison then
        wcTooltipLeft = wcTooltipLeft .. "\n\nPoison Count:"
        wcTooltipRight = wcTooltipRight .. "\n\n"

        if mainHandHasPoison then
            local wcColor, iconColor, poisonColor = getWCColor(mainHandChargePerc, mainHandHasPoison, mainHandPoisonCount)
            wcTooltipLeft = wcTooltipLeft .. "\n"..poisonColor.."Primary Weapon"
            wcTooltipRight = wcTooltipRight .. "\n"..poisonColor..string.format(mainHandPoisonCount)
        end
        if backupMainHandHasPoison  then
            local wcColor, iconColor, poisonColor = getWCColor(backupMainHandChargePerc, backupMainHandHasPoison, backupMainHandPoisonCount)
            wcTooltipLeft = wcTooltipLeft .. "\n"..poisonColor.."Secondary Weapon"
            wcTooltipRight = wcTooltipRight .. "\n"..poisonColor..string.format(backupMainHandPoisonCount)
        end
    end


end

function getpoisoncount(slotNum)
    local hasPoison, poisonCount, poisonHeader, poisonItemLink = GetItemPairedPoisonInfo(slotNum)
    return hasPoison, poisonCount
end

function getitemcharge(slotNum)
	local itemLink = GetItemLink( BAG_WORN, slotNum )
	if itemLink == nil or link == "" then 
    	return 10000
    end
	if not IsItemChargeable( BAG_WORN, slotNum ) then
	    return 10000
    end
	local currentCharge = GetItemLinkNumEnchantCharges(itemLink)
	local maxCharge = GetItemLinkMaxEnchantCharges(itemLink)
    return math.floor((currentCharge / maxCharge) * 100)
end

function getWCColor(wcPerc, hasPoison, poisonCount)
    local wcColor = "|ccccccc"
    local poisonColor = "|cccccc"
    local iconColor = "normal"
    if hasPoison and wc_AutoPoison then
        if poisonCount <= wc_PoisonWarning then
            poisonColor = "|cffff00"
            iconColor = "caution"
        end
        if poisonCount <= wc_PoisonDanger then
            poisonColor = "|cff8000"
            iconColor = "warning"
        end 
        if poisonCount <= wc_PoisonCritical then
            poisonColor = "|cff0000"
            iconColor = "danger"
        end 
    else   
        if wcPerc then
            if wcPerc <= wc_Warning then
                wcColor = "|cffff00"
                iconColor = "caution"
            end
            if wcPerc <= wc_Danger then
                wcColor = "|cff8000"
                iconColor = "warning"
            end    
            if wcPerc <= wc_Critical then
                wcColor = "|cff0000"
                iconColor = "danger"
            end    
        end
    end
    return wcColor, iconColor, poisonColor
end

------------------------------------------------------
-- durability
------------------------------------------------------
function TEB.durability()
    durabilityInfo = ""
    durabilityTooltipLeft = ""
    durabilityTooltipRight = ""

    local repairCost = 0
    local leastDurability = 100
    local totalRepairCost = 0
    local mostDamagedItem = ""
    local mostDamagedCost = 0
    local mostDamagedCondition = 100

    for slotIndex=0,16,1 do
      	if DoesItemHaveDurability(BAG_WORN,slotIndex) then
          	if repairCost == nil or repairCost == "" then
              	repairCost = 0
            end
          	repairCost = tonumber(GetItemRepairCost(BAG_WORN, slotIndex))
          	totalRepairCost = totalRepairCost + repairCost
            condition = GetItemCondition(BAG_WORN, slotIndex)
            if condition < mostDamagedCondition then
                mostDamagedItem = equipSlotReference[slotIndex]
                mostDamagedCost = repairCost
                mostDamagedCondition = condition
            end
          	
          	if leastDurability > condition then
                leastDurability = condition
            end
            local durabilityColor = "|ccccccc"
            if condition > durability_Warning and condition > durability_Danger then
                durabilityColor = "|c00ff00"
            end
            if condition <= durability_Warning then
                durabilityColor = "|cffff00"                  
            end
            if condition <= durability_Danger then
                durabilityColor = "|cff8000"                  
            end    
            if condition <= durability_Critical then
                durabilityColor = "|cff0000"                  
            end    
            
            durabilityTooltipLeft = durabilityTooltipLeft .. "\n"..durabilityColor..TEB.fixname(GetItemName(BAG_WORN, slotIndex))
            durabilityTooltipRight = durabilityTooltipRight .. "\n"..durabilityColor.."("..string.format(repairCost).."g) "..string.format(condition).."%"
        end
    end
    
    if thousandsSeparator then
        totalRepairCost = zo_strformat("<<1>>", ZO_LocalizeDecimalNumber(totalRepairCost)) 
    else
        totalRepairCost = string.format(totalRepairCost)
    end
    
    durabilityTooltipLeft = durabilityTooltipLeft .. "\n\n|cccccccTotal Repair Cost\n\n"
    durabilityTooltipRight = durabilityTooltipRight .. "\n\n|ccccccc"..string.format(totalRepairCost).."g\n\n"
    
    durabilityTooltipLeft = durabilityTooltipLeft .. "Petty Repair Kit\nMinor Repair Kit\nLesser Repair Kit\nCommon Repair Kit\nGreater Repair Kit\nGrand Repair Kit\nCrown Repair Kit"
    if pettyRepairKit ~= nil then
        durabilityTooltipRight = durabilityTooltipRight .. string.format(pettyRepairKit).."\n"..string.format(minorRepairKit).."\n"..string.format(lesserRepairKit).."\n"..string.format(commonRepairKit).."\n"..string.format(greaterRepairKit).."\n"..string.format(grandRepairKit).."\n"..string.format(crownRepairKit)
    end
    
    local durabilityColor = "|ccccccc"
    iconColor = "normal"                  
    if leastDurability < durability_Warning then
        durabilityColor = "|cffff00"
        iconColor = "caution"        
    end
    if leastDurability < durability_Danger then
        durabilityColor = "|cff8000"
        iconColor = "warning"        
    end
    if leastDurability < durability_Danger then
        durabilityColor = "|cff0000"
        iconColor = "danger"        
    end

    if iconIndicator["Durability"] and iconColor ~= "normal" then
        TEB.SetIcon("Durability", iconColor)
    else
        TEB.SetIcon("Durability", "normal")
    end    
    
    if addonInitialized then
        if leastDurability < durability_Critical and pulseWhenCritical then 
            TEB.AddPulseItem("Durability")
        end
        if leastDurability >= durability_Critical or not pulseWhenCritical then        
            TEB.RemovePulseItem("Durability")
        end
    end        
        
    if durability_DisplayPreference == "durability %" then
     durabilityInfo = durabilityColor..string.format(leastDurability).."%"
    end
    if durability_DisplayPreference == "durability %/repair cost" then
     durabilityInfo = durabilityColor..string.format(leastDurability).."%|ccccccc/"..durabilityColor..string.format(totalRepairCost).."g"
    end
    if durability_DisplayPreference == "repair cost" then
     durabilityInfo = durabilityColor..string.format(totalRepairCost).."g"
    end
    if durability_DisplayPreference == "durability % (repair kits)" then
     durabilityInfo = durabilityColor..string.format(leastDurability).."% ("..string.format(totalRepairKits)..")"
    end
    if durability_DisplayPreference == "durability %/repair cost (repair kits)" then
     durabilityInfo = durabilityColor..string.format(leastDurability).."%|ccccccc/"..durabilityColor..string.format(totalRepairCost).."g ("..string.format(totalRepairKits)..")"
    end
    if durability_DisplayPreference == "repair cost (repair kits)" then
     durabilityInfo = durabilityColor..string.format(totalRepairCost).."g ("..string.format(totalRepairKits)..")"
    end
    if durability_DisplayPreference == "most damaged" then
        durabilityInfo = durabilityColor..string.format(mostDamagedItem)
    end    
    if durability_DisplayPreference == "most damaged/durability %" then
        durabilityInfo = durabilityColor..string.format(mostDamagedItem).."/"..string.format(leastDurability).."%"
    end    
     
    if durability_DisplayPreference == "most damaged/durability %/repair cost" then
        durabilityInfo = durabilityColor..string.format(mostDamagedItem).."/"..string.format(mostDamagedCondition).."%/"..string.format(mostDamagedCost).."g"
    end    
    if durability_DisplayPreference == "most damanaged/repair cost" then
        durabilityInfo = durabilityColor..string.format(mostDamagedItem).."/"..string.format(mostDamagedCost).."g"
    end            
end

------------------------------------------------------
-- skyshards
------------------------------------------------------
function TEB.skyshards()
    availablePoints = GetAvailableSkillPoints()
    skyShards = GetNumSkyShards()

    if skyshards_DisplayPreference == "collected/unspent points" then
        skyShardsInfo = string.format(skyShards).."/"..string.format(availablePoints)
    end
    if skyshards_DisplayPreference == "collected/total needed (unspent points)" then
        skyShardsInfo = string.format(skyShards).."/3 ("..string.format(availablePoints)..")"
    end
    if skyshards_DisplayPreference == "collected" then
        skyShardsInfo = string.format(skyShards)
    end
    if skyshards_DisplayPreference == "needed/unspent points" then
        skyShardsInfo = string.format(3 - skyShards).."/"..string.format(availablePoints)
    end
    if skyshards_DisplayPreference == "needed" then
        skyShardsInfo = string.format(3 - skyShards)
    end
end

------------------------------------------------------
-- blacksmithing
------------------------------------------------------
function TEB.blacksmithing()
    blackSmithingInfo, blackSmithingTimerRunning, blackSmithToolTipLeft, blackSmithToolTipRight = TEB.researchtimer(TEBTopResearchBlacksmithingIcon, CRAFTING_TYPE_BLACKSMITHING)
    if blackSmithingTimerRunning and not blacksmithTimerVisible then
        blacksmithTimerVisible = true
        TEB:RebuildBar()
    end
    if not blackSmithingTimerRunning and blacksmithTimerVisible then
        blacksmithTimerVisible = false
        TEB:RebuildBar()
    end     
end

------------------------------------------------------
-- clothing
------------------------------------------------------
function TEB.clothing()
    clothingInfo, clothingTimerRunning, clothingToolTipLeft, clothingToolTipRight = TEB.researchtimer(TEBTopResearchClothingIcon, CRAFTING_TYPE_CLOTHIER)
    if clothingTimerRunning and not clothingTimerVisible then
        clothingTimerVisible = true
        TEB:RebuildBar()
    end
    if not clothingTimerRunning and clothingTimerVisible then
        clothingTimerVisible = false
        TEB:RebuildBar()
    end     
end

------------------------------------------------------
-- woodworking
------------------------------------------------------
function TEB.woodworking()
    woodWorkingInfo, woodWorkingTimerRunning, woodWorkingToolTipLeft, woodWorkingToolTipRight = TEB.researchtimer(TEBTopResearchWoodworkingIcon, CRAFTING_TYPE_WOODWORKING)
    if woodWorkingTimerRunning and not woodworkingTimerVisible then
        woodworkingTimerVisible = true
        TEB:RebuildBar()
    end
    if not woodWorkingTimerRunning and woodworkingTimerVisible then
        woodworkingTimerVisible = false
        TEB:RebuildBar()
    end     
end

------------------------------------------------------
-- jewelrycrafting
------------------------------------------------------
function TEB.jewelrycrafting()
    jewelryCraftingInfo, jewelryTimerRunning, jewelryToolTipLeft, jewelryToolTipRight = TEB.researchtimer(TEBTopResearchJewelryCraftingIcon, CRAFTING_TYPE_JEWELRYCRAFTING)
    if jewelryTimerRunning and not jewelryTimerVisible then
        jewelryTimerVisible = true
        TEB:RebuildBar()
    end
    if not jewelryTimerRunning and jewelryTimerVisible then
        jewelryTimerVisible = false
        TEB:RebuildBar()
    end     
end

------------------------------------------------------
-- researchtimer
------------------------------------------------------
function TEB.researchtimer(researchIcon, craftId)
    researchInfo = ""
    local leastTime = 9999999
    local toolTipLeft = ""
    local toolTipRight = ""
    local timerRunning = false
    local freeSlots = 0
    local timers, totalSlots, traits = TEB.CalculateCraftingTimers(craftId)
    if #timers > 0 then
        timerRunning = true        
        for timerIndex=1,#timers do
            if timers[timerIndex] < leastTime then
                leastTime = timers[timerIndex]
            end
            toolTipLeft = toolTipLeft .. "\n" .. "Slot "..string.format(timerIndex).." - "..traits[timerIndex]
            if researchInfo ~= "" then 
                researchInfo = researchInfo .."|ccccccc/"
            end
            local timerString = TEB.ConvertSeconds(research_DisplayPreference, timers[timerIndex])
        	researchInfo = researchInfo .. timerString
        	toolTipRight = toolTipRight .."\n".. timerString
        end
        for timerIndex=#timers+1,totalSlots do
            freeSlots = freeSlots + 1
            toolTipLeft = toolTipLeft .. "\n" .. "Slot "..string.format(timerIndex)
            toolTipRight = toolTipRight .."\n"..research_FreeText            
        end
        if research_DisplayAllSlots then
            for timerIndex=#timers+1,totalSlots do
                if researchInfo ~= "" then 
                    researchInfo = researchInfo .."|ccccccc/"
                end
                researchInfo = researchInfo ..research_FreeText
            end        
        end
    end
    toolTipLeft = toolTipLeft .. "\n\n".."Free Slots: "..string.format(freeSlots).."\nTotal Slots: "..string.format(totalSlots)
    
    if research_ShowShortest then
        if leastTime == 9999999 then
            researchInfo = research_FreeText
        else
            researchInfo = TEB.ConvertSeconds(research_DisplayPreference, leastTime)
        end
    end

    if research_DisplayAllSlots then
        if researchInfo ~= "" then 
            researchInfo = researchInfo .."|ccccccc ("..string.format(freeSlots)..")"
        end
    end

    return researchInfo, timerRunning, toolTipLeft, toolTipRight
end

------------------------------------------------------
-- ConvertSeconds
------------------------------------------------------
function TEB.ConvertSeconds(displayMethod, seconds)

    local timeString = ""
    local days = math.floor(seconds/86400)
    local hours = math.floor(seconds/3600)
    local mins = math.floor(seconds/60 - (hours*60))
    local secs = math.floor(seconds - hours*3600 - mins *60)  
    if days > 0 then hours = hours - (days * 24) end
    if displayMethod == "short" then
        if days > 0 then
            timeString = string.format(days).."d"..string.format(hours).."h"
        end
        if hours > 0 and timeString == "" then
            timeString = string.format(hours).."h"..string.format(mins).."m"
        end
        if mins > 0 and timeString == "" then
            timeString = string.format(mins).."m"..string.format(secs).."s"
        end        
        if secs > 0 and timeString == "" then
            timeString = string.format(secs).."s"
        end
    end         
    if displayMethod == "simple" then
        if days > 0 then
            timeString = string.format(days).."d"
        end
        if hours > 0 and timeString == "" then
            timeString = string.format(hours+1).."h"
        end
        if mins > 0 and timeString == "" then
            timeString = string.format(mins+1).."m"
        end
        if secs > 0 and timeString == "" then
            timeString = string.format(secs).."s"
        end
    end
    if displayMethod == "exact" then
        timeString = ""
        if days > 1 then
            timeString = timeString .. string.format(days) .. "d"
        end
        timeString = timeString .. string.format("%02.f", hours).."h"..string.format("%02.f", mins).."m"..string.format("%02.f", secs).."s"
    end
    return timeString
end

------------------------------------------------------
-- CalculateCraftingTimers
------------------------------------------------------
function TEB.CalculateCraftingTimers(craftId)
    timers = {}
	local totalSlots = GetMaxSimultaneousSmithingResearch(craftId)
	local totalResearchLines = GetNumSmithingResearchLines(craftId)
    local usedSlots = 0
    traits = {}

	for researchLine = 1, totalResearchLines do
    	local lineName, icon, totalTraits, researchTimeSecs = GetSmithingResearchLineInfo(craftId, researchLine)
        for traitNum=1, totalTraits do
    		totalSecs, remainingSecs = GetSmithingResearchLineTraitTimes(craftId, researchLine, traitNum)
    		if remainingSecs ~= nil then
                local traitId, traitDescription, known = GetSmithingResearchLineTraitInfo(craftId, researchLine, traitNum)
                usedSlots = usedSlots + 1    		
                timers[usedSlots] = remainingSecs
                traits[usedSlots] = traitReference[traitId]
            end

        end
	end
    	
	return timers, totalSlots, traits
end

------------------------------------------------------
-- UpdateKillingBlows
------------------------------------------------------
function TEB.UpdateKillingBlows( eventID, result , isError , abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log )
    if pvpMode then
   
        local currPlayer = GetUnitName('player')
        local target = zo_strformat("<<1>>", targetName)
        local source = zo_strformat("<<1>>", sourceName)

        if sourceType == COMBAT_UNIT_TYPE_PLAYER and targetType == COMBAT_UNIT_TYPE_OTHER then
            kills = kills + 1
            if abilityName ~= "" then --If I got the killing blow
                local kill_time = GetFrameTimeMilliseconds()
                killingBlows = killingBlows + 1
            end
        end
	 end
	 
end

------------------------------------------------------
-- Buffs
------------------------------------------------------
function TEB.buffs()
    local isBuffActive, timeLeftInSeconds, abilityId = LFDB:IsFoodBuffActiveAndGetTimeLeft("player")
    if isBuffActive then
        foodTimerRunning = true
        foodBuffWasActive = true
        local numBuffs = GetNumBuffs("player")
        for buffIndex=1, numBuffs do
            local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, BuffEffectType, AbilityType, StatusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("player", buffIndex)
        end
    else
        foodTimerRunning = false
    end

    if addonInitialized then
        if ((timeLeftInSeconds < food_Critical * 60 and timeLeftInSeconds > 0) or (timeLeftInSecond == 0 and foodBuffWasActive)) and pulseWhenCritical then 
            TEB.AddPulseItem("Food Buff Timer")
        end
        if timeLeftInSeconds >= (food_Critical * 60) or not pulseWhenCritical then        
            TEB.RemovePulseItem("Food Buff Timer")
        end
    end
    local foodColor = "|ccccccc"
    iconColor = "normal"
    if timeLeftInSeconds < (food_Warning * 60) then
        foodColor = "|cffff00"
        iconColor = "caution"
    end
    if timeLeftInSeconds < (food_Danger * 60) then
        foodColor = "|cff8000"
        iconColor = "warning"
    end    
    if timeLeftInSeconds < (food_Danger * 60) then
        foodColor = "|cff0000"
        iconColor = "danger"
    end 

    if iconIndicator["Food Buff Timer"] and foodColor ~= "normal" then
        TEB.SetIcon("Food Buff Timer", iconColor)
    else
        TEB.SetIcon("Food Buff Timer", "normal")
    end
    
    if foodTimerRunning and not foodTimerVisible then
        foodTimerVisible = true
        TEB:RebuildBar()
    end
    if not foodTimerRunning and foodTimerVisible then
        foodTimerVisible = false
        TEB:RebuildBar()
    end       
        
    foodTooltip = TEB.ConvertSeconds(food_DisplayPreference, timeLeftInSeconds)
    food = foodColor..foodTooltip 

    mundus = "None"
    numBuffs = GetNumBuffs("player")
    if numBuffs ~=nil then
        for i = 0, numBuffs, 1 do
            buffName,timeStarted,timeEnding,buffSlot,stackCount,textureName, buffType, effectType, abilityType, statusEffectType,abilityId,canClickOff = GetUnitBuffInfo("player", i)
             if textureName and textureName ~= "" and PlainStringFind(textureName,"ability_mundusstones_") then
                local mundusBuff = ZO_CachedStrFormat("<<C:1>>", textureName)
                local mundusID = string.sub(string.sub(mundusBuff,-7),1,3)
                mundus = mundusStoneReference[mundusID]
            end
            if textureName and textureName ~= "" and PlainStringFind(textureName,"_vampire_infection_") then
                if not isVampire then
                    isVampire = true
                    TEB:RebuildBar() 
                end 
                timeEnding = math.floor(timeEnding) * 1000
                timeStarted = math.floor(timeStarted)
                vampireStage = string.match(buffName,"%d+")
                local buffTimeLeft = math.floor((timeEnding - GetFrameTimeMilliseconds()) / 1000)
                vampireTimeLeft = TEB.ConvertSeconds(vampirism_TimerPreference, buffTimeLeft)
                local skillIndex = 0
                local SkillLinesCount = GetNumSkillLines(SKILL_TYPE_WORLD)
                local nextRankXP
                local currentXP
                local lineName
                local lineLevel = 0
                local skillLineId
                local vampireSkillsID = 51
                for i=1, SkillLinesCount, 1 do
                    skillLineId = GetSkillLineId(SKILL_TYPE_WORLD, i)
                    if skillLineId == vampireSkillsID then
                        skillIndex = i
                        break
                    end
                end
                if skillIndex > 0 then
                    local rank,advised,active,discovered = GetSkillLineDynamicInfo(SKILL_TYPE_WORLD, skillIndex)
                    if discovered == true and active == true then
                        _, nextRankXP, currentXP = GetSkillLineXPInfo(SKILL_TYPE_WORLD, skillIndex)
                    end
                    if GetSkillLineInfo then
                        _, lineLevel = GetSkillLineInfo(SKILL_TYPE_WORLD, skillIndex)
                    else
                        local skillLineData = SKILLS_DATA_MANAGER:GetSkillLineDataByIndices(SKILL_TYPE_WORLD, skillIndex)
                        if skillLineData then
                            _, lineLevel = skillLineData:GetName(), skillLineData:GetCurrentRank()
                        end
                    end                    
                end
                vampireLevel = lineLevel
                --vampireLevelPercent = round((currentXP / nextRankXP)*100, 1)
                --vampireLevelPercentLeft = round(100 - vampireLevelPercent, 1)
                if vampireStage == "1" then vampireTimeLeft = "--" end
                local textColor = "|ccccccc"
                iconColor = "normal"
                local stage = tonumber(vampireStage)
                if vampirism_StageColor[stage] == "green" then 
                    textColor = "|c00ff00"
                    iconColor = "good"
                end
                if vampirism_StageColor[stage] == "yellow" then
                    textColor = "|cffff00"
                    iconColor = "caution"
                end
                if vampirism_StageColor[stage] == "orange" then
                    textColor = "|cff8000"
                    iconColor = "warning"
                end
                if vampirism_StageColor[stage] == "red" then
                    textColor = "|cff0000"
                    iconColor = "danger"
                end
                vampireText = textColor..vampireTimeLeft
                if vampirism_DisplayPreference == "Stage (Timer)" then
                    vampireText = textColor..vampireStage.." ("..vampireTimeLeft..")"
                end
                TEB.SetIcon("Vampirism", iconColor)    
                vampTooltipRight = textColor..vampireStage.."\n|ccccccc"..vampireTimeLeft
           end
        end
    end

end

------------------------------------------------------
-- Bounty/Heat Timer
------------------------------------------------------
function TEB.bounty()
    local bountyTime = GetSecondsUntilBountyDecaysToZero()
    local heatTime = GetSecondsUntilHeatDecaysToZero()
    if bountyTime >0 or heatTime > 0 then 
        bountyTimerRunning = true
    else
        bountyTimerRunning = false
    end
    local longestTime = heatTime
    if bountyTime > heatTime then longestTime = bountyTime end
    if bounty_Good == "normal" then
        bountyColor = "|ccccccc"
        iconColor = "normal"
    else
        bountyColor = "|c00ff00"
        iconColor = "good"
    end
    local infamyAmount =  GetInfamy()
    local infamy = GetInfamyLevel(infamyAmount)
    infamyText = "Upstanding"
    if infamy == INFAMY_THRESHOLD_DISREPUTABLE then
        infamyText = "Disreputable"
        if bounty_Warning == "yellow" then
            bountyColor = "|cffff00"
            iconColor = "caution"
        end
        if bounty_Warning == "orange" then
            bountyColor = "|cff8000"
            iconColor = "warning"
        end
        if bounty_Warning == "red" then
            bountyColor = "|cff0000"
            iconColor = "danger"
        end
    end
    if infamy == INFAMY_THRESHOLD_NOTORIOUS then
        infamyText = "Notorious"
        if bounty_Danger == "yellow" then
            bountyColor = "|cffff00"
            iconColor = "caution"
        end
        if bounty_Danger == "orange" then
            bountyColor = "|cff8000"
            iconColor = "warning"
        end
        if bounty_Danger == "red" then
            bountyColor = "|cff0000"
            iconColor = "danger"
        end
    end
    if infamy == INFAMY_THRESHOLD_FUGITIVE then
        infamyText = "Fugitive"
        if bounty_Critical == "yellow" then
            bountyColor = "|cffff00"
            iconColor = "caution"
        end
        if bounty_Critical == "orange" then
            bountyColor = "|cff8000"
            iconColor = "warning"
        end
        if bounty_Critical == "red" then
            bountyColor = "|cff0000"
            iconColor = "danger"
        end
    end
    bountyPayoff = GetReducedBountyPayoffAmount()
    bountyTimerText = TEB.ConvertSeconds(bounty_DisplayPreference, bountyTime)
    heatTimerText = TEB.ConvertSeconds(bounty_DisplayPreference, heatTime)
    infamyText = bountyColor..infamyText
    bounty = bountyColor..TEB.ConvertSeconds(bounty_DisplayPreference, longestTime)
    TEB.SetIcon("Bounty Timer", iconColor)
    if bountyTimerRunning and not bountyTimerVisible then
        bountyTimerVisible = true
        TEB:RebuildBar()
    end
    if not bountyTimerRunning and bountyTimerVisible then
        bountyTimerVisible = false
        TEB:RebuildBar()
    end  
end

------------------------------------------------------
-- Mail
------------------------------------------------------
function TEB.mail()
    unread_mail = GetNumUnreadMail()
    
    if unread_mail > 0 then
        if not mailUnread then
            mailUnread = true
            TEB:RebuildBar()
        end
    else
        if mailUnread then
            mailUnread = false
            TEB:RebuildBar()
        end
    end

    if unread_mail > 0 then
        if mail_Good and iconIndicator["Unread Mail"] then
            TEB.SetIcon("Unread Mail", "good")
        else
            TEB.SetIcon("Unread Mail", "normal")        
        end
    end
    if mail_Good and unread_mail > 0 then unread_mail = "|c00e900"..string.format(unread_mail) end    
    
end

------------------------------------------------------
-- UpdateDeaths
------------------------------------------------------
function TEB.UpdateDeaths()
    if pvpMode then
        deaths = deaths + 1
    end
end


------------------------------------------------------
-- soulgems
------------------------------------------------------
function TEB.CalculateBagItems()
    soulGemsToolTipLeft = ""
    soulGemsToolTipRight = ""

    total_filled = 0
    normal_filled = 0
    crown_filled = 0
    empty = 0
    lockpicks = 0
    treasures = 0
    not_treasures = 0
    fence = 0
    launder = 0
    stolenSlots = 0
    pettyRepairKit = 0
    minorRepairKit = 0
    lesserRepairKit = 0
    commonRepairKit = 0
    greaterRepairKit = 0
    grandRepairKit = 0
    crownRepairKit = 0
    totalRepairKits = 0

    nf, cf, e, lockpicks, treasures, not_treasures, stolenSlots, pettyRepairKit, minorRepairKit, lesserRepairKit, commonRepairKit, greaterRepairKit, grandRepairKit, crownRepairKit = CountItemsInBag(INVENTORY_BACKPACK)
    
    totalRepairKits = pettyRepairKit + minorRepairKit + lesserRepairKit + commonRepairKit + greaterRepairKit + grandRepairKit + crownRepairKit
    
    total_filled = nf + cf
    normal_filled = nf
    crown_filled = cf
    empty = e
    total_stolen = treasures + not_treasures
    
    local crown_color = "|ccccccc"
    if soulgems_ColorCrown then
        if crown_filled == 0 then
            crown_color = "|ccc0000"
        else
            crown_color = "|cffdf00"
        end
    end
    local total_color = "|ccccccc"
    if soulgems_ColorNormal then
        if total_filled == 0 then
            total_color = "|ccc0000"
        else
            total_color = "|c9900ff"
        end
    end
    local normal_color = "|ccccccc"
    if soulgems_ColorNormal then
        if normal_filled == 0 then
            normal_color = "|ccc0000"
        else
            normal_color = "|cbb00ff"
        end
    end
    local empty_color = "|ccccccc"
    if soulgems_ColorNormal then
        if empty == 0 then
            empty_color = "|ccc0000"
        else
            empty_color = "|c8800ff"
        end
    end        

    soulGemsToolTipLeft = soulGemsToolTipLeft.."\n"..normal_color.."Regular Filled Soul Gems"
    soulGemsToolTipLeft = soulGemsToolTipLeft.."\n"..crown_color.."Crown Soul Gems"
    soulGemsToolTipLeft = soulGemsToolTipLeft.."\n"..empty_color.."Empty Soul Gems"
    
    soulGemsToolTipRight = soulGemsToolTipRight.."\n"..normal_color..string.format(normal_filled)
    soulGemsToolTipRight = soulGemsToolTipRight.."\n"..crown_color..string.format(crown_filled)
    soulGemsToolTipRight = soulGemsToolTipRight.."\n"..empty_color..string.format(empty)

    if soulgems_DisplayPreference == "total filled/empty" then
        soulGemInfo = total_color..string.format(total_filled).."|ccccccc/"..empty_color..string.format(empty)
    end
    if soulgems_DisplayPreference == "total filled (crown)/empty" then
        soulGemInfo = total_color..string.format(total_filled)..crown_color.." ("..string.format(crown_filled)..")|ccccccc/"..empty_color..string.format(empty)
    end
    if soulgems_DisplayPreference == "total filled (empty)" then
        soulGemInfo = total_color..string.format(total_filled)..empty_color.." ("..string.format(empty)..")"
    end
    if soulgems_DisplayPreference == "regular filled/crown/empty" then
        soulGemInfo = normal_color..string.format(normal_filled).."|ccccccc/"..crown_color..string.format(crown_filled).."|ccccccc/"..empty_color..string.format(empty)
    end            
    if soulgems_DisplayPreference == "total filled" then
        soulGemInfo = total_color..string.format(total_filled)
    end
    if soulgems_DisplayPreference == "regular filled" then
        soulGemInfo = total_color..string.format(normal_filled)
    end
    
    totalSells, sellsUsed, resetTimeSeconds = GetFenceSellTransactionInfo()
    fence = totalSells - sellsUsed
    totalLaunders, laundersUsed, resetTimeSeconds = GetFenceLaunderTransactionInfo()
    launder = totalLaunders - laundersUsed
    
    local fenceColor = "|ccccccc"
    if fence <= tt_Warning then
        fenceColor = "|cffdf00"
    end
    if fence <= tt_Danger then
        fenceColor = "|ccc0000"
    end
    
    local launderColor = "|ccccccc"
    if launder <= tt_Warning then
        launderColor = "|cffdf00"
    end
    if launder <= tt_Danger then
        launderColor = "|ccc0000"
    end    
    
    local stolenInvPerc = (stolenSlots/bagMaxSlots)*100
    
    local invColor = "|ccccccc"
    
    if tt_DisplayPreference == "lockpicks" then
        tt = string.format(lockpicks)
    end
    if tt_DisplayPreference == "total stolen" then
        tt = invColor..string.format(total_stolen)
    end
    if tt_DisplayPreference == "total stolen (lockpicks)" then
        tt = invColor..string.format(total_stolen).."|ccccccc ("..string.format(lockpicks)..")"
    end
    if tt_DisplayPreference == "stolen treasures/stolen goods" then
        tt = invColor..string.format(treasures).."|ccccccc/"..string.format(not_treasures)
    end
    if tt_DisplayPreference == "stolen treasures/stolen goods (lockpicks)" then
        tt = invColor..string.format(treasures).."|ccccccc/"..string.format(not_treasures).."|ccccccc ("..string.format(lockpicks)..")"
    end
    if tt_DisplayPreference == "stolen treasures/fence_remaining stolen goods/launder_remaining" then
        tt = invColor..string.format(treasures).."|ccccccc/"..fenceColor..string.format(fence).."|ccccccc "..invColor..string.format(not_treasures).."|ccccccc/"..launderColor..string.format(launder)
    end
    if tt_DisplayPreference == "stolen treasures/fence_remaining stolen goods/launder_remaining (lockpicks)" then
        tt = invColor..string.format(treasures).."|ccccccc/"..fenceColor..string.format(fence).."|ccccccc "..invColor..string.format(not_treasures).."|ccccccc/"..launderColor..string.format(launder).."|ccccccc ("..string.format(lockpicks)..")"
    end
    if tt_DisplayPreference == "stolen treasures/stolen goods fence_remaining/launder_remaining" then
        tt = invColor..string.format(treasures).."|ccccccc/"..string.format(not_treasures).." "..fenceColor..string.format(fence).."|ccccccc/"..launderColor..string.format(launder)
    end    
    if tt_DisplayPreference == "stolen treasures/stolen goods fence_remaining/launder_remaining (lockpicks)" then
        tt = invColor..string.format(treasures).."|ccccccc/"..string.format(not_treasures).." "..fenceColor..string.format(fence).."|ccccccc/"..launderColor..string.format(launder).."|ccccccc ("..string.format(lockpicks)..")"
    end
    
end

function CountItemsInBag(bagId)
    local filled = 0
    local crown_filled = 0
    local empty = 0
    local treasures = 0
    local not_treasures = 0
    local stolenSlots = 0
    local pettyRepairKit = 0
    local minorRepairKit = 0
    local lesserRepairKit = 0
    local commonRepairKit = 0
    local greaterRepairKit = 0
    local grandRepairKit = 0
    local crownRepairKit = 0
    
    local usedSlots, numSlots = PLAYER_INVENTORY:GetNumSlots(bagId)
    for slotIndex=0, numSlots-1 do
        local itemLink = GetItemLink( bagId, slotIndex )
        local itemType, specializedItemType = GetItemLinkItemType( itemLink )
        itemInSlot = GetItemLinkItemId( itemLink )
        if IsItemLinkStolen( itemLink ) then
            stolenSlots = stolenSlots + 1
            if itemType == ITEMTYPE_TREASURE then 
               local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex) 
               treasures = treasures + stack
            end
            if itemType ~= ITEMTYPE_TREASURE then
               local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
               not_treasures = not_treasures + stack
            end
        end
        --local itemInSlot = GetItemId( bagId, slotIndex )
        if itemInSlot == 33271 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            filled = filled + stack
        end
        if itemInSlot == 61080 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            crown_filled = crown_filled + stack
        end
        if itemInSlot == 33265 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            empty = empty + stack
        end
        if itemInSlot == 44874 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            pettyRepairKit = pettyRepairKit + stack
        end
        if itemInSlot == 44875 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            minorRepairKit = minorRepairKit + stack
        end
        if itemInSlot == 44876 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            lesserRepairKit = lesserRepairKit + stack
        end
        if itemInSlot == 44877 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            commonRepairKit = commonRepairKit + stack
        end
        if itemInSlot == 44878 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            greaterRepairKit = greaterRepairKit + stack
        end
        if itemInSlot == 44879 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            grandRepairKit = grandRepairKit + stack
        end
        if itemInSlot == 61079 then
            local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, itemQuality = GetItemInfo(bagId, slotIndex)
            crownRepairKit = crownRepairKit + stack
        end
    end
    
    lockpicks = GetNumLockpicksLeft()

    return filled, crown_filled, empty, lockpicks, treasures, not_treasures, stolenSlots, pettyRepairKit, minorRepairKit, lesserRepairKit, commonRepairKit, greaterRepairKit, grandRepairKit, crownRepairKit
end
--====================================================
--====================================================
-- OnUpdate
--====================================================
--====================================================
function TEB.OnUpdate()
    if refreshTimer > 19 then
        TEB.playername()
        TEB.balance()
        TEB.skyshards()
        TEB.bags()
        TEB.mounttimer()
        TEB.experience()
        TEB.currenttime()
        TEB.durability()
        TEB.blacksmithing()
        TEB.clothing()
        TEB.woodworking()
        TEB.jewelrycrafting()
        TEB.bank()
        TEB.latency()
        TEB.fps()
        TEB.weaponcharge()
        TEB.zone()
        TEB.memory()
        TEB.recall()
        TEB.pvp()
        TEB.enlightenment()
        TEB.mail()
        TEB.buffs()
        TEB.bounty()

        
        if addonInitialized then
            TEB.AddToMountDatabase(playerName)
            TEB.AddToGoldDatabase(playerName)
        end

       --gold = "737,011"
        --lvlText="734"
        --skyShardsInfo="1/11"
        if gadgetText["Gold"] then
            TEBTopGold:SetText(gold)
        else
            TEBTopGold:SetText("")
        end
        if gadgetText["Tel Var Stones"] then
            TEBTopTelvar:SetText(string.format(telvar))   
        else
            TEBTopTelvar:SetText("")   
        end
        if gadgetText["Transmute Crystals"] then
            TEBTopTC:SetText(string.format(crystal))   
        else
            TEBTopTC:SetText("")   
        end
        if gadgetText["Writ Vouchers"] then
            TEBTopWrit:SetText(string.format(writs))  
        else
            TEBTopWrit:SetText("")
        end   
        if gadgetText["Alliance Points"] then
            TEBTopAP:SetText(apString) 
        else
            TEBTopAP:SetText("")
        end   
        if gadgetText["Level"] then
            TEBTopLevel:SetText(string.format(lvlText)) 
        else
            TEBTopLevel:SetText("")
        end   
        if gadgetText["Bag Space"] then
            TEBTopBag:SetText(string.format(bagInfo))
        else
            TEBTopBag:SetText("")
        end         
        if gadgetText["Mount Timer"] then
            TEBTopMount:SetText(string.format(mountlbltxt))
        else
            TEBTopMount:SetText("")
        end     
        if gadgetText["Experience"] then
            TEBTopXP:SetText(gxpString)
        else
            TEBTopXP:SetText("")
        end   
        if gadgetText["Clock"] then
            TEBTopTime:SetText(clock)
        else
            TEBTopTime:SetText("")
        end   
        if gadgetText["Soul Gems"] then
            TEBTopSoulGems:SetText(soulGemInfo)
        else
            TEBTopSoulGems:SetText("")
        end   
        if gadgetText["Sky Shards"] then
            TEBTopSkyShards:SetText(skyShardsInfo)
        else
            TEBTopSkyShards:SetText("")
        end
        if gadgetText["Durability"] then
            TEBTopDurability:SetText(durabilityInfo)
        else
            TEBTopDurability:SetText("")
        end              
        if gadgetText["Blacksmithing Research Timer"] then
            TEBTopResearchBlacksmithing:SetText(blackSmithingInfo)
        else
            TEBTopResearchBlacksmithing:SetText("")
        end           
        if gadgetText["Woodworking Research Timer"] then
            TEBTopResearchWoodworking:SetText(woodWorkingInfo)
        else
            TEBTopResearchWoodworking:SetText("")
        end      
        if gadgetText["Clothing Research Timer"] then
            TEBTopResearchClothing:SetText(clothingInfo)
        else
            TEBTopResearchClothing:SetText("")
        end      
        if gadgetText["Jewelry Crafting Research Timer"] then
            TEBTopResearchJewelryCrafting:SetText(jewelryCraftingInfo)
        else
            TEBTopResearchJewelryCrafting:SetText("")
        end           
        if gadgetText["Bank Space"] then
            TEBTopBank:SetText(bankInfo)
        else
            TEBTopBank:SetText("")
        end           
        if gadgetText["Latency"] then
            TEBTopLatency:SetText(latency)
        else
            TEBTopLatency:SetText("")
        end     
        if gadgetText["FPS"] then
            TEBTopFPS:SetText(fps)
        else
            TEBTopFPS:SetText("")
        end            
        if gadgetText["Weapon Charge"] then
            TEBTopWC:SetText(weaponCharge)
        else
            TEBTopWC:SetText("")
        end            
        if gadgetText["Location"] then
            TEBTopLocation:SetText(location)
        else
            TEBTopLocation:SetText("")
        end          
        if gadgetText["Thief's Tools"] then
            TEBTopTT:SetText(tt)
        else
            TEBTopTT:SetText("")
        end               
        if gadgetText["Memory Usage"] then
            TEBTopMemory:SetText(memory)
        else
            TEBTopMemory:SetText("")
        end   
        if gadgetText["Fast Travel Timer"] then
            TEBTopFT:SetText(ft)
        else
            TEBTopFT:SetText("")
        end          
        if gadgetText["Kill Counter"] then
            TEBTopKills:SetText(killCount)
        else
            TEBTopKills:SetText("")
        end  
        if gadgetText["Enlightenment"] then
            TEBTopEnlightenment:SetText(enlightenment)
        else
            TEBTopEnlightenment:SetText("")
        end            
        if gadgetText["Unread Mail"] then
            TEBTopMail:SetText(unread_mail)
        else
            TEBTopMail:SetText("")
        end  
        if gadgetText["Event Tickets"] then
            TEBTopET:SetText(eventtickets)
        else
            TEBTopET:SetText("")
        end                                  
        if gadgetText["Food Buff Timer"] then
            TEBTopFood:SetText(food)
        else
            TEBTopFood:SetText("")
        end    
        if gadgetText["Mundus Stone"] then
            TEBTopMundus:SetText(mundus)
        else
            TEBTopMundus:SetText("")
        end  
        if gadgetText["Bounty Timer"] then
            TEBTopBounty:SetText(bounty)
        else
            TEBTopBounty:SetText("")
        end  
        if gadgetText["Vampirism"] then
            TEBTopVampirism:SetText(vampireText)
        else
            TEBTopVampirism:SetText("")
        end             

        refreshTimer = 0
        
    end
    
    pulseTimer = pulseTimer + 1
    if pulseTimer > 60 then pulseTimer = 0 end

    if pulseType == "none" then    
        pulseAlpha = 1   
    end    

    if pulseType == "fade in" then    
        if pulseTimer <= 30 then
            pulseAlpha = (pulseTimer / 30)
        end    
        if pulseTimer > 30 then
            pulseAlpha = 1
        end    
    end 
    
    if pulseType == "fade out" then    
        if pulseTimer <= 30 then
            pulseAlpha = 1
        end    
        if pulseTimer > 30 then
            pulseAlpha = ((30 - (pulseTimer - 30)) / 30)
        end    
    end    

    if pulseType == "fade in/out" then    
        if pulseTimer <= 30 then
            pulseAlpha = (pulseTimer / 30)
        end    
        if pulseTimer > 30 then
            pulseAlpha = ((30 - (pulseTimer - 30)) / 30)
        end    
    end        

    if pulseType == "slow blink" then    
        if pulseTimer <= 30 then
            pulseAlpha = 1
        end    
        if pulseTimer > 30 then
            pulseAlpha = 0
        end    
    end  
    
    if pulseType == "slow toggle" then    
        if pulseTimer <= 30 then
            pulseAlpha = 2
        end    
        if pulseTimer > 30 then
            pulseAlpha = 3
        end    
    end  

    if pulseType == "fast blink" then    
        if pulseTimer <= 15 then
            pulseAlpha = 1
        end    
        if pulseTimer > 15 and pulseTimer < 30 then
            pulseAlpha = 0
        end    
        if pulseTimer > 30 and pulseTimer < 45 then
            pulseAlpha = 1
        end    
        if pulseTimer > 45 then
            pulseAlpha = 0
        end    
    end 
        
    for i=1,#pulseList do
        if pulseAlpha < 2 then
            gadgetReference[pulseList[i]][1]:SetAlpha(pulseAlpha)
            gadgetReference[pulseList[i]][2]:SetAlpha(pulseAlpha)
        else
            --TEB.SetIcon(pulseList[i], "critical")
        end            
    end
    
    

    local currentTopBarAlpha = ZO_TopBarBackground:GetAlpha()

    if currentTopBarAlpha ~= 1 then
        table.insert(topBarAlphaList, currentTopBarAlpha)
    end
    if currentTopBarAlpha == 1 and lastTopBarAlpha ~= currentTopBarAlpha then
        if topBarAlphaList[1] > topBarAlphaList[#topBarAlphaList] then TEB.ShowBar() end
        if topBarAlphaList[1] < topBarAlphaList[#topBarAlphaList] then TEB.HideBar() end
        topBarAlphaList = {}
    end
    
    lastTopBarAlpha = currentTopBarAlpha

    if centerTimer > 60 * 60 * 5 then
        TEB:UpdateControlsPosition()
    end

    if (ZO_CompassFrame:GetTop() == originalCompassTop and barPosition == "top" and bumpCompass) then
        TEB:SetBarPosition()
    end
    
    if hideBar  and barAlpha > 0 then
        barAlpha = barAlpha - .05
        if barAlpha < 0 then barAlpha = 0 end
        TEBTop:SetAlpha(barAlpha)
    end
    if not hideBar and barAlpha < 1 then
        barAlpha = barAlpha + .05
        if barAlpha > 1 then barAlpha = 1 end
        TEBTop:SetAlpha(barAlpha)
    end
    
    inCombat = IsUnitInCombat("player")
    
    local maxAlpha = combatOpacity/100
    local incrementAlpha = maxAlpha / 20
    
    if showCombatOpacity > 0 then
        showCombatOpacity = showCombatOpacity - 1
        TEBTopCombatBG:SetAlpha(maxAlpha)
        combatAlpha = maxAlpha
    end
    
    if inCombat and combatAlpha < maxAlpha and combatIndicator then
        combatAlpha = combatAlpha + incrementAlpha
        if combatAlpha > maxAlpha then combatAlpha = maxAlpha end
        TEBTopCombatBG:SetAlpha(combatAlpha)
    end
    if not inCombat and combatAlpha > 0 and showCombatOpacity == 0 then
        combatAlpha = combatAlpha - incrementAlpha
        if combatAlpha < 0 then combatAlpha = 0 end
        TEBTopCombatBG:SetAlpha(combatAlpha)
    end
    
    refreshTimer = refreshTimer + 1
    centerTimer = centerTimer + 1
end

function TEB.DefragGadgets()
    for i=#gadgets, 1, -1 do
        if gadgets[i] == "(None)" or gadgets[i] == "" then
            table.remove(gadgets, i)
        end
    end
    
    for i=#gadgets+1, #defaultGadgets do
        gadgets[i] = "(None)"
        
    end

    for i=#gadgets_pvp, 1, -1 do
        if gadgets_pvp[i] == "(None)" or gadgets_pvp[i] == "" then
            table.remove(gadgets_pvp, i)
        end
    end
    
    for i=#gadgets_pvp+1, #defaultGadgets do
        gadgets_pvp[i] = "(None)"
    end

    TEB.savedVariables.gadgets = gadgets
    TEB.savedVariables.gadgets_pvp = gadgets_pvp

end
------------------------------------------------------
-- round
------------------------------------------------------
function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function TEB.fixname(itemName)
    if string.sub(itemName, -2) == "^p" then itemName = itemName:sub(1, -3) end
    if string.sub(itemName, -2) == "^n" then itemName = itemName:sub(1, -3) end
    if string.sub(itemName, -2) == "^f" then itemName = itemName:sub(1, -3) end
    if string.sub(itemName, -2) == "^m" then itemName = itemName:sub(1, -3) end
    itemName = itemName:gsub("([a-zA-Z])(%w*)", function(a,b) return string.upper(a)..b end)
    return itemName
end

------------------------------------------------------
-- format tooltip
------------------------------------------------------
function FormatTooltip(left, right)
    TEBTooltipLeft:SetText(left)
    TEBTooltipRight:SetText(right)
    if string.len(right) > 0 then
        TEBTooltipRight:SetWidth(100)
    else
        TEBTooltipRight:SetWidth(0)
    end
    TEBTooltip:SetHeight(TEBTooltipLeft:GetHeight())
    TEBTooltip:SetWidth(TEBTooltipLeft:GetWidth() + TEBTooltipRight:GetWidth())
end

------------------------------------------------------
-- titlecase
------------------------------------------------------
local function titlecase(first, rest)
   return first:upper()..rest:lower()
end

------------------------------------------------------
-- CreateSettingsWindow
------------------------------------------------------
function TEB.CreateSettingsWindow()
  panelData = {
    type = "panel",
    name = "The Elder Bar",
    displayName = "The Elder Bar",
    author = "Eldrni",
    version = TEB.version,
    slashCommand = "/teb",
    registerForRefresh = true,
    registerForDefaults = true,
  }
  
  choiceList = { "Off", "PvE Bar", "PvP Bar", "Both Bars" }
  
  cntrlOptionsPanel = LAM2:RegisterAddonPanel("TEB_ASUGB", panelData)
  
  LAM2:RegisterOptionControls("TEB_ASUGB", { 
      { type = "submenu",
        name = "General Settings",
        controls = {
            {
                type = "checkbox",
                name = "Lock the bar",
                tooltip = "Lock the bar, preventing it from being moved.",
                default = true,
                getFunc = function() return TEB.savedVariables.barLocked end,
                setFunc = function(newValue) 
                  TEB.LockUnlockBar(newValue)
                end,
            },           
            {
                type = "checkbox",
                name = "Lock the gadgets",
                tooltip = "Lock the bar, preventing it from being moved.",
                default = true,
                getFunc = function() return TEB.savedVariables.gadgetsLocked end,
                setFunc = function(newValue) 
                  TEB.savedVariables.gadgetsLocked = newValue
                  gadgetsLocked = newValue
                  TEB.LockUnlockGadgets(newValue)
                end,
            },
            {
                type = "checkbox",
                name = "Show lock messages in chat",
                tooltip = "Show a message in chat each time the bar or gadgets are locked or unlocked.",
                default = true,
                getFunc = function() return TEB.savedVariables.lockMessage end,
                setFunc = function(newValue) 
                    TEB.savedVariables.lockMessage = newValue
                    lockMessage = newValue
                end,
            }, 
            {
                type = "dropdown",
                name = "Icon Color",
                tooltip = "Choose how you'd like the icons displayed.",
                default = "white",
                choices = {"white", "color"},
                getFunc = function() return TEB.savedVariables.icons_Mode end,
                setFunc = function(newValue)
                    TEB.savedVariables.icons_Mode = newValue
                    icons_Mode = newValue
                    TEB:RebuildBar()
                end,
              }, 
              {
                type = "slider",
                name = "Draw Layer (0=background, 4=foreground)",
                tooltip = "Choose which layer on which you'd like the bar drawn. Background is underneath everything, foreground is on top of everything.",
                min = 0,
                max = 4,
                step = 1,
                default = 0,
                getFunc = function() return TEB.savedVariables.barLayer end,
                setFunc = function(newValue) 
                    TEB.savedVariables.barLayer = newValue
                    barLayer = newValue    
                    TEB.SetBarLayer()                
                end,
            },                        
              {
                      type = "checkbox",
                      name = "Bump compass down when bar at top",
                      tooltip = "Bump the compass down if the bar position is set to top. Disable this if other addons will be moving the compass.",
                      default = true,
                      getFunc = function() return TEB.savedVariables.bumpCompass end,
                      setFunc = function(newValue) 
                        TEB.savedVariables.bumpCompass = newValue
                        bumpCompass = newValue
                        ReloadUI("ingame")
                        if not bumpCompass then
                            ReloadUI("ingame")
                        else
                            TEB:SetBarPosition()
                            TEB:UpdateControlsPosition()
                        end
                      end,
              },
              {
                      type = "checkbox",
                      name = "Bump action/resource bars up when bar at bottom",
                      tooltip = "Bump the action bar, magicka, health, and stamina bars up if the bar position is set to bottom. Disable this if other addons will be moving the action bar or health/stamina/magicka bars.",
                      default = true,
                      getFunc = function() return TEB.savedVariables.bumpActionBar end,
                      setFunc = function(newValue) 
                        TEB.savedVariables.bumpActionBar = newValue
                        bumpActionBar = newValue
                        if not bumpActionBar then
                            ReloadUI("ingame")
                        else
                            TEB:SetBarPosition()
                            TEB:UpdateControlsPosition()
                        end
                      end,
              },
              {
                      type = "dropdown",
                      name = "Gadgets position",
                      tooltip = "Set The Elder Bar's horizontal position on the screen.",
                      default = "center",
                      choices = {"left", "center", "right"},
                      getFunc = function() return TEB.savedVariables.controlsPosition end,
                      setFunc = function(newValue) 
                        TEB.savedVariables.controlsPosition = newValue
                        controlsPosition = newValue
                        TEB:UpdateControlsPosition()
                        
                      end,
              },   
              {
                type = "dropdown",
                name = "Font",
                tooltip = "Set the font used for gadget text.",
                default = "Univers57",
                choices = {"Univers57", "Univers67", "FTN47", "FTN57", "FTN87", "ProseAntiquePSMT", "Handwritten_Bold", "TrajanPro-Regular"},
                getFunc = function() return TEB.savedVariables.font end,
                setFunc = function(newValue) 
                  TEB.savedVariables.font = newValue
                  font = newValue
                  TEB.ResizeBar()
                  
                end,
            },   
              {
                      type = "slider",
                      name = "Scale",
                      tooltip = "Set The Elder Bar's scale.",
                      min = 50,
                      max = 150,
                      step = 1,
                      default = 100,
                      getFunc = function() return TEB.savedVariables.scale end,
                      setFunc = function(newValue) 
                        TEB.savedVariables.scale = newValue
                        scale = newValue
                        TEB.ResizeBar()                  
                      end,
              },         
              {
                      type = "checkbox",
                      name = "Use thousands separator",
                      tooltip = "Makes numbers a bit more readable by adding a thousands separator (comma, space, period, etc).",
                      default = true,
                      getFunc = function() return TEB.savedVariables.thousandsSeparator end,
                      setFunc = function(newValue) 
                        TEB.savedVariables.thousandsSeparator = newValue
                        thousandsSeparator = newValue
                      end,
              },
              {
                type = "checkbox",
                name = "Pulse Gadgets When Critical",
                tooltip = "Pulse gadgets when the critical theshold is reached.",
                default = false,
                getFunc = function() return TEB.savedVariables.pulseWhenCritical end,
                setFunc = function(newValue) 
                  TEB.savedVariables.pulseWhenCritical = newValue
                  pulseWhenCritical = newValue
                end,
              },     
              {
                      type = "dropdown",
                      name = "Pulse type",
                      tooltip = "Choose the type of pulse used when a gadget needs your attention.",
                      default = "fade in",
                      choices = {"none", "fade in", "fade out", "fade in/out", "slow blink", "fast blink"},
                      getFunc = function() return TEB.savedVariables.pulseType end,
                      setFunc = function(newValue) 
                        TEB.savedVariables.pulseType = newValue
                        pulseType = newValue            
                      end,
              },                         
        },
      },
      { type = "submenu",
        name = "Bar Background Settings",
        controls = {      
            {
                type = "dropdown",
                name = "Background Width",
                tooltip = "Choose how you'd like the bar background displays, either full screen width or dynamic.",
                default = "dynamic",
                choices = {"dynamic", "screen width"},
                getFunc = function() return TEB.savedVariables.barWidth end,
                setFunc = function(newValue)
                    TEB.savedVariables.barWidth = newValue
                    barWidth = newValue
                    TEB:SetBarWidth()
                end,
            },                 
            {
                type = "slider",
                name = "Bar background transparency",
                tooltip = "Set The Elder Bar's background transparency. Lower number means more transparent.",
                min = 0,
                max = 100,
                step = 1,
                default = 100,
                getFunc = function() return TEB.savedVariables.backdropOpacity end,
                setFunc = function(newValue) 
                TEB.savedVariables.backdropOpacity = newValue
                backdropOpacity = newValue
                TEB:SetBackdropOpacity()    
                end,
            },    
            {
                type = "checkbox",
                name = "Turn the bar red when in combat",
                tooltip = "Turn the bar red with in combat.",
                default = true,
                getFunc = function() return TEB.savedVariables.combatIndicator end,
                setFunc = function(newValue) 
                TEB.savedVariables.combatIndicator = newValue
                combatIndicator = newValue                
                end,
            },   
            {
                type = "slider",
                name = "Combat indicator transparency",
                tooltip = "Set the combat indicator's transparency. Lower number means more transparent.",
                min = 0,
                max = 100,
                step = 1,
                default = 100,
                getFunc = function() return TEB.savedVariables.combatOpacity end,
                setFunc = function(newValue) 
                TEB.savedVariables.combatOpacity = newValue
                combatOpacity = newValue
                showCombatOpacity = 300
                        
                end,
            },
        },
      },
      { type = "submenu",
        name = "AUTO-HIDE Settings",
        controls = {                                                                                   
            {
                type = "description",
                text = [[Choose when The Elder Bar will automatically hide and show itself. Hide the bar when:]],
            },
            {
                type = "checkbox",
                name = "Opening the game menu",
                default = true,
                tooltip = "Hide the bar when you open the game menu (crown store, map, character, inventory, skills, etc.",
                getFunc = function() return TEB.savedVariables.autohide_GameMenu end,
                setFunc = function(newValue)
                    TEB.savedVariables.autohide_GameMenu = newValue
                    autohide_GameMenu = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Conversing with NPCs",
                default = true,
                tooltip = "Hide the bar when you talk to any NPC.",
                getFunc = function() return TEB.savedVariables.autohide_Chatter end,
                setFunc = function(newValue)
                    TEB.savedVariables.autohide_Chatter = newValue
                    autohide_Chatter = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Using a crafting station",
                default = true,
                tooltip = "Hide the bar when you use a crafting station.",
                getFunc = function() return TEB.savedVariables.autohide_Crafting end,
                setFunc = function(newValue)
                    TEB.savedVariables.autohide_Crafting = newValue
                    autohide_Crafting = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Opening your personal bank",
                default = true,
                tooltip = "Hide the bar when you open your bank. (only applies if you don't hide the bar when conversing with NPCs)",
                getFunc = function() return TEB.savedVariables.autohide_Bank end,
                setFunc = function(newValue)
                    TEB.savedVariables.autohide_Bank = newValue
                    autohide_Bank = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Opening your guild's bank",
                default = true,
                tooltip = "Hide the bar when you open your guild's bank. (only applies if you don't hide the bar when conversing with NPCs)",
                getFunc = function() return TEB.savedVariables.autohide_GuildBank end,
                setFunc = function(newValue)
                    TEB.savedVariables.autohide_GuildBank = newValue
                    autohide_GuildBank = newValue
                end,
            },
        },
    },
    { type = "submenu",
    name = "Gadgets",
    controls = {                                                                                   
        {
            type = "dropdown",
            name = "Alliance Points",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Alliance Points"] end,
            setFunc = function(newValue)
                gadgetSettings["Alliance Points"] = newValue
                TEB.UpdateGadgetList("Alliance Points", newValue)
            end,
        },      
        {
            type = "dropdown",
            name = "Bag Space",
            default = "Both Bars",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Bag Space"] end,
            setFunc = function(newValue)
                gadgetSettings["Bag Space"] = newValue
                TEB.UpdateGadgetList("Bag Space", newValue)
            end,
        },   
        {
            type = "dropdown",
            name = "Bank Space",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Bank Space"] end,
            setFunc = function(newValue)
                gadgetSettings["Bank Space"] = newValue
                TEB.UpdateGadgetList("Bank Space", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Blacksmithing Research Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Blacksmithing Research Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Blacksmithing Research Timer"] = newValue
                TEB.UpdateGadgetList("Blacksmithing Research Timer", newValue)
            end,
        },  	
        {
            type = "dropdown",
            name = "Bounty/Heat Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Bounty Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Bounty Timer"] = newValue
                TEB.UpdateGadgetList("Bounty Timer", newValue)
            end,
        },  
        {
            type = "dropdown",
            name = "Clock",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Clock"] end,
            setFunc = function(newValue)
                gadgetSettings["Clock"] = newValue
                TEB.UpdateGadgetList("Clock", newValue)
            end,
        },  
        {
            type = "dropdown",
            name = "Clothing Research Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Clothing Research Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Clothing Research Timer"] = newValue
                TEB.UpdateGadgetList("Clothing Research Timer", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "Durability",
            default = "Both Bars",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Durability"] end,
            setFunc = function(newValue)
                gadgetSettings["Durability"] = newValue
                TEB.UpdateGadgetList("Durability", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Enlightenment",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Enlightenment"] end,
            setFunc = function(newValue)
                gadgetSettings["Enlightenment"] = newValue
                TEB.UpdateGadgetList("Enlightenment", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "Event Tickets",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Event Tickets"] end,
            setFunc = function(newValue)
                gadgetSettings["Event Tickets"] = newValue
                TEB.UpdateGadgetList("Event Tickets", newValue)
            end,
        }, 	  
        {
            type = "dropdown",
            name = "Experience",
            default = "Both Bars",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Experience"] end,
            setFunc = function(newValue)
                gadgetSettings["Experience"] = newValue
                TEB.UpdateGadgetList("Experience", newValue)
            end,
        }, 	   
        {
            type = "dropdown",
            name = "Fast Travel Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Fast Travel Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Fast Travel Timer"] = newValue
                TEB.UpdateGadgetList("Fast Travel Timer", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "Food/Drink Buff Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Food Buff Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Food Buff Timer"] = newValue
                TEB.UpdateGadgetList("Food Buff Timer", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "FPS",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["FPS"] end,
            setFunc = function(newValue)
                gadgetSettings["FPS"] = newValue
                TEB.UpdateGadgetList("FPS", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "Gold",
            default = "Both Bars",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Gold"] end,
            setFunc = function(newValue)
                gadgetSettings["Gold"] = newValue
                TEB.UpdateGadgetList("Gold", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "Kill Counter",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Kill Counter"] end,
            setFunc = function(newValue)
                gadgetSettings["Kill Counter"] = newValue
                TEB.UpdateGadgetList("Kill Counter", newValue)
            end,
        }, 
        {
            type = "dropdown",
            name = "Latency",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Latency"] end,
            setFunc = function(newValue)
                gadgetSettings["Latency"] = newValue
                TEB.UpdateGadgetList("Latency", newValue)
            end,
        }, 	  
        {
            type = "dropdown",
            name = "Level",
            default = "Both Bars",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Level"] end,
            setFunc = function(newValue)
                gadgetSettings["Level"] = newValue
                TEB.UpdateGadgetList("Level", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Location",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Location"] end,
            setFunc = function(newValue)
                gadgetSettings["Location"] = newValue
                TEB.UpdateGadgetList("Location", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Jewelry Crafting Research Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Jewelry Crafting Research Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Jewelry Crafting Research Timer"] = newValue
                TEB.UpdateGadgetList("Jewelry Crafting Research Timer", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Memory Usage",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Memory Usage"] end,
            setFunc = function(newValue)
                gadgetSettings["Memory Usage"] = newValue
                TEB.UpdateGadgetList("Memory Usage", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Mount Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Mount Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Mount Timer"] = newValue
                TEB.UpdateGadgetList("Mount Timer", newValue)
            end,
        },	  
        {
            type = "dropdown",
            name = "Mundus Stone",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Mundus Stone"] end,
            setFunc = function(newValue)
                gadgetSettings["Mundus Stone"] = newValue
                TEB.UpdateGadgetList("Mundus Stone", newValue)
            end,
        },	          {
            type = "dropdown",
            name = "Sky Shards",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Sky Shards"] end,
            setFunc = function(newValue)
                gadgetSettings["Sky Shards"] = newValue
                TEB.UpdateGadgetList("Sky Shards", newValue)
            end,
        },	  
        {
            type = "dropdown",
            name = "Soul Gems",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Soul Gems"] end,
            setFunc = function(newValue)
                gadgetSettings["Soul Gems"] = newValue
                TEB.UpdateGadgetList("Soul Gems", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Tel Var Stones",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Tel Var Stones"] end,
            setFunc = function(newValue)
                gadgetSettings["Tel Var Stones"] = newValue
                TEB.UpdateGadgetList("Tel Var Stones", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Thief's Tools",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Thief's Tools"] end,
            setFunc = function(newValue)
                gadgetSettings["Thief's Tools"] = newValue
                TEB.UpdateGadgetList("Thief's Tools", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Transmute Crystals",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Transmute Crystals"] end,
            setFunc = function(newValue)
                gadgetSettings["Transmute Crystals"] = newValue
                TEB.UpdateGadgetList("Transmute Crystals", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Unread Mail",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Unread Mail"] end,
            setFunc = function(newValue)
                gadgetSettings["Unread Mail"] = newValue
                TEB.UpdateGadgetList("Unread Mail", newValue)
            end,
        },	  
        {
            type = "dropdown",
            name = "Vamprism",
            default = "PvE Bar",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Vampirism"] end,
            setFunc = function(newValue)
                gadgetSettings["Vampirism"] = newValue
                TEB.UpdateGadgetList("Vampirism", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Weapon Charge/Poison",
            default = "Both Bars",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Weapon Charge"] end,
            setFunc = function(newValue)
                gadgetSettings["Weapon Charge"] = newValue
                TEB.UpdateGadgetList("Weapon Charge", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Woodworking Research Timer",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Woodworking Research Timer"] end,
            setFunc = function(newValue)
                gadgetSettings["Woodworking Research Timer"] = newValue
                TEB.UpdateGadgetList("Woodworking Research Timer", newValue)
            end,
        },
        {
            type = "dropdown",
            name = "Writ Vouchers",
            default = "Off",
            choices = choiceList,
            getFunc = function() return gadgetSettings["Writ Vouchers"] end,
            setFunc = function(newValue)
                gadgetSettings["Writ Vouchers"] = newValue
                TEB.UpdateGadgetList("Writ Vouchers", newValue)
            end,
            },  
        },
    },  
    {
        type = "divider",
    },    
    { type = "submenu",
    name = "Alliance Points",
    controls = {   
        {
            type = "checkbox",
            name = "Display Text",
            default = true,
            tooltip = "Display text for this gadget.",
            getFunc = function() return TEB.savedVariables.gadgetText["Alliance Points"] end,
            setFunc = function(newValue)
                TEB.savedVariables.gadgetText["Alliance Points"] = newValue
                gadgetText["Alliance Points"] = newValue
            end,
        },                                                
        {
            type = "dropdown",
            name = "Display format",
            tooltip = "Choose how to display alliance points.",
            default = "Total Points",
            choices = {"Total Points", "Session Points", "Points Per Hour", "Total Points/Points Per Hour", "Session Points/Points Per Hour", "Total Points/Session Points", "Total Points/Session Points (Points Per Hour)", "Total Points/Session Points/Points Per Hour"},
            getFunc = function() return TEB.savedVariables.ap_DisplayPreference end,
            setFunc = function(newValue)
                TEB.savedVariables.ap_DisplayPreference = newValue
                ap_DisplayPreference = newValue
            end,
        },
      },
    },
    { type = "submenu",
    name = "Bag Space",
    controls = { 
        {
            type = "checkbox",
            name = "Display Text",
            default = true,
            tooltip = "Display text for this gadget.",
            getFunc = function() return TEB.savedVariables.gadgetText["Bag Space"] end,
            setFunc = function(newValue)
                TEB.savedVariables.gadgetText["Bag Space"] = newValue
                gadgetText["Bag Space"] = newValue
            end,
        },                                             
        {
            type = "dropdown",
            name = "Display format",
            tooltip = "Choose how to display bag space.",
            default = "slots used/total slots",
            choices = {"slots used/total slots", "used%", "slots free/total slots", "slots free", "free%"},
            getFunc = function() return TEB.savedVariables.bag_DisplayPreference end,
            setFunc = function(newValue)
                TEB.savedVariables.bag_DisplayPreference = newValue
                bag_DisplayPreference = newValue
            end,
        },
        {
            type = "slider",
            name = "Caution threshold (% used) [yellow]",
            tooltip = "Choose at what percentage bag space will be colored yellow.",
            min = 0,
            max = 100,
            step = 1,
            default = 50,
            getFunc = function() return TEB.savedVariables.bag_Warning end,
            setFunc = function(newValue) 
            TEB.savedVariables.bag_Warning = newValue
            bag_Warning = newValue                    
            end,
        },
        {
            type = "slider",
            name = "Warning threshold (% used) [orange]",
            tooltip = "Choose at what percentage bag space will be colored red.",
            min = 0,
            max = 100,
            step = 1,
            default = 75,
            getFunc = function() return TEB.savedVariables.bag_Danger end,
            setFunc = function(newValue) 
            TEB.savedVariables.bag_Danger = newValue
            bag_Danger = newValue                    
            end,
        },
        {
            type = "slider",
            name = "Critical threshold (% used) [red]",
            tooltip = "Bag Space used over this percentage will cause the gadget to pulse.",
            min = 0,
            max = 100,
            step = 1,
            default = 90,
            getFunc = function() return TEB.savedVariables.bag_Critical end,
            setFunc = function(newValue) 
            TEB.savedVariables.bag_Critical = newValue
            bag_Critical = newValue                    
            end,
        }, 	
        },
    },            	  
    { type = "submenu",
    name = "Bank Space",
    controls = { 
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Bank Space"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Bank Space"] = newValue
                    gadgetText["Bank Space"] = newValue
                end,
            },                                            
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display bank space.",
                default = "slots used/total slots",
                choices = {"slots used/total slots", "used%", "slots free/total slots", "slots free", "free%"},
                getFunc = function() return TEB.savedVariables.bank_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.bank_DisplayPreference = newValue
                    bank_DisplayPreference = newValue
                end,
            },
            {
                type = "slider",
                name = "Caution threshold (% used) [yellow]",
                tooltip = "Choose at what percentage bank space will be colored yellow.",
                min = 0,
                max = 100,
                step = 1,
                default = 50,
                getFunc = function() return TEB.savedVariables.bank_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.bank_Warning = newValue
                bank_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Warning threshold (% used) [orange]",
                tooltip = "Choose at what percentage bank space will be colored orange.",
                min = 0,
                max = 100,
                step = 1,
                default = 75,
                getFunc = function() return TEB.savedVariables.bank_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.bank_Danger = newValue
                bank_Danger = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Critical threshold (% used) [red]",
                tooltip = "Bank Space used over this percentage will cause the gadget to pulse.",
                min = 0,
                max = 100,
                step = 1,
                default = 90,
                getFunc = function() return TEB.savedVariables.bank_Critical end,
                setFunc = function(newValue) 
                TEB.savedVariables.bank_Critical = newValue
                bank_Critical = newValue                    
                end,
            },   	      	      	  
        },
    },
    { type = "submenu",
    name = "Bounty/Heat Timer",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Bounty Timer"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Bounty Timer"] = newValue
                    gadgetText["Bounty Timer"] = newValue
                end,
            },          	   	   	  
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display the bounty timer.",
                default = "simple",
                choices = {"simple", "short", "exact"},
                getFunc = function() return TEB.savedVariables.bounty_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.bounty_DisplayPreference = newValue
                    bounty_DisplayPreference = newValue
                end,
            },	  
            {
                type = "checkbox",
                name = "Dynamically show timer",
                default = true,
                tooltip = "Show the icon and timer only when you have a bounty or heat.",
                getFunc = function() return TEB.savedVariables.bounty_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.bounty_Dynamic = newValue
                    bounty_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	 
            {
                type = "dropdown",
                name = "Upstanding",
                default = "normal",
                choices = {"normal", "green"},
                getFunc = function() return bounty_Good end,
                setFunc = function(newValue)
                    TEB.savedVariables.bounty_Good = newValue
                    bounty_Good = newValue
                end,
            },               
            {
                type = "dropdown",
                name = "Disreputable",
                default = "yellow",
                choices = {"normal", "yellow", "orange", "red"},
                getFunc = function() return bounty_Warning end,
                setFunc = function(newValue)
                    TEB.savedVariables.bounty_Warning = newValue
                    bounty_Warning = newValue
                end,
            },               
            {
                type = "dropdown",
                name = "Notorious",
                default = "orange",
                choices = {"normal", "yellow", "orange", "red"},
                getFunc = function() return bounty_Danger end,
                setFunc = function(newValue)
                    TEB.savedVariables.bounty_Danger = newValue
                    bounty_Danger = newValue
                end,
            },  
            {
                type = "dropdown",
                name = "Fugitive from Justice",
                default = "red",
                choices = {"normal", "yellow", "orange", "red"},
                getFunc = function() return bounty_Critical end,
                setFunc = function(newValue)
                    TEB.savedVariables.bounty_Critical = newValue
                    bounty_Critical = newValue
                end,
            },                            
        },
    },     
    { type = "submenu",
    name = "Clock",
    controls = { 
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Clock"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Clock"] = newValue
                    gadgetText["Clock"] = newValue
                end,
            },     
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display the clock.",
                default = "local clock",
                choices = {"local clock", "ingame time", "local time/ingame time"},
                getFunc = function() return TEB.savedVariables.clock_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.clock_DisplayPreference = newValue
                    clock_DisplayPreference = newValue
                end,
            },                                                      
            {
                type = "checkbox",
                name = "24 Hour Clock",
                default = true,		
                tooltip = "Display the clock in 24 hour mode. (ON = 24 hour clock, OFF = 12 hour clock)",
                getFunc = function() return TEB.savedVariables.clock_TwentyFourHourClock end,
                setFunc = function(newValue)
                    TEB.savedVariables.clock_TwentyFourHourClock = newValue
                    clock_TwentyFourHourClock = newValue
                end,
            }, 
        },
    },
    { type = "submenu",
    name = "Durability",
    controls = {     
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Durability"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Durability"] = newValue
                    gadgetText["Durability"] = newValue
                end,
            },                                             
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display durability.",
                default = "durability %",
                choices = {"durability %", "durability %/repair cost", "repair cost", "durability % (repair kits)", "durability %/repair cost (repair kits)", "repair cost (repair kits)", "most damaged", "most damaged/durability %", "most damaged/durability %/repair cost", "most damanaged/repair cost"},
                getFunc = function() return TEB.savedVariables.durability_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.durability_DisplayPreference = newValue
                    durability_DisplayPreference = newValue
                end,
            },
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "Choose at what percentage durability will be colored yellow.",
                min = 0,
                max = 100,
                step = 1,
                default = 50,
                getFunc = function() return TEB.savedVariables.durability_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.durability_Warning = newValue
                durability_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "Choose at what percentage durability will be colored red, indicating armor is about to break.",
                min = 0,
                max = 100,
                step = 1,
                default = 25,
                getFunc = function() return TEB.savedVariables.durability_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.durability_Danger = newValue
                durability_Danger = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Critical threshold (pulse red)",
                tooltip = "Durability below this number will cause the gadget to pulse.",
                min = 0,
                max = 100,
                step = 1,
                default = 10,
                getFunc = function() return TEB.savedVariables.durability_Critical end,
                setFunc = function(newValue) 
                TEB.savedVariables.durability_Critical = newValue
                durability_Critical = newValue                    
                end,
            }, 
        },
    },            
    { type = "submenu",
    name = "Enlightenment",
    controls = { 
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Enlightenment"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Enlightenment"] = newValue
                    gadgetText["Enlightenment"] = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Hide when enlighenment empty",
                default = true,
                tooltip = "Automatically hide the Enlighenment gadget, when there is no enlightenment to spend.",
                getFunc = function() return TEB.savedVariables.enlightenment_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.enlightenment_Dynamic = newValue
                    enlightenment_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	  
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "Enlightenment below this number will be colored yellow.",
                min = 0,
                max = 1200000,
                step = 10000,
                default = 200000,
                getFunc = function() return TEB.savedVariables.enlightenment_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.enlightenment_Warning = newValue
                enlightenment_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "Enlightenment below this number will be colored red.",
                min = 0,
                max = 1200000,
                step = 10000,
                default = 100000,
                getFunc = function() return TEB.savedVariables.enlightenment_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.enlightenment_Danger = newValue
                enlightenment_Danger = newValue                    
                end,
            }, 
            {
                type = "slider",
                name = "Critical threshold (pulse red)",
                tooltip = "Enlightenment below this number will cause the gadget to pulse.",
                min = 0,
                max = 1200000,
                step = 10000,
                default = 500000,
                getFunc = function() return TEB.savedVariables.enlightenment_Critical end,
                setFunc = function(newValue) 
                TEB.savedVariables.enlightenment_Critical = newValue
                enlightenment_Critical = newValue                    
                end,
            }, 
        },
    },         
    { type = "submenu",
    name = "Experience",
    controls = { 
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Experience"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Experience"] = newValue
                    gadgetText["Experience"] = newValue
                end,
            },                                             
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display experience.",
                default = "% towards next level/CP",
                choices = {"% towards next level/CP", "% needed for next level/CP", "current XP", "needed XP", "current XP/total needed"},
                getFunc = function() return TEB.savedVariables.experience_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.experience_DisplayPreference = newValue
                    experience_DisplayPreference = newValue
                end,
            }, 
        },
    },      
    { type = "submenu",
    name = "Event Tickets",
    controls = { 
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Event Tickets"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Event Tickets"] = newValue
                    gadgetText["Event Tickets"] = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Hide when have no tickets",
                default = true,
                tooltip = "Automatically hide the Event Tickets gadget when the character has no event tickets.",
                getFunc = function() return TEB.savedVariables.et_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.et_Dynamic = newValue
                    et_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display event tickets.",
                default = "tickets",
                choices = {"tickets", "tickets/max"},
                getFunc = function() return TEB.savedVariables.et_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.et_DisplayPreference = newValue
                    et_DisplayPreference = newValue
                end,
            },             
            {
                type = "slider",
                name = "Warning threshold",
                tooltip = "The warning color will be used when the number of tickets is equal to or higher than what is set here.",
                min = 0,
                max = 12,
                step = 1,
                default = 9,
                getFunc = function() return TEB.savedVariables.et_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.et_Warning = newValue
                et_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold",
                tooltip = "The danger color will be used when the number of tickets is equal to or higher than what is set here.",
                min = 0,
                max = 12,
                step = 1,
                default = 12,
                getFunc = function() return TEB.savedVariables.et_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.et_Danger = newValue
                et_Danger = newValue                    
                end,
            },            
        },
    },		                                               
    { type = "submenu",
    name = "Fast Travel Timer",
    controls = {   
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Fast Travel Timer"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Fast Travel Timer"] = newValue
                    gadgetText["Fast Travel Timer"] = newValue
                end,
            },                                            
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display fast travel timer.",
                default = "time left/cost",
                choices = {"time left", "cost", "time left/cost"},
                getFunc = function() return TEB.savedVariables.ft_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.ft_DisplayPreference = newValue
                    ft_DisplayPreference = newValue
                end,
            },  
            {
                type = "dropdown",
                name = "Timer display format",
                tooltip = "Choose how to display fast travel time left until cheapest.",
                default = "simple",
                choices = {"simple", "short", "exact"},
                getFunc = function() return TEB.savedVariables.ft_TimerDisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.ft_TimerDisplayPreference = newValue
                    ft_TimerDisplayPreference = newValue
                end,
            },	  
            {
                type = "checkbox",
                name = "Only show timer after traveling",
                default = true,
                tooltip = "Show the icon and timer only after you've fast traveled. When the timer reaches zero, the timer disappears again.",
                getFunc = function() return TEB.savedVariables.ft_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.ft_Dynamic = newValue
                    ft_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	
        },
    },
    { type = "submenu",
    name = "Food/Drink Buff Timer",
    controls = { 
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Food Buff Timer"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Food Buff Timer"] = newValue
                    gadgetText["Food Buff Timer"] = newValue
                end,
            },                                             
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display the food buff timer.",
                default = "simple",
                choices = {"simple", "short", "exact"},
                getFunc = function() return TEB.savedVariables.food_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.food_DisplayPreference = newValue
                    food_DisplayPreference = newValue
                end,
            },
            {
                type = "slider",
                name = "Warning threshold (minutes remaining)",
                tooltip = "The warning color will be used when the timer falls below what is set here.",
                min = 0,
                max = 120,
                step = 1,
                default = 15,
                getFunc = function() return TEB.savedVariables.food_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.food_Warning = newValue
                food_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (minutes remaining)",
                tooltip = "The danger color will be used when the timer falls below what is set here.",
                min = 0,
                max = 120,
                step = 1,
                default = 7,
                getFunc = function() return TEB.savedVariables.food_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.food_Danger = newValue
                food_Danger = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Critical threshold (minutes remaining)",
                tooltip = "The gadget will pulse when the timer falls below what is set here.",
                min = 0,
                max = 120,
                step = 1,
                default = 2,
                getFunc = function() return TEB.savedVariables.food_Critical end,
                setFunc = function(newValue) 
                TEB.savedVariables.food_Critical = newValue
                food_Critical = newValue                    
                end,
            }, 
            {
                type = "checkbox",
                name = "Keep Pulsing After Expiring",
                default = true,
                tooltip = "Allows the gadget to continue pulsing even after the timer has expired.",
                getFunc = function() return TEB.savedVariables.food_PulseAfter end,
                setFunc = function(newValue)
                    TEB.savedVariables.food_PulseAfter = newValue
                    food_PulseAfter = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Only show timer when buff active",
                default = true,
                tooltip = "Show the icon and timer only when a food buff is active.",
                getFunc = function() return TEB.savedVariables.food_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.food_Dynamic = newValue
                    food_Dynamic = newValue
                    TEB:RebuildBar()
                end,
              },            
        },
    },	  	   	    	       
    { type = "submenu",
    name = "FPS",
    controls = {                                       
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["FPS"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["FPS"] = newValue
                    gadgetText["FPS"] = newValue
                end,
            },   
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "FPS below this number will be colored yellow.",
                min = 0,
                max = 100,
                step = 1,
                default = 30,
                getFunc = function() return TEB.savedVariables.fps_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.fps_Warning = newValue
                fps_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "FPS below this number will be colored red.",
                min = 0,
                max = 100,
                step = 1,
                default = 15,
                getFunc = function() return TEB.savedVariables.fps_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.fps_Danger = newValue
                fps_Danger = newValue                    
                end,
            },
            {
                type = "checkbox",
                name = "Use Fixed Width",
                default = true,
                tooltip = "Use fixed width for this gadget.",
                warning = "Disabling this will cause UI reload.",
                getFunc = function() return TEB.savedVariables.fps_Fixed end,
                setFunc = function(newValue)
                    TEB.savedVariables.fps_Fixed = newValue
                    fps_Fixed = newValue
                    TEB.SetFPSFixed()
                end,
            },   	             
            {
                type = "slider",
                name = "Fixed Width Size",
                tooltip = "The size in pixels for the gadget.",
                min = 1,
                max = 400,
                step = 1,
                default = 100,
                getFunc = function() return TEB.savedVariables.fps_FixedLength end,
                setFunc = function(newValue) 
                TEB.savedVariables.fps_FixedLength = newValue
                fps_FixedLength = newValue                  
                if fps_Fixed then TEB.SetFPSFixed() end
                end,
            },
        },
    },
    { type = "submenu",
    name = "Gold",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Gold"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Gold"] = newValue
                    gadgetText["Gold"] = newValue
                end,
            },                                              
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display gold.",
                default = "gold on character",
                choices = {"gold on character", "gold on character/gold in bank", "gold on character (gold in bank)", "character+bank gold", "tracked gold", "tracked+bank gold"},
                getFunc = function() return TEB.savedVariables.gold_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.gold_DisplayPreference = newValue
                    gold_DisplayPreference = newValue
                end,
            }, 
            {
                type = "checkbox",
                name = "Track this character",
                tooltip = "Track this character's gold.",
                default = true,
                disabled = function() return TEB.DisableGoldTracker() end,
                getFunc = function() return TEB.GetCharacterGoldTracked() end,
                setFunc = function(newValue)
                    TEB.SetCharacterGoldTracked(newValue)
                end,
            },	 
        },
    }, 
    { type = "submenu",
    name = "Kill Counter",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Kill Counter"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Kill Counter"] = newValue
                    gadgetText["Kill Counter"] = newValue
                end,
            },           	  
            {
                type = "dropdown",
                name = "Kill Counter display format",
                tooltip = "Choose how to display the kill counter.",
                default = "Killing Blows/Deaths (Kill Ratio)",
                choices = {"Assists/Killing Blows/Deaths (Kill Ratio)", "Assists/Killing Blows/Deaths", "Killing Blows/Deaths (Kill Ratio)", "Killing Blows/Deaths", "Kill Ratio"},
                getFunc = function() return TEB.savedVariables.kc_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.kc_DisplayPreference = newValue
                    kc_DisplayPreference = newValue
                end,
            },		
        },
    },  
    { type = "submenu",
    name = "Latency",
    controls = {                                  
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Latency"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Latency"] = newValue
                    gadgetText["Latency"] = newValue
                end,
            },   
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "Latency above this number will be colored yellow.",
                min = 0,
                max = 5000,
                step = 10,
                default = 100,
                getFunc = function() return TEB.savedVariables.latency_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.latency_Warning = newValue
                latency_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "Latency above this number will be colored red.",
                min = 0,
                max = 5000,
                step = 10,
                default = 500,
                getFunc = function() return TEB.savedVariables.latency_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.latency_Danger = newValue
                latency_Danger = newValue                    
                end,
            },
            {
                type = "checkbox",
                name = "Use Fixed Width",
                default = true,
                tooltip = "Use fixed width for this gadget.",
                warning = "Disabling this will cause UI reload.",
                getFunc = function() return TEB.savedVariables.latency_Fixed end,
                setFunc = function(newValue)
                    TEB.savedVariables.latency_Fixed = newValue
                    latency_Fixed = newValue
                    TEB.SetLatencyFixed()
                end,
            },   	             
            {
                type = "slider",
                name = "Fixed Width Size",
                tooltip = "The size in pixels for the gadget.",
                min = 1,
                max = 400,
                step = 1,
                default = 100,
                getFunc = function() return TEB.savedVariables.latency_FixedLength end,
                setFunc = function(newValue) 
                TEB.savedVariables.latency_FixedLength = newValue
                latency_FixedLength = newValue                  
                if latency_Fixed then TEB.SetLatencyFixed() end
                end,
            },
        },
    },	        	       
    { type = "submenu",
    name = "Level",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Level"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Level"] = newValue
                    gadgetText["Level"] = newValue
                end,
            },         	  	   	   	  
            {
                type = "dropdown",
                name = "Display format when below level 50",
                tooltip = "Choose how to display the level/CP when below level 50.",
                default = "[Class Icon] Character Level (Unspent Points)",
                choices = {"[Class Icon] Character Level", "[Class Icon] Character Level/Champion Points", "[Class Icon] Champion Points", "[CP Icon] Character Level", "[CP Icon] Character Level/Champion Points", "[CP Icon] Champion Points", "[Class Icon] Character Level (Unspent Points)", "[Class Icon] Character Level/Champion Points (Unspent Points)", "[Class Icon] Champion Points (Unspent Points)", "[CP Icon] Character Level (Unspent Points)", "[CP Icon] Character Level/Champion Points (Unspent Points)", "[CP Icon] Champion Points (Unspent Points)"},
                getFunc = function() return TEB.savedVariables.level_DisplayPreferenceNotMax end,
                setFunc = function(newValue)
                    TEB.savedVariables.level_DisplayPreferenceNotMax = newValue
                    level_DisplayPreferenceNotMax = newValue
                    TEB:RebuildBar()
                end,
            },	  
            {
                type = "dropdown",
                name = "Display format when at level 50",
                tooltip = "Choose how to display the level/CP when at level 50.",
                default = "[CP Icon] Champion Points (Unspent Points)",
                choices = {"[Class Icon] Character Level", "[Class Icon] Character Level/Champion Points", "[Class Icon] Champion Points", "[CP Icon] Character Level", "[CP Icon] Character Level/Champion Points", "[CP Icon] Champion Points", "[Class Icon] Character Level (Unspent Points)", "[Class Icon] Character Level/Champion Points (Unspent Points)", "[Class Icon] Champion Points (Unspent Points)", "[CP Icon] Character Level (Unspent Points)", "[CP Icon] Character Level/Champion Points (Unspent Points)", "[CP Icon] Champion Points (Unspent Points)"},
                getFunc = function() return TEB.savedVariables.level_DisplayPreferenceMax end,
                setFunc = function(newValue)
                    TEB.savedVariables.level_DisplayPreferenceMax = newValue
                    level_DisplayPreferenceMax = newValue
                    TEB:RebuildBar()            
                end,
            },
            {
                type = "checkbox",
                name = "Dynamically show champion points",
                default = true,
                tooltip = "Show the icon and unspent points only when there is at least one point to spend.",
                getFunc = function() return TEB.savedVariables.level_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.level_Dynamic = newValue
                    level_Dynamic = newValue
                end,
            },	 
        },
    }, 
    { type = "submenu",
    name = "Location",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Location"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Location"] = newValue
                    gadgetText["Location"] = newValue
                end,
            },                                              
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display your location.",
                default = "(x, y) Zone Name",
                choices = {"(x, y) Zone Name", "Zone Name (x, y)", "Zone Name", "x, y"},
                getFunc = function() return TEB.savedVariables.location_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.location_DisplayPreference = newValue
                    location_DisplayPreference = newValue
                end,
            },	
        },
    },
    { type = "submenu",
    name = "Memory Usage",
    controls = {                                      
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Memory Usage"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Memory Usage"] = newValue
                    gadgetText["Memory Usage"] = newValue
                end,
            }, 
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "Memory Usage above this number will be colored yellow.",
                min = 0,
                max = 1024,
                step = 8,
                default = 512,
                getFunc = function() return TEB.savedVariables.memory_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.memory_Warning = newValue
                memory_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "Memory usage above this number will be colored red.",
                min = 0,
                max = 1024,
                step = 8,
                default = 768,
                getFunc = function() return TEB.savedVariables.memory_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.memory_Danger = newValue
                memory_Danger = newValue                    
                end,
            }, 
        },
    },	        
    { type = "submenu",
    name = "Mount Timer",
    controls = {                                     
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Mount Timer"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Mount Timer"] = newValue
                    gadgetText["Mount Timer"] = newValue
                end,
            },             	  	    	    	  
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display the mount timer.",
                default = "simple",
                choices = {"simple", "short", "exact"},
                getFunc = function() return TEB.savedVariables.mount_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.mount_DisplayPreference = newValue
                    mount_DisplayPreference = newValue
                end,
            },	  
            {
                type = "checkbox",
                name = "Automatically hide timer when mount fully trained",
                default = true,
                tooltip = "Hide the icon and timer only when the mount is fully trained.",
                getFunc = function() return TEB.savedVariables.mount_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.mount_Dynamic = newValue
                    mount_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	
            {
                type = "checkbox",
                name = "Indicate when the timer has reached zero",
                default = true,
                tooltip = "When the timer has reached zero, turn the gadget green.",
                getFunc = function() return TEB.savedVariables.mount_Good end,
                setFunc = function(newValue)
                    TEB.savedVariables.mount_Good = newValue
                    mount_Good = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Pulse gadget",
                default = true,
                tooltip = "Pulse the gadget when it is time to train your mount.",
                getFunc = function() return TEB.savedVariables.mount_Critical end,
                setFunc = function(newValue)
                    TEB.savedVariables.mount_Critical = newValue
                    mount_Critical = newValue
                end,
            },	  	
            {
                type = "checkbox",
                name = "Track this character",
                tooltip = "Track this character's mount training time left.",
                default = true,
                disabled = function() return TEB.DisableMountTracker() end,
                reference = "mountTrackCheckbox",
                getFunc = function() return TEB.GetCharacterMountTracked() end,
                setFunc = function(newValue)
                    TEB.SetCharacterMountTracked(newValue)
                end,
            },  
        },
    },  	  		  
    { type = "submenu",
    name = "Mundus Stone",
    controls = {                                     
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Mundus Stone"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Mundus Stone"] = newValue
                    gadgetText["Mundus Stone"] = newValue
                end,
            },             	  	    	    	  
        },
    },  	  		  
    { type = "submenu",
    name = "Research Timers",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for these gadgets.",
                getFunc = function() return TEB.savedVariables.gadgetText["Blacksmithing Research Timer"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Blacksmithing Research Timer"] = newValue
                    TEB.savedVariables.gadgetText["Clothing Research Timer"] = newValue
                    TEB.savedVariables.gadgetText["Woodworking Research Timer"] = newValue
                    TEB.savedVariables.gadgetText["Jewelry Crafting Research Timer"] = newValue
                    gadgetText["Blacksmithing Research Timer"] = newValue
                    gadgetText["Clothing Research Timer"] = newValue
                    gadgetText["Woodworking Research Timer"] = newValue
                    gadgetText["Jewelry Crafting Research Timer"] = newValue
                end,
            },          	   	   	  
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display research timers.",
                default = "simple",
                choices = {"simple", "short", "exact"},
                getFunc = function() return TEB.savedVariables.research_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.research_DisplayPreference = newValue
                    research_DisplayPreference = newValue
                end,
            },	  
            {
                type = "checkbox",
                name = "Only show timers while researching",
                default = true,
                tooltip = "Show the icon and timer only when you are actively researching.",
                getFunc = function() return TEB.savedVariables.research_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.research_Dynamic = newValue
                    research_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	  
            {
                type = "checkbox",
                name = "Only show the shortest timer",
                default = false,
                tooltip = "When researching multiple items, only show the timer that has the least amount of time left.",
                getFunc = function() return TEB.savedVariables.research_ShowShortest end,
                setFunc = function(newValue)
                    TEB.savedVariables.research_ShowShortest = newValue
                    research_ShowShortest = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Show free slots",
                default = true,
                tooltip = "Show the number of free slots available for research.",
                getFunc = function() return TEB.savedVariables.research_DisplayAllSlots end,
                setFunc = function(newValue)
                    TEB.savedVariables.research_DisplayAllSlots = newValue
                    research_DisplayAllSlots = newValue
                end,
            },
            {
                type = "dropdown",
                name = "Display free slots as",
                tooltip = "Choose how to display free research slots.",
                default = "--",
                choices = {"--", "-", "free", "0", "done"},
                getFunc = function() return TEB.savedVariables.research_FreeText end,
                setFunc = function(newValue)
                    TEB.savedVariables.research_FreeText = newValue
                    research_FreeText = newValue
                end,
            },	
        },
    },  
    { type = "submenu",
    name = "Sky Shards",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Sky Shards"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Sky Shards"] = newValue
                    gadgetText["Sky Shards"] = newValue
                end,
            },                                             
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display sky shard count.",
                default = "collected/unspent points",
                choices = {"collected/unspent points", "collected/total needed (unspent points)", "needed/unspent points", "collected", "needed"},
                getFunc = function() return TEB.savedVariables.skyshards_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.skyshards_DisplayPreference = newValue
                    skyshards_DisplayPreference = newValue
                end,
            },
        },
    },	
    { type = "submenu",
    name = "Soul Gems",
    controls = {  
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Soul Gems"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Soul Gems"] = newValue
                    gadgetText["Soul Gems"] = newValue
                end,
            },                                            
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display soul gem count.\ntotal filled = regular (non-crown) filled soul gems + crown soul gems\nregular filled = regular (non-crown) filled soul gems\ncrown = crown soul gems\nempty = empty soul gems",
                default = "total filled/empty",
                choices = {"total filled/empty", "total filled (empty)", "total filled (crown)/empty", "regular filled/crown/empty", "total filled", "regular filled"},
                getFunc = function() return TEB.savedVariables.soulgems_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.soulgems_DisplayPreference = newValue
                    soulgems_DisplayPreference = newValue
                    TEB.CalculateBagItems()
                end,
            },
        },
    },
    { type = "submenu",
    name = "Tel Var Stones",
    controls = {                                       
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Tel Var Stones"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Tel Var Stones"] = newValue
                    gadgetText["Tel Var Stones"] = newValue
                end,
            }, 	
        },
    },  
    { type = "submenu",
    name = "Thief's Tools",
    controls = {                                    
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Thief's Tools"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Thief's Tools"] = newValue
                    gadgetText["Thief's Tools"] = newValue
                end,
            }, 
            {
                type = "slider",
                name = "Interactions warning threshold (yellow)",
                tooltip = "Fence and launder interactions below this number will be colored yellow.",
                min = 0,
                max = 100,
                step = 1,
                default = 25,
                getFunc = function() return TEB.savedVariables.tt_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.tt_Warning = newValue
                tt_Warning = newValue
                TEB.CalculateBagItems()                  
                end,
            },
            {
                type = "slider",
                name = "Interactions danger threshold (red)",
                tooltip = "Fence and launder interactions below this number will be colored red.",
                min = 0,
                max = 100,
                step = 1,
                default = 10,
                getFunc = function() return TEB.savedVariables.tt_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.tt_Danger = newValue
                tt_Danger = newValue
                TEB.CalculateBagItems()                    
                end,
            },
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display the thief's tools.",
                default = "stolen treasures/stolen goods (lockpicks)",
                choices = {"lockpicks", "total stolen", "total stolen (lockpicks)", "stolen treasures/stolen goods", "stolen treasures/stolen goods (lockpicks)", "stolen treasures/fence_remaining stolen goods/launder_remaining", "stolen treasures/fence_remaining stolen goods/launder_remaining (lockpicks)", "stolen treasures/stolen goods fence_remaining/launder_remaining", "stolen treasures/stolen goods fence_remaining/launder_remaining (lockpicks)"},
                getFunc = function() return TEB.savedVariables.tt_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.tt_DisplayPreference = newValue
                    tt_DisplayPreference = newValue
                    TEB.CalculateBagItems()
                end,
            },  
        },
    }, 		    
    { type = "submenu",
    name = "Transmute Crystals",
    controls = {                                      
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Transmute Crystals"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Transmute Crystals"] = newValue
                    gadgetText["Transmute Crystals"] = newValue
                end,
            }, 
        },
    },
    { type = "submenu",
    name = "Unread Mail",
    controls = {                                      
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Unread Mail"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Unread Mail"] = newValue
                    gadgetText["Unread Mail"] = newValue
                end,
            }, 
            {
                type = "checkbox",
                name = "Automatically hide when no unread mail",
                default = true,
                tooltip = "Hide the gadget only when there in no unread mail.",
                getFunc = function() return TEB.savedVariables.mail_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.mail_Dynamic = newValue
                    mail_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	
            {
                type = "checkbox",
                name = "Indicate when there is unread mail",
                default = true,
                tooltip = "When there is unread mail, turn the gadget green.",
                getFunc = function() return TEB.savedVariables.mail_Good end,
                setFunc = function(newValue)
                    TEB.savedVariables.mail_Good = newValue
                    mail_Good = newValue
                end,
            },
            {
                type = "checkbox",
                name = "Pulse gadget",
                default = true,
                tooltip = "Pulse the gadget when there is unread mail.",
                getFunc = function() return TEB.savedVariables.mail_Critical end,
                setFunc = function(newValue)
                    TEB.savedVariables.mail_Critical = newValue
                    mail_Critical = newValue
                end,
            },	 
        },
    }, 	  		       	              
    { type = "submenu",
    name = "Vampirism",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Vampirism"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Vampirism"] = newValue
                    gadgetText["Vampirism"] = newValue
                end,
            },          	   	   	  
            {
                type = "dropdown",
                name = "Display format",
                tooltip = "Choose how to display the vampirism gadget information.",
                default = "Stage (Timer)",
                choices = {"Stage (Timer)", "Timer"},
                getFunc = function() return TEB.savedVariables.vampirism_DisplayPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_DisplayPreference = newValue
                    vampirism_DisplayPreference = newValue
                end,
            },	  
            {
                type = "dropdown",
                name = "Timer Display format",
                tooltip = "Choose how to display the vampirism stage timer.",
                default = "simple",
                choices = {"simple", "short", "exact"},
                getFunc = function() return TEB.savedVariables.vampirism_TimerPreference end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_TimerPreference = newValue
                    vampirism_TimerPreference = newValue
                end,
            },	  
            {
                type = "checkbox",
                name = "Hide if not a vampire",
                default = true,
                tooltip = "Show the gadget only if you are a vampire.",
                getFunc = function() return TEB.savedVariables.vampirism_Dynamic end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_Dynamic = newValue
                    vampirism_Dynamic = newValue
                    TEB:RebuildBar()
                end,
            },	 
            {
                type = "dropdown",
                name = "Stage 1",
                default = "normal",
                choices = {"normal", "green", "yellow", "orange", "red"},
                getFunc = function() return vampirism_StageColor[1] end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_StageColor[1] = newValue
                    vampirism_StageColor[1] = newValue
                end,
            },               
            {
                type = "dropdown",
                name = "Stage 2",
                default = "yellow",
                choices = {"normal", "green", "yellow", "orange", "red"},
                getFunc = function() return vampirism_StageColor[2] end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_StageColor[2] = newValue
                    vampirism_StageColor[2] = newValue
                end,
            },               
            {
                type = "dropdown",
                name = "Stage 3",
                default = "orange",
                choices = {"normal", "green", "yellow", "orange", "red"},
                getFunc = function() return vampirism_StageColor[3] end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_StageColor[3] = newValue
                    vampirism_StageColor[3] = newValue
                end,
            },  
            {
                type = "dropdown",
                name = "Stage 4",
                default = "red",
                choices = {"normal", "green", "yellow", "orange", "red"},
                getFunc = function() return vampirism_StageColor[4] end,
                setFunc = function(newValue)
                    TEB.savedVariables.vampirism_StageColor[4] = newValue
                    vampirism_StageColor[4] = newValue
                end,
            },                            
        },
    },         
    { type = "submenu",
    name = "Weapon Charge/Poison",
    controls = {
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Weapon Charge"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Weapon Charge"] = newValue
                    gadgetText["Weapon Charge"] = newValue
                end,
            },       
            {
                type = "checkbox",
                name = "Display poison count when poison is applied",
                default = true,
                tooltip = "Replace weapon charge display with poison count whenever poison is applied to a weapon.",
                getFunc = function() return TEB.savedVariables.wc_AutoPoison end,
                setFunc = function(newValue)
                    TEB.savedVariables.wc_AutoPoison = newValue
                    wc_AutoPoison = newValue
                end,
            },    	
            {
                    type = "description",
                    text = "|c2A8FEEWeapon Charge Thresholds:",
                    width = "full"
            },     	    	                                         
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "Weapon charge below this number will be colored yellow.",
                min = 0,
                max = 100,
                step = 1,
                default = 50,
                getFunc = function() return TEB.savedVariables.wc_Warning end,
                setFunc = function(newValue) 
                TEB.savedVariables.wc_Warning = newValue
                wc_Warning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "Weapon charge below this number will be colored red.",
                min = 0,
                max = 100,
                step = 1,
                default = 25,
                getFunc = function() return TEB.savedVariables.wc_Danger end,
                setFunc = function(newValue) 
                TEB.savedVariables.wc_Danger = newValue
                wc_Danger = newValue                    
                end,
            }, 
            {
                type = "slider",
                name = "Critical threshold (pulse)",
                tooltip = "Weapon charge below this number will cause the gadget to pulse.",
                min = 0,
                max = 100,
                step = 1,
                default = 10,
                getFunc = function() return TEB.savedVariables.wc_Critical end,
                setFunc = function(newValue) 
                TEB.savedVariables.wc_Critical = newValue
                wc_Critical = newValue                    
                end,
            },
            {
                    type = "description",
                    text = "|c2A8FEEPoison Count Thresholds:",
                    width = "full"
            },           
            {
                type = "slider",
                name = "Warning threshold (yellow)",
                tooltip = "Poison Count below this number will be colored yellow.",
                min = 0,
                max = 100,
                step = 1,
                default = 20,
                getFunc = function() return TEB.savedVariables.wc_PoisonWarning end,
                setFunc = function(newValue) 
                TEB.savedVariables.wc_PoisonWarning = newValue
                wc_PoisonWarning = newValue                    
                end,
            },
            {
                type = "slider",
                name = "Danger threshold (red)",
                tooltip = "Poison Count below this number will be colored red.",
                min = 0,
                max = 100,
                step = 1,
                default = 10,
                getFunc = function() return TEB.savedVariables.wc_PoisonDanger end,
                setFunc = function(newValue) 
                TEB.savedVariables.wc_PoisonDanger = newValue
                wc_PoisonDanger = newValue                    
                end,
            }, 
            {
                type = "slider",
                name = "Critical threshold (pulse)",
                tooltip = "Poison Count below this number will cause the gadget to pulse.",
                min = 0,
                max = 100,
                step = 1,
                default = 5,
                getFunc = function() return TEB.savedVariables.wc_PoisonCritical end,
                setFunc = function(newValue) 
                TEB.savedVariables.wc_PoisonCritical = newValue
                wc_PoisonCritical = newValue                    
                end,
            },          
        },
    },  
    { type = "submenu",
    name = "Writ Vouchers",
    controls = {                                   
            {
                type = "checkbox",
                name = "Display Text",
                default = true,
                tooltip = "Display text for this gadget.",
                getFunc = function() return TEB.savedVariables.gadgetText["Writ Vouchers"] end,
                setFunc = function(newValue)
                    TEB.savedVariables.gadgetText["Writ Vouchers"] = newValue
                    gadgetText["Writ Vouchers"] = newValue
                end,
            },
        },
    },                   	  	    
  })

end

EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_ADD_ON_LOADED, TEB.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, TEB.CalculateBagItems)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_OPEN_BANK, TEB.BankHideBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_CLOSE_BANK, TEB.ShowBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_CHATTER_BEGIN, TEB.ChatterHideBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_CHATTER_END, TEB.ShowBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_CRAFTING_STATION_INTERACT, TEB.CraftingHideBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_END_CRAFTING_STATION_INTERACT, TEB.ShowBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_OPEN_GUILD_BANK, TEB.GuildBankHideBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_CLOSE_GUILD_BANK, TEB.ShowBar)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_JUSTICE_STOLEN_ITEMS_REMOVED, TEB.CalculateBagItems)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_COMBAT_EVENT, TEB.UpdateKillingBlows)
EVENT_MANAGER:RegisterForEvent(TEB.name, EVENT_PLAYER_DEAD, TEB.UpdateDeaths)
 
EVENT_MANAGER:AddFilterForEvent(TEB.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_KILLING_BLOW)

ZO_CreateStringId("SI_BINDING_NAME_LOCK_UNLOCK_BAR", "Lock/Unlock Bar")
ZO_CreateStringId("SI_BINDING_NAME_LOCK_UNLOCK_GADGETS", "Lock/Unlock Gadgets")