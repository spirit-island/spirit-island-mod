difficulty=-1
postSetup = true
postSetupComplete = false
hasBroadcast = true

local destinyPlayers = {}
local readyTokens = {}
local round = 1 -- First or second round of drafts
local phase = 0 -- Phase within a round
local timer = nil

function onSave()
    local data_table = {
        destinyPlayers = destinyPlayers,
        readyTokens = readyTokens,
        round = round,
        phase = phase,
    }
    return JSON.encode(data_table)
end

function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        destinyPlayers = loaded_data.destinyPlayers
        readyTokens = loaded_data.readyTokens
        round = loaded_data.round
        phase = loaded_data.phase
    end

    Color.Add("SoftBlue", Color.new(0.53,0.92,1))

    if Global.getVar("gameStarted") and Global.getVar("scenarioCard") ~= nil and Global.getVar("scenarioCard").guid == self.guid then
        PostSetup()
    end
end

function Broadcast()
    return "Use the button on the scenario panel to progress drafting"
end

function PostSetup(_)
    if round <= 2 then
        -- Lock out card gains for the duration
        Wait.condition(
            function() Global.setVar("scriptWorkingCardC", true) end,
            function() return not Global.getVar("scriptWorkingCardC") end
        )
    end
    if round == 1 and phase == 0 then
        addParticipatingButtons()
        timer = Wait.time(addParticipatingButtons, 1, -1)
    elseif round <= 2 then
        updatePassDirButtons()
        startUpdateReady()
    end
    updateSelfButton()
    Wait.frames(updateAllCardButtons, 2) -- Global onLoad() overwrites the buttons in the power gain area on a 1-frame delay, so overwrite them ourselves after that

    postSetupComplete = true
end

function cleanUp()
    Global.setVar("scriptWorkingCardC", false)
    destroyReadyTokens()
end

function broadcastInstructions()
    if round > 2 or phase == 0 then
        return
    end
    if getNumPlayers() == 2 then
        if phase == 1 then
            broadcastMessage("Sort the Power Cards into 3 pairs")
        else
            broadcastMessage("Choose pairs of Power Cards to add to your Destiny")
        end
    else
        broadcastMessage("Choose a Power Card to add to your Destiny")
    end
end

function updateSelfButton()
    if round == 1 or round == 2 then
        if phase == 0 then
            setSelfButton({label = "Draft Cards", click_function = "draftCards"})
        elseif getNumPlayers() == 2 then
            if phase == 1 then
                setSelfButton({label = "Reveal Groups", click_function = "revealGroups"})
            else
                setSelfButton({label = "Finish Draft", click_function = "discardGroups"})
            end
        else
            if phase < 5 then
                setSelfButton({label = "Pass Cards", click_function = "passCards"})
            else
                setSelfButton({label = "Finish Draft", click_function = "passCards"})
            end
        end
    else
        self.clearButtons()
    end
end

function getParticipatingButton(zoneGUID)
    local buttonLabel = {
        [true] = "Destiny Unfolds:\nParticipating",
        [false] = "Destiny Unfolds:\nNot Participating",
    }
    local buttonColor = {
        [true] = "Green",
        [false] = "Red",
    }
    local participating = destinyPlayers[zoneGUID]
    return {
        label = buttonLabel[participating],
        color = buttonColor[participating],
        click_function = "toggleParticipating",
        function_owner = self,
        position = {0,0,0.77},
        rotation = {0,180,0},
        scale = getButtonScale(getObjectFromGUID(zoneGUID)),
        height = 1400,
        width = 4000,
        font_size = 500,
        tooltip = "Click to toggle",
    }
end

function getPassDirButton(zoneGUID)
    local passPlayer = getPassPlayer(zoneGUID)
    local label = ""
    if passPlayer then
        label = "Passing to "..getSpiritName(passPlayer)
    end
    return {
        label = label,
        click_function = "nullFunc",
        function_owner = self,
        position = {0,0,0.5},
        rotation = {0,180,0},
        scale = getButtonScale(getObjectFromGUID(zoneGUID)),
        height = 0,
        width = 0,
        font_size = 500,
        font_color = "White",
    }
