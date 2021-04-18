numCards = 0
discard = Vector(-46.21, 1.5, 0.33)
tokenOffset = Vector(10,0.1,0)

function onSave()
    local data_table = {
        discard = discard,
    }
    return JSON.encode(data_table)
end
function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        discard = Vector(loaded_data.discard)
    end

    self.createButton({ -- Blighted Island Placeholder
        click_function = "BlightIslandButton",
        function_owner = Global,
        label          = "",
        position       = Vector(1.146,0.2,1.35),
        rotation       = Vector(0,0,0),
        width          = 0,
        height         = 0,
        scale          = Vector(0.17,1,0.2),
        font_size      = 220,
        tooltip        = "Click here when the blight stack has been reduced to 0"
    })
    self.createButton({ -- FEAR POOL
        click_function = "blankFunc",
        function_owner = self,
        label          = Global.getVar("fearPool"),
        font_color     = {1,1,1},
        color          = {0/255,150/255,0/255},
        position       = Vector(0,0.1,0.16),
        width          = 0,
        height         = 0,
        font_size      = 200,
    })
    self.createButton({ -- GENERATED FEAR
        click_function = "blankFunc",
        function_owner = self,
        label          = Global.getVar("generatedFear"),
        font_color     = {1,1,1},
        color          = {0/255,150/255,0/255},
        position       = Vector(0,0.1,0.7),
        width          = 0,
        height         = 0,
        font_size      = 200,
    })
    self.createButton({
        click_function = "removeFear",
        function_owner = self,
        label          = "0",
        position       = Vector(0,-0.1,0.15),
        width          = 200,
        height         = 200,
        font_size      = 0,
        tooltip        = "Remove Fear"
    })
    self.createButton({
        click_function = "addFear",
        function_owner = self,
        label          = "0",
        position       = Vector(0,-0.1,0.68),
        width          = 200,
        height         = 200,
        font_size      = 0,
        tooltip        = "Add Fear"
    })
    self.createButton({
        click_function = "advanceInvaderCards",
        function_owner = self,
        label          = "",
        position       = Vector(1.78,0,1.874),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 200,
        tooltip        = "Advance Invader Cards"
    })
    self.createButton({
        click_function = "modifyFearPool",
        function_owner = self,
        label          = "",
        position       = Vector(-0.63,0.1,1.36),
        width          = 0,
        height         = 0,
        scale          = Vector(0.18,0.18,0.18),
        font_size      = 160,
        tooltip        = "Add/Remove Fear from Pool"
    })
    self.createButton({
        click_function = "timePasses",
        function_owner = Global,
        label          = "",
        position       = Vector(0.33,0.1,1.36),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 160,
        tooltip        = "Time Passes at the end of each round.\n\nAll Dahan and Invaders are healed to full health."
    })
    self.createButton({
        click_function = "toggleReady",
        function_owner = self,
        label          = "",
        position       = Vector(1.58,0,1.1),
        rotation       = Vector(0,270,0),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 300,
        tooltip        = "Shows all player's ready status\n\nFor use with Events, Fear Card, or other effects that need to be tracked"
    })
    self.createButton({
        click_function = "toggleElements",
        function_owner = self,
        label          = "",
        position       = Vector(1.58,0,-0.85),
        rotation       = Vector(0,270,0),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 300,
        tooltip        = "Sums all players elemental contributions\n\nFor use with Events that read \"Aided by\""
    })
    self.createButton({
        click_function = "flipExploreCard",
        function_owner = self,
        label          = "",
        position       = Vector(1.58,0,1.874),
        rotation       = Vector(0,270,0),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 300,
        tooltip        = "Flip over the top Invader Card"
    })
    placeReadyTokens()
    placeElementTokens()
    updateFearUI()
end

