---- Versioning
version = "1.4.0-beta.6"
versionGuid = "57d9fe"
---- constants ----
numHandsPerPlayer = 2
---- Used with Spirit Board Scripts
counterBag = "5f595a"
minorPowerZone = "cb16ab"
minorPowerDiscardZone = "55b275"
majorPowerZone = "089896"
majorPowerDiscardZone = "eaf864"
uniquePowerDiscardZone = "uniquePowerDiscard"
PlayerBags = {
    ["Red"] = "fb7941",
    ["Purple"] = "8ee413",
    ["Yellow"] = "8aad81",
    ["Blue"] = "f9e149",
    ["Green"] = "9f4841",
    ["Orange"] = "a2f5cc",
}
---- Used with Adversary Scripts
eventDeckZone = "a16796"
invaderDeckZone = "dd0921"
fearDeckZone = "bd8761"
stage1DeckZone = "cf2635"
stage2DeckZone = "7f21be"
stage3DeckZone = "2a9f36"
adversaryBag = "a62bd7"
scenarioBag = "c16363"
---- Used with ElementsHelper Script
elementScanZones = {
    ["Red"] = "9fc5a4",
    ["Purple"] = "654ab2",
    ["Yellow"] = "102771",
    ["Blue"] = "6f2249",
    ["Green"] = "190f05",
    ["Orange"] = "61ac7c",
}
playerTables = {
    Red = "dce473",
    Purple = "c99d4d",
    Yellow = "794c81",
    Blue = "125e82",
    Green = "d7d593",
    Orange = "33c4af",
}
------ Saved Config Data
BnCAdded = false
JEAdded = false
fearPool = 0
generatedFear = 0
gameStarted = false
difficultyString = ""
blightedIslandCard = nil
blightedIsland = false
adversaryCard = nil
adversaryLevel = 0
adversaryCard2 = nil
adversaryLevel2 = 0
scenarioCard = nil
returnBlightBag = nil
explorerBag = "613ea4"
townBag = "4d3c15"
cityBag = "a245f8"
selectedColors = {}
selectedBoards = {}
blightCards = {}

playerBlocks = {
    Red = "c68e2c",
    Purple = "661aa3",
    Yellow = "c3c59b",
    Blue = "36bbcc",
    Green = "fac8e4",
    Orange = "6b5b4b",
}

showPlayerButtons = true
showAllMultihandedButtons = false

------ Unsaved Config Data
numPlayers = 1
numBoards = 1
useBlightCard = true
useBnCEvents = false
useJEEvents = false
gamePaused = false
boardLayout = "Balanced"
difficulty = 0
yHeight = 0
stagesSetup = 0
boardsSetup = 0
showAdvancedSettings = true
showRandomizers = false
minDifficulty = 0
maxDifficulty = 11
useRandomAdversary = false
useSecondAdversary = false
includeThematic = false
useRandomBoard = false
useRandomScenario = false
------
aidBoard = "bee103"
SetupChecker = "9ad187"
fearDeckSetupZone = "fbbf69"
sourceSpirit = "21f561"
------
dahanBag = "f4c173"
blightBag = "af50b8"
boxBlightBag = "49405b"
beastsBag = "a42427"
diseaseBag = "7019af"
wildsBag = "ca5089"
strifeBag = "af4e63"
badlandsBag = "d3f7f8"
oneEnergyBag = "d336ca"
threeEnergyBag = "a1b7da"
defendBags = {
    Red = "93e047",
    Purple = "66ef2a",
    Yellow = "5f9fff",
    Blue = "997fba",
    Green = "ba1f04",
    Orange = "78a105",
    White = "1716e3",
}
isolateBags = {
    Red = "ddd376",
    Purple = "9f5d0d",
    Yellow = "12d056",
    Blue = "a1f5b5",
    Green = "d9dc6d",
    Orange = "18c282",
}
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
alternateBoardLayoutNames = {
    {},
    {"Fragment","Opposite Shores"},
    {"Coastline","Sunrise"},
    {"Leaf","Snake"},
    {"Snail","Peninsula","V"},
    {"Star","Flower","Caldera"},
}
interactableObjectsToDisableOnLoad = {
    "57dbb8","fd27d5","25fddc", "d3dd7e", -- tables
    "dce473","c99d4d","794c81","125e82","d7d593","33c4af", -- player tables
    "a8cd8c", -- top row border
    "1be83c", -- right column border
    "108d0b", -- bottom row border
    "c17411", -- left column border
    "187be2", "e79255", -- middle column border
    "055a45", -- middle row border
    "5f4be2", -- sea tile
    "235564", -- white box section
    "9ad187", -- start menu object
    "6b5b4b","fac8e4","36bbcc","c3c59b","661aa3","c68e2c", -- player counters
    "19d429", --Big block
}

---- TTS Events Section
function onScriptingButtonDown(index, playerColor)
    DropPiece(Pieces[index], Player[playerColor].getPointerPosition(), playerColor)
end
function onObjectDrop(player_color, dropped_object)
    if gameStarted then
        if dropped_object.hasTag("Highlight") then
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
function onObjectCollisionEnter(hit_object, collision_info)
    if hit_object == seaTile then
        if collision_info.collision_object.type ~= "Card" then
            deleteObject(collision_info.collision_object, false)
        end
    end
end
function onObjectLeaveContainer(container, object)
    if container ~= StandardMapBag and container ~= ThematicMapBag and container ~= MJThematicMapBag then
        return
    end
    object.setScale(scaleFactors[SetupChecker.getVar("optionalScaleBoard")].size)
