---- Versioning
version = "3.0.0-beta.21"
versionGuid = "57d9fe"
---- Used with Spirit Board Scripts
counterBag = "EnergyCounters"
minorPowerZone = "cb16ab"
majorPowerZone = "089896"
PlayerBags = {
    ["Red"] = "PlayerBagRed",
    ["Purple"] = "PlayerBagPurple",
    ["Yellow"] = "PlayerBagYellow",
    ["Blue"] = "PlayerBagBlue",
    ["Green"] = "PlayerBagGreen",
    ["Orange"] = "PlayerBagOrange",
}
---- Used with Adversary Scripts
eventDeckZone = "a16796"
invaderDeckZone = "dd0921"
stage1DeckZone = "cf2635"
stage2DeckZone = "7f21be"
stage3DeckZone = "2a9f36"
adversaryBag = "AdversaryBag"
scenarioBag = "ScenarioBag"
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
numPlayers = 1
numBoards = 1
boardLayout = "Balanced"
expansions = {}
events = {}
fearPool = 0
generatedFear = 0
gameStarted = false
difficulty = 0
difficultyString = ""
blightedIslandCard = nil
blightedIsland = false
adversaryCard = nil
adversaryLevel = 0
adversaryCard2 = nil
adversaryLevel2 = 0
scenarioCard = nil
secondWave = nil
returnBlightBag = nil
explorerBag = "613ea4"
townBag = "4d3c15"
cityBag = "a245f8"
seaTile = "5f4be2"
selectedColors = {}
selectedBoards = {}
blightCards = {}
fastDiscount = 0
currentPhase = 1
playtestMinorPowers = 0
playtestMajorPowers = 0
playerBlocks = {
    Red = "c68e2c",
    Purple = "661aa3",
    Yellow = "c3c59b",
    Blue = "36bbcc",
    Green = "fac8e4",
    Orange = "6b5b4b",
}
showPlayerButtons = true
onlyCleanupTimePasses = false
objectsToCleanup = {}
extraRandomBoard = nil
------ Unsaved Config Data
gamePaused = false
yHeight = 0
stagesSetup = 0
boardsSetup = 0
adversaryLossCallback = nil
adversaryLossCallback2 = nil
wave = 1
------
minorPowerDiscardZone = "55b275"
majorPowerDiscardZone = "eaf864"
uniquePowerDiscardZone = "uniquePowerDiscard"
playtestMinorPowerZone = "15922f"
playtestMinorPowerDiscardZone = "03b826"
playtestMajorPowerZone = "0a7dcb"
playtestMajorPowerDiscardZone = "bb37a9"
------
aidBoard = "aidBoard"
SetupChecker = "SetupChecker"
fearDeckSetupZone = "fbbf69"
sourceSpirit = "SourceSpirit"
spiritZone = "934ea8"
------
dahanBag = "f4c173"
blightBag = "af50b8"
boxBlightBag = "BoxBlightBag"
beastsBag = "a42427"
diseaseBag = "7019af"
wildsBag = "ca5089"
strifeBag = "af4e63"
badlandsBag = "d3f7f8"
oneEnergyBag = "d336ca"
threeEnergyBag = "a1b7da"
speedBag = "65fc65"
-----
StandardMapBag = "BalancedMapBag"
ExtraMapBag = "1f095d"
ThematicMapBag = "ThematicMapBag"
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
    {"Pi"},
}

---- TTS Events Section
function onObjectEnterZone(zone, enter_object)
    if zone.guid == "2d3124" or zone.guid == "ac8366" then
        local handIndex = 1
        if zone.guid == "ac8366" then
            handIndex = 2
        end
        local handZone = Player["White"].getHandTransform(handIndex)
        handZone.scale.x = handZone.scale.x + 0.75
        handZone.position.x = handZone.position.x - 0.375
        Player["White"].setHandTransform(handZone, handIndex)
    end
end
function onObjectLeaveZone(zone, leave_object)
    if zone.guid == "2d3124" or zone.guid == "ac8366" then
        local handIndex = 1
        if zone.guid == "ac8366" then
            handIndex = 2
        end
        local handZone = Player["White"].getHandTransform(handIndex)
        handZone.scale.x = handZone.scale.x - 0.75
        handZone.position.x = handZone.position.x + 0.375
        Player["White"].setHandTransform(handZone, handIndex)
    end
end
function onScriptingButtonDown(index, playerColor)
    if playerColor == "Grey" then return end
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
            dropped_object.highlightOn(dropColor, 20)
        end
    end
end
function onObjectStateChange(changed_object, old_guid)
    if seaTile.guid == old_guid then
        seaTile = changed_object
        seaTile.interactable = false
        if gameStarted then
            seaTile.registerCollisions(false)
        end
        return
    end
end
function onObjectCollisionEnter(hit_object, collision_info)
    if hit_object == seaTile then
        if collision_info.collision_object.type ~= "Card" then
            if onlyCleanupTimePasses then
                objectsToCleanup[collision_info.collision_object.guid] = true
            else
                cleanupObject({obj = collision_info.collision_object, fear = false})
            end
        end
    end
    -- HACK: Temporary fix until TTS bug resolved https://tabletopsimulator.nolt.io/770
    if scenarioCard ~= nil and scenarioCard.getVar("onObjectCollision") then
        scenarioCard.call("onObjectCollisionEnter", {hit_object=hit_object, collision_info=collision_info})
    end
end
function onObjectCollisionExit(hit_object, collision_info)
    if hit_object == seaTile then
        if collision_info.collision_object.type ~= "Card" then
            if onlyCleanupTimePasses then
                objectsToCleanup[collision_info.collision_object.guid] = nil
            end
        end
    end
    -- HACK: Temporary fix until TTS bug resolved https://tabletopsimulator.nolt.io/770
    if scenarioCard ~= nil and scenarioCard.getVar("onObjectCollision") then
        scenarioCard.call("onObjectCollisionExit", {hit_object=hit_object, collision_info=collision_info})
    end
end
function onObjectEnterContainer(container, object)
    if container.hasTag("Presence") and object.hasTag("Presence") then
        if container.getQuantity() == 2 then
            -- This will trigger twice when a chip container is formed
            -- Not sure of a way around it, but with setDecals it's harmless
            makeSacredSite(container)
        end
        return
    end
end
function makeSacredSite(obj)
    local color = string.sub(obj.getName(),1,-12)
    local url = ""
    if color == "Red" then
        url = "http://cloud-3.steamusercontent.com/ugc/1752434562676874388/C51FB839BC19E2E94CE837708F00B462DAC1C89D/"
    elseif color == "Purple" then
        url = "http://cloud-3.steamusercontent.com/ugc/1752434562676885555/CD5BF2645FDC5B6AEFAA98C7D76BBD7015E18B93/"
    elseif color == "Yellow" then
        url = "http://cloud-3.steamusercontent.com/ugc/1752434562676889038/323BA470D164E4C6D36713E34F20E578C0A3F94A/"
    elseif color == "Blue" then
        url = "http://cloud-3.steamusercontent.com/ugc/1752434562676881841/9B1B1859A3BCE1EE2EC77AE688E13E937CB08F09/"
    elseif color == "Green" then
        url = "http://cloud-3.steamusercontent.com/ugc/1752434562676883074/3419998A3044C614DBAEDC710658F3A4CB7D8CF3/"
    elseif color == "Orange" then
        url = "http://cloud-3.steamusercontent.com/ugc/1752434562676884361/85EE264FD32632A9DD3828EA9538FDBC4F2FBC22/"
    end
    obj.setDecals({
        {
            name     = color.."'s Sacred Site",
            url      = url,
            position = {0, -0.14, 0},
            rotation = {90, 180, 0},
            scale    = {3, 3, 3},
        },
    })
end
function onObjectLeaveContainer(container, object)
    if container.hasTag("Presence") and object.hasTag("Presence") then
        if container.getQuantity() == 1 and container.remainder.getStateId() ~= 2 then
            container.remainder.setDecals({})
        end
        if object.getStateId() ~= 2 then
            object.setDecals({})
        end
        return
    elseif (container == StandardMapBag or container == ExtraMapBag or container == ThematicMapBag) and isIslandBoard({obj=object}) then
        object.setScale(scaleFactors[SetupChecker.getVar("optionalScaleBoard")].size)
        if container == ExtraMapBag then
            local decal = {
                name = "Threshold",
                rotation = {90, 180, 0},
                scale    = {0.24, 0.24, 1},
                url      = "http://cloud-3.steamusercontent.com/ugc/1616219505080617822/E2AA0C5E430D8E48373022F7D00F6307B02E5E7C/"
            }
            if object.getName() == "A" or object.getName() == "C" then
                decal.position = {1.48, 0.2, -0.1}
            elseif object.getName() == "B" or object.getName() == "D" then
                decal.position = {1.48, 0.2, -0.05}
            elseif object.getName() == "E" or object.getName() == "F" then
                decal.position = {1.58, 0.2, 0.05}
            end
            object.setDecals({decal})
        end
        return
    end
end
function onObjectEnterScriptingZone(zone, obj)
    if obj.hasTag("Aspect") then
        if zone.guid == spiritZone then
            for _,object in pairs(upCast(obj, 1, 0, Vector(0, -1, 0))) do
                if object.hasTag("Spirit") then
                    sourceSpirit.call("AddAspectButton", {obj = object})
                    break
                end
            end
        end
        for color,guid in pairs(elementScanZones) do
            if guid == zone.guid then
                if gameStarted and obj.hasTag("Setup") then
                    obj.call("doSetup", {color=color})
                end
                break
            end
        end
    end
end
function onObjectLeaveScriptingZone(zone, obj)
    for _,guid in pairs(elementScanZones) do
        if guid == zone.guid then
            if obj.getTable("thresholds") ~= nil then
                obj.setDecals({})
            end
            break
        end
    end