function setupGame()
    self.editButton({
        index = 5,
        label = "<\n<\n<",
        width = 500,
        height = 1500,
    })
    self.editButton({
        index = 6,
        label = "Modify\nFear Pool",
        width = 1000,
        height = 450,
    })
    self.editButton({
        index = 7,
        label = "Time\nPasses",
        width = 600,
        height = 450,
    })
    self.editButton({
        index = 8,
        label = "Ready Helper",
        width = 2100,
        height = 500,
    })
    self.editButton({
        index = 10,
        label = "Explore",
        width = 1500,
        height = 500,
    })
    Wait.time(aidPanelScanLoop,1,-1)
    Wait.time(scanReady,1,-1)

    if Global.getVar("useEventDeck") or #getObjectFromGUID("a16796").getObjects() > 0 then
        UI.setAttribute("panelTurnOrderEvent","active","true")
        self.editButton({
            index = 9,
            label = "Element Helper",
            width = 2100,
            height = 500,
        })
        Wait.time(scanElements,2,-1)
    end

    if Global.getVar("blightedIslandCard") ~= nil then
        UI.setAttribute("panelTurnOrderBlight","active","true")
    end

    if Global.getVar("adversaryCard") ~= nil then
        UI.setAttribute("panelUIAdversary","active","true")
        UI.setAttribute("panelUI","height", UI.getAttribute("panelUI", "height") + 30)
    end
end

function blankFunc()
end
function wt(some)
    local Time = os.clock() + some
    while os.clock() < Time do
        coroutine.yield(0)
    end
end

---- Invader Card Section
function flipExploreCard()
    local objs = Global.getVar("invaderDeckZone").getObjects()
    if #objs ~= 1 then
        -- already have a faceup card
        return
    end
    if objs[1].type == "Deck" then
        objs[1].takeObject({
            position = objs[1].getPosition() + Vector(0,.5,0),
            flip = true,
        })
    elseif objs[1].type == "Card" then
        objs[1].flip()
    end
end

scanLoopTable = {
    Build2 = {
        sourceGUID = "6bc964",
        origin = Vector(-0.23,0.5,-0.137),
        faceDown = false,
    },
    Ravage = {
        origin = Vector(-0.203,0.5,1.872),
        faceDown = false,
    },
    Build = {
        origin = Vector(-0.715,0.5,1.874),
        faceDown = false,
    },
    Explore = {
        origin = Vector(-1.23,0.5,1.874),
        faceDown = false,
    },
}

function advanceInvaderCards()
    for i,v in pairs(scanLoopTable) do
        local source = self
        if v.sourceGUID ~= nil then
            source = getObjectFromGUID(v.sourceGUID)
            if source == nil then goto continueAdvance end
        end
        do
            local hits = Physics.cast({
                origin       = source.positionToWorld(v.origin),
                direction    = Vector(0,1,0),
                type         = 3,
                size         = Vector(1,0.9,1.5),
                orientation  = source.getRotation(),
                max_distance = 0,
                --debug        = true,
            })
            local hitObjects = {}
            for _,hit in pairs(hits) do
                if hit.hit_object ~= source then table.insert(hitObjects,hit.hit_object) end
            end
            for _,hit in pairs(hitObjects) do
                if hit.type == "Card" and hit.is_face_down == v.faceDown then
                    if i == "Build2" then
                        hit.setRotation(Vector(0,90,0))
                        hit.setPositionSmooth(discard)
                    elseif i == "Ravage" then
                        local build2 = UI.getAttribute("panelBuild2","active")
                        if not build2 or build2 == "false" or build2 == "False" then
                            hit.setRotation(Vector(0,90,0))
                            hit.setPositionSmooth(discard)
                        else
                            source = getObjectFromGUID(scanLoopTable["Build2"].sourceGUID)
                            local nextO = source.positionToWorld(scanLoopTable["Build2"].origin)
                            hit.setPositionSmooth(Vector(nextO[1],nextO[2]+0.2,hit.getPosition().z))
                        end
                    elseif i == "Build" then
                        local nextO = source.positionToWorld(scanLoopTable["Ravage"].origin)
                        hit.setPositionSmooth(Vector(nextO[1],hit.getPosition().y,hit.getPosition().z))
                    elseif i == "Explore" then
                        local nextO = source.positionToWorld(scanLoopTable["Build"].origin)
                        hit.setPositionSmooth(Vector(nextO[1],hit.getPosition().y,hit.getPosition().z))
                    end
                end
            end
        end
        ::continueAdvance::
    end
    if Global.getVar("currentPhase") == 3 then
        Global.call("enterSlowPhase", nil)
    end