end
function onSave()
    local data_table = {
        BnCAdded = BnCAdded,
        JEAdded =  JEAdded,
        fearPool = fearPool,
        generatedFear = generatedFear,
        gameStarted = gameStarted,
        difficulty = difficulty,
        difficultyString = difficultyString,
        blightedIsland = blightedIsland,
        returnBlightBag = returnBlightBag.guid,
        explorerBag = explorerBag.guid,
        townBag = townBag.guid,
        cityBag = cityBag.guid,
        adversaryLevel = adversaryLevel,
        adversaryLevel2 = adversaryLevel2,
        boardLayout = boardLayout,
        selectedBoards = selectedBoards,
        numPlayers = numPlayers,
        blightCards = blightCards,

        panelInvaderVisibility = UI.getAttribute("panelInvader","visibility"),
        panelAdversaryVisibility = UI.getAttribute("panelAdversary","visibility"),
        panelTurnOrderVisibility = UI.getAttribute("panelTurnOrder","visibility"),
        panelTimePassesVisibility = UI.getAttribute("panelTimePasses","visibility"),
        panelReadyVisibility = UI.getAttribute("panelReady","visibility"),
        panelFearVisibility = UI.getAttribute("panelFear", "visibility"),
        panelBlightVisibility = UI.getAttribute("panelBlight", "visibility"),
        panelScoreVisibility = UI.getAttribute("panelScore", "visibility"),
        panelPowerDrawVisibility = UI.getAttribute("panelPowerDraw", "visibility"),
        showPlayerButtons = showPlayerButtons,
        showAllMultihandedButtons = showAllMultihandedButtons,
        playerBlocks = convertObjectsToGuids(playerBlocks),
        elementScanZones = elementScanZones
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
    if scenarioCard ~= nil then
        data_table.scenarioCard = scenarioCard.guid
    end
    local selectedTable = {}
    for color,data in pairs(selectedColors) do
        local colorTable = {ready=data.ready.guid, paid=data.paid}
        if data.counter ~= nil then
            colorTable.counter = data.counter.guid
        end
        selectedTable[color] = colorTable
    end
    data_table.selectedColors = selectedTable
    saved_data = JSON.encode(data_table)
    return saved_data
end
function onLoad(saved_data)
    getObjectFromGUID(versionGuid).setValue("version " .. version)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    Color.Add("SoftYellow", Color.new(0.9,0.7,0.1))

    clearHotkeys()
    for _, piece in ipairs(Pieces) do
        addHotkey("Add " .. piece, function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
            DropPiece(piece, cursorLocation, droppingPlayerColor)
        end)
    end

    addHotkey("Add Fear", function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("addFear")
    end)
    addHotkey("Remove Fear", function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("removeFear")
    end)
    addHotkey("Advance Invader Cards", function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("advanceInvaderCards")
    end)
    addHotkey("Remove Piece", function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
        if hoveredObject ~= nil and not hoveredObject.getLock() then
            deleteObject(hoveredObject, false)
        end
    end)
    addHotkey("Destroy Piece", function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
        if hoveredObject ~= nil and not hoveredObject.getLock() then
            deleteObject(hoveredObject, true)
        end
    end)
    addHotkey("Forget Power", function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
        if isPowerCard(hoveredObject) then
            ensureCardInPlay(hoveredObject)
            discardPowerCardFromPlay(hoveredObject, 1)
        end
    end)

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
    scenarioBag = getObjectFromGUID(scenarioBag)
    sourceSpirit = getObjectFromGUID(sourceSpirit)
    ------
    dahanBag = getObjectFromGUID(dahanBag)
    explorerBag = getObjectFromGUID(explorerBag)
    townBag = getObjectFromGUID(townBag)
    cityBag = getObjectFromGUID(cityBag)
    blightBag = getObjectFromGUID(blightBag)
    returnBlightBag = blightBag
    boxBlightBag = getObjectFromGUID(boxBlightBag)
    diseaseBag = getObjectFromGUID(diseaseBag)
    wildsBag = getObjectFromGUID(wildsBag)
    beastsBag = getObjectFromGUID(beastsBag)
    strifeBag = getObjectFromGUID(strifeBag)
    badlandsBag = getObjectFromGUID(badlandsBag)
    oneEnergyBag = getObjectFromGUID(oneEnergyBag)
    threeEnergyBag = getObjectFromGUID(threeEnergyBag)
    for index, bagGuid in pairs(defendBags) do
        defendBags[index] = getObjectFromGUID(bagGuid)
    end
    for index, bagGuid in pairs(isolateBags) do
        isolateBags[index] = getObjectFromGUID(bagGuid)
    end
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
        playerBlocks = loaded_data.playerBlocks
        elementScanZones = loaded_data.elementScanZones
        selectedColors = loaded_data.selectedColors
        BnCAdded = loaded_data.BnCAdded
        JEAdded = loaded_data.JEAdded
        fearPool = loaded_data.fearPool
        generatedFear = loaded_data.generatedFear
        difficulty = loaded_data.difficulty
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
        scenarioCard = getObjectFromGUID(loaded_data.scenarioCard)
        boardLayout = loaded_data.boardLayout
        selectedBoards = loaded_data.selectedBoards
        numPlayers = loaded_data.numPlayers
        blightCards = loaded_data.blightCards
        showPlayerButtons = loaded_data.showPlayerButtons
        showAllMultihandedButtons = loaded_data.showAllMultihandedButtons

        if gameStarted then
            UI.setAttribute("panelInvader","visibility",loaded_data.panelInvaderVisibility)
            UI.setAttribute("panelAdversary","visibility",loaded_data.panelAdversaryVisibility)
            UI.setAttribute("panelTurnOrder","visibility",loaded_data.panelTurnOrderVisibility)
            UI.setAttribute("panelTimePasses","visibility",loaded_data.panelTimePassesVisibility)
            UI.setAttribute("panelReady","visibility",loaded_data.panelReadyVisibility)
            UI.setAttribute("panelFear","visibility",loaded_data.panelFearVisibility)
            UI.setAttribute("panelBlight","visibility",loaded_data.panelBlightVisibility)
            UI.setAttribute("panelScore","visibility",loaded_data.panelScoreVisibility)
            UI.setAttribute("panelPowerDraw","visibility",loaded_data.panelPowerDrawVisibility)
            UI.setAttribute("panelUIToggle","active","true")

            seaTile.registerCollisions(false)
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
            numBoards = getMapCount({norm = true, them = true})
            gamePaused = false
            for _,o in ipairs(getAllObjects()) do
                local t = o.getTable("posMap")
                if t ~= nil and t ~= {} then
                    o.interactable = false -- sets boards to uninteractable after reload
                end
            end
        end
    end
    playerBlocks = convertGuidsToObjects(playerBlocks)
    playerTables = convertGuidsToObjects(playerTables)
    for color,data in pairs(selectedColors) do
        local colorTable = {ready=getObjectFromGUID(data.ready), paid=data.paid}
        if data.counter ~= nil then
            colorTable.counter = getObjectFromGUID(data.counter)
        end
        selectedColors[color] = colorTable
    end

    if Player["White"].seated then Player["White"].changeColor("Red") end
    updateAllPlayerAreas()
    setupSwapButtons()
    Wait.time(spiritUpdater, 10, -1)
end
----
function readyCheck()
    local colorCount = 0
    local readyCount = 0
    for _,data in pairs(selectedColors) do
        if not data.ready.is_face_down and data.ready.resting then
            readyCount = readyCount + 1
        end
        colorCount = colorCount + 1
    end
    if readyCount >= colorCount and colorCount ~= 0 then
        broadcastToAll("All Players are ready!")
        for _,data in pairs(selectedColors) do
            data.ready.flip()
        end
    end
end
function isThematic()
    return boardLayout == "Thematic"
end
---- Setup Buttons Section
function nullFunc()
end
function SetupGame()
    if getMapCount({norm = true, them = true}) == 0 and numPlayers == 0 then
        broadcastToAll("Select the number of players before starting the game", Color.SoftYellow)
        return
    end
    if getMapCount({norm = true, them = false}) > 0 and getMapCount({norm = false, them = true}) > 0 then
        broadcastToAll("You can only have one type of board at once", Color.SoftYellow)
        return
    end
    if adversaryCard == nil and not useRandomAdversary and adversaryCard2 ~= nil then
        broadcastToAll("A Leading Adversary is Required to use a Supporting Adversary", Color.SoftYellow)
        return
    end
    if adversaryCard ~= nil and adversaryCard == adversaryCard2 then
        broadcastToAll("The Leading and Supporting Adversary cannot be the same", Color.SoftYellow)
        return
    end
    if adversaryCard == nil then
        adversaryLevel = 0
    end
    if adversaryCard2 == nil then
        adversaryLevel2 = 0
    end
    -- Map tiles are guaranteed to be of only one type
    local mapCount = getMapCount({norm = true, them = true})
    if mapCount > 0 then
        numBoards = mapCount
        if SetupChecker.getVar("optionalExtraBoard") then
            numPlayers = numBoards - 1
        else
            numPlayers = numBoards
        end
    else
        if SetupChecker.getVar("optionalExtraBoard") then
            if numPlayers == 6 then
                -- There are only currently 6 balanced boards
                SetupChecker.setVar("optionalExtraBoard", false)
                SetupChecker.call("updateDifficulty", {})
                numBoards = numPlayers
            else
                numBoards = numPlayers + 1
            end
        else
            numBoards = numPlayers
        end
    end
    if useRandomBoard then
        randomBoard()
    end
    if useRandomScenario then
        randomScenario()
    end
    if useRandomAdversary or useSecondAdversary then
        randomAdversary(0)
    end

    SetupChecker.call("closeUI", {})
    SetupChecker.setVar("setupStarted", true)
    showPlayerButtons = false
    updateSwapButtons()

    startLuaCoroutine(Global, "PreSetup")
    Wait.condition(function()
        startLuaCoroutine(Global, "SetupFear")
        startLuaCoroutine(Global, "SetupPowerDecks")
        startLuaCoroutine(Global, "SetupBlightCard")
        startLuaCoroutine(Global, "SetupScenario")
        startLuaCoroutine(Global, "SetupAdversary")
        startLuaCoroutine(Global, "SetupInvaderDeck")
        startLuaCoroutine(Global, "SetupEventDeck")
        startLuaCoroutine(Global, "SetupMap")
    end, function() return stagesSetup == 1 end)
    Wait.condition(function() startLuaCoroutine(Global, "PostSetup") end, function() return stagesSetup == 9 end)
    Wait.condition(function() startLuaCoroutine(Global, "StartGame") end, function() return stagesSetup == 10 end)
end
function randomBoard()
    if SetupChecker.call("difficultyCheck", {thematic = true}) > maxDifficulty then
        -- The difficulty can't be increased anymore so don't use thematic
        includeThematic = false
    end
    local min = 0
    if includeThematic then
        min = -1
    end
    local value = math.random(min,#alternateBoardLayoutNames[numBoards])
    if value == 0 then
        boardLayout = "Balanced"
    elseif value == -1 then
        boardLayout = "Thematic"
    else
        boardLayout = alternateBoardLayoutNames[numBoards][value]
    end
    SetupChecker.call("updateDifficulty", {})
end
function randomScenario()
    if difficulty > maxDifficulty then
        return
    end
    local attempts = 0
    while scenarioCard == nil do
        if attempts > 1000 then
            -- TODO find a more elegant solution for detecting bad difficulty ranges
            broadcastToAll("Was not able to find random scenario to satisfy min/max difficulty specifications", "Red")
            return
        end
        attempts = attempts + 1
        scenarioCard = SetupChecker.call("randomScenario",{})
        local tempDifficulty = SetupChecker.call("difficultyCheck", {scenario = scenarioCard.getVar("difficulty")})
        if tempDifficulty > maxDifficulty or (tempDifficulty < minDifficulty and not useRandomAdversary and not useSecondAdversary) then
            scenarioCard = nil
        elseif scenarioCard.getVar("requirements") then
            local allowed = scenarioCard.call("Requirements", {
                eventDeck = useBnCEvents or useJEEvents,
                blightCard = useBlightCard,
                expansions = {bnc = BnCAdded, je = JEAdded},
                thematic = isThematic(),
                adversary = adversaryCard ~= nil or adversaryCard2 ~= nil or useRandomAdversary or useSecondAdversary,
            })
            if not allowed then
                scenarioCard = nil
            end
        else
            SetupChecker.call("updateDifficulty", {})
            broadcastToAll("Your randomised scenario is "..scenarioCard.getName(), "Blue")
            break
        end
    end
end
function randomAdversary(attempts)
    if difficulty >= maxDifficulty then
        if adversaryCard == nil and adversaryCard2 ~= nil then
            adversaryCard = adversaryCard2
            adversaryLevel = adversaryLevel2
            adversaryCard2 = nil
            adversaryLevel2 = 0
        end
        return
    end
    if attempts > 1000 then
        -- TODO find a more elegant solution for detecting bad difficulty ranges
        broadcastToAll("Was not able to find random adversary to satisfy min/max difficulty specifications", "Red")
        return
    end
    if useRandomAdversary and useSecondAdversary then
        local adversary = nil
        while adversary == nil do
            adversary = SetupChecker.call("randomAdversary",{})
            if adversary.getVar("requirements") then
                local allowed = adversary.call("Requirements", {eventDeck = useBnCEvents or useJEEvents, blightCard = useBlightCard, expansions = {bnc = BnCAdded, je = JEAdded}, thematic = isThematic()})
                if not allowed then
                    adversary = nil
                end
            end
        end
        local adversary2 = nil
        while adversary2 == nil or adversary2 == adversary do
            adversary2 = SetupChecker.call("randomAdversary",{})
            if adversary2.getVar("requirements") then
                local allowed = adversary2.call("Requirements", {eventDeck = useBnCEvents or useJEEvents, blightCard = useBlightCard, expansions = {bnc = BnCAdded, je = JEAdded}, thematic = isThematic()})
                if not allowed then
                    adversary2 = nil
                end
            end
        end
        local difficulty = adversary.getVar("difficulty")
        local difficulty2 = adversary2.getVar("difficulty")
        local combos = {}
        for i,v in pairs(difficulty) do
            local params = {lead = v}
            for j,w in pairs(difficulty2) do
                params.support = w
                local newDiff = SetupChecker.call("difficultyCheck", params)
                if newDiff >= minDifficulty and newDiff <= maxDifficulty then
                    table.insert(combos, {i,j})
                elseif newDiff > maxDifficulty then
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
            SetupChecker.call("updateDifficulty", {})
            broadcastToAll("Your randomised adversaries are "..adversaryCard.getName().." and "..adversaryCard2.getName(), "Blue")
        else
            randomAdversary(attempts + 1)
        end
    else
        local selectedAdversary = adversaryCard
        if selectedAdversary == nil then
            selectedAdversary = adversaryCard2
        end
        local adversary = nil
        while adversary == nil or adversary == selectedAdversary do
            adversary = SetupChecker.call("randomAdversary",{})
            if adversary.getVar("requirements") then
                local allowed = adversary.call("Requirements", {eventDeck = useBnCEvents or useJEEvents, blightCard = useBlightCard, expansions = {bnc = BnCAdded, je = JEAdded}, thematic = isThematic()})
                if not allowed then
                    adversary = nil
                end
            end
        end
        local combos = {}
        for i,v in pairs(adversary.getVar("difficulty")) do
            local params = {}
            if adversaryCard == nil then
                params.lead = v
            else
                params.support = v
            end
            local newDiff = SetupChecker.call("difficultyCheck", params)
            if newDiff >= minDifficulty and newDiff <= maxDifficulty then
                table.insert(combos, i)
            elseif newDiff > maxDifficulty then
                break
            end
        end
        if #combos ~= 0 then
            local index = math.random(1,#combos)
            if adversaryCard == nil then
                adversaryCard = adversary
                adversaryLevel = combos[index]
            else
                adversaryCard2 = adversary
                adversaryLevel2 = combos[index]
            end
            SetupChecker.call("updateDifficulty", {})
            broadcastToAll("Your randomised adversary is "..adversary.getName(), "Blue")
        else
            randomAdversary(attempts + 1)
        end
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
    if scenarioCard ~= nil then
        local extraFearCards = scenarioCard.getVar("fearCards")
        if extraFearCards ~= nil then
            fearCards[1] = fearCards[1] + extraFearCards[1]
            fearCards[2] = fearCards[2] + extraFearCards[2]
            fearCards[3] = fearCards[3] + extraFearCards[3]
        end
    end
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
    if not useBnCEvents and not useJEEvents and (BncAdded or JEAdded) then
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
            position = zone.getPosition() + Vector(count,0,0),
            rotation = Vector(0, 180, 180),
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
            position = zone.getPosition() + Vector(count,0,0),
            rotation = Vector(0, 180, 180),
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
            position = zone.getPosition() + Vector(count,0,0),
            rotation = Vector(0, 180, 180),
            callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
        })
        count = count + 1
        table.insert(cardTable, card)
    end

    Wait.condition(function() group(cardTable) end, function() return cardsLoaded == count end)
    Wait.condition(function()
        if scenarioCard ~= nil and scenarioCard.getVar("fearSetup") then
            scenarioCard.call("FearSetup", { deck = zone.getObjects()[1] })
            Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return scenarioCard.getVar("fearSetupComplete") end)
        else
            stagesSetup = stagesSetup + 1
        end
    end, function() local objs = zone.getObjects() return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == count end)
    return 1
end
function setupFearTokens()
    local fearMulti = 4
    if SetupChecker.getVar("optionalExtraBoard") then
        fearMulti = fearMulti + 1
    end
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
    aidBoard.call("updateFearUI")
end
----- Minor/Major Power Section
function SetupPowerDecks()
    getObjectFromGUID(minorPowerZone).getObjects()[1].shuffle()
    getObjectFromGUID(majorPowerZone).getObjects()[1].shuffle()

    SetupChecker.setScale(Vector(1,1,1))
    SetupChecker.setRotationSmooth(Vector(0,180,0))
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
        SetupChecker.createButton({
            click_function = "MajorPowerC",
            function_owner = Global,
            label          = "Gain a\nMajor",
            position       = Vector(146,0.8, -2.2),
            width          = 1600,
            height         = 1500,
            font_size      = 500,
            tooltip        = "Click to learn a Major Power",
        })
        SetupChecker.createButton({
            click_function = "MinorPowerC",
            function_owner = Global,
            label          = "Gain a\nMinor",
            position       = Vector(146, 0.8, 2.6),
            width          = 1600,
            height         = 1500,
            font_size      = 500,
            tooltip        = "Click to learn a Minor Power",
        })
        stagesSetup = stagesSetup + 1
    end, function() return not SetupChecker.isSmoothMoving() end)
    return 1
end
handOffset = Vector(0,0,35)
scriptWorkingCardC = false
powerPlayer = nil
powerCards = 4
function MajorPowerC(obj, player_color, alt_click)
    local cards = 4
    if alt_click then
        cards = 2
    end
    startDealPowerCards("MajorPower", Player[player_color], cards)
end
function MajorPowerUI(player, button)
    local cards = 4
    -- button is "-1"/"1" for left click/single touch
    if math.abs(button) > 1 then
    	cards = 2
    end
    startDealPowerCards("MajorPower", player, cards)