end
function onSave()
    local data_table = {
        expansions = expansions,
        events = events,
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
        seaTile = seaTile.guid,
        adversaryLevel = adversaryLevel,
        adversaryLevel2 = adversaryLevel2,
        boardLayout = boardLayout,
        selectedBoards = selectedBoards,
        numPlayers = numPlayers,
        numBoards = numBoards,
        blightCards = blightCards,
        fastDiscount = fastDiscount,
        currentPhase = currentPhase,
        playtestMinorPowers = playtestMinorPowers,
        playtestMajorPowers = playtestMajorPowers,
        onlyCleanupTimePasses = onlyCleanupTimePasses,
        objectsToCleanup = objectsToCleanup,
        extraRandomBoard = extraRandomBoard,

        panelInvaderVisibility = UI.getAttribute("panelInvader","visibility"),
        panelAdversaryVisibility = UI.getAttribute("panelAdversary","visibility"),
        panelTurnOrderVisibility = UI.getAttribute("panelTurnOrder","visibility"),
        panelTimePassesVisibility = UI.getAttribute("panelTimePasses","visibility"),
        panelReadyVisibility = UI.getAttribute("panelReady","visibility"),
        panelBlightFearVisibility = UI.getAttribute("panelBlightFear", "visibility"),
        panelScoreVisibility = UI.getAttribute("panelScore", "visibility"),
        panelPowerDrawVisibility = UI.getAttribute("panelPowerDraw", "visibility"),
        showPlayerButtons = showPlayerButtons,
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
    if secondWave ~= nil then
        data_table.secondWave = secondWave.guid
    end
    local selectedTable = {}
    for color,data in pairs(selectedColors) do
        local colorTable = {
            ready = data.ready.guid,
            elements = convertObjectsToGuids(data.elements),
            defend = data.defend.guid,
            isolate = data.isolate.guid,
            paid = data.paid,
            gained = data.gained,
        }
        if data.counter ~= nil then
            colorTable.counter = data.counter.guid
        end
        selectedTable[color] = colorTable
    end
    data_table.selectedColors = selectedTable
    return JSON.encode(data_table)
end
function onLoad(saved_data)
    getObjectFromGUID(versionGuid).setValue("version " .. version)
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    Color.Add("SoftGreen", Color.new(0.75,1,0.67))

    clearHotkeys()
    for _, piece in ipairs(Pieces) do
        addHotkey("Add " .. piece, function (playerColor, hoveredObject, cursorLocation, key_down_up)
            DropPiece(piece, cursorLocation, playerColor)
        end)
    end

    addHotkey("Remove Piece", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        if hoveredObject ~= nil and not hoveredObject.getLock() then
            cleanupObject({obj = hoveredObject, fear = false})
        end
    end)
    addHotkey("Destroy Piece", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        if hoveredObject ~= nil and not hoveredObject.getLock() then
            cleanupObject({obj = hoveredObject, fear = true})
        end
    end)

    addHotkey("Add Fear", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("addFear")
    end)
    addHotkey("Remove Fear", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("removeFear")
    end)
    addHotkey("Flip Explore Card", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("flipExploreCard")
    end)
    addHotkey("Advance Invader Cards", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("advanceInvaderCards")
    end)

    addHotkey("Forget Power", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        for _,obj in pairs(Player[playerColor].getSelectedObjects()) do
            if isPowerCard({card=obj}) then
                -- This ugliness is because setPositionSmooth doesn't work from a hand.
                ensureCardInPlay(obj)
                discardPowerCardFromPlay({card = obj, discardHeight = 1})
            end
        end
        if isPowerCard({card=hoveredObject}) then
            -- This ugliness is because setPositionSmooth doesn't work from a hand.
            ensureCardInPlay(hoveredObject)
            discardPowerCardFromPlay({card = hoveredObject, discardHeight = 1})
        end
    end)
    addHotkey("Discard Power (to 2nd hand)", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        for _,obj in pairs(Player[playerColor].getSelectedObjects()) do
            if isPowerCard({card=obj}) then
                obj.deal(1, playerColor, 2)
            end
        end
        if isPowerCard({card=hoveredObject}) then
            hoveredObject.deal(1, playerColor, 2)
        end
    end)

    addHotkey("Gain Major Power", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        MajorPowerC(nil, playerColor, false)
    end)
    addHotkey("Gain Minor Power", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        MinorPowerC(nil, playerColor, false)
    end)
    addHotkey("Reclaim All", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        local obj = playerBlocks[playerColor]
        if obj ~= nil then
            reclaimAll(obj, playerColor, false)
        end
    end)

    for _,obj in ipairs(getObjectsWithTag("Uninteractable")) do
        obj.setLock(true)
        obj.interactable = false
    end

    ------
    aidBoard = getObjectFromGUID(aidBoard)
    SetupChecker = getObjectFromGUID(SetupChecker)
    adversaryBag = getObjectFromGUID(adversaryBag)
    scenarioBag = getObjectFromGUID(scenarioBag)
    invaderDeckZone = getObjectFromGUID(invaderDeckZone)
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
    speedBag = getObjectFromGUID(speedBag)
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
    ExtraMapBag = getObjectFromGUID(ExtraMapBag)
    ThematicMapBag = getObjectFromGUID(ThematicMapBag)
    seaTile = getObjectFromGUID(seaTile)

    -- Loads the tracking for if the game has started yet
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        gameStarted = loaded_data.gameStarted
        playerBlocks = loaded_data.playerBlocks
        elementScanZones = loaded_data.elementScanZones
        selectedColors = loaded_data.selectedColors
        expansions = loaded_data.expansions
        events = loaded_data.events
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
        seaTile = getObjectFromGUID(loaded_data.seaTile)
        adversaryCard = getObjectFromGUID(loaded_data.adversaryCardGuid)
        adversaryLevel = loaded_data.adversaryLevel
        adversaryCard2 = getObjectFromGUID(loaded_data.adversaryCard2Guid)
        adversaryLevel2 = loaded_data.adversaryLevel2
        scenarioCard = getObjectFromGUID(loaded_data.scenarioCard)
        secondWave = getObjectFromGUID(loaded_data.secondWave)
        boardLayout = loaded_data.boardLayout
        selectedBoards = loaded_data.selectedBoards
        numPlayers = loaded_data.numPlayers
        numBoards = loaded_data.numBoards
        blightCards = loaded_data.blightCards
        showPlayerButtons = loaded_data.showPlayerButtons
        fastDiscount = loaded_data.fastDiscount
        currentPhase = loaded_data.currentPhase
        playtestMinorPowers = loaded_data.playtestMinorPowers
        playtestMajorPowers = loaded_data.playtestMajorPowers
        onlyCleanupTimePasses = loaded_data.onlyCleanupTimePasses
        objectsToCleanup = loaded_data.objectsToCleanup
        extraRandomBoard = loaded_data.extraRandomBoard

        if gameStarted then
            UI.setAttribute("panelInvader","visibility",loaded_data.panelInvaderVisibility)
            UI.setAttribute("panelAdversary","visibility",loaded_data.panelAdversaryVisibility)
            UI.setAttribute("panelTurnOrder","visibility",loaded_data.panelTurnOrderVisibility)
            UI.setAttribute("panelTimePasses","visibility",loaded_data.panelTimePassesVisibility)
            UI.setAttribute("panelReady","visibility",loaded_data.panelReadyVisibility)
            UI.setAttribute("panelBlightFear","visibility",loaded_data.panelBlightFearVisibility)
            UI.setAttribute("panelScore","visibility",loaded_data.panelScoreVisibility)
            UI.setAttribute("panelPowerDraw","visibility",loaded_data.panelPowerDrawVisibility)
            UI.setAttribute("panelUIToggle","active","true")

            updateCurrentPhase(false)
            seaTile.registerCollisions(false)
            SetupPowerDecks()
            addGainPowerCardButtons()
            Wait.condition(function()
                aidBoard.call("setupGame")
                createDifficultyButton()
            end, function() return not aidBoard.spawning end)
            Wait.condition(adversaryUISetup, function() return (adversaryCard == nil or not adversaryCard.spawning) and (adversaryCard2 == nil or not adversaryCard2.spawning) end)
            Wait.time(readyCheck,1,-1)
            if not blightedIsland then
                Wait.condition(addBlightedIslandButton, function() return not aidBoard.spawning end)
            end
            gamePaused = false
            for _,obj in ipairs(getObjects()) do
                if isIslandBoard({obj=obj}) then
                    obj.interactable = false -- sets boards to uninteractable after reload
                elseif isPowerCard({card=obj}) then
                    applyPowerCardContextMenuItems(obj)
                end
            end
        end
    end
    yHeight = seaTile.getPosition().y + 0.1
    playerBlocks = convertGuidsToObjects(playerBlocks)
    playerTables = convertGuidsToObjects(playerTables)
    for color,data in pairs(selectedColors) do
        local colorTable = {
            ready = getObjectFromGUID(data.ready),
            elements = convertGuidsToObjects(data.elements),
            defend = getObjectFromGUID(data.defend),
            isolate = getObjectFromGUID(data.isolate),
            paid = data.paid,
            gained = data.gained,
        }
        if data.counter ~= nil then
            colorTable.counter = getObjectFromGUID(data.counter)
        end
        selectedColors[color] = colorTable
    end

    if Player["White"].seated then Player["White"].changeColor("Red") end
    updateAllPlayerAreas()
    setupSwapButtons()
    updateCurrentPhase(false)
    Wait.time(spiritUpdater, 10, -1)
end
----
function readyCheck()
    local colorCount = 0
    local readyCount = 0
    for _,data in pairs(selectedColors) do
        if data.ready.is_face_down and data.ready.resting then
            readyCount = readyCount + 1
        end
        colorCount = colorCount + 1
    end
    if colorCount == 0 or readyCount < colorCount then
        return
    end

    broadcastToAll("All Players are ready!", Color.SoftGreen)
    for _,data in pairs(selectedColors) do
        data.ready.flip()
    end
    if currentPhase == 1 then
        enterFastPhase(nil)
    elseif currentPhase == 2 then
        enterInvaderPhase(nil)
    end
end
function isThematic()
    return boardLayout == "Thematic"
end
---- Setup Buttons Section
function nullFunc()
end
function CanSetupGame()
    if getMapCount({norm = true, them = false}) > 0 and getMapCount({norm = false, them = true}) > 0 then
        broadcastToAll("You can only have one type of board at once", Color.Red)
        return false
    end
    if adversaryCard == nil and not SetupChecker.getVar("randomAdversary") and adversaryCard2 ~= nil then
        broadcastToAll("A Leading Adversary is Required to use a Supporting Adversary", Color.Red)
        return false
    end
    if adversaryCard ~= nil and adversaryCard == adversaryCard2 then
        broadcastToAll("The Leading and Supporting Adversary cannot be the same", Color.Red)
        return false
    end
    return true
end
function SetupGame()
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
            if numPlayers == 6 and boardLayout == "Thematic" then
                -- Thematic doesn't support extra board
                SetupChecker.setVar("optionalExtraBoard", false)
                SetupChecker.call("updateDifficulty")
                numBoards = numPlayers
            else
                numBoards = numPlayers + 1
            end
        else
            numBoards = numPlayers
        end
    end
    if SetupChecker.getVar("randomBoard") or SetupChecker.getVar("randomScenario") or SetupChecker.getVar("randomAdversary") or SetupChecker.getVar("randomAdversary2") then
        printToAll("Randomiser:", Color.White)
    end
    if SetupChecker.getVar("randomBoard") then
        randomBoard()
    end
    if SetupChecker.getVar("randomScenario") then
        randomScenario()
    end
    if SetupChecker.getVar("randomAdversary") or SetupChecker.getVar("randomAdversary2") then
        randomAdversary(0)
    end

    SetupChecker.call("closeUI")
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
    if SetupChecker.call("difficultyCheck", {thematic = true}) > SetupChecker.getVar("randomMax") then
        -- The difficulty can't be increased anymore so don't use thematic
        SetupChecker.setVar("randomBoardThematic", false)
    elseif numPlayers == 6 and numBoards > 6 then
        -- Thematic at 6 players doesn't current support extra board
        SetupChecker.setVar("randomBoardThematic", false)
    end
    local min = 0
    if SetupChecker.getVar("randomBoardThematic") then
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
    printToAll("Board Layout - "..boardLayout, Color.SoftBlue)
    SetupChecker.call("updateDifficulty")
end
function usingEvents()
    for _,enabled in pairs(events) do
        if enabled then
            return true
        end
    end
    return false
end
function usingSpiritTokens()
    return expansions["Branch & Claw"] or expansions["Jagged Earth"]
end
function randomScenario()
    if difficulty > SetupChecker.getVar("randomMax") then
        return
    end
    local randomMin = SetupChecker.getVar("randomMin")
    local randomMax = SetupChecker.getVar("randomMax")
    local randomAdversary = SetupChecker.getVar("randomAdversary")
    local randomAdversary2 = SetupChecker.getVar("randomAdversary2")
    local attempts = 0
    while scenarioCard == nil do
        if attempts > 1000 then
            -- TODO find a more elegant solution for detecting bad difficulty ranges
            broadcastToAll("Was not able to find random scenario to satisfy min/max difficulty specifications", Color.SoftYellow)
            return
        end
        attempts = attempts + 1
        scenarioCard = SetupChecker.call("RandomScenario")
        local tempDifficulty = SetupChecker.call("difficultyCheck", {scenario = scenarioCard.getVar("difficulty")})
        if tempDifficulty > randomMax or (tempDifficulty < randomMin and not randomAdversary and not randomAdversary2) then
            scenarioCard = nil
        elseif scenarioCard.getVar("requirements") then
            local allowed = scenarioCard.call("Requirements", {
                eventDeck = usingEvents(),
                blightCard = SetupChecker.getVar("optionalBlightCard"),
                expansions = expansions,
                thematic = isThematic(),
                adversary = adversaryCard ~= nil or adversaryCard2 ~= nil or randomAdversary or randomAdversary2,
            })
            if not allowed then
                scenarioCard = nil
            end
        else
            SetupChecker.call("updateDifficulty")
            printToAll("Scenario - "..scenarioCard.getName(), Color.SoftBlue)
            break
        end
    end
end
function randomAdversary(attempts)
    if difficulty >= SetupChecker.getVar("randomMax") then
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
        broadcastToAll("Was not able to find random adversary to satisfy min/max difficulty specifications", Color.SoftYellow)
        return
    end
    if SetupChecker.getVar("randomAdversary") and SetupChecker.getVar("randomAdversary2") then
        local adversary = SetupChecker.call("RandomAdversary")
        if adversary.getVar("requirements") then
            local allowed = adversary.call("Requirements", {eventDeck = usingEvents(), blightCard = SetupChecker.getVar("optionalBlightCard"), expansions = expansions, thematic = isThematic()})
            if not allowed then
                adversary = nil
            end
        end
        local adversary2 = SetupChecker.call("RandomAdversary")
        if adversary2.getVar("requirements") then
            local allowed = adversary2.call("Requirements", {eventDeck = usingEvents(), blightCard = SetupChecker.getVar("optionalBlightCard"), expansions = expansions, thematic = isThematic()})
            if not allowed then
                adversary2 = nil
            end
        end
        if adversary == nil or adversary2 == nil or adversary == adversary2 then
            randomAdversary(attempts + 1)
            return
        end

        local difficulty = adversary.getVar("difficulty")
        local difficulty2 = adversary2.getVar("difficulty")
        local randomMin = SetupChecker.getVar("randomMin")
        local randomMax = SetupChecker.getVar("randomMax")
        local combos = {}
        for i,v in pairs(difficulty) do
            local params = {lead = v}
            for j,w in pairs(difficulty2) do
                params.support = w
                local newDiff = SetupChecker.call("difficultyCheck", params)
                if newDiff >= randomMin and newDiff <= randomMax then
                    table.insert(combos, {i,j})
                elseif newDiff > randomMax then
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
            SetupChecker.call("updateDifficulty")
            printToAll("Adversaries - "..adversaryCard.getName().." "..adversaryLevel.." and "..adversaryCard2.getName().." "..adversaryLevel2, Color.SoftBlue)
        else
            randomAdversary(attempts + 1)
        end
    else
        local selectedAdversary = adversaryCard
        if selectedAdversary == nil then
            selectedAdversary = adversaryCard2
        end
        local adversary = SetupChecker.call("RandomAdversary")
        if adversary.getVar("requirements") then
            local allowed = adversary.call("Requirements", {eventDeck = usingEvents(), blightCard = SetupChecker.getVar("optionalBlightCard"), expansions = expansions, thematic = isThematic()})
            if not allowed then
                adversary = nil
            end
        end
        if adversary == nil or adversary == selectedAdversary then
            randomAdversary(attempts + 1)
            return
        end

        local randomMin = SetupChecker.getVar("randomMin")
        local randomMax = SetupChecker.getVar("randomMax")
        local combos = {}
        for i,v in pairs(adversary.getVar("difficulty")) do
            local params = {}
            if adversaryCard == nil then
                params.lead = v
            else
                params.support = v
            end
            local newDiff = SetupChecker.call("difficultyCheck", params)
            if newDiff >= randomMin and newDiff <= randomMax then
                table.insert(combos, i)
            elseif newDiff > randomMax then
                break
            end
        end
        if #combos ~= 0 then
            local index = math.random(1,#combos)
            if adversaryCard == nil then
                adversaryCard = adversary
                adversaryLevel = combos[index]
                printToAll("Adversary - "..adversary.getName().." "..adversaryLevel, Color.SoftBlue)
            else
                adversaryCard2 = adversary
                adversaryLevel2 = combos[index]
                printToAll("Adversary - "..adversary.getName().." "..adversaryLevel2, Color.SoftBlue)
            end
            SetupChecker.call("updateDifficulty")
        else
            randomAdversary(attempts + 1)
        end
    end
end
function SetupPlaytestDeck(zone, name, option, callback)
    local stagingArea = {
        ["Fear"] = Vector(-50.70, 2, 97.32),
        ["Blight Cards"] = Vector(-46.70, 2, 97.32),
        ["Events"] = Vector(-42.70, 2, 97.32),
    }
    local function PlaytestAll(bag, guid, deck)
        local cards = bag.takeObject({
            guid = guid,
            position = stagingArea[name],
            rotation = {0, 180, 180},
        })
        if deck == nil then
            cards.setPosition(zone.getPosition())
            deck = cards
        else
            deck.putObject(cards)
        end
        if callback ~= nil then
            callback(deck, function() deck.shuffle() end)
        else
            deck.shuffle()
        end
    end
    local function PlaytestHalf(bag, guid, deck)
        local cards = bag.takeObject({
            guid = guid,
            position = stagingArea[name],
            rotation = {0, 180, 180},
        })
        local cardsCount = #cards.getObjects()
        local deckCount = 0
        if deck ~= nil then
            deckCount = #deck.getObjects()
        end
        if deckCount <= cardsCount then
            if deck == nil then
                cards.setPosition(zone.getPosition())
                deck = cards
            else
                deck.putObject(cards)
            end
            if callback ~= nil then
                callback(deck, function() deck.shuffle() end)
            else
                deck.shuffle()
            end
        else
            -- deck is never nil here
            for _ = 1,cardsCount do
                cards.putObject(deck.takeObject({
                    rotation = {0, 180, 180},
                    smooth = false,
                }))
            end
            cards.shuffle()
            if callback ~= nil then
                callback(cards, function()
                    cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                    deck.putObject(cards)
                end)
            else
                cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                deck.putObject(cards)
            end
        end
    end
    local function PlaytestNew(bag, guid, deck)
        local cards = bag.takeObject({
            guid = guid,
            position = stagingArea[name],
            rotation = {0, 180, 180},
        })
        cards.shuffle()
        if callback ~= nil then
            callback(cards, function()
                if deck == nil then
                    cards.setPosition(zone.getPosition())
                else
                    cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                    deck.putObject(cards)
                end
            end)
        else
            if deck == nil then
                cards.setPosition(zone.getPosition())
            else
                cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                deck.putObject(cards)
            end
        end
    end

    local playtestExpansion = SetupChecker.getVar("playtestExpansion")
    if playtestExpansion ~= nil then
        local bagGuid = SetupChecker.getTable("expansions")[playtestExpansion]
        if bagGuid ~= nil then
            local bag = getObjectFromGUID(bagGuid)
            for _,obj in pairs(bag.getObjects()) do
                if obj.name == name then
                    if option == "0" then
                        PlaytestAll(bag, obj.guid, zone.getObjects()[1])
                    elseif option == "1" then
                        PlaytestHalf(bag, obj.guid, zone.getObjects()[1])
                    elseif option == "2" then
                        PlaytestNew(bag, obj.guid, zone.getObjects()[1])
                    end
                    return
                end
            end
        end
    end
end
----- Pre Setup Section
function PreSetup()
    local preSetupSteps = 0
    if adversaryCard ~= nil and adversaryCard.getVar("preSetup") then
        adversaryCard.call("PreSetup",{level = adversaryLevel})
        Wait.condition(function() preSetupSteps = preSetupSteps + 1 end, function() return adversaryCard.getVar("preSetupComplete") end)
    else
        preSetupSteps = preSetupSteps + 1
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("preSetup") then
        -- Wait for first adversary to finish
        Wait.condition(function()
            adversaryCard2.call("PreSetup",{level = adversaryLevel2})
            Wait.condition(function() preSetupSteps = preSetupSteps + 1 end, function() return adversaryCard2.getVar("preSetupComplete") end)
        end, function() return preSetupSteps >= 1 end)
    else
        preSetupSteps = preSetupSteps + 1
    end
    if scenarioCard ~= nil and scenarioCard.getVar("preSetup") then
        scenarioCard.call("PreSetup")
        Wait.condition(function() preSetupSteps = preSetupSteps + 1 end, function() return scenarioCard.getVar("preSetupComplete") end)
    else
        preSetupSteps = preSetupSteps + 1
    end
    if secondWave ~= nil and secondWave.getVar("preSetup") then
        secondWave.call("PreSetup")
        Wait.condition(function() preSetupSteps = preSetupSteps + 1 end, function() return secondWave.getVar("preSetupComplete") end)
    else
        preSetupSteps = preSetupSteps + 1
    end
    Wait.condition(function()
        setupBlightTokens()
        stagesSetup = stagesSetup + 1
    end, function() return preSetupSteps == 4 end)
    return 1
end
function setupBlightTokens()
    blightBag.reset()
    local numBlight = 2 * numBoards
    if not SetupChecker.getVar("optionalBlightCard") then
        numBlight = 5 * numBoards
    end
    if SetupChecker.getVar("optionalBlightSetup") then
        numBlight = numBlight + 1
    end
    local max = math.huge
    if secondWave ~= nil then
        local blightCount = secondWave.getVar("blightCount")
        if blightCount ~= nil then
            numBlight = blightCount[1]
            if #blightCount > 1 and secondWave.getVar("blightedIsland") then
                max = blightCount[#blightCount]
            end
        end
    end
    if scenarioCard ~= nil then
        local blightTokens = scenarioCard.getVar("setupBlightTokens")
        if blightTokens ~= nil then
            numBlight = numBlight + math.min(blightTokens * numBoards, max)
        end
    end
    for _ = 1, numBlight do
        blightBag.putObject(boxBlightBag.takeObject({
            position = blightBag.getPosition() + Vector(0,1,0),
            smooth = false,
        }))
    end
end
----- Fear Section
function SetupFear()
    setupFearTokens()

    local fearCards = {3,3,3}
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
    if not usingEvents() and usingSpiritTokens() then
        fearCards[2] = fearCards[2] + 1
    end

    local handZone = Player["White"].getHandTransform(1)
    local fearDeck = getObjectFromGUID(fearDeckSetupZone).getObjects()[1]
    local count = 0

    fearDeck.shuffle()
    SetupPlaytestDeck(getObjectFromGUID(fearDeckSetupZone), "Fear", SetupChecker.getVar("playtestFear"), nil)
    local maxCards = #fearDeck.getObjects()

    for _ = 1, fearCards[1] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", Color.Red)
            break
        end
        fearDeck.takeObject({
            position = handZone.position - Vector(count/2, 0, 0),
            rotation = Vector(0, 180, 180),
            smooth = false,
        })
        count = count + 1
    end
    for _ = 1, fearCards[2] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", Color.Red)
            break
        end
        fearDeck.takeObject({
            position = handZone.position - Vector(count/2, 0, 0),
            rotation = Vector(0, 180, 180),
            smooth = false,
        })
        count = count + 1
    end
    for _ = 1, fearCards[3] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", Color.Red)
            break
        end
        fearDeck.takeObject({
            position = handZone.position - Vector(count/2, 0, 0),
            rotation = Vector(0, 180, 180),
            smooth = false,
        })
        count = count + 1
    end

    Wait.frames(function()
        fearDeck = Player["White"].getHandObjects(1)

        local divider = getObjectFromGUID("f96a71")
        divider.setPosition(fearDeck[math.max(1,#fearDeck-fearCards[1]-fearCards[2]+1)].getPosition() - Vector(0.2, 0, 0))
        count = count + 1

        divider = getObjectFromGUID("969897")
        divider.setPosition(fearDeck[math.max(1,#fearDeck-fearCards[1]+1)].getPosition() - Vector(0.2, 0, 0))
        count = count + 1

        Wait.condition(function()
            stagesSetup = stagesSetup + 1
        end, function() return #Player["White"].getHandObjects(1) == count end)
    end, 10)

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
function SetupPlaytestPowerDeck(deck, name, option, callback)
    local stagingArea = {
        ["Minor Powers"] = getObjectFromGUID(playtestMinorPowerZone).getPosition(),
        ["Major Powers"] = getObjectFromGUID(playtestMajorPowerZone).getPosition(),
    }
    local function PlaytestFull(bag, guid)
        local cards = bag.takeObject({
            guid = guid,
            position = stagingArea[name],
            rotation = {0, 180, 180},
        })
        deck.putObject(cards)
        if callback ~= nil then
            callback(deck, function() deck.shuffle() end)
        else
            deck.shuffle()
        end
    end
    local function PlaytestMix(bag, guid)
        local cards = bag.takeObject({
            guid = guid,
            position = stagingArea[name],
            rotation = {0, 180, 180},
        })
        if callback ~= nil then
            callback(cards, function() cards.shuffle() end)
        else
            cards.shuffle()
        end
    end

    local playtestExpansion = SetupChecker.getVar("playtestExpansion")
    if playtestExpansion ~= nil then
        local bagGuid = SetupChecker.getTable("expansions")[playtestExpansion]
        if bagGuid ~= nil then
            local bag = getObjectFromGUID(bagGuid)
            for _,obj in pairs(bag.getObjects()) do
                if obj.name == name then
                    if option == "0" then
                        PlaytestFull(bag, obj.guid)
                    elseif option == "1" then
                        if name == "Minor Powers" then
                            playtestMinorPowers = 1
                        elseif name == "Major Powers" then
                            playtestMajorPowers = 1
                        end
                        PlaytestMix(bag, obj.guid)
                    elseif option == "2" then
                        if name == "Minor Powers" then
                            playtestMinorPowers = 2
                        elseif name == "Major Powers" then
                            playtestMajorPowers = 2
                        end
                        PlaytestMix(bag, obj.guid)
                    end
                    return
                end
            end
        end
    end
end
function SetupPowerDecks()
    if not gameStarted then
        local minorPowers = getObjectFromGUID(minorPowerZone).getObjects()[1]
        minorPowers.shuffle()
        SetupPlaytestPowerDeck(minorPowers, "Minor Powers", SetupChecker.getVar("playtestMinorPower"), nil)

        local majorPowers = getObjectFromGUID(majorPowerZone).getObjects()[1]
        majorPowers.shuffle()
        SetupPlaytestPowerDeck(majorPowers, "Major Powers", SetupChecker.getVar("playtestMajorPower"), nil)
    end

    local exploratoryPowersDone = false
    if not gameStarted and SetupChecker.getVar("exploratoryVOTD") then
        local deck = getObjectFromGUID(majorPowerZone).getObjects()[1]
        deck.takeObject({
            guid = "152fe0",
            callback_function = function(obj)
                local temp = obj.setState(2)
                Wait.frames(function()
                    deck.putObject(temp)
                    deck.shuffle()
                    exploratoryPowersDone = true
                end, 1)
            end,
        })
    else
        exploratoryPowersDone = true
    end
    SetupChecker.createButton({
        click_function = "MajorPowerC",
        function_owner = Global,
        label          = "Gain a\nMajor",
        position       = Vector(31.75, -0.1, -29.5),
        rotation       = Vector(0, 180, 0),
        width          = 800,
        height         = 750,
        font_size      = 250,
        tooltip        = "Click to learn a Major Power",
    })
    SetupChecker.createButton({
        click_function = "MinorPowerC",
        function_owner = Global,
        label          = "Gain a\nMinor",
        position       = Vector(29.75, -0.1, -29.5),
        rotation       = Vector(0, 180, 0),
        width          = 800,
        height         = 750,
        font_size      = 250,
        tooltip        = "Click to learn a Minor Power",
    })
    SetupChecker.createButton({
        click_function = "MajorPowerC",
        function_owner = Global,
        label          = "Gain a\nMajor",
        position       = Vector(-31.75, -0.1, -29.5),
        rotation       = Vector(0, 180, 0),
        width          = 800,
        height         = 750,
        font_size      = 250,
        tooltip        = "Click to learn a Major Power",
    })
    SetupChecker.createButton({
        click_function = "MinorPowerC",
        function_owner = Global,
        label          = "Gain a\nMinor",
        position       = Vector(-29.75, -0.1, -29.5),
        rotation       = Vector(0, 180, 0),
        width          = 800,
        height         = 750,
        font_size      = 250,
        tooltip        = "Click to learn a Minor Power",
    })
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return exploratoryPowersDone end)
    return 1
end
handOffset = Vector(0,0,36)
scriptWorkingCardC = false
function MajorPowerC(obj, player_color, alt_click)
    local cards = 4
    if alt_click then
        cards = 2
    end
    startDealPowerCards(false, Player[player_color], cards)
end
function MajorPowerUI(player, button)
    if player.color == "Grey" then return end
    local cards = 4
    -- button is "-1"/"1" for left click/single touch
    if math.abs(button) > 1 then
        cards = 2
    end
    startDealPowerCards(false, player, cards)
end
function MinorPowerC(obj, player_color, alt_click)
    local cards = 4
    if alt_click then
        cards = 6
    end
    startDealPowerCards(true, Player[player_color], cards)
end
function MinorPowerUI(player, button)
    if player.color == "Grey" then return end
    local cards = 4
    -- button is "-1"/"1" for left click/single touch
    if math.abs(button) > 1 then
        cards = 6
    end
    startDealPowerCards(true, player, cards)
end
function startDealPowerCards(minor, player, cardCount)
    -- protection from double clicking
    if scriptWorkingCardC then return end
    scriptWorkingCardC = true

    if minor then
        _G["startDealPowerCardsCo"] = function()
            DealPowerCards(
                player,
                cardCount,
                getObjectFromGUID(minorPowerZone),
                getObjectFromGUID(minorPowerDiscardZone),
                getObjectFromGUID(playtestMinorPowerZone),
                getObjectFromGUID(playtestMinorPowerDiscardZone),
                playtestMinorPowers
            )
            return 1
        end
    else
        _G["startDealPowerCardsCo"] = function()
            DealPowerCards(
                player,
                cardCount,
                getObjectFromGUID(majorPowerZone),
                getObjectFromGUID(majorPowerDiscardZone),
                getObjectFromGUID(playtestMajorPowerZone),
                getObjectFromGUID(playtestMajorPowerDiscardZone),
                playtestMajorPowers
            )
            return 1
        end
    end

    startLuaCoroutine(Global, "startDealPowerCardsCo")
end
function DealPowerCards(player, cardCount, deckZone, discardZone, playtestDeckZone, playtestDiscardZone, playtestPowers)
    -- clear the zone!
    local hand = player.getHandTransform()
    if hand == nil then
        scriptWorkingCardC = false
        return
    end
    local handPos = hand.position
    local discardTable = DiscardPowerCards(handPos)
    if #discardTable > 0 then
        wt(0.1)
    end

    local xPadding = 4.4
    if cardCount > 4 then
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

    local function dealPowerCards(powersZone, powersDiscardZone, count, offset, isPlaytest)
        local deck = powersZone.getObjects()[1]
        if deck == nil then
        elseif deck.type == "Card" then
            if cardsAdded < count then
                deck.setLock(true)
                deck.setPositionSmooth(powerDealCentre + cardPlaceOffset[offset + 1])
                deck.setRotationSmooth(Vector(0, 180, 0))
                if isPlaytest then
                    deck.addTag("Playtest")
                end
                CreatePickPowerButton(deck)
                cardsAdded = cardsAdded + 1
                Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not deck.isSmoothMoving() end)
            end
        elseif deck.type == "Deck" then
            for i=1, math.min(deck.getQuantity(), count) do
                local tempCard = deck.takeObject({
                    position = powerDealCentre + cardPlaceOffset[offset + i],
                    flip = true,
                })
                tempCard.setLock(true)
                if isPlaytest then
                    tempCard.addTag("Playtest")
                end
                CreatePickPowerButton(tempCard)
                cardsAdded = cardsAdded + 1
                Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not tempCard.isSmoothMoving() end)
            end
        end
        if cardsAdded < count then
            deck = powersDiscardZone.getObjects()[1]
            deck.setPositionSmooth(powersZone.getPosition(), false, true)
            deck.setRotationSmooth(Vector(0, 180, 180), false, true)
            deck.shuffle()
            wt(0.5)

            for i=cardsAdded+1, math.min(deck.getQuantity(), count) do
                local tempCard = deck.takeObject({
                    position = powerDealCentre + cardPlaceOffset[offset + i],
                    flip = true,
                })
                tempCard.setLock(true)
                if isPlaytest then
                    tempCard.addTag("Playtest")
                end
                CreatePickPowerButton(tempCard)
                cardsAdded = cardsAdded + 1
                Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not tempCard.isSmoothMoving() end)
            end
        end
    end
    local playtestCount = playtestPowers
    if cardCount == 2 then
        if playtestPowers > 0 then
            playtestCount = 1
        end
    elseif cardCount == 6 then
        if playtestPowers == 1 then
            playtestCount = 2
        elseif playtestPowers == 2 then
            playtestCount = 3
        end
    end
    dealPowerCards(deckZone, discardZone, cardCount - playtestCount, 0, false)
    dealPowerCards(playtestDeckZone, playtestDiscardZone, playtestCount, cardCount - playtestCount, true)

    Wait.condition(function() scriptWorkingCardC = false end, function() return cardsResting == cardsAdded end)
end
function CreatePickPowerButton(card)
    local scale = flipVector(Vector(card.getScale()))
    card.createButton({
        click_function = "PickPower",
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
function PickPower(cardo,playero,alt_click)
    if cardo.hasTag("Major") then
        Player[playero].broadcast("Don't forget to Forget a Power Card!", Color.SoftYellow)
    end
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
        discardPowerCardFromPlay({card = obj, discardHeight = i})
        obj.clearButtons()
        Wait.condition(function() obj.setLock(false) end, function() return not obj.isSmoothMoving() end)
        discardTable[i] = obj
    end
    return discardTable
end
function discardPowerCardFromPlay(params)
    local discardZone
    if params.card.hasTag("Major") and not params.card.hasTag("Playtest") then
        discardZone = getObjectFromGUID(majorPowerDiscardZone)
    elseif params.card.hasTag("Major") and params.card.hasTag("Playtest") then
        discardZone = getObjectFromGUID(playtestMajorPowerDiscardZone)
    elseif params.card.hasTag("Minor") and not params.card.hasTag("Playtest") then
        discardZone = getObjectFromGUID(minorPowerDiscardZone)
    elseif params.card.hasTag("Minor") and params.card.hasTag("Playtest") then
        discardZone = getObjectFromGUID(playtestMinorPowerDiscardZone)
    elseif params.card.hasTag("Unique") then
        discardZone = getObjectFromGUID(uniquePowerDiscardZone)
    else
        -- Discard unknown cards to the unique power discard
        discardZone = getObjectFromGUID(uniquePowerDiscardZone)
    end
    params.card.setPositionSmooth(discardZone.getPosition() + Vector(0,params.discardHeight,0), false, true)
    params.card.setRotation(Vector(0, 180, 0))
end

function getPowerZoneObjects(handP)
    local hits = upCastPosSizRot(
        handOffset + Vector(handP.x,yHeight,handP.z), -- pos
        Vector(15,0.1,4),  -- size
        Vector(0,0,0),  --  rotation
        0,  -- distance
        {"Card","Deck"})
    return hits
end
function addGainPowerCardButtons()
    for color, _ in pairs(selectedColors) do
        local cardZoneObjects = getPowerZoneObjects(Player[color].getHandTransform().position)
        for _, obj in ipairs(cardZoneObjects) do
            if obj.type == "Card" then
                CreatePickPowerButton(obj, "PickPower")
            end
        end
    end
end
----- Blight Section
function SetupBlightCard()
    local cardsSetup = 0
    local function bncBlightCardOptions(deck, callback)
        if SetupChecker.getVar("exploratoryAid") and expansions["Branch & Claw"] then
            deck.takeObject({
                guid = "bf66eb",
                callback_function = function(obj)
                    local temp = obj.setState(2)
                    Wait.frames(function()
                        deck.putObject(temp)
                        deck.shuffle()
                        cardsSetup = cardsSetup + 1
                    end, 1)
                end,
            })
        else
            cardsSetup = cardsSetup + 1
        end
        if callback ~= nil then
            Wait.condition(function() callback() end, function() return cardsSetup == 1 end)
        end
    end
    if SetupChecker.getVar("optionalBlightCard") then
        local grabbedDeck = false
        local blightDeck = getObjectFromGUID("b38ea8").getObjects()[1]
        blightDeck.shuffle()
        if SetupChecker.getVar("playtestExpansion") == "Branch & Claw" then
            grabbedDeck = true
            SetupPlaytestDeck(getObjectFromGUID("b38ea8"), "Blight Cards", SetupChecker.getVar("playtestBlight"), bncBlightCardOptions)
        else
            bncBlightCardOptions(blightDeck)
        end
        if not grabbedDeck then
            SetupPlaytestDeck(getObjectFromGUID("b38ea8"), "Blight Cards", SetupChecker.getVar("playtestBlight"), nil)
        end

        Wait.condition(function()
            grabBlightCard(true)
        end, function() return cardsSetup == 1 and #getObjectFromGUID("b38ea8").getObjects() == 1 end)
    else
        blightedIsland = true
    end
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return blightedIsland or (blightedIslandCard ~= nil and not blightedIslandCard.isSmoothMoving()) end)
    return 1
end
function grabBlightCard(start)
    local blightDeck = getObjectFromGUID("b38ea8").getObjects()[1]
    local blightDiscard = getObjectFromGUID("b18505").getPosition()

    if findNextBlightCard(start, blightDeck) then
        return
    elseif blightDeck.type == "Deck" then
        blightDeck.takeObject({
            position = blightDiscard,
            callback_function = function(obj)
                if not usingEvents() and (not obj.getVar("healthy") and (obj.getVar("immediate") or obj.getVar("blight") == 2)) then
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
            for _, data in pairs(blightDeck.getObjects()) do
                if data.name == blightCards[i] then
                    blightDeck.takeObject({
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
function BlightIslandButtonUI(player)
    BlightIslandButton(nil, player.color)
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
    if secondWave ~= nil then
        local blightCount = secondWave.getVar("blightCount")
        if blightCount ~= nil and blightCount[index+1] ~= nil then
            numBlight = blightCount[index+1]
        end
    end
    if not blightedIslandCard.getVar("healthy") and scenarioCard ~= nil then
        local blightTokens = scenarioCard.getVar("blightTokens")
        if blightTokens ~= nil then
            numBlight = numBlight + (blightTokens * numBoards)
        end
    end
    numBlight = math.max(numBlight, 0)
    for _ = 1, numBlight do
        blightBag.putObject(boxBlightBag.takeObject({position = blightBag.getPosition() + Vector(0,1,0)}))
    end
    wt(1)
    gamePaused = false -- to re-enable scripting buttons and object cleanup
    broadcastToAll(blightedIslandCard.getName()..":", Color.White)
    printToAll(numBlight.." Blight Tokens Added", Color.SoftBlue)
    wt(1)
    if numBlight == 0 and blightedIsland then
        broadcastToAll("Invaders win via the Blight Loss Condition!", Color.SoftYellow)
    else
        broadcastToAll("Remember to check the Blight Card's effect!", Color.SoftYellow)
    end
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
----- Scenario section
function SetupScenario()
    for _,guid in pairs(SetupChecker.getVar("scenarios")) do
        if guid == "" then
        elseif scenarioCard == nil or scenarioCard.guid ~= guid then
            getObjectFromGUID(guid).destruct()
        end
    end

    local pos = Vector(0.75, 0.11, -1.81)
    if scenarioCard ~= nil then
        local targetScale = 1.71
        local currentScale = scenarioCard.getScale()[1]
        local scaleMult = (currentScale - targetScale)/10
        for i = 1, 10 do
            wt(0.02)
            scenarioCard.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
        end

        scenarioCard.setLock(true)
        scenarioCard.setRotationSmooth(Vector(0,180,0), false, true)
        scenarioCard.setPositionSmooth(aidBoard.positionToWorld(pos), false, true)
        pos = pos + Vector(0, 0, -1.03)
    end
    if secondWave ~= nil then
        local targetScale = 1.71
        local currentScale = secondWave.getScale()[1]
        local scaleMult = (currentScale - targetScale)/10
        for i = 1, 10 do
            wt(0.02)
            secondWave.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
        end

        secondWave.setLock(true)
        secondWave.setRotationSmooth(Vector(0,180,0), false, true)
        secondWave.setPositionSmooth(aidBoard.positionToWorld(pos), false, true)
    end

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return (scenarioCard == nil or not scenarioCard.isSmoothMoving()) and (secondWave == nil or not secondWave.isSmoothMoving()) end)
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
        })
        secondAdversaryBoard.setLock(true)
        secondAdversaryBoard.interactable = false
        Wait.condition(function() boardSetup = true end, function() return not secondAdversaryBoard.isSmoothMoving() end)
    else
        boardSetup = true
    end

    if adversaryCard ~= nil then
        local targetScale = 1.71
        local currentScale = adversaryCard.getScale()[1]
        local scaleMult = (currentScale - targetScale)/10
        for i = 1, 10 do
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
            adversaryCard.setPositionSmooth(secondAdversaryBoard.positionToWorld(Vector(0,0.21,0)), false, true)
            adversaryCard2.setLock(true)
            adversaryCard2.setPositionSmooth(aidBoard.positionToWorld(Vector(-0.75,0.11,-1.81)), false, true)
        elseif adversaryCard ~= nil then
            adversaryCard.setLock(true)
            adversaryCard.setPositionSmooth(aidBoard.positionToWorld(Vector(-0.75,0.11,-1.81)), false, true)
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
        if reminder.ravage == "Generic" then
            reminder.ravage = adversaryBag.takeObject({guid="135124"})
        end
        reminder.ravage.setPosition(aidBoard.positionToWorld(ravagePos))
        reminder.ravage.setRotation(Vector(0, 180, 0))
        reminder.ravage.setLock(true)
        reminder.ravage.interactable = false
        ravagePos.z = ravagePos.z + 0.07
    end
    if reminder2.ravage and reminder2.ravage ~= reminder.ravage then
        if reminder2.ravage == "Generic" then
            local obj = getObjectFromGUID("135124")
            if obj then
                reminder2.ravage = obj.clone()
            else
                reminder2.ravage = adversaryBag.takeObject({guid="135124"})
            end
        end
        reminder2.ravage.setPosition(aidBoard.positionToWorld(ravagePos))
        reminder2.ravage.setRotation(Vector(0, 180, 0))
        reminder2.ravage.setLock(true)
        reminder2.ravage.interactable = false
    end

    local afterRavagePos = Vector(-0.47,-0.09,1.9)
    if reminder.afterRavage then
        if reminder.afterRavage == "Generic" then
            reminder.afterRavage = adversaryBag.takeObject({guid="027ef0"})
        end
        reminder.afterRavage.setPosition(aidBoard.positionToWorld(afterRavagePos))
        reminder.afterRavage.setRotation(Vector(0, 90, 0))
        reminder.afterRavage.setLock(true)
        reminder.afterRavage.interactable = false
        afterRavagePos.y = afterRavagePos.y - 0.01
        afterRavagePos.z = afterRavagePos.z + 0.11
    end
    if reminder2.afterRavage then
        if reminder2.afterRavage == "Generic" then
            local obj = getObjectFromGUID("027ef0")
            if obj then
                reminder2.afterRavage = obj.clone()
            else
                reminder2.afterRavage = adversaryBag.takeObject({guid="027ef0"})
            end
        end
        reminder2.afterRavage.setPosition(aidBoard.positionToWorld(afterRavagePos))
        reminder2.afterRavage.setRotation(Vector(0, 90, 0))
        reminder2.afterRavage.setLock(true)
        reminder2.afterRavage.interactable = false
    end

    local buildPos = Vector(-0.72,-0.09,2.24)
    if reminder.build then
        if reminder.build == "Generic" then
            reminder.build = adversaryBag.takeObject({guid="a178fa"})
        end
        reminder.build.setPosition(aidBoard.positionToWorld(buildPos))
        reminder.build.setRotation(Vector(0, 180, 0))
        reminder.build.setLock(true)
        reminder.build.interactable = false
        buildPos.z = buildPos.z + 0.07
    end
    if reminder2.build and reminder2.build ~= reminder.build then
        if reminder2.build == "Generic" then
            local obj = getObjectFromGUID("a178fa")
            if obj then
                reminder2.build = obj.clone()
            else
                reminder2.build = adversaryBag.takeObject({guid="a178fa"})
            end
        end
        reminder2.build.setPosition(aidBoard.positionToWorld(buildPos))
        reminder2.build.setRotation(Vector(0, 180, 0))
        reminder2.build.setLock(true)
        reminder2.build.interactable = false
    end

    local afterBuildPos = Vector(-0.98,-0.09,1.9)
    if reminder.afterBuild then
        if reminder.afterBuild == "Generic" then
            reminder.afterBuild = adversaryBag.takeObject({guid="2ab0ad"})
        end
        reminder.afterBuild.setPosition(aidBoard.positionToWorld(afterBuildPos))
        reminder.afterBuild.setRotation(Vector(0, 90, 0))
        reminder.afterBuild.setLock(true)
        reminder.afterBuild.interactable = false
        afterBuildPos.y = afterBuildPos.y - 0.01
        afterBuildPos.z = afterBuildPos.z + 0.11
    end
    if reminder2.afterBuild then
        if reminder2.afterBuild == "Generic" then
            local obj = getObjectFromGUID("2ab0ad")
            if obj then
                reminder2.afterBuild = obj.clone()
            else
                reminder2.afterBuild = adversaryBag.takeObject({guid="2ab0ad"})
            end
        end
        reminder2.afterBuild.setPosition(aidBoard.positionToWorld(afterBuildPos))
        reminder2.afterBuild.setRotation(Vector(0, 90, 0))
        reminder2.afterBuild.setLock(true)
        reminder2.afterBuild.interactable = false
    end

    local explorePos = Vector(-1.24,-0.09,2.24)
    if reminder.explore then
        if reminder.explore == "Generic" then
            reminder.explore = adversaryBag.takeObject({guid="a5b6b3"})
        end
        reminder.explore.setPosition(aidBoard.positionToWorld(explorePos))
        reminder.explore.setRotation(Vector(0, 180, 0))
        reminder.explore.setLock(true)
        reminder.explore.interactable = false
        explorePos.z = explorePos.z + 0.07
    end
    if reminder2.explore and reminder2.explore ~= reminder.explore then
        if reminder2.explore == "Generic" then
            local obj = getObjectFromGUID("a5b6b3")
            if obj then
                reminder2.explore = obj.clone()
            else
                reminder2.explore = adversaryBag.takeObject({guid="a5b6b3"})
            end
        end
        reminder2.explore.setPosition(aidBoard.positionToWorld(explorePos))
        reminder2.explore.setRotation(Vector(0, 180, 0))
        reminder2.explore.setLock(true)
        reminder2.explore.interactable = false
    end

    local afterExplorePos = Vector(-1.49,-0.09,1.9)
    if reminder.afterExplore then
        if reminder.afterExplore == "Generic" then
            reminder.afterExplore = adversaryBag.takeObject({guid="47288b"})
        end
        reminder.afterExplore.setPosition(aidBoard.positionToWorld(afterExplorePos))
        reminder.afterExplore.setRotation(Vector(0, 90, 0))
        reminder.afterExplore.setLock(true)
        reminder.afterExplore.interactable = false
        afterExplorePos.y = afterExplorePos.y - 0.01
        afterExplorePos.z = afterExplorePos.z + 0.11
    end
    if reminder2.afterExplore then
        if reminder2.afterExplore == "Generic" then
            local obj = getObjectFromGUID("47288b")
            if obj then
                reminder2.afterExplore = obj.clone()
            else
                reminder2.afterExplore = adversaryBag.takeObject({guid="47288b"})
            end
        end
        reminder2.afterExplore.setPosition(aidBoard.positionToWorld(afterExplorePos))
        reminder2.afterExplore.setRotation(Vector(0, 90, 0))
        reminder2.afterExplore.setLock(true)
        reminder2.afterExplore.interactable = false
    end
end
function adversaryUISetup()
    local lineCount = 0
    if adversaryCard and adversaryCard.getVar("hasUI") then
        local ui = adversaryCard.call("AdversaryUI", {level = adversaryLevel, supporting = false})
        UI.setAttribute("panelAdversaryName","text",adversaryCard.getName().." Level "..adversaryLevel)
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
                    if ui.loss.counter.callback then
                        adversaryLossCallback = ui.loss.counter.callback
                    end
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
        UI.setAttribute("panelAdversary2Name","text",adversaryCard2.getName().." Level "..adversaryLevel2)
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
                    if ui.loss.counter.callback then
                        adversaryLossCallback2 = ui.loss.counter.callback
                    end
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
    local height = lineCount*18
    UI.setAttribute("panelAdversary","height",height)
    UI.setAttribute("panelInvader","offsetXY","0 "..305+5+height)
    UI.setAttribute("panelBlightFear","offsetXY","0 "..305+5+104+height)
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
        if adversaryLossCallback2 ~= nil then
            adversaryCard2.call(adversaryLossCallback2, {count=params.count})
        end
    else
        if adversaryLossCallback ~= nil then
            adversaryCard.call(adversaryLossCallback, {count=params.count})
        end
    end
    UI.setAttribute(id,"text",params.count)
end
function randomTerrain(player)
    if player.color == "Grey" then return end
    local random = math.random(1,2)
    if random == 1 then
        broadcastToAll("Your random Stage III Escalation is \"top terrain\" for the current Adversary Action", Color.SoftYellow)
    else
        broadcastToAll("Your random Stage III Escalation is \"bottom terrain\" for the current Adversary Action", Color.SoftYellow)
    end
end
----- Invader Deck Section
invaderCards = {
    ["W"] = {["guid"] = "8cf7b8", ["stage"] = 1},
    ["M"] = {["guid"] = "8346dd", ["stage"] = 1},
    ["J"] = {["guid"] = "cf9353", ["stage"] = 1},
    ["S"] = {["guid"] = "e07847", ["stage"] = 1},
    ["We"] = {["guid"] = "3b538b", ["stage"] = 2},
    ["Me"] = {["guid"] = "ec8fb2", ["stage"] = 2},
    ["Je"] = {["guid"] = "c304c1", ["stage"] = 2},
    ["Se"] = {["guid"] = "b88f34", ["stage"] = 2},
    ["C"] = {["guid"] = "a5afb0", ["stage"] = 2},
    ["MW"] = {["guid"] = "6c6131", ["stage"] = 3},
    ["JW"] = {["guid"] = "3e6af4", ["stage"] = 3},
    ["SW"] = {["guid"] = "0f66d9", ["stage"] = 3},
    ["MJ"] = {["guid"] = "0f16b8", ["stage"] = 3},
    ["SM"] = {["guid"] = "72c176", ["stage"] = 3},
    ["JS"] = {["guid"] = "89d57f", ["stage"] = 3},
}
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

    local cardsToSetup = 0
    local cardsSetup = 0
    for i=1, #deckTable do
        local cardData = invaderCards[deckTable[i]]
        if cardData then
            cardsToSetup = cardsToSetup + 1
            local deck
            if cardData.stage == 1 then
                deck = getObjectFromGUID(stage1DeckZone).getObjects()[1]
            elseif cardData.stage == 2 then
                deck = getObjectFromGUID(stage2DeckZone).getObjects()[1]
            else
                -- assumed stage 3
                deck = getObjectFromGUID(stage3DeckZone).getObjects()[1]
            end
            deck.takeObject({
                guid = cardData.guid,
                position = deck.getPosition() + Vector(-6,1,14 + i),
                rotation = Vector(0,180,0),
                callback_function = function(obj) cardsSetup = cardsSetup + 1 end,
            })
        end
    end

    Wait.condition(function() grabInvaderCards(deckTable) end, function() return cardsToSetup == cardsSetup end)
    return 1
end
function grabInvaderCards(deckTable)
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
                position = invaderDeckZone.getPosition() + Vector(-#deckTable+i,0,0),
                smooth = false,
                callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
            })
            table.insert(cardTable, card)
        elseif char == 2 then
            local card = stage2Deck.takeObject({
                position = invaderDeckZone.getPosition() + Vector(-#deckTable+i,0,0),
                smooth = false,
                callback_function = function(obj) cardsLoaded = cardsLoaded + 1 end,
            })
            table.insert(cardTable, card)
        elseif char == 3 or char == "3*" then
            local card = stage3Deck.takeObject({
                position = invaderDeckZone.getPosition() + Vector(-#deckTable+i,0,0),
                smooth = false,
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
        elseif invaderCards[deckTable[i]] then
            local card = getObjectFromGUID(invaderCards[deckTable[i]].guid)
            card.setPosition(invaderDeckZone.getPosition() + Vector(-#deckTable+i,0,0))
            card.setRotationSmooth(Vector(0,180,180))
            cardsLoaded = cardsLoaded + 1
            table.insert(cardTable, card)
        end
    end
    Wait.condition(function() group(cardTable) end, function() return cardsLoaded == #deckTable end)
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() local objs = invaderDeckZone.getObjects() return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == #deckTable end)
end
----- Event Deck Section
function SetupEventDeck()
    local cardsSetup = 0
    local deck = getObjectFromGUID(eventDeckZone).getObjects()[1]
    if deck ~= nil then
        deck.shuffle()
    end

    local function bncEventOptions(bncDeck, callback)
        Wait.condition(function()
            local bncEventSetup = 0
            if SetupChecker.getVar("exploratoryWar") then
                bncDeck.takeObject({
                    guid = "cfd4d1",
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        Wait.frames(function()
                            bncDeck.putObject(temp)
                            bncDeck.shuffle()
                            cardsSetup = cardsSetup + 1
                            bncEventSetup = bncEventSetup + 1
                        end, 1)
                    end,
                })
            else
                cardsSetup = cardsSetup + 1
                bncEventSetup = bncEventSetup + 1
            end
            if SetupChecker.getVar("optionalDigitalEvents") then
                if not SetupChecker.getVar("exploratoryWar") then
                    bncDeck.takeObject({guid = "cfd4d1"}).destruct()
                end
                bncDeck.takeObject({guid = "6692e8"}).destruct()
            end
            if SetupChecker.getVar("optionalStrangeMadness") and not SetupChecker.getVar("optionalDigitalEvents") then
                local strangeMadness = getObjectFromGUID("BnCBag").takeObject({
                    guid = "0edac2",
                    position = getObjectFromGUID(eventDeckZone).getPosition(),
                    rotation = {0,180,180},
                    smooth = false,
                })
                bncDeck.putObject(strangeMadness)
                bncDeck.shuffle()
            end
            if callback ~= nil then
                Wait.condition(function() callback() end, function() return bncEventSetup == 1 end)
            end
        end, function() return not bncDeck.loading_custom end)
    end

    local grabbedDeck = false
    if events["Branch & Claw"] then
        if SetupChecker.getVar("playtestExpansion") == "Branch & Claw" then
            grabbedDeck = true
            SetupPlaytestDeck(getObjectFromGUID(eventDeckZone), "Events", SetupChecker.getVar("playtestEvent"), bncEventOptions)
        else
            bncEventOptions(deck)
        end
    else
        if SetupChecker.getVar("playtestExpansion") == "Branch & Claw" then
            grabbedDeck = true
        end
        cardsSetup = cardsSetup + 1
    end
    if not grabbedDeck then
        SetupPlaytestDeck(getObjectFromGUID(eventDeckZone), "Events", SetupChecker.getVar("playtestEvent"), nil)
    end
    if usingEvents() then
        Wait.condition(function()
            stagesSetup = stagesSetup + 1
        end, function() return cardsSetup == 1 and #getObjectFromGUID(eventDeckZone).getObjects() == 1 and not getObjectFromGUID(eventDeckZone).getObjects()[1].isSmoothMoving() end)
    else
        stagesSetup = stagesSetup + 1
    end
    return 1
end
----- Map Section
function SetupMap()
    local adversariesSetup = 0
    if adversaryCard ~= nil and adversaryCard.getVar("limitSetup") then
        adversaryCard.call("LimitSetup",{level = adversaryLevel, other = {exist = adversaryCard2 ~= nil, level = adversaryLevel2}})
        Wait.condition(function() adversariesSetup = adversariesSetup + 1 end, function() return adversaryCard.getVar("limitSetupComplete") end)
    else
        adversariesSetup = adversariesSetup + 1
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("limitSetup") then
        adversaryCard2.call("LimitSetup",{level = adversaryLevel2, other = {exist = adversaryCard ~= nil, level = adversaryLevel}})
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
            ExtraMapBag.shuffle()
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
    aidBoard.call("setupGame")

    local postSetupSteps = 0
    local firstAdversarySetup = false

    if secondWave ~= nil then
        difficultyString = difficultyString.."Wave "..wave.."\n"
    end
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

    if SetupChecker.getVar("exploratoryBODAN") then
        local spirit = getObjectFromGUID("606f23")
        if spirit ~= nil then
            spirit = spirit.setState(2)
            if not SetupChecker.call("isSpiritPickable", {guid = "606f23"}) then
                Wait.condition(function() spirit.clearButtons() postSetupSteps = postSetupSteps + 1 end, function() return not spirit.loading_custom end)
            else
                postSetupSteps = postSetupSteps + 1
            end
        else
            postSetupSteps = postSetupSteps + 1
        end
    else
        postSetupSteps = postSetupSteps + 1
    end

    if adversaryCard ~= nil and adversaryCard.getVar("postSetup") then
        adversaryCard.call("PostSetup",{level = adversaryLevel, other = {exist = adversaryCard2 ~= nil, level = adversaryLevel2}})
        Wait.condition(function() postSetupSteps = postSetupSteps + 1 firstAdversarySetup = true end, function() return adversaryCard.getVar("postSetupComplete") end)
    else
        postSetupSteps = postSetupSteps + 1
        firstAdversarySetup = true
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("postSetup") then
        -- Wait for first adversary to finish
        Wait.condition(function()
            adversaryCard2.call("PostSetup",{level = adversaryLevel2, other = {exist = adversaryCard ~= nil, level = adversaryLevel}})
            Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return adversaryCard2.getVar("postSetupComplete") end)
        end, function() return firstAdversarySetup end)
    else
        postSetupSteps = postSetupSteps + 1
    end
    if scenarioCard ~= nil and scenarioCard.getVar("postSetup") then
        scenarioCard.call("PostSetup")
        Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return scenarioCard.getVar("postSetupComplete") end)
    else
        postSetupSteps = postSetupSteps + 1
    end
    if secondWave ~= nil and secondWave.getVar("mapSetup") then
        secondWave.call("PostSetup")
        Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return secondWave.getVar("postSetupComplete") end)
    else
        postSetupSteps = postSetupSteps + 1
    end

    if not usingEvents() and usingSpiritTokens() then
        -- Setup up command cards last
        Wait.condition(function()
            local invaderDeck = invaderDeckZone.getObjects()[1]
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
                    local objs = invaderDeckZone.getObjects()
                    return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == #cards + 2
                end)
            end, function()
                local objs = invaderDeckZone.getObjects()
                return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == #cards + 1
            end)
        end, function() return postSetupSteps == 5 end)
    else
        postSetupSteps = postSetupSteps + 1
    end

    -- HACK: trying to fix client desync issue
    for _,obj in ipairs(getObjects()) do
        if isIslandBoard({obj=obj}) then
            obj.setPosition(obj.getPosition()-Vector(0,0.01,0))
        end
    end

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return postSetupSteps == 6 end)
    return 1
end
function createDifficultyButton()
    local buttonPos = Vector(0.75,0,-3.8)
    if adversaryCard2 == nil then
        -- not double adversaries
        buttonPos = Vector(0.75,0,-2.8)
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
    local JEBag = getObjectFromGUID("JEBag")
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
    runSpiritSetup()
    enableUI()
    seaTile.registerCollisions(false)
    Wait.time(readyCheck,1,-1)
    setLookingForPlayers(false)
    if adversaryCard ~= nil and adversaryCard.getVar("hasBroadcast") then
        local broadcast = adversaryCard.call("Broadcast", {level = adversaryLevel, other = {exist = adversaryCard2 ~= nil, level = adversaryLevel2}})
        if broadcast ~= nil then
            printToAll("Adversary:", Color.White)
            printToAll(broadcast, Color.SoftBlue)
            wt(2)
        end
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("hasBroadcast") then
        local broadcast = adversaryCard2.call("Broadcast", {level = adversaryLevel2, other = {exist = adversaryCard ~= nil, level = adversaryLevel}})
        if broadcast ~= nil then
            printToAll("Adversary:", Color.White)
            printToAll(broadcast, Color.SoftBlue)
            wt(2)
        end
    end
    if scenarioCard ~= nil and scenarioCard.getVar("hasBroadcast") then
        local broadcast = scenarioCard.call("Broadcast")
        if broadcast ~= nil then
            printToAll("Scenario:", Color.White)
            printToAll(broadcast, Color.SoftBlue)
            wt(2)
        end
    end
    if secondWave ~= nil and secondWave.getVar("hasBroadcast") then
        local broadcast = secondWave.call("Broadcast")
        if broadcast ~= nil then
            printToAll("Scenario:", Color.White)
            printToAll(broadcast, Color.SoftBlue)
            wt(2)
        end
    end
    if adversaryCard2 ~= nil then
        printToAll("Escalation:", Color.White)
        printToAll("The stage II escalation is "..adversaryCard.getName().."\nThe stage III escalation is "..adversaryCard2.getName(), Color.SoftBlue)
        wt(2)
    elseif adversaryCard ~= nil then
        printToAll("Escalation:", Color.White)
        printToAll("Your Stage II escalation is "..adversaryCard.getName(), Color.SoftBlue)
        wt(2)
    end
    printToAll("Game Started!", Color.White)
    printToAll("Don't forget to perform the initial Explore Step!", Color.SoftYellow)
    if SetupChecker.getVar("optionalExtraBoard") and numPlayers == 1 then
        printToAll("But not on the extra board!", Color.SoftYellow)
    end
    return 1
end
function enableUI()
    Wait.frames(function()
        -- HACK: Temporary hack to try to fix visibility TTS bug https://tabletopsimulator.nolt.io/583
        UI.setXmlTable(UI.getXmlTable(), {})

        -- Need to wait for xml table to get updated
        Wait.frames(function()
            local colors = {}
            for color,_ in pairs(PlayerBags) do
                table.insert(colors, color)
            end
            UI.setAttribute("panelUIToggle","active","true")
            setVisiTable("panelTimePasses", colors)
            setVisiTable("panelReady", colors)
            setVisiTable("panelPowerDraw", colors)
            setVisiTable("panelUI", colors)
            setVisiTable("panelUIToggleHide", colors)
        end, 2)
    end, 3)
end
function runSpiritSetup()
    for color, _ in pairs(selectedColors) do
        local zone = getObjectFromGUID(elementScanZones[color])
        for _, obj in ipairs(zone.getObjects()) do
            if obj.hasTag("Setup") then
                obj.call("doSetup", {color=color})
            end
        end
    end
end
------
function addSpirit(params)
    SetupChecker.call("addSpirit", params)
end
function removeSpirit(params)
    SetupChecker.call("removeSpirit", params)
    getObjectFromGUID(elementScanZones[params.color]).clearButtons()
    selectedColors[params.color] = {
        ready = params.ready,
        counter = params.counter,
        elements = params.elements,
        defend = params.defend,
        isolate = params.isolate,
        paid = false,
        gained = false,
    }
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
    for guid,_ in pairs(objectsToCleanup) do
        local obj = getObjectFromGUID(guid)
        if obj ~= nil then
            cleanupObject({obj = obj, fear = false})
        end
        objectsToCleanup[guid] = nil
    end
    for _,object in pairs(upCast(seaTile, 0.5)) do
        handlePiece(object, 0)
    end
    for color,data in pairs(selectedColors) do
        handlePlayer(color, data)
    end

    broadcastToAll("Time Passes...", Color.White)
    local quote = quotes[math.random(#quotes)]
    wt(2)
    printToAll("\"" .. quote[1] .. "\"", Color.SoftBlue)
    wt(2)
    printToAll("- " .. quote[2], Color.SoftBlue)
    wt(2)
    enterSpiritPhase(nil)
    timePassing = false
    return 1
end
function handlePiece(object, offset)
    local name = object.getName()
    if string.sub(name, 1, 4) == "City" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset)
        end
    elseif string.sub(name, 1, 4) == "Town" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset)
        end
    elseif string.sub(name, 1, 8) == "Explorer" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset)
        end
    elseif string.sub(name, 1, 5) == "Dahan" then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,0,0), offset)
        end
    elseif name == "Blight" then
        object = resetPiece(object, Vector(0,180,0), offset)
    elseif object.hasTag("Reminder Token") then
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
        if obj.hasTag("Any") then
            if obj.getStateId() ~= 9 then obj = obj.setState(9) end
            if obj.getLock() == false then obj.destruct() end
        elseif obj.type == "Generic" and obj.getVar("elements") ~= nil then
            if obj.getLock() == false then obj.destruct() end
        elseif obj.hasTag("Reminder Token") then
            if obj.getLock() == false then obj.destruct() end
        elseif obj.getName() == "Speed Token" then
            -- Move speed token up a bit to trigger collision exit callback
            obj.setPosition(obj.getPosition() + Vector(0,1,0))
            Wait.frames(function() obj.destruct() end , 1)
        elseif obj.type == "Card" and not obj.getLock() then
            obj.deal(1, color, 2)
        end
    end

    if data.paid then
        playerBlocks[color].editButton({index=1, label="Pay", click_function="payEnergy", color="Red", tooltip="Left click to pay energy for your cards"})
        data.paid = false
    end
    if data.gained then
        playerBlocks[color].editButton({index=2, label="Gain", click_function="gainEnergy", color="Red", tooltip="Left click to gain energy from presence track"})
        data.gained = false
    end
    if data.ready.is_face_down then
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
        ["Thematic"] = {
            { pos = Vector(-1.93, 1.08, 20.44), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
        },
        ["Balanced"] = {
            { pos = Vector(5.96, 1.08, 16.59), rot = Vector(0.00, 180.00, 0.00) },
        },
    },
    { -- 2 Board
        ["Thematic"] = {
            { pos = Vector(9.54, 1.08, 18.07), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(-10.34, 1.08, 18.04), rot = Vector(0.00, 180.00, 0.00), board = "W" },
        },
        ["Balanced"] = {
            { pos = Vector(9.13, 1.08, 25.29), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(0.29, 1.08, 10.21), rot = Vector(0.00, 0.00, 0.00) },
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
        ["Thematic"] = {
            { pos = Vector(24.91, 1.08, 10.20), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(5.03, 1.08, 10.17), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(15.03, 1.08, 27.16), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
        },
        ["Balanced"] = {
            { pos = Vector(2.33, 1.08, 26.80), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(2.46, 1.08, 11.54), rot = Vector(0.00, 60.00, 0.00) },
            { pos = Vector(15.70, 1.08, 19.37), rot = Vector(0.00, 300.00, 0.00) },
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
        ["Thematic"] = {
            { pos = Vector(29.29, 1.08, 10.20), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(9.41, 1.08, 10.17), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(19.41, 1.08, 27.16), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
            { pos = Vector(-0.62, 1.08, 27.04), rot = Vector(0.00, 180.00, 0.00), board = "NW" },
        },
        ["Balanced"] = {
            { pos = Vector(2.36, 1.08, 26.47), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(20.40, 1.08, 26.64), rot = Vector(0.00, 0.00, 0.00) },
            { pos = Vector(-6.65, 1.08, 11.13), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(11.27, 1.08, 11.33), rot = Vector(0.00, 0.00, 0.00) },
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
        ["Thematic"] = {
            { pos = Vector(33.53, 1.08, 24.51), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(13.65, 1.08, 24.48), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(23.65, 1.08, 41.47), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
            { pos = Vector(3.62, 1.08, 41.35), rot = Vector(0.00, 180.00, 0.00), board = "NW" },
            { pos = Vector(43.40, 1.08, 7.63), rot = Vector(0.00, 180.00, 0.00), board = "SE" },
        },
        ["Balanced"] = {
            { pos = Vector(3.32, 1.08, 32.42), rot = Vector(0.00, 120.00, 0.00) },
            { pos = Vector(25.46, 1.08, 24.68), rot = Vector(0.00, 240.00, 0.00) },
            { pos = Vector(38.99, 1.08, 32.44), rot = Vector(0.00, 300.00, 0.00) },
            { pos = Vector(12.18, 1.08, 16.81), rot = Vector(0.00, 120.02, 0.00) },
            { pos = Vector(25.62, 1.08, 9.32), rot = Vector(0.00, 359.99, 0.00) },
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
        ["Thematic"] = {
            { pos = Vector(33.53, 1.08, 24.51), rot = Vector(0.00, 180.00, 0.00), board = "E" },
            { pos = Vector(13.65, 1.08, 24.48), rot = Vector(0.00, 180.00, 0.00), board = "W" },
            { pos = Vector(23.65, 1.08, 41.47), rot = Vector(0.00, 180.00, 0.00), board = "NE" },
            { pos = Vector(3.62, 1.08, 41.35), rot = Vector(0.00, 180.00, 0.00), board = "NW" },
            { pos = Vector(43.40, 1.08, 7.63), rot = Vector(0.00, 180.00, 0.00), board = "SE" },
            { pos = Vector(23.59, 1.08, 7.55), rot = Vector(0.00, 180.00, 0.00), board = "SW" },
        },
        ["Balanced"] = {
            { pos = Vector(4.31, 1.08, 29.13), rot = Vector(0.00, 150.01, 0.00) },
            { pos = Vector(19.72, 1.08, 29.32), rot = Vector(0.00, 270.00, 0.00) },
            { pos = Vector(43.04, 1.08, 33.51), rot = Vector(0.00, 210.00, 0.00) },
            { pos = Vector(12.25, 1.08, 15.90), rot = Vector(0.00, 30.01, 0.00) },
            { pos = Vector(35.44, 1.08, 20.02), rot = Vector(0.00, 90.00, 0.00) },
            { pos = Vector(50.90, 1.08, 20.26), rot = Vector(0.00, 330.00, 0.00) },
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
            { pos = Vector(22.76, 1.08, 45.03), rot = Vector(0.00, 162.62, 0.00) },
            { pos = Vector(33.80, 1.08, 24.36), rot = Vector(0.00, 282.64, 0.00) },
            { pos = Vector(46.88, 1.08, 12.07), rot = Vector(0.00, 282.62, 0.00) },
            { pos = Vector(18.70, 1.08, 27.55), rot = Vector(0.00, 162.65, 0.00) },
            { pos = Vector(23.48, 1.08, 12.88), rot = Vector(0.00, 42.62, 0.00) },
            { pos = Vector(6.30, 1.08, 7.69), rot = Vector(0.00, 42.61, 0.00) },
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
    { -- 7 Board
        ["Thematic"] = {},
        ["Balanced"] = {
            { pos = Vector(-2.92, 1.08, 26.63), rot = Vector(0.00, 140.00, 0.00) },
            { pos = Vector(12.33, 1.08, 29.40), rot = Vector(0.00, 260.00, 0.00) },
            { pos = Vector(7.18, 1.08, 14.98), rot = Vector(0.00, 20.00, 0.00) },
            { pos = Vector(29.16, 1.08, 23.23), rot = Vector(0.00, 260.00, 0.00) },
            { pos = Vector(46.29, 1.08, 16.93), rot = Vector(0.00, 80.00, 0.00) },
            { pos = Vector(51.43, 1.08, 31.42), rot = Vector(0.00, 200.00, 0.00) },
            { pos = Vector(61.44, 1.08, 19.74), rot = Vector(0.00, 320.00, 0.00) },
        },
        ["Pi"] = {
            { pos = Vector(5.50, 1.06, 8.62), rot = Vector(0.00, 0.00, 0.00) },
            { pos = Vector(14.48, 1.07, 24.01), rot = Vector(0.00, 0.00, 0.00) },
            { pos = Vector(14.36, 1.09, 39.34), rot = Vector(0.00, 240.00, 0.00) },
            { pos = Vector(32.18, 1.05, 39.30), rot = Vector(0.00, 240.00, 0.00) },
            { pos = Vector(50.00, 1.05, 39.22), rot = Vector(0.00, 240.00, 0.00) },
            { pos = Vector(50.02, 1.05, 23.67), rot = Vector(0.00, 180.00, 0.00) },
            { pos = Vector(41.01, 1.05, 8.27), rot = Vector(0.00, 180.00, 0.00) },
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
----
function GenerateMapData()
    local boards = getMapTiles()
    while true do
        local moving = false
        for _, obj in pairs(boards) do
            if obj.isSmoothMoving() then
                moving = true
                break
            end
        end
        if not moving then break end
        coroutine.yield()
    end
    local noteLines = {}
    table.insert(noteLines, "boardLayout = {")
    table.insert(noteLines, "    -- ...")
    table.insert(noteLines, "    { -- <num> Boards")
    table.insert(noteLines, "        -- ...")
    table.insert(noteLines, "        [\"<map name>\"] = {")
    for _, board in pairs(boards) do
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
    for _,obj in pairs(upCast(seaTile)) do
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
    for _,obj in pairs(upCast(seaTile)) do
        if isIslandBoard({obj=obj}) then
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
    SetupChecker.call("updateDifficulty")

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
        if extraRandomBoard == nil then
            extraRandomBoard = math.random(1,#boards)
        end
        rand = extraRandomBoard
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
        if isThematic() then
            ThematicMapBag.takeObject({
                position = ThematicMapBag.getPosition() + Vector(0,-5,0),
                guid = themGuids[board.board],
                smooth = false,
                callback_function = function(obj)
                    if SetupChecker.getVar("optionalThematicRedo") then
                        obj = obj.setState(2)
                    end
                    BoardCallback(obj, board.pos, board.rot, i==rand, scaleOrigin)
                end,
            })
        else
            local bag = StandardMapBag
            if #bag.getObjects() == 0 then
                -- This should only be true with 6 player extra board
                bag = ExtraMapBag
            end
            local selectedBoardName = nil
            if selectedBoards[count] ~= nil then
                if selectedBoards[count]:sub(-1) == "2" then
                    selectedBoardName = selectedBoards[count]:sub(1, -2)
                    bag = ExtraMapBag
                else
                    selectedBoardName = selectedBoards[count]
                end
            end
            local list = bag.getObjects()
            local index = 1
            for _,value in pairs(list) do
                if selectedBoardName ~= nil then
                    if value.name == selectedBoardName then
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

            local boardObject= bag.takeObject({
                index = index,
                position = bag.getPosition() + Vector(0,-5,0),
                smooth = false,
                callback_function = function(obj) BoardCallback(obj, board.pos, board.rot, i==rand, scaleOrigin) end,
            })
            if selectedBoardName == nil then
                if bag == ExtraMapBag then
                    table.insert(selectedBoards, boardObject.getName().."2")
                else
                    table.insert(selectedBoards, boardObject.getName())
                end
            end
            count = count + 1
        end
    end
end
function BoardCallback(obj, pos, rot, extra, scaleOrigin)
    obj.interactable = false
    obj.setLock(true)
    obj.setRotationSmooth(rot, false, true)
    local scaleFactor = scaleFactors[SetupChecker.getVar("optionalScaleBoard")]
    obj.setPositionSmooth(scaleFactor.position*pos + (1-scaleFactor.position)*scaleOrigin, false, true)
    Wait.condition(function() setupMap(obj,extra) end, function() return obj.resting and not obj.loading_custom end)
end
function setupMap(map, extra)
    _G["setupMapCo"] = function()
        local piecesToPlace = map.getTable("pieceMap")
        local posToPlace = map.getTable("posMap")
        local originalPieces = map.getTable("pieceMap")

        if not map.hasTag("Thematic") then -- if not a thematic board
            if usingSpiritTokens() then -- during Setup put 1 Beast and 1 Disease on each island board
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

        if secondWave ~= nil and secondWave.getVar("mapSetup") then
            piecesToPlace = secondWave.call("MapSetup", {name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra})
        end
        if scenarioCard ~= nil and scenarioCard.getVar("mapSetup") then
            piecesToPlace = scenarioCard.call("MapSetup", {name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra})
        end
        -- supporting adversary setup should happen before primary
        if adversaryCard2 ~= nil and adversaryCard2.getVar("mapSetup") then
            piecesToPlace = adversaryCard2.call("MapSetup", {level = adversaryLevel2, name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra})
        end
        if adversaryCard ~= nil and adversaryCard.getVar("mapSetup") then
            piecesToPlace = adversaryCard.call("MapSetup", {level = adversaryLevel, name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra})
        end

        for l,landTable in ipairs(piecesToPlace) do
            for i,pieceName in ipairs(landTable) do
                if secondWave and pieceName == "Box Blight" then
                    pieceName = "Blight"
                end
                place(pieceName,map.positionToWorld(posToPlace[l][i]))
                coroutine.yield(0)
            end
        end
        boardsSetup = boardsSetup + 1
        return 1
    end
    startLuaCoroutine(Global, "setupMapCo")
end

function place(objName, placePos, droppingPlayerColor)
    if objName == "CityS" then
        place("City",placePos,droppingPlayerColor)
        if usingSpiritTokens() then
            Wait.time(function() place("Strife",placePos + Vector(0,1,0),droppingPlayerColor) end, 0.5)
        end
    elseif objName == "TownS" then
        place("Town",placePos,droppingPlayerColor)
        if usingSpiritTokens() then
            Wait.time(function() place("Strife",placePos + Vector(0,1,0),droppingPlayerColor) end, 0.5)
        end
    elseif objName == "ExplorerS" then
        place("Explorer",placePos,droppingPlayerColor)
        if usingSpiritTokens() then
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
                    broadcastToAll("France wins via their Additional Loss Condition!", Color.SoftYellow)
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
        if usingSpiritTokens() then
            temp = strifeBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Beasts" then
        if usingSpiritTokens() then
            temp = beastsBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Wilds" then
        if usingSpiritTokens() then
            temp = wildsBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Disease" then
        if usingSpiritTokens() then
            temp = diseaseBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Badlands" then
        if expansions["Jagged Earth"] then
            temp = badlandsBag.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Defend Token" then
        if droppingPlayerColor and selectedColors[droppingPlayerColor] and selectedColors[droppingPlayerColor].defend ~= nil then
            temp = selectedColors[droppingPlayerColor].defend.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "Isolate Token" then
        if droppingPlayerColor and selectedColors[droppingPlayerColor] and selectedColors[droppingPlayerColor].isolate ~= nil then
            temp = selectedColors[droppingPlayerColor].isolate.takeObject({position = placePos,rotation = Vector(0,180,0)})
        else
            return
        end
    elseif objName == "1 Energy" then
        temp = oneEnergyBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "3 Energy" then
        temp = threeEnergyBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "Speed Token" then
        temp = speedBag.takeObject({position=placePos,rotation=Vector(0,180,0)})
    elseif objName == "Scenario Token" then
        local bag = getObjectFromGUID("8d6e46")
        if bag ~= nil then
            temp = bag.takeObject({position=placePos,rotation=Vector(0,180,0)})
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

-- one-indexed table
Pieces = {
    "Explorer",
    "Town",
    "City",
    "Blight",
    "Badlands",
    "Beasts",
    "Wilds",
    "Disease",
    "Strife",
    "Dahan",
    "Defend Token",
    "Isolate Token",
    "1 Energy",
    "3 Energy",
    "Box Blight",
    "Speed Token",
}

function DropPiece(piece, cursorLocation, droppingPlayerColor)
    if not gameStarted or gamePaused then
        return
    end
    place(piece, cursorLocation + Vector(0,2,0), droppingPlayerColor)
end

function cleanupObject(params)
    local bag = nil
    local removeObject = true
    if string.sub(params.obj.getName(),1,5) == "Dahan" then
        params.obj.setRotation(Vector(0,0,0))
        bag = dahanBag
    elseif string.sub(params.obj.getName(),1,8) == "Explorer" then
        params.obj.setRotation(Vector(0,180,0))
        bag = explorerBag
    elseif string.sub(params.obj.getName(),1,4) == "Town" then
        params.obj.setRotation(Vector(0,180,0))
        bag = townBag
        if params.fear then
            aidBoard.call("addFear")
        end
    elseif string.sub(params.obj.getName(),1,4) == "City" then
        params.obj.setRotation(Vector(0,180,0))
        bag = cityBag
        if params.fear then
            aidBoard.call("addFear")
            aidBoard.call("addFear")
        end
    elseif params.obj.getName() == "Blight" then
        params.obj.setRotation(Vector(0,180,0))
        bag = returnBlightBag
    elseif params.obj.getName() == "Strife" then
        params.obj.setRotation(Vector(0,180,0))
        bag = strifeBag
    elseif params.obj.getName() == "Beasts" then
        params.obj.setRotation(Vector(0,180,0))
        bag = beastsBag
    elseif params.obj.getName() == "Wilds" then
        params.obj.setRotation(Vector(0,180,0))
        bag = wildsBag
    elseif params.obj.getName() == "Disease" then
        params.obj.setRotation(Vector(0,180,0))
        bag = diseaseBag
    elseif params.obj.getName() == "Badlands" then
        params.obj.setRotation(Vector(0,180,0))
        bag = badlandsBag
    else
        if not params.obj.hasTag("Destroy") then
            removeObject = false
        end
    end

    if removeObject and (bag == nil or bag.type == "Infinite") then
        params.obj.destruct()
    elseif removeObject then
        params.obj.highlightOff()
        if params.obj.getStateId() ~= -1 and params.obj.getStateId() ~= 1 then
            params.obj = params.obj.setState(1)
        end
        bag.putObject(params.obj)
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

    local invaderDeck = invaderDeckZone.getObjects()[1]
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
    local lose = 2 * difficulty + aidBoard.getVar("numCards") + aidBoard.call("countDiscard") + dahan - blight

    UI.setAttribute("scoreWin", "text", win)
    UI.setAttribute("scoreLose", "text", lose)
end
function flipReady(player)
    if player.color == "Grey" then return end
    if selectedColors[player.color] then
        selectedColors[player.color].ready.flip()
    end
end
-----
spiritsScanned = {}
function spiritUpdater()
    local sScript = sourceSpirit.getLuaScript()
    local start, _ = string.find(sScript, "-- Source Spirit start")
    if start ~= nil then
        sScript = string.sub(sScript, 1, start - 2)
    end
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
function upCast(obj,dist,offset,dir)
    dist = dist or 1
    offset = offset or 0
    dir = dir or Vector(0,1,0)
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,offset,0),
        direction    = dir,
        type         = 3,
        size         = obj.getBoundsNormalized().size,
        orientation  = obj.getRotation(),
        max_distance = dist,
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
        if v.hit_object ~= obj and not isIslandBoard({obj=v.hit_object}) then
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end
function upCastPosSizRot(pos,size,rot,dist,types)
    rot = rot or Vector(0,0,0)
    dist = dist or 1
    local hits = Physics.cast({
        origin       = pos,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = size,
        orientation  = rot,
        max_distance = dist,
        --debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if types ~= nil then
            local matchesType = false
            for _,t in pairs(types) do
                if v.hit_object.type == t then matchesType = true end
            end
            if matchesType then
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

function detectPresence(spirit, position)
    local hits = Physics.cast{
        origin = spirit.positionToWorld(position), -- pos
        direction = Vector(0, 1, 0),
        max_distance = 1,
        type = 1, --ray
    }
    local hasPresence = false
    for _, hit in pairs(hits) do
        if hit.hit_object.hasTag("Presence") then
            hasPresence = true
            break
        end
    end
    return hasPresence
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
            position={1.1,3.2,-11.2}, rotation={0,180,0}, height=0, width=0,
            font_color={1,1,1}, font_size=500
        })
        -- Pay Energy (button index 1)
        obj.createButton({
            label="", click_function="nullFunc",
            position={-4.2,3.2,-11.2}, rotation={0,180,0}, height=0, width=0,
            font_color="White", font_size=500,
        })
        -- Gain Energy (button index 2)
        obj.createButton({
            label="", click_function="nullFunc",
            position={-4.2,3.2,-12.6}, rotation={0,180,0}, height=0, width=0,
            font_color="White", font_size=500,
        })
        obj.createButton({
            label="Reclaim All", click_function="reclaimAll",
            position={1.1,3.2,-12.6}, rotation={0,180,0}, height=600, width=2600,
            font_size=500,
        })
        for i,bag in pairs(selected.elements) do
            if i == 9 then break end
            bag.createButton({
                label="?", click_function="nullFunc",
                position={0,0.1,1.9}, rotation={0,0,0}, height=0, width=0,
                font_color={1,1,1}, font_size=800
            })
        end
        -- Other buttons to follow/be fixed later.
    elseif initialized and not selected then
        obj.setVar("initialized", false)
        obj.clearButtons()
    end

    if not selected then
        if timer then  -- No spirit, but a running timer.
            Wait.stop(timer)
            timer = nil
            obj.setVar("timer", timer)
        end
        return
    end

    if selected.paid then
        obj.editButton({index=1, label="Paid", click_function="refundEnergy", color="Green", height=600, width=1550, tooltip="Right click to refund energy for your cards"})
    else
        obj.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", height=600, width=1550, tooltip="Left click to pay energy for your cards"})
    end
    if selected.gained then
        obj.editButton({index=2, label="Gained", click_function="returnEnergy", color="Green", height=600, width=1550, tooltip="Right click to return energy from presence track"})
    else
        obj.editButton({index=2, label="Gain", click_function="gainEnergy", color="Red", height=600, width=1550, tooltip="Left click to gain energy from presence track"})
    end

    local energy = 0

    local Elements = {}
    Elements.__index = Elements
    function Elements:new(init)
        local outTable = {0,0,0,0,0,0,0,0}
        setmetatable(outTable, self)
        outTable:add(init)
        return outTable
    end
    function Elements:add(other)
        if other == nil then
            return
        elseif type(other) == "table" then
            for i = 1, 8 do
                self[i] = self[i] + other[i]
            end
        elseif type(other) == "string" then
            for i = 1, string.len(other) do
                self[i] = self[i] + math.floor(string.sub(other, i, i))
            end
        end
    end
    function Elements:threshold(threshold)
        for i = 1, 8 do
            if threshold[i] > self[i] then
                return false
            end
        end
        return true
    end
    function Elements:__tostring()
        return table.concat(self, "")
    end

    local function powerCost(card)
        local cost = card.getVar("energy")
        -- Skip counting locked card's energy (Aid from Lesser Spirits)
        if card.getLock() or cost == nil then
            return 0
        elseif (card.hasTag("Fast") and not card.hasTag("Temporary Slow")) or card.hasTag("Temporary Fast") then
            cost = cost - fastDiscount
        end
        return cost
    end

    local function calculateTrackElements(spiritBoard)
        local elements = Elements:new()
        if spiritBoard.script_state ~= "" then
            local trackElements = spiritBoard.getTable("trackElements")
            if trackElements ~= nil then
                for _, trackElem in pairs(trackElements) do
                    if not detectPresence(spiritBoard, trackElem.position) then
                        elements:add(trackElem.elements)
                    end
                end
            end
        end
        return elements
    end

    local function addThresholdDecals(object, elements, thresholds, scale)
        local decals = {}
        local positions = {}
        for _, threshold in pairs(thresholds) do
            local decal
            local vec = Vector(threshold.position)
            local vecString = vec:string()
            if positions[vecString] then
                decal = positions[vecString]
            else
                decal = {
                    name = "Threshold",
                    position = vec + Vector(0, 0.21, 0),
                    rotation = {90, 180, 0},
                    scale    = scale,
                }
            end
            if elements:threshold(Elements:new(threshold.elements)) then
                decal.url = "http://cloud-3.steamusercontent.com/ugc/1752434998238112918/1438FD310432FAA24898C44212AB081770C923B9/"
            elseif not positions[vecString] then
                decal.url = "http://cloud-3.steamusercontent.com/ugc/1752434998238120811/7B41881EE983802C10E4ECEF57123443AE9F11BA/"
            end
            positions[vecString] = decal
            table.insert(decals, decal)
        end
        object.setDecals(decals)
    end
    local function checkThresholds(spiritBoard, aspects, thresholdCards, elements)
        if spiritBoard.script_state ~= "" then
            local thresholds = spiritBoard.getTable("thresholds")
            if thresholds ~= nil then
                addThresholdDecals(spiritBoard, elements, thresholds, {0.08, 0.08, 1})
            end
        end
        for _, aspect in pairs(aspects) do
            if aspect.script_state ~= "" then
                local thresholds = aspect.getTable("thresholds")
                if thresholds ~= nil then
                    addThresholdDecals(aspect, elements, thresholds, {0.12, 0.24, 1})
                end
            end
        end
        for _, card in pairs(thresholdCards) do
            if card.script_state ~= "" then
                local thresholds = card.getTable("thresholds")
                if thresholds ~= nil then
                    addThresholdDecals(card, elements, thresholds, {0.16, 0.16, 1})
                end
            end
        end
    end

    local function countItems()
        local zone = params.zone
        local elements = Elements:new()
        -- We track the elements separately, since we count tokens *everywhere*
        -- for the choice event element helper, and don't want to double count
        -- the tokens in the scan zones.
        local nonTokenElements = Elements:new()

        local spirit = nil
        local aspects = {}
        local thresholdCards = {}
        energy = 0
        --Go through all items found in the zone
        for _, entry in ipairs(zone.getObjects()) do
            if entry.hasTag("spirit") then
                local trackElements = calculateTrackElements(entry)
                elements:add(trackElements)
                nonTokenElements:add(trackElements)
                spirit = entry
            elseif entry.type == "Card" then
                if entry.hasTag("Aspect") and not entry.is_face_down then
                    table.insert(aspects, entry)
                end
                --Ignore if no elements entry
                if entry.getVar("elements") ~= nil then
                    if not entry.is_face_down and entry.getPosition().z > zone.getPosition().z then
                        -- Skip counting locked card's elements (exploratory Aid from Lesser Spirits)
                        if not entry.getLock() or not (blightedIsland and blightedIslandCard ~= nil and blightedIslandCard.guid == "ad5b9a") then
                            local cardElements = entry.getVar("elements")
                            elements:add(cardElements)
                            nonTokenElements:add(cardElements)
                        end
                        energy = energy + powerCost(entry)
                    end
                    if entry.getTable("thresholds") ~= nil then
                        table.insert(thresholdCards, entry)
                    end
                end
            elseif entry.type == "Generic" then
                local tokenCounts = entry.getVar("elements")
                if tokenCounts ~= nil then
                    elements:add(tokenCounts)
                end
            end
        end
        if spirit ~= nil then
            checkThresholds(spirit, aspects, thresholdCards, elements)
        end
        --Updates the number display
        params.obj.editButton({index=0, label="Energy Cost: "..energy})
        for i, v in ipairs(elements) do
            selected.elements[i].editButton({index=0, label=v})
        end
        selected.nonTokenElements = nonTokenElements
    end
    countItems()    -- Update counts immediately.
    if timer then
        Wait.stop(timer)
    end
    timer = Wait.time(countItems, 1, -1)
    obj.setVar("timer", timer)
end
function reclaimAll(target_obj, source_color)
    if not gameStarted then
        return
    end
    local color = target_obj.getVar("playerColor")
    if color ~= source_color and Player[color].seated then
        return
    end

    for _,obj in pairs(Player[color].getHandObjects(2)) do
        if isPowerCard({card=obj}) then
            obj.deal(1, color, 1)
        end
    end
end
function giveEnergy(params)
    local success = updateEnergyCounter(params.color, true, params.energy)
    if not success then
        success = refundEnergyTokens(params.color, params.energy)
    end
    return success
end
function gainEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif alt_click then
        return
    end
    local color = target_obj.getVar("playerColor")
    if color ~= source_color and Player[color].seated then
        return
    end

    local zone = getObjectFromGUID(elementScanZones[color])
    for _, obj in ipairs(zone.getObjects()) do
        if obj.hasTag("Spirit") then
            local supported = false
            local energyTotal = 0
            local trackEnergy = obj.getTable("trackEnergy")
            if trackEnergy ~= nil then
                supported = true
                for _, energy in pairs(trackEnergy) do
                    if not detectPresence(obj, energy.position) then
                        energyTotal = energyTotal + energy.count
                        break
                    end
                end
            end
            local bonusEnergy = obj.getTable("bonusEnergy")
            if bonusEnergy ~= nil then
                supported = true
                for _, energy in pairs(bonusEnergy) do
                    if not detectPresence(obj, energy.position) then
                        energyTotal = energyTotal + energy.count
                    end
                end
            end
            if not supported then
                Player[color].broadcast("Spirit does not support automatic energy gain", Color.SoftYellow)
            else
                local refunded = updateEnergyCounter(color, true, energyTotal)
                if not refunded then
                    refunded = refundEnergyTokens(color, energyTotal)
                end
                if refunded then
                    selectedColors[color].gained = true
                    target_obj.editButton({index=2, label="Gained", click_function="returnEnergy", color="Green", tooltip="Right click to return energy from presence track"})
                else
                    Player[source_color].broadcast("Was unable to gain energy", Color.SoftYellow)
                end
            end
            break
        end
    end
end
function returnEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif not alt_click then
        return
    end
    local color = target_obj.getVar("playerColor")
    if color ~= source_color and Player[color].seated then
        return
    end

    local zone = getObjectFromGUID(elementScanZones[color])
    for _, obj in ipairs(zone.getObjects()) do
        if obj.hasTag("Spirit") then
            local supported = false
            local energyTotal = 0
            local trackEnergy = obj.getTable("trackEnergy")
            if trackEnergy ~= nil then
                supported = true
                for _, energy in pairs(trackEnergy) do
                    if not detectPresence(obj, energy.position) then
                        energyTotal = energyTotal + energy.count
                        break
                    end
                end
            end
            local bonusEnergy = obj.getTable("bonusEnergy")
            if bonusEnergy ~= nil then
                supported = true
                for _, energy in pairs(bonusEnergy) do
                    if not detectPresence(obj, energy.position) then
                        energyTotal = energyTotal + energy.count
                    end
                end
            end
            if not supported then
                Player[color].broadcast("Spirit does not support automatic energy gain", Color.SoftYellow)
            else
                local paid = updateEnergyCounter(color, false, energyTotal)
                if not paid then
                    paid = payEnergyTokens(color, energyTotal)
                end
                if paid then
                    selectedColors[color].gained = false
                    target_obj.editButton({index=2, label="Gain", click_function="gainEnergy", color="Red", tooltip="Left click to gain energy from presence track"})
                else
                    Player[source_color].broadcast("You don't have enough energy", Color.SoftYellow)
                end
            end
            break
        end
    end
end
function payEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif alt_click then
        return
    end
    local color = target_obj.getVar("playerColor")
    if color ~= source_color and Player[color].seated then
        return
    end

    local paid = updateEnergyCounter(color, false, getEnergyLabel(color))
    if not paid then
        paid = payEnergyTokens(color, nil)
    end
    if paid then
        selectedColors[color].paid = true
        target_obj.editButton({index=1, label="Paid", click_function="refundEnergy", color="Green", tooltip="Right click to refund energy for your cards"})
    else
        Player[source_color].broadcast("You don't have enough energy", Color.SoftYellow)
    end
end
function updateEnergyCounter(color, refund, cost)
    if selectedColors[color].counter == nil or not selectedColors[color].counter.getLock() then
        return false
    end
    local energy = selectedColors[color].counter.getValue()
    if refund then
        cost = cost * -1
    end
    if cost > energy then
        return false
    end
    selectedColors[color].counter.setValue(energy - cost)
    return true
end
function payEnergyTokens(color, cost)
    if cost == nil then
        cost = getEnergyLabel(color)
    end
    local energy = 0
    local zone = getObjectFromGUID(elementScanZones[color])
    local objects = zone.getObjects()
    local energyTokens = {{}, {}}
    local oneEnergyTotal = 0
    for _, obj in ipairs(objects) do
        if obj.type == "Chip" then
            local quantity = obj.getQuantity()
            if quantity == -1 then
                quantity = 1
            end
            if obj.getName() == "1 Energy" then
                energy = energy + quantity
                oneEnergyTotal = oneEnergyTotal + quantity
                table.insert(energyTokens[1], obj)
            elseif obj.getName() == "3 Energy" then
                energy = energy + (3 * quantity)
                table.insert(energyTokens[2], obj)
            end
        end
    end
    if cost > energy then
        return false
    end
    -- Only spend 3 energy tokens until you don't go negative unless there aren't enough 1 energy tokens
    for i=#energyTokens[2],1,-1 do
        if cost <= 2 and oneEnergyTotal >= 2 then
            break
        end
        local obj = energyTokens[2][i]
        local quantity = obj.getQuantity()
        if quantity == -1 then
            quantity = 1
        end
        for j=1,quantity do
            if j == quantity then
                if obj.remainder then
                    obj = obj.remainder
                end
                obj.destruct()
                table.remove(energyTokens[2], i)
            else
                obj.takeObject({}).destruct()
            end
            cost = cost - 3
            if cost <= 2 and oneEnergyTotal >= 2 then
                break
            end
        end
    end
    -- Then spend 1 energy token
    for i=#energyTokens[1],1,-1 do
        if cost <= 0 then
            break
        end
        local obj = energyTokens[1][i]
        local quantity = obj.getQuantity()
        if quantity == -1 then
            quantity = 1
        end
        for j=1,quantity do
            if j == quantity then
                if obj.remainder then
                    obj = obj.remainder
                end
                obj.destruct()
                table.remove(energyTokens[1], i)
            else
                obj.takeObject({}).destruct()
            end
            cost = cost - 1
            if cost <= 0 then
                break
            end
        end
    end
    -- Now go back and spend remaining 3 energy tokens if needed
    for i=#energyTokens[2],1,-1 do
        if cost <= 0 then
            break
        end
        local obj = energyTokens[2][i]
        local quantity = obj.getQuantity()
        if quantity == -1 then
            quantity = 1
        end
        for j=1,quantity do
            if j == quantity then
                if obj.remainder then
                    obj = obj.remainder
                end
                obj.destruct()
                table.remove(energyTokens[2], i)
            else
                obj.takeObject({}).destruct()
            end
            cost = cost - 3
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
    end
    local color = target_obj.getVar("playerColor")
    if color ~= source_color and Player[color].seated then
        return
    end

    local refunded = updateEnergyCounter(color, true, getEnergyLabel(color))
    if not refunded then
        refunded = refundEnergyTokens(color, nil)
    end
    if refunded then
        selectedColors[color].paid = false
        target_obj.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", tooltip="Left click to pay energy for your cards"})
    else
        Player[source_color].broadcast("Was unable to refund energy", Color.SoftYellow)
    end
end
function refundEnergyTokens(color, cost)
    if cost == nil then
        cost = getEnergyLabel(color)
    end
    if cost < 0 then
        return payEnergyTokens(color, -cost)
    end
    local zone = getObjectFromGUID(elementScanZones[color])
    while cost >= 3 do
        threeEnergyBag.takeObject({
            position = zone.getPosition()+Vector(-10,2,-5),
            rotation = Vector(0,180,0),
            smooth = false,
        })
        cost = cost - 3
    end
    while cost >= 1 do
        oneEnergyBag.takeObject({
            position = zone.getPosition()+Vector(-10,2,-3),
            rotation = Vector(0,180,0),
            smooth = false,
        })
        cost = cost - 1
    end
    return true
end
function getCurrentEnergy(color)
    if selectedColors[color].counter ~= nil and selectedColors[color].counter.getLock() then
        return selectedColors[color].counter.getValue()
    end

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
                energy = energy + quantity
            elseif obj.getName() == "3 Energy" then
                energy = energy + (3 * quantity)
            end
        end
    end
    return energy
end

function setupSwapButtons()
    for color,obj in pairs(playerTables) do
        obj.setVar("playerColor", color)
        local scale = flipVector(Vector(obj.getScale()))
        scale = scale * 2
        -- Sit Here (button index 0)
        obj.createButton({
            label="", click_function="onClickedSitHere", function_owner=Global,
            position={-3.25,0.4,7.5}, rotation={0,0,0}, height=0, width=0, scale=scale,
            font_color={0,0,0}, font_size=250,
            tooltip="Moves your current player color to be located here. The color currently seated here will be moved to your current location. Spirit panels and other cards will be relocated if applicable.",
        })
        -- Change Color (button index 1)
        obj.createButton({
            label="", click_function="onClickedChangeColor", function_owner=Global,
            position={3.25,0.4,7.5}, rotation={0,0,0}, height=0, width=0, scale=scale,
            font_color={0,0,0}, font_size=250,
            tooltip="Change to be this color, updating all of your presence and reminder tokens accordingly. The player that is this color will be changed to be yours. Your seating position will not change.",
        })
        -- Play Spirit (button index 2)
        obj.createButton({
            label="", click_function="onClickedPlaySpirit", function_owner=Global,
            position={0,0.4,7.5}, rotation={0,0,0}, height=0, width=0, scale=scale,
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
    local table = playerTables[color]
    if table == nil then return end
    if Player[color].seated or not selectedColors[color] then
        table.editButton({index=2, label="", height=0, width=0})
    else
        table.editButton({index=2, label="Play Spirit", height=400, width=1500})
    end
end
---- UI Section
childHeight = 64
childWidth = 64
childFontSize = 30
forceInvaderUpdate = false

titleBGColorNA="#666666"
titleColorNA="#222222"
titleBGColor="#CCCCCC"
titleColor="black"

invaderColors = {
    "white", -- Stage I
    "white", -- Stage II
    "white", -- Stage III
    S = "yellow",
    M = "#666666",
    W = "#AAEEFF",
    J = "green",
    C = "blue",
    n = "#444444", -- no cards
    E = "#FF3300", -- Stage EMPTY
    ["_"] = "#444444" -- No Explore
}
invaderFontColors = {
    "black", -- Stage I
    "black", -- Stage II
    "black", -- Stage III
    S = "black",
    M = "black",
    W = "black",
    J = "black",
    C = "black",
    n = "#666666", -- no cards
    E = "black", -- Stage EMPTY
    ["_"] = "#666666" -- No Explore
}
tooltips = {
    "Stage I",
    "Stage II",
    "Stage III",
    S = "Sands",
    M = "Mountains",
    W = "Wetlands",
    J = "Jungle",
    C = "Coastal",
    n = "NO ACTION", -- no cards
    E = "YOU LOSE WHEN THE\nINVADERS NEXT\nEXPLORE", -- Stage EMPTY
    ["_"] = "UNKNOWN UNTIL\nNEXT INVADER PHASE" -- No Explore
}
textOut = {
    "I", -- Stage I
    "II", -- Stage II
    "III", -- Stage III
    S = "S",
    M = "M",
    W = "W",
    J = "J",
    C = "C",
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
    delim = delim or "|"
    local stringI = 1
    local outTable = {}
    while stringI < #inString do
        local delimPos = string.find(inString,delim,stringI)
        if delimPos then
            table.insert(outTable,string.sub(inString,stringI,delimPos-1))
            stringI = delimPos+1
        else
            table.insert(outTable,string.sub(inString,stringI))
            break
        end
    end
    return outTable
end
function visiTableToString(inTable,delim)
    delim = delim or "|"
    local outString = ""
    for _, v in ipairs(inTable) do
        outString = outString..v..delim
    end
    outString = string.sub(outString, 1, #outString-1)
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
    local colorEnabled = getCurrentState("panelInvader", player.color)
    toggleUI("panelInvader", player.color, colorEnabled)
    colorEnabled = getCurrentState("panelBlightFear", player.color)
    toggleUI("panelBlightFear", player.color, colorEnabled)
end
function toggleAdversaryUI(player)
    local colorEnabled = getCurrentState("panelAdversary", player.color)
    toggleUI("panelAdversary", player.color, colorEnabled)
end
function toggleTurnOrderUI(player)
    local colorEnabled = getCurrentState("panelTurnOrder", player.color)
    toggleUI("panelTurnOrder", player.color, colorEnabled)
end
function toggleScoreUI(player)
    local colorEnabled = getCurrentState("panelScore", player.color)
    toggleUI("panelScore", player.color, colorEnabled)
end
function toggleButtonUI(player)
    local colorEnabled = getCurrentState("panelPowerDraw", player.color)
    toggleUI("panelPowerDraw", player.color, colorEnabled)
    colorEnabled = getCurrentState("panelTimePasses", player.color)
    toggleUI("panelTimePasses", player.color, colorEnabled)
    colorEnabled = getCurrentState("panelReady", player.color)
    toggleUI("panelReady", player.color, colorEnabled)
end
function togglePlayerControls(player)
    if not player.admin then
        player.broadcast("Only promoted players can toggle seat controls.")
        return
    end
    showPlayerButtons = not showPlayerButtons
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
    if not forceInvaderUpdate and invaderCompare(tabIn,currentTable) then
        return
    end
    forceInvaderUpdate = false
    currentTable = tabIn
    for i,tType in pairs({"Build2","Ravage","Build","Explore"}) do
        hideAll(tType)
        local cards = tabIn[i]
        for j,card in pairs(cards) do
            for k = 1,string.len(card.type) do
                local type = string.sub(card.type,k,k)
                set(tType,j,k,type,card.escalate)
                size(tType,j,k,#cards,string.len(card.type))
                show(tType,j,k)
            end
        end
        if #cards == 0 then
            if tType == "Explore" then
                toggleInvaderPhaseImage(false)
                if tabIn["Stage"] ~= 0 then
                    set(tType,1,1,tabIn["Stage"],false)
                    size(tType,1,1,1,1)
                    show(tType,1,1)
                else
                    alert(tType)
                    size(tType,1,1,"E")
                    set(tType,1,1,"E",false)
                    show(tType,1,1)
                end
            else
                dark(tType)
                size(tType,1,1,"n")
                set(tType,1,1,"n",false)
                show(tType,1,1)
            end
        else
            if tType == "Explore" then
                toggleInvaderPhaseImage(true)
            end
            light(tType)
        end
    end
end
function toggleInvaderPhaseImage(explore)
    local current = UI.getAttribute("invaderImage", "image")
    local start, _ = string.find(current,"Stage")
    if start == nil and not explore then
        UI.setAttribute("invaderImage", "image", current.." Stage")
        UI.setAttribute("exploreAdvance", "onClick", "aidBoard/flipExploreCard")
    elseif start ~= nil and explore then
        UI.setAttribute("invaderImage", "image", string.sub(current, 1, start - 2))
        UI.setAttribute("exploreAdvance", "onClick", "aidBoard/advanceInvaderCards")
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
function set(a,b,c,d, escalate)
    local tooltip = tooltips[d]
    local text = textOut[d]
    if escalate then
        tooltip = tooltip.." with Escalation"
        text = text.."ₑ"
    end
    UI.setAttributes("panel"..a..b..c, {color = invaderColors[d], tooltip = tooltip, tooltipPosition="Above"})
    UI.setAttributes("panel"..a..b..c.."text", {color = invaderFontColors[d], text = text})
end
function hideAll(a)
    UI.setAttribute("panel"..a..11, "active", false)
    UI.setAttribute("panel"..a..12, "active", false)
    UI.setAttribute("panel"..a..21, "active", false)
    UI.setAttribute("panel"..a..22, "active", false)
    UI.setAttribute("panel"..a..31, "active", false)
    UI.setAttribute("panel"..a..32, "active", false)
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

function invaderCompare(t1,t2)
    local function cc2(tab)
        local newTab = {}
        newTab[1] = tab["Stage"]
        for i,v in ipairs(tab) do
            newTab[i+1] = ""
            for _,w in ipairs(v) do
                newTab[i+1] = newTab[i+1]..w.type..tostring(w.escalation)
            end
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
    local function handsSwap()
        for i = 1,3 do
            local ta = Player[a].getHandTransform(i)
            local tb = Player[b].getHandTransform(i)
            Player[a].setHandTransform(tb, i)
            Player[b].setHandTransform(ta, i)
        end
    end

    handsSwap()
    positionSwap(playerTables)
    tableSwap(playerBlocks)
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
        local t = upCast(playerTable, 2)
        for i = 1,3 do
            for _,obj in ipairs(Player[color].getHandObjects(i)) do
                table.insert(t, obj)
            end
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
        if selectedColors[from] then
            selectedColors[from].defend.setPosition(selectedColors[from].defend.getPosition() + transform)
            selectedColors[from].isolate.setPosition(selectedColors[from].isolate.getPosition() + transform)
            if not selectedColors[to] then
                for _, bag in pairs(selectedColors[from].elements) do
                    bag.setPosition(bag.getPosition() + transform)
                    bag.clearButtons()
                end
            end
        end
    end

    -- Fix for handling Fractured's 3rd hand with "Sit Here"
    local offset = Player[b].getHandTransform(1).position - Player[a].getHandTransform(1).position
    local ta = Player[a].getHandTransform(3)
    local tb = Player[b].getHandTransform(3)
    if ta.position.z < -40 or tb.position.z < -40 then
        ta.position = ta.position + offset
        tb.position = tb.position - offset
        Player[a].setHandTransform(tb, 3)
        Player[b].setHandTransform(ta, 3)
    end

    if selectedColors[a] and selectedColors[b] then
        local bags = selectedColors[a].elements
        selectedColors[a].elements = selectedColors[b].elements
        selectedColors[b].elements = bags
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
    local function initData(color, ix)
        local bag = getObjectFromGUID(PlayerBags[color])
        -- If color has not been selected this will be changed during player bag emptying
        local colorTint = color
        if selectedColors[color] then
            colorTint = selectedColors[color].defend.getColorTint()
        end
        return {
            color = color,
            ix = ix,
            bag = bag,
            qty = bag.getQuantity(),
            tint = colorTint,
            presenceTint = bag.getColorTint(),
            objects = {},
            pattern = color .. "'s (.*)",
            bagContents = {},
        }
    end
    local colors = {
        from = initData(fromColor, 1),
        to = initData(toColor, 2)
    }

    -- If both bags are full, there's not a lot of work to do.
    if colors.from.qty == 25 and colors.to.qty == 25 then
        return
    end

    selectedColors[fromColor], selectedColors[toColor] = selectedColors[toColor], selectedColors[fromColor]
    -- Only need to handle case where both colors have spirits here
    if selectedColors[fromColor] and selectedColors[toColor] then
        local bag = selectedColors[fromColor].defend
        local pos = bag.getPosition()
        selectedColors[fromColor].defend = selectedColors[toColor].defend
        selectedColors[toColor].defend = bag
        selectedColors[toColor].defend.setPosition(selectedColors[fromColor].defend.getPosition())
        selectedColors[fromColor].defend.setPosition(pos)

        bag = selectedColors[fromColor].isolate
        pos = bag.getPosition()
        selectedColors[fromColor].isolate = selectedColors[toColor].isolate
        selectedColors[toColor].isolate = bag
        selectedColors[toColor].isolate.setPosition(selectedColors[fromColor].isolate.getPosition())
        selectedColors[fromColor].isolate.setPosition(pos)
    end

    -- Remove any items still in the bags
    for _, data in pairs(colors) do
        for i = 1,data.qty do
            local obj = data.bag.takeObject({
                sound = false,
                position = Vector(data.ix*2, i*2, 200),    -- Chosen to be out-of-the-way and to prevent items from stacking.
                smooth = false,
            })
            table.insert(data.bagContents, obj.guid)
            if obj.getName() == "Defend Tokens" then
                data.tint = obj.getColorTint()
            end
        end
    end

    -- Pass 1: Iterate over all objects looking for "<color>'s X".
    -- Make a note of what we find and what tint it is.
    local match = string.match  -- Performance
    for _,obj in pairs(getObjects()) do
        local name = obj.getName()
        if name then
            for _,data in pairs(colors) do
                local suffix = match(name, data.pattern)
                if suffix then
                    if not data.objects[suffix] then
                        data.objects[suffix] = {obj}
                    else
                        table.insert(data.objects[suffix], obj)
                    end
                end
            end
        end
    end

    -- Pass 2: Iterate over found objects and swap color tints and object names.
    -- After we're done, put objects in their new player bag, if applicable.
    Wait.frames(function()
        for _,ab in pairs({{colors.from, colors.to}, {colors.to, colors.from}}) do
            local a, b = unpack(ab)
            local stop = #b.bagContents-1
            if stop <= 0 then stop = 1 end
            for i = #b.bagContents,stop,-1 do  -- Iterate in reverse order.
                local obj = getObjectFromGUID(b.bagContents[i])
                local name = obj.getName()
                if name == "Defend Tokens" then
                    local pos = selectedColors[b.color].defend.getPosition()
                    a.bag.putObject(selectedColors[b.color].defend)
                    obj.setPosition(pos)
                    obj.setLock(true)
                    selectedColors[b.color].defend = obj
                elseif name == "Isolate Tokens" then
                    local pos = selectedColors[b.color].isolate.getPosition()
                    a.bag.putObject(selectedColors[b.color].isolate)
                    obj.setPosition(pos)
                    obj.setLock(true)
                    selectedColors[b.color].isolate = obj
                else
                    broadcastToAll("Internal Error: Unknown object " .. name .. " in player bag.", Color.Red)
                end
            end
            for suffix, objs in pairs(b.objects) do
                if suffix == "Presence" then
                    local newname = a.color .. "'s " .. suffix
                    for _, obj in ipairs(objs) do
                        obj.setColorTint(a.presenceTint)
                        obj.setName(newname)
                        local originalState = obj.getStateId()
                        if obj.getStateId() == 1 then
                            obj = obj.setState(2)
                        else
                            if obj.getDecals() then
                                makeSacredSite(obj)
                            end
                            obj = obj.setState(1)
                        end
                        obj.setColorTint(a.presenceTint)
                        obj.setName(newname)
                        if originalState == 1 then
                            if obj.getDecals() then
                                makeSacredSite(obj)
                            end
                        end
                        _ = obj.setState(originalState)
                    end
                elseif suffix == "Defend" then
                    -- Easier to grab new defend token than to change the name and color of every state
                    for _, obj in ipairs(objs) do
                        local attrs = {position = obj.getPosition(), rotation = obj.getRotation(), smooth = false}
                        local locked = obj.getLock()
                        local state = obj.getStateId()
                        destroyObject(obj)
                        obj = selectedColors[a.color].defend.takeObject(attrs)
                        if state ~= 1 then
                            obj = obj.setState(state)
                        end
                        obj.setLock(locked)
                    end
                else
                    local newname = a.color .. "'s " .. suffix
                    for _, obj in ipairs(objs) do
                        local states = obj.getStates()
                        if states ~= nil and #states > 1 then
                            broadcastToAll("Internal Error: Object " .. obj.getName() .. " has multiple states and may not handle color swap properly.", Color.Red)
                        end
                        obj.setColorTint(a.tint)
                        obj.setName(newname)
                    end
                end
            end
            for i = #b.bagContents - 2,1,-1 do  -- Iterate in reverse order.
                a.bag.putObject(getObjectFromGUID(b.bagContents[i]))
            end
        end
    end, 1)
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
        pa.broadcast("There's already a color swap in progress, please wait and try again", Color.Red)
        return
    end
    colorLock = true

    if pa.seated then
        if pb.seated then
            if pa.steam_id == pb.steam_id then  -- Hotseat game
                -- Hotseat games may lose track of the player when their color changes for strange reasons -- mainly because they're prompted to reenter their name again.
                broadcastToAll("Color swapping may be unstable in hotseat games.", Color.Red)
            end
            -- Need a temporary color to seat the player at to swap colors. Favor those not used by the game first, followed by those used by the game.
            -- Use Black as a last resort since the player accidentally becoming a GM is probably A Bad Thing(tm).
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

function swapPlayerUI(a, b, xmlID)
    local aEnabled = false
    local bEnabled = false
    local currentVisiTable = getVisiTable(xmlID)
    for _,color in ipairs(currentVisiTable) do
        if color == a then
            aEnabled = true
        elseif color == b then
            bEnabled = true
        end
    end
    if aEnabled == bEnabled then
        return nil
    end

    local newVisiTable = {}
    for _,color in ipairs(currentVisiTable) do
        if (color ~= a and aEnabled) or (color ~= b and bEnabled) then
            table.insert(newVisiTable,color)
        end
    end
    if aEnabled then
        table.insert(newVisiTable,b)
    else
        table.insert(newVisiTable,a)
    end
    return newVisiTable
end
function swapPlayerUIs(a, b)
    local newVisiTable = swapPlayerUI(a, b, "panelUIToggleHide")
    if newVisiTable ~= nil then
        setVisiTable("panelUIToggleHide",newVisiTable)
        setVisiTable("panelUI",newVisiTable)
    end

    newVisiTable = swapPlayerUI(a, b, "panelInvader")
    if newVisiTable ~= nil then
        setVisiTable("panelInvader",newVisiTable)
        setVisiTable("panelBlightFear",newVisiTable)
    end

    newVisiTable = swapPlayerUI(a, b, "panelAdversary")
    if newVisiTable ~= nil then
        setVisiTable("panelAdversary",newVisiTable)
    end

    newVisiTable = swapPlayerUI(a, b, "panelTurnOrder")
    if newVisiTable ~= nil then
        setVisiTable("panelTurnOrder",newVisiTable)
    end

    newVisiTable = swapPlayerUI(a, b, "panelScore")
    if newVisiTable ~= nil then
        setVisiTable("panelScore",newVisiTable)
    end

    newVisiTable = swapPlayerUI(a, b, "panelPowerDraw")
    if newVisiTable ~= nil then
        setVisiTable("panelPowerDraw",newVisiTable)
        setVisiTable("panelTimePasses",newVisiTable)
        setVisiTable("panelReady",newVisiTable)
    end
end

function swapSeatColors(a, b)
    if not swapPlayerColors(a, b) then
        return
    end
    swapPlayerPresenceColors(a, b)
    swapPlayerAreaColors(a, b)
    swapPlayerUIs(a, b)
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

function isIslandBoard(params)
    if params.obj == nil then
        return false
    end
    return params.obj.hasTag("Balanced") or params.obj.hasTag("Thematic")
end
function isPowerCard(params)
    if params.card == nil then
        return false
    end
    return params.card.type == "Card" and (params.card.hasTag("Minor") or params.card.hasTag("Major") or params.card.hasTag("Unique"))
end
function onObjectSpawn(obj)
    if isPowerCard({card=obj}) then
        applyPowerCardContextMenuItems(obj)
    end
end
function applyPowerCardContextMenuItems(card)
    card.addContextMenuItem(
        "Discard (to 2nd hand)",
        function(player_color)
            for _,obj in pairs(Player[player_color].getSelectedObjects()) do
                if isPowerCard({card=obj}) then
                    obj.deal(1, player_color, 2)
                end
            end
        end,
        false)
    card.addContextMenuItem(
        "Forget",
        function(player_color)
            for _,obj in pairs(Player[player_color].getSelectedObjects()) do
                if isPowerCard({card=obj}) then
                    -- This ugliness is because setPositionSmooth doesn't work from a hand.
                    ensureCardInPlay(obj)
                    discardPowerCardFromPlay({card = obj, discardHeight = 1})
                end
            end
        end,
        false)
end

-- ensureCardInPlay moves the supplied card from a player's hand to a safe
-- location, if it's in a hand.
function ensureCardInPlay(card)
    for _, color in pairs(Player.getAvailableColors()) do
        for handIndex=1,Player[color].getHandCount() do
            if isObjectInHand(card, color, handIndex) then
                local cpos = card.getPosition()
                card.setPosition(Vector(cpos.x, 0, cpos.z))
                return
            end
        end
    end
end


function isObjectInHand(obj, color, handIndex)
    for _, handObj in ipairs(Player[color].getHandObjects(handIndex)) do
        if obj.guid == handObj.guid then
            return true
        end
    end
    return false
end

function enterSpiritPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 1 then return end
    broadcastToAll("Entering Spirit Phase", Color.White)
    updateCurrentPhase(true)
    currentPhase = 1
    updateCurrentPhase(false)

    for color,_ in pairs(selectedColors) do
        Player[color].broadcast("Energy at start of Spirit Phase: "..getCurrentEnergy(color), Color.SoftYellow)
    end
end
function enterFastPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 2 then return end
    broadcastToAll("Entering Fast Power Phase", Color.White)
    updateCurrentPhase(true)
    currentPhase = 2
    updateCurrentPhase(false)
end
function enterInvaderPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 3 then return end
    broadcastToAll("Entering Invader Phase", Color.White)
    if blightedIslandCard and not blightedIslandCard.is_face_down and blightedIslandCard.getDescription() ~= "" then
        printToAll(blightedIslandCard.getName()..": ", Color.White)
        printToAll(blightedIslandCard.getDescription(), Color.SoftBlue)
    end
    updateCurrentPhase(true)
    currentPhase = 3
    updateCurrentPhase(false)
end
function enterSlowPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 4 then return end
    broadcastToAll("Entering Slow Power Phase", Color.White)
    updateCurrentPhase(true)
    currentPhase = 4
    updateCurrentPhase(false)
end
function updateCurrentPhase(clear)
    local id = ""
    if currentPhase == 1 then
        id = "spiritPhase"
    elseif currentPhase == 2 then
        id = "fastPhase"
    elseif currentPhase == 3 then
        id = "invaderPhase"
    elseif currentPhase == 4 then
        id = "slowPhase"
    end
    local attributes = {
        textColor = "#323232"
    }
    if clear then
        attributes.text = string.sub(UI.getAttribute(id, "text"), 3, -3)
    else
        attributes.text = ">>"..UI.getAttribute(id, "text").."<<"
    end
    UI.setAttributes(id, attributes)
end
