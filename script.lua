---- Versioning
version = "3.8.0-beta.1"
versionGuid = "57d9fe"
---- Used with Spirit Board Scripts
counterBag = "EnergyCounters"
minorPowerZone = "cb16ab"
majorPowerZone = "089896"
playerBag = "PlayerBag"
Tints = {
    ["Red"] = {
        Presence = "#DA1A18",
        Token = "#FF514F"
    },
    ["Purple"] = {
        Presence = "#A020F0",
        Token = "#C467FE"
    },
    ["Yellow"] = {
        Presence = "#E7E52C",
        Token = "#FFFC34"
    },
    ["Blue"] = {
        Presence = "#0038FF",
        Token = "#358EFF"
    },
    ["Green"] = {
        Presence = "#28D620",
        Token = "#52FF4A"
    },
    ["Orange"] = {
        Presence = "#FF6920",
        Token = "#FFA240"
    },
    ["Teal"] = {
        Presence = "#4CFAB4",
        Token = "#59FFBB"
    },
    ["Pink"] = {
        Presence = "#F46FCD",
        Token = "#FF73F1"
    },
    ["Brown"] = {
        Presence = "#772F00",
        Token = "#B26C2A"
    },
    ["White"] = {
        Presence = "#FFFFFF",
    },
}
---- Used with Adversary Scripts
eventDeckZone = "a16796"
invaderDeckZone = "dd0921"
stage1DeckZone = "cf2635"
stage2DeckZone = "7f21be"
stage3DeckZone = "2a9f36"
adversaryBag = "AdversaryBag"
scenarioBag = "ScenarioBag"
------ Saved Config Data
numPlayers = 1
numBoards = 1
boardLayout = "Balanced"
expansions = {}
events = {}
fearPool = 0
generatedFear = 0
setupCompleted = false
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
showPlayerButtons = true
onlyCleanupTimePasses = false
objectsToCleanup = {}
extraRandomBoard = nil
gamekeys = {}
noFear = false
noHealInvader = false
noHealDahan = false
turn = 1
terrorLevel = 1
seatTables = {"dce473", "c99d4d", "794c81", "125e82", "d7d593", "33c4af"}
playerTables = {}
recorder = nil
------ Unsaved Config Data
gamePaused = false
stagesSetup = 0
boardsSetup = 0
adversaryLossCallback = nil
adversaryLossCallback2 = nil
wave = 1
castDown = nil
castDownTimer = nil
castDownColor = nil
presenceTimer = nil
victoryTimer = nil
loss = nil
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
blightDeckZone = "b38ea8"
fearDeckSetupZone = "fbbf69"
sourceSpirit = "SourceSpirit"
------
dahanBag = "f4c173"
blightBag = "af50b8"
boxBlightBag = "BoxBlightBag"
beastsBag = "a42427"
diseaseBag = "7019af"
wildsBag = "ca5089"
strifeBag = "af4e63"
badlandsBag = "d3f7f8"
vitalityBag = "fdff9d"
oneEnergyBag = "d336ca"
threeEnergyBag = "a1b7da"
speedBag = "f5ba21"
genericDefendBag = "1716e3"
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
        local handZone = Player["Black"].getHandTransform(handIndex)
        handZone.scale.x = handZone.scale.x + 0.75
        handZone.position.x = handZone.position.x - 0.375
        Player["Black"].setHandTransform(handZone, handIndex)
    end
end
function onObjectLeaveZone(zone, leave_object)
    if zone.guid == "2d3124" or zone.guid == "ac8366" then
        local handIndex = 1
        if zone.guid == "ac8366" then
            handIndex = 2
        end
        local handZone = Player["Black"].getHandTransform(handIndex)
        handZone.scale.x = handZone.scale.x - 0.75
        handZone.position.x = handZone.position.x + 0.375
        Player["Black"].setHandTransform(handZone, handIndex)
    end
end
function onScriptingButtonDown(index, playerColor)
    if gamekeys[playerColor] then return end
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
                cleanupObject({obj = collision_info.collision_object, fear = false, reason = "Removing"})
            end
        end
    -- TODO: extract cast down code once onObjectCollisionEnter can exist outside of global
    elseif isIslandBoard({obj=hit_object}) and hit_object.getName() == castDown then
        cleanupObject({obj = collision_info.collision_object, fear = true, remove = true, color = castDownColor, reason = "Cast Down"})
        if castDownTimer ~= nil then
            Wait.stop(castDownTimer)
        end
        castDownTimer = Wait.time(function() castDownCallback(hit_object) end, 0.5)
    end
    -- HACK: Temporary fix until TTS bug resolved https://tabletopsimulator.nolt.io/770
    if scenarioCard ~= nil and scenarioCard.getVar("onObjectCollision") then
        scenarioCard.call("onObjectCollisionEnter", {hit_object=hit_object, collision_info=collision_info})
    end
end
function castDownCallback(board)
    local mapCount = getMapCount({norm = true, them = true})
    castDown = nil
    castDownTimer = nil
    castDownColor = nil
    local bag
    if board.hasTag("Balanced") then
        if board.getDecals() == nil then
            bag = StandardMapBag
        else
            bag = ExtraMapBag
        end
    else
        bag = ThematicMapBag
    end
    board.setLock(false)
    bag.putObject(board)
    bag.shuffle()

    -- because of some caching or delay, the map tile will still count even after it's put away
    if mapCount == 1 then
        Defeat({})
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
        local playerColor = object.getName():sub(1,-12)
        local labelColor = fontColor(Color[playerColor])
        makeLabel(container, 2, 0.3, -0.15, labelColor, false)
    elseif container.hasTag("Spirit") and object.hasTag("Aspect") then
        sourceSpirit.call("AddAspectButton", {obj = container})
    elseif container.hasTag("Label") and object.hasTag("Label") then
        local thickness = 0.11
        local offset = 0.01
        local backdrop = true
        if container.hasTag("Blight") then
            thickness = 0.363
            offset = 0.05
            backdrop = false
        end
        makeLabel(container, 1, thickness, offset, {1,1,1}, backdrop)
    end
end
function GetSacredSiteUrl(params)
    if params.color == "Red" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577478456/5AED930161D049CE76309D9A144DD720B6CD90DD/"
    elseif params.color == "Purple" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577508377/A054E6F4C28CDA53A6E1007637DAE2B31AD3B040/"
    elseif params.color == "Yellow" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577505356/7E936312C2DC02ADCBCF73431D14F0179648D945/"
    elseif params.color == "Blue" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577507696/4F328278536C079106E848C8CABE70CAC02B7D71/"
    elseif params.color == "Green" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577506124/3D05984B0E7FD2B6CFA262613512D65333CCDF0E/"
    elseif params.color == "Orange" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577503990/84E8BA700D5F36B9E7A1509F63B2108E55E1DE02/"
    elseif params.color == "Teal" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577507093/7F7AF0689015B0E9FEE404761DC05492342C6106/"
    elseif params.color == "Pink" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577508994/315444E91F9EA15D5C71DD676752C16EAD13A510/"
    elseif params.color == "Brown" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577509725/F59973839DF9CEF36777772990C72655C44339E2/"
    elseif params.color == "White" then
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577510383/5ABC8245C0D4D145DBB816C93FB59DFACB332E41/"
    else
        return "http://cloud-3.steamusercontent.com/ugc/1923617670577510383/5ABC8245C0D4D145DBB816C93FB59DFACB332E41/"
    end
end
function makeSacredSite(obj)
    local color = string.sub(obj.getName(),1,-12)
    local url = GetSacredSiteUrl({color = color})
    if url == "" then
        return
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
    local rotation = obj.getRotation()
    rotation.z = 0.0
    obj.setRotation(rotation)
end
function makeLabel(obj, count, thickness, offset, labelColor, backdrop)
    if obj.getQuantity() <= count then
        obj.clearButtons()
    elseif obj.getButtons() == nil then
        local quantity = obj.getQuantity()
        if backdrop then
            obj.createButton({
                click_function = "nullFunc",
                function_owner = Global,
                label          = "█",
                position       = Vector(0,thickness * quantity + offset,0),
                font_size      = 280 / obj.getScale().x * 0.75,
                font_color     = {0,0,0},
                width          = 0,
                height         = 0,
            })
        end
        obj.createButton({
            click_function = "nullFunc",
            function_owner = Global,
            label          = quantity,
            position       = Vector(0,thickness * quantity + offset,0),
            font_size      = 280 / obj.getScale().x,
            font_color     = labelColor,
            width          = 0,
            height         = 0,
        })
    else
        local quantity = obj.getQuantity()
        local index = 0
        if backdrop then
            local label = "█"
            if quantity > 9 then
                label = label.."█"
            end
            obj.editButton({
                index          = 0,
                label          = label,
                position       = Vector(0,thickness * quantity + offset,0),
            })
            index = 1
        end
        obj.editButton({
            index          = index,
            label          = obj.getQuantity(),
            position       = Vector(0,thickness * quantity + offset,0),
        })
    end
end
function onObjectLeaveContainer(container, object)
    if container.hasTag("Presence") and object.hasTag("Presence") then
        if container.getQuantity() == 1 and container.remainder.getStateId() ~= 2 then
            container.remainder.setDecals({})
        end
        if object.getStateId() ~= 2 then
            object.setDecals({})
        end
        local playerColor = object.getName():sub(1,-12)
        local labelColor = fontColor(Color[playerColor])
        makeLabel(container, 2, 0.3, -0.15, labelColor, false)
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
    elseif container.hasTag("Label") and object.hasTag("Label") then
        local thickness = 0.11
        local offset = 0.01
        local backdrop = true
        if container.hasTag("Blight") then
            thickness = 0.363
            offset = 0.05
            backdrop = false
        end
        makeLabel(container, 1, thickness, offset, {1,1,1}, backdrop)
    end
end
function onObjectEnterScriptingZone(zone, obj)
    if zone.guid == "341005" then
        if obj.guid == "969897" then
            terrorLevel = 2
            broadcastToAll("Terror Level II Achieved!", Color.SoftYellow)
            checkVictory()
        elseif obj.guid == "f96a71" then
            terrorLevel = 3
            broadcastToAll("Terror Level III Achieved!", Color.SoftYellow)
            checkVictory()
        end
    elseif gameStarted and obj.hasTag("Setup") and not obj.getVar("setupComplete") then
        for color,data in pairs(selectedColors) do
            if data.zone == zone then
                local success = obj.call("doSetup", {color=color})
                obj.setVar("setupComplete", success)
                break
            end
        end
    end
end
function onObjectLeaveScriptingZone(zone, obj)
    if zone.guid == "341005" then
        -- When deck is made terror dividers aren't being held
        if obj.guid == "969897" and obj.held_by_color then
            terrorLevel = 1
        elseif obj.guid == "f96a71" and obj.held_by_color then
            terrorLevel = 2
        end
    else
        for _,data in pairs(selectedColors) do
            if data.zone == zone then
                if obj.getTable("thresholds") ~= nil then
                    obj.setDecals({})
                end
                break
            end
        end
    end