end

function addParticipatingButtons()
    for _,selected in pairs(Global.getVar("selectedColors")) do
        if selected.zone ~= nil then
            local zoneGUID = selected.zone.guid
            if destinyPlayers[zoneGUID] == nil then
                destinyPlayers[zoneGUID] = true
            end
            local buttonParams = getParticipatingButton(zoneGUID)
            if not getButtonIndex(selected.zone, buttonParams) then
                setButton(selected.zone, buttonParams)
            end
        end
    end
end

function clearParticipatingButtons()
    for _,selected in pairs(Global.getVar("selectedColors")) do
        if selected.zone ~= nil then
            removeButton(selected.zone, getParticipatingButton(selected.zone.guid))
        end
    end
end

function updatePassDirButtons()
    local haveButtons = getNumPlayers() > 2 and round <= 2 and phase ~= 0
    for zoneGUID,_ in pairs(destinyPlayers) do
        local buttonParams = getPassDirButton(zoneGUID)
        if haveButtons then
            setButton(getObjectFromGUID(zoneGUID), buttonParams)
        else
            removeButton(getObjectFromGUID(zoneGUID), buttonParams)
        end
    end
end

function toggleParticipating(obj, _, _)
    destinyPlayers[obj.guid] = not destinyPlayers[obj.guid]
    setButton(obj, getParticipatingButton(obj.guid))
end