end
function MinorPowerC(obj, player_color, alt_click)
    local cards = 4
    if alt_click then
        cards = 6
    end
    startDealPowerCards("MinorPower", Player[player_color], cards)
end
function MinorPowerUI(player, button)
    local cards = 4
    -- button is "-1"/"1" for left click/single touch
    if math.abs(button) > 1 then
    	cards = 6
    end
    startDealPowerCards("MinorPower", player, cards)
end
function startDealPowerCards(coro_name, player, cardCount)
    -- protection from double clicking
    if scriptWorkingCardC then return end

    scriptWorkingCardC = true
    powerPlayer = player
    powerCards = cardCount
    startLuaCoroutine(Global, coro_name)
end
function MinorPower()
    local MinorPowerDeckZone = getObjectFromGUID(minorPowerZone)
    local MinorPowerDiscardZone = getObjectFromGUID(minorPowerDiscardZone)
    DealPowerCards(MinorPowerDeckZone, MinorPowerDiscardZone, "PickPowerMinor")
    return 1
end
function MajorPower()
    local MajorPowerDeckZone = getObjectFromGUID(majorPowerZone)
    local MajorPowerDiscardZone = getObjectFromGUID(majorPowerDiscardZone)
    DealPowerCards(MajorPowerDeckZone, MajorPowerDiscardZone, "PickPowerMajor")
    return 1
end
function DealPowerCards(deckZone, discardZone, clickFunctionName)
    -- clear the zone!
    local handPos = powerPlayer.getHandTransform().position
    local discardTable = DiscardPowerCards(handPos)
    if #discardTable > 0 then
        wt(0.1)
    end

    local xPadding = 4.4
    if powerCards > 4 then
        xPadding = 3.6
    end
    local cardPlaceOffset = {
        Vector(-(2.5*xPadding)+2*xPadding,0,0),
        Vector(-(2.5*xPadding)+3*xPadding,0,0),
        Vector(-(2.5*xPadding)+1*xPadding,0,0),
        Vector(-(2.5*xPadding)+4*xPadding,0,0),
        Vector(-(2.5*xPadding)+0*xPadding,0,0),
        Vector(-(2.5*xPadding)+5*xPadding,0,0),
    }
    local cardsAdded = 0
    local cardsResting = 0
    local powerDealCentre = handOffset + Vector(handPos.x,yHeight,handPos.z)

    local deck = deckZone.getObjects()[1]
    if deck == nil then
    elseif deck.type == "Card" then
        deck.setLock(true)
        deck.setPositionSmooth(powerDealCentre + cardPlaceOffset[1])
        deck.setRotationSmooth(Vector(0, 180, 0))
        CreatePickPowerButton(deck, clickFunctionName)
        cardsAdded = cardsAdded + 1
        Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not deck.isSmoothMoving() end)
    elseif deck.type == "Deck" then
        for i=1, math.min(deck.getQuantity(), powerCards) do
            local tempCard = deck.takeObject({
                position = powerDealCentre + cardPlaceOffset[i],
                flip = true,
            })
            tempCard.setLock(true)
            CreatePickPowerButton(tempCard, clickFunctionName)
            cardsAdded = cardsAdded + 1
            Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not tempCard.isSmoothMoving() end)
        end
    end
    if cardsAdded < powerCards then
        deck = discardZone.getObjects()[1]
        deck.setPositionSmooth(deckZone.getPosition(), false, true)
        deck.setRotationSmooth(Vector(0, 180, 180), false, true)
        deck.shuffle()
        wt(0.5)

        for i=cardsAdded+1, math.min(deck.getQuantity(), powerCards) do
            local tempCard = deck.takeObject({
                position = powerDealCentre + cardPlaceOffset[i],
                flip = true,
            })
            tempCard.setLock(true)
            CreatePickPowerButton(tempCard, clickFunctionName)
            cardsAdded = cardsAdded + 1
            Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not tempCard.isSmoothMoving() end)
        end
    end
    Wait.condition(function() scriptWorkingCardC = false end, function() return cardsResting == cardsAdded end)
end
function CreatePickPowerButton(card, clickFunctionName)
    local scale = flipVector(Vector(card.getScale()))
    card.createButton({
        click_function = clickFunctionName,
        function_owner = Global,
        label          = "Pick Power",
        position       = Vector(0,0.3,1.43),
        width          = 900,
        scale          = scale,
        height         = 160,
        font_size      = 150,
        tooltip = "Pick Power Card to your hand"
    })
end
function PickPowerMinor(cardo,playero,alt_click)
    -- Give card to player regardless of whose hand they are in front of
    cardo.deal(1,playero)
    cardo.clearButtons()

    Wait.condition(function()
        cardo.setLock(false)
        if not alt_click then
            local handPos = Player[playero].getHandTransform().position
            local minorDiscardZone = getObjectFromGUID(minorPowerDiscardZone)
            DiscardPowerCards(handPos)
        end
    end, function() return not cardo.isSmoothMoving() end)
end
function PickPowerMajor(cardo,playero,alt_click)
    -- Give card to player regardless of whose hand they are in front of
    cardo.deal(1,playero)
    cardo.clearButtons()

    Wait.condition(function()
        cardo.setLock(false)
        if not alt_click then
            local handPos = Player[playero].getHandTransform().position
            DiscardPowerCards(handPos)
        end
    end, function() return not cardo.isSmoothMoving() end)
end
function DiscardPowerCards(handPos)
    local discardTable = {}
    local cardZoneObjects = getPowerZoneObjects(handPos)
    for i, obj in ipairs(cardZoneObjects) do
        discardPowerCardFromPlay(obj, i)
        obj.clearButtons()
        Wait.condition(function() obj.setLock(false) end, function() return not obj.isSmoothMoving() end)
        discardTable[i] = obj
    end
    return discardTable
end
function discardPowerCardFromPlay(card, discardHeight)
    local discardZone
    if card.hasTag("Major") then
        discardZone = getObjectFromGUID(majorPowerDiscardZone)
    elseif card.hasTag("Minor") then
        discardZone = getObjectFromGUID(minorPowerDiscardZone)
    elseif card.hasTag("Unique") then
        discardZone = getObjectFromGUID(uniquePowerDiscardZone)
    else
        -- Discard unknown cards to the unique power discard
        discardZone = getObjectFromGUID(uniquePowerDiscardZone)
    end
    card.setPositionSmooth(discardZone.getPosition() + Vector(0,discardHeight,0), false, true)
    card.setRotation(Vector(0, 180, 0))
end

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
----- Blight Section
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
function grabBlightCard(start)
    local blightDeck = getObjectFromGUID("b38ea8").getObjects()[1]

    if findNextBlightCard(start, blightDeck) then
        return
    elseif blightDeck.type == "Deck" then
        blightDeck.shuffle()
        local card = blightDeck.takeObject({
            position = blightDeck.getPosition() + Vector(3.92, 1, 0),
            callback_function = function(obj)
                if not useBnCEvents and not useJEEvents and (not obj.getVar("healthy") and (obj.getVar("immediate") or obj.getVar("blight") == 2)) then
                    obj.setRotationSmooth(Vector(0,180,0))
                    grabBlightCard(start)
                elseif SetupChecker.getVar("optionalSoloBlight") and numPlayers == 1 and not obj.getVar("healthy") and obj.getVar("blight") == 2 then
                    obj.setRotationSmooth(Vector(0,180,0))
                    grabBlightCard(start)
                else
                    setupBlightCard(start, obj)
                end
            end,
        })
    else
        -- if there's only a single blight card just use it
        setupBlightCard(start, blightDeck)
    end
end
function findNextBlightCard(start, blightDeck)
    local index = getBlightCardIndex()
    if index < 0 then
        index = 1
    else
        index = index + 1
    end
    for i=index,#blightCards do
        if blightDeck.type == "Deck" then
            for j,data in pairs(blightDeck.getObjects()) do
                if data.name == blightCards[i] then
                    local card = blightDeck.takeObject({
                        index = data.index,
                        position = blightDeck.getPosition() + Vector(3.92, 1, 0),
                        callback_function = function(obj) setupBlightCard(start, obj) end,
                    })
                    return true
                end
            end
        else
            if blightDeck.getName() == blightCards[i] then
                setupBlightCard(start, blightDeck)
                return true
            end
        end
    end
    -- If the remaining cards can't be found remove them
    for i=#blightCards,index,-1 do
        table.remove(blightCards, i)
    end
    return false
end
function getBlightCardIndex()
    if blightedIslandCard ~= nil then
        for i,cardName in pairs(blightCards) do
            if cardName == blightedIslandCard.getName() then
                return i
            end
        end
    end
    return -1
end
function setupBlightCard(start, card)
    blightedIslandCard = card
    blightedIslandCard.setPositionSmooth(aidBoard.positionToWorld(Vector(-1.15,0.11,0.99)))
    blightedIslandCard.setLock(true)
    if start then
        addBlightedIslandButton()
    else
        startLuaCoroutine(Global, "BlightedIslandFlipPart2")
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
    if #blightBag.getObjects() ~= 0 then -- blightBag must be empty to flip this card!
        Player[playerColor].broadcast("There is still blight on the Blight Card!", Color.SoftYellow)
    elseif not gamePaused then
        BlightedIslandFlip()
    end
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
    startLuaCoroutine(Global, "BlightedIslandFlipPart2")
end
function BlightedIslandFlipPart2()
    if not blightedIslandCard.getVar("healthy") then
        hideBlightButton()
    end

    local index = getBlightCardIndex()
    if index == -1 then
        table.insert(blightCards, blightedIslandCard.getName())
    end

    blightedIslandCard.setRotationSmooth(Vector(0,180,0))
    local numBlight = blightedIslandCard.getVar("blight") * numBoards
    if not blightedIslandCard.getVar("healthy") and scenarioCard ~= nil then
        local blightTokens = scenarioCard.getVar("blightTokens")
        if blightTokens ~= nil then
            numBlight = numBlight + (blightTokens * numBoards)
        end
        blightTokens = scenarioCard.getVar("blightCount")
        if blightTokens ~= nil then
            numBlight = blightTokens
        end
    end
    for i=1, numBlight do
        blightBag.putObject(boxBlightBag.takeObject({position = blightBag.getPosition() + Vector(0,1,0)}))
    end
    wt(1)
    gamePaused = false -- to re-enable scripting buttons and object cleanup
    broadcastToAll(blightedIslandCard.getName()..": "..numBlight.." Blight Tokens Added", Color.SoftBlue)
    wt(1)
    broadcastToAll("Remember to check the blight card effect", Color.SoftBlue)
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
    local numBlight = 2 * numBoards
    if not useBlightCard then
        numBlight = 5 * numBoards
    end
    if SetupChecker.getVar("optionalBlightSetup") then
        numBlight = numBlight + 1
    end
    if scenarioCard ~= nil then
        local blightTokens = scenarioCard.getVar("setupBlightTokens")
        if blightTokens ~= nil then
            numBlight = numBlight + (blightTokens * numBoards)
        end
    end
    for i=1, numBlight do
        blightBag.putObject(boxBlightBag.takeObject({
            position = blightBag.getPosition() + Vector(0,1,0),
            smooth = false,
        }))
    end
end
----- Scenario section
function SetupScenario()
    for _,guid in pairs(SetupChecker.getVar("scenarios")) do
        if guid == "" then
        elseif scenarioCard == nil or scenarioCard.guid ~= guid then
            getObjectFromGUID(guid).destruct()
        end
    end

    if scenarioCard ~= nil then
        local targetScale = 1.71
        local currentScale = scenarioCard.getScale()[1]
        local scaleMult = (currentScale - targetScale)/20
        for i = 1, 20 do
            wt(0.02)
            scenarioCard.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
        end

        scenarioCard.setLock(true)
        scenarioCard.setRotationSmooth(Vector(0,180,0))
        scenarioCard.setPositionSmooth(aidBoard.positionToWorld(Vector(0.75,0.11,-1.81)))
    end

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return scenarioCard == nil or not scenarioCard.isSmoothMoving() end)
    return 1
