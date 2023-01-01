numCards = 0
discard = Vector(-46.21, 1.5, 0.33)
tokenOffset = Vector(10,0.1,0)
fearCount = {}
fearTimers = {}

function onSave()
    local data_table = {
        discard = discard,
    }
    return JSON.encode(data_table)
end
function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
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
        click_function = "removeFearButton",
        function_owner = self,
        label          = "0",
        position       = Vector(0,-0.1,0.15),
        width          = 200,
        height         = 200,
        font_size      = 0,
        tooltip        = "Remove Fear"
    })
    self.createButton({
        click_function = "addFearButton",
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
    self.createButton({
        click_function = "secondWave",
        function_owner = self,
        label          = "",
        position       = Vector(-0.72,0.1,-1.85),
        rotation       = Vector(0,0,0),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 300,
        tooltip        = "Enable Second Wave for next game"
    })
    self.createButton({
        click_function = "flipEventCard",
        function_owner = self,
        label          = "",
        position       = Vector(0.32,0.1,-0.3),
        rotation       = Vector(0,0,0),
        width          = 0,
        height         = 0,
        scale          = Vector(0.2,0.2,0.2),
        font_size      = 300,
        tooltip        = "Flip over the top Event Card"
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
    if Global.getVar("secondWave") == nil then
        if Global.getVar("scenarioCard") ~= nil then
            self.editButton({
                index = 11,
                position = Vector(-0.72,0.1,-2.85),
            })
        end
        self.editButton({
            index = 11,
            label = "Second Wave?",
            width = 1900,
            height = 500,
        })
    end
    Wait.time(aidPanelScanLoop,1,-1)
    Wait.time(scanReady,1,-1)

    if Global.call("usingEvents") or #Global.getVar("eventDeckZone").getObjects() > 0 then
        UI.setAttribute("panelTurnOrderEvent","active","true")
        self.editButton({
            index = 9,
            label = "Element Helper",
            width = 2100,
            height = 500,
        })
        self.editButton({
            index = 12,
            label = "Event",
            width = 1500,
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

function secondWave()
    self.editButton({
        index = 11,
        label = "",
        width = 0,
        height = 0,
    })
    local pos = Vector(0.75, 0.11, -1.81)
    if Global.getVar("scenarioCard") ~= nil then
        pos = pos + Vector(0, 0, -1.03)
    end
    local secondWave = Global.getVar("scenarioBag").takeObject({
        guid = "e924fe",
        position = self.positionToWorld(pos),
        rotation = Vector(0, 180, 0),
        callback_function = function(obj) obj.call("PostSetup", {}) end,
    })
    secondWave.setScale(Vector(1.71, 1, 1.71))
    secondWave.setLock(true)
end
function flipEventCard()
    EventCard({})
end
function EventCard(params)
    if not Global.getVar("gameStarted") then
        return
    end
    if not Global.call("usingEvents") then
        -- events disabled
        return
    end

    local objs = Global.getVar("eventDeckZone").getObjects()
    if #objs == 0 then
        broadcastToAll("Unable to resolve Event Card, Event Deck empty", Color.SoftYellow)
        return
    elseif #objs > 1 or not objs[1].is_face_down then
        local stop = false
        for _,obj in pairs(objs) do
            if obj.type == "Deck" and not obj.is_face_down then
                stop = true
                break
            elseif obj.type == "Card" and not obj.is_face_down then
                if obj.guid ~= params.ignore then
                    stop = true
                    break
                end
            end
        end
        -- already have a faceup card
        if stop then
            return
        end
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
function discardEvent()
    if not Global.getVar("gameStarted") then
        return
    end
    if not Global.call("usingEvents") then
        -- events disabled
        return
    end

    local objs = Global.getVar("eventDeckZone").getObjects()
    if #objs == 0 or (#objs == 1 and objs[1].is_face_down) then
        -- no faceup card
        return
    end

    for _,obj in pairs(objs) do
        if obj.type == "Card" then
            obj.setPositionSmooth(obj.getPosition()+Vector(-3.58,0.5,0))
            break
        end
    end
end
---- Invader Card Section
function flipExploreCard()
    if not Global.getVar("gameStarted") then
        return
    end
    local function removeSpecial(card)
        local script = card.getLuaScript()
        local start, finish = string.find(script,"special=true\n")
        if start ~= nil then
            card.setLuaScript(script:sub(1, start-1)..script:sub(finish+1, -1))
            card.setVar("special", nil)
        end
    end

    local objs = Global.getVar("invaderDeckZone").getObjects()
    if #objs == 0 then
        broadcastToAll("Unable to Explore, Invader Deck empty", Color.SoftYellow)
        Global.call("Defeat", {invader = true})
        return
    end

    local deck = nil
    local offset = Vector(0, .5, 0)
    for _,obj in pairs(objs) do
        if obj.type == "Deck" then
            deck = obj
        elseif obj.type == "Card" and obj.is_face_down then
            if deck == nil then
                deck = obj
            end
        elseif obj.type == "Card" then
            if obj.getLock() then
                obj.setLock(false)
                offset = offset + Vector(0, 0, -1)
            else
                return
            end
        end
    end

    if deck.type == "Deck" then
        deck.takeObject({
            position = deck.getPosition() + offset,
            flip = true,
            callback_function = removeSpecial,
        })
    elseif deck.type == "Card" then
        deck.setRotationSmooth(Vector(0, 180, 0))
        deck.setPosition(deck.getPosition() + offset)
        removeSpecial(deck)
    end
end

scanLoopTable = {
    Build2 = {
        sourceGUID = "6bc964",
        origin = Vector(-0.23,0.09,0.42),
    },
    Ravage = {
        origin = Vector(-0.203,0.09,2.1),
    },
    Build = {
        origin = Vector(-0.715,0.09,2.1),
    },
    Explore = {
        origin = Vector(-1.23,0.09,2.1),
    },
}

function advanceInvaderCards()
    if not Global.getVar("gameStarted") then
        return
    end
    -- The last setup of setup generally is performing explore and then advancing invader cards
    Global.setVar("setupCompleted", true)

    local prevOffset = Vector(0, 0, 0)
    local currentOffset = Vector(0, 0, 0)
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
                type         = 1,
                max_distance = 0.3,
                --debug        = true,
            })
            local hitObjects = {}
            for _,hit in pairs(hits) do
                if hit.hit_object ~= source then table.insert(hitObjects,hit.hit_object) end
            end
            local depth = 1
            for _,hit in pairs(hitObjects) do
                if hit.type == "Card" and not hit.is_face_down then
                    if hit.getLock() then
                        if i ~= "Ravage" then
                            hit.setLock(false)
                        end
                        hit.setPositionSmooth(hit.getPosition() + Vector(0, 0, 1) * (depth - 1))
                        currentOffset = currentOffset + Vector(0, 0, 1)
                    else
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
                                hit.setPositionSmooth(Vector(nextO[1],nextO[2]+0.3,hit.getPosition().z)+currentOffset+prevOffset)
                            end
                        elseif i == "Build" then
                            local nextO = source.positionToWorld(scanLoopTable["Ravage"].origin)
                            hit.setPositionSmooth(Vector(nextO[1],hit.getPosition().y+0.1,hit.getPosition().z)+currentOffset+prevOffset)
                        elseif i == "Explore" then
                            local nextO = source.positionToWorld(scanLoopTable["Build"].origin)
                            hit.setPositionSmooth(Vector(nextO[1],hit.getPosition().y+0.1,hit.getPosition().z)+currentOffset+prevOffset)
                        end
                    end
                    depth = depth + 1
                elseif i == "Explore" then
                    if hit.type == "Deck" then
                        local objs = hit.getObjects()
                        local invaderCard = false
                        for _,tag in pairs(objs[1].tags) do
                            if tag == "Invader Card" then
                                invaderCard = true
                                break
                            end
                        end
                        if not invaderCard then
                            broadcastToAll(objs[1].name.." was revealed from Invader Deck", Color.SoftYellow)
                        end
                    elseif hit.type == "Card" then
                        if not hit.hasTag("Invader Card") then
                            broadcastToAll(hit.getName().." was revealed from Invader Deck", Color.SoftYellow)
                        end
                    end
                end
            end
            prevOffset = currentOffset * -1
            currentOffset = Vector(0, 0, 0)
        end
        ::continueAdvance::
    end
    discardEvent()
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
                type         = 1,
                max_distance = 0.3,
                --debug        = true,
            })
            local hitObjects = {}
            for _,hit in pairs(hits) do
                if hit.hit_object ~= source then table.insert(hitObjects,hit.hit_object) end
            end
            for _,hit in pairs(hitObjects) do
                if hit.type == "Card" and not hit.is_face_down and hit.hasTag("Invader Card") then
                    if hit.loading_custom then
                        -- you can't access script for objects not loaded, so wait for next iteration of loop
                        return
                    end
                    local iType = hit.getVar("cardInvaderType")
                    local escalate = hit.getVar("cardInvaderStage") == 2 and iType ~= "C" and iType ~= "L"
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
        type         = 1,
        max_distance = 0.3,
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
function countDeck()
    local invaderDeck = Global.getVar("invaderDeckZone").getObjects()[1]
    local count = 0
    if invaderDeck ~= nil and Vector.equals(invaderDeck.getRotation(), Vector(0,180,180), 0.1) then
        if invaderDeck.type == "Deck" then
            for _,obj in pairs(invaderDeck.getObjects()) do
                for _,tag in pairs(obj.tags) do
                    if tag == "Invader Card" then
                        count = count + 1
                        break
                    end
                end
            end
        elseif invaderDeck.type == "Card" and invaderDeck.hasTag("Invader Card") then
            count = 1
        end
    end
    return count
end
function countDiscard()
    local count = 0
    local hits = Physics.cast({
        origin       = discard-Vector(0,0.5,0),
        direction    = Vector(0,1,0),
        type         = 1,
        max_distance = 0.3,
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
function addFearButton(_, color, _)
    addFear({color = color})
end
function addFearUI(player)
    addFear({color = player.color})
end
function addFear(params)
    if not Global.getVar("gameStarted") or Global.getVar("gamePaused") then
        return
    end
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    if fearPool == 1 then
        Global.setVar("fearPool", generatedFear + 1)
        Global.setVar("generatedFear", 0)
        fearCard({earned = true})
    else
        Global.setVar("fearPool", fearPool - 1)
        Global.setVar("generatedFear", generatedFear + 1)
    end
    updateFearUI()
    handlePlayerFear(params.color, 1, params.reason)
end
function removeFearButton(_, color, _)
    removeFear({color = color})
end
function removeFearUI(player)
    removeFear({color = player.color})
end
function removeFear(params)
    if not Global.getVar("gameStarted") or Global.getVar("gamePaused") then
        return
    end
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    if generatedFear == 0 then
        Global.setVar("fearPool", 1)
        Global.setVar("generatedFear", fearPool - 1)
        broadcastToAll("Fear Card Taken Back! (This is currently not scripted)", Color.Red)
    else
        Global.setVar("fearPool", fearPool + 1)
        Global.setVar("generatedFear", generatedFear - 1)
    end
    updateFearUI()
    handlePlayerFear(params.color, -1, params.reason)
end
function handlePlayerFear(color, amount, reason)
    if color == nil then
        color = ""
    end
    if reason == nil then
        reason = ""
    end

    if fearCount[color] == nil then
        fearCount[color] = {}
    end
    if fearCount[color][reason] == nil then
        fearCount[color][reason] = 0
    end
    fearCount[color][reason] = fearCount[color][reason] + amount

    if fearTimers[color] == nil then
        fearTimers[color] = {}
    end
    if fearTimers[color][reason] ~= nil then
        Wait.stop(fearTimers[color][reason])
    end

    local function printFear()
        local output = fearCount[color][reason].." Fear Generated"
        if reason ~= "" then
            output = output.." from "..reason
        end
        output = output.."!"

        if color == "" then
            printToAll(output.." (Global)", Color.White)
        else
            Player[color].print(output, Color.White)
        end
        fearCount[color][reason] = 0
        fearTimers[color][reason] = nil
    end
    fearTimers[color][reason] = Wait.time(printFear, 2)
end
function modifyFearPool(obj, color, alt_click)
    local fearPool = Global.getVar("fearPool")
    local generatedFear = Global.getVar("generatedFear")
    if alt_click then
        if fearPool == 1 and generatedFear == 0 then
            broadcastToAll("Fear Pool cannot go to zero", Color.Red)
            return
        elseif fearPool == 1 then
            Global.setVar("fearPool", generatedFear)
            Global.setVar("generatedFear", 0)
            fearCard({earned = true})
        else
            Global.setVar("fearPool", fearPool-1)
        end
    else
        Global.setVar("fearPool", fearPool+1)
    end
    updateFearUI()
end

function fearCard(params)
    local pos
    if params.earned then
        local handTransform = Player["Black"].getHandTransform(2)
        pos = handTransform.position + Vector(-0.5*handTransform.scale.x, 0, 0)
    else
        pos = Global.getVar("fearDeckSetupZone").getPosition()
    end

    local fearDeck = Player["Black"].getHandObjects(1)
    local dividerPos = self.positionToWorld(Vector(-1.1,1,0.08))
    local foundFearCount = 0
    for i=#fearDeck,1,-1 do
        local card = fearDeck[i]
        if not card.getLock() then
            if card.getName() == "Terror II" or card.getName() == "Terror III" then
                card.setLock(true)
                Wait.frames(function()
                    Wait.frames(function() card.setLock(false) end, 1)
                    card.setPosition(dividerPos)
                    card.setRotation(Vector(0, 180, 0))
                end, 1)
            elseif card.hasTag("Invader Card") then
                local invaderPos = self.positionToWorld(scanLoopTable["Build"].origin) + Vector(0,1,1.15)
                if Global.UI.getAttribute("panelBuild21", "active") == "True" then
                    -- already have 2 build cards
                    invaderPos = invaderPos + Vector(0,0,-2)
                elseif Global.UI.getAttribute("panelBuild11text", "text") ~= "NO ACTION" then
                    -- already have 1 build card
                    invaderPos = invaderPos + Vector(0,0,-1)
                end
                card.setLock(true)
                Wait.frames(function()
                    Wait.frames(function() card.setLock(false) end, 1)
                    -- Russia puts invader cards in this deck at a scale factor of 1.37
                    card.scale(1/1.37)
                    card.setPosition(invaderPos)
                    card.setRotationSmooth(Vector(0,180,0))
                    invaderCardBroadcast(card)
                end, 1)
            elseif card.hasTag("Fear") then
                foundFearCount = foundFearCount + 1
                if foundFearCount == 2 then
                    break
                end
                card.setLock(true)
                Wait.frames(function() card.setLock(false) end, 1)
                card.setPosition(pos)
                if params.earned then
                    broadcastToAll("Fear Card Earned!", Color.SoftBlue)
                else
                    broadcastToAll("Fear Card Removed!", Color.SoftBlue)
                end
            end
        end
    end
    if foundFearCount ~= 2 then
        local scenarioCard = Global.getVar("scenarioCard")
        if scenarioCard == nil or not scenarioCard.getVar("customVictory") then
            Global.setVar("terrorLevel", 4)
            Global.call("Victory")
        end
    end
end
function invaderCardBroadcast(card)
    local stage = card.getVar("cardInvaderStage")
    if stage == 2 then
        if card.getVar("cardInvaderType") == "C" then
            broadcastToAll("Stage II Invader Card was revealed from the Fear Deck", Color.SoftYellow)
        else
            broadcastToAll("Stage II Invader Card was revealed from the Fear Deck\n(You perform the Escalation when you Resolve the card, not now)", Color.SoftYellow)
        end
    elseif stage == 3 then
        if Global.getVar("adversaryCard2") == nil then
            broadcastToAll("Stage III Invader Card was revealed from the Fear Deck", Color.SoftYellow)
        else
            broadcastToAll("Stage III Invader Card was revealed from the Fear Deck\n(You perform the Escalation when you Resolve the card, not now)", Color.SoftYellow)
        end
    end
end
---- Ready Helper Section
playerReadyGuids = {
    {guid = "c64244"},
    {guid = "5a7378"},
    {guid = "f348b7"},
    {guid = "69401f"},
    {guid = "a46d80"},
    {guid = "72fd72"},
}
function placeReadyTokens()
    for _,data in pairs(playerReadyGuids) do
        local obj = getObjectFromGUID(data.guid)
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
        for _,data in pairs(playerReadyGuids) do
            local obj = getObjectFromGUID(data.guid)
            local pos = obj.getPosition()
            obj.setPositionSmooth(pos + tokenOffset)
            totalObjects = totalObjects + 1
            Wait.condition(function() objectsMoved = objectsMoved + 1 end, function() return not obj.isSmoothMoving() end)
        end
        Wait.condition(function() self.editButton({index = 8, label = "Close", width = 2100, height = 500, tooltip = ""}) end, function() return objectsMoved == totalObjects end)
    else
        for _,data in pairs(playerReadyGuids) do
            local obj = getObjectFromGUID(data.guid)
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
    local tints = Global.getTable("Tints")
    for _,data in pairs(playerReadyGuids) do
        local readyToken = getObjectFromGUID(data.guid)
        if data.color and selectedColors[data.color] then
            local tokenTint = tints[data.color].Presence
            if tints[data.color].Token then
                tokenTint = tints[data.color].Token
            end
            readyToken.setInvisibleTo({})
            readyToken.setColorTint(Color.fromHex(tokenTint))

            if selectedColors[data.color].ready and selectedColors[data.color].ready.is_face_down then
                readyToken.editButton({
                    index=0,
                    label="✓",
                    font_color="Green",
                })
                table.insert(yes, data.color)
            else
                readyToken.editButton({
                    index=0,
                    label="X",
                    font_color="Red",
                })
                table.insert(no, data.color)
            end
        else
            readyToken.setInvisibleTo(Player.getColors())
            readyToken.setColorTint(Color.fromHex("#918F8F"))
            readyToken.editButton({index=0, label=""})
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
    for _, v in pairs(elementGuids) do
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
        for _,v in pairs(elementGuids) do
            local obj = getObjectFromGUID(v)
            local pos = obj.getPosition()
            obj.setPositionSmooth(pos + tokenOffset)
            totalObjects = totalObjects + 1
            Wait.condition(function() objectsMoved = objectsMoved + 1 end, function() return not obj.isSmoothMoving() end)
        end
        Wait.condition(function() self.editButton({index = 9, label = "Close", width = 2100, height = 500, tooltip = ""}) end, function() return objectsMoved == totalObjects end)
    else
        for _,v in pairs(elementGuids) do
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