end
function aidPanelScanLoop()
    local outTable = {}
    local count = 0
    for _,v in pairs(scanLoopTable) do
        local stageTable = {}
        local source = self
        if v.sourceGUID ~= nil then
            source = getObjectFromGUID(v.sourceGUID)
            if source == nil then goto continueLoop end
        end
        do
            local hits = Physics.cast({
                origin       = source.positionToWorld(v.origin),
                direction    = Vector(0,1,0),
                type         = 3,
                size         = Vector(1,0.9,1.5),
                orientation  = source.getRotation(),
                max_distance = 0,
                --debug        = true,
            })
            local hitObjects = {}
            for _,hit in pairs(hits) do
                if hit.hit_object ~= source then table.insert(hitObjects,hit.hit_object) end
            end
            for _,hit in pairs(hitObjects) do
                if hit.type == "Card" and hit.is_face_down == v.faceDown and hit.hasTag("Invader Card") then
                    if hit.loading_custom then
                        -- you can't access script for objects not loaded, so wait for next iteration of loop
                        return
                    end
                    local iType = hit.getVar("cardInvaderType")
                    local escalate = hit.getVar("cardInvaderStage") == 2 and iType ~= "C"
                    table.insert(stageTable,{type=iType,escalate=escalate})
                    count = count + 1
                end
            end
        end
        ::continueLoop::
        table.insert(outTable,stageTable)
    end

    local hits = Physics.cast({
        origin       = self.positionToWorld(scanLoopTable["Explore"].origin),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = Vector(1,0.9,1.5),
        orientation  = self.getRotation(),
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for _,hit in pairs(hits) do
        if hit.hit_object ~= self then table.insert(hitObjects,hit.hit_object) end
    end
    local currentStage = 0
    for _,hit in pairs(hitObjects) do
        if hit.type == "Card" or hit.type == "Deck" then
            local stage = getStage(hit)
            if stage ~= nil then currentStage = stage end
        end
    end
    outTable["Stage"] = currentStage

    numCards = count
    Global.call("updateAidPanel", outTable)
end
function countDiscard()
    local count = 0
    local hits = Physics.cast({
        origin       = discard,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = Vector(1,0.9,1.5),
        orientation  = Vector(0,90,0),
        max_distance = 0,
        --debug        = true,
    })
    for _,hit in pairs(hits) do
        if hit.hit_object ~= self then
            if hit.hit_object.type == "Card" and hit.hit_object.hasTag("Invader Card") then
                count = count + 1
            elseif hit.hit_object.type == "Deck" then
                for _,obj in pairs(hit.hit_object.getObjects()) do
                    for _,tag in pairs(obj.tags) do
                        if tag == "Invader Card" then
                            count = count + 1
                            break
                        end
                    end
                end
            end
        end
    end
    return count
end

function getStage(o)
    if o.type == "Card" then
        local special = o.getVar("special")
        local stage = o.getVar("cardInvaderStage")
        if special then
            stage = stage - 1
        end
        return stage
    elseif o.type == "Deck" then
        for _,obj in pairs(o.getObjects()) do
            local found = false
            for _,tag in pairs(obj.tags) do
                if tag == "Invader Card" then
                    found = true
                    break
                end
            end
            if found then
                local _, finish = string.find(obj.lua_script,"cardInvaderStage=")
                local stage = tonumber(string.sub(obj.lua_script,finish+1))
                -- Prussia early stage 3 should count as stage 2
                if string.find(obj.lua_script,"special=") ~= nil then
                    stage = stage - 1
                end
                return stage
            end
        end
    end
    return nil
end
---- Fear Section
function updateFearUI()
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    self.editButton({index = 1, label = fearPool})
    local attributes = {
        textColor = "#323232",
        text = fearPool
    }
    if fearPool > 9 then
        attributes.offsetXY = "90 5"
        attributes.width = "28%"
    else
        attributes.offsetXY = "75 5"
        attributes.width = "16%"
    end
    UI.setAttributes("panelFearPool", attributes)
    self.editButton({index = 2, label = generatedFear})
    attributes = {
        textColor = "#323232",
        text = generatedFear
    }
    if generatedFear > 9 then
        attributes.offsetXY = "10 5"
        attributes.width = "28%"
    else
        attributes.offsetXY = "25 5"
        attributes.width = "16%"
    end
    UI.setAttributes("panelFearGenerated", attributes)
end
function addFear()
    if not Global.getVar("gameStarted") or Global.getVar("gamePaused") then
        return
    end
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    if fearPool == 1 then
        Global.setVar("fearPool", generatedFear + 1)
        Global.setVar("generatedFear", 0)
        startLuaCoroutine(self, "fearCardEarned")
    else
        Global.setVar("fearPool", fearPool - 1)
        Global.setVar("generatedFear", generatedFear + 1)
    end
    updateFearUI()
end
function removeFear()
    if not Global.getVar("gameStarted") or Global.getVar("gamePaused") then
        return
    end
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    if generatedFear == 0 then
        Global.setVar("fearPool", 1)
        Global.setVar("generatedFear", fearPool - 1)
        broadcastToAll("Fear Card Taken Back! (This is currently not scripted)", {1,0,0})
    else
        Global.setVar("fearPool", fearPool + 1)
        Global.setVar("generatedFear", generatedFear - 1)
    end
    updateFearUI()
end
function modifyFearPool(obj, color, alt_click)
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    if alt_click then
        if fearPool == 1 and generatedFear == 0 then
            broadcastToAll("Fear Pool cannot go to zero", {1,0,0})
            return
        elseif fearPool == 1 then
            Global.setVar("fearPool", generatedFear)
            Global.setVar("generatedFear", 0)
            startLuaCoroutine(self, "fearCardEarned")
        else
            Global.setVar("fearPool", fearPool-1)
        end
    else
        Global.setVar("fearPool", fearPool+1)
    end
    updateFearUI()
end

function fearCardEarned()
    local fearDeckZone = getObjectFromGUID("bd8761")
    local dividerPos = self.positionToWorld(Vector(-1.1,1,0.08))
    local earnedPos = self.positionToWorld(Vector(1.15,1,0.98))
    local completedTable = { false, false }
    local fearDeck = getFearDeck(fearDeckZone)

    earnFearCard(completedTable, fearDeck, earnedPos, dividerPos)
    Wait.condition(function() earnTerrorLevel(completedTable, fearDeck, earnedPos, dividerPos) end, function() return completedTable[1] end)

    Wait.condition(function()
        if #fearDeckZone.getObjects() == 0 then
            broadcastToAll("Fear Victory Achieved!!!", {1,0,0})
        end
    end, function() return completedTable[2] end)
    return 1
end
function getFearDeck(fearDeckZone)
    local fearDeck = nil
    for _,obj in pairs(fearDeckZone.getObjects()) do
        if obj.type == "Deck" then
            local found = false
            for _,o in pairs(obj.getObjects()) do
                for _,tag in pairs(o.tags) do
                    if tag == "Fear" then
                        fearDeck = obj
                        found = true
                        break
                    end
                end
                if found then
                    break
                end
            end
        elseif obj.type == "Card" and obj.hasTag("Fear") then
            fearDeck = obj
        else
            broadcastToAll("Unable to automate Fear Card Earning, extra card/deck detected!", {1,0,0})
            return nil
        end
    end
    return fearDeck
end
function earnFearCard(completedTable, fearDeck, earnedPos, dividerPos)
    -- Handle case where Terror Board is on top of deck
    if fearDeck ~= nil then
        local cardEarned = false
        local emptyDeck = false
        local cardsMoved = 0
        local movesCompleted = 0
        while (not cardEarned and not emptyDeck) do
            local card = nil
            card, cardEarned, emptyDeck = examineCard(fearDeck, dividerPos)
            if cardEarned then
                if fearDeck.type == "Deck" then
                    card = fearDeck.takeObject({
                        position = earnedPos,
                        rotation = Vector(0, 180, 180),
                    })
                else
                    card.setPositionSmooth(earnedPos)
                    card.setRotationSmooth(Vector(0, 180, 180))
                    emptyDeck = true
                end
                broadcastToAll("Fear Card Earned!", Color.SoftBlue)
            end
            cardsMoved = cardsMoved + 1
            Wait.condition(function() movesCompleted = movesCompleted + 1 end, function() return card == nil or not card.isSmoothMoving() end)
        end
        Wait.condition(function() completedTable[1] = true end, function() return movesCompleted == cardsMoved end)
    else
        completedTable[1] = true
    end
end
function earnTerrorLevel(completedTable, fearDeck, earnedPos, dividerPos)
    -- Handle case where Terror Board is uncovered
    if fearDeck ~= nil then
        local topCardIsFear = false
        local emptyDeck = false
        local cardsMoved = 0
        local movesCompleted = 0
        while (not topCardIsFear and not emptyDeck) do
            local card = nil
            card, topCardIsFear, emptyDeck = examineCard(fearDeck, dividerPos)

            cardsMoved = cardsMoved + 1
            Wait.condition(function() movesCompleted = movesCompleted + 1 end, function() return card == nil or not card.isSmoothMoving() end)
        end
        Wait.condition(function() completedTable[2] = true end, function() return movesCompleted == cardsMoved end)
    else
        completedTable[2] = true
    end
end
function examineCard(fearDeck, dividerPos)
    local card
    local emptyDeck = false
    if fearDeck.type == "Deck" then
        if fearDeck.remainder then
            fearDeck = fearDeck.remainder
            card = fearDeck
        else
            card = fearDeck.getObjects()[1]
        end
    else
        card = fearDeck
    end

    if card.guid == "969897" then
        if fearDeck.type == "Deck" then
            card = fearDeck.takeObject({
                position = dividerPos,
                rotation = Vector(0, 180, 180),
            })
        else
            card.setPositionSmooth(dividerPos)
            card.setRotationSmooth(Vector(0, 180, 180))
            emptyDeck = true
        end
        broadcastToAll("Terror Level II Achieved!", {1,0,0})
    elseif card.guid == "f96a71" then
        if fearDeck.type == "Deck" then
            card = fearDeck.takeObject({
                position = dividerPos,
                rotation = Vector(0, 180, 180),
            })
        else
            card.setPositionSmooth(dividerPos)
            card.setRotationSmooth(Vector(0, 180, 180))
            emptyDeck = true
        end
        broadcastToAll("Terror Level III Achieved!", {1,0,0})
    else
        local invaderCard = false
        if fearDeck.type == "Deck" then
            for _,tag in pairs(card.tags) do
                if tag == "Invader Card" then
                    invaderCard = true
                    break
                end
            end
        else
            invaderCard = card.hasTag("Invader Card")
        end

        if invaderCard then
            local pos = self.positionToWorld(scanLoopTable["Build"].origin) + Vector(0,1,-1)
            if fearDeck.type == "Deck" then
                card = fearDeck.takeObject({
                    position = pos,
                    rotation = Vector(0,180,0),
                    -- Russia puts invader cards in this deck at a scale factor of 1.37
                    callback_function = function(obj) obj.scale(1/1.37) invaderCardBroadcast(obj) end,
                })
            else
                -- Russia puts invader cards in this deck at a scale factor of 1.37
                card.scale(1/1.37)
                card.setPositionSmooth(pos)
                card.setRotationSmooth(Vector(0,180,0))
                invaderCardBroadcast(card)
            end
        else
            if fearDeck.type == "Deck" then
                return nil, true, emptyDeck
            else
                return card, true, emptyDeck
            end
        end
    end
    if fearDeck.type == "Deck" then
        return nil, false, emptyDeck
    else
        return card, false, emptyDeck
    end
end
function invaderCardBroadcast(card)
    local stage = card.getVar("cardInvaderStage")
    if stage == 2 then
        if card.getVar("cardInvaderType") == "C" then
            broadcastToAll("Stage II Invader Card was revealed from the Fear Deck", {1,0,0})
        else
            broadcastToAll("Stage II Invader Card was revealed from the Fear Deck\n(You perform the escalation when you resolve the card, not now)", {1,0,0})
        end
    elseif stage == 3 then
        if Global.getVar("adversaryCard2") == nil then
            broadcastToAll("Stage III Invader Card was revealed from the Fear Deck", {1,0,0})
        else
            broadcastToAll("Stage III Invader Card was revealed from the Fear Deck\n(You perform the escalation when you resolve the card, not now)", {1,0,0})
        end
    end
end
---- Ready Helper Section
playerReadyGuids = {
    ["Red"] = "c64244",
    ["Purple"] = "5a7378",
    ["Yellow"] = "f348b7",
    ["Blue"] = "69401f",
    ["Green"] = "a46d80",
    ["Orange"] = "72fd72",
}
function placeReadyTokens()
    for _,v in pairs (playerReadyGuids) do
        local obj = getObjectFromGUID(v)
        local pos = obj.getPosition()
        if pos.x - self.getPosition().x > 10 then
            obj.setPosition(pos - tokenOffset)
        end
        obj.createButton({
            click_function="blankFunc",
            function_owner=self,
            label="",
            position=Vector(3,0.1,0),
            rotation=Vector(0,0,0),
            width=0,
            height=0,
            font_size=500,
            scale = Vector(2,2,2),
        })
    end
end

readyVisible = false
function toggleReady()
    self.editButton({
        index = 8,
        label = "",
        width = 0,
        height = 0,
    })
    local objectsMoved = 0
    local totalObjects = 0
    readyVisible = not readyVisible
    if readyVisible then
        for _,v in pairs (playerReadyGuids) do
            local obj = getObjectFromGUID(v)
            local pos = obj.getPosition()
            obj.setPositionSmooth(pos + tokenOffset)
            totalObjects = totalObjects + 1
            Wait.condition(function() objectsMoved = objectsMoved + 1 end, function() return not obj.isSmoothMoving() end)
        end
        Wait.condition(function() self.editButton({index = 8, label = "Close", width = 2100, height = 500, tooltip = ""}) end, function() return objectsMoved == totalObjects end)
    else
        for _,v in pairs (playerReadyGuids) do
            local obj = getObjectFromGUID(v)
            local pos = obj.getPosition()
            obj.setPositionSmooth(pos - tokenOffset)
            totalObjects = totalObjects + 1
            Wait.condition(function() objectsMoved = objectsMoved + 1 end, function() return not obj.isSmoothMoving() end)
        end
        Wait.condition(function() self.editButton({index = 8, label = "Ready Helper", width = 2100, height = 500, tooltip = "Shows all player's ready status\n\nFor use with Events, Fear Card, or other effects that need to be tracked"}) end, function() return objectsMoved == totalObjects end)
    end
end

function scanReady()
    local selectedColors = Global.getVar("selectedColors")
    local yes = {}
    local no = {}
    for color,guid in pairs(playerReadyGuids) do
        if selectedColors[color] then
            if selectedColors[color].ready.is_face_down then
                getObjectFromGUID(guid).editButton({
                    index=0,
                    label="✓",
                    font_color="Green",
                })
                table.insert(yes, color)
            else
                getObjectFromGUID(guid).editButton({
                    index=0,
                    label="X",
                    font_color="Red",
                })
                table.insert(no, color)
            end
        end
    end
    setReadyUI(yes, no)
end
function setReadyUI(yes, no)
    Global.call("setVisiTableParams", {id="panelReadyYes", table=yes})
    Global.call("setVisiTableParams", {id="panelReadyNo", table=no})
end
---- Element Helper Section
elementGuids = {
    "c5cbb7",
    "cb1318",
    "76f418",
    "107788",
    "f433f0",
    "c44b9c",
    "4a1ff8",
    "6c0a2f",
}

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
function Elements:__tostring()
    return table.concat(self, "")
end

function placeElementTokens()
    for _, v in pairs (elementGuids) do
        local obj = getObjectFromGUID(v)
        local pos = obj.getPosition()
        if pos.x - self.getPosition().x > 10 then
            obj.setPosition(pos - tokenOffset)
        end
        obj.createButton({
            click_function="blankFunc",
            function_owner=self,
            label="0",
            position=Vector(2.75,0,0),
            rotation=Vector(0,0.1,0),
            width=0,
            height=0,
            font_color={1,1,1},
            font_size=500,
            scale = Vector(2,2,2),
        })
    end
end

elementsVisible = false
function toggleElements()
    self.editButton({
        index = 9,
        label = "",
        width = 0,
        height = 0,
    })
    local objectsMoved = 0
    local totalObjects = 0
    elementsVisible = not elementsVisible
    if elementsVisible then
        for _,v in pairs (elementGuids) do
            local obj = getObjectFromGUID(v)
            local pos = obj.getPosition()
            obj.setPositionSmooth(pos + tokenOffset)
            totalObjects = totalObjects + 1
            Wait.condition(function() objectsMoved = objectsMoved + 1 end, function() return not obj.isSmoothMoving() end)
        end
        Wait.condition(function() self.editButton({index = 9, label = "Close", width = 2100, height = 500, tooltip = ""}) end, function() return objectsMoved == totalObjects end)
    else
        for _,v in pairs (elementGuids) do
            local obj = getObjectFromGUID(v)
            local pos = obj.getPosition()
            obj.setPositionSmooth(pos - tokenOffset)
            totalObjects = totalObjects + 1
            Wait.condition(function() objectsMoved = objectsMoved + 1 end, function() return not obj.isSmoothMoving() end)
        end
        Wait.condition(function() self.editButton({index = 9, label = "Element Helper", width = 2100, height = 500, tooltip = "Sums all players elemental contributions\n\nFor use with Events that read \"Aided by\""}) end, function() return objectsMoved == totalObjects end)
    end
end

function scanElements()
    local elements = Elements:new()
    for _, selected in pairs(Global.getVar("selectedColors")) do
        elements:add(selected.nonTokenElements)
    end

    local elementsTable = {"Sun","Moon","Fire","Air","Water","Earth","Plant","Animal"}
    for i,total in ipairs(elements) do
        local elementTokensCount = #getObjectsWithTag(elementsTable[i])
        -- We double count tokens on the Island Board for the Elemental Invocation scenario
        local invocationElementTokensCount = #getObjectsWithAllTags({elementsTable[i],"Invocation Element"})
        getObjectFromGUID(elementGuids[i]).editButton({
            index = 0,
            label = total + elementTokensCount + invocationElementTokensCount,
        })
    end
end