end
----- Adversary Section
function SetupAdversary()
    for _,guid in pairs(SetupChecker.getVar("adversaries")) do
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
        local targetScale = 1.71
        local currentScale = adversaryCard.getScale()[1]
        local scaleMult = (currentScale - targetScale)/20
        for i = 1, 20 do
            wt(0.02)
            adversaryCard.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
            if adversaryCard2 ~= nil then
                adversaryCard2.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
            end
        end
    end

    -- Wait until Second Adversary board is in position before moving cards
    Wait.condition(function()
        if adversaryCard2 ~= nil then
            adversaryCard.setLock(true)
            adversaryCard.setPositionSmooth(secondAdversaryBoard.positionToWorld(Vector(0,0.21,0)))
            adversaryCard2.setLock(true)
            adversaryCard2.setPositionSmooth(aidBoard.positionToWorld(Vector(-0.75,0.11,-1.81)))
        elseif adversaryCard ~= nil then
            adversaryCard.setLock(true)
            adversaryCard.setPositionSmooth(aidBoard.positionToWorld(Vector(-0.75,0.11,-1.81)))
        end
    end, function() return boardSetup end)

    reminderSetup()
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
            UI.setAttribute("panelAdversary2Level1","text","1) "..ui.one.name)
            if ui.one.tooltip then
                UI.setAttribute("panelAdversary2Level1","tooltip",ui.one.tooltip)
            end
            UI.setAttribute("panelAdversary2Level1","active","true")
            lineCount = lineCount + 1
        end
        if ui.two then
            UI.setAttribute("panelAdversary2Level2","text","2) "..ui.two.name)
            if ui.two.tooltip then
                UI.setAttribute("panelAdversary2Level2","tooltip",ui.two.tooltip)
            end
            UI.setAttribute("panelAdversary2Level2","active","true")
            lineCount = lineCount + 1
        end
        if ui.three then
            UI.setAttribute("panelAdversary2Level3","text","3) "..ui.three.name)
            if ui.three.tooltip then
                UI.setAttribute("panelAdversary2Level3","tooltip",ui.three.tooltip)
            end
            UI.setAttribute("panelAdversary2Level3","active","true")
            lineCount = lineCount + 1
        end
        if ui.four then
            UI.setAttribute("panelAdversary2Level4","text","4) "..ui.four.name)
            if ui.four.tooltip then
                UI.setAttribute("panelAdversary2Level4","tooltip",ui.four.tooltip)
            end
            UI.setAttribute("panelAdversary2Level4","active","true")
            lineCount = lineCount + 1
        end
        if ui.five then
            UI.setAttribute("panelAdversary2Level5","text","5) "..ui.five.name)
            if ui.five.tooltip then
                UI.setAttribute("panelAdversary2Level5","tooltip",ui.five.tooltip)
            end
            UI.setAttribute("panelAdversary2Level5","active","true")
            lineCount = lineCount + 1
        end
        if ui.six then
            UI.setAttribute("panelAdversary2Level6","text","6) "..ui.six.name)
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
    if scenarioCard ~= nil and scenarioCard.getVar("invaderDeckSetup") then
        deckTable = scenarioCard.call("InvaderDeckSetup",{deck = deckTable})
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
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() local objs = zone.getObjects() return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == #deckTable end)
end
----- Event Deck Section
function SetupEventDeck()
    local decksSetup = 0
    if useBnCEvents then
        local BnCBag = getObjectFromGUID("ea7207")
        local deck = BnCBag.takeObject({
            guid = "05f7b7",
            position = getObjectFromGUID(eventDeckZone).getPosition(),
            rotation = {0,180,180},
        })
        Wait.condition(function()
            if SetupChecker.getVar("exploratoryWar") then
                deck.takeObject({
                    guid = "cfd4d1",
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        Wait.frames(function()
                            deck.putObject(temp)
                            deck.shuffle()
                            decksSetup = decksSetup + 1
                        end, 1)
                    end,
                })
            else
                decksSetup = decksSetup + 1
            end
        end, function() return not deck.loading_custom end)
        if SetupChecker.getVar("optionalStrangeMadness") then
            local strangeMadness = BnCBag.takeObject({
                guid = "0edac2",
                position = getObjectFromGUID(eventDeckZone).getPosition(),
                rotation = {0,180,180},
            })
            Wait.condition(function() decksSetup = decksSetup + 1 end, function() return not strangeMadness.loading_custom end)
        else
            decksSetup = decksSetup + 1
        end
    else
        decksSetup = decksSetup + 2
    end
    if useJEEvents then
        local JEBag = getObjectFromGUID("850ac1")
        local deck = JEBag.takeObject({
            guid = "299e38",
            position = getObjectFromGUID(eventDeckZone).getPosition(),
            rotation = {0,180,180},
        })
        Wait.condition(function() decksSetup = decksSetup + 1 end, function() return not deck.loading_custom end)
    else
        decksSetup = decksSetup + 1
    end
    if useBnCEvents or useJEEvents then
        Wait.condition(function()
            getObjectFromGUID(eventDeckZone).getObjects()[1].shuffle()
            stagesSetup = stagesSetup + 1
        end, function() return decksSetup == 3 and #getObjectFromGUID(eventDeckZone).getObjects() == 1 and not getObjectFromGUID(eventDeckZone).getObjects()[1].isSmoothMoving() end)
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
    if getMapCount({norm = true, them = true}) == 0 then
        if isThematic() then
            MapPlacen(boardLayouts[numBoards][boardLayout])
        else
            StandardMapBag.shuffle()
            if scenarioCard ~= nil and scenarioCard.getVar("boardSetup") then
                MapPlacen(scenarioCard.call("BoardSetup", { boards = numBoards }))
            else
                MapPlacen(boardLayouts[numBoards][boardLayout])
            end
        end
    else
        MapPlaceCustom()
    end
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return boardsSetup == numBoards end)
end
----- Post Setup Section
function PostSetup()
    aidBoard.call("setupGame", {})

    local postSetupSteps = 0
    local firstAdversarySetup = false
    local exploratoryPowersDone = false

    if adversaryCard == nil then
        difficultyString = difficultyString.."No Adversary\n"
    elseif adversaryCard2 == nil then
        difficultyString = difficultyString..adversaryCard.getName().." Level "..adversaryLevel.."\n"
    else
        difficultyString = difficultyString.."II: "..adversaryCard.getName().." Level "..adversaryLevel.."\n".."III: "..adversaryCard2.getName().." Level "..adversaryLevel2.."\n"
    end
    if scenarioCard == nil then
        difficultyString = difficultyString.."No Scenario\n"
    else
        difficultyString = difficultyString..scenarioCard.getName().."\n"
    end
    difficultyString = difficultyString.."Difficulty "..difficulty
    createDifficultyButton()

    if SetupChecker.getVar("exploratoryVOTD") then
        local deck = getObjectFromGUID(majorPowerZone).getObjects()[1]
        deck.takeObject({
            guid = "152fe0",
            callback_function = function(obj)
                local temp = obj.setState(2)
                Wait.frames(function()
                    deck.putObject(temp)
                    deck.shuffle()
                    postSetupSteps = postSetupSteps + 1
                    exploratoryPowersDone = true
                end, 1)
            end,
        })
    else
        postSetupSteps = postSetupSteps + 1
        exploratoryPowersDone = true
    end
    if SetupChecker.getVar("exploratoryBODAN") then
        local spirit = getObjectFromGUID("606f23").setState(2)
        if not SetupChecker.call("isSpiritPickable", {guid = "606f23"}) then
            Wait.condition(function() spirit.clearButtons() postSetupSteps = postSetupSteps + 1 end, function() return not spirit.loading_custom end)
        else
            postSetupSteps = postSetupSteps + 1
        end
    else
        postSetupSteps = postSetupSteps + 1
    end

    if adversaryCard ~= nil and adversaryCard.getVar("postSetup") then
        adversaryCard.call("PostSetup",{level = adversaryLevel, other={level=adversaryLevel2}})
        Wait.condition(function() postSetupSteps = postSetupSteps + 1 firstAdversarySetup = true end, function() return adversaryCard.getVar("postSetupComplete") end)
    else
        postSetupSteps = postSetupSteps + 1
        firstAdversarySetup = true
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("postSetup") then
        -- Wait for first adversary to finish
        Wait.condition(function()
            adversaryCard2.call("PostSetup",{level = adversaryLevel2, other={level=adversaryLevel}})
            Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return adversaryCard2.getVar("postSetupComplete") end)
        end, function() return firstAdversarySetup end)
    else
        postSetupSteps = postSetupSteps + 1
    end
    if scenarioCard ~= nil and scenarioCard.getVar("postSetup") then
        -- Wait for all exploratory powers to have state changed
        Wait.condition(function()
            scenarioCard.call("PostSetup",{})
            Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return scenarioCard.getVar("postSetupComplete") end)
        end, function() return exploratoryPowersDone end)
    else
        postSetupSteps = postSetupSteps + 1
    end

    if not useBnCEvents and not useJEEvents and (BnCAdded or JEAdded) then
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
            Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function()
                local objs = zone.getObjects()
                return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == #cards + 2
            end)
        end, function()
            local objs = zone.getObjects()
            return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == #cards + 1
        end)
    else
        postSetupSteps = postSetupSteps + 1
    end

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function()log(postSetupSteps) return postSetupSteps == 6 end)
    return 1
end
function createDifficultyButton()
    local buttonPos = Vector(-0.75,0,-2.75)
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
    exploratory()
    enableUI()
    seaTile.registerCollisions(false)
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
    if scenarioCard ~= nil then
        local broadcast = scenarioCard.getVar("broadcast")
        if broadcast ~= nil then
            wt(2)
            broadcastToAll(broadcast, "Blue")
        end
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
function exploratory()
end
function enableUI()
    local colors = {}
    for color,_ in pairs(PlayerBags) do
        if selectedColors[color] or Player[color].seated then
            table.insert(colors, color)
        end
    end
    UI.setAttribute("panelUIToggle","active","true")
    setVisiTable("panelTimePasses", colors)
    setVisiTable("panelReady", colors)
    setVisiTable("panelPowerDraw", colors)
end
------
function addSpirit(params)
    SetupChecker.call("addSpirit", params)
end
function removeSpirit(params)
    SetupChecker.call("removeSpirit", params)
    getObjectFromGUID(elementScanZones[params.color]).clearButtons()
    selectedColors[params.color] = {ready=params.ready, counter=params.counter, paid=false}
    updatePlayerArea(params.color)
end
function getEmptySeat()
    local orderedBlockGuids = {
        "c68e2c",
        "661aa3",
        "c3c59b",
        "36bbcc",
        "fac8e4",
        "6b5b4b",
    }
    for _,guid in pairs(orderedBlockGuids) do
        local color = getObjectFromGUID(guid).getVar("playerColor")
        if #getObjectFromGUID(PlayerBags[color]).getObjects() ~= 0 then
            return color
        end
    end
    return nil
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
        handlePiece(object, 0)
    end

    for color,data in pairs(selectedColors) do
        handlePlayer(color, data)
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
function handlePiece(object, offset)
    if string.sub(object.getName(),1,4) == "City" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset)
        end
    elseif string.sub(object.getName(),1,4) == "Town" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset)
        end
    elseif string.sub(object.getName(),1,8) == "Explorer" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset)
        end
    elseif string.sub(object.getName(),1,5) == "Dahan" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,0,0), offset)
        end
    elseif object.getName() == "Blight" then
        object = resetPiece(object, Vector(0,180,0), offset)
    elseif string.sub(object.getName(),-6) == "Defend" then
        if object.getLock() == false then
            object.destruct()
            object = nil
        end
    elseif string.sub(object.getName(),-7) == "Isolate" then
        if object.getLock() == false then
            object.destruct()
            object = nil
        end
    end
    return object
end
function resetPiece(object, rotation, offset)
    local objOffset = 0
    if object.getStateId() ~= -1 and object.getStateId() ~= 1 then
        objOffset = 1
    elseif not Vector.equals(object.getRotation(), rotation, 0.1) then
        objOffset = 1
    end
    local loopOffset = 0
    for _,obj in pairs(upCastRay(object,5)) do
        -- need to store tag since after state change tag isn't instantly updated
        local isFigurine = obj.type == "Figurine"
        obj = handlePiece(obj, offset + objOffset)
        if obj ~= nil then
            obj.setPositionSmooth(obj.getPosition() + Vector(0,offset + objOffset + loopOffset,0))
        end
        if isFigurine then
            -- Figurines are Invaders, Dahan, and Blight, you should only handle the one directly above you
            break
        end
        loopOffset = loopOffset + 0.1
    end
    if object.getStateId() ~= -1 and object.getStateId() ~= 1 then
        object.setRotationSmooth(rotation)
        object.setPositionSmooth(object.getPosition() + Vector(0,objOffset,0))
        object = object.setState(1)
    elseif not Vector.equals(object.getRotation(), rotation, 0.1) then
        object.setRotationSmooth(rotation)
        object.setPositionSmooth(object.getPosition() + Vector(0,objOffset,0))
    end
    return object