function completeRegistration()
    if getNumPlayers() < 2 then
        broadcastError("Destiny Unfolds requires at least 2 participating players.")
        return false
    end

    local zoneGUIDs = {}
    for zoneGUID,data in pairs(destinyPlayers) do
        if data then
            destinyPlayers[zoneGUID] = {
                cards = {},
                zones = {},
                handIndices = {},
            }
            table.insert(zoneGUIDs, zoneGUID)
        else
            destinyPlayers[zoneGUID] = nil
        end
    end

    zoneGUIDs = sortByX(zoneGUIDs)
    for i=2,#zoneGUIDs do
        destinyPlayers[zoneGUIDs[i]].left = zoneGUIDs[i-1]
    end
    for i=1,#zoneGUIDs-1 do
        destinyPlayers[zoneGUIDs[i]].right = zoneGUIDs[i+1]
    end
    destinyPlayers[zoneGUIDs[1]].left = zoneGUIDs[#zoneGUIDs]
    destinyPlayers[zoneGUIDs[#zoneGUIDs]].right = zoneGUIDs[1]

    if timer ~= nil then
        Wait.stop(timer)
    end
    clearParticipatingButtons()

    spawnReadyTokens()

    return true
end

function broadcastError(message)
    broadcastToAll(message, Color.Red)
end
function broadcastMessage(message)
    broadcastToAll(message, Color.SoftBlue)
end

function getPassPlayer(zoneGUID)
    local passDirs = {"left", "right"}
    local passDir = passDirs[round]
    return destinyPlayers[zoneGUID][passDir]
end

function getNumPlayers()
    local num = 0
    for _,data in pairs(destinyPlayers) do
        if data then
            num = num + 1
        end
    end
    return num
end

function getButtonScale(obj)
    local scale = obj.getScale()
    return Vector(1 / scale.x, 1 / scale.y, 1 / scale.z)
end

function getButtonIndex(obj, params)
    local buttons = obj.getButtons()
    if buttons == nil then
        return nil
    end
    for _,button in pairs(buttons) do
        local match = true
        for key,val in pairs(params) do
            if button[key] ~= val then
                match = false
                break
            end
        end
        if match then
            return button.index
        end
    end
    return nil
end

function setButton(obj, params)
    local identifier = {click_function = params.click_function, function_owner = params.function_owner}
    local buttonIndex = getButtonIndex(obj, identifier)
    if not buttonIndex then
        obj.createButton(params)
    else
        local newParams = {index = buttonIndex}
        for k,v in pairs(params) do
            newParams[k] = v
        end
        obj.editButton(newParams)
    end
end

function removeButton(obj, params)
    local identifier = {click_function = params.click_function, function_owner = params.function_owner}
    local buttonIndex = getButtonIndex(obj, identifier)
    if buttonIndex then
        obj.removeButton(buttonIndex)
    end
end

function setSelfButton(params)
    local buttonParams = {
        function_owner = self,
        position       = Vector(0.6, 1, -1.1),
        rotation       = Vector(0,0,0),
        scale          = Vector(0.2,0.2,0.2),
        width          = 2000,
        height         = 500,
        font_size      = 300,
    }
    for k,v in pairs(params) do
        buttonParams[k] = v
    end
    if not self.getButtons() then
        self.createButton(buttonParams)
    else
        buttonParams.index = 0
        self.editButton(buttonParams)
    end
end

function getZoneColor(zoneGUID)
    for color,selected in pairs(Global.getVar("selectedColors")) do
        if selected.zone.guid == zoneGUID then
            return color
        end
    end
end

function getZoneGUID(color)
    if color == nil then
        return nil
    end
    local selected = Global.getVar("selectedColors")[color]
    if selected == nil then
        return nil
    end
    return selected.zone.guid
end

function getTablePos(zoneGUID)
    return Global.getVar("playerTables")[getZoneColor(zoneGUID)].getPosition()
end

function getSpiritName(zoneGUID)
    for _,obj in pairs(getObjectFromGUID(zoneGUID).getObjects()) do
        if obj.hasTag("Spirit") then
            return obj.getName()
        end
    end
end

function spawnZones(zoneGUID)
    local handSep = Vector(0.0, 0.0, -5.5)

    local color = getZoneColor(zoneGUID)
    local player = Player[color]
    local lastHandPos = player.getHandTransform(player.getHandCount()).position

    local pickZoneScale = Vector(22.0, 5.1, 5.1)
    local destinyScale = Global.getTable("handScale")

    local pickZonePos = getTablePos(zoneGUID) + Global.getVar("tableOffset")
    local hiddenDestinyPos = lastHandPos + 2 * handSep
    local publicDestinyPos = lastHandPos + handSep

    local function spawnZone(var, typeName, fogColor, fogHidePointers, position, scale)
        if destinyPlayers[zoneGUID].zones[var] then
            -- Skip if it already exists.
            return false
        end
        local zone = spawnObjectData({
            data = {
                Name = typeName,
                FogColor = fogColor,
                FogHidePointers = fogHidePointers,
                Transform = {
                    posX = 0,
                    posY = 0,
                    posZ = 0,
                    rotX = 0,
                    rotY = 0,
                    rotZ = 0,
                    scaleX = 1.0,
                    scaleY = 1.0,
                    scaleZ = 1.0,
                },
                Locked = true,
            },
            position = position,
            rotation = Vector(0, 0, 0),
            scale = scale,
        })
        Wait.condition(
            function() destinyPlayers[zoneGUID].zones[var] = zone.guid end,
            function() return not zone.spawning end
        )
        return true
    end
    local function spawnHidingZone(var, color, position, scale)
        spawnZone(var, "FogOfWarTrigger", color, true, position, scale)
    end
    local function spawnHand(var, color, position, scale)
        local spawned = spawnZone(var, "HandTrigger", color, nil, position, scale)
        if spawned then
            destinyPlayers[zoneGUID].handIndices[var] = Player[getZoneColor(zoneGUID)].getHandCount()
        end
    end

    spawnHidingZone("pickHiding", color, pickZonePos, pickZoneScale)
    spawnHand("publicDestiny", color, publicDestinyPos, destinyScale)
    if getNumPlayers() > 2 then
        spawnHidingZone("destinyHiding", color, hiddenDestinyPos, destinyScale)
        spawnHand("hiddenDestiny", color, hiddenDestinyPos, destinyScale)
    end
end

function cleanUpZones(zoneGUID)
    local zones = destinyPlayers[zoneGUID].zones
    local handIndices = destinyPlayers[zoneGUID].handIndices
    if zones.pickHiding then
        getObjectFromGUID(zones.pickHiding).destruct()
        zones.pickHiding = nil
    end
    if zones.destinyHiding then
        getObjectFromGUID(zones.destinyHiding).destruct()
        zones.destinyHiding = nil
    end
    if zones.hiddenDestiny then
        getObjectFromGUID(zones.hiddenDestiny).destruct()
        zones.hiddenDestiny = nil
        handIndices.hiddenDestiny = nil
    end
end

function spawnAllZones()
    for zoneGUID,_ in pairs(destinyPlayers) do
        spawnZones(zoneGUID)
    end
end

function cleanUpAllZones()
    for zoneGUID,_ in pairs(destinyPlayers) do
        cleanUpZones(zoneGUID)
    end
end

function revealHiddenDestinies()
    local cardsDealt = 0
    local cardsResting = 0
    for zoneGUID,data in pairs(destinyPlayers) do
        local player = Player[getZoneColor(zoneGUID)]
        for _,card in pairs(player.getHandObjects(data.handIndices.hiddenDestiny)) do
            card.deal(1, player.color, data.handIndices.publicDestiny)
            cardsDealt = cardsDealt + 1
            Wait.condition(function() cardsResting = cardsResting + 1 end, function() return not card.isSmoothMoving() end)
        end
    end
    if round > 2 then
        Wait.condition(cleanUpAllZones, function() return cardsResting == cardsDealt end)
    end
end

function dealCard(card, color, toHidden)
    local handIndices = destinyPlayers[getZoneGUID(color)].handIndices
    local handIndex = handIndices.publicDestiny
    if toHidden then
        handIndex = handIndices.hiddenDestiny
    end

    card.deal(1, color, handIndex)
    card.clearButtons()
    card.call("PickPower", {})
    Wait.condition(function() card.setLock(false) end, function() return not card.isSmoothMoving() end)
end

function scanCards()
    for zoneGUID,_ in pairs(destinyPlayers) do
        destinyPlayers[zoneGUID].cards = {}
        for _,card in pairs(Global.call("getPowerZoneObjects", getTablePos(zoneGUID))) do
            destinyPlayers[zoneGUID].cards[card.guid] = false
        end
    end
    updateAllCardButtons()
    updateReady()
end

function sortByX(guids)
    table.sort(guids, function(a,b)
        return getObjectFromGUID(a).getPosition().x < getObjectFromGUID(b).getPosition().x
    end)
    return guids
end

function getOrderedCards(zoneGUID)
    -- Returns an array (mapping sequential integers to card GUIDs), sorted by position from left to right
    local data = destinyPlayers[zoneGUID]
    if not (type(data) == "table" and data.cards) then
        return {}
    end
    local cards = {}
    for cardGUID,_ in pairs(data.cards) do
        table.insert(cards, cardGUID)
    end
    return sortByX(cards)
end

function updateCardButtons(card, selected)
    local function setCardButton(click_function, label, tooltip, highlight, x, width)
        local buttonColor = {
            [true] = "Blue",
            [false] = "White",
        }
        setButton(card, {
            label = label,
            color = buttonColor[highlight],
            click_function = click_function,
            function_owner = self,
            position = Vector(x, 0.3, 1.43),
            width = width,
            scale = getButtonScale(card),
            height = 160,
            font_size = 150,
            tooltip = tooltip,
        })
    end

    card.clearButtons()
    if getNumPlayers() == 2 then
        if phase == 1 then
            for i=1,3 do
               setCardButton("selectCardGroup"..tostring(i), tostring(i), "Set which pair this Power Card is in", i == selected, (i-2) * 0.2, 160)
            end
        else
            setCardButton("grabGroup", "Pick Pair", "Pick these two Power Cards to your hand", false, 1, 900)
        end
    else
        setCardButton("selectCard", "Pick Power", "Select this Power Card", selected, 0, 900)
    end
end

function updateAllCardButtons()
    local grouped = getNumPlayers() == 2 and phase == 2
    for zoneGUID,data in pairs(destinyPlayers) do
        local orderedCards = getOrderedCards(zoneGUID)
        for i,cardGUID in ipairs(orderedCards) do
            local card = getObjectFromGUID(cardGUID)
            if not (grouped and i%2 == 0) then
                updateCardButtons(card, data.cards[cardGUID])
            elseif grouped then
                card.clearButtons()
            end
        end
    end
end

function selectCard(card, _, alt_click)
    for zoneGUID,data in pairs(destinyPlayers) do
        local found = false
        for cardGUID,selected in pairs(data.cards) do
            if cardGUID == card.guid then
                if alt_click and not selected then
                    return
                end
                found = true
                break
            end
        end
        if found then
            for cardGUID,selected in pairs(data.cards) do
                data.cards[cardGUID] = (cardGUID == card.guid and not alt_click)
                updateCardButtons(getObjectFromGUID(cardGUID), data.cards[cardGUID])
            end
            break
        end
    end
    updateReady()
end

function selectCardGroup(card, _, alt_click, group)
    if alt_click then
        group = false
    end
    for zoneGUID,data in pairs(destinyPlayers) do
        local found = false
        for cardGUID,selected in pairs(data.cards) do
            if cardGUID == card.guid then
                data.cards[cardGUID] = group
                updateCardButtons(getObjectFromGUID(cardGUID), data.cards[cardGUID])
                break
            end
        end
        if found then
            break
        end
    end
    updateReady()
end
function selectCardGroup1(card, player_clicker_color, alt_click)
    selectCardGroup(card, player_clicker_color, alt_click, 1)
end
function selectCardGroup2(card, player_clicker_color, alt_click)
    selectCardGroup(card, player_clicker_color, alt_click, 2)
end
function selectCardGroup3(card, player_clicker_color, alt_click)
    selectCardGroup(card, player_clicker_color, alt_click, 3)
end

function grabGroup(card, player_clicker_color, _)
    local cardsDealt = 0
    local cardsResting = 0
    for zoneGUID,data in pairs(destinyPlayers) do
        local group = nil
        for cardGUID,selected in pairs(data.cards) do
            if cardGUID == card.guid then
                group = selected
                break
            end
        end
        if group ~= nil then
            for cardGUID,selected in pairs(data.cards) do
                if selected == group then
                    local card = getObjectFromGUID(cardGUID)
                    destinyPlayers[zoneGUID].cards[cardGUID] = nil
                    dealCard(card, player_clicker_color, false)
                    cardsDealt = cardsDealt + 1
                    Wait.condition(
                        function() cardsResting = cardsResting + 1 end,
                        function() return not card.isSmoothMoving() end
                    )
                end
            end
            break
        end
    end
    Wait.condition(
        updateReady,
        function() return cardsResting == cardsDealt end
    )
end

function validatePlayer(zoneGUID, broadcast)
    local numPlayers = getNumPlayers()
    local playerName = getSpiritName(zoneGUID).." ("..tostring(getZoneColor(zoneGUID))..")"
    if numPlayers == 2 and phase == 1 then
        local groups = {0, 0, 0}
        for _,selected in pairs(destinyPlayers[zoneGUID].cards) do
            if selected then
                groups[selected] = groups[selected] + 1
            end
        end
        if groups[1] == 2 and groups[2] == 2 and groups[3] == 2 then
            return true
        else
            if broadcast then
                broadcastError(playerName.." has not chosen pairs correctly")
            end
            return false
        end
    elseif numPlayers == 2 then
        local cards = Player[getZoneColor(zoneGUID)].getHandObjects(destinyPlayers[zoneGUID].handIndices.publicDestiny)
        local minima = {4, 10}
        local maxima = {6, 10}
        local minCards = minima[round]
        local maxCards = maxima[round]
        if #cards < minCards then
            if broadcast then
                broadcastError(playerName.." does not have enough cards in their destiny")
            end
            return false
        elseif #cards > maxCards then
            if broadcast then
                broadcastError(playerName.." has too many cards in their destiny")
            end
            return false
        else
            return true
        end
    else
        local hasPicked = false
        for _,selected in pairs(destinyPlayers[zoneGUID].cards) do
            if selected then
                hasPicked = true
                break
            end
        end
        if hasPicked then
            return true
        else
            if broadcast then
                broadcastError(playerName.." has not picked a Power Card")
            end
            return false
        end
    end
end

function validateAllPlayers(broadcast)
    local isValid = true
    for zoneGUID,_ in pairs(destinyPlayers) do
        if not validatePlayer(zoneGUID, broadcast) then
            isValid = false
        end
    end
    return isValid
end

function wt(some)
    local Time = os.clock() + some
    while os.clock() < Time do
        coroutine.yield(0)
    end
end

function discardCards()
    for zoneGUID,_ in pairs(destinyPlayers) do
        destinyPlayers[zoneGUID].cards = {}
        local discardTable = Global.call("DiscardPowerCards", getTablePos(zoneGUID))
        if #discardTable > 0 then
            wt(0.1)
        end
    end
    return 1
end

function getCardPositions(zoneGUID, count, group)
    return Global.call("getCardPositions", {tablePos = getTablePos(zoneGUID), count = count, pair = group})
end

function getAllCardPositions(cardCount, group)
    local playerCardPositions = {}
    for zoneGUID,_ in pairs(destinyPlayers) do
        table.insert(playerCardPositions, getCardPositions(zoneGUID, cardCount, group))
    end

    local cardPositions = {}
    -- Interleave card positions for each player, so that cards are still dealt evenly if they run out
    for i=1,cardCount do
        for _,positions in pairs(playerCardPositions) do
            table.insert(cardPositions, positions[i])
        end
    end
    return cardPositions
end

function dealCards()
    local numMajors = 3 - round
    local numMinors = 6 - numMajors
    local numPlayers = getNumPlayers()

    discardCards()

    local cardPositions = getAllCardPositions(numMinors + numMajors, false)
    local numPlaytestMajors = Global.call("getPlaytestCount", {count = numMajors, major = true})
    local numPlaytestMinors = Global.call("getPlaytestCount", {count = numMinors, major = false})

    Global.call("dealPowerCards", {
        cardPositions = cardPositions,
        numMinors = numMinors * numPlayers,
        numPlaytestMinors = numPlaytestMinors * numPlayers,
        numMajors = numMajors * numPlayers,
        numPlaytestMajors = numPlaytestMajors * numPlayers,
        callback_function = "scanCards",
        callback_object = self
    })

    return 1
end

function draftCards()
    if round == 1 and not completeRegistration() then
        return
    end

    spawnAllZones()
    startLuaCoroutine(self, "dealCards")

    phase = phase + 1
    updateSelfButton()
    updatePassDirButtons()
    broadcastInstructions()
end

local passCardsWorking = false
function passCards()
    if passCardsWorking or not validateAllPlayers(true) then
        return
    end
    passCardsWorking = true

    local finalDraft = phase == 5

    local cardsDealt = 0
    local cardsResting = 0
    for zoneGUID,data in pairs(destinyPlayers) do
        local cardsMoved = 0
        local orderedCards = getOrderedCards(zoneGUID)
        local cardPositions = getCardPositions(getPassPlayer(zoneGUID), #orderedCards - 1, false)
        for _,cardGUID in ipairs(orderedCards) do
            local card = getObjectFromGUID(cardGUID)
            if data.cards[cardGUID] then
                dealCard(card, getZoneColor(zoneGUID), true)
                cardsDealt = cardsDealt + 1
                Wait.condition(
                    function() cardsResting = cardsResting + 1 end,
                    function() return not card.isSmoothMoving() end
                )
            elseif not finalDraft then
                card.setPosition(cardPositions[cardsMoved + 1])
                card.setRotation(Vector(0, 180, 0))
                card.setLock(true)
                cardsMoved = cardsMoved + 1
            end
        end
    end

    if finalDraft then
        Wait.condition(
            function()
                startLuaCoroutine(self, "discardCards")
                revealHiddenDestinies()
                passCardsWorking = false
            end,
            function() return cardsResting == cardsDealt end
        )
        round = round + 1
        phase = 0
    else
        Wait.condition(
            function()
                scanCards()
                passCardsWorking = false
            end,
            function() return cardsResting == cardsDealt end
        )
        phase = phase + 1
    end

    if round > 2 then
        cleanUp()
    end
    updatePassDirButtons()
    updateSelfButton()
end

function revealGroups()
    if not validateAllPlayers(true) then
        return
    end

    cleanUpAllZones()

    for zoneGUID,data in pairs(destinyPlayers) do
        local cardPositions = getCardPositions(zoneGUID, 6, true)
        local cardsMoved = {0, 0, 0}
        for cardGUID,selected in pairs(data.cards) do
            local card = getObjectFromGUID(cardGUID)
            card.setPosition(cardPositions[selected * 2 - 1 + cardsMoved[selected]])
            card.setRotation(Vector(0, 180, 0))
            card.setLock(true)
            cardsMoved[selected] = cardsMoved[selected] + 1
        end
    end

    phase = phase + 1
    updateAllCardButtons()
    updateSelfButton()
    updateReady()
    broadcastInstructions()
end

function discardGroups()
    if not validateAllPlayers(true) then
        return
    end

    startLuaCoroutine(self, "discardCards")
    round = round + 1
    phase = 0

    if round > 2 then
        cleanUp()
    end
    updateSelfButton()
end

function spawnReadyTokens()
    local numTokens = 6
    for i=1,numTokens do
        local data = {
            Name = "Custom_Model",
            Transform = {
                rotX = 0,
                rotY = 180,
                rotZ = 0,
                scaleX = 0.5,
                scaleY = 0.8,
                scaleZ = 0.5,
            },
            Nickname = "Ready",
            Tags = {"Uninteractable"},
            Locked = true,
            CustomMesh = {
                MeshURL = "http://cloud-3.steamusercontent.com/ugc/868489312390110251/5C3337D08AA1E8E0DD9A2B79D23BB60B568F478E/",
                DiffuseURL = "http://cloud-3.steamusercontent.com/ugc/863986017479109174/7B1C203C001E522EB47374C09461EAC2A71E59EB/",
                MaterialIndex = 3
            },
        }
        local token = spawnObjectData({
            data = data,
            position = self.getPosition() + Vector((i - 3.5) * 1.36, 0, 3.5),
            callback_function = function(obj)
                obj.interactable = false
                readyTokens[i] = obj.guid
            end
        })
        token.setInvisibleTo(Player.getColors())
    end
    startUpdateReady()
end

function destroyReadyTokens()
    if timer ~= nil then
        Wait.stop(timer)
    end
    for i,guid in pairs(readyTokens) do
        getObjectFromGUID(guid).destruct()
        readyTokens[i] = nil
    end
end

function updateReady()
    local seatTables = Global.getVar("seatTables")
    local tints = Global.getTable("Tints")
    for i,guid in pairs(readyTokens) do
        local color = Global.call("getTableColor", getObjectFromGUID(seatTables[i]))
        local zoneGUID = getZoneGUID(color)
        local token = getObjectFromGUID(guid)
        if phase > 0 and zoneGUID and destinyPlayers[zoneGUID] then
            local tokenTint = tints[color].Presence
            if tints[color].Token then
                tokenTint = tints[color].Token
            end
            local buttonParams = {
                click_function = "nullFunc",
                function_owner = self,
                position = Vector(0, 0.1, -2),
                rotation = Vector(0, 0, 0),
                scale = getButtonScale(token),
                width = 0,
                height = 0,
                font_size = 500,
            }
            if validatePlayer(zoneGUID, false) then
                buttonParams.label = "✓"
                buttonParams.font_color = "Green"
            else
                buttonParams.label = "X"
                buttonParams.font_color = "Red"
            end
            token.setInvisibleTo({})
            token.setColorTint(Color.fromHex(tokenTint))
            setButton(token, buttonParams)
        else
            token.setInvisibleTo(Player.getColors())
            token.setColorTint(Color.fromHex("#918F8F"))
            token.clearButtons()
        end
    end
end

function startUpdateReady()
    updateReady()
    timer = Wait.time(updateReady, 2, -1)
end

function nullFunc()
end