end
function onSave()
    local data_table = {
        expansions = expansions,
        events = events,
        fearPool = fearPool,
        generatedFear = generatedFear,
        setupCompleted = setupCompleted,
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
        noFear = noFear,
        noHealInvader = noHealInvader,
        noHealDahan = noHealDahan,
        turn = turn,
        terrorLevel = terrorLevel,
        seatTables = seatTables,
        playerTables = convertObjectsToGuids(playerTables),

        panelInvaderVisibility = UI.getAttribute("panelInvader","visibility"),
        panelAdversaryVisibility = UI.getAttribute("panelAdversary","visibility"),
        panelTurnOrderVisibility = UI.getAttribute("panelTurnOrder","visibility"),
        panelTimePassesVisibility = UI.getAttribute("panelTimePasses","visibility"),
        panelReadyVisibility = UI.getAttribute("panelReady","visibility"),
        panelBlightFearVisibility = UI.getAttribute("panelBlightFear", "visibility"),
        panelPowerDrawVisibility = UI.getAttribute("panelPowerDraw", "visibility"),
        showPlayerButtons = showPlayerButtons,
        gamekeys = gamekeys
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
    if recorder ~= nil then
        data_table.recorder = recorder.guid
    end
    local selectedTable = {}
    for color,data in pairs(selectedColors) do
        local colorTable = {}
        if next(data) ~= nil then
            colorTable.ready = data.ready.guid
            colorTable.elements = convertObjectsToGuids(data.elements)
            colorTable.defend = data.defend.guid
            colorTable.isolate = data.isolate.guid
            colorTable.zone = data.zone.guid
            colorTable.paid = data.paid
            colorTable.gained = data.gained
            colorTable.bargain = data.bargain
            colorTable.debt = data.debt
            if data.counter ~= nil then
                colorTable.counter = data.counter.guid
            end
        end
        selectedTable[color] = colorTable
    end
    data_table.selectedColors = selectedTable
    return JSON.encode(data_table)
end
function onLoad(saved_data)
    local versionObj = getObjectFromGUID(versionGuid)
    if versionObj ~= nil then
        versionObj.setValue("version " .. version)
    end
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    Color.Add("SoftGreen", Color.new(0.75,1,0.67))

    clearHotkeys()
    for index, piece in ipairs(Pieces) do
        addHotkey("Add " .. piece, function (playerColor, hoveredObject, cursorLocation, key_down_up)
            if index <= 10 and not gamekeys[playerColor] then
                gamekeys[playerColor] = true
            end
            DropPiece(piece, cursorLocation, playerColor)
        end)
    end

    addHotkey("Remove Piece", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        if hoveredObject ~= nil and not hoveredObject.getLock() then
            cleanupObject({obj = hoveredObject, fear = false, color = playerColor, reason = "Removing"})
        end
    end)
    addHotkey("Destroy Piece", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        if hoveredObject ~= nil and not hoveredObject.getLock() then
            cleanupObject({obj = hoveredObject, fear = true, color = playerColor, reason = "Destroying"})
        end
    end)

    addHotkey("Add Fear", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("addFear", {color = playerColor})
    end)
    addHotkey("Remove Fear", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("removeFear", {color = playerColor})
    end)
    addHotkey("Flip Event Card", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        aidBoard.call("flipEventCard")
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
                forgetPowerCard({card = obj, discardHeight = 1, color = playerColor})
            end
        end
        if isPowerCard({card=hoveredObject}) then
            forgetPowerCard({card = hoveredObject, discardHeight = 1, color = playerColor})
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
        local obj = selectedColors[playerColor]
        if obj ~= nil and obj.zone ~= nil then
            reclaimAll(obj.zone, playerColor, false)
        end
    end)
    addContextMenuItem("Grab Spirit Markers", grabSpiritMarkers, false)
    addHotkey("Grab Spirit Markers", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        grabSpiritMarkers()
    end)
    addContextMenuItem("Grab Destroy Bag", grabDestroyBag, false)
    addHotkey("Grab Destroy Bag", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        local bag = getObjectFromGUID("fd0a22")
        if bag ~= nil then
            bag.takeObject({position = cursorLocation})
        end
    end)
    addHotkey("Flip Ready Token", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        if selectedColors[playerColor] and selectedColors[playerColor].ready then
            selectedColors[playerColor].ready.flip()
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
    eventDeckZone = getObjectFromGUID(eventDeckZone)
    blightDeckZone = getObjectFromGUID(blightDeckZone)
    fearDeckSetupZone = getObjectFromGUID(fearDeckSetupZone)
    invaderDeckZone = getObjectFromGUID(invaderDeckZone)
    counterBag = getObjectFromGUID(counterBag)
    sourceSpirit = getObjectFromGUID(sourceSpirit)
    playerBag = getObjectFromGUID(playerBag)
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
    vitalityBag = getObjectFromGUID(vitalityBag)
    oneEnergyBag = getObjectFromGUID(oneEnergyBag)
    threeEnergyBag = getObjectFromGUID(threeEnergyBag)
    speedBag = getObjectFromGUID(speedBag)
    genericDefendBag = getObjectFromGUID(genericDefendBag)
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
        setupCompleted = loaded_data.setupCompleted
        gameStarted = loaded_data.gameStarted
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
        gamekeys = loaded_data.gamekeys
        noFear = loaded_data.noFear
        noHealInvader = loaded_data.noHealInvader
        noHealDahan = loaded_data.noHealDahan
        turn = loaded_data.turn
        terrorLevel = loaded_data.terrorLevel
        seatTables = loaded_data.seatTables
        playerTables = convertGuidsToObjects(loaded_data.playerTables)
        recorder = getObjectFromGUID(loaded_data.recorder)

        if gameStarted then
            UI.setAttribute("panelInvader","visibility",loaded_data.panelInvaderVisibility)
            UI.setAttribute("panelAdversary","visibility",loaded_data.panelAdversaryVisibility)
            UI.setAttribute("panelTurnOrder","visibility",loaded_data.panelTurnOrderVisibility)
            UI.setAttribute("panelTimePasses","visibility",loaded_data.panelTimePassesVisibility)
            UI.setAttribute("panelReady","visibility",loaded_data.panelReadyVisibility)
            UI.setAttribute("panelBlightFear","visibility",loaded_data.panelBlightFearVisibility)
            UI.setAttribute("panelPowerDraw","visibility",loaded_data.panelPowerDrawVisibility)
            UI.setAttribute("panelUIToggle","active","true")
            UI.setAttribute("panelTurnOverTurn", "text", "Turn: "..turn)

            for _, presence in pairs(getObjectsWithTag("Presence")) do
                onObjectEnterContainer(presence, presence)
            end
            for _, token in pairs(getObjectsWithTag("Label")) do
                onObjectEnterContainer(token, token)
            end

            updateCurrentPhase(false)
            seaTile.registerCollisions(false)
            SetupPowerDecks()
            Wait.frames(addGainPowerCardButtons, 1)
            Wait.condition(function()
                aidBoard.call("setupGame")
                createDifficultyButton()
            end, function() return not aidBoard.spawning end)
            Wait.condition(adversaryUISetup, function() return (adversaryCard == nil or not adversaryCard.spawning) and (adversaryCard2 == nil or not adversaryCard2.spawning) end)
            Wait.time(bargainCheck,2,-1)
            Wait.time(readyCheck,1,-1)
            enableVictoryDefeat()

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
    for color,data in pairs(selectedColors) do
        local colorTable = {}
        if next(data) ~= nil then
            colorTable.ready = getObjectFromGUID(data.ready)
            colorTable.elements = convertGuidsToObjects(data.elements)
            colorTable.defend = getObjectFromGUID(data.defend)
            colorTable.isolate = getObjectFromGUID(data.isolate)
            colorTable.zone = getObjectFromGUID(data.zone)
            colorTable.paid = data.paid
            colorTable.gained = data.gained
            colorTable.bargain = data.bargain
            colorTable.debt = data.debt
            if data.counter ~= nil then
                colorTable.counter = getObjectFromGUID(data.counter)
            end
        end
        selectedColors[color] = colorTable
    end

    if Player["White"].seated and not selectedColors["White"] then
        Player["White"].changeColor("Grey")
    end
    updateAllPlayerAreas()
    setupTableButtons()
    updateCurrentPhase(false)
    Wait.time(spiritUpdater, 10, -1)
end
----
function bargainCheck()
    local bargain = {}
    for color,_ in pairs(selectedColors) do
        bargain[color] = 0
    end
    for _,obj in pairs(getObjectsWithTag("Bargain")) do
        for _,object in pairs(upCast(obj, 0, 0.1)) do
            if object.hasTag("Presence") then
                local count = object.getQuantity()
                if count == -1 then
                    count = 1
                end
                local color = string.sub(object.getName(),1,-12)
                if selectedColors[color] == nil then
                    color = getSpiritColor({name = object.getDescription()})
                end

                bargain[color] = bargain[color] + count
            end
        end
    end

    for color,count in pairs(bargain) do
        if selectedColors[color].bargain ~= count then
            if count == 0 then
                selectedColors[color].debt = 0
                if selectedColors[color].zone then
                    selectedColors[color].zone.editButton({index=4, label=""})
                    selectedColors[color].zone.editButton({index=5, label="", click_function="nullFunc", color="White", height=0, width=0, tooltip=""})
                end
            else
                selectedColors[color].debt = selectedColors[color].debt + count - selectedColors[color].bargain
                if selectedColors[color].zone then
                    selectedColors[color].zone.editButton({index=4, label="Debt: "..selectedColors[color].debt})
                    if selectedColors[color].bargain == 0 then
                        selectedColors[color].zone.editButton({index=5, label="Pay 1", click_function="payDebt", color="Red", height=600, width=1550, tooltip="Left click to pay 1 energy to Bargain Debt. Right click to refund 1 energy from Bargain Debt."})
                    end
                end
            end
            selectedColors[color].bargain = count
        end
    end
end
function readyCheck()
    local colorCount = 0
    local readyCount = 0
    for _,data in pairs(selectedColors) do
        if data.ready and data.ready.is_face_down and data.ready.resting then
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
    return boardLayout == "Thematic" or boardLayout == "Custom Thematic"
end
---- Setup Buttons Section
function nullFunc()
end
function CanSetupGame()
    if getMapCount({norm = true, them = false}) > 0 and getMapCount({norm = false, them = true}) > 0 then
        broadcastToAll("You can only have one type of board at once", Color.Red)
        return false
    end
    if (numPlayers > 6 or (numPlayers == 6 and SetupChecker.getVar("optionalExtraBoard"))) and isThematic() then
        broadcastToAll("Thematic setup can't use more than 6 boards", Color.Red)
        return false
    end
    if (numPlayers > 7 or (numPlayers == 7 and SetupChecker.getVar("optionalExtraBoard"))) and getMapCount({norm = true, them = true}) == 0 then
        broadcastToAll("Custom map setup is required for more than 7 boards", Color.Red)
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
            if numPlayers == 6 and isThematic() then
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
    showPlayerButtons = false
    updateColorPickButtons()
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
function usingBadlands()
    return expansions["Jagged Earth"]
end
function usingVitality()
    -- TODO: change me to check for nature incarnate expansion later
    return SetupChecker.getVar("optionalNatureIncarnateSetup")
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
        if scenarioCard ~= nil then
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
        if adversary == nil then
            randomAdversary(attempts + 1)
            return
        end
        if adversary.getVar("requirements") then
            local allowed = adversary.call("Requirements", {eventDeck = usingEvents(), blightCard = SetupChecker.getVar("optionalBlightCard"), expansions = expansions, thematic = isThematic()})
            if not allowed then
                adversary = nil
            end
        end
        local adversary2 = SetupChecker.call("RandomAdversary")
        if adversary2 == nil then
            randomAdversary(attempts + 1)
            return
        end
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
        local randomMaximizeLevel = SetupChecker.getVar("randomMaximizeLevel")
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
            local index
            if randomMaximizeLevel then
                index = #combos
            else
                index = math.random(1,#combos)
            end
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
        if adversary == nil then
            randomAdversary(attempts + 1)
            return
        end
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
        local randomMaximizeLevel = SetupChecker.getVar("randomMaximizeLevel")
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
            local index
            if randomMaximizeLevel then
                index = #combos
            else
                index = math.random(1,#combos)
            end
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
function SetupPlaytestDeck(zone, name, option, callback, done)
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
        deck.shuffle()
        if callback ~= nil then
            callback(deck, function()
                if done ~= nil then
                    done()
                end
            end)
        else
            if done ~= nil then
                done()
            end
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
            deck.shuffle()
            if callback ~= nil then
                callback(deck, function()
                    if done ~= nil then
                        done()
                    end
                end)
            else
                if done ~= nil then
                    done()
                end
            end
        else
            local objs = {cards}
            -- deck is never nil here
            for _ = 1,cardsCount do
                table.insert(objs, deck.takeObject({
                    rotation = {0, 180, 180},
                    smooth = false,
                }))
            end
            cards = group(objs)[1]
            cards.shuffle()
            if callback ~= nil then
                callback(cards, function()
                    cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                    deck.putObject(cards)
                    if done ~= nil then
                        done()
                    end
                end)
            else
                cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                deck.putObject(cards)
                if done ~= nil then
                    done()
                end
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
                if done ~= nil then
                    done()
                end
            end)
        else
            if deck == nil then
                cards.setPosition(zone.getPosition())
            else
                cards.setPosition(deck.getPosition() + Vector(0, 10, 0))
                deck.putObject(cards)
            end
            if done ~= nil then
                done()
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
    if done ~= nil then
        done()
    end
end
----- Pre Setup Section
function PreSetup()
    local preSetupSteps = 0
    if adversaryCard ~= nil and adversaryCard.getVar("preSetup") then
        print("PreSetup for Adversaries is now deprecated, please update code for "..adversaryCard.getName().." to maintain future compatibility with the mod")
        adversaryCard.call("PreSetup",{level = adversaryLevel})
        Wait.condition(function() preSetupSteps = preSetupSteps + 1 end, function() return adversaryCard.getVar("preSetupComplete") end)
    else
        preSetupSteps = preSetupSteps + 1
    end
    if adversaryCard2 ~= nil and adversaryCard2.getVar("preSetup") then
        print("PreSetup for Adversaries is now deprecated, please update code for "..adversaryCard2.getName().." to maintain future compatibility with the mod")
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
        local function setupInvaderPieces()
            local invaders = { explorer = nil, town = nil, city = nil }
            if adversaryCard ~= nil and adversaryCard.getVar("invaderSetup") then
                local results = adversaryCard.call("InvaderSetup",{level = adversaryLevel})
                if results then
                    if results.explorer then
                        invaders.explorer = results.explorer
                    end
                    if results.town then
                        invaders.town = results.town
                    end
                    if results.city then
                        invaders.city = results.city
                    end
                end
            end
            if adversaryCard2 ~= nil and adversaryCard2.getVar("invaderSetup") then
                local results = adversaryCard2.call("InvaderSetup",{level = adversaryLevel2})
                if results then
                    for _,key in pairs({"explorer", "town", "city"}) do
                        if results[key] == nil then
                            goto continue
                        elseif invaders[key] == nil then
                            invaders[key] = results[key]
                            goto continue
                        end

                        if results[key].tooltip then
                            if invaders[key].tooltip then
                                invaders[key].tooltip = invaders[key].tooltip.."\n\n"..results[key].tooltip
                            else
                                invaders[key].tooltip = results[key].tooltip
                            end
                        end

                        if results[key].color then
                            if invaders[key].color then
                                invaders[key].color = Color.fromHex(invaders[key].color):lerp(Color.fromHex(results[key].color), 0.5):toHex(false)
                            else
                                invaders[key].color = results[key].color
                            end
                        end

                        if results[key].states then
                            if invaders[key].states then
                                for _,stateData in pairs(results[key].states) do
                                    table.insert(invaders[key].states, stateData)
                                end
                            else
                                invaders[key].states = results[key].states
                            end
                        end
                        ::continue::
                    end
                end
            end

            local count = 0
            local function updateInvaderData(bag, invader)
                if invader == nil then
                    count = count + 1
                    return
                end

                local function deepcopy(orig)
                    local orig_type = type(orig)
                    local copy
                    if orig_type == 'table' then
                        copy = {}
                        for orig_key, orig_value in next, orig, nil do
                            copy[deepcopy(orig_key)] = deepcopy(orig_value)
                        end
                        setmetatable(copy, deepcopy(getmetatable(orig)))
                    else -- number, string, boolean, etc
                        copy = orig
                    end
                    return copy
                end

                local tempObject = bag.takeObject({})
                local data = tempObject.getData()
                tempObject.destruct()
                local bagColor = nil

                if invader.tooltip then
                    data.Description = invader.tooltip

                    if data.States then
                        for _,state in pairs(data.States) do
                            state.Description = invader.tooltip
                        end
                    end
                end

                if invader.color then
                    local color = Color.fromHex(invader.color)
                    data.ColorDiffuse.r = color.r
                    data.ColorDiffuse.g = color.g
                    data.ColorDiffuse.b = color.b

                    if data.States then
                        for _,state in pairs(data.States) do
                            state.ColorDiffuse.r = color.r
                            state.ColorDiffuse.g = color.g
                            state.ColorDiffuse.b = color.b
                        end
                    end

                    bagColor = color
                end

                if invader.states then
                    local nextState = 2
                    if data.States then
                        for _,_ in pairs(data.States) do
                            nextState = nextState + 1
                        end
                    end
                    local originalStates = nextState - 1
                    for _=1,#invader.states do
                        if nextState == 2 then
                            data.States = {[2] = deepcopy(data)}
                        else
                            data.States[nextState] = deepcopy(data.States[nextState - 1])
                            local _,finish = data.Nickname:find(":")
                            data.States[nextState].Nickname = data.Nickname:sub(1, finish+1)..(nextState - 1).." Damage"
                        end
                        nextState = nextState + 1
                    end
                    for i=1,originalStates do
                        local state
                        if i == originalStates then
                            state = data
                        else
                            state = data.States[originalStates-i+1]
                        end

                        data.States[nextState-i].Transform = state.Transform
                        data.States[nextState-i].CustomMesh = state.CustomMesh
                    end
                    for i,stateData in pairs(invader.states) do
                        local state
                        if i == 1 then
                            state = data
                        else
                            state = data.States[i]
                        end

                        if stateData.color then
                            local color = Color.fromHex(stateData.color)
                            if bagColor then
                                bagColor = bagColor:lerp(color, 0.5)
                            else
                                bagColor = color
                            end
                            if invader.color then
                                color = color:lerp(Color.fromHex(invader.color), 0.5)
                            end
                            state.ColorDiffuse.r = color.r
                            state.ColorDiffuse.g = color.g
                            state.ColorDiffuse.b = color.b

                        end

                        if stateData.copy then
                            state.Transform = data.States[nextState-(originalStates-stateData.copy)-1].Transform
                            state.CustomMesh = data.States[nextState-(originalStates-stateData.copy)-1].CustomMesh
                        end
                    end
                end

                local obj = spawnObjectData({
                    data = data,
                    position = bag.getPosition() + Vector(0,2,0),
                })
                bag.reset()
                bag.setColorTint(bagColor)
                Wait.condition(function() count = count + 1 end, function() return obj.isDestroyed() end)
            end

            updateInvaderData(explorerBag, invaders.explorer)
            updateInvaderData(townBag, invaders.town)
            updateInvaderData(cityBag, invaders.city)

            Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return count == 3 end)
        end

        setupBlightTokens()
        setupInvaderPieces()
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
    if adversaryCard ~= nil then
        local blightTokens = adversaryCard.getVar("setupBlightTokens")
        if blightTokens ~= nil then
            numBlight = numBlight + math.min(blightTokens[adversaryLevel] * numBoards, max)
        end
    end
    if adversaryCard2 ~= nil then
        local blightTokens = adversaryCard2.getVar("setupBlightTokens")
        if blightTokens ~= nil then
            numBlight = numBlight + math.min(blightTokens[adversaryLevel2] * numBoards, max)
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

    local handZone = Player["Black"].getHandTransform(1)
    local fearDeck = fearDeckSetupZone.getObjects()[1]
    local count = 0

    fearDeck.shuffle()
    SetupPlaytestDeck(fearDeckSetupZone, "Fear", SetupChecker.getVar("playtestFear"), nil, nil)
    local maxCards = #fearDeck.getObjects()

    --[[
    Fear deck is setup in stages because there's been issues with terror dividers appearing in
    the wrong place. So now we add one set of fear cards, wait, add terror divider, wait, etc.
    ]]--
    for _ = 1, fearCards[1] do
        if count >= maxCards then
            broadcastToAll("Not enough Fear Cards", Color.Red)
            break
        end
        addFearCard({position = handZone.position - Vector(count/2, 0, 0)})
        count = count + 1
    end

    Wait.condition(function()
        local divider = getObjectFromGUID("969897")
        divider.setPosition(handZone.position - Vector(count/2, 0, 0))
        count = count + 1

        Wait.condition(function()
            for _ = 1, fearCards[2] do
                if count >= maxCards then
                    broadcastToAll("Not enough Fear Cards", Color.Red)
                    break
                end
                addFearCard({position = handZone.position - Vector(count/2 + 1.5, 0, 0)})
                count = count + 1
            end

            Wait.condition(function()
                divider = getObjectFromGUID("f96a71")
                divider.setPosition(handZone.position - Vector(count/2 + 1.5, 0, 0))
                count = count + 1

                Wait.condition(function()
                    for _ = 1, fearCards[3] do
                        if count >= maxCards then
                            broadcastToAll("Not enough Fear Cards", Color.Red)
                            break
                        end
                        addFearCard({position = handZone.position - Vector(count/2 + 3, 0, 0)})
                        count = count + 1
                    end

                    Wait.condition(function()
                        stagesSetup = stagesSetup + 1
                    end, function() return #Player["Black"].getHandObjects(1) == count end)
                end, function() return #Player["Black"].getHandObjects(1) == count end)
            end, function() return #Player["Black"].getHandObjects(1) == count end)
        end, function() return #Player["Black"].getHandObjects(1) == count end)
    end, function() return #Player["Black"].getHandObjects(1) == count end)

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
function addFearCard(params)
    local fearDeck = fearDeckSetupZone.getObjects()[1]
    if fearDeck == nil then
        broadcastToAll("No Fear Cards remaining", Color.Red)
        return
    end

    local position
    if params.position then
        position = params.position
    else
        local handTransform = Player["Black"].getHandTransform(1)
        position = handTransform.position + Vector(handTransform.scale.x/2, 0, 0)
    end

    if fearDeck.type == "Deck" then
        fearDeck.takeObject({
            position = position,
            rotation = Vector(0, 180, 180),
            smooth = false,
        })
    else
        fearDeck.setPosition(position)
        fearDeck.setRotation(Vector(0, 180, 180))
    end
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

    if not gameStarted then
        local function bncMinorPowersOptions(bncDeck, callback)
            local banList = SetupChecker.getTable("banList")["Minor Powers"]
            if not SetupChecker.getVar("optionalNatureIncarnateSetup") then
                if not banList["Growth Through Sacrifice"] and not banList["b35267"] then
                    local card = getObjectFromGUID("BnCBag").takeObject({
                        guid = "b35267",
                        position = getObjectFromGUID(minorPowerZone).getPosition(),
                        rotation = {0,180,180},
                        smooth = false,
                    })
                    bncDeck.putObject(card)
                    bncDeck.shuffle()
                end
            else
                if not banList["Roiling Bog and Snagging Thorn"] and not banList["c25a68"] then
                    local card = getObjectFromGUID("BnCBag").takeObject({
                        guid = "c25a68",
                        position = getObjectFromGUID(minorPowerZone).getPosition(),
                        rotation = {0,180,180},
                        smooth = false,
                    })
                    bncDeck.putObject(card)
                    bncDeck.shuffle()
                end
            end
            if callback ~= nil then
                callback()
            end
        end

        local minorPowers = getObjectFromGUID(minorPowerZone).getObjects()[1]
        if expansions["Branch & Claw"] and SetupChecker.getVar("playtestExpansion") ~= "Branch & Claw" then
            bncMinorPowersOptions(minorPowers)
        end
        minorPowers.shuffle()
        if SetupChecker.getVar("playtestExpansion") == "Branch & Claw" then
            SetupPlaytestPowerDeck(minorPowers, "Minor Powers", SetupChecker.getVar("playtestMinorPower"), bncMinorPowersOptions)
        else
            SetupPlaytestPowerDeck(minorPowers, "Minor Powers", SetupChecker.getVar("playtestMinorPower"), nil)
        end

        local majorPowers = getObjectFromGUID(majorPowerZone).getObjects()[1]
        majorPowers.shuffle()
        SetupPlaytestPowerDeck(majorPowers, "Major Powers", SetupChecker.getVar("playtestMajorPower"), nil)

        local banList = SetupChecker.getTable("banList")["Major Powers"]
        local exploratoryPowersDone = false
        if SetupChecker.getVar("exploratoryVOTD") and not banList["Vengeance of the Dead"] and not banList["152fe0"] then
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

        Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return exploratoryPowersDone end)
    end

    return 1
end
handOffset = Vector(0,-3.25,36)
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
    local powerDealCentre = handOffset + handPos

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
                    callback_function = CreatePickPowerButton,
                })
                tempCard.setLock(true)
                if isPlaytest then
                    tempCard.addTag("Playtest")
                end
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
                    callback_function = CreatePickPowerButton,
                })
                tempCard.setLock(true)
                if isPlaytest then
                    tempCard.addTag("Playtest")
                end
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
    card.clearButtons()
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
    cardo.call("PickPower", {})

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
        forgetPowerCard({card = obj, discardHeight = i})
        obj.clearButtons()
        Wait.condition(function() obj.setLock(false) end, function() return not obj.isSmoothMoving() end)
        discardTable[i] = obj
    end
    return discardTable
end
function forgetPowerCard(params)
    local discardZone
    if params.card.hasTag("Major") then
        if params.card.hasTag("Playtest") then
            discardZone = getObjectFromGUID(playtestMajorPowerDiscardZone)
        else
            discardZone = getObjectFromGUID(majorPowerDiscardZone)
        end
    elseif params.card.hasTag("Minor") then
        if params.card.hasTag("Playtest") then
            discardZone = getObjectFromGUID(playtestMinorPowerDiscardZone)
        else
            discardZone = getObjectFromGUID(minorPowerDiscardZone)
        end
    elseif params.card.hasTag("Unique") then
        discardZone = getObjectFromGUID(uniquePowerDiscardZone)
    else
        -- Discard unknown cards to the unique power discard
        discardZone = getObjectFromGUID(uniquePowerDiscardZone)
    end

    if params.color then
        Player[params.color].broadcast("Forgot "..params.card.getName())
    end

    -- HACK work around issue where setPositionSmooth doesn't move object from hand to non hand
    local inHand = isObjectInHand(params.card)
    if inHand then
        params.card.use_hands = false
        local position = params.card.getPosition()
        position.y = 0
        params.card.setPosition(position)
    end
    Wait.frames(function()
        params.card.setPositionSmooth(discardZone.getPosition() + Vector(0,params.discardHeight,0), false, true)
        params.card.setRotation(Vector(0, 180, 0))
        if inHand then
            Wait.condition(function() params.card.use_hands = true end, function() return not params.card.isSmoothMoving() end)
        end
    end, 1)
end
function isObjectInHand(obj)
    for _,zone in pairs(obj.getZones()) do
        if zone.type == "Hand" then
            return true
        end
    end
    return false
end

function getPowerZoneObjects(handP)
    local hits = upCastPosSizRot(
        handOffset + handP, -- pos
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
    local function bncBlightCardOptions(bncDeck, callback)
        Wait.condition(function()
            local banList = SetupChecker.getTable("banList")["Blight Cards"]
            local bncBlightSetup = 0
            if SetupChecker.getVar("exploratoryAid") and not banList["Aid from Lesser Spirits"] and not banList["bf66eb"] then
                bncDeck.takeObject({
                    guid = "bf66eb",
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        Wait.frames(function()
                            bncDeck.putObject(temp)
                            bncDeck.shuffle()
                            cardsSetup = cardsSetup + 1
                            bncBlightSetup = bncBlightSetup + 1
                        end, 1)
                    end,
                })
            else
                cardsSetup = cardsSetup + 1
                bncBlightSetup = bncBlightSetup + 1
            end
            if not SetupChecker.getVar("optionalNatureIncarnateSetup") and not banList["Tipping Point"] and not banList["59e61e"] then
                local card = getObjectFromGUID("BnCBag").takeObject({
                    guid = "59e61e",
                    position = blightDeckZone.getPosition(),
                    rotation = {0,180,180},
                    smooth = false,
                })
                bncDeck.putObject(card)
                bncDeck.shuffle()
            end
            if callback ~= nil then
                Wait.condition(function() callback() end, function() return bncBlightSetup == 1 end)
            end
        end, function() return not bncDeck.loading_custom end)
    end
    if SetupChecker.getVar("optionalBlightCard") then
        local blightDeck = blightDeckZone.getObjects()[1]
        blightDeck.shuffle()

        if expansions["Branch & Claw"] and SetupChecker.getVar("playtestExpansion") ~= "Branch & Claw" then
            bncBlightCardOptions(blightDeck)
        else
            cardsSetup = cardsSetup + 1
        end

        Wait.condition(function()
            local grabbedDeck = false
            if SetupChecker.getVar("playtestExpansion") == "Branch & Claw" then
                grabbedDeck = true
                SetupPlaytestDeck(blightDeckZone, "Blight Cards", SetupChecker.getVar("playtestBlight"), bncBlightCardOptions, function() grabBlightCard(true) end)
            end
            if not grabbedDeck then
                SetupPlaytestDeck(blightDeckZone, "Blight Cards", SetupChecker.getVar("playtestBlight"), nil, function() grabBlightCard(true) end)
            end
        end, function() return cardsSetup == 1 end)
    else
        blightedIsland = true
    end
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return blightedIsland or (blightedIslandCard ~= nil and not blightedIslandCard.isSmoothMoving()) end)
    return 1
end
function grabBlightCard(start)
    local blightDeck = blightDeckZone.getObjects()[1]
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
    local blightDiscard = getObjectFromGUID("b18505").getPosition()
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
                        position = blightDiscard,
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
    blightedIslandCard.setRotationSmooth(Vector(0,180,180))
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
        local blightDiscard = getObjectFromGUID("b18505").getPosition()
        blightedIslandCard.setPositionSmooth(blightDiscard)
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
        Defeat({blight = true})
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
    for _,guid in pairs(SetupChecker.getVar("allScenarios")) do
        if guid == "" then
        elseif scenarioCard == nil or scenarioCard.guid ~= guid then
            getObjectFromGUID(guid).destruct()
        end
    end

    local pos = Vector(0.75, 0.11, -1.81)
    if scenarioCard ~= nil then
        scenarioCard.UI.hide(scenarioCard.getName())
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
    for _,guid in pairs(SetupChecker.getVar("allAdversaries")) do
        if guid == "" then
        elseif (adversaryCard == nil or adversaryCard.guid ~= guid) and (adversaryCard2 == nil or adversaryCard2.guid ~= guid) then
            getObjectFromGUID(guid).destruct()
        end
    end

    if adversaryCard ~= nil then
        adversaryCard.UI.hide(adversaryCard.getName())
        local targetScale = 1.71
        local currentScale = adversaryCard.getScale()[1]
        local scaleMult = (currentScale - targetScale)/10
        for i = 1, 10 do
            wt(0.02)
            adversaryCard.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
            if adversaryCard2 ~= nil then
                adversaryCard2.UI.hide(adversaryCard2.getName())
                adversaryCard2.setScale(Vector(currentScale-scaleMult*i,1.00,currentScale-scaleMult*i))
            end
        end
    end

    local pos = Vector(-0.75, 0.11, -1.81)
    if adversaryCard2 ~= nil then
        adversaryCard.setLock(true)
        adversaryCard.setPositionSmooth(aidBoard.positionToWorld(pos + Vector(0, 0, -1.03)), false, true)
        adversaryCard2.setLock(true)
        adversaryCard2.setPositionSmooth(aidBoard.positionToWorld(pos), false, true)
    elseif adversaryCard ~= nil then
        adversaryCard.setLock(true)
        adversaryCard.setPositionSmooth(aidBoard.positionToWorld(pos), false, true)
    end

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
function adversaryUI()
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
        local deprecated = false
        if ui.one then
            UI.setAttribute("panelAdversaryLevel1","text","1) "..ui.one.name)
            if ui.one.tooltip then
                UI.setAttribute("panelAdversaryLevel1","tooltip",ui.one.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel1","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.two then
            UI.setAttribute("panelAdversaryLevel2","text","2) "..ui.two.name)
            if ui.two.tooltip then
                UI.setAttribute("panelAdversaryLevel2","tooltip",ui.two.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel2","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.three then
            UI.setAttribute("panelAdversaryLevel3","text","3) "..ui.three.name)
            if ui.three.tooltip then
                UI.setAttribute("panelAdversaryLevel3","tooltip",ui.three.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel3","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.four then
            UI.setAttribute("panelAdversaryLevel4","text","4) "..ui.four.name)
            if ui.four.tooltip then
                UI.setAttribute("panelAdversaryLevel4","tooltip",ui.four.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel4","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.five then
            UI.setAttribute("panelAdversaryLevel5","text","5) "..ui.five.name)
            if ui.five.tooltip then
                UI.setAttribute("panelAdversaryLevel5","tooltip",ui.five.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel5","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.six then
            UI.setAttribute("panelAdversaryLevel6","text","6) "..ui.six.name)
            if ui.six.tooltip then
                UI.setAttribute("panelAdversaryLevel6","tooltip",ui.six.tooltip)
            end
            UI.setAttribute("panelAdversaryLevel6","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if deprecated then
            print("AdversaryUI without effects table for Adversaries is now deprecated, please update code for "..adversaryCard.getName().." to maintain future compatibility with the mod")
        end
        local ravage = false
        local build = false
        local explore = false
        if ui.effects then
            for level,data in pairs(ui.effects) do
                local name = data.name
                if data.ravage then
                    name = name.."(R)"
                    ravage = true
                end
                if data.afterRavage then
                    name = name.."(AR)"
                    ravage = true
                end
                if data.build then
                    name = name.."(B)"
                    build = true
                end
                if data.afterBuild then
                    name = name.."(AB)"
                    build = true
                end
                if data.explore then
                    name = name.."(E)"
                    explore = true
                end
                if data.afterExplore then
                    name = name.."(AE)"
                    explore = true
                end
                UI.setAttribute("panelAdversaryLevel"..level,"text",level..") "..name)
                if data.tooltip then
                    UI.setAttribute("panelAdversaryLevel"..level,"tooltip",data.tooltip)
                end
                UI.setAttribute("panelAdversaryLevel"..level,"active","true")
                lineCount = lineCount + 1
            end
        end
        if ui.invader then
            if ui.invader.ravage then
                ravage = true
            end
            if ui.invader.build then
                build = true
            end
            if ui.invader.explore then
                explore = true
            end
            print("AdversaryUI with invader table for Adversaries is now deprecated, please update code for "..adversaryCard.getName().." to maintain future compatibility with the mod")
        end
        if ravage then
            UI.setAttribute("panelRavageOutline", "active", "true")
        end
        if build then
            UI.setAttribute("panelBuildOutline", "active", "true")
            UI.setAttribute("panelBuild2Outline", "active", "true")
        end
        if explore then
            UI.setAttribute("panelExploreOutline", "active", "true")
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
        local deprecated = false
        if ui.one then
            UI.setAttribute("panelAdversary2Level1","text","1) "..ui.one.name)
            if ui.one.tooltip then
                UI.setAttribute("panelAdversary2Level1","tooltip",ui.one.tooltip)
            end
            UI.setAttribute("panelAdversary2Level1","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.two then
            UI.setAttribute("panelAdversary2Level2","text","2) "..ui.two.name)
            if ui.two.tooltip then
                UI.setAttribute("panelAdversary2Level2","tooltip",ui.two.tooltip)
            end
            UI.setAttribute("panelAdversary2Level2","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.three then
            UI.setAttribute("panelAdversary2Level3","text","3) "..ui.three.name)
            if ui.three.tooltip then
                UI.setAttribute("panelAdversary2Level3","tooltip",ui.three.tooltip)
            end
            UI.setAttribute("panelAdversary2Level3","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.four then
            UI.setAttribute("panelAdversary2Level4","text","4) "..ui.four.name)
            if ui.four.tooltip then
                UI.setAttribute("panelAdversary2Level4","tooltip",ui.four.tooltip)
            end
            UI.setAttribute("panelAdversary2Level4","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.five then
            UI.setAttribute("panelAdversary2Level5","text","5) "..ui.five.name)
            if ui.five.tooltip then
                UI.setAttribute("panelAdversary2Level5","tooltip",ui.five.tooltip)
            end
            UI.setAttribute("panelAdversary2Level5","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if ui.six then
            UI.setAttribute("panelAdversary2Level6","text","6) "..ui.six.name)
            if ui.six.tooltip then
                UI.setAttribute("panelAdversary2Level6","tooltip",ui.six.tooltip)
            end
            UI.setAttribute("panelAdversary2Level6","active","true")
            lineCount = lineCount + 1
            deprecated = true
        end
        if deprecated then
            print("AdversaryUI without effects table for Adversaries is now deprecated, please update code for "..adversaryCard2.getName().." to maintain future compatibility with the mod")
        end
        local ravage = false
        local build = false
        local explore = false
        if ui.effects then
            for level,data in pairs(ui.effects) do
                local name = data.name
                if data.ravage then
                    name = name.."(R)"
                    ravage = true
                end
                if data.afterRavage then
                    name = name.."(AR)"
                    ravage = true
                end
                if data.build then
                    name = name.."(B)"
                    build = true
                end
                if data.afterBuild then
                    name = name.."(AB)"
                    build = true
                end
                if data.explore then
                    name = name.."(E)"
                    explore = true
                end
                if data.afterExplore then
                    name = name.."(AE)"
                    explore = true
                end
                UI.setAttribute("panelAdversary2Level"..level,"text",level..") "..name)
                if data.tooltip then
                    UI.setAttribute("panelAdversary2Level"..level,"tooltip",data.tooltip)
                end
                UI.setAttribute("panelAdversary2Level"..level,"active","true")
                lineCount = lineCount + 1
            end
        end
        if ui.invader then
            if ui.invader.ravage then
                ravage = true
            end
            if ui.invader.build then
                build = true
            end
            if ui.invader.explore then
                explore = true
            end
            print("AdversaryUI with invader table for Adversaries is now deprecated, please update code for "..adversaryCard2.getName().." to maintain future compatibility with the mod")
        end
        if ravage then
            UI.setAttribute("panelRavageOutline", "active", "true")
        end
        if build then
            UI.setAttribute("panelBuildOutline", "active", "true")
            UI.setAttribute("panelBuild2Outline", "active", "true")
        end
        if explore then
            UI.setAttribute("panelExploreOutline", "active", "true")
        end
    end
    local height = lineCount*20
    UI.setAttribute("panelAdversary","height",height)
    UI.setAttribute("panelInvader","offsetXY","0 "..305+5+height)
    UI.setAttribute("panelBlightFear","offsetXY","0 "..305+5+104+height)
end
function adversaryUISetup()
    SetupChecker.call("updateAdversaryUI", {callback = "adversaryUI"})
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
    local deck = eventDeckZone.getObjects()[1]
    if deck ~= nil then
        deck.shuffle()
    end

    local function bncEventOptions(bncDeck, callback)
        Wait.condition(function()
            local banList = SetupChecker.getTable("banList")["Event Cards"]
            local bncEventSetup = 0
            if not SetupChecker.getVar("optionalNatureIncarnateSetup") then
                if not banList["War Touches the Island's Shores"] and not banList["cfd4d1"] then
                    local card = getObjectFromGUID("BnCBag").takeObject({
                        guid = "cfd4d1",
                        position = eventDeckZone.getPosition(),
                        rotation = {0,180,180},
                        smooth = false,
                    })
                    bncDeck.putObject(card)
                    bncDeck.shuffle()
                end
                if not banList["Outpaced"] and not banList["6692e8"] then
                    local card = getObjectFromGUID("BnCBag").takeObject({
                        guid = "6692e8",
                        position = eventDeckZone.getPosition(),
                        rotation = {0,180,180},
                        smooth = false,
                    })
                    bncDeck.putObject(card)
                    bncDeck.shuffle()
                end
                if not banList["A Strange Madness Among the Beasts"] and not banList["0edac2"] then
                    local card = getObjectFromGUID("BnCBag").takeObject({
                        guid = "0edac2",
                        position = eventDeckZone.getPosition(),
                        rotation = {0,180,180},
                        smooth = false,
                    })
                    bncDeck.putObject(card)
                    bncDeck.shuffle()
                end
            end
            if SetupChecker.getVar("exploratoryWar") and not SetupChecker.getVar("optionalNatureIncarnateSetup") and not banList["War Touches the Island's Shores"] and not banList["cfd4d1"] then
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
            if callback ~= nil then
                Wait.condition(function() callback() end, function() return bncEventSetup == 1 end)
            end
        end, function() return not bncDeck.loading_custom end)
    end

    if events["Branch & Claw"] and SetupChecker.getVar("playtestExpansion") ~= "Branch & Claw" then
        bncEventOptions(deck)
    else
        cardsSetup = cardsSetup + 1
    end

    Wait.condition(function()
        local grabbedDeck = false
        if SetupChecker.getVar("playtestExpansion") == "Branch & Claw" then
            grabbedDeck = true
            if events["Branch & Claw"] then
                SetupPlaytestDeck(eventDeckZone, "Events", SetupChecker.getVar("playtestEvent"), bncEventOptions, function() stagesSetup = stagesSetup + 1 end)
            else
                stagesSetup = stagesSetup + 1
            end
        end
        if not grabbedDeck then
            SetupPlaytestDeck(eventDeckZone, "Events", SetupChecker.getVar("playtestEvent"), nil, function() stagesSetup = stagesSetup + 1 end)
        end
    end, function() return cardsSetup == 1 end)
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
    local maps = getMapTiles()
    if #maps == 0 then
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
        MapPlaceCustom(maps)
    end
    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return boardsSetup == numBoards end)
end
----- Post Setup Section
function PostSetup()
    aidBoard.call("setupGame")

    local postSetupSteps = 0
    local sequentialPostSetupSteps = 0

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
        -- TODO change bag image to exploratory (eventually)
        local spirit = getObjectFromGUID("fa9c2f")
        if spirit ~= nil then
            local foundSpirit = false
            for _, obj in pairs(spirit.getObjects()) do
                if obj.guid == "606f23" then
                    foundSpirit = true
                    break
                end
            end
            if foundSpirit then
                local obj = spirit.takeObject({
                    guid = "606f23",
                    position = spirit.getPosition() + Vector(0, 1, 0),
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        temp.setVar("setup", true)
                        Wait.frames(function()
                            spirit.putObject(temp)
                            postSetupSteps = postSetupSteps + 1
                        end, 1)
                    end,
                })
                obj.setVar("setup", true)
            else
                postSetupSteps = postSetupSteps + 1
            end
        else
            spirit = getObjectFromGUID("606f23")
            if spirit ~= nil then
                spirit = spirit.setState(2)
                spirit.setLock(true)
                Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return not spirit.loading_custom end)
            else
                postSetupSteps = postSetupSteps + 1
            end
        end
    else
        postSetupSteps = postSetupSteps + 1
    end

    if SetupChecker.getVar("exploratoryShadows") then
        -- TODO change bag image to exploratory (eventually)
        local spirit = getObjectFromGUID("45e367")
        if spirit ~= nil then
            local foundSpirit = false
            for _, obj in pairs(spirit.getObjects()) do
                if obj.guid == "bd2a4a" then
                    foundSpirit = true
                    break
                end
            end
            if foundSpirit then
                local obj = spirit.takeObject({
                    guid = "bd2a4a",
                    position = spirit.getPosition() + Vector(0, 1, 0),
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        temp.setVar("setup", true)
                        Wait.frames(function()
                            spirit.putObject(temp)
                            postSetupSteps = postSetupSteps + 1
                        end, 1)
                    end,
                })
                obj.setVar("setup", true)
            else
                postSetupSteps = postSetupSteps + 1
            end
        else
            spirit = getObjectFromGUID("bd2a4a")
            if spirit ~= nil then
                spirit = spirit.setState(2)
                spirit.setLock(true)
                Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return not spirit.loading_custom end)
            else
                postSetupSteps = postSetupSteps + 1
            end
        end
    else
        postSetupSteps = postSetupSteps + 1
    end

    if SetupChecker.getVar("exploratoryTrickster") then
        local spirit = getObjectFromGUID("472723")
        if spirit ~= nil then
            local cardsDone = 0
            local foundCard = false
            for _, obj in pairs(spirit.getObjects()) do
                if obj.guid == "8152de" then
                    foundCard = true
                    break
                end
            end
            if foundCard then
                spirit.takeObject({
                    guid = "8152de",
                    position = spirit.getPosition() + Vector(-2, 1, 0),
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        Wait.frames(function()
                            spirit.putObject(temp)
                            cardsDone = cardsDone + 1
                        end, 1)
                    end,
                })
            else
                cardsDone = cardsDone + 1
            end
            foundCard = false
            for _, obj in pairs(spirit.getObjects()) do
                if obj.guid == "78d741" then
                    foundCard = true
                    break
                end
            end
            if foundCard then
                spirit.takeObject({
                    guid = "78d741",
                    position = spirit.getPosition() + Vector(2, 1, 0),
                    callback_function = function(obj)
                        local temp = obj.setState(2)
                        Wait.frames(function()
                            spirit.putObject(temp)
                            cardsDone = cardsDone + 1
                        end, 1)
                    end,
                })
            else
                cardsDone = cardsDone + 1
            end
            Wait.condition(function() postSetupSteps = postSetupSteps + 1 end, function() return cardsDone == 2 end)
        else
            local card = getObjectFromGUID("8152de")
            card.setState(2)
            card = getObjectFromGUID("78d741")
            card.setState(2)
            postSetupSteps = postSetupSteps + 1
        end
    else
        postSetupSteps = postSetupSteps + 1
    end

    if adversaryCard ~= nil and adversaryCard.getVar("postSetup") then
        adversaryCard.call("PostSetup",{level = adversaryLevel, other = {exist = adversaryCard2 ~= nil, level = adversaryLevel2}})
        Wait.condition(function()
            postSetupSteps = postSetupSteps + 1
            sequentialPostSetupSteps = sequentialPostSetupSteps + 1
        end, function() return adversaryCard.getVar("postSetupComplete") end)
    else
        postSetupSteps = postSetupSteps + 1
        sequentialPostSetupSteps = sequentialPostSetupSteps + 1
    end
    Wait.condition(function()
        if adversaryCard2 ~= nil and adversaryCard2.getVar("postSetup") then
            adversaryCard2.call("PostSetup",{level = adversaryLevel2, other = {exist = adversaryCard ~= nil, level = adversaryLevel}})
            Wait.condition(function()
                postSetupSteps = postSetupSteps + 1
                sequentialPostSetupSteps = sequentialPostSetupSteps + 1
            end, function() return adversaryCard2.getVar("postSetupComplete") end)
        else
            postSetupSteps = postSetupSteps + 1
            sequentialPostSetupSteps = sequentialPostSetupSteps + 1
        end
    end, function() return sequentialPostSetupSteps == 1 end)
    Wait.condition(function()
        if scenarioCard ~= nil and scenarioCard.getVar("postSetup") then
            scenarioCard.call("PostSetup")
            Wait.condition(function()
                postSetupSteps = postSetupSteps + 1
                sequentialPostSetupSteps = sequentialPostSetupSteps + 1
            end, function() return scenarioCard.getVar("postSetupComplete") end)
        else
            postSetupSteps = postSetupSteps + 1
            sequentialPostSetupSteps = sequentialPostSetupSteps + 1
        end
    end, function() return sequentialPostSetupSteps == 2 end)
    Wait.condition(function()
        if secondWave ~= nil and secondWave.getVar("postSetup") then
            secondWave.call("PostSetup")
            Wait.condition(function()
                postSetupSteps = postSetupSteps + 1
                sequentialPostSetupSteps = sequentialPostSetupSteps + 1
            end, function() return secondWave.getVar("postSetupComplete") end)
        else
            postSetupSteps = postSetupSteps + 1
            sequentialPostSetupSteps = sequentialPostSetupSteps + 1
        end
    end, function() return sequentialPostSetupSteps == 3 end)

    Wait.condition(function()
        if not usingEvents() and usingSpiritTokens() then
        -- Setup up command cards last
            local invaderDeck = invaderDeckZone.getObjects()[1]
            local cards = invaderDeck.getObjects()
            local stageII = nil
            local stageIII = nil
            for _,card in pairs(cards) do
                local start,finish = string.find(card.lua_script,"cardInvaderStage=")
                if start ~= nil then
                    local stage = tonumber(string.sub(card.lua_script,finish+1,finish+1))
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
        else
            postSetupSteps = postSetupSteps + 1
        end
    end, function() return postSetupSteps == 7 end)

    -- HACK: trying to fix client desync issue
    for _,obj in pairs(getMapTiles()) do
        obj.setPosition(obj.getPosition()-Vector(0,0.01,0))
    end

    Wait.condition(function() stagesSetup = stagesSetup + 1 end, function() return postSetupSteps == 8 end)
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
function MapSetPosition(offset)
    offset = offset or 0.01
    for _,obj in pairs(getMapTiles()) do
        obj.setPosition(obj.getPosition()-Vector(0,offset,0))
    end
end
function MapSetPositionSmooth(offset)
    offset = offset or 0.01
    for _,obj in pairs(getMapTiles()) do
        obj.setPositionSmooth(obj.getPosition()-Vector(0,offset,0), false)
    end
end
function MapSetRotation(offset)
    offset = offset or 0.01
    for _,obj in pairs(getMapTiles()) do
        obj.setRotation(obj.getRotation()-Vector(0,offset,0))
    end
end
function MapSetRotationSmooth(offset)
    offset = offset or 0.01
    for _,obj in pairs(getMapTiles()) do
        obj.setRotationSmooth(obj.getRotation()-Vector(0,offset,0), false)
    end
end
function MapSetScale(offset)
    offset = offset or 0.01
    for _,obj in pairs(getMapTiles()) do
        obj.setScale(obj.getScale()-Vector(offset,0,0))
    end
end
----- Start Game Section
function StartGame()
    gamePaused = false
    gameStarted = true
    runSpiritSetup()
    enableUI()
    seaTile.registerCollisions(false)
    Wait.time(bargainCheck,2,-1)
    Wait.time(readyCheck,1,-1)
    enableVictoryDefeat()

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
function enableVictoryDefeat()
    if presenceTimer ~= nil then
        Wait.stop(presenceTimer)
        presenceTimer = nil
    end
    presenceTimer = Wait.time(checkPresenceLoss, 5, -1)
    if scenarioCard == nil or not scenarioCard.getVar("customVictory") then
        if victoryTimer ~= nil then
            Wait.stop(victoryTimer)
            victoryTimer = nil
        end
        victoryTimer = Wait.time(checkVictory, 5, -1)
    else
        scenarioCard.createButton({
            click_function = "Victory",
            function_owner = Global,
            label          = "Victory Achieved",
            position       = Vector(0.6, 1, -1.1),
            rotation       = Vector(0,0,0),
            scale          = Vector(0.2,0.2,0.2),
            width          = 2200,
            height         = 500,
            font_size      = 300,
        })
    end
    if scenarioCard ~= nil then
        if scenarioCard.getVar("automatedVictoryDefeat") then
            scenarioCard.call("AutomatedVictoryDefeat")
        end
        if scenarioCard.getVar("customLoss") then
            scenarioCard.createButton({
                click_function = "scenarioDefeat",
                function_owner = Global,
                label          = "Loss Condition",
                position       = Vector(0.6, 1, -1.1),
                rotation       = Vector(0,0,0),
                scale          = Vector(0.2,0.2,0.2),
                width          = 2000,
                height         = 500,
                font_size      = 300,
            })
        end
    end
    if adversaryCard ~= nil then
        if adversaryCard.getVar("automatedVictoryDefeat") then
            adversaryCard.call("AutomatedVictoryDefeat")
        end
        if adversaryCard.getVar("customLoss") then
            adversaryCard.createButton({
                click_function = "adversaryDefeat",
                function_owner = Global,
                label          = "Loss Condition",
                position       = Vector(-0.6, 1, -1.3),
                rotation       = Vector(0,0,0),
                scale          = Vector(0.2,0.2,0.2),
                width          = 2000,
                height         = 500,
                font_size      = 300,
            })
        end
    end
    if adversaryCard2 ~= nil then
        if adversaryCard2.getVar("automatedVictoryDefeat") then
            adversaryCard2.call("AutomatedVictoryDefeat")
        end
        if adversaryCard2.getVar("customLoss") then
            adversaryCard2.createButton({
                click_function = "adversaryDefeat",
                function_owner = Global,
                label          = "Loss Condition",
                position       = Vector(-0.6, 1, -1.3),
                rotation       = Vector(0,0,0),
                scale          = Vector(0.2,0.2,0.2),
                width          = 2000,
                height         = 500,
                font_size      = 300,
            })
        end
    end
end
function enableUI()
    Wait.frames(function()
        -- HACK: Temporary fix until TTS bug resolved https://tabletopsimulator.nolt.io/583
        UI.setXmlTable(UI.getXmlTable(), {})

        -- Need to wait for xml table to get updated
        Wait.frames(function()
            local colors = invertVisiTable({"Black", "Grey"})
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
    for color,data in pairs(selectedColors) do
        if data.zone then
            for _,obj in pairs(data.zone.getObjects()) do
                if obj.hasTag("Setup") and not obj.getVar("setupComplete") then
                    local success = obj.call("doSetup", {color=color})
                    obj.setVar("setupComplete", success)
                end
            end
        end
    end
end
------
function playerHasSpirit(params)
    return selectedColors[params.color] ~= nil
end
function addSpirit(params)
    return SetupChecker.call("addSpirit", params)
end
function pickSpirit(params)
    selectedColors[params.color] = {}
    SetupChecker.call("removeSpirit", params)
end
function removeSpirit(params)
    local seatGuid = playerTables[params.color].guid
    for index,guid in pairs(seatTables) do
        if guid == seatGuid then
            local playerReadyGuids = aidBoard.getTable("playerReadyGuids")
            if index <= #playerReadyGuids then
                playerReadyGuids[index].color = params.color
                aidBoard.setTable("playerReadyGuids", playerReadyGuids)
            end
            break
        end
    end

    selectedColors[params.color] = {
        ready = params.ready,
        counter = params.counter,
        elements = params.elements,
        defend = params.defend,
        isolate = params.isolate,
        zone = params.zone,
        paid = false,
        gained = false,
        bargain = 0,
        debt = 0,
    }
    updatePlayerArea(params.color)
end
function getEmptySeat()
    local coloredSeats = {}
    for color,obj in pairs(playerTables) do
        coloredSeats[obj.guid] = color
    end
    for _,guid in pairs(seatTables) do
        if coloredSeats[guid] then
            if not playerHasSpirit({color = coloredSeats[guid]}) then
                return coloredSeats[guid]
            end
        else
            local color
            for c,_ in pairs(Tints) do
                if not playerTables[c] then
                    color = c
                    break
                end
            end
            setupColor(getObjectFromGUID(guid), color)
            return color
        end
    end
    return nil
end
function getSeatCount()
    local count = 0
    for _,obj in pairs(seatTables) do
        if obj ~= nil then
            count = count + 1
        end
    end
    return count
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
    triggerChangePhase(true)
    turn = turn + 1
    UI.setAttribute("panelTurnOverTurn", "text", "Turn: "..turn)
    noFear = false
    for guid,_ in pairs(objectsToCleanup) do
        local obj = getObjectFromGUID(guid)
        if obj ~= nil then
            cleanupObject({obj = obj, fear = false, reason = "Removing"})
        end
        objectsToCleanup[guid] = nil
    end
    for _,object in pairs(upCast(seaTile, 0, 0.48)) do
        handlePiece(object, 0)
    end
    noHealInvader = false
    noHealDahan = false
    for color,data in pairs(selectedColors) do
        handlePlayer(color, data)
    end
    for _,object in pairs(getObjectsWithTag("Time Passes")) do
        object.call("timePasses")
    end

    broadcastToAll("Time Passes...", Color.White)
    local quote = quotes[math.random(#quotes)]
    wt(2)
    printToAll("\"" .. quote[1] .. "\"", Color.SoftBlue)
    wt(2)
    printToAll("- " .. quote[2], Color.SoftBlue)
    wt(2)
    broadcastToAll("Starting Turn "..turn, Color.White)
    enterSpiritPhase(nil)
    for color,_ in pairs(selectedColors) do
        Player[color].broadcast("Energy at start of Spirit Phase: "..getCurrentEnergy(color), Color.SoftYellow)
    end
    timePassing = false
    return 1
end
function handlePiece(object, offset)
    if object.hasTag("City") then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset, noHealInvader)
        end
    elseif object.hasTag("Town") then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset, noHealInvader)
        end
    elseif object.hasTag("Explorer") then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,180,0), offset, noHealInvader)
        end
    elseif object.hasTag("Dahan") then
        if object.getLock() == false then
            object = resetPiece(object, Vector(0,0,0), offset, noHealDahan)
        end
    elseif object.hasTag("Blight") then
        object = resetPiece(object, Vector(0,180,0), offset, false)
    elseif object.hasTag("Reminder Token") then
        if object.getLock() == false then
            object.destruct()
            object = nil
        end
    end
    return object
end
function rotationEqual(objectRotation, comparisonRotation, tolerance)
    if Vector.equals(objectRotation, comparisonRotation, tolerance) then
        return true
    elseif comparisonRotation.x == 0 and comparisonRotation.y ~= 0 and comparisonRotation.z ~= 0 and Vector.equals(objectRotation, Vector(360, comparisonRotation.y, comparisonRotation.z), tolerance) then
        return true
    elseif comparisonRotation.x == 0 and comparisonRotation.y == 0 and comparisonRotation.z ~= 0 and Vector.equals(objectRotation, Vector(360, 360, comparisonRotation.z), tolerance) then
        return true
    elseif comparisonRotation.x == 0 and comparisonRotation.y ~= 0 and comparisonRotation.z == 0 and Vector.equals(objectRotation, Vector(360, comparisonRotation.y, 360), tolerance) then
        return true
    elseif comparisonRotation.x == 0 and comparisonRotation.y == 0 and comparisonRotation.z == 0 and Vector.equals(objectRotation, Vector(360, 360, 360), tolerance) then
        return true
    elseif comparisonRotation.x ~= 0 and comparisonRotation.y == 0 and comparisonRotation.z ~= 0 and Vector.equals(objectRotation, Vector(comparisonRotation.x, 360, comparisonRotation.z), tolerance) then
        return true
    elseif comparisonRotation.x ~= 0 and comparisonRotation.y == 0 and comparisonRotation.z == 0 and Vector.equals(objectRotation, Vector(comparisonRotation.x, 360, 360), tolerance) then
        return true
    elseif comparisonRotation.x ~= 0 and comparisonRotation.y ~= 0 and comparisonRotation.z == 0 and Vector.equals(objectRotation, Vector(comparisonRotation.x, comparisonRotation.y, 360), tolerance) then
        return true
    else
        return false
    end
end
function resetPiece(object, rotation, offset, skip)
    local objOffset = 0
    local upsideDown = false
    local rot = object.getRotation()
    local flipRot = Vector(rotation.x, rotation.y, 180)
    local spunRot = Vector(rotation.x, rot.y, rotation.z)
    if not skip and object.getStateId() ~= -1 and object.getStateId() ~= 1 then
        objOffset = 1
    elseif rotationEqual(rot, flipRot, 1) then
        -- object upside down
        upsideDown = true
    elseif rotationEqual(rot, spunRot, 1) then
        -- object spun around
    else
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

    if upsideDown then
        local flipOffset = object.getBounds().offset.y*2
        object.setRotation(rotation)
        object.setPosition(object.getPosition() - Vector(0,flipOffset,0))
    elseif not skip and object.getStateId() ~= -1 and object.getStateId() ~= 1 then
        object.setRotation(rotation)
        object.setPositionSmooth(object.getPosition() + Vector(0,objOffset,0))
        object = object.setState(1)
    else
        object.setRotation(rotation)
        object.setPositionSmooth(object.getPosition() + Vector(0,objOffset,0))
    end
    return object
end
function handlePlayer(color, data)
    if data.zone then
        for _, obj in ipairs(data.zone.getObjects()) do
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
                -- Skip moving face down cards and those below spirit panel
                if not obj.is_face_down and obj.getPosition().z > data.zone.getPosition().z then
                    obj.deal(1, color, 2)
                end
            end
        end
    end

    if data.paid then
        selectedColors[color].zone.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", tooltip="Left click to pay energy for your cards"})
        data.paid = false
    end
    if data.gained then
        selectedColors[color].zone.editButton({index=2, label="Gain", click_function="gainEnergy", color="Red", tooltip="Left click to gain energy from presence track"})
        data.gained = false
    end
    if data.bargain > 0 then
        selectedColors[color].zone.editButton({index=4, label="Debt: "..data.bargain})
        data.debt = data.bargain
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
function PopulateSpawnPositions()
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

    for _,board in pairs(boards) do
        local piecesToPlace = board.getTable("pieceMap")
        local posToPlace = board.getTable("posMap")
        local count = 1
        local beastsIndex = 0
        if not board.hasTag("Thematic") then
            for i=1,#piecesToPlace do
                if #piecesToPlace[i] == 0 then
                    beastsIndex = i
                    break
                end
            end
        end
        for l,landTable in ipairs(posToPlace) do
            for i,pieceName in ipairs(piecesToPlace[l]) do
                place({name = pieceName, position = board.positionToWorld(posToPlace[l][i])})
            end
            local startIndex = #piecesToPlace[l]+1
            if not board.hasTag("Thematic") then
                if l == 2 then
                    place({name = "Disease", position = board.positionToWorld(posToPlace[l][startIndex])})
                    startIndex = startIndex + 1
                end
                if l == beastsIndex then
                    place({name = "Beasts", position = board.positionToWorld(posToPlace[l][startIndex])})
                    startIndex = startIndex + 1
                end
            end
            for i=startIndex,#landTable do
                local defend = place({name = "Defend Marker", position = board.positionToWorld(posToPlace[l][i])})
                local countCopy = count
                Wait.condition(function()
                    if countCopy ~= 1 then
                        defend.setState(countCopy)
                    end
                end, function() return not defend.isSmoothMoving() end)
                count = (count % 21) + 1
            end
        end
    end
end
function GenerateSpawnPositions()
    local output = GetSpawnPositions()
    local noteLines = {}
    for boardName,objsData in pairs(output) do
        table.insert(noteLines, boardName)
        for _,objData in pairs(objsData) do
            local name = objData.name
            if objData.quantity > 1 then
                name = name.." "..objData.quantity
            end
            local pos = objData.position
            table.insert(noteLines, name.." {\\n    x="..pos.x..", y="..pos.y..", z="..pos.z.."\\n}")
        end
        table.insert(noteLines, "")
    end
    Notes.addNotebookTab({
        title = "New Map Positions",
        body = table.concat(noteLines, "\n") .. "\n",
    })
end
function GetSpawnPositions()
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

    local output = {}
    for _,board in pairs(boards) do
        local boardTable = {}
        local hits = Physics.cast({
            origin = board.getPosition() + Vector(0, 0.45, 0),
            direction = Vector(0, 1, 0),
            type = 3,
            size = board.getBounds().size,
        })
        for _,hit in pairs(hits) do
            if not isIslandBoard({obj=hit.hit_object}) then
                local subHits = Physics.cast({
                    origin = hit.hit_object.getPosition() + Vector(0, 0.1, 0),
                    direction = Vector(0, -1, 0),
                    max_distance = 0.6,
                })
                local onBoard = false
                for _,subHit in pairs(subHits) do
                    if subHit.hit_object == board then
                        onBoard = true
                        break
                    end
                end

                if onBoard then
                    local name
                    if hit.hit_object.hasTag("Dahan") then
                        name = "Dahan"
                    elseif hit.hit_object.hasTag("Explorer") then
                        name = "Explorer"
                    elseif hit.hit_object.hasTag("Town") then
                        name = "Town"
                    elseif hit.hit_object.hasTag("City") then
                        name = "City"
                    else
                        name = hit.hit_object.getName()
                    end
                    if name == "Defend" then
                        name = name.."-"..hit.hit_object.getStateId()
                    end
                    local quantity = hit.hit_object.getQuantity()
                    if quantity == -1 then
                        quantity = 1
                    end
                    local pos = board.positionToLocal(hit.hit_object.getPosition())
                    pos.y = 0.7
                    table.insert(boardTable, {name = name, quantity = quantity, position = pos})
                end
            end
        end
        output[board.getName()] = boardTable
    end
    return output
end
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
    if params.norm then
        count = count + #getObjectsWithTag("Balanced")
    end
    if params.them then
        count = count + #getObjectsWithTag("Thematic")
    end
    return count
end

function getMapTiles()
    local mapTiles = {}
    for _,obj in pairs(upCast(seaTile, 0, 0.1)) do
        if isIslandBoard({obj=obj}) then
            table.insert(mapTiles,obj)
        end
    end
    return mapTiles
end

function MapPlaceCustom(maps)
    -- board type is guaranteed to either be thematic or normal, and there has to be at least one map tile in the table
    if maps[1].hasTag("Balanced") then
        boardLayout = "Custom"
    else
        boardLayout = "Custom Thematic"
    end
    SetupChecker.call("updateDifficulty")

    local rand = 0
    if SetupChecker.getVar("optionalExtraBoard") then
        if extraRandomBoard == nil then
            extraRandomBoard = math.random(1,#maps)
        end
        rand = extraRandomBoard
    end
    local optionalThematicRedo = SetupChecker.getVar("optionalThematicRedo")
    for i,map in pairs(maps) do
        if map.hasTag("Thematic") then
            if optionalThematicRedo and map.getStateId() == 1 then
                map = map.setState(2)
            elseif not optionalThematicRedo and map.getStateId() == 2 then
                map = map.setState(1)
            end
        end
        map.setLock(true)
        map.interactable = false
        Wait.condition(function() setupMap(map,i==rand) end, function() return not map.loading_custom end)

        if i == rand then
            printToAll("Board "..selectedBoards[i].." was chosen to be the extra board!", Color.SoftBlue)
        end
    end
end

function MapPlacen(boards)
    local rand = 0
    local BETaken = false
    local DFTaken = false
    local AGTaken = false
    local CHTaken = false
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
    local optionalThematicRedo = SetupChecker.getVar("optionalThematicRedo")
    for i, board in pairs(boards) do
        if isThematic() then
            local selectedBoardName = nil -- luacheck: ignore 311 (variable actually used)
            if selectedBoards[count] ~= nil then
                selectedBoardName = selectedBoards[count]
            else
                selectedBoardName = board.board
            end

            local boardObject = ThematicMapBag.takeObject({
                position = ThematicMapBag.getPosition() + Vector(0,-5,0),
                guid = themGuids[selectedBoardName],
                smooth = false,
                callback_function = function(obj)
                    if optionalThematicRedo then
                        obj = obj.setState(2)
                    end
                    BoardCallback(obj, board.pos, board.rot, i==rand, scaleOrigin)
                end,
            })

            if selectedBoards[count] == nil then
                table.insert(selectedBoards, boardObject.getName())
            end
            count = count + 1
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
                    elseif value.name == "A" or value.name == "G" then
                        if not AGTaken then
                            AGTaken = true
                            index = value.index
                            break
                        end
                    elseif value.name == "C" or value.name == "H" then
                        if not CHTaken then
                            CHTaken = true
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

            local boardObject = bag.takeObject({
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

        if i == rand then
            printToAll("Board "..selectedBoards[i].." was chosen to be the extra board!", Color.SoftBlue)
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

        local thematic = isThematic()
        if secondWave ~= nil and secondWave.getVar("mapSetup") then
            piecesToPlace = secondWave.call("MapSetup", {name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra, thematic = thematic})
        end
        if scenarioCard ~= nil and scenarioCard.getVar("mapSetup") then
            piecesToPlace = scenarioCard.call("MapSetup", {name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra, thematic = thematic})
        end
        -- supporting adversary setup should happen before primary
        if adversaryCard2 ~= nil and adversaryCard2.getVar("mapSetup") then
            piecesToPlace = adversaryCard2.call("MapSetup", {level = adversaryLevel2, name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra, thematic = thematic})
        end
        if adversaryCard ~= nil and adversaryCard.getVar("mapSetup") then
            piecesToPlace = adversaryCard.call("MapSetup", {level = adversaryLevel, name = map.getName(), pieces = piecesToPlace, original = originalPieces, extra = extra, thematic = thematic})
        end

        for l,landTable in ipairs(piecesToPlace) do
            for i,pieceName in ipairs(landTable) do
                if secondWave and pieceName == "Box Blight" then
                    pieceName = "Blight"
                end
                if posToPlace[l][i] == nil then
                    broadcastToAll("Board "..map.getName().." did not have room to place "..pieceName.." in land "..l, Color.Red)
                else
                    local obj = place({name = pieceName, position = map.positionToWorld(posToPlace[l][i])})
                    if obj == nil then
                        broadcastToAll("Board "..map.getName().." did not have room to place "..pieceName.." in land "..l, Color.Red)
                    end
                    coroutine.yield(0)
                end
            end
        end
        boardsSetup = boardsSetup + 1
        return 1
    end
    startLuaCoroutine(Global, "setupMapCo")
end

function place(params)
    if params.name == "CityS" then
        local result = place({name = "City", position = params.position, color = params.color})
        if usingSpiritTokens() then
            Wait.time(function() place({name = "Strife", position = params.position + Vector(0,1,0), color = params.color}) end, 0.5)
        end
        return result
    elseif params.name == "TownS" then
        local result = place({name = "Town", position = params.position, color = params.color})
        if usingSpiritTokens() then
            Wait.time(function() place({name = "Strife", position = params.position + Vector(0,1,0), color = params.color}) end, 0.5)
        end
        return result
    elseif params.name == "ExplorerS" then
        local result = place({name = "Explorer", position = params.position, color = params.color})
        if usingSpiritTokens() then
            Wait.time(function() place({name = "Strife", position = params.position + Vector(0,1,0), color = params.color}) end, 0.5)
        end
        return result
    end
    local temp = true
    if params.name == "Explorer" then
        if explorerBag.getCustomObject().type ~= 7 then
            if #explorerBag.getObjects() == 0 then
                broadcastToAll("There are no Explorers left to place", Color.SoftYellow)
                explorerBag.call("none")
                return nil
            end
        end
        temp = explorerBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "Town" then
        if townBag.getCustomObject().type ~= 7 then
            if #townBag.getObjects() == 0 then
                broadcastToAll("There are no Towns left to place", Color.SoftYellow)
                townBag.call("none")
                return nil
            end
        end
        temp = townBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "City" then
        if cityBag.getCustomObject().type ~= 7 then
            if #cityBag.getObjects() == 0 then
                broadcastToAll("There are no Cities left to place", Color.SoftYellow)
                cityBag.call("none")
                return nil
            end
        end
        temp = cityBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "Dahan" then
        if dahanBag.getCustomObject().type ~= 7 then
            if #dahanBag.getObjects() == 0 then
                broadcastToAll("There are no Dahan left to place", Color.SoftYellow)
                return nil
            end
        end
        temp = dahanBag.takeObject({position=params.position,rotation=Vector(0,0,0)})
    elseif params.name == "Blight" then
        if #blightBag.getObjects() == 0 then
            broadcastToAll("There is no Blight left to place", Color.SoftYellow)
            return nil
        end
        temp = blightBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "Box Blight" then
        temp = boxBlightBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "Strife" then
        if usingSpiritTokens() then
            temp = strifeBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        else
            return true
        end
    elseif params.name == "Beasts" then
        if usingSpiritTokens() then
            temp = beastsBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        else
            return true
        end
    elseif params.name == "Wilds" then
        if usingSpiritTokens() then
            temp = wildsBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        else
            return true
        end
    elseif params.name == "Disease" then
        if usingSpiritTokens() then
            temp = diseaseBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        else
            return true
        end
    elseif params.name == "Badlands" then
        if usingBadlands() then
            temp = badlandsBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        else
            return true
        end
    elseif params.name == "Vitality" then
        if usingVitality() then
            temp = vitalityBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        else
            return true
        end
    elseif params.name == "Defend Marker" then
        if params.color and selectedColors[params.color] and selectedColors[params.color].defend ~= nil then
            temp = selectedColors[params.color].defend.takeObject({position = params.position,rotation = Vector(0,180,0)})
        else
            temp = genericDefendBag.takeObject({position = params.position, rotation = Vector(0,180,0)})
        end
    elseif params.name == "Isolate Marker" then
        if params.color and selectedColors[params.color] and selectedColors[params.color].isolate ~= nil then
            temp = selectedColors[params.color].isolate.takeObject({position = params.position,rotation = Vector(0,180,0)})
        else
            return nil
        end
    elseif params.name == "1 Energy" then
        temp = oneEnergyBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "3 Energy" then
        temp = threeEnergyBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "Speed Token" then
        temp = speedBag.takeObject({position=params.position,rotation=Vector(0,180,0)})
    elseif params.name == "Scenario Marker" then
        local bag = getObjectFromGUID("8d6e46")
        if bag ~= nil then
            temp = bag.takeObject({position=params.position,rotation=Vector(0,180,0)})
        else
            return nil
        end
    end
    if params.color then
        local dropColor = params.color
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
    return temp
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
    "Defend Marker",
    "Isolate Marker",
    "1 Energy",
    "3 Energy",
    "Box Blight",
    "Speed Token",
    "Vitality",
}

function DropPiece(piece, cursorLocation, droppingPlayerColor)
    if not gameStarted or gamePaused then
        return
    end
    place({name = piece, position = cursorLocation + Vector(0,2,0), color = droppingPlayerColor})
end

function cleanupObject(params)
    if params.obj.isDestroyed() then
        return
    end

    local bag = nil
    if params.obj.hasTag("Dahan") then
        params.obj.setRotation(Vector(0,0,0))
        bag = dahanBag
    elseif params.obj.hasTag("Explorer") then
        params.obj.setRotation(Vector(0,180,0))
        bag = explorerBag
    elseif params.obj.hasTag("Town") then
        params.obj.setRotation(Vector(0,180,0))
        bag = townBag
        if params.fear and not noFear then
            aidBoard.call("addFear", {color = params.color, reason = params.reason})
        end
    elseif params.obj.hasTag("City") then
        params.obj.setRotation(Vector(0,180,0))
        bag = cityBag
        if params.fear and not noFear then
            aidBoard.call("addFear", {color = params.color, reason = params.reason})
            aidBoard.call("addFear", {color = params.color, reason = params.reason})
        end
    elseif params.obj.hasTag("Blight") then
        params.obj.setRotation(Vector(0,180,0))
        if params.remove then
            bag = boxBlightBag
        else
            bag = returnBlightBag
        end
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
    elseif params.obj.getName() == "Vitality" then
        params.obj.setRotation(Vector(0,180,0))
        bag = vitalityBag
    else
        if not params.obj.hasTag("Destroy") then
            return
        end
    end

    if bag == nil or bag.type == "Infinite" then
        params.obj.destruct()
    else
        params.obj.highlightOff()
        if params.obj.getStateId() ~= -1 and params.obj.getStateId() ~= 1 then
            params.obj = params.obj.setState(1)
        end
        local quantity = params.obj.getQuantity()
        if quantity > 1 then
            for _ = 1,quantity do
                bag.putObject(params.obj.takeObject({}))
            end
        else
            bag.putObject(params.obj)
        end
    end
end
----
function getSpirit(params)
    for _,data in pairs(selectedColors) do
        if data.zone then
            for _,object in pairs(data.zone.getObjects()) do
                if object.hasTag("Spirit") and object.getName() == params.name then
                    return object
                end
            end
        end
    end
    return nil
end
function getSpiritColor(params)
    for color,data in pairs(selectedColors) do
        if data.zone then
            for _,object in pairs(data.zone.getObjects()) do
                if object.hasTag("Spirit") and object.getName() == params.name then
                    return color
                end
            end
        end
    end
    return nil
end
function checkPresenceLoss()
    -- Wait until after initial advance invader cards since presence should be on island by then
    if not setupCompleted then
        return
    end

    local colors = {}
    for color,_ in pairs(selectedColors) do
        colors[color] = false
    end

    for _,obj in pairs(getObjectsWithTag("Presence")) do
        -- Presence is not in player area
        if #obj.getZones() == 0 then
            local color = string.sub(obj.getName(),1,-12)
            if colors[color] == nil then
                color = getSpiritColor({name = obj.getDescription()})
            end
            -- Color does not already have presence on island
            if color ~= nil and not colors[color] then
                -- Presence is currently being moved, count as being on island for now
                if obj.held_by_color or not obj.getVelocity():equals(Vector(0, 0, 0)) then
                    colors[color] = true
                else
                    local hits = Physics.cast({
                        origin = obj.getPosition(),
                        direction = Vector(0,-1,0),
                        max_distance = 1,
                        --debug = true,
                    })
                    for _,v in pairs(hits) do
                        if v.hit_object ~= obj and isIslandBoard({obj=v.hit_object}) then
                            colors[color] = true
                            break
                        end
                    end
                end
            end
        end
    end

    local presenceLoss = false
    for color,onIsland in pairs(colors) do
        if not onIsland then
            if selectedColors[color].zone then
                for _,obj in ipairs(selectedColors[color].zone.getObjects()) do
                    if obj.hasTag("Spirit") then
                        if presenceTimer ~= nil then
                            Wait.stop(presenceTimer)
                            presenceTimer = nil
                        end
                        Defeat({presence = obj.getName()})
                        presenceLoss = true
                        break
                    end
                end
                if presenceLoss then
                    break
                end
            end
        end
    end
end
function scenarioDefeat(scenario)
    scenario.clearButtons()
    Defeat({scenario = scenario.getName()})
end
function adversaryDefeat(adversary)
    adversary.clearButtons()
    Defeat({adversary = adversary.getName()})
end
function Defeat(params)
    if checkVictory(true) then
        if victoryTimer ~= nil then
            Wait.stop(victoryTimer)
            victoryTimer = nil
        end
        params.sacrifice = true
    end
    if params.sacrifice then
        broadcastToAll("Sacrifice Victory!", Color.SoftYellow)
    elseif params.adversary then
        broadcastToAll(params.adversary.." wins via Additional Loss Condition!", Color.SoftYellow)
    elseif params.scenario then
        broadcastToAll("Invaders win via "..params.scenario.." Additional Loss Condition!", Color.SoftYellow)
    elseif params.blight then
        broadcastToAll("Invaders win via the Blight Loss Condition!", Color.SoftYellow)
    elseif params.invader then
        broadcastToAll("Invaders win via the Invader Card Loss Condition!", Color.SoftYellow)
    elseif params.presence then
        broadcastToAll("Invaders win via the Destroyed Presence Loss Condition!", Color.SoftYellow)
    else
        broadcastToAll("Invaders win via Unknown Loss Condition!", Color.SoftYellow)
    end
    loss = params
    showGameOver()
end
function checkVictory(returnOnly)
    if scenarioCard ~= nil and scenarioCard.getVar("customVictory") then
        return false
    end
    local victory = false

    local invaderTierLeft = 0
    for _,bag in pairs(getObjectsWithTag("Counting Bag")) do
        for _,obj in pairs(bag.getObjects()) do
            for _,tag in pairs(obj.tags) do
                if tag == "City" then
                    invaderTierLeft = 3
                    break
                elseif tag == "Town" then
                    invaderTierLeft = 2
                    break
                elseif tag == "Explorer" then
                    invaderTierLeft = 1
                    break
                end
            end
            if invaderTierLeft == 3 then
                break
            end
        end
        if invaderTierLeft == 3 then
            break
        end
    end

    if #getObjectsWithTag("City") == 0 and invaderTierLeft < 3 then
        if terrorLevel == 3 then
            victory = true
        elseif #getObjectsWithTag("Town") == 0 and invaderTierLeft < 2 then
            if terrorLevel == 2 then
                victory = true
            elseif #getObjectsWithTag("Explorer") == 0 and invaderTierLeft < 1 then
                victory = true
            end
        end
    end
    if victory and not returnOnly then
        Victory()
    end
    return victory
end
function Victory()
    if victoryTimer ~= nil then
        Wait.stop(victoryTimer)
        victoryTimer = nil
    end
    if terrorLevel == 4 then
        broadcastToAll("Fear Victory Achieved!", Color.SoftYellow)
    elseif terrorLevel == 3 then
        broadcastToAll("Terror Level III Victory Achieved!", Color.SoftYellow)
    elseif terrorLevel == 2 then
        broadcastToAll("Terror Level II Victory Achieved!", Color.SoftYellow)
    else
        broadcastToAll("Terror Level I Victory Achieved!", Color.SoftYellow)
    end

    if loss ~= nil then
        loss.sacrifice = true
    end
    showGameOver()
end
function showGameOver()
    if UI.getAttribute("panelUIGameOver", "active") == "false" then
        UI.setAttribute("panelUIGameOver","active","true")
        UI.setAttribute("panelUI","height", UI.getAttribute("panelUI", "height") + 30)
    end

    refreshGameOver()

    if SetupChecker.getVar("optionalGameResults") then
        local colors = invertVisiTable({"Black", "Grey"})
        setVisiTable("panelGameOver", colors)
    end
end
function refreshGameOver()
    local lines = 8

    local headerText
    if loss then
        headerText = "Defeat - "
        if loss.sacrifice then
            headerText = "Sacrifice Victory"
        elseif loss.adversary then
            headerText = headerText..loss.adversary.." Loss Condition"
        elseif loss.scenario then
            headerText = headerText..loss.scenario.." Loss Condition"
        elseif loss.blight then
            headerText = headerText.."Blight Loss Condition"
        elseif loss.invader then
            headerText = headerText.."Invader Deck Loss Condition"
        elseif loss.presence then
            headerText = headerText.."Destroyed Presence Loss Condition"
        else
            headerText = headerText.."Unknown Loss Condition"
        end
    else
        headerText = "Victory - "
        if terrorLevel == 4 then
            headerText = headerText.."Fear"
        elseif terrorLevel == 3 then
            headerText = headerText.."Terror Level III"
        elseif terrorLevel == 2 then
            headerText = headerText.."Terror Level II"
        else
            headerText = headerText.."Terror Level I"
        end
    end
    UI.setAttribute("panelGameOverHeader", "text", headerText)

    local spiritCount = 0
    for _,data in pairs(selectedColors) do
        if data.zone then
            for _,obj in ipairs(data.zone.getObjects()) do
                if obj.hasTag("Spirit") then
                    spiritCount = spiritCount + 1
                    UI.setAttribute("panelGameOverSpirit"..spiritCount, "text", obj.getName())
                    if spiritCount % 2 == 1 then
                        UI.setAttribute("panelGameOverSpiritRow"..(spiritCount + 1)/2, "active", true)
                        lines = lines + 1
                    end
                end
            end
        end
    end

    local adversaryOrScenario = false
    local secondAdversaryOrSecondWave = false
    if adversaryCard ~= nil then
        UI.setAttribute("panelGameOverLeading", "text", adversaryCard.getName().." "..adversaryLevel)
        adversaryOrScenario = true
    else
        UI.setAttribute("panelGameOverLeadingHeader", "text", "")
    end
    if adversaryCard2 ~= nil then
        UI.setAttribute("panelGameOverSupporting", "text", adversaryCard2.getName().." "..adversaryLevel2)
        secondAdversaryOrSecondWave = true
    else
        UI.setAttribute("panelGameOverSupportingHeader", "text", "")
    end
    if scenarioCard ~= nil then
        UI.setAttribute("panelGameOverScenario", "text", scenarioCard.getName())
        adversaryOrScenario = true
    end
    if secondWave ~= nil then
        UI.setAttribute("panelGameOverSecondWave", "text", "Wave "..wave)
        secondAdversaryOrSecondWave = true
    end
    if adversaryOrScenario then
        UI.setAttribute("panelGameOverAdversaryScenario", "active", true)
        lines = lines + 1
    end
    if secondAdversaryOrSecondWave then
        UI.setAttribute("panelGameOverSupportSecondWave", "active", true)
        lines = lines + 1
    end

    local dahan = #getObjectsWithTag("Dahan")
    local blight = 0
    local blightObjs = getObjectsWithTag("Blight")
    for _,obj in pairs(blightObjs) do
        local quantity = obj.getQuantity()
        if quantity == -1 then
            blight = blight + 1
        else
            blight = blight + quantity
        end
    end
    local deck = aidBoard.call("countDeck")
    local cards = aidBoard.getVar("numCards")
    local discard = aidBoard.call("countDiscard")

    local phase = ""
    if currentPhase == 1 then
        phase = "Spirit"
    elseif currentPhase == 2 then
        phase = "Fast"
    elseif currentPhase == 3 then
        phase = "Invader"
    elseif currentPhase == 4 then
        phase = "Slow"
    end

    UI.setAttribute("panelGameOverDifficulty", "text", difficulty)
    UI.setAttribute("panelGameOverTurn", "text", turn)
    UI.setAttribute("panelGameOverPhase", "text", phase)
    UI.setAttribute("panelGameOverDeck", "text", deck)
    UI.setAttribute("panelGameOverFaceup", "text", cards)
    UI.setAttribute("panelGameOverDiscard", "text", discard)

    local explorers = #getObjectsWithTag("Explorer")
    local towns = #getObjectsWithTag("Town")
    local cities = #getObjectsWithTag("City")

    for _,bag in pairs(getObjectsWithTag("Counting Bag")) do
        for _,obj in pairs(bag.getObjects()) do
            for _,tag in pairs(obj.tags) do
                if tag == "City" then
                    cities = cities + 1
                    break
                elseif tag == "Town" then
                    towns = towns + 1
                    break
                elseif tag == "Explorer" then
                    explorers = explorers + 1
                    break
                elseif tag == "Dahan" then
                    dahan = dahan + 1
                    break
                end
            end
        end
    end

    UI.setAttribute("panelGameOverExplorer", "text", explorers)
    UI.setAttribute("panelGameOverTown", "text", towns)
    UI.setAttribute("panelGameOverCity", "text", cities)
    UI.setAttribute("panelGameOverBlight", "text", blight)
    UI.setAttribute("panelGameOverDahan", "text", dahan)

    local score = getScore(dahan, blight, deck, cards, discard)
    local scoreText
    if loss then
        if loss.sacrifice then
            scoreText = score[1] - 10
        else
            scoreText = score[2]
        end
    else
        scoreText = score[1]
    end
    UI.setAttribute("panelGameOverScore", "text", scoreText)

    if recorder ~= nil then
        UI.setAttributes("panelGameOverRecord", {active = "true", tooltip = recorder.getDescription()})
    end

    UI.setAttribute("panelGameOver", "height", 80 * lines)
end
function sacrificeGameOver()
    if loss then
        loss.sacrifice = true
    else
        loss = {sacrifice = true}
    end
    refreshGameOver()
end
function resetGameOver()
    setVisiTable("panelGameOver", {})
    loss = nil
    enableVictoryDefeat()
end
function hideGameOver(player)
    toggleUI("panelGameOver", player.color, true)
end
function toggleGameOver(player)
    local colorEnabled = getCurrentState("panelGameOver", player.color)
    toggleUI("panelGameOver", player.color, colorEnabled)
    if not colorEnabled then
        refreshGameOver()
    end
end
function RecordGame()
    recorder.call("Record", {loss = loss})
    UI.setAttribute("panelGameOverRecord", "active", "false")
end
function getScore(dahan, blight, deck, cards, discard)
    dahan = math.floor(dahan / numBoards)
    blight = math.floor(blight / numBoards)

    local win = math.floor(5 * difficulty) + 10 + 2 * deck + dahan - blight
    local lose = math.floor(2 * difficulty) + cards + discard + dahan - blight
    return {win, lose}
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
                v.setVar("reload", true)
                v = v.reload()
                v.setVar("reload", true)
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
        size         = obj.getBounds().size,
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
        origin = obj.getBounds().center,
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
    local obj = playerTables[color]
    if obj then
        setupPlayerArea({obj = obj})
        return true
    end
    return false
end
-- Updates all player areas.
function updateAllPlayerAreas()
    for _,obj in pairs(playerTables) do
        setupPlayerArea({obj = obj})
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
    local timer = params.obj.getVar("timer")  -- May be nil
    local initialized = params.obj.getVar("initialized")
    local color
    for k, v in pairs(playerTables) do
        if v.guid == params.obj.guid then
            color = k
            break
        end
    end
    local selected = selectedColors[color]

    if not initialized and selected then
        params.obj.setVar("initialized", true)
        -- Energy Cost (button index 0)
        selected.zone.createButton({
            label="Energy Cost: ?", click_function="nullFunc",
            position={0.05,0,0.08}, rotation={0,180,0}, scale={1/22,0,1/23},
            height=0, width=0, font_color={1,1,1}, font_size=500
        })
        -- Pay Energy (button index 1)
        selected.zone.createButton({
            label="", click_function="nullFunc",
            position={-0.19,0,0.08}, rotation={0,180,0}, scale={1/22,0,1/23},
            height=0, width=0, font_color="White", font_size=500,
        })
        -- Gain Energy (button index 2)
        selected.zone.createButton({
            label="", click_function="nullFunc",
            position={-0.19,0,0.02}, rotation={0,180,0}, scale={1/22,0,1/23},
            height=0, width=0, font_color="White", font_size=500,
        })
        selected.zone.createButton({
            label="Reclaim All", click_function="reclaimAll",
            position={0.05,0,0.02}, rotation={0,180,0}, scale={1/22,0,1/23},
            height=600, width=2600, font_size=500,
        })
        -- Bargain Debt (button index 4)
        selected.zone.createButton({
            label="", click_function="nullFunc",
            position={0.43,0,0.08}, rotation={0,180,0}, scale={1/22,0,1/23},
            height=0, width=0, font_color="White", font_size=500,
        })
        -- Bargain Pay (button index 5)
        selected.zone.createButton({
            label="", click_function="nullFunc",
            position={0.43,0,0.02}, rotation={0,180,0}, scale={1/22,0,1/23},
            height=0, width=0, font_color="White", font_size=500,
        })
        for i,bag in pairs(selected.elements) do
            if i == 9 then break end
            bag.createButton({
                label="?", click_function="nullFunc",
                position={0,0.1,1.9}, rotation={0,0,0},
                height=0, width=0, font_color={1,1,1}, font_size=800
            })
        end
        -- Other buttons to follow/be fixed later.
    elseif initialized and not selected then
        params.obj.setVar("initialized", false)
        params.obj.clearButtons()
    end

    if not selected then
        if timer then  -- No spirit, but a running timer.
            Wait.stop(timer)
            timer = nil
            params.obj.setVar("timer", timer)
        end
        return
    end

    if selected.paid then
        selected.zone.editButton({index=1, label="Paid", click_function="refundEnergy", color="Green", height=600, width=1550, tooltip="Right click to refund energy for your cards"})
    else
        selected.zone.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", height=600, width=1550, tooltip="Left click to pay energy for your cards"})
    end
    if selected.gained then
        selected.zone.editButton({index=2, label="Gained", click_function="returnEnergy", color="Green", height=600, width=1550, tooltip="Right click to return energy from presence track"})
    else
        selected.zone.editButton({index=2, label="Gain", click_function="gainEnergy", color="Red", height=600, width=1550, tooltip="Left click to gain energy from presence track"})
    end
    if selected.debt > 0 then
        selected.zone.editButton({index=4, label="Debt: "..selected.debt})
        selected.zone.editButton({index=5, label="Pay 1", click_function="payDebt", color="Red", height=600, width=1550, tooltip="Left click to pay 1 energy to Bargain Debt. Right click to refund 1 energy from Bargain Debt."})
    else
        selected.zone.editButton({index=4, label=""})
        selected.zone.editButton({index=5, label="", click_function="nullFunc", color="White", height=0, width=0, tooltip=""})
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
                    position = vec + Vector(0, 0.22, 0),
                    rotation = Vector(90, 180, 0):sub(object.getRotation():sub(Vector(0, 180, 0))),
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
                    local scale
                    if aspect.getRotation():equals(Vector(0, 180, 0)) or aspect.getRotation():equals(Vector(0, 0, 0)) then
                        scale = {0.12, 0.24, 1}
                    else
                        scale = {0.24, 0.12, 1}
                    end
                    addThresholdDecals(aspect, elements, thresholds, scale)
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
        if selected.zone then
            for _,entry in ipairs(selected.zone.getObjects()) do
                if entry.hasTag("Spirit") then
                    local trackElements = calculateTrackElements(entry)
                    elements:add(trackElements)
                    nonTokenElements:add(trackElements)
                    spirit = entry
                elseif entry.type == "Card" then
                    if entry.hasTag("Aspect") and not entry.is_face_down then
                        table.insert(aspects, entry)
                    end
                    --Ignore if no elements entry or if face down
                    if entry.getVar("elements") ~= nil and not entry.is_face_down then
                        if entry.hasTag("Aspect") then -- Count elements on aspects regardless of location or locking
                            local cardElements = entry.getVar("elements")
                            elements:add(cardElements)
                            nonTokenElements:add(cardElements)
                        elseif entry.getPosition().z > selected.zone.getPosition().z then -- Skip counting power cards below spirit panel
                            -- Skip counting locked card's elements (exploratory Aid from Lesser Spirits)
                            if not entry.getLock() or not (blightedIsland and blightedIslandCard ~= nil and blightedIslandCard.guid == "ad5b9a") then
                                local cardElements = entry.getVar("elements")
                                elements:add(cardElements)
                                nonTokenElements:add(cardElements)
                            end
                            energy = energy + powerCost(entry)
                        end
                    end
                    if not entry.hasTag("Aspect") and entry.getTable("thresholds") ~= nil then
                        table.insert(thresholdCards, entry)
                    end
                elseif entry.type == "Generic" then
                    local tokenCounts = entry.getVar("elements")
                    if tokenCounts ~= nil then
                        elements:add(tokenCounts)
                    end
                end
            end
        end
        if spirit ~= nil then
            checkThresholds(spirit, aspects, thresholdCards, elements)
        end
        --Updates the number display
        selected.zone.editButton({index=0, label="Energy Cost: "..energy})
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
    params.obj.setVar("timer", timer)
end
function reclaimAll(target_obj, source_color)
    if not gameStarted then
        return
    end

    local target_color = nil
    for color,data in pairs(selectedColors) do
        if data.zone == target_obj then
            target_color = color
            break
        end
    end
    if target_color == nil then
        return
    end

    if target_color ~= source_color and Player[target_color].seated then
        return
    end

    for _,obj in pairs(Player[target_color].getHandObjects(2)) do
        if isPowerCard({card=obj}) then
            obj.deal(1, target_color, 1)
        end
    end
end
function payDebt(target_obj, source_color, alt_click)
    local target_color = nil
    for color,data in pairs(selectedColors) do
        if data.zone == target_obj then
            target_color = color
            break
        end
    end
    if target_color == nil then
        return
    end

    if target_color ~= source_color and Player[target_color].seated then
        return
    end

    if alt_click then
        if selectedColors[target_color].bargain <= selectedColors[target_color].debt then
            Player[source_color].broadcast("Spirit has no paid bargain debt!", Color.SoftYellow)
            return
        end
        if not giveEnergy({color = target_color, energy = 1, ignoreDebt = true}) then
            return
        end
        selectedColors[target_color].debt = selectedColors[target_color].debt + 1
    else
        if selectedColors[target_color].debt <= 0 then
            Player[source_color].broadcast("Spirit has no remaining bargain debt!", Color.SoftYellow)
            return
        end
        if not giveEnergy({color = target_color, energy = -1, ignoreDebt = true}) then
            Player[source_color].broadcast("Spirit has no energy to pay debt!", Color.SoftYellow)
            return
        end
        selectedColors[target_color].debt = selectedColors[target_color].debt - 1
    end

    selectedColors[target_color].zone.editButton({index = 4, label = "Debt: "..selectedColors[target_color].debt})
end
function giveEnergy(params)
    local success = updateEnergyCounter(params.color, true, params.energy, params.ignoreDebt)
    if not success then
        success = refundEnergyTokens(params.color, params.energy, params.ignoreDebt)
    end
    return success
end
function gainEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif alt_click then
        return
    end

    local target_color = nil
    for color,data in pairs(selectedColors) do
        if data.zone == target_obj then
            target_color = color
            break
        end
    end
    if target_color == nil then
        return
    end
    if target_color ~= source_color and Player[target_color].seated then
        return
    end

    if selectedColors[target_color].zone then
        for _,obj in ipairs(selectedColors[target_color].zone.getObjects()) do
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
                    Player[target_color].broadcast("Spirit does not support automatic energy gain", Color.SoftYellow)
                else
                    local refunded = updateEnergyCounter(target_color, true, energyTotal, false)
                    if not refunded then
                        refunded = refundEnergyTokens(target_color, energyTotal, false)
                    end
                    if refunded then
                        selectedColors[target_color].gained = true
                        selectedColors[target_color].zone.editButton({index=2, label="Gained", click_function="returnEnergy", color="Green", tooltip="Right click to return energy from presence track"})
                    else
                        Player[source_color].broadcast("Was unable to gain energy", Color.SoftYellow)
                    end
                end
                break
            end
        end
    end
end
function returnEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif not alt_click then
        return
    end

    local target_color = nil
    for color,data in pairs(selectedColors) do
        if data.zone == target_obj then
            target_color = color
            break
        end
    end
    if target_color == nil then
        return
    end
    if target_color ~= source_color and Player[target_color].seated then
        return
    end

    if selectedColors[target_color].zone then
        for _,obj in ipairs(selectedColors[target_color].zone.getObjects()) do
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
                    Player[target_color].broadcast("Spirit does not support automatic energy gain", Color.SoftYellow)
                else
                    local paid = updateEnergyCounter(target_color, false, energyTotal, false)
                    if not paid then
                        paid = payEnergyTokens(target_color, energyTotal, false)
                    end
                    if paid then
                        selectedColors[target_color].gained = false
                        selectedColors[target_color].zone.editButton({index=2, label="Gain", click_function="gainEnergy", color="Red", tooltip="Left click to gain energy from presence track"})
                    else
                        Player[source_color].broadcast("You don't have enough energy", Color.SoftYellow)
                    end
                end
                break
            end
        end
    end
end
function payEnergy(target_obj, source_color, alt_click)
    if not gameStarted then
        return
    elseif alt_click then
        return
    end

    local target_color = nil
    for color,data in pairs(selectedColors) do
        if data.zone == target_obj then
            target_color = color
            break
        end
    end
    if target_color == nil then
        return
    end
    if target_color ~= source_color and Player[target_color].seated then
        return
    end

    local paid = updateEnergyCounter(target_color, false, getEnergyLabel(target_color), true)
    if not paid then
        paid = payEnergyTokens(target_color, nil, true)
    end
    if paid then
        selectedColors[target_color].paid = true
        selectedColors[target_color].zone.editButton({index=1, label="Paid", click_function="refundEnergy", color="Green", tooltip="Right click to refund energy for your cards"})
    else
        Player[source_color].broadcast("You don't have enough energy", Color.SoftYellow)
    end
end
function updateEnergyCounter(color, refund, cost, ignoreDebt)
    if selectedColors[color].counter == nil or not selectedColors[color].counter.getLock() then
        return false
    end
    local energy = selectedColors[color].counter.getValue()
    if refund then
        cost = -cost
    end

    if not ignoreDebt then
        if cost > energy + (selectedColors[color].bargain - selectedColors[color].debt) then
            return false
        end
    else
        if cost > energy then
            return false
        end
    end

    if not ignoreDebt and selectedColors[color].bargain > 0 then
        if cost < 0 then
            -- gain energy
            if selectedColors[color].debt <= 0 then
                selectedColors[color].debt = selectedColors[color].debt + cost
            else
                if selectedColors[color].debt >= -cost then
                    selectedColors[color].debt = selectedColors[color].debt + cost
                    cost = 0
                else
                    local diff = selectedColors[color].debt
                    selectedColors[color].debt = selectedColors[color].debt + cost
                    cost = cost + diff
                end
            end
        elseif cost > 0 then
            -- ungain energy
            if selectedColors[color].debt < 0 then
                if selectedColors[color].debt <= -cost then
                    selectedColors[color].debt = selectedColors[color].debt + cost
                else
                    if selectedColors[color].bargain - selectedColors[color].debt >= cost then
                        selectedColors[color].debt = selectedColors[color].debt + cost
                        cost = cost - selectedColors[color].debt
                    else
                        selectedColors[color].debt = selectedColors[color].bargain
                        cost = cost - selectedColors[color].bargain
                    end
                end
            else
                if selectedColors[color].bargain - selectedColors[color].debt >= cost then
                    selectedColors[color].debt = selectedColors[color].debt + cost
                    cost = 0
                else
                    selectedColors[color].debt = selectedColors[color].bargain
                    cost = cost - selectedColors[color].bargain
                end
            end
        end
        local debt = selectedColors[color].debt
        if debt < 0 then
            debt = 0
        end
        selectedColors[color].zone.editButton({index=4, label="Debt: "..debt})
    end
    selectedColors[color].counter.setValue(energy - cost)
    return true
end
function payEnergyTokens(color, cost, ignoreDebt)
    if cost == nil then
        cost = getEnergyLabel(color)
    end
    local energy = 0
    local energyTokens = {{}, {}}
    local oneEnergyTotal = 0
    if selectedColors[color].zone then
        for _,obj in ipairs(selectedColors[color].zone.getObjects()) do
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
    end

    if not ignoreDebt then
        if cost > energy + (selectedColors[color].bargain - selectedColors[color].debt) then
            return false
        end
    else
        if cost > energy then
            return false
        end
    end

    if not ignoreDebt and selectedColors[color].bargain > 0 then
        if selectedColors[color].debt < 0 then
            if selectedColors[color].debt <= -cost then
                selectedColors[color].debt = selectedColors[color].debt + cost
            else
                if selectedColors[color].bargain - selectedColors[color].debt >= cost then
                    selectedColors[color].debt = selectedColors[color].debt + cost
                    cost = cost - selectedColors[color].debt
                else
                    selectedColors[color].debt = selectedColors[color].bargain
                    cost = cost - selectedColors[color].bargain
                end
            end
        else
            if selectedColors[color].bargain - selectedColors[color].debt >= cost then
                selectedColors[color].debt = selectedColors[color].debt + cost
                cost = 0
            else
                selectedColors[color].debt = selectedColors[color].bargain
                cost = cost - selectedColors[color].bargain
            end
        end
        local debt = selectedColors[color].debt
        if debt < 0 then
            debt = 0
        end
        selectedColors[color].zone.editButton({index=4, label="Debt: "..debt})
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
    -- Give change for 3 energy token
    if cost < 0 then
        refundEnergyTokens(color, -cost, true)
    end
    return true
end
function getEnergyLabel(color)
    local energy = selectedColors[color].zone.getButtons()[1].label
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

    local target_color = nil
    for color,data in pairs(selectedColors) do
        if data.zone == target_obj then
            target_color = color
            break
        end
    end
    if target_color == nil then
        return
    end
    if target_color ~= source_color and Player[target_color].seated then
        return
    end

    local refunded = updateEnergyCounter(target_color, true, getEnergyLabel(target_color), false)
    if not refunded then
        refunded = refundEnergyTokens(target_color, nil, false)
    end
    if refunded then
        selectedColors[target_color].paid = false
        selectedColors[target_color].zone.editButton({index=1, label="Pay", click_function="payEnergy", color="Red", tooltip="Left click to pay energy for your cards"})
    else
        Player[source_color].broadcast("Was unable to refund energy", Color.SoftYellow)
    end
end
function refundEnergyTokens(color, cost, ignoreDebt)
    if cost == nil then
        cost = getEnergyLabel(color)
    end
    if cost < 0 then
        return payEnergyTokens(color, -cost, ignoreDebt)
    end

    if not ignoreDebt and selectedColors[color].bargain > 0 then
        if selectedColors[color].debt <= 0 then
            selectedColors[color].debt = selectedColors[color].debt - cost
        else
            if selectedColors[color].debt >= cost then
                selectedColors[color].debt = selectedColors[color].debt - cost
                cost = 0
            else
                local diff = selectedColors[color].debt
                selectedColors[color].debt = selectedColors[color].debt - cost
                cost = cost - diff
            end
        end
        local debt = selectedColors[color].debt
        if debt < 0 then
            debt = 0
        end
        selectedColors[color].zone.editButton({index=4, label="Debt: "..debt})
    end

    while cost >= 3 do
        threeEnergyBag.takeObject({
            position = selectedColors[color].zone.getPosition()+Vector(-10,2,-5),
            rotation = Vector(0,180,0),
            smooth = false,
        })
        cost = cost - 3
    end
    while cost >= 1 do
        oneEnergyBag.takeObject({
            position = selectedColors[color].zone.getPosition()+Vector(-10,2,-3),
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
    if selectedColors[color].zone then
        for _,obj in ipairs(selectedColors[color].zone.getObjects()) do
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
    end
    return energy
end

function setupTableButtons()
    updateColorPickButtons()
    updateSwapButtons()
end
function setupColorPickButtons(obj, seat)
    local buttons = {}
    for color,_ in pairs(Tints) do
        if not seat or not playerTables[color] then
            local buttonColor = Color[color]:toHex(false)
            local textColor = fontColor(Color[color])
            local func = "pickColor"
            local text = "Pick "
            local fontSize = "44"
            local minWidth = "270"
            local visibility = ""
            if not seat then
                func = "swapColor"
                text = "Swap to "
                fontSize = "70"
                minWidth = "600"
                visibility = visiTableToString(invertVisiTable({"Black", "Grey"}))
            end
            table.insert(buttons, {
                tag = "Button",
                attributes = {
                    id = color,
                    onClick = "Global/"..func.."("..obj.guid..")",
                    colors = "#"..buttonColor.."|#"..buttonColor.."|#"..buttonColor.."|#"..buttonColor.."80",
                    textColor = "rgb("..textColor[1]..","..textColor[2]..","..textColor[3]..")",
                    text = text..color,
                    fontSize = fontSize,
                    minWidth = minWidth,
                    minHeight = "110",
                    visibility = visibility,
                },
                children = {},
            })
        else
            table.insert(buttons, {
                tag = "Text",
                attributes = {},
                children = {},
            })
        end
    end
    local tag = "GridLayout"
    if not seat then
        tag = "VerticalLayout"
    end
    local xml = {
        {
            tag = tag,
            attributes = {
                childForceExpandWidth = "false",
                childForceExpandHeight = "false",
                childAlignment = "MiddleCenter",
                spacing = "30",
                position = "0 0 -80",
                rotation = "0 0 180",
                constraint = "FixedColumnCount",
                cellSize = "270 110",
            },
            children = buttons,
        }
    }
    if seat then
        table.insert(xml, {
            tag = "Button",
            attributes = {
                onClick = "Global/swapPlace("..obj.guid..")",
                text = "Swap Place",
                fontSize = "44",
                position = "0 420 -80",
                rotation = "0 0 180",
                width = "270",
                height = "110",
                visibility = visiTableToString(invertVisiTable({"Black", "Grey"}))
            },
            children = {},
        })
    end
    obj.UI.setXmlTable(xml, {})
end
function pickColor(player, guid, color)
    setupColor(getObjectFromGUID(guid), color)
    player.changeColor(color)
end
function setupColor(table, color)
    playerTables[color] = table
    setupSwapButtons(table, { seated = true })
    updateColorPickButtons()

    SpawnHand({color = color, position = table.getPosition() + Vector(0, 3.29, -16.4)})
    SpawnHand({color = color, position = table.getPosition() + Vector(0, 3.29, -21.9)})

    local colorTint
    if Tints[color].Table then
        colorTint = Color.fromHex(Tints[color].Table)
    else
        colorTint = Color.fromHex(Tints[color].Presence)
    end
    table.setColorTint(colorTint)
end
function SpawnHand(params)
    spawnObjectData({
        data = {
            Name = "HandTrigger",
            FogColor = params.color,
            Transform = {
                posX = 0,
                posY = 0,
                posZ = 0,
                rotX = 0,
                rotY = 0,
                rotZ = 0,
                scaleX = 1.0,
                scaleY = 1.0,
                scaleZ = 1.0
            },
            Locked = true,
        },
        position = params.position,
        rotation = Vector(0, 0, 0),
        scale = Vector(18.41, 6.48, 4.7),
    })
end
-- @param params.seated Boolean indicating if a player is about to be seated here.
function setupSwapButtons(obj, params)
    params = params or {}
    local xml = {}
    local color = getTableColor(obj)
    local buttonColor = Color[color]:toHex(false)
    local textColor = fontColor(Color[color])
    local playerButtonVisibility = "Invisible"
    if showPlayerButtons then
        playerButtonVisibility = visiTableToString(invertVisiTable({"Black", "Grey", color}))
    end
    local playSpiritVisibility = "Invisible"
    local playSpiritText = ""
    if not params.seated and not Player[color].seated then
        if selectedColors[color] then
            playSpiritVisibility = visiTableToString(invertVisiTable({color}))
            playSpiritText = "Play Spirit"
        elseif showPlayerButtons then
            playSpiritVisibility = visiTableToString(invertVisiTable({color}))
            playSpiritText = "Play " .. color
        end
    end
    table.insert(xml, {
        tag = "Button",
        attributes = {
            id = "swapPlace",
            onClick = "Global/onClickedSwapPlace("..obj.guid..")",
            position = "320 755 -80",
            rotation = "0 0 180",
            text = "Swap Place",
            fontSize = "44",
            width = "270",
            height = "110",
            visibility = playerButtonVisibility,
            -- Note: tooltips don't work on Custom UI (https://tabletopsimulator.nolt.io/1369)
            -- tooltip="Moves your current player color to be located here. The color currently seated here will be moved to your current location. Spirit panels and other cards will be relocated if applicable.",
        },
        children = {},
    })
    table.insert(xml, {
        tag = "Button",
        attributes = {
            id = "swapColor",
            onClick = "Global/onClickedSwapColor("..obj.guid..")",
            position = "-320 755 -80",
            rotation = "0 0 180",
            text = "Swap " .. color,
            colors = "#"..buttonColor.."|#"..buttonColor.."|#"..buttonColor.."|#"..buttonColor.."80",
            textColor = "rgb("..textColor[1]..","..textColor[2]..","..textColor[3]..")",
            fontSize = "44",
            width = "270",
            height = "110",
            visibility = playerButtonVisibility,
            -- Note: tooltips don't work on Custom UI (https://tabletopsimulator.nolt.io/1369)
            -- tooltip="Change to be this color, updating all of your presence and reminder tokens accordingly. The player that is this color will be changed to be yours. Your seating position will not change.",
        },
        children = {},
    })
    table.insert(xml, {
        tag = "Button",
        attributes = {
            id = "playSpirit",
            onClick = "Global/onClickedPlaySpirit("..obj.guid..")",
            position = "0 755 -80",
            rotation = "0 0 180",
            text = playSpiritText,
            fontSize = "44",
            width = "270",
            height = "110",
            visibility = playSpiritVisibility,
            -- Note: tooltips don't work on Custom UI (https://tabletopsimulator.nolt.io/1369)
            -- tooltip="Switch to play the spirit that is here, changing your player color accordingly. Only available for spirits without a seated player. Intended for multi-handed solo games.",
        },
        children = {},
    })
    local foundGainOptions = false
    for _,data in pairs(obj.UI.getXmlTable()) do
        if data.attributes.id == "GainSpirits" then
            foundGainOptions = true
            table.insert(xml, data)
            break
        end
    end
    if not foundGainOptions then
        table.insert(xml, {
            tag = "VerticalLayout",
            attributes = {
                id = "GainSpirits",
                recurse = "GainSpirits",
                childForceExpandWidth = "false",
                childForceExpandHeight = "false",
                childAlignment = "MiddleCenter",
                spacing = "30",
                position = "0 0 -80",
                rotation = "0 0 180",
            },
            children = {},
        })
    end
    obj.UI.setXmlTable(xml, {})
end
function flipVector(vec)
    vec.x = 1/vec.x
    vec.y = 1/vec.y
    vec.z = 1/vec.z
    return vec
end
function fontColor(bg)
    if bg and (bg.r*0.30 + bg.g*0.59 + bg.b*0.11) > 0.50 then
        return {0,0,0}
    else
        return {1,1,1}
    end
end
function updateColorPickButtons()
    local coloredSeats = {}
    for _,obj in pairs(playerTables) do
        coloredSeats[obj.guid] = true
    end
    for _,guid in pairs(seatTables) do
        if not coloredSeats[guid] then
            if showPlayerButtons then
                setupColorPickButtons(getObjectFromGUID(guid), true)
            else
                local obj = getObjectFromGUID(guid)
                obj.UI.setXml("")
            end
        end
    end
    if showPlayerButtons then
        setupColorPickButtons(getObjectFromGUID("fe680a"), false)
        setupColorPickButtons(getObjectFromGUID("2ca216"), false)
    else
        getObjectFromGUID("fe680a").UI.setXml("")
        getObjectFromGUID("2ca216").UI.setXml("")
    end
end
function updateSwapButtons()
    for _, obj in pairs(playerTables) do
        setupSwapButtons(obj)
    end
end
function updatePlaySpiritButton(color)
    local table = playerTables[color]
    if table == nil then return end
    if not Player[color].seated and selectedColors[color] then
        table.UI.setAttribute("playSpirit", "visibility", "")
        table.UI.setAttribute("playSpirit", "text", "Play Spirit")
    elseif not Player[color].seated and showPlayerButtons then
        table.UI.setAttribute("playSpirit", "visibility", "")
        table.UI.setAttribute("playSpirit", "text", "Play " .. color)
    else
        table.UI.setAttribute("playSpirit", "visibility", "Invisible")
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
    L = "grey",
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
    L = "black",
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
    L = {"Non-Mining Lands", Ravage = "Mining Lands"},
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
    L = "Salt",
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
--- Takes a table of player colors and returns a table of all the player colors
--- not in the argument.
function invertVisiTable(inTable)
    local outTable = {}
    for _, color in pairs(Player.getColors()) do
        local include = true
        for _, c in pairs(inTable) do
            if color == c then
                include = false
                break
            end
        end
        if include then
            table.insert(outTable, color)
        end
    end
    return outTable
end

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
    updateColorPickButtons()
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
        UI.setAttribute("panel"..tType.."Outline", "height", childHeight)
        UI.setAttribute("panel"..tType.."Outline", "width", childWidth)
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
                    set(tType,1,1,"E",false)
                    size(tType,1,1,"E")
                    show(tType,1,1)
                end
            else
                set(tType,1,1,"n",false)
                size(tType,1,1,"n")
                show(tType,1,1)
            end
        else
            if tType == "Explore" then
                toggleInvaderPhaseImage(true)
            end
        end
    end
end
function hideAll(a)
    UI.setAttribute("panel"..a..11, "active", false)
    UI.setAttribute("panel"..a..12, "active", false)
    UI.setAttribute("panel"..a..21, "active", false)
    UI.setAttribute("panel"..a..22, "active", false)
    UI.setAttribute("panel"..a..31, "active", false)
    UI.setAttribute("panel"..a..32, "active", false)
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
function set(a,b,c,d, escalate)
    local tooltip = tooltips[d]
    if type(tooltip) == "table" then
        if tooltip[a] then
            tooltip = tooltip[a]
        else
            tooltip = tooltip[1]
        end
    end
    local text = textOut[d]
    if escalate then
        tooltip = tooltip.." with Escalation"
        text = text.."ₑ"
    end
    UI.setAttributes("panel"..a..b..c, {color = invaderColors[d], tooltip = tooltip, tooltipPosition="Above"})
    UI.setAttributes("panel"..a..b..c.."text", {color = invaderFontColors[d], text = text})
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
function show(a,b,c)
    UI.setAttribute("panel"..a..b..c, "active", true)
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

function getTableColor(table)
    for color,obj in pairs(playerTables) do
        if obj == table then
            return color
        end
    end
    return ""
end

colorLock = false
function swapPlayerColors(a, b)
    if a == b then
        return false
    end
    local pa, pb = Player[a], Player[b]

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
            for _,tempColor in ipairs({"White", "Brown", "Pink", "Teal", "Orange", "Green", "Blue", "Yellow", "Purple", "Red", "Black"}) do
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

function swapPlayerAreas(a, b)
    if(a == b) then return end
    local colorA = getTableColor(a)
    local colorB = getTableColor(b)

    swapPlayerAreaObjects(a, b, colorA, colorB)
    swapPlayerHands(a, b, colorA, colorB)
    swapPlayerTables(a, b)

    if colorB ~= "" then
        printToAll(colorA .. " swapped places with " .. colorB .. ".", Color[colorA])
    end
end

function swapPlayerAreaObjects(a, b, colorA, colorB)
    if a == b then return end
    local swaps = {[colorA] = colorB, [colorB] = colorA}
    local tables = {[colorA] = a, [colorB] = b}
    local objects = {}
    for color,playerTable in pairs(tables) do
        local t = upCast(playerTable, 1.9)
        if color ~= "" then
            for i = 1,Player[color].getHandCount() do
                for _,obj in ipairs(Player[color].getHandObjects(i)) do
                    table.insert(t, obj)
                end
            end
        end
        objects[color] = t
    end
    for from,to in pairs(swaps) do
        local transform = tables[to].getPosition() - tables[from].getPosition()
        for _,obj in ipairs(objects[from]) do
            if obj.interactable then
                obj.setPosition(obj.getPosition() + transform)
            end
        end
        if selectedColors[from] then
            selectedColors[from].defend.setPosition(selectedColors[from].defend.getPosition() + transform)
            selectedColors[from].isolate.setPosition(selectedColors[from].isolate.getPosition() + transform)
            selectedColors[from].zone.setPosition(selectedColors[from].zone.getPosition() + transform)
            for _,bag in pairs(selectedColors[from].elements) do
                bag.setPosition(bag.getPosition() + transform)
            end
        end
    end
end
function swapPlayerHands(a, b, colorA, colorB)
    if a == b then return end
    local offset = b.getPosition() - a.getPosition()

    if colorA ~= "" then
        for i = 1,Player[colorA].getHandCount() do
            local transform = Player[colorA].getHandTransform(i)
            transform.position = transform.position + offset
            Player[colorA].setHandTransform(transform, i)
        end
    end

    if colorB ~= "" then
        for i = 1,Player[colorB].getHandCount() do
            local transform = Player[colorB].getHandTransform(i)
            transform.position = transform.position - offset
            Player[colorB].setHandTransform(transform, i)
        end
    end
end
function swapPlayerTables(a, b)
    if a == b then return end
    local pos = a.getPosition()
    a.setPosition(b.getPosition())
    b.setPosition(pos)

    local indexA, indexB
    for i,guid in pairs(seatTables) do
        if guid == a.guid then
            indexB = i
            seatTables[i] = b.guid
        elseif guid == b.guid then
            indexA = i
            seatTables[i] = a.guid
        end
    end

    local playerReadyGuids = aidBoard.getTable("playerReadyGuids")
    local color = playerReadyGuids[indexA].color
    playerReadyGuids[indexA].color = playerReadyGuids[indexB].color
    playerReadyGuids[indexB].color = color
    aidBoard.setTable("playerReadyGuids", playerReadyGuids)
end

function swapSeatColors(a, b)
    if not swapPlayerColors(a, b) then
        return
    end
    recolorPlayerPieces(a, b)
    recolorPlayerArea(a, b)
    swapPlayerUIs(a, b)
end

function recolorDefend(bag, color)
    local data = bag.getData()
    local colorTint
    if Tints[color].Token then
        colorTint = Color.fromHex(Tints[color].Token)
    else
        colorTint = Color.fromHex(Tints[color].Presence)
    end
    data.ColorDiffuse.r = colorTint[1]
    data.ColorDiffuse.g = colorTint[2]
    data.ColorDiffuse.b = colorTint[3]
    data.ContainedObjects[1].Nickname = color.."'s Defend"
    data.ContainedObjects[1].ColorDiffuse.r = colorTint[1]
    data.ContainedObjects[1].ColorDiffuse.g = colorTint[2]
    data.ContainedObjects[1].ColorDiffuse.b = colorTint[3]
    for _,state in pairs(data.ContainedObjects[1].States) do
        state.Nickname = color.."'s Defend"
        state.ColorDiffuse.r = colorTint[1]
        state.ColorDiffuse.g = colorTint[2]
        state.ColorDiffuse.b = colorTint[3]
    end
    bag.destruct()
    return spawnObjectData({data = data})
end
function recolorIsolate(bag, color)
    local data = bag.getData()
    local colorTint
    if Tints[color].Token then
        colorTint = Color.fromHex(Tints[color].Token)
    else
        colorTint = Color.fromHex(Tints[color].Presence)
    end
    data.ColorDiffuse.r = colorTint[1]
    data.ColorDiffuse.g = colorTint[2]
    data.ColorDiffuse.b = colorTint[3]
    data.ContainedObjects[1].Nickname = color.."'s Isolate"
    data.ContainedObjects[1].ColorDiffuse.r = colorTint[1]
    data.ContainedObjects[1].ColorDiffuse.g = colorTint[2]
    data.ContainedObjects[1].ColorDiffuse.b = colorTint[3]
    bag.destruct()
    return spawnObjectData({data = data})
end
function recolorPlayerPieces(fromColor, toColor)
    if fromColor == toColor then return end
    local function initData(color)
        local colorTint
        if Tints[color].Token then
            colorTint = Color.fromHex(Tints[color].Token)
        else
            colorTint = Color.fromHex(Tints[color].Presence)
        end
        return {
            color = color,
            presenceTint = Color.fromHex(Tints[color].Presence),
            tokenTint = colorTint,
            objects = {},
            pattern = color .. "'s (.*)",
        }
    end
    local colors = {
        from = initData(fromColor),
        to = initData(toColor)
    }

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
    elseif selectedColors[fromColor] then
        selectedColors[fromColor].defend = recolorDefend(selectedColors[fromColor].defend, toColor)
        selectedColors[fromColor].isolate = recolorIsolate(selectedColors[fromColor].isolate, toColor)
    elseif selectedColors[toColor] then
        selectedColors[toColor].defend = recolorDefend(selectedColors[toColor].defend, fromColor)
        selectedColors[toColor].isolate = recolorIsolate(selectedColors[toColor].isolate, fromColor)
    end
    selectedColors[fromColor], selectedColors[toColor] = selectedColors[toColor], selectedColors[fromColor]

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
            for suffix, objs in pairs(b.objects) do
                if suffix == "Presence" then
                    local newname = a.color .. "'s " .. suffix
                    for _, obj in ipairs(objs) do
                        obj.setColorTint(a.presenceTint)
                        obj.setName(newname)
                        if obj.getDecals() then
                            makeSacredSite(obj)
                        end
                        local originalState = obj.getStateId()
                        if originalState == 1 then
                            obj = obj.setState(2)
                        else
                            obj = obj.setState(1)
                        end
                        obj.setColorTint(a.presenceTint)
                        obj.setName(newname)
                        if obj.getDecals() then
                            makeSacredSite(obj)
                        end
                        _ = obj.setState(originalState)
                    end
                elseif suffix == "Defend" then
                    -- Easier to grab new defend marker than to change the name and color of every state
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
                        obj.setColorTint(a.tokenTint)
                        obj.setName(newname)
                    end
                end
            end
        end
    end, 1)
end
function recolorPlayerArea(a, b)
    for _,obj in pairs(getObjects()) do
        if obj.type == "Hand" then
            local data = obj.getData()
            local found = false
            if data.FogColor == a then
                data.FogColor = b
                found = true
            elseif data.FogColor == b then
                data.FogColor = a
                found = true
            end
            if found then
                spawnObjectData({data = data})
                obj.destruct()
            end
        end
    end

    if playerTables[a] then
        local colorTint
        if Tints[b].Table then
            colorTint = Color.fromHex(Tints[b].Table)
        else
            colorTint = Color.fromHex(Tints[b].Presence)
        end
        playerTables[a].setColorTint(colorTint)
    end
    if playerTables[b] then
        local colorTint
        if Tints[a].Table then
            colorTint = Color.fromHex(Tints[a].Table)
        else
            colorTint = Color.fromHex(Tints[a].Presence)
        end
        playerTables[b].setColorTint(colorTint)
    end
    playerTables[a], playerTables[b] = playerTables[b], playerTables[a]

    local playerReadyGuids = aidBoard.getTable("playerReadyGuids")
    for _,data in pairs(playerReadyGuids) do
        if data.color == a then
            data.color = b
        elseif data.color == b then
            data.color = a
        end
    end
    aidBoard.setTable("playerReadyGuids", playerReadyGuids)

    updateSwapButtons()
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

    newVisiTable = swapPlayerUI(a, b, "panelPowerDraw")
    if newVisiTable ~= nil then
        setVisiTable("panelPowerDraw",newVisiTable)
        setVisiTable("panelTimePasses",newVisiTable)
        setVisiTable("panelReady",newVisiTable)
    end

    newVisiTable = swapPlayerUI(a, b, "panelGameOver")
    if newVisiTable ~= nil then
        setVisiTable("panelGameOver",newVisiTable)
    end

    local enabled = gamekeys[a]
    gamekeys[a] = gamekeys[b]
    gamekeys[b] = enabled
end

function swapPlace(player, guid, _)
    if playerTables[player.color] then
        swapPlayerAreas(playerTables[player.color], getObjectFromGUID(guid))
    else
        player.broadcast("Pick a color first", Color.Red)
    end
end
-- Trade places with selected seat.
function onClickedSwapPlace(player, guid, id)
    local target_obj = getObjectFromGUID(guid)
    local target_color = getTableColor(target_obj)
    local source_color = player.color
    if player.color == "Grey" then
        return
    end

    if target_color == nil and not playerTables[source_color] then
        return
    elseif not playerTables[source_color] then
        swapPlayerColors(source_color, target_color)
    else
        swapPlayerAreas(playerTables[source_color], target_obj)
    end
end

function swapColor(player, _, color)
    if playerTables[player.color] then
        swapSeatColors(player.color, color)
        updateColorPickButtons()
        updateSwapButtons()
    else
        player.broadcast("Pick a color first", Color.Red)
    end
end
-- Trade colors with selected seat.
function onClickedSwapColor(player, guid, id)
    local target_color = getTableColor(getObjectFromGUID(guid))
    local source_color = player.color
    if player.color == "Grey" then
        return
    end

    if target_color == nil then
        return
    end

    if not playerTables[source_color] then
        swapPlayerColors(source_color, target_color)
    else
        swapSeatColors(source_color, target_color)
    end
end

-- Play spirit
function onClickedPlaySpirit(player, guid, id)
    local target_color = getTableColor(getObjectFromGUID(guid))
    local source_color = player.color

    if target_color == nil then
        return
    end

    if player.color == "Grey" then
        player.changeColor(target_color)
        return
    end

    if swapPlayerColors(source_color, target_color) then
        Wait.frames(function()
            Player[target_color].lookAt({
                position = playerTables[target_color].getPosition() + Vector(0,2.81,0),
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
    for color,_ in pairs(playerTables) do
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
    elseif obj.hasTag("Seat") then
        table.insert(seatTables, obj.guid)
        setupColorPickButtons(obj, true)
        SetupChecker.call("updateMaxPlayers", {max = getSeatCount()})
    end
end
function onObjectDestroy(obj)
    if obj.hasTag("Seat") then
        for i,guid in pairs(seatTables) do
            if guid == obj.guid then
                table.remove(seatTables, i)
                SetupChecker.call("updateMaxPlayers", {max = getSeatCount()})
                break
            end
        end
        for color,table in pairs(playerTables) do
            if table == obj then
                -- Not really sure what to do if a spirit has already been picked
                if not selectedColors[color] then
                    for _,o in pairs(getObjects()) do
                        if o.type == "Hand" then
                            if o.getData().FogColor == color then
                                o.destruct()
                            end
                        end
                    end
                end
                playerTables[color] = nil
                updateColorPickButtons()
            end
        end
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
                    forgetPowerCard({card = obj, discardHeight = 1, color = player_color})
                end
            end
        end,
        false)
end

function grabSpiritMarkers()
    local bag = getObjectFromGUID("011f19")
    for _,data in pairs(selectedColors) do
        if data.zone then
            for _, obj in ipairs(data.zone.getObjects()) do
                if obj.hasTag("Spirit") then
                    for _,marker in pairs(bag.getObjects()) do
                        if marker.name == obj.getName() then
                            bag.takeObject({
                                guid = marker.guid,
                                position = data.zone.getPosition() + Vector(0, 2, 8.5)
                            })
                            break
                        end
                    end
                    break
                end
            end
        end
    end
end
function grabDestroyBag(color)
    local bag = getObjectFromGUID("fd0a22")
    if bag ~= nil then
        if Player[color] then
            bag.takeObject({position = Player[color].getPointerPosition() + Vector(0, 2, 0)})
        end
    end
end

function enterSpiritPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 1 then return end
    broadcastToAll("Entering Spirit Phase", Color.White)
    updateCurrentPhase(true)
    currentPhase = 1
    updateCurrentPhase(false)
    triggerChangePhase(false)
end
function enterFastPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 2 then return end
    broadcastToAll("Entering Fast Power Phase", Color.White)
    updateCurrentPhase(true)
    currentPhase = 2
    updateCurrentPhase(false)
    triggerChangePhase(false)
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
    triggerChangePhase(false)
end
function enterSlowPhase(player)
    if player and player.color == "Grey" then return end
    if currentPhase == 4 then return end
    broadcastToAll("Entering Slow Power Phase", Color.White)
    updateCurrentPhase(true)
    currentPhase = 4
    updateCurrentPhase(false)
    triggerChangePhase(false)
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
        attributes.text = string.gsub(string.gsub(UI.getAttribute(id, "text"), ">>", ""), "<<", "")
    else
        attributes.text = ">>"..UI.getAttribute(id, "text").."<<"
    end
    UI.setAttributes(id, attributes)
end
function triggerChangePhase(timePasses)
    local phase = currentPhase
    if timePasses then
        phase = 5
    end
    for _,object in pairs(getObjectsWithTag("Phases")) do
        object.call("changePhase", {phase = phase, turn = turn})
    end
end

function EnableOceanDrowningLimit()
    SetupChecker.setVar("optionalDrowningCap", true)
end