end
function handlePlayer(color, data)
    local zone = getObjectFromGUID(elementScanZones[color])
    for _, obj in ipairs(zone.getObjects()) do
        if obj.getName() == "Any" then
            if obj.getStateId() ~= 9 then obj = obj.setState(9) end
            if obj.getLock() == false then obj.destruct() end
        elseif obj.type == "Tile" and obj.getVar("elements") ~= nil then
            if obj.getLock() == false then obj.destruct() end
        elseif string.sub(obj.getName(),-6) == "Defend" then
            obj.destruct()
        elseif string.sub(obj.getName(),-7) == "Isolate" then
            obj.destruct()
        end
    end

    if data.paid then
        playerBlocks[color].editButton({index=1, label="Pay", click_function="payEnergy", color="Red", tooltip="Left click to pay energy for your cards"})
        data.paid = false
    end
    if not data.ready.is_face_down then
        data.ready.flip()
    end
end
------
scaleFactors = {
    -- Note that we scale the boards up more than the position, so the gaps
    -- don't increase in size.
    [true]={name = "Large", position = 1.09, size = Vector(7.15, 1, 7.15)},
    [false]={name = "Standard", position = 1, size = Vector(6.5, 1, 6.5)},
}
boardLayouts = {
    { -- 1 Board
        ["Balanced"] = {
            { pos = Vector(5.96, 1.08, 16.59), rot = Vector(0.00, 180.00, 0.00) },
        },
        ["Thematic"] = {
            { pos = Vector(-1.93, 1.08, 20.44), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
        },
    },
    { -- 2 Board
        ["Balanced"] = {
            { pos = Vector(9.13, 1.08, 25.29), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(0.29, 1.08, 10.21), rot = Vector(0.00, 0.00, 0.00) },
        },
        ["Thematic"] = {
            { pos = Vector(9.54, 1.08, 18.07), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(-10.34, 1.08, 18.04), rot = Vector(0.00, 180.00, 0.00), board = "W" },
        },
        ["Top to Top"] = {
            { pos = Vector(9.13, 1.08, 25.29), rot = Vector(0.00, 0.00, 0.00) },
            { pos = Vector(-0.06, 1.08, 9.62), rot = Vector(0.00, 180.00, 0.00) },
        },
        ["Coastline"] = {
            { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
            { pos = Vector(20.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        },
        ["Opposite Shores"] = {
            { pos = Vector(-4.22, 1.08, 18.91), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(13.78, 1.08, 19.09), rot = Vector(0.00, 0.00, 0.00) },
        },
        ["Fragment"] = {
            { pos = Vector(-5.20, 1.08, 18.87), rot = Vector(0.00, 90.00, 0.00) },
            { pos = Vector(10.12, 1.08, 19.08), rot = Vector(0.00, 330.00, 0.00) },
        },
        ["Inverted Fragment"] = {
            { pos = Vector(-5.44, 1.08, 18.99), rot = Vector(0.00, 270.00, 0.00) },
            { pos = Vector(10.12, 1.08, 19.08), rot = Vector(0.00, 330.00, 0.00) },
        },
    },
    { -- 3 Board
        ["Balanced"] = {
            { pos = Vector(2.33, 1.08, 26.80), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(2.46, 1.08, 11.54), rot = Vector(0.00, 60.00, 0.00) },
            { pos = Vector(15.70, 1.08, 19.37), rot = Vector(0.00, 300.00, 0.00) },
        },
        ["Thematic"] = {
            { pos = Vector(24.91, 1.08, 10.20), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(5.03, 1.08, 10.17), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(15.03, 1.08, 27.16), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
        },
        ["Coastline"] = {
            { pos = Vector(-2.47, 1.08, 10.29), rot = Vector(0.00, 240.69, 0.00) },
            { pos = Vector(15.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
            { pos = Vector(33.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        },
        ["Sunrise"] = {
            { pos = Vector(-6.01, 1.08, 10.63), rot = Vector(0.00, 60.00, 0.00) },
            { pos = Vector(7.19, 1.08, 18.54), rot = Vector(0.00, 300.00, 0.00) },
            { pos = Vector(20.60, 1.08, 10.69), rot = Vector(0.00, 0.00, 0.00) },
        },
    },
    { -- 4 Board
        ["Balanced"] = {
            { pos = Vector(2.36, 1.08, 26.47), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(20.40, 1.08, 26.64), rot = Vector(0.00, 0.00, 0.00) },
            { pos = Vector(-6.65, 1.08, 11.13), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(11.27, 1.08, 11.33), rot = Vector(0.00, 0.00, 0.00) },
        },
        ["Thematic"] = {
            { pos = Vector(29.29, 1.08, 10.20), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(9.41, 1.08, 10.17), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(19.41, 1.08, 27.16), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
            { pos = Vector(-0.62, 1.08, 27.04), rot = Vector(0.00, 180.00, 0.00), board = "NW" },
        },
        ["Leaf"] = {
            { pos = Vector(7.05, 1.08, 34.30), rot = Vector(0.00, 300.27, 0.00) },
            { pos = Vector(20.53, 1.08, 26.36), rot = Vector(0.00, 0.27, 0.00) },
            { pos = Vector(-2.00, 1.08, 18.53), rot = Vector(0.00, 120.27, 0.00) },
            { pos = Vector(11.39, 1.08, 10.92), rot = Vector(0.00, 0.27, 0.00) },
        },
        ["Snake"] = {
            { pos = Vector(35.36, 1.08, 37.55), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(8.26, 1.08, 22.19), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(26.45, 1.08, 22.36), rot = Vector(0.00, 0.05, 0.00) },
            { pos = Vector(-0.73, 1.08, 7.00), rot = Vector(0.00, 0.01, 0.00) },
        },
    },
    { -- 5 Board
        ["Balanced"] = {
            { pos = Vector(3.32, 1.08, 32.42), rot = Vector(0.00, 120.00, 0.00) },
            { pos = Vector(25.46, 1.08, 24.68), rot = Vector(0.00, 240.00, 0.00) },
            { pos = Vector(38.99, 1.08, 32.44), rot = Vector(0.00, 300.00, 0.00) },
            { pos = Vector(12.18, 1.08, 16.81), rot = Vector(0.00, 120.02, 0.00) },
            { pos = Vector(25.62, 1.08, 9.32), rot = Vector(0.00, 359.99, 0.00) },
        },
        ["Thematic"] = {
            { pos = Vector(30.89, 1.08, 23.51), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(11.01, 1.08, 23.48), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(21.01, 1.08, 40.47), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
            { pos = Vector(0.98, 1.08, 40.35), rot = Vector(0.00, 180.00, 0.00), board = "NW" },
            { pos = Vector(40.82, 1.08, 6.66), rot = Vector(0.00, 180.00, 0.00), board = "SE" },
        },
        ["Snail"] = {
            { pos = Vector(26.42, 1.08, 41.16), rot = Vector(0.00, 240.00, 0.00) },
            { pos = Vector(13.22, 1.08, 33.29), rot = Vector(0.00, 120.02, 0.00) },
            { pos = Vector(26.68, 1.08, 25.70), rot = Vector(0.00, 359.99, 0.00) },
            { pos = Vector(8.72, 1.08, 10.08), rot = Vector(0.00, 60.01, 0.00) },
            { pos = Vector(26.67, 1.08, 9.98), rot = Vector(0.00, 60.00, 0.00) },
        },
        ["Peninsula"] = {
            { pos = Vector(10.81, 1.08, 32.03), rot = Vector(0.00, 150.07, 0.00) },
            { pos = Vector(26.27, 1.08, 32.27), rot = Vector(0.00, 270.07, 0.00) },
            { pos = Vector(18.66, 1.08, 18.81), rot = Vector(0.00, 30.09, 0.00) },
            { pos = Vector(41.71, 1.08, 23.07), rot = Vector(0.00, 270.25, 0.00) },
            { pos = Vector(57.12, 1.08, 13.96), rot = Vector(0.00, 270.25, 0.00) },
        },
        ["V"] = {
            { pos = Vector(0.17, 1.08, 33.75), rot = Vector(0.00, 119.99, 0.00) },
            { pos = Vector(40.67, 1.08, 41.60), rot = Vector(0.00, 0.01, 0.00) },
            { pos = Vector(8.96, 1.08, 18.16), rot = Vector(0.00, 119.99, 0.00) },
            { pos = Vector(31.52, 1.08, 26.14), rot = Vector(0.00, 359.99, 0.00) },
            { pos = Vector(22.40, 1.08, 10.67), rot = Vector(0.00, 0.01, 0.00) },
        },
    },
    { -- 6 Board
        ["Balanced"] = {
            { pos = Vector(4.31, 1.08, 29.13), rot = Vector(0.00, 150.01, 0.00) },
            { pos = Vector(19.72, 1.08, 29.32), rot = Vector(0.00, 270.00, 0.00) },
            { pos = Vector(43.04, 1.08, 33.51), rot = Vector(0.00, 210.00, 0.00) },
            { pos = Vector(12.25, 1.08, 15.90), rot = Vector(0.00, 30.01, 0.00) },
            { pos = Vector(35.44, 1.08, 20.02), rot = Vector(0.00, 90.00, 0.00) },
            { pos = Vector(50.90, 1.08, 20.26), rot = Vector(0.00, 330.00, 0.00) },
        },
        ["Thematic"] = {
            { pos = Vector(33.53, 1.08, 23.51), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(13.65, 1.08, 23.48), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(23.65, 1.08, 40.47), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
            { pos = Vector(3.62, 1.08, 40.35), rot = Vector(0.00, 180.00, 0.00), board = "NW" },
            { pos = Vector(43.40, 1.08, 6.63), rot = Vector(0.00, 180.00, 0.00), board = "SE" },
            { pos = Vector(23.59, 1.08, 6.55), rot = Vector(0.00, 180.00, 0.00), board = "SW" },
        },
        ["Star"] = {
            { pos = Vector(33.19, 1.08, 40.36), rot = Vector(0.00, 330.00, 0.00) },
            { pos = Vector(40.94, 1.08, 26.76), rot = Vector(0.00, 30.00, 0.00) },
            { pos = Vector(33.16, 1.08, 13.18), rot = Vector(0.00, 90.00, 0.00) },
            { pos = Vector(17.52, 1.08, 13.25), rot = Vector(0.00, 149.99, 0.00) },
            { pos = Vector(9.71, 1.08, 26.79), rot = Vector(0.00, 210.00, 0.00) },
            { pos = Vector(17.50, 1.08, 40.33), rot = Vector(0.00, 269.99, 0.00) },
        },
        ["Flower"] = {
            { pos = Vector(22.76, 1.08, 43.03), rot = Vector(0.00, 162.62, 0.00) },
            { pos = Vector(33.80, 1.08, 22.36), rot = Vector(0.00, 282.64, 0.00) },
            { pos = Vector(46.88, 1.08, 10.07), rot = Vector(0.00, 282.62, 0.00) },
            { pos = Vector(18.70, 1.08, 25.55), rot = Vector(0.00, 162.65, 0.00) },
            { pos = Vector(23.48, 1.08, 10.88), rot = Vector(0.00, 42.62, 0.00) },
            { pos = Vector(6.30, 1.08, 5.69), rot = Vector(0.00, 42.61, 0.00) },
        },
        ["Caldera"] = {
            { pos = Vector(-0.20, 1.08, 31.44), rot = Vector(0.00, 120.42, 0.00) },
            { pos = Vector(13.16, 1.08, 39.17), rot = Vector(0.00, 240.44, 0.00) },
            { pos = Vector(31.10, 1.08, 38.86), rot = Vector(0.00, 240.43, 0.00) },
            { pos = Vector(8.54, 1.08, 15.76), rot = Vector(0.00, 120.46, 0.00) },
            { pos = Vector(31.18, 1.08, 23.41), rot = Vector(0.00, 0.43, 0.00) },
            { pos = Vector(21.95, 1.08, 8.04), rot = Vector(0.00, 0.42, 0.00) },
        },
    },
}
themGuids = {
    ["NW"] = "e0c325",
    ["NE"] = "bd6555",
    ["W"] = "9d9b8f",
    ["E"] = "051c66",
    ["SW"] = "0f2e60",
    ["SE"] = "505d5d",
}
themRedoGuids = {
    ["NW"] = "a0e5c0",
    ["NE"] = "14a35f",
    ["W"] = "bdaa82",
    ["E"] = "f14363",
    ["SW"] = "ffa7e6",
    ["SE"] = "214c72",
}
----
function GenerateMapData()
    boards = getMapTiles()
    while true do
        local moving = false
        for i, obj in pairs(boards) do
            if obj.isSmoothMoving() then
                moving = true
                break
            end
        end
        if not moving then break end
        coroutine.yield()
    end
    noteLines = {}
    table.insert(noteLines, "boardLayout = {")
    table.insert(noteLines, "    -- ...")
    table.insert(noteLines, "    { -- <num> Boards")
    table.insert(noteLines, "        -- ...")
    table.insert(noteLines, "        [\"<map name>\"] = {")
    for i, board in pairs(boards) do
        local pos, rot = board.getPosition(), board.getRotation()
        local themBoard = ""
        if board.hasTag("Thematic") then
            themBoard = ", board = \"" .. board.getName() .. "\""
        end
        local t = string.format(
            "{ pos = Vector(%.2f, %.2f, %.2f), rot = Vector(%.2f, %.2f, %.2f)%s },",
            pos.x, pos.y, pos.z,
            rot.x, rot.y, rot.z,
            themBoard
        )
        table.insert(noteLines, "            " .. t)
    end
    table.insert(noteLines, "        },")
    table.insert(noteLines, "        -- ...")
    table.insert(noteLines, "}")
    Notes.addNotebookTab({
        title = "New Map Layout",
        body = table.concat(noteLines, "\n") .. "\n",
    })
end
----
function getMapCount(params)
    local count = 0
    for _,obj in pairs(upCast(seaTile,1,0,0.9)) do
        if params.norm and obj.hasTag("Balanced") then
            count = count + 1
        elseif params.them and obj.hasTag("Thematic") then
            count = count + 1
        end
    end
    return count
end

function getMapTiles()
    local mapTiles = {}
    for _,obj in pairs(upCast(seaTile,1,0,0.9)) do
        if obj.hasTag("Balanced") or obj.hasTag("Thematic") then
            table.insert(mapTiles,obj)
        end
    end
    return mapTiles
end

function MapPlaceCustom()
    local maps = getMapTiles()
    -- board type is guaranteed to either be thematic or normal, and there has to be at least one map tile in the table
    if maps[1].hasTag("Balanced") then
        boardLayout = "Custom"
    else
        boardLayout = "Thematic"
    end
    SetupChecker.call("updateDifficulty", {})

    local rand = 0
    if SetupChecker.getVar("optionalExtraBoard") then
        rand = math.random(1,numBoards)
    end
    for i,map in pairs(maps) do
        map.setLock(true)
        map.interactable = false
        setupMap(map,i==rand)
    end
end

function MapPlacen(boards)
    local rand = 0
    local BETaken = false
    local DFTaken = false
    if SetupChecker.getVar("optionalExtraBoard") then
        rand = math.random(1,#boards)
    end

    -- We use the average position of the boards in the island layout
    -- as the origin to scale from.
    local scaleOrigin = Vector(0,0,0)
    for _, board in pairs(boards) do
        scaleOrigin = scaleOrigin + board.pos
    end
    scaleOrigin = scaleOrigin * (1./#boards)

    local count = 1
    for i, board in pairs(boards) do
        local temp = nil
        if isThematic() then
            if SetupChecker.getVar("optionalThematicRedo") then
                temp = MJThematicMapBag.takeObject({
                    position = MJThematicMapBag.getPosition() + Vector(0,-5,0),
                    guid = themRedoGuids[board.board],
                    smooth = false,
                    callback_function = function(obj) BoardCallback(obj, board.pos, board.rot, i==rand, scaleOrigin) end,
                })
            else
                temp = ThematicMapBag.takeObject({
                    position = ThematicMapBag.getPosition() + Vector(0,-5,0),
                    guid = themGuids[board.board],
                    smooth = false,
                    callback_function = function(obj) BoardCallback(obj, board.pos, board.rot, i==rand, scaleOrigin) end,
                })
            end
        else
            local list = StandardMapBag.getObjects()
            local index = 1
            for _,value in pairs(list) do
                if selectedBoards[count] ~= nil then
                    if value.name == selectedBoards[count] then
                        index = value.index
                        break
                    end
                elseif #boards <= 4 and SetupChecker.getVar("optionalBoardPairings") then
                    if value.name == "B" or value.name == "E" then
                        if not BETaken then
                            BETaken = true
                            index = value.index
                            break
                        end
                    elseif value.name == "D" or value.name == "F" then
                        if not DFTaken then
                            DFTaken = true
                            index = value.index
                            break
                        end
                    else
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
                callback_function = function(obj) BoardCallback(obj, board.pos, board.rot, i==rand, scaleOrigin) end,
            })
            if selectedBoards[count] == nil then
                table.insert(selectedBoards, temp.getName())
            end
            count = count + 1
        end
    end
end
function BoardCallback(obj,pos,rot,extra, scaleOrigin)
    obj.interactable = false
    obj.setLock(true)
    obj.setRotationSmooth(rot, false, true)
    local scaleFactor = scaleFactors[SetupChecker.getVar("optionalScaleBoard")]
    obj.setPositionSmooth(scaleFactor.position*pos + (1-scaleFactor.position)*scaleOrigin, false, true)
    Wait.condition(function() setupMap(obj,extra) end, function() return obj.resting and not obj.loading_custom end)
end
setupMapCoObj = nil
function setupMap(map,extra)
    setupMapCoObj = map
    if extra then
        startLuaCoroutine(Global, "setupMapCoExtra")
    else
        startLuaCoroutine(Global, "setupMapCoNoExtra")
    end
end
function setupMapCoNoExtra()
    return setupMapCo(false)
end
function setupMapCoExtra()
    return setupMapCo(true)
end
function setupMapCo(extra)
    local map = setupMapCoObj
    local piecesToPlace = map.getTable("pieceMap")
    local posToPlace = map.getTable("posMap")
    local originalPieces = map.getTable("pieceMap")

    if not map.hasTag("Thematic") then -- if not a thematic board
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

    if extra and numPlayers < 5 then
        local townFound = false
        local cityFound = false
        for i=1,#piecesToPlace do
            for j=#piecesToPlace[i],1,-1 do
                if string.sub(piecesToPlace[i][j],1,8) == "Explorer" then
                    table.remove(piecesToPlace[i],j)
                elseif string.sub(piecesToPlace[i][j],1,4) == "Town" then
                    if numPlayers == 4 and not townFound then
                        townFound = true
                    else
                        table.remove(piecesToPlace[i],j)
                    end
                elseif string.sub(piecesToPlace[i][j],1,4) == "City" then
                    if numPlayers == 3 and not cityFound and i < 4 then
                        cityFound = true
                    else
                        table.remove(piecesToPlace[i],j)
                    end
                end
            end
        end
        if not townFound and numPlayers == 4 then
            for i=1,3 do
                for j,v in pairs (originalPieces[i]) do
                    if string.sub(v,1,4) == "City" then
                        table.insert(piecesToPlace[i],j, v)
                        townFound = true
                        break
                    end
                end
                if townFound then
                    break
                end
            end
            if not townFound then
                for i=1,3 do
                    for j,v in pairs (originalPieces[i]) do
                        if string.sub(v,1,4) == "Town" then
                            table.insert(piecesToPlace[i],j, v)
                            townFound = true
                            break
                        end
                    end
                    if townFound then
                        break
                    end
                end
            end
        elseif not cityFound and numPlayers == 3 then
            for i=1,3 do
                for j,v in pairs (originalPieces[i]) do
                    if string.sub(v,1,4) == "Town" then
                        table.insert(piecesToPlace[i],j, v)
                        cityFound = true
                        break
                    end
                end
                if cityFound then
                    break
                end
            end
        end
    end

    if scenarioCard ~= nil and scenarioCard.getVar("mapSetup") then
        piecesToPlace = scenarioCard.call("MapSetup", {pieces = piecesToPlace, original = originalPieces, extra = extra})
    end
    -- supporting adversary setup should happen before primary
    if adversaryCard2 ~= nil and adversaryCard2.getVar("mapSetup") then
        piecesToPlace = adversaryCard2.call("MapSetup", {level = adversaryLevel2, pieces = piecesToPlace, guid = map.guid, original = originalPieces, extra = extra})
    end
    if adversaryCard ~= nil and adversaryCard.getVar("mapSetup") then
        piecesToPlace = adversaryCard.call("MapSetup", {level = adversaryLevel, pieces = piecesToPlace, guid = map.guid, original = originalPieces, extra = extra})
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
    elseif objName == "TownS" then
        place("Town",placePos,droppingPlayerColor)
        if BnCAdded or JEAdded then
            Wait.time(function() place("Strife",placePos + Vector(0,1,0),droppingPlayerColor) end, 0.5)
        end
    elseif objName == "ExplorerS" then
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
                -- TODO extract this logic into adversary
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
    elseif objName == "Box Blight" then
        temp = boxBlightBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
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
    elseif objName == "Defend Token" then
        if droppingPlayerColor and defendBags[droppingPlayerColor] then
            temp = defendBags[droppingPlayerColor].takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            temp = defendBags["White"].takeObject({position = placePos,rotation = Vector(0,180,0)})
        end
    elseif objName == "Isolate Token" then
        if droppingPlayerColor and isolateBags[droppingPlayerColor] then
            temp = isolateBags[droppingPlayerColor].takeObject({position = placePos,rotation = Vector(0,180,180)})
        end
    elseif objName == "1 Energy" then
        temp = oneEnergyBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "3 Energy" then
        temp = threeEnergyBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
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

-- one-indexed table
Pieces = {
    "Explorer",
    "Town",
    "City",
    "Blight",
    "Badlands",
    "Strife",
    "Beasts",
    "Wilds",
    "Disease",
    "Dahan",
    "Defend Token",
    "Isolate Token",
    "1 Energy",
    "3 Energy",
    "Box Blight",
}

function DropPiece(piece, cursorLocation, droppingPlayerColor)
    if not gameStarted or gamePaused then
        return
    end
    place(piece, cursorLocation + Vector(0,2,0), droppingPlayerColor)
end

function deleteObject(obj, fear)
    local bag = nil
    local removeObject = true
    if string.sub(obj.getName(),1,5) == "Dahan" then
        obj.setRotation(Vector(0,0,0))
        bag = dahanBag
    elseif string.sub(obj.getName(),1,8) == "Explorer" then
        obj.setRotation(Vector(0,180,0))
        bag = explorerBag
    elseif string.sub(obj.getName(),1,4) == "Town" then
        obj.setRotation(Vector(0,180,0))
        bag = townBag
        if fear then
            aidBoard.call("addFear")
            aidBoard.call("addFear")
        end
    elseif string.sub(obj.getName(),1,4) == "City" then
        obj.setRotation(Vector(0,180,0))
        bag = cityBag
        if fear then
            aidBoard.call("addFear")
            aidBoard.call("addFear")
            aidBoard.call("addFear")
        end
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
        if not obj.hasTag("Destroy") then
            removeObject = false
        end
    end

    if removeObject and (bag == nil or bag.type == "Infinite") then
        obj.destruct()
    elseif removeObject then
        obj.highlightOff()
        if obj.getStateId() ~= -1 and obj.getStateId() ~= 1 then
            obj = obj.setState(1)
        end
        bag.putObject(obj)
    end
end
----
function refreshScore()
    local dahan = math.floor(#getObjectsWithTag("Dahan") / numBoards)
    local blight = #getObjectsWithTag("Blight")
    if SetupChecker.call("isSpiritPickable", {guid="4c061f"}) then
        -- TODO figure out a more elegant solution here
        blight = blight - 2
    end
    blight = math.floor(blight / numBoards)

    local invaderDeck = getObjectFromGUID(invaderDeckZone).getObjects()[1]
    local deckCount = 0
    if invaderDeck ~= nil and Vector.equals(invaderDeck.getRotation(), Vector(0,180,180), 0.1) then
        if invaderDeck.type == "Deck" then
            for _,obj in pairs(invaderDeck.getObjects()) do
                for _,tag in pairs(obj.tags) do
                    if tag == "Invader Card" then
                        deckCount = deckCount + 1
                        break
                    end
                end
            end
        elseif invaderDeck.type == "Card" and invaderDeck.hasTag("Invader Card") then
            deckCount = 1
        end
    end
    local win = math.floor(5 * difficulty) + 10 + 2 * deckCount + dahan - blight
    local lose = 2 * difficulty + aidBoard.getVar("numCards") + aidBoard.call("countDiscard", {}) + dahan - blight

    UI.setAttribute("scoreWin", "text", "Victory: "..win)
    UI.setAttribute("scoreLose", "text", "Defeat: "..lose)
end
-----
spiritsScanned = {}
function spiritUpdater()
    local sScript = sourceSpirit.getLuaScript()
    for _,v in pairs(getObjectsWithTag("Spirit")) do
        if not spiritsScanned[v.guid] then
            spiritsScanned[v.guid] = true
            if v.getLuaScript() ~= sScript then
                v.setLuaScript(sScript)
                v = v.reload()
                broadcastToAll(v.getName().." has been updated to the current version!")
            end
        end
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
        origin = obj.getBoundsNormalized().center,
        direction = Vector(0,1,0),
        max_distance = dist,
        --debug = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if v.hit_object ~= obj and not obj.hasTag("Balanced") and not obj.hasTag("Thematic") then
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
                if v.hit_object.type == t then matchesTag = true end
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

-- Updates the selected player color's player area.  Does nothing if they don't have one.
-- Returns TRUE if an update occured, FALSE if no such player area existed.
function updatePlayerArea(color)
    local obj = playerBlocks[color]
    if obj then
        obj.call("setupPlayerArea")
        return true
    end
    return false
end
-- Updates all player areas.
function updateAllPlayerAreas()
    for _,obj in pairs(playerBlocks) do
        obj.call("setupPlayerArea")
    end
end

function setupPlayerArea(params)
    -- Figure out what color we're supposed to be, or if playerswapping is even allowed.
    local obj = params.obj
    local timer = obj.getVar("timer")  -- May be nil
    local initialized = obj.getVar("initialized")
    local color
    for k, v in pairs(playerBlocks) do
        if v.guid == obj.guid then
            color = k
            break
        end
    end
    obj.setVar("playerColor", color)
    local selected = selectedColors[color]

    local playerReadyGuids = aidBoard.getTable("playerReadyGuids")
    if not selected then
        local readyIndicator = getObjectFromGUID(playerReadyGuids[color])
        local buttons = readyIndicator.getButtons()
        if buttons and #buttons > 0 then
            readyIndicator.editButton({index=0, label=""})
        end
    end
    if not initialized and selected then
        obj.setVar("initialized", true)
        -- Energy Cost (button index 0)
        obj.createButton({
            label="Energy Cost: ?", click_function="nullFunc",
            position={0,3.2,-11.2}, rotation={0,180,0}, height=0, width=0,
            font_color={1,1,1}, font_size=500
        })
        -- Pay Energy (button index 1)
        obj.createButton({
            label="", click_function="nullFunc", function_owner=Global,
            position={-5,3.2,-11.2}, rotation={0,180,0}, height=0, width=0,
            font_color="White", font_size=500,
        })
        -- Other buttons to follow/be fixed later.
    elseif initialized and not selected then
        obj.setVar("initialized", false)
        obj.clearButtons()
    end

    for _,bag in pairs(params.elementBags) do
        local position = bag.getPosition()
        if selected then
            position.y = -0.74
        else
            position.y = -1.4
        end
        bag.setPosition(position)

        if not initialized and selected then
            bag.createButton({
                label="?", click_function="nullFunc",
                position={0,2.04,1.05}, rotation={0,0,0}, height=0, width=0,
                font_color={1,1,1}, font_size=450
            })
        elseif initialized and not selected then
            bag.clearButtons()
        end
    end
    local position = params.anyBag.getPosition()
    if selected then
        position.y = -0.74
    else
        position.y = -1
    end
    params.anyBag.setPosition(position)
    position = defendBags[color].getPosition()
    if selected then
        position.y = 0.95
    else
        position.y = 0.5
    end
    defendBags[color].setPosition(position)
    position = isolateBags[color].getPosition()
    if selected then
        position.y = 0.95
    else
        position.y = 0.5
    end
    isolateBags[color].setPosition(position)

    if not selected then
        if timer then  -- No spirit, but a running timer.
            Wait.stop(timer)
            timer = nil
            obj.setVar("timer", timer)
        end
        return
    end

    if selected.paid then
        obj.editButton({index=1, label="Paid", click_function="refundEnergy", color="Green", height=600, width=1200, tooltip="Right click to refund energy for your cards"})
    else
        obj.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", height=600, width=1200, tooltip="Left click to pay energy for your cards"})
    end

    local energy = 0

    local function elemStrToArr(elemStr)
        local outArr = {}
        for i = 1, string.len(elemStr) do
            table.insert(outArr,(math.floor(string.sub(elemStr, i, i))))
        end
        return outArr
    end

    local function elemCombine(inTableOfElemStrCards)
        outTable = {0,0,0,0,0,0,0,0}
        for i = 1, #inTableOfElemStrCards do
            local elemTable = elemStrToArr(inTableOfElemStrCards[i].getVar("elements"))
            for j = 1, 8 do
                outTable[j] = outTable[j] + elemTable[j]
            end
            if inTableOfElemStrCards[i].getVar("energy") ~= nil then
                energy = energy + inTableOfElemStrCards[i].getVar("energy")
            end
        end
        return outTable
    end

    local function countItems()
        local totalValue = 0
        local zone = params.zone
        local itemsInZone = zone.getObjects()
        local elemCardTable = {}
        energy = 0
        --Go through all items found in the zone
        for _, entry in ipairs(itemsInZone) do
            --Ignore non-cards
            if entry.type == "Card" then
                --Ignore if no elements entry
                if entry.getVar("elements") ~= nil then
                    if not entry.is_face_down and entry.getPosition().z > zone.getPosition().z then
                        table.insert(elemCardTable, entry)
                    end
                end
            elseif entry.type == "Tile" then
                if entry.getVar("elements") ~= nil then
                    table.insert(elemCardTable, entry)
                end
            end
        end
        combinedElements = elemCombine(elemCardTable)
        params.obj.editButton({index=0, label="Energy Cost: "..energy})
        for i,v in ipairs(combinedElements) do
            params.elementBags[i].editButton({index=0, label=v})
        end
        --Updates the number display
    end
    countItems()    -- Update counts immediately.
    if not timer then   -- Timer doesn't already exist.
        timer = Wait.time(countItems, 1, -1)
        obj.setVar("timer", timer)
    end
end
function payEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif alt_click then
        return
    elseif playerBlocks[source_color] ~= target_obj then
        return
    end

    local paid = updateEnergyCounter(source_color, false)
    if not paid then
        paid = payEnergyTokens(source_color)
    end
    if paid then
        selectedColors[source_color].paid = true
        target_obj.editButton({index=1, label="Paid", click_function="refundEnergy", color="Green", tooltip="Right click to refund energy for your cards"})
    else
        Player[source_color].broadcast("You don't have enough energy", Color.SoftYellow)
    end
end
function updateEnergyCounter(color, refund)
    if selectedColors[color].counter == nil or not selectedColors[color].counter.getLock() then
        return false
    end
    local cost = getEnergyLabel(color)
    local energy = selectedColors[color].counter.getValue()
    if not refund and cost > energy then
        return false
    end
    if refund then
        cost = cost * -1
    end
    selectedColors[color].counter.setValue(energy - cost)
    return true
end
function payEnergyTokens(color)
    local cost = getEnergyLabel(color)
    local energy = 0
    local zone = getObjectFromGUID(elementScanZones[color])
    local objects = zone.getObjects()
    for _, obj in ipairs(objects) do
        if obj.type == "Chip" then
            local quantity = obj.getQuantity()
            if quantity == -1 then
                quantity = 1
            end
            if obj.getName() == "1 Energy" then
                energy = energy + (1 * quantity)
            elseif obj.getName() == "3 Energy" then
                energy = energy + (3 * quantity)
            end
        end
    end
    if cost > energy then
        return false
    end
    for _, obj in ipairs(objects) do
        if obj.type == "Chip" then
            local quantity = obj.getQuantity()
            if quantity == -1 then
                quantity = 1
            end
            if obj.getName() == "1 Energy" then
                cost = cost - (1 * quantity)
                obj.destruct()
            elseif obj.getName() == "3 Energy" then
                cost = cost - (3 * quantity)
                obj.destruct()
            end
            if cost <= 0 then
                break
            end
        end
    end
    if cost < 0 then
        refundEnergyTokens(color, -cost)
    end
    return true
end
function getEnergyLabel(color)
    local energy = playerBlocks[color].getButtons()[1].label
    energy = tonumber(string.sub(energy, 14, -1))
    if energy == nil then
        energy = 0
    end
    return energy
end
function refundEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif not alt_click then
        return
    elseif playerBlocks[source_color] ~= target_obj then
        return
    end

    local refunded = updateEnergyCounter(source_color, true)
    if not refunded then
        refunded = refundEnergyTokens(source_color, nil)
    end
    if refunded then
        selectedColors[source_color].paid = false
        target_obj.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", tooltip="Left click to pay energy for your cards"})
    else
        Player[source_color].broadcast("Was unable to refund energy", Color.SoftYellow)
    end
end
function refundEnergyTokens(color, energy)
    if energy == nil then
        energy = getEnergyLabel(color)
    end
    local zone = getObjectFromGUID(elementScanZones[color])
    while energy >= 3 do
        threeEnergyBag.takeObject({
            position = zone.getPosition()+Vector(-10,2,-5),
            rotation = Vector(0,180,0),
        })
        energy = energy - 3
    end
    while energy >= 1 do
        oneEnergyBag.takeObject({
            position = zone.getPosition()+Vector(-10,2,-3),
            rotation = Vector(0,180,0),
        })
        energy = energy - 1
    end
    return true
end

function setupSwapButtons()
    for color,obj in pairs(playerTables) do
        obj.setVar("playerColor", color)
        local scale = flipVector(Vector(obj.getScale()))
        scale = scale * 2
        -- Sit Here (button index 0)
        obj.createButton({
            label="", click_function="onClickedSitHere", function_owner=Global,
            position={-3.25,0.4,4.75}, rotation={0,0,0}, height=0, width=0, scale=scale,
            font_color={0,0,0}, font_size=250,
            tooltip="Moves your current player color to be located here. The color currently seated here will be moved to your current location. Spirit panels and other cards will be relocated if applicable.",
        })
        -- Change Color (button index 1)
        obj.createButton({
            label="", click_function="onClickedChangeColor", function_owner=Global,
            position={3.25,0.4,4.75}, rotation={0,0,0}, height=0, width=0, scale=scale,
            font_color={0,0,0}, font_size=250,
            tooltip="Change to be this color, updating all of your presence and reminder tokens accordingly. The player that is this color will be changed to be yours. Your seating position will not change.",
        })
        -- Play Spirit (button index 2)
        obj.createButton({
            label="", click_function="onClickedPlaySpirit", function_owner=Global,
            position={0,0.4,4.75}, rotation={0,0,0}, height=0, width=0, scale=scale,
            font_color={0,0,0}, font_size=250,
            tooltip="Switch to play the spirit that is here, changing your player color accordingly. Only available for spirits without a seated player. Intended for multi-handed solo games.",
        })
    end
    updateSwapButtons()
end
function flipVector(vec)
    vec.x = 1/vec.x
    vec.y = 1/vec.y
    vec.z = 1/vec.z
    return vec
end
function updateSwapButtons()
    for color,obj in pairs(playerTables) do
        if showPlayerButtons then
            local bg = Color[color]
            local fg
            if (bg.r*0.30 + bg.g*0.59 + bg.b*0.11) > 0.50 then
                fg = {0,0,0}
            else
                fg = {1,1,1}
            end
            obj.editButton({index=0, label="Sit Here", height=400, width=1500})
            obj.editButton({index=1, label="Pick " .. color, height=400, width=1500, color=bg, font_color=fg})
        else
            obj.editButton({index=0, label="", height=0, width=0})
            obj.editButton({index=1, label="", height=0, width=0})
        end
        updatePlaySpiritButton(color)
    end
end
function updatePlaySpiritButton(color)
    if Player[color].seated or (not selectedColors[color] and not showAllMultihandedButtons) then
        playerTables[color].editButton({index=2, label="", height=0, width=0})
    else
        playerTables[color].editButton({index=2, label="Play Spirit", height=400, width=1500})
    end
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
function toggleFearUI(player)
    colorEnabled = getCurrentState("panelFear", player.color)
    toggleUI("panelFear", player.color, colorEnabled)
end
function toggleBlightUI(player)
    colorEnabled = getCurrentState("panelBlight", player.color)
    toggleUI("panelBlight", player.color, colorEnabled)
end
function togglePowerDrawUI(player)
    colorEnabled = getCurrentState("panelPowerDraw", player.color)
    toggleUI("panelPowerDraw", player.color, colorEnabled)
end
function toggleScoreUI(player)
    colorEnabled = getCurrentState("panelScore", player.color)
    toggleUI("panelScore", player.color, colorEnabled)
end
function togglePlayerControls(player)
    if not player.admin then
        player.broadcast("Only promoted players can toggle seat controls.")
        return
    end
    showPlayerButtons = not showPlayerButtons
    updateSwapButtons()
end
function toggleMultihanded(player)
    if not player.admin then
        player.broadcast("Only promoted players can toggle multihanded options.")
        return
    end
    showAllMultihandedButtons = not showAllMultihandedButtons
    updateSwapButtons()
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
        local newTab = {}
        for i,v in ipairs(tab) do
            newTab[i] = table.concat(v,",")
        end
        return table.concat(newTab,"|")
    end
    return cc2(t1) == cc2(t2)
end

function swapPlayerAreaColors(a, b)
    if a == b then return end
    local function tableSwap(table)
        table[a], table[b] = table[b], table[a]
    end
    local function positionSwap(table)
        local oa = table[a]
        local ob = table[b]
        if type(oa) == "string" then
            oa = getObjectFromGUID(oa)
            ob = getObjectFromGUID(ob)
        end
        local ta = oa.getPosition()
        local tb = ob.getPosition()
        oa.setPosition(tb)
        ob.setPosition(ta)
    end
    local function handSwap(i)
        local ta = Player[a].getHandTransform(i)
        local tb = Player[b].getHandTransform(i)
        Player[a].setHandTransform(tb, i)
        Player[b].setHandTransform(ta, i)
    end

    for i = 1,2 do
        handSwap(i)
    end
    positionSwap(playerTables)
    tableSwap(playerBlocks)
    positionSwap(defendBags)
    positionSwap(isolateBags)
    tableSwap(elementScanZones)
    updatePlayerArea(a)
    updatePlayerArea(b)
end

function swapPlayerAreaObjects(a, b)
    if a == b then return end
    local swaps = {[a] = b, [b] = a}
    local tables = {[a] = playerTables[a], [b] = playerTables[b]}
    local zones = {}
    local buttons = {}
    local objects = {}
    for color,playerTable in pairs(tables) do
        local t = upCast(playerTable, 50)
        for _,obj in ipairs(Player[color].getHandObjects(2)) do
            table.insert(t, obj)
        end
        objects[color] = t
        local zone = getObjectFromGUID(elementScanZones[color])
        zones[color] = zone
        local zoneButtons = zone.getButtons()
        buttons[color] = zoneButtons
        if zoneButtons then
            for i = #zoneButtons - 1, 0, -1 do
                zone.removeButton(i)
            end
        end
    end
    for from,to in pairs(swaps) do
        local transform = tables[to].getPosition() - tables[from].getPosition()
        for _,obj in ipairs(objects[from]) do
            if obj.interactable then
                obj.setPosition(obj.getPosition() + transform)
            end
        end
        if buttons[from] then
            for _,button in ipairs(buttons[from]) do
                zones[to].createButton(button)
            end
        end
    end
end

function swapPlayerAreas(a, b)
    if(a == b) then return end
    swapPlayerAreaObjects(a, b)
    swapPlayerAreaColors(a, b)
    printToAll(a .. " swapped places with " .. b .. ".", Color[a])
end

function swapPlayerPresenceColors(fromColor, toColor)
    if fromColor == toColor then return end
    local function initData(color, ix, oppositeColor)
        bag = getObjectFromGUID(PlayerBags[color])
        return {
            color = color,
            ix = ix,
            bag = bag,
            qty = bag.getQuantity(),
            tints = {},
            objects = {},
            pattern = color .. "'s (.*)",
            bagContents = {},
            oppositeColor = oppositeColor,
        }
    end
    local colors = {
        from = initData(fromColor, 1, toColor),
        to = initData(toColor, 2, fromColor)
    }
    local specialTokens = {
        Defend = defendBags,
        Isolate = isolateBags,
    }

    -- If both bags are full, there's not a lot of work to do.
    -- Unfortunately, we still need to loop through other things because of defend tokens that aren't in bags.
    local fastSwap = (colors.from.qty == 14 and colors.to.qty == 14)
    -- Just bail out fast.

    selectedColors[fromColor], selectedColors[toColor] = selectedColors[toColor], selectedColors[fromColor]

    if not fastSwap then
        -- Remove any items still in the bags
        -- NOTE: TTS's documentation suggests we may need to wait a physics frame after doing this,
        -- but this seems to work fine without doing that.  If something goes awry with this code in the future,
        -- you might try re-adding the delay.
        for color,data in pairs(colors) do
            for i = 1,data.qty do
                local obj = data.bag.takeObject({
                    sound=false,
                    position={x=data.ix*2, z=200, y=i*2}    -- Chosen to be out-of-the-way and to prevent items from stacking.
                })
                table.insert(data.bagContents, obj)
            end
        end
    end

    -- Pass 1: Iterate over all objects looking for "<color>'s X".
    -- Make a note of what we find and what tint it is. Handle Isolate and Defend tokens in this pass.
    local match = string.match  -- Performance
    local name, suffix
    for _,obj in pairs(getAllObjects()) do
        name = obj.getName()
        if name then
            for _,data in pairs(colors) do
                suffix = match(name, data.pattern)
                if suffix then
                    if specialTokens[suffix] then
                        local state = obj.getStateId()
                        local attrs = {position = obj.getPosition(), rotation = obj.getRotation(), smooth = false}
                        local locked = obj.getLock()
                        destroyObject(obj)
                        obj = specialTokens[suffix][data.oppositeColor].takeObject(attrs)
                        obj.setLock(locked)
                        obj.setState(state)
                    elseif not fastMode then
                        data.tints[suffix] = obj.getColorTint()
                        if not data.objects[suffix] then
                            data.objects[suffix] = {obj}
                        else
                            table.insert(data.objects[suffix], obj)
                        end
                    end
                end
            end
        end
    end

    -- Pass 2: Iterate over found objects and swap color tints and object names.
    -- After we're done, put objects in their new presence bag, if applicable.
    if fastMode then
        -- All's we did is maybe recolor some isolate and defend tokens, so we can skip the rest of this.
        return
    end
    for _,ab in pairs({{colors.from, colors.to}, {colors.to, colors.from}}) do
        local a, b = unpack(ab)
        for suffix, tint in pairs(a.tints) do
            local newname = a.color .. "'s " .. suffix
            for _, obj in ipairs(b.objects[suffix]) do
                obj.setColorTint(tint)
                obj.setName(newname)
            end
        end
        for i = #b.bagContents,1,-1 do  -- Iterate in reverse order.
            a.bag.putObject(b.bagContents[i])
        end
    end
end

colorLock = false
function swapPlayerColors(a, b)
    if a == b then
        return false
    end
    local pa, pb = Player[a], Player[b]

    if not playerBlocks[a] then
        -- This should only trigger if the player clicking is a non-standard color.
        if pb.seated then
            pa.broadcast("Color " .. b .. " is already claimed.  Try another color.", Color.Red)
            return false
        end
    end

    if colorLock then
        pa.broadcast("There's already a color swap in progress, please wait and try again", Color.SoftYellow)
        return
    end
    colorLock = true

    if pa.seated then
        if pb.seated then
            if pa.steam_id == pb.steam_id then  -- Hotseat game
                -- Hotseat games may lose track of the player when their color changes for strange reasons -- mainly because they're prompted to reenter their name again.
                broadcastToAll("Note: Color swapping may be unstable in hotseat games.", Color.SoftYellow)
            end
            -- Need a temporary color to seat the player at to swap colors. Favor those not used by the game first, followed by those used by the game.
            -- Use Black as a last resort since the player accidentally becoming a GM is probably A Bad Thing(tm).
            local tempColor
            for _,tempColor in ipairs({"Brown", "Teal", "Pink", "White", "Orange", "Green", "Blue", "Yellow", "Purple", "Red", "Black"}) do
                if pa.changeColor(tempColor) then
                    Wait.frames(function()
                        pb.changeColor(a)
                        Wait.frames(function()
                            Player[tempColor].changeColor(b)
                            Wait.frames(function()
                                colorLock = false
                            end, 1)
                        end, 1)
                    end, 1)
                    return true
                end
            end
            -- If we reach here, we failed to change colors. Shouldn't happen. Just in case it does.
            pa.broadcast("Unable to swap colors with " .. b .. ". (All player colors are in use?)", Color.Red)
        else
            if pa.changeColor(b) then
                Wait.frames(function()
                    colorLock = false
                end, 1)
                return true
            end
        end
    elseif pb.seated then
        if pb.changeColor(a) then
            Wait.frames(function()
                colorLock = false
            end, 1)
            return true
        end
    end
    colorLock = false
    return false
end

function swapSeatColors(a, b)
    if not swapPlayerColors(a, b) then
        return
    end
    swapPlayerPresenceColors(a, b)
    swapPlayerAreaColors(a, b)
end

-- Trade places with selected seat.
function onClickedSitHere(target_obj, source_color, alt_click)
    local target_color = target_obj.getVar("playerColor")
    if not playerBlocks[source_color] then
        swapPlayerColors(source_color, target_color)
    else
        swapPlayerAreas(source_color, target_color)
    end
end

-- Trade colors with selected seat.
function onClickedChangeColor(target_obj, source_color, alt_click)
    local target_color = target_obj.getVar("playerColor")
    if not playerBlocks[source_color] then
        swapPlayerColors(source_color, target_color)
    else
        swapSeatColors(source_color, target_color)
    end
end

-- Play spirit
function onClickedPlaySpirit(target_obj, source_color, alt_click)
    local target_color = target_obj.getVar("playerColor")
    if swapPlayerColors(source_color, target_color) then
        Wait.frames(function ()
            Player[target_color].lookAt({
                position = playerBlocks[target_color].getPosition() - Vector(0,0,15),
                pitch = 70,
                distance = 30,
            })
        end, 2)
    end
end

-- Given a table of guids, returns a table of objects
function convertGuidsToObjects(table_in)
    local table_out = {}
    for k,guid in pairs(table_in) do
        table_out[k] = getObjectFromGUID(guid)
    end
    return table_out
end
-- Given a table of objects, return a table of guids
function convertObjectsToGuids(table_in)
    local table_out = {}
    for k,obj in pairs(table_in) do
        table_out[k] = obj.guid
    end
    return table_out
end

function onPlayerChangeColor(player_color)
    -- We technically only need to update both the old and the new player areas, however...
    -- TTS does not let us know what the player's previous color was.
    -- So update all player areas.
    for color,_ in pairs(playerBlocks) do
        updatePlaySpiritButton(color)
    end
end
function onPlayerConnect(player)
    updatePlaySpiritButton(player.color)
end
function onPlayerDisconnect(player)
    if #Player.getPlayers() == 0 and #Player.getSpectators() == 0 then
        return
    end
    updatePlaySpiritButton(player.color)
end

function isPowerCard(card)
    if card.type == "Card" and (card.hasTag("Minor") or card.hasTag("Major") or card.hasTag("Unique")) then
        return true
    end
    return false
end
function onObjectSpawn(obj)
    if isPowerCard(obj) then
        applyPowerCardContextMenuItem(obj)
    end
end
function applyPowerCardContextMenuItem(card)
    card.addContextMenuItem(
        "Forget",
        function()
            -- This ugliness is because setPositionSmooth doesn't work from a hand.
            ensureCardInPlay(card)
            discardPowerCardFromPlay(card, 1)
        end,
        false)
end
-- ensureCardInPlay moves the supplied card from a player's hand to a safe
-- location, if it's in a hand.
function ensureCardInPlay(card)
    for color, _ in pairs(PlayerBags) do
        for handIndex=1,numHandsPerPlayer do
            for _, obj in ipairs(Player[color].getHandObjects(handIndex)) do
                if obj.guid == card.guid then
                    local cpos = card.getPosition()
                    card.setPosition(Vector(cpos.x, 0, cpos.z))
                    return
                end
            end
        end
    end
end
