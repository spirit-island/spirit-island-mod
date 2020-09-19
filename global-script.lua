---- Used with Spirit Board Scripts
counterBag = "5f2acb"
minorPowerZone = "cb16ab"
majorPowerZone = "089896"
PlayerBags = {
    ["Red"] = "fb7941",
    ["Purple"] = "8ee413",
    ["Yellow"] = "8aad81",
    ["Blue"] = "f9e149",
    ["Green"] = "9f4841",
    ["Brown"] = "a2f5cc",
}
---- Used with Adversary Scripts
eventDeckZone = "a16796"
invaderDeckZone = "dd0921"
fearDeckZone = "bd8761"
stage1DeckZone = "cf2635"
stage2DeckZone = "7f21be"
stage3DeckZone = "2a9f36"
adversaryBag = "a62bd7"
---- Used with ElementsHelper Script
elementScanZones = {
    ["Red"] = "9fc5a4",
    ["Purple"] = "654ab2",
    ["Yellow"] = "102771",
    ["Blue"] = "6f2249",
    ["Green"] = "190f05",
    ["Brown"] = "61ac7c",
}
----
--[[ unfinished innate code start
function checkInnates(tableIn)
    local pCol = tableIn[1]
    local elementTable = tableIn[2]
    --log(pCol)
    --log(elementTable)
    local board = getSpiritBoard(pCol)
    --if board == nil then log("nil board!") return end
    --log(board)
end
function getSpiritBoard(pCol)
    local hits = Physics.cast({
        origin       = Player[pCol].getHandTransform().position + Vector(0,-3.4,10),
        direction    = {0,1,0},
        type         = 3,
        size         = {1,0.05,1},
        orientation  = {0,1,0},
        max_distance = 0,
        debug        = true,
    })
    --log("_")
    --log(#hits)
    --return nil
end
lightningTab = {
    {
        type = 3,
        num = 3,
        pos = {-0.207,0.2,0.417},
    },{
        type = 4,
        num = 2,
        pos = {-0.08,0.2,0.417},
    }
}
function x()
    if board.getName() == "Lightning's Swift Strike" then
        for _,group in ipairs (lightningTab) do
            for _,test in ipairs (group) do
                log(test)
            end
        end
    end
end
]]--

------ Saved Config Data
BnCAdded = false
JEAdded = false
fearPool = 0
generatedFear = 0
gameStarted = false
difficultyString = ""
blightedIsland = false
adversaryCard = nil
adversaryLevel = 0
adversaryCard2 = nil
adversaryLevel2 = 0
returnBlightBag = nil
explorerBag = "613ea4"
townBag = "4d3c15"
cityBag = "a245f8"
selectedColors = {}
------ Unsaved Config Data
numPlayers = 0
useBlightCard = true
useEventDeck = false
gamePaused = false
boardType = "Standard"
alternateSetupIndex = 1
canStart = true
difficulty = 0
yHeight = 0
stagesSetup = 0
cleanupTimerId = 0
boardsSetup = 0
spiritGuids = {}
spiritTags = {}
spiritChoices = {}
spiritChoicesLength = 0
showAdvancedSettings = true
showRandomizers = false
minDifficulty = 1
maxDifficulty = 11
useSecondAdversary = false
useRandomAdversary = false
includeThematic = false
useRandomBoard = false
------
aidBoard = "bee103"
SetupChecker = "ab0a4e"
fearDeckSetupZone = "fbbf69"
------
dahanBag = "f4c173"
blightBag = "af50b8"
blightBagInfinite = "3595ff"
beastsBag = "a42427"
diseaseBag = "7019af"
wildsBag = "ca5089"
strifeBag = "af4e63"
badlandsBag = "d3f7f8"
-----
StandardMapBag = "9760a2"
ThematicMapBag = "bcd431"
MJThematicMapBag = "95ba87"
seaTile = "5f4be2"
-----
cityHealth = "22928c"
cityDamage = "d8b6c7"
townHealth = "4e6aee"
townDamage = "7f1e11"
explorerHealth = "87ee9c"
explorerDamage = "574835"
dahanHealth = "746488"
dahanDamage = "d936f3"
-----
adversaryGuids = {
    "", -- None
    "dd3d47", -- Prussia
    "b765cf", -- England
    "f114f8", -- Sweden
    "e8f3e3", -- France
    "1d9bcd", -- Habsburg
    "1ea4cf", -- Russia
    "37a592", -- Scotland
}
boardSetupNames = {
    "Standard",
    "Thematic",
    "Thematic Redo",
}
alternateSetupNames = {
    {"Standard"},
    {"Standard","Fragment","Opposite Shores"},
    {"Standard","Coastline","Sunrise"},
    {"Standard","Leaf","Snake"},
    {"Standard","Snail","Peninsula","V"},
    {"Standard","Star","Flower","Caldera"},
}
randomChoices = {
    "Random Spirit",
    "Random JE Spirit",
    "Pick 4",
}
readyTokens = {
    Red = "ab93fc",
    Purple = "d61929",
    Yellow = "747fcb",
    Blue = "3c01e2",
    Green = "88a4c3",
    Brown = "d17f93",
}
interactableObjectsToDisableOnLoad = {
    "57dbb8","fd27d5","25fddc", -- spirit tables
    "dce473","c99d4d","794c81","125e82","d7d593","33c4af", -- player tables
    "a8cd8c", -- top row border
    "1be83c", -- right column border
    "108d0b", -- bottom row border
    "c17411", -- left column border
    "187be2", -- middle column border
    "055a45", -- middle row border
    "5f4be2", -- sea tile
    "235564", -- white box section
    "ab0a4e", -- start menu object
    "6b5b4b","fac8e4","36bbcc","c3c59b","661aa3","c68e2c", -- player counters
}

---- TTS Events Section
function onScriptingButtonDown(index, playerColor)
    if not gameStarted or gamePaused then
        return
    end
    DropMiniature(index, Player[playerColor].getPointerPosition(), playerColor)
end
function onObjectDrop(player_color, dropped_object)
    if gameStarted then
        if dropped_object.getVar("highlightOnObjectDrop") ~= nil then
            if dropped_object.getVar("highlightOnObjectDrop") then
                local dropColor = player_color
                if player_color == "Blue" then
                    dropColor = {0.118, 0.53, 1}
                elseif player_color == "Red" then
                    dropColor = {0.856, 0.1, 0.094}
                elseif player_color == "Yellow" then
                    dropColor = {0.905, 0.898, 0.172}
                elseif player_color == "Purple" then
                    dropColor = {0.627, 0.125, 0.941}
                end
                dropped_object.highlightOn(dropColor, 60)
            end
        end
    end
end
function onObjectEnterScriptingZone(zone, obj)
    if zone.guid == "ac4fad" then
        if gameStarted and not gamePaused then
            if obj.tag ~= "Card" then
                if not zoneDestroyFlag then
                    zoneDestroyFlag = true
                    Wait.time(checkZoneDestroy,1)
                end
            end
        elseif not gameStarted then
            if obj ~= nil and obj.tag == "Card" and obj.getVar("difficulty") then
                local found = false
                for _,guid in pairs(adversaryGuids) do
                    if guid == obj.guid then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(adversaryGuids, obj.guid)
                end
            end
        end
    end
end
function onSave()
    data_table = {
        BnCAdded = BnCAdded,
        JEAdded =  JEAdded,
        fearPool = fearPool,
        generatedFear = generatedFear,
        gameStarted = gameStarted,
        difficultyString = difficultyString,
        blightedIsland = blightedIsland,
        returnBlightBag = returnBlightBag.guid,
        explorerBag = explorerBag.guid,
        townBag = townBag.guid,
        cityBag = cityBag.guid,
        adversaryLevel = adversaryLevel,
        adversaryLevel2 = adversaryLevel2,

        panelInvaderVisibility = UI.getAttribute("panelInvader","visibility"),
        panelAdversaryVisibility = UI.getAttribute("panelAdversary","visibility"),
        panelTurnOrderVisibility = UI.getAttribute("panelTurnOrder","visibility"),
        panelTimePassesVisibility = UI.getAttribute("panelTimePasses","visibility"),
        panelReadyVisibility = UI.getAttribute("panelReady","visibility"),
    }
    if blightedIslandCard ~= nil then
        data_table.blightedIslandGuid = blightedIslandCard.guid
    end
    if adversaryCard ~= nil then
        data_table.adversaryCardGuid = adversaryCard.guid
    end
    if adversaryCard2 ~= nil then
        data_table.adversaryCard2Guid = adversaryCard2.guid
    end
    local savedSelectedColors = {}
    for color,obj in pairs(selectedColors) do
        savedSelectedColors[color] = obj.guid
    end
    data_table.selectedColors = savedSelectedColors
    saved_data = JSON.encode(data_table)
    return saved_data
end
function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    Color.Add("SoftYellow", Color.new(0.9,0.7,0.1))

    for _,v in ipairs(interactableObjectsToDisableOnLoad) do
        if getObjectFromGUID(v) ~= nil then
            getObjectFromGUID(v).setLock(true)
            getObjectFromGUID(v).interactable = false
        end
    end

    ------
    aidBoard = getObjectFromGUID(aidBoard)
    SetupChecker = getObjectFromGUID(SetupChecker)
    adversaryBag = getObjectFromGUID(adversaryBag)
    ------
    dahanBag = getObjectFromGUID(dahanBag)
    explorerBag = getObjectFromGUID(explorerBag)
    townBag = getObjectFromGUID(townBag)
    cityBag = getObjectFromGUID(cityBag)
    blightBag = getObjectFromGUID(blightBag)
    returnBlightBag = blightBag
    blightBagInfinite = getObjectFromGUID(blightBagInfinite)
    diseaseBag = getObjectFromGUID(diseaseBag)
    wildsBag = getObjectFromGUID(wildsBag)
    beastsBag = getObjectFromGUID(beastsBag)
    strifeBag = getObjectFromGUID(strifeBag)
    badlandsBag = getObjectFromGUID(badlandsBag)
    -----
    cityHealth = getObjectFromGUID(cityHealth)
    cityDamage = getObjectFromGUID(cityDamage)
    townHealth = getObjectFromGUID(townHealth)
    townDamage = getObjectFromGUID(townDamage)
    explorerHealth = getObjectFromGUID(explorerHealth)
    explorerDamage = getObjectFromGUID(explorerDamage)
    dahanHealth = getObjectFromGUID(dahanHealth)
    dahanDamage = getObjectFromGUID(dahanDamage)
    -----
    StandardMapBag = getObjectFromGUID(StandardMapBag)
    ThematicMapBag = getObjectFromGUID(ThematicMapBag)
    MJThematicMapBag = getObjectFromGUID(MJThematicMapBag)
    seaTile = getObjectFromGUID(seaTile)
    yHeight = seaTile.getPosition().y + 0.1

    -- Loads the tracking for if the game has started yet
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        gameStarted = loaded_data.gameStarted
        if gameStarted then
            BnCAdded = loaded_data.BnCAdded
            JEAdded = loaded_data.JEAdded
            fearPool = loaded_data.fearPool
            generatedFear = loaded_data.generatedFear
            difficultyString = loaded_data.difficultyString
            blightedIsland = loaded_data.blightedIsland
            blightedIslandCard = getObjectFromGUID(loaded_data.blightedIslandGuid)
            returnBlightBag = getObjectFromGUID(loaded_data.returnBlightBag)
            explorerBag = getObjectFromGUID(loaded_data.explorerBag)
            townBag = getObjectFromGUID(loaded_data.townBag)
            cityBag = getObjectFromGUID(loaded_data.cityBag)
            adversaryCard = getObjectFromGUID(loaded_data.adversaryCardGuid)
            adversaryLevel = loaded_data.adversaryLevel
            adversaryCard2 = getObjectFromGUID(loaded_data.adversaryCard2Guid)
            adversaryLevel2 = loaded_data.adversaryLevel2
            for color,guid in pairs(loaded_data.selectedColors) do
                selectedColors[color] = getObjectFromGUID(guid)
            end

            UI.setAttribute("panelInvader","visibility",loaded_data.panelInvaderVisibility)
            UI.setAttribute("panelAdversary","visibility",loaded_data.panelAdversaryVisibility)
            UI.setAttribute("panelTurnOrder","visibility",loaded_data.panelTurnOrderVisibility)
            UI.setAttribute("panelTimePasses","visibility",loaded_data.panelTimePassesVisibility)
            UI.setAttribute("panelReady","visibility",loaded_data.panelReadyVisibility)
            UI.setAttribute("panelUIToggle","active","true")

            SetupPowerDecks()
            Wait.condition(function()
                aidBoard.call("setupGame", {})
                createDifficultyButton()
            end, function() return not aidBoard.spawning end)
            Wait.condition(adversaryUISetup, function() return (adversaryCard == nil or not adversaryCard.spawning) and (adversaryCard2 == nil or not adversaryCard2.spawning) end)
            Wait.time(readyCheck,1,-1)
            if not blightedIsland then
                Wait.condition(addBlightedIslandButton, function() return not aidBoard.spawning end)
            end
            numPlayers = getMapCount(true, true)
            gamePaused = false
            for _,o in ipairs(getAllObjects()) do
                local t = o.getTable("posMap")
                if t ~= nil and t ~= {} then
                    o.interactable = false -- sets boards to uninteractable after reload
                end
            end
        else
            SetupChecker.createButton({ -- index 0
                click_function = "player1Setup",
                function_owner = Global,
                label          = "1",
                position       = Vector(0,0.3,-9),
                width          = 1000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 1
                click_function = "player2Setup",
                function_owner = Global,
                label          = "2",
                position       = Vector(2.5,0.3,-9),
                width          = 1000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 2
                click_function = "player3Setup",
                function_owner = Global,
                label          = "3",
                position       = Vector(5,0.3,-9),
                width          = 1000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 3
                click_function = "player4Setup",
                function_owner = Global,
                label          = "4",
                position       = Vector(0,0.3,-7.5),
                width          = 1000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 4
                click_function = "player5Setup",
                function_owner = Global,
                label          = "5",
                position       = Vector(2.5,0.3,-7.5),
                width          = 1000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 5
                click_function = "player6Setup",
                function_owner = Global,
                label          = "6",
                position       = Vector(5,0.3,-7.5),
                width          = 1000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 6
                click_function = "SetupGame",
                function_owner = Global,
                label          = "Start Game?",
                position       = Vector(2.5,0.3,8),
                width          = 2000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 7
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Leading\nAdversary",
                font_color     = {1,1,1},
                position       = Vector(0,0.3,-6.25),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 8
                click_function = "adversaryButton",
                function_owner = Global,
                label          = "None",
                position       = Vector(0,0.3,-5),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "A way to make the game more of a challenge, introducing an escalation effect and other rules.",
            })
            SetupChecker.createButton({ -- index 9
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Leading\nAdversary Level",
                font_color     = {1,1,1},
                position       = Vector(0,0.3,-3.75),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 10
                click_function = "levelButton",
                function_owner = Global,
                label          = "---",
                position       = Vector(0,0.3,-2.5),
                width          = 2000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 11
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Difficulty: 0",
                font_color     = {1,1,1},
                position       = Vector(2.5,0.3,-1.25),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 12
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Board Type",
                font_color     = {1,1,1},
                position       = Vector(0,0.3,2.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
           SetupChecker.createButton({ -- index 13
                click_function = "boardTypeF",
                function_owner = Global,
                label          = "Standard",
                position       = Vector(0,0.3,3.5),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "Different island boards that can be played with. The Thematic boards are more difficult but better reflect to shape of the island lore-wise.",
            })
            SetupChecker.createButton({ -- index 14
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Board Layout",
                font_color     = {1,1,1},
                position       = Vector(5,0.3,2.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 15
                click_function = "alternateSetupButton",
                function_owner = Global,
                label          = "Standard",
                position       = Vector(5,0.3,3.5),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "Different ways the island boards can be laid out (can only be used on the standard boards).",
            })
            SetupChecker.createButton({ -- index 16
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Number of Players",
                font_color     = {1,1,1},
                position       = Vector(2.5,0.3,-10),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 17
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Supporting\nAdversary",
                font_color     = {1,1,1},
                position       = Vector(5,0.3,-6.25),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 18
                click_function = "adversaryButton2",
                function_owner = Global,
                label          = "None",
                position       = Vector(5,0.3,-5),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "A way to make the game more of a challenge, playing with two adversaries at the same time.\nOne adversary's escalation will happen in stage 2, and the other's in stage 3, despite there being no escalation symbol.",
            })
            SetupChecker.createButton({ -- index 19
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Supporting\nAdversary Level",
                font_color     = {1,1,1},
                position       = Vector(5,0.3,-3.75),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 20
                click_function = "levelButton2",
                function_owner = Global,
                label          = "---",
                position       = Vector(5,0.3,-2.5),
                width          = 2000,
                height         = 600,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 21
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Blight Card?",
                font_color     = {1,1,1},
                position       = Vector(0,0.3,5),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 22
                click_function = "toggleBlightCard",
                function_owner = Global,
                label          = "Yes",
                position       = Vector(0,0.3,6),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "It is recommended to have no blight card for teaching games.",
            })
            SetupChecker.createButton({ -- index 23
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Event Deck?",
                font_color     = {1,1,1},
                position       = Vector(5,0.3,5),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 24
                click_function = "toggleEventDeck",
                function_owner = Global,
                label          = "No",
                position       = Vector(5,0.3,6),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "If you want to play with expansions, but without the event deck.",
            })
            SetupChecker.createButton({ -- index 25
                click_function = "nullFunc",
                function_owner = Global,
                label          = "Add Expansions",
                font_color     = {1,1,1},
                position       = Vector(2.5,0.3,0),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 26
                click_function = "addExpansionBnC",
                function_owner = Global,
                label          = "Branch & Claw",
                position       = Vector(0,0.3,1),
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "Adds more minor/major/fear/blighted island cards. Introduces event cards and spirit tokens (Beast, Wilds, Disease, Strife)",
            })
            SetupChecker.createButton({ -- index 27
                click_function = "addExpansionJE",
                function_owner = Global,
                label          = "Jagged Earth",
                position       = Vector(5,0.3,1),
                width          = 0,
                height         = 0,
                width          = 2000,
                height         = 600,
                font_size      = 290,
                tooltip        = "Adds more minor/major/fear/blighted island cards. Introduces event cards and spirit tokens (Beast, Wilds, Disease, Strife, Badlands)",
            })
            SetupChecker.createButton({ -- index 28
                click_function = "toggleSettings",
                function_owner = Global,
                label          = "Simplify\nSettings",
                position       = Vector(0,0.3,15),
                width          = 2000,
                height         = 750,
                font_size      = 290,
                tooltip        = "This simplifies the options available for newer players",
            })
            SetupChecker.createButton({ -- index 29
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(17.5,0.3,11.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 30
                click_function = "randomSpirit",
                function_owner = Global,
                label          = "",
                position       = Vector(15,0.3,12.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Will randomly give you any spirit",
            })
            SetupChecker.createButton({ -- index 31
                click_function = "randomJESpirit",
                function_owner = Global,
                label          = "",
                position       = Vector(20,0.3,12.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Will randomly give you a spirit from the Jagged Earth expansion",
            })
            SetupChecker.createButton({ -- index 32
                click_function = "gainSpirit",
                function_owner = Global,
                label          = "",
                position       = Vector(17.5,0.3,14),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Will give you an option of 4 spirits to choose from in your play area",
            })
            SetupChecker.createButton({ -- index 33
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(17.5,0.3,2),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 34
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(17.5,0.3,3),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 35
                click_function = "changeMin",
                function_owner = Global,
                label          = "",
                position       = Vector(15,0.3,4),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Sets the minimum difficulty for the adversary or adversary combination",
            })
            SetupChecker.createButton({ -- index 36
                click_function = "changeMax",
                function_owner = Global,
                label          = "",
                position       = Vector(20,0.3,4),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Sets the maximum difficulty for the adversary or adversary combination",
            })
            SetupChecker.createButton({ -- index 37
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(15,0.3,5.25),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 38
                click_function = "toggleSecondAdvesary",
                function_owner = Global,
                label          = "",
                position       = Vector(15,0.3,6.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "If you would like to play with 1 or 2 adversaries",
            })
            SetupChecker.createButton({ -- index 39
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(20,0.3,5.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 40
                click_function = "toggleRandomAdvesary",
                function_owner = Global,
                label          = "",
                position       = Vector(20,0.3,6.5),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Determines whether to randomly pick an adversary or adversary combination when game starts",
            })
            SetupChecker.createButton({ -- index 41
                click_function = "toggleRandomizers",
                function_owner = Global,
                label          = "Show\nRandomizers",
                position       = Vector(5,0.3,15),
                width          = 2000,
                height         = 750,
                font_size      = 290,
                tooltip        = "Shows the Spirit and Adversary Randomizer buttons",
            })
            SetupChecker.createButton({ -- index 42
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(17.5,0.3,8),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 43
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(15,0.3,9),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 44
                click_function = "toggleThematic",
                function_owner = Global,
                label          = "",
                position       = Vector(15,0.3,10),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "If you would like to include thematic setup in the pool of board configurations",
            })
            SetupChecker.createButton({ -- index 45
                click_function = "nullFunc",
                function_owner = Global,
                label          = "",
                font_color     = {1,1,1},
                position       = Vector(20,0.3,9),
                width          = 0,
                height         = 0,
                font_size      = 290,
            })
            SetupChecker.createButton({ -- index 46
                click_function = "toggleRandomBoard",
                function_owner = Global,
                label          = "",
                position       = Vector(20,0.3,10),
                width          = 0,
                height         = 0,
                font_size      = 290,
                tooltip        = "Determines whether to randomly pick a board configuration when game starts",
            })
            cleanupTimerId = Wait.time(cleanupAdversary,1,-1)
        end
    end
    if Player["White"].seated then Player["White"].changeColor("Red") end
end
----
function readyCheck()
    local colorCount = 0
    local readyCount = 0
    for _,obj in pairs(selectedColors) do
        if not obj.is_face_down and obj.resting then
            readyCount = readyCount + 1
        end
        colorCount = colorCount + 1
    end
    if readyCount >= colorCount and colorCount ~= 0 then
        broadcastToAll("All Players are ready!")
        for _,obj in pairs(selectedColors) do
            obj.flip()
        end
    end
end
---- Setup Buttons Section
function nullFunc()
end
function player6Setup()
    numPlayers = 6
    playerSetup()
end
function player5Setup()
    numPlayers = 5
    playerSetup()
end
function player4Setup()
    numPlayers = 4
    playerSetup()
end
function player3Setup()
    numPlayers = 3
    playerSetup()
end
function player2Setup()
    numPlayers = 2
    playerSetup()
end
function player1Setup()
    numPlayers = 1
    playerSetup()
end
function playerSetup()
    local label = "1"
    if numPlayers == 1 then
        label = "> "..label.." <"
    end
    SetupChecker.editButton({
        index          = 0,
        label          = label,
    })

    local label = "2"
    if numPlayers == 2 then
        label = "> "..label.." <"
    end
    SetupChecker.editButton({
        index          = 1,
        label          = label,
    })

    local label = "3"
    if numPlayers == 3 then
        label = "> "..label.." <"
    end
    SetupChecker.editButton({
        index          = 2,
        label          = label,
    })

    local label = "4"
    if numPlayers == 4 then
        label = "> "..label.." <"
    end
    SetupChecker.editButton({
        index          = 3,
        label          = label,
    })

    local label = "5"
    if numPlayers == 5 then
        label = "> "..label.." <"
    end
    SetupChecker.editButton({
        index          = 4,
        label          = label,
    })

    local label = "6"
    if numPlayers == 6 then
        label = "> "..label.." <"
    end
    SetupChecker.editButton({
        index          = 5,
        label          = label,
    })
    resetAlternateButton()
end
function adversaryButton(_, _, alt_click)
    local adversaryIndex = 1
    for i = 1, #adversaryGuids do
        if adversaryCard == nil then
            adversaryIndex = 1
            break
        elseif adversaryGuids[i] == adversaryCard.guid then
            adversaryIndex = i
            break
        end
    end
    if alt_click then
        adversaryIndex = adversaryIndex - 1
        if adversaryIndex == 0 then
            adversaryIndex = #adversaryGuids
        end
    else
        adversaryIndex = (adversaryIndex % #adversaryGuids) + 1
    end
    adversaryCard = getObjectFromGUID(adversaryGuids[adversaryIndex])
    local label = "None"
    if adversaryCard ~= nil then
        label = adversaryCard.getName()
    end
    SetupChecker.editButton({
        index          = 8,
        label          = label,
    })
    if adversaryIndex == 1 then
        SetupChecker.editButton({
            index          = 10,
            label          = "---",
        })
    else
        SetupChecker.editButton({
            index          = 10,
            label          = adversaryLevel,
        })
    end
    updateDifficulty()
end
function adversaryButton2(_, _, alt_click)
    local adversaryIndex = 1
    for i = 1, #adversaryGuids do
        if adversaryCard2 == nil then
            adversaryIndex = 1
            break
        elseif adversaryGuids[i] == adversaryCard2.guid then
            adversaryIndex = i
            break
        end
    end
    if alt_click then
        adversaryIndex = adversaryIndex - 1
        if adversaryIndex == 0 then
            adversaryIndex = #adversaryGuids
        end
    else
        adversaryIndex = (adversaryIndex % #adversaryGuids) + 1
    end
    adversaryCard2 = getObjectFromGUID(adversaryGuids[adversaryIndex])
    local label = "None"
    if adversaryCard2 ~= nil then
        label = adversaryCard2.getName()
    end
    SetupChecker.editButton({
        index          = 18,
        label          = label,
    })
    if adversaryIndex == 1 then
        SetupChecker.editButton({
            index          = 20,
            label          = "---",
        })
    else
        SetupChecker.editButton({
            index          = 20,
            label          = adversaryLevel2,
        })
    end
    updateDifficulty()
end
function levelButton(_, _, alt_click)
    if adversaryCard == nil then
        broadcastToAll("Select an adversary before setting a level", Color.SoftYellow)
        return
    end
    if alt_click then
        adversaryLevel = (adversaryLevel - 1) % 7
    else
        adversaryLevel = (adversaryLevel + 1) % 7
    end
    SetupChecker.editButton({
        index          = 10,
        label          = adversaryLevel,
    })
    updateDifficulty()
end
function levelButton2(_, _, alt_click)
    if adversaryCard2 == nil then
        broadcastToAll("Select an adversary before setting a level", Color.SoftYellow)
        return
    end
    if alt_click then
        adversaryLevel2 = (adversaryLevel2  - 1) % 7
    else
        adversaryLevel2 = (adversaryLevel2  + 1) % 7
    end
    SetupChecker.editButton({
        index          = 20,
        label          = adversaryLevel2,
    })
    updateDifficulty()
end
function boardTypeF(_, color, alt_click)
    local typeIndex = 1
    for i = 1, #boardSetupNames do
        if boardSetupNames[i] == boardType then
            typeIndex = i
            break
        end
    end
    if alt_click then
        typeIndex = typeIndex - 1
        if typeIndex == 0 then
            typeIndex = #boardSetupNames
        end
    else
        typeIndex = (typeIndex % #boardSetupNames) + 1
    end
    boardType = boardSetupNames[typeIndex]
    SetupChecker.editButton({
        index          = 13,
        label          = boardType,
    })
    updateDifficulty()
end
function alternateSetupButton(_, color, alt_click)
    if numPlayers == 0 then
        broadcastToAll("Select the number of players before changing the board layout", Color.SoftYellow)
        return
      end
    if numPlayers == 1 then
        broadcastToAll("There aren't any alternate board layouts for one player", Color.SoftYellow)
        return
    end
    if boardType == "Thematic" or boardType == "Thematic Redo" then
        broadcastToAll("There aren't any alternate board layouts for the Thematic Boards", Color.SoftYellow)
        return
    end

    if alt_click then
        alternateSetupIndex = alternateSetupIndex - 1
        if alternateSetupIndex == 0 then
            alternateSetupIndex = #alternateSetupNames[numPlayers]
        end
    else
        alternateSetupIndex = (alternateSetupIndex % #alternateSetupNames[numPlayers]) + 1
    end
    SetupChecker.editButton({
        index          = 15,
        label          = alternateSetupNames[numPlayers][alternateSetupIndex],
    })
end
function toggleBlightCard()
    useBlightCard = not useBlightCard
    if useBlightCard then
        SetupChecker.editButton({
            index          = 22,
            label          = "Yes",
        })
    else
        SetupChecker.editButton({
            index          = 22,
            label          = "No",
        })
    end
end
function toggleEventDeck()
    if not BnCAdded and not JEAdded then
        broadcastToAll("The Branch & Claw or Jagged Earth expansions are required to use Event Deck", Color.SoftYellow)
        return
    end
    useEventDeck = not useEventDeck
    if useEventDeck then
        SetupChecker.editButton({
            index          = 24,
            label          = "Yes",
        })
    else
        SetupChecker.editButton({
            index          = 24,
            label          = "No",
        })
    end
end
function addExpansionBnC()
    SetupChecker.editButton({
        index          = 26,
        label          = "",
        width          = 0,
        height         = 0,
    })
    Wait.condition(function() startLuaCoroutine(Global, "addBnCCardsCo") end, function() return canStart end)
end
function addExpansionJE()
    SetupChecker.editButton({
        index          = 27,
        label          = "",
        width          = 0,
        height         = 0,
    })
    Wait.condition(function() startLuaCoroutine(Global, "addJECardsCo") end, function() return canStart end)
end
function SetupGame()
    if not canStart then
        broadcastToAll("Please wait, an expansion's cards haven't been added yet", Color.SoftYellow)
        return 0
    end
    if getMapCount(true, true) == 0 and numPlayers == 0 then
        broadcastToAll("Select the number of players before starting the game", Color.SoftYellow)
        return 0
    end
    if getMapCount(true, false) > 0 and getMapCount(false, true) > 0 then
        broadcastToAll("You can only have one type of board at once", Color.SoftYellow)
        return 0
    end
    if useRandomAdversary then
        randomAdversary()
    end
    if adversaryCard == nil and adversaryCard2 ~= nil then
        broadcastToAll("A Leading Adversary is Required to use a Supporting Adversary", Color.SoftYellow)
        return 0
    end
    if adversaryCard ~= nil and adversaryCard == adversaryCard2 then
        broadcastToAll("The Leading and Supporting Adversary cannot be the same", Color.SoftYellow)
        return 0
    end
    if adversaryCard == nil then
        adversaryLevel = 0
    end
    if adversaryCard2 == nil then
        adversaryLevel2 = 0
    end
    -- Map tiles are guaranteed to be of only one type
    local mapCount = getMapCount(true, true)
    if mapCount > 0 then
        numPlayers = mapCount
    end
    if useRandomBoard then
        randomBoard()
    end

    Wait.stop(cleanupTimerId)
    SetupChecker.clearButtons()

    startLuaCoroutine(Global, "PreSetup")
    Wait.condition(function()
        startLuaCoroutine(Global, "SetupFear")
        startLuaCoroutine(Global, "SetupPowerDecks")
        startLuaCoroutine(Global, "SetupBlightCard")
        startLuaCoroutine(Global, "SetupAdversary")
        startLuaCoroutine(Global, "SetupInvaderDeck")
        startLuaCoroutine(Global, "SetupEventDeck")
        startLuaCoroutine(Global, "SetupMap")
    end, function() return stagesSetup == 1 end)
    Wait.condition(function() startLuaCoroutine(Global, "PostSetup") end, function() return stagesSetup == 8 end)
    Wait.condition(function() startLuaCoroutine(Global, "StartGame") end, function() return stagesSetup == 9 end)
end
function toggleSettings()
    showAdvancedSettings = not showAdvancedSettings
    if showAdvancedSettings then  --Unsimplify
        SetupChecker.editButton({
            index = 6,
            position = Vector(2.5,0.3,8),
        })
        SetupChecker.editButton({
            index = 7,
            label = "Leading\nAdversary",
            position = Vector(0,0.3,-6.25),
        })
        SetupChecker.editButton({
            index = 8,
            position = Vector(0,0.3,-5),
        })
        SetupChecker.editButton({
            index = 9,
            label = "Leading\nAdversary Level",
            position = Vector(0,0.3,-3.75),
        })
        SetupChecker.editButton({
            index = 10,
            position = Vector(0,0.3,-2.5),
        })
        SetupChecker.editButton({
            index = 12,
            label = "Board Type",
        })
        SetupChecker.editButton({
            index = 13,
            label = boardType,
            width = 2000,
            height = 600,
        })
        SetupChecker.editButton({
            index = 14,
            label = "Board Layout",
        })
        local label = "Standard"
        if numPlayers ~= 0 then
            label = alternateSetupNames[numPlayers][alternateSetupIndex]
        end
        SetupChecker.editButton({
            index = 15,
            label = label,
            width = 2000,
            height = 600,
        })
        SetupChecker.editButton({
            index = 17,
            label = "Supporting\nAdversary",
        })
        label = "None"
        if adversaryCard2 ~= nil then
            label = adversaryCard2.getName()
        end
        SetupChecker.editButton({
            index = 18,
            label = label,
            width = 2000,
            height = 600,
        })
        SetupChecker.editButton({
            index = 19,
            label = "Supporting\nAdversary Level",
        })
        label = "---"
        if adversaryCard2 ~= nil then
            label = adversaryLevel2
        end
        SetupChecker.editButton({
            index = 20,
            label = label,
            width  = 2000,
            height = 600,
        })
        SetupChecker.editButton({
            index = 21,
            position = Vector(0,0.3,5),
        })
        SetupChecker.editButton({
            index = 22,
            position = Vector(0,0.3,6),
        })
        SetupChecker.editButton({
            index = 23,
            position = Vector(5,0.3,5),
        })
        SetupChecker.editButton({
            index = 24,
            position = Vector(5,0.3,6),
        })
        SetupChecker.editButton({
            index = 28,
            label = "Simplify\nSettings",
        })
    else   --Simplify
        SetupChecker.editButton({
            index = 6,
            position = Vector(2.5,0.3,5.5),
        })
        SetupChecker.editButton({
            index = 7,
            label = "Adversary",
            position = Vector(2.5,0.3,-6),
        })
        SetupChecker.editButton({
            index = 8,
            position = Vector(2.5,0.3,-5),
        })
        SetupChecker.editButton({
            index = 9,
            label = "Adversary Level",
            position = Vector(2.5,0.3,-3.5),
        })
        SetupChecker.editButton({
            index = 10,
            position = Vector(2.5,0.3,-2.5),
        })
        SetupChecker.editButton({
            index = 12,
            label = "",
        })
        SetupChecker.editButton({
            index = 13,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 14,
            label = "",
        })
        SetupChecker.editButton({
            index = 15,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 17,
            label = "",
        })
        SetupChecker.editButton({
            index = 18,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 19,
            label = "",
        })
        SetupChecker.editButton({
            index = 20,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 21,
            position = Vector(0,0.3,2.5),
        })
        SetupChecker.editButton({
            index = 22,
            position = Vector(0,0.3,3.5),
        })
        SetupChecker.editButton({
            index = 23,
            position = Vector(5,0.3,2.5),
        })
        SetupChecker.editButton({
            index = 24,
            position = Vector(5,0.3,3.5),
        })
        SetupChecker.editButton({
            index = 28,
            label = "Unsimplify\nSettings",
        })
    end
end
function toggleRandomizers()
    showRandomizers = not showRandomizers
    if showRandomizers then
        SetupChecker.editButton({
            index = 29,
            label = "Spirit Randomizer",
        })
        SetupChecker.editButton({
            index = 30,
            label = "Random Spirit",
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 31,
            label = "Random JE Spirit",
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 32,
            label = "\"Gain a Spirit\"",
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 33,
            label = "Adversary Randomizer",
        })
        SetupChecker.editButton({
            index = 34,
            label = "Min/Max Difficulty",
        })
        SetupChecker.editButton({
            index = 35,
            label = minDifficulty,
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 36,
            label = maxDifficulty,
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 37,
            label = "Supporting\nAdversary?",
        })
        label = "No"
        if useSecondAdversary then
            label = "Yes"
        end
        SetupChecker.editButton({
            index = 38,
            label = label,
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 39,
            label = "Enable?",
        })
        local label = "No"
        if useRandomAdversary then
            label = "Yes"
        end
        SetupChecker.editButton({
            index = 40,
            label = label,
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 41,
            label = "Hide\nRandomizers",
        })
        SetupChecker.editButton({
            index = 42,
            label = "Board Randomizers",
        })
        SetupChecker.editButton({
            index = 43,
            label = "Include Thematic?",
        })
        label = "No"
        if includeThematic then
            label = "Yes"
        end
        SetupChecker.editButton({
            index = 44,
            label = label,
            width = 2200,
            height = 600,
        })
        SetupChecker.editButton({
            index = 45,
            label = "Enable?",
        })
        local label = "No"
        if useRandomBoard then
            label = "Yes"
        end
        SetupChecker.editButton({
            index = 46,
            label = label,
            width = 2200,
            height = 600,
        })
    else
        SetupChecker.editButton({
            index = 29,
            label = "",
        })
        SetupChecker.editButton({
            index = 30,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 31,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 32,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 33,
            label = "",
        })
        SetupChecker.editButton({
            index = 34,
            label = "",
        })
        SetupChecker.editButton({
            index = 35,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 36,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 37,
            label = "",
        })
        SetupChecker.editButton({
            index = 38,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 39,
            label = "",
        })
        SetupChecker.editButton({
            index = 40,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 41,
            label = "Show\nRandomizers",
        })
        SetupChecker.editButton({
            index = 42,
            label = "",
        })
        SetupChecker.editButton({
            index = 43,
            label = "",
        })
        SetupChecker.editButton({
            index = 44,
            label = "",
            width = 0,
            height = 0,
        })
        SetupChecker.editButton({
            index = 45,
            label = "",
        })
        SetupChecker.editButton({
            index = 46,
            label = "",
            width = 0,
            height = 0,
        })
    end
end
function randomSpirit(_, color)
    local spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    spirit.call("PickSpirit", {color = color, random = {aspect = true}})
    broadcastToColor("Your randomised spirit is "..spirit.getName(), color, "Blue")
end
function randomJESpirit(_, color)
    local guid = spiritGuids[math.random(1,#spiritGuids)]
    while(spiritTags[guid] ~= "JE") do
        guid = spiritGuids[math.random(1,#spiritGuids)]
    end
    local spirit = getObjectFromGUID(guid)
    spirit.call("PickSpirit", {color = color, random = {aspect = true}})
    broadcastToColor("Your randomised Jagged Earth spirit is "..spirit.getName(), color, "Blue")
end
function gainSpirit(_, color)
    local obj = getObjectFromGUID(elementScanZones[color])
    if obj.getButtons() ~= nil and #obj.getButtons() ~= 0 then
        broadcastToColor("You already have Spirit options", color, Color.SoftYellow)
        return
    elseif getObjectFromGUID(PlayerBags[color]).getObjects() == 0 then
        broadcastToColor("You already picked a spirit", color, Color.SoftYellow)
        return
    end
    broadcastToColor("Your 4 randomised spirits to choose from are in your play area", color, Color.SoftBlue)

    local spirit1 = getNewSpirit()
    local spirit2 = getNewSpirit()
    local spirit3 = getNewSpirit()
    local spirit4 = getNewSpirit()

    if spirit1 ~= nil then
        obj.createButton({
            click_function = "pickSpirit1",
            function_owner = Global,
            label = spirit1.getName(),
            position = Vector(0,0,-0.15),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
    if spirit2 ~= nil then
        obj.createButton({
            click_function = "pickSpirit2",
            function_owner = Global,
            label = spirit2.getName(),
            position = Vector(0,0,-0.3),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
    if spirit3 ~= nil then
        obj.createButton({
            click_function = "pickSpirit3",
            function_owner = Global,
            label = spirit3.getName(),
            position = Vector(0,0,-0.45),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
    if spirit4 ~= nil then
        obj.createButton({
            click_function = "pickSpirit4",
            function_owner = Global,
            label = spirit4.getName(),
            position = Vector(0,0,-0.6),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
end
function changeMin(_, _, alt_click)
    if alt_click then
        local minValue = 1
        if minDifficulty < minValue then
            broadcastToAll("Min Difficulty Level cannot be lower than "..minValue, Color.SoftYellow)
            minDifficulty = minValue
        elseif minDifficulty == minValue then
            broadcastToAll("Min Difficulty Level cannot be lower than "..minValue, Color.SoftYellow)
        else
            minDifficulty = minDifficulty - 1
        end
    else
        if minDifficulty < maxDifficulty then
            minDifficulty = minDifficulty + 1
        elseif minDifficulty == maxDifficulty then
            broadcastToAll("Min Difficulty Level cannot be higher than max", Color.SoftYellow)
        else
            broadcastToAll("Min Difficulty Level cannot be higher than max", Color.SoftYellow)
            minDifficulty = maxDifficulty
        end
    end
    SetupChecker.editButton({
        index = 35,
        label = minDifficulty,
    })
    updateRandomAdversary()
end
function changeMax(_, _, alt_click)
    if alt_click then
        if maxDifficulty < minDifficulty then
            broadcastToAll("Max Difficulty Level cannot be lower than min", Color.SoftYellow)
            maxDifficulty = minDifficulty
        elseif maxDifficulty == minDifficulty then
            broadcastToAll("Max Difficulty Level cannot be lower than min", Color.SoftYellow)
        else
            maxDifficulty = maxDifficulty - 1
        end
    else
        local maxValue = 11
        if useSecondAdversary then
            maxValue = 16
        end
        if maxDifficulty < maxValue then
            maxDifficulty = maxDifficulty + 1
        elseif maxDifficulty == maxValue then
            broadcastToAll("Max Difficulty Level cannot be higher than "..maxValue, Color.SoftYellow)
        else
            broadcastToAll("Max Difficulty Level cannot be higher than "..maxValue, Color.SoftYellow)
            maxDifficulty = maxValue
        end
    end
    SetupChecker.editButton({
        index = 36,
        label = maxDifficulty,
    })
    updateRandomAdversary()
end
function toggleSecondAdvesary()
    useSecondAdversary = not useSecondAdversary
    if useSecondAdversary then
        if maxDifficulty < 2 then
            maxDifficulty = 2
            SetupChecker.editButton({
                index = 36,
                label = maxDifficulty,
            })
        end
        SetupChecker.editButton({
            index = 38,
            label = "Yes",
        })
    else
        if minDifficulty > 11 then
            minDifficulty = 11
            SetupChecker.editButton({
                index = 35,
                label = minDifficulty,
            })
        end
        if maxDifficulty > 11 then
            maxDifficulty = 11
            SetupChecker.editButton({
                index = 36,
                label = maxDifficulty,
            })
        end
        SetupChecker.editButton({
            index = 38,
            label = "No",
        })
    end
    updateRandomAdversary()
end
function toggleRandomAdvesary()
    useRandomAdversary = not useRandomAdversary
    if useRandomAdversary then
        SetupChecker.editButton({
            index = 40,
            label = "Yes",
        })
    else
        SetupChecker.editButton({
            index = 40,
            label = "No",
        })
    end
end
function toggleThematic()
    includeThematic = not includeThematic
    if includeThematic then
        SetupChecker.editButton({
            index = 44,
            label = "Yes",
        })
    else
        SetupChecker.editButton({
            index = 44,
            label = "No",
        })
    end
    updateRandomBoard()
end
function toggleRandomBoard()
    useRandomBoard = not useRandomBoard
    if useRandomBoard then
        SetupChecker.editButton({
            index = 46,
            label = "Yes",
        })
    else
        SetupChecker.editButton({
            index = 46,
            label = "No",
        })
    end
end
---- Setup Button Helpers Section
function updateDifficulty()
    difficulty = 0
    if adversaryCard ~= nil then
        difficulty = difficulty + adversaryCard.getVar("difficulty")[adversaryLevel]
    end
    if adversaryCard2 ~= nil then
        local difficulty2 = adversaryCard2.getVar("difficulty")[adversaryLevel2]
        if difficulty > difficulty2 then
            difficulty = difficulty + (0.5 * difficulty2)
        else
            difficulty = (0.5 * difficulty) + difficulty2
        end
    end
    if boardType == "Thematic" or boardType == "Thematic Redo" then
        if BnCAdded or JEAdded then
            difficulty = difficulty + 1
        else
            difficulty = difficulty + 3
        end
    end
    SetupChecker.editButton({
        index          = 11,
        label          = "Difficulty: "..difficulty,
    })
end
function resetAlternateButton()
    alternateSetupIndex = 1
    if showAdvancedSettings then
        SetupChecker.editButton({
            index = 15,
            label = alternateSetupNames[numPlayers][alternateSetupIndex],
        })
    end
end
function updateRandomAdversary()
    if not useRandomAdversary then
        useRandomAdversary = true
        SetupChecker.editButton({
            index = 40,
            label = "Yes",
        })
    end
end
function updateRandomBoard()
    if not useRandomBoard then
        useRandomBoard = true
        SetupChecker.editButton({
            index = 46,
            label = "Yes",
        })
    end
end
function addBnCCardsCo()
    canStart = false
    BnCAdded = true
    updateDifficulty()

    useEventDeck = true
    SetupChecker.editButton({
        index = 24,
        label = "Yes",
    })
    local BnCBag = getObjectFromGUID("ea7207")

    local fearDeck = BnCBag.takeObject({guid = "d16f70"})
    getObjectFromGUID(fearDeckSetupZone).getObjects()[1].putObject(fearDeck)
    local minorPowers = BnCBag.takeObject({guid = "913789"})
    getObjectFromGUID(minorPowerZone).getObjects()[1].putObject(minorPowers)
    local majorPowers = BnCBag.takeObject({guid = "07ac50"})
    getObjectFromGUID(majorPowerZone).getObjects()[1].putObject(majorPowers)
    local blightCards = BnCBag.takeObject({guid = "788333"})
    getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)
    BnCBag.takeObject({
        guid = "05f7b7",
        position = getObjectFromGUID("b18505").getPosition(),
        rotation = {0,180,180},
    })

    wt(0.5)
    canStart = true
    return 1
end

function addJECardsCo()
    canStart = false
    JEAdded = true
    updateDifficulty()

    useEventDeck = true
    SetupChecker.editButton({
        index = 24,
        label = "Yes",
    })
    local JEBag = getObjectFromGUID("850ac1")

    local fearDeck = JEBag.takeObject({guid = "723183"})
    getObjectFromGUID(fearDeckSetupZone).getObjects()[1].putObject(fearDeck)
    local minorPowers = JEBag.takeObject({guid = "80b54a"})
    getObjectFromGUID(minorPowerZone).getObjects()[1].putObject(minorPowers)
    local majorPowers = JEBag.takeObject({guid = "98a916"})
    getObjectFromGUID(majorPowerZone).getObjects()[1].putObject(majorPowers)
    local blightCards = JEBag.takeObject({guid = "8120e0"})
    getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)
    JEBag.takeObject({
        guid = "299e38",
        position = getObjectFromGUID("b18505").getPosition(),
        rotation = {0,180,180},
    })

    wt(0.5)
    canStart = true
    return 1
end

function cleanupAdversary()
    local adversaryRemoved = false
    for i,v in pairs(adversaryGuids) do
        if v ~= "" then
            local obj = getObjectFromGUID(v)
            if obj == nil then
                table.remove(adversaryGuids, i)
                adversaryRemoved = true
            end
        end
    end
    if adversaryRemoved then
        removeAdversary()
    end
end
function removeAdversary()
    local resetCard = false
    if adversaryCard == nil then
        resetCard = true
        SetupChecker.editButton({
            index          = 8,
            label          = "None",
        })
        SetupChecker.editButton({
            index          = 10,
            label          = "---",
        })
    end
    if adversaryCard2 == nil then
        resetCard = true
        SetupChecker.editButton({
            index          = 18,
            label          = "None",
        })
        SetupChecker.editButton({
            index          = 20,
            label          = "---",
        })
    end
    if resetCard then
        updateDifficulty()
    end
end
function getNewSpirit()
    if spiritChoicesLength >= #spiritGuids then
        return nil
    end
    local spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    while (spiritChoices[spirit.getName()]) do
        spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    end
    spiritChoices[spirit.getName()] = spirit.guid
    spiritChoicesLength = spiritChoicesLength + 1
    return spirit
end
function pickSpirit1(obj, color)
    if elementScanZones[color] ~= obj.guid then return end
    pickSpirit(obj, 0, color)
end
function pickSpirit2(obj, color)
    if elementScanZones[color] ~= obj.guid then return end
    pickSpirit(obj, 1, color)
end
function pickSpirit3(obj, color)
    if elementScanZones[color] ~= obj.guid then return end
    pickSpirit(obj, 2, color)
end
function pickSpirit4(obj, color)
    if elementScanZones[color] ~= obj.guid then return end
    pickSpirit(obj, 3, color)
end
function pickSpirit(obj, index, color)
    local name = obj.getButtons()[index+1].label
    if isSpiritPickable(spiritChoices[name]) then
        getObjectFromGUID(spiritChoices[name]).call("PickSpirit", {color = color, random = {aspect = true}})
        obj.clearButtons()
    else
        broadcastToColor("Spirit unavailable getting new one", color, Color.SoftYellow)
        local spirit = getNewSpirit()
        if spirit ~= nil then
            obj.editButton({
                index = index,
                label = spirit.getName(),
            })
        else
            obj.editButton({
                index = index,
                label = "",
                width = 0,
                height = 0,
            })
        end
    end
end
function isSpiritPickable(guid)
    for _,v in pairs(spiritGuids) do
        if v == guid then
            return true
        end
    end
    return false
end
function randomAdversary()
    if not useSecondAdversary then
        local adversary = getObjectFromGUID(adversaryGuids[math.random(2,#adversaryGuids)])
        local difficulty = adversary.getVar("difficulty")
        local combos = {}
        for i,v in pairs(difficulty) do
            if v >= minDifficulty and v <= maxDifficulty then
                table.insert(combos, i)
            elseif v > maxDifficulty then
                break
            end
        end
        if #combos ~= 0 then
            local index = math.random(1,#combos)
            adversaryCard = adversary
            adversaryLevel = combos[index]
            adversaryCard2 = nil
            adversaryLevel2 = 0
            updateDifficulty()
            broadcastToAll("Your randomised adversary is "..adversaryCard.getName(), "Blue")
        else
            randomAdversary()
        end
    else
        local adversary = getObjectFromGUID(adversaryGuids[math.random(2,#adversaryGuids)])
        local adversary2 = getObjectFromGUID(adversaryGuids[math.random(2,#adversaryGuids)])
        while (#adversaryGuids > 2 and adversary2 == adversary) do
            adversary2 = getObjectFromGUID(adversaryGuids[math.random(2,#adversaryGuids)])
        end
        local difficulty = adversary.getVar("difficulty")
        local difficulty2 = adversary2.getVar("difficulty")
        local combos = {}
        for i,v in pairs(difficulty) do
            for j,w in pairs(difficulty2) do
                local tempDifficulty = 0
                if v > w then
                    tempDifficulty = v + (0.5 * w)
                else
                    tempDifficulty = (0.5 * v) + w
                end
                if tempDifficulty >= minDifficulty and tempDifficulty <= maxDifficulty then
                    table.insert(combos, {i,j})
                elseif tempDifficulty > maxDifficulty then
                    break
                end
            end
        end
        if #combos ~= 0 then
            local index = math.random(1,#combos)
            adversaryCard = adversary
            adversaryLevel = combos[index][1]
            adversaryCard2 = adversary2
            adversaryLevel2 = combos[index][2]
            updateDifficulty()
            broadcastToAll("Your randomised adversaries are "..adversaryCard.getName().." and "..adversaryCard2.getName(), "Blue")
        else
            randomAdversary()
        end
    end
end
function randomBoard()
    local min = 1
    if includeThematic then
        min = 0
    end
    local value = math.random(min,#alternateSetupNames[numPlayers])
    if value == 0 then
        boardType = boardSetupNames[2]
        alternateSetupIndex = 1
    else
        boardType = boardSetupNames[1]
        alternateSetupIndex = value
    end
end
----- Pre Setup Section
function PreSetup()
    local adversariesSetup = 0
    if adversaryCard ~= nil and adversaryCard.getVar("preSetup") then
        adversaryCard.call("PreSetup",{level = adversaryLevel})
        Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard.getVar("preSetupComplete") end)
    else
        adversariesSetup = adversariesSetup + 1
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("preSetup") then
        -- Wait for first adversary to finish
        Wait.condition(function()
            adversaryCard2.call("PreSetup",{level = adversaryLevel2})
            Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard2.getVar("preSetupComplete") end)
        end, function() return adversariesSetup == 1 end)
    else
        adversariesSetup = adversariesSetup + 1
    end
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return adversariesSetup == 2 end)
    return 1
end
----- Fear Section
function SetupFear()
    setupFearTokens()

    fearCards = {3,3,3}
    if adversaryCard ~= nil then
        local extraFearCards = adversaryCard.getVar("fearCards")[adversaryLevel]
        fearCards[1] = fearCards[1] + extraFearCards[1]
        fearCards[2] = fearCards[2] + extraFearCards[2]
        fearCards[3] = fearCards[3] + extraFearCards[3]
    end
    if adversaryCard2 ~= nil then
        local extraFearCards = adversaryCard2.getVar("fearCards")[adversaryLevel2]
        fearCards[1] = fearCards[1] + extraFearCards[1]
        fearCards[2] = fearCards[2] + extraFearCards[2]
        fearCards[3] = fearCards[3] + extraFearCards[3]
    end
    if not useEventDeck and (BnCAdded or JEAdded) then
        fearCards[2] = fearCards[2] + 1
    end

    local zone = getObjectFromGUID(fearDeckZone)
    local fearDeck = getObjectFromGUID(fearDeckSetupZone).getObjects()[1]
    -- include the two terror dividers
    local maxCards = #fearDeck.getObjects() + 2
    local count = 0
    local cardTable = {}
    local cardsLoaded = 0

    fearDeck.shuffle()
    for w=1, fearCards[3] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", "Red")
            break
        end
        local card = fearDeck.takeObject({
            position       = zone.getPosition() + Vector(count,0,0),
            rotation       = Vector(0, 180, 180),
            callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
        })
        count = count + 1
        table.insert(cardTable, card)
    end

    local card = getObjectFromGUID("4211e9")
    card.setPositionSmooth(zone.getPosition() + Vector(count,0,0))
    count = count + 1
    cardsLoaded = cardsLoaded + 1
    table.insert(cardTable, card)

    fearDeck.shuffle()
    for w=1, fearCards[2] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", "Red")
            break
        end
        local card = fearDeck.takeObject({
            position       = zone.getPosition() + Vector(count,0,0),
            rotation       = Vector(0, 180, 180),
            callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
        })
        count = count + 1
        table.insert(cardTable, card)
    end

    card = getObjectFromGUID("2b7d0b")
    card.setPositionSmooth(zone.getPosition() + Vector(count,0,0))
    count = count + 1
    cardsLoaded = cardsLoaded + 1
    table.insert(cardTable, card)

    fearDeck.shuffle()
    for w=1, fearCards[1] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", "Red")
            break
        end
        local card = fearDeck.takeObject({
            position       = zone.getPosition() + Vector(count,0,0),
            rotation       = Vector(0, 180, 180),
            callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
        })
        count = count + 1
        table.insert(cardTable, card)
    end

    Wait.condition(function() group(cardTable) end, function() return cardsLoaded == count end)
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() local objs = zone.getObjects() return #objs == 1 and objs[1].tag == "Deck" and #objs[1].getObjects() == count end)
    return 1
end
function setupFearTokens()
    local fearMulti = 4
    if adversaryCard ~= nil then
        local fearTokens = adversaryCard.getVar("fearTokens")
        if fearTokens ~= nil then
            fearMulti = fearMulti + fearTokens[adversaryLevel]
        end
    end
    if adversaryCard2 ~= nil then
        local fearTokens = adversaryCard2.getVar("fearTokens")
        if fearTokens ~= nil then
            fearMulti = fearMulti + fearTokens[adversaryLevel2]
        end
    end
    fearPool = fearMulti * numPlayers
    aidBoard.editButton({index = 1, label = tostring(fearPool)})
    aidBoard.editButton({index = 2, label = 0})
end
----- Minor/Major Power Section
function SetupPowerDecks()
    getObjectFromGUID(minorPowerZone).getObjects()[1].shuffle()
    getObjectFromGUID(majorPowerZone).getObjects()[1].shuffle()

    SetupChecker.setScale(Vector(1,1,1))
    SetupChecker.setPositionSmooth(Vector(-41.95,0.2,-7.97))

    Wait.condition(function()
        SetupChecker.createButton({
            click_function = "MajorPowerC",
            function_owner = Global,
            label          = "Gain a\nMajor",
            position       = Vector(0,0.8, -2.2),
            width          = 1600,
            height         = 1500,
            font_size      = 500,
            tooltip        = "Click to learn a Major Power",
        })
        SetupChecker.createButton({
            click_function = "MinorPowerC",
            function_owner = Global,
            label          = "Gain a\nMinor",
            position       = Vector(0, 0.8, 2.6),
            width          = 1600,
            height         = 1500,
            font_size      = 500,
            tooltip        = "Click to learn a Minor Power",
        })
        stagesSetup = stagesSetup + 1
    end, function() return not SetupChecker.isSmoothMoving() end)
    return 1
end
scriptWorkingCardC = false
powerColor = nil
function MajorPowerC(obj, player_color)
    -- protection from double clicking
    if scriptWorkingCardC then return end

    scriptWorkingCardC = true
    powerColor = player_color
    startLuaCoroutine(Global, "MajorPower")
end
function MinorPowerC(obj, player_color)
    -- protection from double clicking
    if scriptWorkingCardC then return end

    scriptWorkingCardC = true
    powerColor = player_color
    startLuaCoroutine(Global, "MinorPower")
end
handOffset = Vector(0,0,35)
function getPowerZoneObjects(handP)
    local hits = upCastPosSizRot(
        handOffset + Vector(handP.x,yHeight,handP.z), -- pos
        Vector(15,1,4),  -- size
        Vector(0,0,0),  --  rotation
        1,  -- distance
        1,  -- multi
        {"Card","Deck"})
    return hits
end
function MinorPower()
    local MinorPowerDeckZone = getObjectFromGUID(minorPowerZone)
    local MinorPowerDiscardZone = getObjectFromGUID("55b275")
    DealPowerCards(MinorPowerDeckZone, MinorPowerDiscardZone, "PickPowerMinor")
    return 1
end
function MajorPower()
    local MajorPowerDeckZone = getObjectFromGUID(majorPowerZone)
    local MajorPowerDiscardZone = getObjectFromGUID("eaf864")
    DealPowerCards(MajorPowerDeckZone, MajorPowerDiscardZone, "PickPowerMajor")
    return 1
end
function DealPowerCards(deckZone, discardZone, clickFunctionName)
    -- clear the zone!
    local handPos = Player[powerColor].getHandTransform().position
    local discardTable = DiscardPowerCards(handPos, discardZone)
    if #discardTable > 0 then
        wt(1)
    end

    local xPadding = 4.4
    local cardPlaceOffsetXs = {
        -(2.5*xPadding)+1*xPadding,
        -(2.5*xPadding)+2*xPadding,
        -(2.5*xPadding)+3*xPadding,
        -(2.5*xPadding)+4*xPadding,
    }
    local cardToAdd = 1
    local cardsResting = 0
    local powerDealCentre = handOffset + Vector(handPos.x,yHeight,handPos.z)

    local Deck = deckZone.getObjects()
    if Deck[1] == nil then
    elseif Deck[1].tag == "Card" then
        Deck[1].setLock(true)
        Deck[1].setPositionSmooth(powerDealCentre + Vector(cardPlaceOffsetXs[1],0,0))
        Deck[1].setRotationSmooth(Vector(0, 180, 0))
        CreatePickPowerButton(Deck[1], clickFunctionName)
        cardToAdd = cardToAdd + 1
        Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not Deck[1].isSmoothMoving() end)
    elseif Deck[1].tag == "Deck" then
        for i=1, math.min(Deck[1].getQuantity(), 4) do
            local tempCard = Deck[1].takeObject({
                position       = powerDealCentre + Vector(cardPlaceOffsetXs[i],0,0),
                flip           = true
            })
            tempCard.setLock(true)
            CreatePickPowerButton(tempCard, clickFunctionName)
            cardToAdd = cardToAdd + 1
            Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not tempCard.isSmoothMoving() end)
        end
    end
    if cardToAdd <= 4 then
        Deck = discardZone.getObjects()
        Deck[1].setPositionSmooth(deckZone.getPosition(), false, true)
        Deck[1].setRotationSmooth(Vector(0, 180, 180), false, true)
        Deck[1].shuffle()
        wt(0.5)

        for i=cardToAdd, math.min(Deck[1].getQuantity(), 4) do
            local tempCard = Deck[1].takeObject({
                position       = powerDealCentre + Vector(cardPlaceOffsetXs[i],0,0),
                flip           = true
            })
            tempCard.setLock(true)
            CreatePickPowerButton(tempCard, clickFunctionName)
            cardToAdd = cardToAdd + 1
            Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not tempCard.isSmoothMoving() end)
        end
    end
    Wait.condition(function() scriptWorkingCardC = false end, function() return cardsResting == cardToAdd - 1 end)
end
function CreatePickPowerButton(card, clickFunctionName)
    card.createButton({
        click_function = clickFunctionName,
        function_owner = Global,
        label          = "Pick Power",
        position       = Vector(0,0.3,1.47),
        width          = 900,
        scale            = Vector(0.9,1,0.5),
        height         = 200,
        font_size      = 180,
        tooltip = "Pick Power Card to your hand"
    })
end
function PickPowerMinor(cardo,playero,alt_click)
    -- Give card to player regardless of who’s hand they are in front of
    cardo.deal(1,playero)
    cardo.clearButtons()

    Wait.condition(function()
        cardo.setLock(false)
        if not alt_click then
            local handPos = Player[playero].getHandTransform().position
            local minorDiscardZone = getObjectFromGUID("55b275")
            DiscardPowerCards(handPos, minorDiscardZone)
        end
    end, function() return not cardo.isSmoothMoving() end)
end
function PickPowerMajor(cardo,playero,alt_click)
    -- Give card to player regardless of who’s hand they are in front of
    cardo.deal(1,playero)
    cardo.clearButtons()

    Wait.condition(function()
        cardo.setLock(false)
        if not alt_click then
            local handPos = Player[playero].getHandTransform().position
            local majorDiscardZone = getObjectFromGUID("eaf864")
            DiscardPowerCards(handPos, majorDiscardZone)
        end
    end, function() return not cardo.isSmoothMoving() end)
end
function DiscardPowerCards(handPos, discardZone)
    local discardTable = {}
    local cardZoneObjects = getPowerZoneObjects(handPos)
    for i, obj in ipairs(cardZoneObjects) do
        obj.setPositionSmooth(discardZone.getPosition() + Vector(0,i,0), false, true)
        obj.setRotationSmooth(Vector(0, 180, 0), false, true)
        obj.clearButtons()
        Wait.condition(function() obj.setLock(false) end, function() return not obj.isSmoothMoving() end)
        discardTable[i] = obj
    end
    return discardTable
end
----- Blight Section
blightedIslandCard = nil
function SetupBlightCard()
    if useBlightCard then
        grabBlightCard(true)
    else
        blightedIsland = true
    end
    setupBlightTokens()
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return blightedIsland or (blightedIslandCard ~= nil and not blightedIslandCard.isSmoothMoving()) end)
    return 1
end
function grabBlightCard(setup)
    local blightDeckZone = getObjectFromGUID("b38ea8")
    local blightDeck = blightDeckZone.getObjects()[1]
    local blightCardPos = aidBoard.positionToWorld(Vector(-1.15,0.11,0.99))
    if blightDeck.tag == "Deck" then
        blightDeck.shuffle()
        local card = blightDeck.takeObject({
            position = blightDeckZone.getPosition() + Vector(3.92, 1, 0),
            callback_function = function(obj)
                if not useEventDeck and (not obj.getVar("healthy") and (obj.getVar("immediate") or obj.getVar("blight") == 2)) then
                    obj.setRotationSmooth(Vector(0,180,0))
                    grabBlightCard(setup)
                elseif numPlayers == 1 and not obj.getVar("healthy") and obj.getVar("blight") == 2 then
                    obj.setRotationSmooth(Vector(0,180,0))
                    grabBlightCard(setup)
                else
                    blightedIslandCard = obj
                    blightedIslandCard.setPositionSmooth(blightCardPos)
                    blightedIslandCard.setLock(true)
                    if setup then
                        addBlightedIslandButton()
                    else
                        startLuaCoroutine(Global, "BlightedIslandFlipPart2")
                    end
                end
            end,
        })
    else
        -- if there’s only a single blight card just use it
        blightedIslandCard = blightDeck
        blightedIslandCard.setPositionSmooth(blightCardPos)
        blightedIslandCard.setLock(true)
        if setup then
            addBlightedIslandButton()
        else
            startLuaCoroutine(Global, "BlightedIslandFlipPart2")
        end
    end
end
function addBlightedIslandButton()
    if blightedIslandCard ~= nil then
        aidBoard.editButton({
            index          = 0,
            label          = "Blighted Island",
            width          = 1600,
            height         = 270,
        })
    end
end
function BlightIslandButton(_, playerColor)
    if #blightBag.getObjects() == 0 then -- blightBag must be empty to flip this card!
        if blightedIslandTimer == 0 then
            broadcastToColor("Double-click to go Blighted Island", playerColor, Color.SoftBlue)
        end
        startLuaCoroutine(Global, "BlightedIslandTimer")
    else
        broadcastToColor("There is still blight on the Blight Card!", playerColor, Color.SoftYellow)
    end
end
blightedIslandTimer = 0
function BlightedIslandTimer()
    if blightedIslandTimer == 1 then
        blightedIslandTimer = 0
        BlightedIslandFlip()
    else
        blightedIslandTimer = 1
        wt(1)
        blightedIslandTimer = 0
    end
    return 1
end
function BlightedIslandFlip()
    gamePaused = true -- to disable scripting buttons and object cleanup
    if not blightedIslandCard.is_face_down then
        -- still healthy card
        local blightDeckZone = getObjectFromGUID("b38ea8")
        blightedIslandCard.setPositionSmooth(blightDeckZone.getPosition() + Vector(3.92, 1, 0))
        blightedIslandCard.setLock(false)
        local blightDeck = blightDeckZone.getObjects()[1]
        if blightDeck == nil then
            hideBlightButton()
            return
        else
            grabBlightCard(false)
            return
        end
    end
    BlightedIslandFlipPart2()
end
function BlightedIslandFlipPart2()
    if not blightedIslandCard.getVar("healthy") then
        hideBlightButton()
    end

    blightedIslandCard.setRotationSmooth(Vector(0,180,0))
    local numBlight = blightedIslandCard.getVar("blight") * numPlayers
    for i=1, numBlight do
        blightBag.putObject(blightBagInfinite.takeObject({position = blightBag.getPosition() + Vector(0,1,0)}))
    end
    wt(1)
    gamePaused = false -- to re-enable scripting buttons and object cleanup
    broadcastToAll("Blighted Island", Color.SoftYellow)
    wt(3)
    broadcastToAll(numBlight.." Blight Tokens Added", Color.SoftBlue)
    wt(5)
    broadcastToAll("Remember to check the blighted island effect", Color.SoftBlue)
    return 1
end
function hideBlightButton()
    aidBoard.editButton({
        index = 0,
        label = "",
        width = 0,
        height = 0,
    })
    blightedIsland = true
end
function setupBlightTokens()
    blightBag.reset()
    local numBlight = 2 * numPlayers
    if not useBlightCard then
        numBlight = 5 * numPlayers
    end
    for i=1, numBlight do
        blightBag.putObject(blightBagInfinite.takeObject({
            position = blightBag.getPosition() + Vector(0,1,0),
            smooth = false,
        }))
    end
end
----- Adversary Section
function SetupAdversary()
    for _,guid in pairs(adversaryGuids) do
        if guid == "" then
        elseif (adversaryCard == nil or adversaryCard.guid ~= guid) and (adversaryCard2 == nil or adversaryCard2.guid ~= guid) then
            getObjectFromGUID(guid).destruct()
        end
    end

    local boardSetup = false
    local secondAdversaryBoard = nil
    if adversaryCard2 ~= nil then
        secondAdversaryBoard = adversaryBag.takeObject({
            guid = "312e2d",
            position = aidBoard.positionToWorld(Vector(-0.75,-0.11,-2.84)),
            rotation = {0,180,0},
            callback_function = function(obj) obj.setLock(true) end,
        })
        Wait.condition(function() boardSetup = true end, function() return not secondAdversaryBoard.isSmoothMoving() end)
    else
        boardSetup = true
    end

    if adversaryCard ~= nil then
        local targetScale = 1.53
        local currentScale = adversaryCard.getScale()[1]
        local scaleMult = (currentScale - targetScale)/20
        for i = 1, 17 do
            wt(0.02)
            adversaryCard.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
            if adversaryCard2 ~= nil then
                adversaryCard2.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
            end
        end
    end

    -- Wait until Second Adversary board is in position before moving cards
    Wait.condition(function()
        if adversaryCard ~= nil then
            adversaryCard.setLock(true)
            adversaryCard.setPositionSmooth(aidBoard.positionToWorld(Vector(-0.75,0.11,-1.81)))
        end
        if adversaryCard2 ~= nil then
            adversaryCard2.setLock(true)
            adversaryCard2.setPositionSmooth(secondAdversaryBoard.positionToWorld(Vector(0,0.21,0)))
        end
    end, function() return boardSetup end)

    reminderSetup()

    if adversaryCard == nil then
        difficultyString = "No Adversary\nDifficulty "..difficulty
        difficulty = 0
    elseif adversaryCard2 == nil then
        difficultyString = adversaryCard.getName().." Level "..adversaryLevel.."\nDifficulty "..difficulty
    else
        difficultyString = adversaryCard2.getName().." Level "..adversaryLevel2.."\n"..adversaryCard.getName().." Level "..adversaryLevel.."\nDifficulty "..difficulty
    end
    Wait.condition(createDifficultyButton, function() return boardSetup end)

    adversaryUISetup()

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return (adversaryCard == nil or not adversaryCard.isSmoothMoving()) and (adversaryCard2 == nil or not adversaryCard2.isSmoothMoving()) end)
    return 1
end
function reminderSetup()
    local reminder = {}
    if adversaryCard ~= nil then
        if adversaryCard.getVar("reminderSetup") then
            reminder = adversaryCard.call("ReminderSetup", { level = adversaryLevel })
        end
    end
    local reminder2 = {}
    if adversaryCard2 ~= nil then
        if adversaryCard2.getVar("reminderSetup") then
            reminder2 = adversaryCard2.call("ReminderSetup", { level = adversaryLevel2 })
        end
    end

    local ravagePos = Vector(-0.2,-0.09,2.24)
    if reminder.ravage then
        local obj = adversaryBag.takeObject({
            guid = reminder.ravage,
            position = aidBoard.positionToWorld(ravagePos),
            rotation = {0,180,0},
        })
        obj.setLock(true)
        ravagePos.z = ravagePos.z + 0.07
    end
    if reminder2.ravage and reminder2.ravage ~= reminder.ravage then
        local obj = adversaryBag.takeObject({
            guid = reminder2.ravage,
            position = aidBoard.positionToWorld(ravagePos),
            rotation = {0,180,0},
        })
        obj.setLock(true)
    end

    local buildPos = Vector(-0.72,-0.09,2.24)
    if reminder.build then
        local obj = adversaryBag.takeObject({
            guid = reminder.build,
            position = aidBoard.positionToWorld(buildPos),
            rotation = {0,180,0},
        })
        obj.setLock(true)
        buildPos.z = buildPos.z + 0.07
    end
    if reminder2.build and reminder2.build ~= reminder.build then
        local obj = adversaryBag.takeObject({
            guid = reminder2.build,
            position = aidBoard.positionToWorld(buildPos),
            rotation = {0,180,0},
        })
        obj.setLock(true)
    end

    local explorePos = Vector(-1.24,-0.09,2.24)
    if reminder.explore then
        local obj = adversaryBag.takeObject({
            guid = reminder.explore,
            position = aidBoard.positionToWorld(explorePos),
            rotation = {0,180,0},
        })
        obj.setLock(true)
        explorePos.z = explorePos.z + 0.07
    end
    if reminder2.explore and reminder2.explore ~= reminder.explore then
        local obj = adversaryBag.takeObject({
            guid = reminder2.explore,
            position = aidBoard.positionToWorld(explorePos),
            rotation = {0,180,0},
        })
        obj.setLock(true)
    end
end
function createDifficultyButton()
    local buttonPos = Vector(-0.9,0,-2.75)
    if getObjectFromGUID("312e2d") == nil or not Vector.equals(getObjectFromGUID("312e2d").getPosition(), aidBoard.positionToWorld(Vector(-0.75,-0.11,-2.84))) then
        -- not double adversaries
        buttonPos = Vector(0,0,-2.75)
    end
    aidBoard.createButton({
        click_function = "nullFunc",
        function_owner = Global,
        label          = difficultyString,
        position       = buttonPos,
        font_size      = 80,
        font_color     = {1,1,1},
        width          = 0,
        height         = 0,
    })
end
function adversaryUISetup()
    local lineCount = 0
    if adversaryCard and adversaryCard.getVar("hasUI") then
        local ui = adversaryCard.call("AdversaryUI", {level = adversaryLevel, supporting = false})
        UI.setAttribute("panelAdversaryName","text",adversaryCard.getName().." Effects")
        lineCount = lineCount + 1
        if ui.loss then
            UI.setAttribute("panelAdversaryLossText","tooltip",ui.loss.tooltip)
            UI.setAttribute("panelAdversaryLoss","active","true")
            lineCount = lineCount + 1
            if ui.loss.counter then
                UI.setAttribute("panelAdversaryLossCounterText","text",ui.loss.counter.text)
                UI.setAttribute("panelAdversaryLossCounter","active","true")
                lineCount = lineCount + 1
                if ui.loss.counter.buttons then
                    UI.setAttribute("panelAdversaryLossCounterMinus","active","true")
                    UI.setAttribute("panelAdversaryLossCounterPlus","active","true")
                end
            end
        end
        UI.setAttribute("panelAdversaryEscalation","tooltip",ui.escalation.tooltip)
        lineCount = lineCount + 1
        if ui.one then
            UI.setAttribute("panelAdversaryLevel1","text","1) "..ui.one.name)
            if ui.one.tooltip then
                UI.setAttribute("panelAdversaryLevel1","tooltip",ui.one.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel1","active","true")
            lineCount = lineCount + 1
        end
        if ui.two then
            UI.setAttribute("panelAdversaryLevel2","text","2) "..ui.two.name)
            if ui.two.tooltip then
                UI.setAttribute("panelAdversaryLevel2","tooltip",ui.two.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel2","active","true")
            lineCount = lineCount + 1
        end
        if ui.three then
            UI.setAttribute("panelAdversaryLevel3","text","3) "..ui.three.name)
            if ui.three.tooltip then
                UI.setAttribute("panelAdversaryLevel3","tooltip",ui.three.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel3","active","true")
            lineCount = lineCount + 1
        end
        if ui.four then
            UI.setAttribute("panelAdversaryLevel4","text","4) "..ui.four.name)
            if ui.four.tooltip then
                UI.setAttribute("panelAdversaryLevel4","tooltip",ui.four.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel4","active","true")
            lineCount = lineCount + 1
        end
        if ui.five then
            UI.setAttribute("panelAdversaryLevel5","text","5) "..ui.five.name)
            if ui.five.tooltip then
                UI.setAttribute("panelAdversaryLevel5","tooltip",ui.five.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel5","active","true")
            lineCount = lineCount + 1
        end
        if ui.six then
            UI.setAttribute("panelAdversaryLevel6","text","6) "..ui.six.name)
            if ui.six.tooltip then
                UI.setAttribute("panelAdversaryLevel6","tooltip",ui.six.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel6","active","true")
            lineCount = lineCount + 1
        end
    end
    if adversaryCard2 and adversaryCard2.getVar("hasUI") then
        lineCount = lineCount + 1
        UI.setAttribute("panelAdversary2Helper","active","true")
        local ui = adversaryCard2.call("AdversaryUI", {level = adversaryLevel2, supporting = true})
        UI.setAttribute("panelAdversary2Name","text",adversaryCard2.getName().." Effects")
        lineCount = lineCount + 1
        if ui.loss then
            UI.setAttribute("panelAdversary2LossText","tooltip",ui.loss.tooltip)
            UI.setAttribute("panelAdversary2Loss","active","true")
            lineCount = lineCount + 1
            if ui.loss.counter then
                UI.setAttribute("panelAdversary2LossCounterText","text",ui.loss.counter.text)
                UI.setAttribute("panelAdversary2LossCounter","active","true")
                lineCount = lineCount + 1
                if ui.loss.counter.buttons then
                    UI.setAttribute("panelAdversary2LossCounterMinus","active","true")
                    UI.setAttribute("panelAdversary2LossCounterPlus","active","true")
                end
            end
        end
        UI.setAttribute("panelAdversary2Escalation","tooltip",ui.escalation.tooltip)
        lineCount = lineCount + 1
        if ui.escalation.random then
            UI.setAttribute("panelAdversary2EscalationRandom","active","true")
        end
        if ui.one then
            UI.setAttribute("panelAdversary2Level1","text",ui.one.name)
            if ui.one.tooltip then
                UI.setAttribute("panelAdversary2Level1","tooltip",ui.one.tooltip)
            end
            UI.setAttribute("panelAdversary2Level1","active","true")
            lineCount = lineCount + 1
        end
        if ui.two then
            UI.setAttribute("panelAdversary2Level2","text",ui.two.name)
            if ui.two.tooltip then
                UI.setAttribute("panelAdversary2Level2","tooltip",ui.two.tooltip)
            end
            UI.setAttribute("panelAdversary2Level2","active","true")
            lineCount = lineCount + 1
        end
        if ui.three then
            UI.setAttribute("panelAdversary2Level3","text",ui.three.name)
            if ui.three.tooltip then
                UI.setAttribute("panelAdversary2Level3","tooltip",ui.three.tooltip)
            end
            UI.setAttribute("panelAdversary2Level3","active","true")
            lineCount = lineCount + 1
        end
        if ui.four then
            UI.setAttribute("panelAdversary2Level4","text",ui.four.name)
            if ui.four.tooltip then
                UI.setAttribute("panelAdversary2Level4","tooltip",ui.four.tooltip)
            end
            UI.setAttribute("panelAdversary2Level4","active","true")
            lineCount = lineCount + 1
        end
        if ui.five then
            UI.setAttribute("panelAdversary2Level5","text",ui.five.name)
            if ui.five.tooltip then
                UI.setAttribute("panelAdversary2Level5","tooltip",ui.five.tooltip)
            end
            UI.setAttribute("panelAdversary2Level5","active","true")
            lineCount = lineCount + 1
        end
        if ui.six then
            UI.setAttribute("panelAdversary2Level6","text",ui.six.name)
            if ui.six.tooltip then
                UI.setAttribute("panelAdversary2Level6","tooltip",ui.six.tooltip)
            end
            UI.setAttribute("panelAdversary2Level6","active","true")
            lineCount = lineCount + 1
        end
    end
    UI.setAttribute("panelAdversary","height",lineCount*20)
end
function decrementLossCounter(player, countID)
    if player.color == "Grey" then return end
    local count = UI.getAttribute(countID,"text")
    local supporting = false
    if countID == "panelAdversary2LossCounterCount" then
        supporting = true
    end
    UpdateAdversaryLossCounter({count=count - 1,supporting=supporting})
end
function incrementLossCounter(player, countID)
    if player.color == "Grey" then return end
    local count = UI.getAttribute(countID,"text")
    local supporting = false
    if countID == "panelAdversary2LossCounterCount" then
        supporting = true
    end
    UpdateAdversaryLossCounter({count=count + 1,supporting=supporting})
end
function UpdateAdversaryLossCounter(params)
    local id = "panelAdversaryLossCounterCount"
    if params.supporting then
        id = "panelAdversary2LossCounterCount"
    end
    UI.setAttribute(id,"text",params.count)
end
function randomTerrain(player)
    if player.color == "Grey" then return end
    local random = math.random(1,2)
    if random == 1 then
        broadcastToAll("Your random stage 3 escalation is \"top terrain\" for the current Adversary Action", Color.SoftBlue)
    else
        broadcastToAll("Your random stage 3 escalation is \"bottom terrain\" for the current Adversary Action", Color.SoftBlue)
    end
end
----- Invader Deck Section
function SetupInvaderDeck()
    local deckTable = {1,1,1,2,2,2,2,3,3,3,3,3}
    -- supporting adversary setup should happen first
    if adversaryCard2 ~= nil and adversaryCard2.getVar("invaderDeckSetup") then
        deckTable = adversaryCard2.call("InvaderDeckSetup",{level = adversaryLevel2, deck = deckTable})
    end
    if adversaryCard ~= nil and adversaryCard.getVar("invaderDeckSetup") then
        deckTable = adversaryCard.call("InvaderDeckSetup",{level = adversaryLevel, deck = deckTable})
    end

    local requiresCoastal = false
    for i=1, #deckTable do
        if deckTable[i] == "C" then
            if not requiresCoastal then
                requiresCoastal = true
            else
                -- There can only be one Coastal card
                deckTable[i] = 2
            end
        end
    end

    local coastalSetup = false
    if requiresCoastal then
        -- Set Coastal card aside for now
        local stage2Deck = getObjectFromGUID(stage2DeckZone).getObjects()[1]
        stage2Deck.takeObject({
            guid = "c304c1",
            position = stage2Deck.getPosition() + Vector(0,1,0),
            rotation = Vector(0,180,0),
            callback_function = function(obj) coastalSetup = true end,
        })
    else
        coastalSetup = true
    end

    Wait.condition(function() grabInvaderCards(deckTable) end, function() return coastalSetup end)
    return 1
end
function grabInvaderCards(deckTable)
    local zone = getObjectFromGUID(invaderDeckZone)
    local stage1Deck = getObjectFromGUID(stage1DeckZone).getObjects()[1]
    local stage2Deck = getObjectFromGUID(stage2DeckZone).getObjects()[1]
    local stage3Deck = getObjectFromGUID(stage3DeckZone).getObjects()[1]

    stage1Deck.shuffle()
    stage2Deck.shuffle()
    stage3Deck.shuffle()

    local cardTable = {}
    local cardsLoaded = 0
    for i = #deckTable, 1, -1 do
        local char = deckTable[i]
        if char == 1 then
            local card = stage1Deck.takeObject({
                position = zone.getPosition() + Vector(-#deckTable+i,0,0),
                callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
            })
            table.insert(cardTable, card)
        elseif char == 2 then
            local card = stage2Deck.takeObject({
                position = zone.getPosition() + Vector(-#deckTable+i,0,0),
                callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
            })
            table.insert(cardTable, card)
        elseif char == 3 or char == "3*" then
            local card = stage3Deck.takeObject({
                position = zone.getPosition() + Vector(-#deckTable+i,0,0),
                callback_function = function(obj)
                    cardsLoaded = cardsLoaded + 1
                    if char == "3*" then
                        local script = obj.getLuaScript()
                        script = "special=true\n"..script
                        obj.setLuaScript(script)
                    end
                end,
            })
            table.insert(cardTable, card)
        elseif char == "C" then
            local card = getObjectFromGUID("c304c1")
            card.setPositionSmooth(zone.getPosition() + Vector(-#deckTable+i,0,0))
            card.setRotationSmooth(Vector(0,180,180))
            cardsLoaded = cardsLoaded + 1
            table.insert(cardTable, card)
        end
    end
    Wait.condition(function() group(cardTable) end, function() return cardsLoaded == #deckTable end)
    local zone = getObjectFromGUID(invaderDeckZone)
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() local objs = zone.getObjects() return #objs == 1 and objs[1].tag == "Deck" and #objs[1].getObjects() == #deckTable end)
end
----- Event Deck Section
function SetupEventDeck()
    if useEventDeck then
        local deck = getObjectFromGUID("b18505").getObjects()[1]
        deck.shuffle()
        deck.setPositionSmooth(getObjectFromGUID(eventDeckZone).getPosition())
        Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return not deck.isSmoothMoving() end)
    else
        stagesSetup = stagesSetup + 1
    end
    return 1
end
----- Map Section
function SetupMap()
    local adversariesSetup = 0
    if adversaryCard ~= nil and adversaryCard.getVar("limitSetup") then
        adversaryCard.call("LimitSetup",{level = adversaryLevel, other = {level = adversaryLevel2}})
        Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard.getVar("limitSetupComplete") end)
    else
        adversariesSetup = adversariesSetup + 1
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("limitSetup") then
        adversaryCard2.call("LimitSetup",{level = adversaryLevel2, other = {level = adversaryLevel}})
        Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard2.getVar("limitSetupComplete") end)
    else
        adversariesSetup = adversariesSetup + 1
    end
    Wait.condition(BoardSetup, function() return adversariesSetup == 2 end)

    return 1
end
function BoardSetup()
    if getMapCount(true, true) == 0 then
        if boardType == "Standard" then
            StandardMapBag.shuffle()
            MapPlacen(posMap[numPlayers][alternateSetupIndex],rotMap[numPlayers][alternateSetupIndex])
        else
            MapPlacen(posMapThem[numPlayers],rotMapThem[numPlayers])
        end
    else
        MapPlaceCustom()
    end
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return boardsSetup == numPlayers end)
end
----- Post Setup Section
function PostSetup()
    aidBoard.call("setupGame", {})

    local isThematic = boardType ~= "Standard"
    local adversariesSetup = 0
    if adversaryCard ~= nil and adversaryCard.getVar("postSetup") then
        adversaryCard.call("PostSetup",{level = adversaryLevel, other={level=adversaryLevel2}, thematic=isThematic})
        Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard.getVar("postSetupComplete") end)
    else
        adversariesSetup = adversariesSetup + 1
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("postSetup") then
        -- Wait for first adversary to finish
        Wait.condition(function()
            adversaryCard2.call("PostSetup",{level = adversaryLevel2, other={level=adversaryLevel}, thematic=isThematic})
            Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard2.getVar("postSetupComplete") end)
        end, function() return adversariesSetup == 1 end)
    else
        adversariesSetup = adversariesSetup + 1
    end

    local commandSetup = false
    if not useEventDeck and (BnCAdded or JEAdded) then
        local zone = getObjectFromGUID(invaderDeckZone)
        local invaderDeck = zone.getObjects()[1]
        local cards = invaderDeck.getObjects()
        local stageII = nil
        local stageIII = nil
        for _,card in pairs(cards) do
            local start,finish = string.find(card.lua_script,"cardInvaderStage=")
            if start ~= nil then
                local stage = tonumber(string.sub(card.lua_script,finish+1))
                local special = string.find(card.lua_script,"special=")
                if special ~= nil then
                    stage = stage - 1
                end
                if stage == 2 and stageII == nil then
                    stageII = card.index
                elseif stage == 3 and stageIII == nil then
                    stageIII = card.index
                end
            end
            if stageII ~= nil and stageIII ~= nil then
                break
            end
        end
        if stageII == nil then stageII = 0 end
        if stageIII == nil then stageIII = 0 end
        if stageII <= stageIII then stageIII = stageIII + 1 end

        setupCommandCard(invaderDeck, stageII, "d46930")
        Wait.condition(function()
            setupCommandCard(invaderDeck, stageIII, "a578fe")
            Wait.condition(function() commandSetup = true end, function()
                local objs = zone.getObjects()
                return #objs == 1 and objs[1].tag == "Deck" and #objs[1].getObjects() == #cards + 2
            end)
        end, function()
            local objs = zone.getObjects()
            return #objs == 1 and objs[1].tag == "Deck" and #objs[1].getObjects() == #cards + 1
        end)
    else
        commandSetup = true
    end

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return adversariesSetup == 2 and commandSetup end)
    return 1
end
function setupCommandCard(invaderDeck, depth, guid)
    for i=1,depth do
        invaderDeck.takeObject({
            position = invaderDeck.getPosition() + Vector(0,2+(depth-i)*0.5,0)
        })
    end
    local JEBag = getObjectFromGUID("850ac1")
    JEBag.takeObject({
        guid = guid,
        position = invaderDeck.getPosition() + Vector(0,0.1,0),
        rotation = {0,90,180},
        smooth = false,
    })
end
----- Start Game Section
function StartGame()
    gamePaused = false
    gameStarted = true
    enableUI()
    Wait.time(readyCheck,1,-1)
    setLookingForPlayers(false)
    broadcastToAll("Game Started!", Table)
    broadcastToAll("Don't forget to do the initial explore action yourself!", Color.SoftBlue)
    if adversaryCard2 ~= nil then
        wt(2)
        broadcastToAll("Your stage II escalation is "..adversaryCard.getName()..".\nYour stage III escalation is "..adversaryCard2.getName(), "Blue")
    elseif adversaryCard ~= nil then
        wt(2)
        broadcastToAll("Your Stage II escalation is "..adversaryCard.getName(), "Blue")
    end
    if adversaryCard ~= nil then
        local broadcast = adversaryCard.getVar("broadcast")
        if broadcast ~= nil and broadcast[adversaryLevel] ~= nil then
            wt(2)
            broadcastToAll(broadcast[adversaryLevel], "Blue")
        end
    end
    if adversaryCard2 ~= nil then
        local broadcast = adversaryCard2.getVar("broadcast")
        if broadcast ~= nil and broadcast[adversaryLevel2] ~= nil then
            wt(2)
            broadcastToAll(broadcast[adversaryLevel2], "Blue")
        end
    end
    return 1
end
function enableUI()
    local visibility = ""
    for _,player in pairs(Player.getPlayers()) do
        if player.seated then
            visibility = visibility..player.color.."|"
        end
    end
    UI.setAttribute("panelUIToggle","active","true")
    UI.setAttribute("panelTimePasses","visibility",visibility)
    UI.setAttribute("panelReady","visibility",visibility)
end
------
function addSpirit(params)
    -- Ignore Source Spirit
    if params.spirit.guid == "f2a77d" then return end
    -- For now, no shroud or fractured since they don’t have cards
    if params.spirit.guid == "a95c14" or params.spirit.guid == "013dfc" then return end
    table.insert(spiritGuids, params.spirit.guid)
    spiritTags[params.spirit.guid] = params.spirit.getDescription()
end
function removeSpirit(params)
    for i,v in pairs(spiritGuids) do
        if v == params.spirit then
            table.remove(spiritGuids, i)
            break
        end
    end
    if params.color then
        getObjectFromGUID(elementScanZones[params.color]).clearButtons()
        selectedColors[params.color] = getObjectFromGUID(readyTokens[params.color])
    end
end
------
quotes = {
    {"Time passes, and little by little everything that we have spoken in falsehood becomes true.","Marcel Proust"},
    {"Time passes so slowly if you are unaware of it and so quickly if you are aware of it.","Marc Bolan"},
    {"Time goes, you say, Ah no! Alas, Time stays, we go.","Henry Austin Dobson"},
    {"Time wastes our bodies and our wits, but we waste time, so we are quits.","Anonymous"},
    {"Time has no divisions to mark its passage, there is never a thunderstorm or blare of trumpets to announce the beginning of a new month or year. Even when a new century begins it is only we mortals who ring bells and fire off pistols.","Thomas Mann"},
    {"Time. Like a petal in the wind, Flows softly by. As old lives are taken, New ones begin. A continual chain, Which lasts throughout eternity. Every life but a minute in time, But each of equal importance.","Cindy Cheney"},
    {"The long unmeasured pulse of time moves everything. There is nothing hidden that it cannot bring to light, nothing once known that may not become unknown. Nothing is impossible.","Sophocles"},
    {"Indifferent to the affairs of men, time runs out, precise, heedless, exact, and immutable in rhythm.","Erwin Sylvanus"},
    {"Time is a sort of river of passing events, and strong is its current; no sooner is a thing brought to sight than it is swept by and another takes its place, and this too will be swept away.","Marcus Aurelius"},
    {"Time is a great teacher, but unfortunately it kills all its pupils.","Hector Louis Berlioz"},
    {"Half our time is spent trying to find something to do with the time we have rushed through life trying to save.","Will Rogers"},
    {"The bad news is time flies. The good news is you're the pilot.","Michael Althsuler"},
    {"Time flies never to be recalled.","Virgil"},
    {"Time flies over us, but leaves its shadow behind.","Nathaniel Hawthorne"},
    {"Time is the most undefinable yet paradoxical of things; the past is gone, the future is not come, and the present becomes the past even while we attempt to define it, and, like the flash of lightning, at once exists and expires.","Charles Caleb Colton"},
    {"Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma - which is living with the results of other people's thinking.","Steve Jobs"},
    {"Time and tide wait for no man, but time always stands still for a woman of 30.","Robert Frost"},
    {"Time, you old gypsy man, will you not stay, put up your caravan just for one day?","Ralph Hodgson"},
    {"The more sand that has escaped from the hourglass of our life, the clearer we should see through it.","Jean Paul"},
    {"Don't say you don't have enough time. You have exactly the same number of hours per day that were given to Helen Keller, Pasteur, Michaelangelo, Mother Teresa, Leonardo da Vinci, Thomas Jefferson, and Albert Einstein.","H. Jackson Brown Junior"},
    {"Time is a brisk wind, for each hour it brings something new... but who can understand and measure its sharp breath, its mystery and its design?","Paracelsus"},
    {"Time forks perpetually toward innumerable futures.","Jorge Luis Borges"},
    {"As we speak cruel time is fleeing. Seize the day, believing as little as possible in the morrow.","Horace"},
    {"Idleness makes hours pass slowly and years swiftly. Activity makes the hours short and the years long.","Cesare Pavese"},
    {"Time does not pass, it continues.","Marty Rubin"},
    {"Time is free, but it's priceless. You can't own it, but you can use it. You can't keep it, but you can spend it. Once you've lost it you can never get it back.","Harvey McKay"},
    {"Time is more valuable than money. You can get more money, but you cannot get more time.","Jim Rohn"},
    {"Time is like a handful of sand- the tighter you grasp it, the faster it runs through your fingers","Anonymous"},
    {"Methinks I see the wanton hours flee, And as they pass, turn back and laugh at me.","George Villiers"},
    {"Better late than never, but never late is better","Anonymous"},
}
timePassing = false
function timePassesUI(player)
    if player.color == "Grey" then return end
    timePasses()
end
function timePasses()
    if not timePassing then
        timePassing = true
        startLuaCoroutine(Global, "timePassesCo")
    end
end
function timePassesCo()
    for _,object in pairs(upCast(seaTile,1.1,0,0.9)) do
        handlePiece(object, 1)
    end

    for _,guid in pairs (elementScanZones) do
        local zone = getObjectFromGUID(guid)
        for _, obj in ipairs(zone.getObjects()) do
            if obj.getName() == "Any" then
                if obj.getStateId() ~= 9 then obj.setState(9) end
                if obj.getLock() == false then obj.destruct() end
            elseif obj.tag == "Tile" and obj.getVar("elements") ~= nil then
                if obj.getLock() == false then obj.destruct() end
            end
        end
    end

    broadcastToAll("Time Passes...", Color.SoftBlue)
    local quote = quotes[math.random(#quotes)]
    wt(2)
    broadcastToAll("\"" .. quote[1] .. "\"", {0.9,0.9,0.9})
    wt(2)
    broadcastToAll("- " .. quote[2], {0.9,0.9,0.9})
    wt(2)
    timePassing = false
    return 1
end
function handlePiece(object, depth)
    if string.sub(object.getName(),1,4) == "City" then
        object = resetPiece(object, Vector(0,180,0), depth)
    elseif string.sub(object.getName(),1,4) == "Town" then
        object = resetPiece(object, Vector(0,180,0), depth)
    elseif string.sub(object.getName(),1,8) == "Explorer" then
        object = resetPiece(object, Vector(0,180,0), depth)
    elseif string.sub(object.getName(),1,5) == "Dahan" then
        object = resetPiece(object, Vector(0,0,0), depth)
    elseif string.sub(object.getName(),1,6) == "Blight" then
        object = resetPiece(object, Vector(0,180,0), depth)
    elseif string.sub(object.getName(),-7) == "Defence" then
        object.destruct()
        object = nil
    end
    return object
end
function resetPiece(object, rotation, depth)
    for _,obj in pairs(upCastRay(object,5)) do
        -- need to store tag since after state change tag isn’t instantly updated
        local isFigurine = obj.tag == "Figurine"
        obj = handlePiece(obj, depth + 1)
        if obj ~= nil then
            obj.setPositionSmooth(obj.getPosition() + Vector(0,2*depth,0))
        end
        if isFigurine then
            -- Figurines are Invaders, Dahan, and Blight, you should only handle the one directly above you
            break
        end
    end
    if object.getStateId() ~= -1 and object.getStateId() ~= 1 then
        object.setRotationSmooth(rotation)
        object.setPositionSmooth(object.getPosition() + Vector(0,0.5,0))
        object = object.setState(1)
    elseif not Vector.equals(object.getRotation(), rotation, 0.1) then
        object.setRotationSmooth(rotation)
        object.setPositionSmooth(object.getPosition() + Vector(0,0.5,0))
    end
    return object
end
------
posMap = { -- This order should exactly match alternateSetupNames table
    { -- 1 player
        { -- Standard
            Vector(5.96, 1.08, 16.59),
        },
    },
    { -- 2 Player
        { -- Standard
            Vector(9.13, 1.08, 25.29),
            Vector{0.29, 1.08, 10.21},
        },
        { -- Fragment
            Vector{-5.20, 1.07, 18.87},
            Vector{10.12, 1.07, 19.08},
        },
        { -- Opposite Shores
            Vector{-4.22, 1.07, 18.91},
            Vector{13.78, 1.07, 19.09},
        },
    },
    { -- 3 Player
        { -- Standard
            Vector{2.33, 1.08, 26.80},
            Vector{2.46, 1.08, 11.54},
            Vector{15.70, 1.08, 19.37},
        },
        { -- Coastline
            Vector{-2.47, 1.08, 10.29},
            Vector{15.38, 1.08, 9.96},
            Vector{33.22, 1.08, 9.58},
        },
        { -- Sunrise
            Vector{-6.01, 1.07, 10.63},
            Vector{7.19, 1.07, 18.54},
            Vector{20.60, 1.07, 10.69},
        },
    },
    { -- 4 Player
        { -- Standard
            Vector{2.36, 1.08, 26.47},
            Vector{20.40, 1.08, 26.64},
            Vector{-6.65, 1.08, 11.13},
            Vector{11.27, 1.08, 11.33},
        },
        { -- Leaf
            Vector{7.05, 1.08, 34.30},
            Vector{20.53, 1.08, 26.36},
            Vector{-2.00, 1.08, 18.53},
            Vector{11.39, 1.08, 10.92},
        },
        { --Snake
            Vector{35.36, 1.08, 37.55},
            Vector{8.26, 1.08, 22.19},
            Vector{26.45, 1.08, 22.36},
            Vector{-0.73, 1.08, 7.00},
        },
    },
    { -- 5 Player
        { -- Standard
            Vector{3.32, 1.08, 32.42},
            Vector{25.46, 1.08, 24.68},
            Vector{38.99, 1.08, 32.44},
            Vector{12.18, 1.08, 16.81},
            Vector{25.62, 1.08, 9.32},
        },
        {  -- Snail
            Vector{26.42, 1.08, 41.16},
            Vector{13.22, 1.08, 33.29},
            Vector{26.68, 1.08, 25.70},
            Vector{8.72, 1.08, 10.08},
            Vector{26.67, 1.08, 9.98},
        },
        { -- Peninsula
            Vector{10.81, 1.08, 32.03},
            Vector{26.27, 1.08, 32.27},
            Vector{18.66, 1.08, 18.81},
            Vector{41.71, 1.07, 23.07},
            Vector{57.12, 1.07, 13.96},
        },
        { -- V
            Vector{0.17, 1.07, 33.75},
            Vector{40.67, 1.07, 41.60},
            Vector{8.96, 1.07, 18.16},
            Vector{31.52, 1.07, 26.14},
            Vector{22.40, 1.07, 10.67},
        },
    },
    { -- 6 Player
        { -- Standard
            Vector{4.31, 1.08, 29.13},
            Vector{19.72, 1.08, 29.32},
            Vector{43.04, 1.08, 33.51},
            Vector{12.25, 1.08, 15.90},
            Vector{35.44, 1.08, 20.02},
            Vector{50.90, 1.08, 20.26},
        },
        { -- Star
            Vector{33.19, 1.07, 34.36},
            Vector{40.94, 1.07, 20.76},
            Vector{33.16, 1.07, 7.18},
            Vector{17.52, 1.07, 7.25},
            Vector{9.71, 1.07, 20.79},
            Vector{17.50, 1.07, 34.33},
        },
        { -- Flower
            Vector{7.70, 1.07, 41.68},
            Vector{30.85, 1.07, 38.06},
            Vector{48.54, 1.07, 41.11},
            Vector{19.22, 1.07, 27.92},
            Vector{33.81, 1.07, 22.91},
            Vector{27.62, 1.07, 6.07},
        },
        { -- Caldera
            Vector{-0.20, 1.07, 31.44},
            Vector{13.16, 1.07, 39.17},
            Vector{31.10, 1.07, 38.86},
            Vector{8.54, 1.07, 15.76},
            Vector{31.18, 1.07, 23.41},
            Vector{21.95, 1.07, 8.04},
        },
    },
}
rotMap = {
    { -- 1 Player
        { -- Standard
            Vector(0.00, 180.00, 0.00),
        },
    },
    { -- 2 Player
        { -- Standard
            Vector(0.00, 180.00, 0.00),
            Vector(0.00, 0.00, 0.00),
        },
        { -- Fragment
            Vector{0.00, 90.00, 0.00},
            Vector{0.00, 330.00, 0.00},
        },
        { -- Opposite Shores
            Vector(0.00, 180.00, 0.00),
            Vector(0.00, 0.00, 0.00),
        },
    },
    { -- 3 Player
        { -- Standard
            Vector(0.00, 180.00, 0.00),
            Vector(0.00, 60.00, 0.00),
            Vector(0.00, 300.00, 0.00),
        },
        { --Coastline
            Vector(0.00, 240.69, 0.00),
            Vector(0.00, 240.69, 0.00),
            Vector(0.00, 240.69, 0.00),
        },
        { -- Sunrise
            Vector(0.00, 60.00, 0.00),
            Vector(0.00, 300.00, 0.00),
            Vector(0.00, 0.00, 0.00),
        },
    },
    { -- 4 Player
        { -- Standard
            Vector(0.00, 180.00, 0.00),
            Vector(0.00, 0.00, 0.00),
            Vector(0.00, 180.00, 0.00),
            Vector(0.00, 0.00, 0.00),
        },
        { -- Leaf
            Vector{0.00, 300.27, 0.00},
            Vector{0.00, 0.27, 0.00},
            Vector{0.00, 120.27, 0.00},
            Vector{0.00, 0.27, 0.00},
        },
        { -- Snake
            Vector{0.00, 180.00, 0.00},
            Vector{0.00, 180.00, 0.00},
            Vector{0.00, 0.05, 0.00},
            Vector{0.00, 0.01, 0.00},
        },
    },
    { -- 5 Player
        { -- Standard
            Vector(0.00, 120.00, 0.00),
            Vector{0.00, 240.00, 0.00},
            Vector{0.00, 300.00, 0.00},
            Vector{0.00, 120.02, 0.00},
            Vector{0.00, 359.99, 0.00},
        },
        { -- Snail
            Vector{0.00, 240.00, 0.00},
            Vector{0.00, 120.02, 0.00},
            Vector{0.00, 359.99, 0.00},
            Vector{0.00, 60.01, 0.00},
            Vector{0.00, 60.00, 0.00},
        },
        { -- Peninsula
            Vector{0.00, 150.07, 0.00},
            Vector{0.00, 270.07, 0.00},
            Vector{0.00, 30.09, 0.00},
            Vector{0.00, 270.25, 0.00},
            Vector{0.00, 270.25, 0.00},
        },
        { -- V
            Vector{0.00, 119.99, 0.00},
            Vector{0.00, 0.01, 0.00},
            Vector{0.00, 119.99, 0.00},
            Vector{0.00, 359.99, 0.00},
            Vector{0.00, 0.01, 0.00},
        },
    },
    { -- 6 Player
        { -- Standard
            Vector{0.00, 150.01, 0.00},
            Vector{0.00, 270.00, 0.00},
            Vector{0.00, 210.00, 0.00},
            Vector{0.00, 30.01, 0.00},
            Vector{0.00, 90.00, 0.00},
            Vector{0.00, 330.00, 0.00},
        },
        { -- Star
            Vector{0.00, 330.00, 0.00},
            Vector{0.00, 30.00, 0.00},
            Vector{0.00, 90.00, 0.00},
            Vector{0.00, 149.99, 0.00},
            Vector{0.00, 210.00, 0.00},
            Vector{0.00, 269.99, 0.00},
        },
        { -- Flower
            Vector{0.00, 109.62, 0.00},
            Vector{0.00, 229.64, 0.00},
            Vector{0.00, 229.62, 0.00},
            Vector{0.00, 109.65, 0.00},
            Vector{0.00, 349.62, 0.00},
            Vector{0.00, 349.61, 0.00},
        },
        { -- Caldera
            Vector{0.00, 120.42, 0.00},
            Vector{0.00, 240.44, 0.00},
            Vector{0.00, 240.43, 0.00},
            Vector{0.00, 120.46, 0.00},
            Vector{0.00, 0.43, 0.00},
            Vector{0.00, 0.42, 0.00},
        },
    },
}
posMapThem = {
    {
        Vector{-1.93, 1.07, 20.44}, --NE
    },
    {
        Vector{9.54, 1.07, 18.07}, --E
        Vector{-10.34, 1.07, 18.04}, --W
    },
    {
        Vector{24.91, 1.07, 10.20}, --E
        Vector{5.03, 1.07, 10.17}, --W
        Vector{15.03, 1.07, 27.16}, --NE
    },
    {
        Vector{29.29, 1.07, 10.20}, --E
        Vector{9.41, 1.07, 10.17}, --W
        Vector{19.41, 1.07, 27.16}, --NE
        Vector{-0.62, 1.07, 27.04}, --NW
    },
    {
        Vector{30.89, 1.07, 21.51}, --E
        Vector{11.01, 1.07, 21.48}, --W
        Vector{21.01, 1.07, 38.47}, --NE
        Vector{0.98, 1.07, 38.35}, --NW
        Vector{40.82, 1.07, 4.66}, --SE
    },
    {
        Vector{33.53, 1.07, 21.51}, --E
        Vector{13.65, 1.07, 21.48}, --W
        Vector{23.65, 1.07, 38.47}, --NE
        Vector{3.62, 1.07, 38.35}, --NW
        Vector{43.40, 1.07, 4.63}, --SE
        Vector{23.59, 1.07, 4.55}, --SW
    },
}
rotMapThem = {
    {
        Vector(0.00, 180.00, 0.00),
    },
    {
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
    },
    {
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
    },
    {
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
    },
    {
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
    },
    {
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
        Vector(0.00, 180.00, 0.00),
    },
}
themGuids = {
    {"f4fc81"},
    {"8094c8","10650c"},
    {"8094c8","10650c","f4fc81"},
    {"8094c8","10650c","f4fc81","be4ea1"},
    {"8094c8","10650c","f4fc81","be4ea1","a33e8c"},
    {"8094c8","10650c","f4fc81","be4ea1","a33e8c","7576c3"},
}
themRedoGuids = {
    {"14a35f"},
    {"f14363","bdaa82"},
    {"f14363","bdaa82","14a35f"},
    {"f14363","bdaa82","14a35f","a0e5c0"},
    {"f14363","bdaa82","14a35f","a0e5c0","214c72"},
    {"f14363","bdaa82","14a35f","a0e5c0","214c72","ffa7e6"},
}
----
function getMapCount(norm, them)
    local count = 0
    for _,obj in pairs(upCast(seaTile,1,0,0.9)) do
        if obj.name == "Custom_Token" then
            if obj.getBoundsNormalized().size.x > 25 and obj.getBoundsNormalized().size.z > 12 then
                local prefix = string.sub(obj.getName(),1,4)
                if norm and prefix == "NORM" then
                    count = count + 1
                elseif them and prefix == "THEM" then
                    count = count + 1
                end
            end
        end
    end
    return count
end

function getMapTiles()
    local mapTiles = {}
    for _,obj in pairs(upCast(seaTile,1,0,0.9)) do
        if obj.name == "Custom_Token" then
            if obj.getBoundsNormalized().size.x > 25 and obj.getBoundsNormalized().size.z > 12 then
                if string.sub(obj.getName(),1,4) == "NORM" or "THEM" then
                    table.insert(mapTiles,obj)
                end
            end
        end
    end
    return mapTiles
end

function MapPlaceCustom()
    local maps = getMapTiles()
    -- board type is guaranteed to either be thematic or normal, and there has to be at least one map tile in the table
    if string.sub(maps[1].getName(),1,4) == "NORM" then
        boardType = boardSetupNames[1]
    else
        boardType = boardSetupNames[2]
    end

    for _,map in pairs(maps) do
        map.setLock(true)
        map.interactable = false
        setupMap(map)
    end
end

BETaken = false
DFTaken = fase
function MapPlacen(posTable, rotTable)
    for i=1, numPlayers do
        local temp = nil
        if boardType == "Standard" then
            local list = StandardMapBag.getObjects()
            local index = 1
            for _,value in pairs(list) do
                if numPlayers <=4 and (value.guid == "73f45a" or value.guid == "ee58e3") then
                    if not BETaken then
                        BETaken = true
                        index = value.index
                        break
                    end
                elseif numPlayers <= 4 and (value.guid == "c16a28" or value.guid == "adc8eb") then
                    if not DFTaken then
                        DFTaken = true
                        index = value.index
                        break
                    end
                else
                    index = value.index
                    break
                end
            end

            temp = StandardMapBag.takeObject({
                index = index,
                position = StandardMapBag.getPosition() + Vector(0,-5,0),
                smooth = false,
                callback_function = function(obj) BoardCallback(obj,posTable[i], rotTable[i]) end,
            })
        elseif boardType == "Thematic" then
            temp = ThematicMapBag.takeObject({
                position = ThematicMapBag.getPosition() + Vector(0,-5,0),
                guid = themGuids[numPlayers][i],
                smooth = false,
                callback_function = function(obj) BoardCallback(obj,posTable[i], rotTable[i]) end,
            })
        elseif boardType == "Thematic Redo" then
            temp = MJThematicMapBag.takeObject({
                position = MJThematicMapBag.getPosition() + Vector(0,-5,0),
                guid = themRedoGuids[numPlayers][i],
                smooth = false,
                callback_function = function(obj) BoardCallback(obj,posTable[i], rotTable[i]) end,
            })
        end
    end
end
function BoardCallback(obj,pos,rot)
    obj.interactable = false
    obj.setLock(true)
    obj.setRotationSmooth(rot, false, true)
    obj.setPositionSmooth(pos, false, true)
    Wait.condition(function() setupMap(obj) end, function() return obj.resting and not obj.loading_custom end)
end
setupMapCoObj = nil
function setupMap(map)
    setupMapCoObj = map
    startLuaCoroutine(Global, "setupMapCo")
end
function setupMapCo()
    local map = setupMapCoObj
    local piecesToPlace = map.getTable("pieceMap")
    local posToPlace = map.getTable("posMap")

    local originalPieces = map.getTable("pieceMap")

    if string.sub(map.getName(),1,4) ~= "THEM" then -- if not a thematic board
        if BnCAdded or JEAdded then -- during Setup put 1 Beast and 1 Disease on each island board
            for i=1,#piecesToPlace do
                if #piecesToPlace[i] == 0 then
                    table.insert(piecesToPlace[i],"Beasts") -- the Beasts go in the lowest-numbered land with no printed Setup icons
                    break
                end
            end
            table.insert(piecesToPlace[2],"Disease") -- the Disease goes in land #2 (with the City)
        end
    end

    -- supporting adversary setup should happen first
    if adversaryCard2 ~= nil and adversaryCard2.getVar("mapSetup") then
        piecesToPlace = adversaryCard2.call("MapSetup", { level = adversaryLevel2, pieces = piecesToPlace, guid = map.guid, original = originalPieces})
    end
    if adversaryCard ~= nil and adversaryCard.getVar("mapSetup") then
        piecesToPlace = adversaryCard.call("MapSetup", { level = adversaryLevel, pieces = piecesToPlace, guid = map.guid, original = originalPieces})
    end

    for l,landTable in ipairs (piecesToPlace) do
        for i,pieceName in ipairs (landTable) do
            place(pieceName,map.positionToWorld(posToPlace[l][i]))
            coroutine.yield(0)
        end
    end
    boardsSetup = boardsSetup + 1
    return 1
end

function place(objName, placePos, droppingPlayerColor)
    if objName == "CityS" then
        place("City",placePos,droppingPlayerColor)
        if BnCAdded or JEAdded then
            Wait.time(function() place("Strife",placePos + Vector(0,1,0),droppingPlayerColor) end, 0.5)
        end
    end
    if objName == "TownS" then
        place("Town",placePos,droppingPlayerColor)
        if BnCAdded or JEAdded then
            Wait.time(function() place("Strife",placePos + Vector(0,1,0),droppingPlayerColor) end, 0.5)
        end
    end
    if objName == "ExplorerS" then
        place("Explorer",placePos,droppingPlayerColor)
        if BnCAdded or JEAdded then
            Wait.time(function() place("Strife",placePos + Vector(0,1,0),droppingPlayerColor) end, 0.5)
        end
    end
    local temp = nil
    if objName == "Explorer" then
        if explorerBag.getCustomObject().type ~= 7 then
            if #explorerBag.getObjects() == 0 then
                broadcastToAll("There are no Explorers left to place", Color.SoftYellow)
                return
            end
        end
        temp = explorerBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "Town" then
        if townBag.getCustomObject().type ~= 7 then
            if #townBag.getObjects() == 0 then
                broadcastToAll("There are no Towns left to place", Color.SoftYellow)
                if (adversaryCard ~= nil and adversaryCard.getName() == "France") or (adversaryCard2 ~= nil and adversaryCard2.getName() == "France") then
                    broadcastToAll("France wins via Additional Loss Condition!", Color.SoftYellow)
                end
                return
            end
        end
        temp = townBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "City" then
        if cityBag.getCustomObject().type ~= 7 then
            if #cityBag.getObjects() == 0 then
                broadcastToAll("There are no Cities left to place", Color.SoftYellow)
                return
            end
        end
        temp = cityBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "Dahan" then
        if dahanBag.getCustomObject().type ~= 7 then
            if #dahanBag.getObjects() == 0 then
                broadcastToAll("There are no Dahan left to place", Color.SoftYellow)
                return
            end
        end
        temp = dahanBag.takeObject({position=placePos,rotation=Vector(0,0,0)})
    elseif objName == "Blight" then
        if #blightBag.getObjects() == 0 then
            broadcastToAll("There is no Blight left to place", Color.SoftYellow)
            return
        end
        temp = blightBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "BlightInfinite" then
        temp = blightBagInfinite.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "Strife" then
        if BnCAdded or JEAdded then
            temp = strifeBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Beasts" then
        if BnCAdded or JEAdded then
            temp = beastsBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Wilds" then
        if BnCAdded or JEAdded then
            temp = wildsBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Disease" then
        if BnCAdded or JEAdded then
            temp = diseaseBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Badlands" then
        if JEAdded then
            temp = badlandsBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    end
    if droppingPlayerColor then
        local dropColor = droppingPlayerColor
        if dropColor == "Blue" then
            dropColor = {0.118, 0.53, 1}
        elseif dropColor == "Red" then
            dropColor = {0.856, 0.1, 0.094}
        elseif dropColor == "Yellow" then
            dropColor = {0.905, 0.898, 0.172}
        elseif dropColor == "Purple" then
            dropColor = {0.627, 0.125, 0.941}
        end
        temp.highlightOn(dropColor, 20)
    end
end

function DropMiniature(index, cursorLocation, droppingPlayerColor)
    if index == 1 then
        place("Explorer",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 2 then
        place("Town",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 3 then
        place("City",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 4 then
        place("Blight",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 10 then
        place("Dahan",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 6 then
        place("Strife",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 7 then
        place("Beasts",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 8 then
        place("Wilds",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 9 then
        place("Disease",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    elseif index == 5 then
        place("Badlands",cursorLocation + Vector(0,2,0),droppingPlayerColor)
    end
end

zoneDestroyFlag = false
function checkZoneDestroy()
     if not zoneDestroyFlag then return end

    for _,obj in pairs(getObjectFromGUID("ac4fad").getObjects()) do
        deleteObject(obj)
    end
    zoneDestroyFlag = false
end
function deleteObject(obj)
    local bag = nil
    local removeObject = true
    if string.match(obj.getName(),"Dahan") then
        obj.setRotation(Vector(0,0,0))
        bag = dahanBag
    elseif string.match(obj.getName(),"Explorer") then
        obj.setRotation(Vector(0,180,0))
        bag = explorerBag
    elseif string.match(obj.getName(),"Town") then
        obj.setRotation(Vector(0,180,0))
        bag = townBag
    elseif string.match(obj.getName(),"City") then
        obj.setRotation(Vector(0,180,0))
        bag = cityBag
    elseif obj.getName() == "Blight" then
        obj.setRotation(Vector(0,180,0))
        bag = returnBlightBag
    elseif obj.getName() == "Strife" then
        obj.setRotation(Vector(0,180,0))
        bag = strifeBag
    elseif obj.getName() == "Beasts" then
        obj.setRotation(Vector(0,180,0))
        bag = beastsBag
    elseif obj.getName() == "Wilds" then
        obj.setRotation(Vector(0,180,0))
        bag = wildsBag
    elseif obj.getName() == "Disease" then
        obj.setRotation(Vector(0,180,0))
        bag = diseaseBag
    elseif obj.getName() == "Badlands" then
        obj.setRotation(Vector(0,180,0))
        bag = badlandsBag
    else
        if not obj.getVar("destroyOnTableDrop") then
            removeObject = false
        end
    end

    if removeObject and (bag == nil or bag.tag == "Infinite") then
        obj.destruct()
    elseif removeObject then
        obj.highlightOff()
        if obj.getStateId() ~= -1 and obj.getStateId() ~= 1 then
            obj = obj.setState(1)
        end
        bag.putObject(obj)
    end
end
---------------
function wt(some)
    local Time = os.clock() + some
    while os.clock() < Time do
        coroutine.yield(0)
    end
end
--------------------
function upCast(obj,dist,offset,multi)
    local dist = dist or 1
    local offset = offset or 0
    local multi = multi or 1
    local oPos = obj.getPosition()
    local oBounds = obj.getBoundsNormalized()
    local oRot = obj.getRotation()
    local orig = Vector(oPos[1],oPos[2]+offset,oPos[3])
    local siz = Vector(oBounds.size.x*multi,dist,oBounds.size.z*multi)
    local orient = Vector(oRot[1],oRot[2],oRot[3])
    local hits = Physics.cast({
        origin       = orig,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = siz,
        orientation  = orient,
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end
function upCastRay(obj,dist)
    local hits = Physics.cast({
        origin = obj.getPosition(),
        direction = Vector(0,1,0),
        max_distance = dist,
        --debug = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        local prefix = string.sub(v.hit_object.getName(),1,4)
        if v.hit_object ~= obj and prefix ~= "NORM" and prefix ~= "THEM" then
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end
function upCastPosSizRot(oPos,size,rot,dist,multi,tags)
    local rot = rot or Vector(0,0,0)
    local dist = dist or 1
    local offset = offset or 0
    local multi = multi or 1
    local tags = tags or {}
    local oBounds = size
    local oRot = rot
    local orig = Vector(oPos[1],oPos[2],oPos[3])
    local siz = Vector(oBounds[1]*multi,dist,oBounds[3]*multi)
    local orient = Vector(oRot[1],oRot[2],oRot[3])
    local hits = Physics.cast({
        origin       = orig,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = siz,
        orientation  = orient,
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if tags ~= {} then
            local matchesTag = false
            for _,t in pairs(tags) do
                if v.hit_object.tag == t then matchesTag = true end
            end
            if matchesTag then
                table.insert(hitObjects,v.hit_object)
            end
        else
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end
---- UI Section
childHeight = 80
childWidth = 80
childFontSize = 40

titleBGColorNA="#666666"
titleColorNA="#222222"
titleBGColor="#CCCCCC"
titleColor="black"

invaderColors ={
    S = "yellow",
    M = "#666666",
    W = "#AAEEFF",
    J = "green",
    C = "blue",
    a = "white", -- Stage I
    b = "white", -- Stage II
    c = "white", -- Stage III
    n = "#444444", -- no cards
    E = "#FF3300", -- Stage EMPTY
    ["_"] = "#444444" -- No Explore
}
invaderFontColors ={
    S = "black",
    M = "black",
    W = "black",
    J = "black",
    C = "black",
    a = "black", -- Stage I
    b = "black", -- Stage II
    c = "black", -- Stage III
    n = "#666666", -- no cards
    E = "black", -- Stage EMPTY
    ["_"] = "#666666" -- No Explore
}
tooltips ={
    S = "Sands",
    M = "Mountains",
    W = "Wetlands",
    J = "Jungle",
    C = "Coastal",
    a = "Stage I",
    b = "Stage II",
    c = "Stage III",
    n = "NO ACTION", -- no cards
    E = "YOU LOSE WHEN THE\nINVADERS NEXT\nEXPLORE", -- Stage EMPTY
    ["_"] = "UNKNOWN UNTIL\nNEXT INVADER PHASE" -- No Explore
}
textOut ={
    S = "S",
    M = "M",
    W = "W",
    J = "J",
    C = "C",
    a = "I", -- Stage I
    b = "II", -- Stage II
    c = "III", -- Stage III
    n = "NO ACTION", -- no cards
    E = "EMPTY", -- Stage EMPTY
    ["_"] = "?" -- No Explore
}

currentTable = {
    {},
    {},
    {},
    {},
    {},
}

function visiStringToTable(inString,delim)
    if inString == "Invisible" then inString = "" end
    local delim = delim or "|"
    local stringI = 1
    local outTable = {}
    while stringI < #inString do
        local delimPos = string.find(inString,delim,stringI)
        if delimPos then
            table.insert(outTable,string.sub(inString,stringI,delimPos-1))
            stringI = delimPos+1
        else
            table.insert(outTable,string.sub(inString,stringI))
            stringI = #inString
            break
        end
    end
    return outTable
end
function visiTableToString(inTable,delim)
    local delim = delim or "|"
    local outString = ""
    for i,v in ipairs(inTable) do
        outString = outString..v..delim
    end
    local outString = string.sub(outString, 1, #outString-1)
    if outString == "" then outString = "Invisible" end
    return outString
end
function getVisiTable(xmlID) return visiStringToTable(UI.getAttribute(xmlID,"visibility")) end
function setVisiTable(xmlID, inTable) UI.setAttribute(xmlID,"visibility",visiTableToString(inTable)) end
function getVisiTableParams(params) return getVisiTable(params.id) end
function setVisiTableParams(params) setVisiTable(params.id, params.table) end

function showButtons(player)
    toggleUI("panelUIToggleHide", player.color, false)
    toggleUI("panelUI", player.color, false)
end
function hideButtons(player)
    toggleUI("panelUIToggleHide", player.color, true)
    toggleUI("panelUI", player.color, true)
end
function toggleInvaderUI(player)
    colorEnabled = getCurrentState("panelInvader", player.color)
    toggleUI("panelInvader", player.color, colorEnabled)
end
function toggleAdversaryUI(player)
    colorEnabled = getCurrentState("panelAdversary", player.color)
    toggleUI("panelAdversary", player.color, colorEnabled)
end
function toggleTurnOrderUI(player)
    colorEnabled = getCurrentState("panelTurnOrder", player.color)
    toggleUI("panelTurnOrder", player.color, colorEnabled)
end
function toggleTimePassesUI(player)
    colorEnabled = getCurrentState("panelTimePasses", player.color)
    toggleUI("panelTimePasses", player.color, colorEnabled)
end
function toggleReadyUI(player)
    colorEnabled = getCurrentState("panelReady", player.color)
    toggleUI("panelReady", player.color, colorEnabled)
end
function getCurrentState(xmlID, player_color)
    local colorEnabled = false
    local currentVisiTable = getVisiTable(xmlID)
    for _,color in ipairs(currentVisiTable) do
        if color == player_color then
            colorEnabled = true
        end
    end
    return colorEnabled
end

function toggleUI(xmlID, player_color, colorEnabled)
    local currentVisiTable = getVisiTable(xmlID)
    local newVisiTable = {}
    if colorEnabled then
        for _,color in ipairs(currentVisiTable) do
            if color ~= player_color then
                table.insert(newVisiTable,color)
            end
        end
    else
        newVisiTable = table.insert(currentVisiTable,player_color)
    end
    setVisiTable(xmlID,newVisiTable)
end
function updateAidPanel(tabIn)
    if tCompare(tabIn,currentTable) then
        return
    end
    currentTable = tabIn
    for i,tType in pairs({"Build2","Ravage","Build","Explore","Stage"}) do
        hideAll(tType)
        cTab = tabIn[i]
        for Ti,T in pairs (cTab) do
            for c = 1,string.len(T) do
                local char = string.sub(T,c,c)
                set(tType,Ti,c,char,#cTab)
                size(tType,Ti,c,#cTab,string.len(T))
                show(tType,Ti,c)
            end
        end
        if #cTab == 0 then
            dark(tType)
            size(tType,1,1,"n")
            if tType == "Explore" then
                set(tType,1,1,"_",1)
            else
                set(tType,1,1,"n",1)
            end
            show(tType,1,1)
        else
            light(tType)
        end
        if #cTab == 0 and tType == "Stage" then
            alert(tType)
            size(tType,1,1,"E")
            set(tType,1,1,"E",1)
            show(tType,1,1)
        end
    end
end
function dark(a)
    UI.setAttribute("panel"..a.."0", "color", titleBGColorNA)
    UI.setAttribute("panel"..a.."0".."text", "color", titleColorNA)
end
function light(a)
    UI.setAttribute("panel"..a.."0", "color", titleBGColor)
    UI.setAttribute("panel"..a.."0".."text", "color", titleColor)
end
function alert(a)
    UI.setAttribute("panel"..a.."0", "color", invaderColors["E"])
    UI.setAttribute("panel"..a.."0".."text", "color", invaderFontColors["E"])
end
function set(a,b,c,d,e)
    local tOff = 0
    if e >= 2 then
        if b == 1 then
            tOff = 40
        else
            tOff = 8
        end
    else
        tOff = 10
    end
    UI.setAttributes("panel"..a..b..c, {color = invaderColors[d], tooltip = tooltips[d], tooltipPosition="Below", tooltipOffset=tOff})
    UI.setAttributes("panel"..a..b..c.."text", {color = invaderFontColors[d], text = textOut[d]})
end
function hideAll(a)
    UI.setAttribute("panel"..a..11, "active", false)
    UI.setAttribute("panel"..a..12, "active", false)
    UI.setAttribute("panel"..a..21, "active", false)
    UI.setAttribute("panel"..a..22, "active", false)
end
function hide(a,b,c)
    UI.setAttribute("panel"..a..b..c, "active", false)
end
function show(a,b,c)
    UI.setAttribute("panel"..a..b..c, "active", true)
end
function size(a,b,c,d,e)
    if d == "n" or d == "E" then
        UI.setAttribute("panel"..a..b..c, "preferredHeight", childHeight)
        UI.setAttribute("panel"..a..b..c, "preferredWidth", childWidth)
        UI.setAttribute("panel"..a..b..c.."text", "fontSize", childFontSize/2)
    else
        UI.setAttribute("panel"..a..b..c, "preferredHeight", childHeight/e)
        UI.setAttribute("panel"..a..b..c, "preferredWidth", childWidth/d)
        UI.setAttribute("panel"..a..b..c.."text", "fontSize", childFontSize/math.max(d,e))
    end
end

function tCompare(t1,t2)
    function cc2(tab)
        newTab = {}
        for i,v in ipairs(tab) do
            newTab[i] = table.concat(v,",")
    end
    return table.concat(newTab,"|")
    end
    if cc2(t1) == cc2(t2) then return true else return false end
end
