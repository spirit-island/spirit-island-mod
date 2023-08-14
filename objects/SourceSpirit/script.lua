-- Spirit Panel for MJ & iakona's Spirit Island Mod --
useProgression = false
useAspect = 2

function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    getObjectFromGUID("SourceSpirit").call("load", {obj = self, saved_data = saved_data})
end
-- Source Spirit start
function load(params)
    if params.saved_data and params.saved_data ~= "" then
        local loaded_data = JSON.decode(params.saved_data)
        params.obj.setVar("broadcast", loaded_data.broadcast)
        params.obj.setTable("trackElements", loaded_data.trackElements)
        params.obj.setTable("trackEnergy", loaded_data.trackEnergy)
        params.obj.setTable("bonusEnergy", loaded_data.bonusEnergy)
        params.obj.setTable("thresholds", loaded_data.thresholds)
    end

    local success = Global.call("addSpirit", {spirit=params.obj})
    if not success then
        return
    end

    local choose, progression, aspect, rotation
    if params.obj.type == "Bag" then
        choose = Vector(-0.8, 0.21, 0.9)
        progression = Vector(-0.8, 0.21, 0.4)
        aspect = Vector(-0.8, 0.21, 0.65)
        rotation = Vector(0, 0, 0)
    else
        choose = Vector(0.7, -0.1, 0.9)
        progression = Vector(-0.7, -0.1, 0.9)
        aspect = Vector(0.7, -0.2, 0.4)
        rotation = Vector(0, 0, 180)
    end
    params.obj.createButton({
        click_function = "SetupSpirit",
        function_owner = self,
        label          = "Choose Spirit",
        position       = choose,
        rotation       = rotation,
        scale          = Vector(0.2,0.2,0.2),
        width          = 1800,
        height         = 500,
        font_size      = 300,
        color          = {r=146/255, g=229/255, b=175/255},
    })
    params.obj.createButton({
        click_function = "ToggleProgression",
        function_owner = self,
        label          = "",
        position       = progression,
        rotation       = rotation,
        scale          = Vector(0.2,0.2,0.2),
        width          = 0,
        height         = 0,
        font_size      = 300,
        tooltip        = "Enable/Disable Progression Deck",
    })
    params.obj.createButton({
        click_function = "ToggleAspect",
        function_owner = self,
        label          = "",
        position       = aspect,
        rotation       = rotation,
        scale          = Vector(0.2,0.2,0.2),
        width          = 0,
        height         = 0,
        font_size      = 300,
        tooltip        = "Enable/Disable Aspect Deck",
    })

    local hasProgression = false
    local hasAspect = false
    if params.obj.type == "Bag" then
        for _,obj in pairs(params.obj.getObjects()) do
            if obj.name == "Progression" then
                params.obj.setVar("progressionCard", obj.lua_script)
                hasProgression = true
            else
                for _,tag in pairs(obj.tags) do
                    if tag == "Aspect" then
                        hasAspect = true
                        break
                    end
                end
            end
        end
    else
        for _,obj in pairs(upCast(params.obj)) do
            if obj.getName() == "Progression" then
                params.obj.setVar("progressionCard", obj)
                hasProgression = true
            elseif obj.hasTag("Aspect") then
                hasAspect = true
            end
        end
    end
    if hasAspect then
        params.obj.editButton({
            index          = 2,
            label          = "Aspects: All",
            width          = 2300,
            height         = 500,
        })
    end
    if hasProgression then
        params.obj.editButton({
            index          = 1,
            label          = "Progression: No",
            width          = 2200,
            height         = 500,
        })
        if not hasAspect then
            params.obj.editButton({
                index          = 1,
                position       = aspect,
            })
        end
    end
end
function AddAspectButton(params)
    if params.obj.getButtons()[2].width == 0 then
        params.obj.editButton({
            index          = 2,
            label          = "Aspects: All",
            width          = 2300,
            height         = 500,
        })
    end
end
function FindAspects(params)
    if params.obj.type == "Bag" then
        local aspects = {}
        for _,obj in pairs(params.obj.getObjects()) do
            for _,tag in pairs(obj.tags) do
                if tag == "Aspect" then
                    table.insert(aspects, obj)
                    break
                end
            end
        end
        return aspects
    else
        for _,obj in pairs(upCast(params.obj)) do
            if obj.hasTag("Aspect") then
                return obj
            end
        end
    end
    return nil
end
function RandomAspect(params)
    local obj = FindAspects(params)
    if obj == nil then
        return ""
    elseif type(obj) == "table" then
        local newDeck = {}
        for _,aspect in pairs(obj) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                end
            end
            if enabled then
                table.insert(newDeck, aspect)
            end
        end
        local index = math.random(0,#newDeck)
        if index == 0 then
            return ""
        end
        return newDeck[index].name
    elseif obj.type == "Deck" then
        local newDeck = {}
        for _,aspect in pairs(obj.getObjects()) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                end
            end
            if enabled then
                table.insert(newDeck, aspect)
            end
        end
        local index = math.random(0,#newDeck)
        if index == 0 then
            return ""
        end
        return newDeck[index].name
    elseif obj.type == "Card" then
        local count = 1
        if obj.hasTag("Requires Tokens") and not Global.call("usingSpiritTokens") then
            count = 0
        elseif obj.hasTag("Requires Badlands") and not Global.call("usingBadlands") then
            count = 0
        end
        local index = math.random(0,count)
        if index == 0 then
            return ""
        end
        return obj.getName()
    end
    return ""
end
function PickSpirit(params)
    if params.aspect then
        if params.aspect == "Random" then
            params.obj.setVar("useAspect", 1)
        elseif params.aspect == "" then
            params.obj.setVar("useAspect", 0)
        else
            params.obj.setVar("useAspect", 3)
            params.obj.setVar("aspect", params.aspect)
        end
    end
    SetupSpirit(params.obj, params.color)
end

function SetupSpirit(obj, player_color)
    if Global.call("playerHasSpirit", {color = player_color}) then
        Player[player_color].broadcast("You already picked a Spirit!", Color.Red)
    elseif not Global.getTable("playerTables")[player_color] then
        Player[player_color].broadcast("You need to pick a seat first!", Color.Red)
    else
        obj.clearButtons()
        Global.call("pickSpirit", {
            spirit = obj,
            color = player_color
        })
        if Global.getVar("SetupChecker").getVar("setupStarted") and not Global.getVar("gameStarted") then
            Wait.condition(function() setupSpirit(obj, player_color) end, function() return Global.getVar("gameStarted") end)
        else
            setupSpirit(obj, player_color)
        end
    end
end
function setupSpirit(obj, player_color)
    local xPadding = 1.3
    local xOffset = 1
    local castObjects = nil
    local hpos = Player[player_color].getHandTransform().position
    local spirit
    if obj.type == "Bag" then
        for _,o in pairs(obj.getObjects()) do
            for _,tag in pairs(o.tags) do
                if tag == "Spirit" then
                    spirit = obj.takeObject({
                        guid = o.guid,
                        position = hpos + Vector(0,-3.05,12.5),
                        rotation = Vector(0,180,0),
                        smooth = false,
                    })
                    break
                end
            end
        end
        Wait.condition(function() spirit.clearButtons() end, function() return not spirit.loading_custom end)
    else
        castObjects = upCast(obj)
        obj.setPosition(hpos + Vector(0,-3.05,12.5))
        obj.setRotation(Vector(0,180,0))
        spirit = obj
    end
    spirit.setLock(true)
    local spos = spirit.getPosition()
    local snaps = spirit.getSnapPoints()
    local placed = 0

    local objsData = Global.getVar("playerBag").getData().ContainedObjects

    -- Setup Presence
    local playerTints = Global.getTable("Tints")[player_color]
    local color = Color.fromHex(playerTints.Presence)
    local presenceData = objsData[13]
    presenceData.Nickname = player_color.."'s "..presenceData.Nickname
    presenceData.ColorDiffuse.r = color.r
    presenceData.ColorDiffuse.g = color.g
    presenceData.ColorDiffuse.b = color.b
    presenceData.States[2].Nickname = player_color.."'s "..presenceData.States[2].Nickname
    presenceData.States[2].ColorDiffuse.r = color.r
    presenceData.States[2].ColorDiffuse.g = color.g
    presenceData.States[2].ColorDiffuse.b = color.b
    presenceData.States[2].AttachedDecals[1].CustomDecal.Name = player_color.."'s "..presenceData.States[2].AttachedDecals[1].CustomDecal.Name
    presenceData.States[2].AttachedDecals[1].CustomDecal.ImageURL = Global.call("GetSacredSiteUrl", {color = player_color})
    for i = 1,13 do
        local p = snaps[i]
        if i <= #snaps then
            spawnObjectData({
                data = presenceData,
                position = spirit.positionToWorld(p.position),
                rotation = Vector(0, 180, 0),
            })
        else
            spawnObjectData({
                data = presenceData,
                position = spos + Vector(-placed*xPadding+xOffset,0.05,10),
                rotation = Vector(0, 180, 0),
            })
            placed = placed + 1
        end
    end

    -- Setup Ready Token
    local ready = spawnObjectData({
        data = objsData[12],
        position = spos + Vector(7.2, 0.05, 7),
        rotation = Vector(0, 180, 0),
    })

    -- Setup Energy Counter
    local counter = Global.getVar("counterBag").takeObject({
        position = spos + Vector(-5.9, -0.05, 6.8),
        rotation = Vector(0, 0, 0),
    })
    counter.setLock(true)

    -- Setup Element Bags
    local elements = {}
    for i = 1,9 do
        elements[i] = spawnObjectData({
            data = objsData[12-i],
            position = spos + Vector(-8.31, -0.1, 20.21) + Vector(i * 2, 0, 0),
            rotation = Vector(0, 180, 0),
        })
        elements[i].setLock(true)
    end

    -- Setup Reminder Bags
    if playerTints.Token then
        color = Color.fromHex(playerTints.Token)
    end
    local defendData = objsData[2]
    defendData.ColorDiffuse.r = color.r
    defendData.ColorDiffuse.g = color.g
    defendData.ColorDiffuse.b = color.b
    defendData.ContainedObjects[1].Nickname = player_color.."'s "..defendData.ContainedObjects[1].Nickname
    defendData.ContainedObjects[1].ColorDiffuse.r = color.r
    defendData.ContainedObjects[1].ColorDiffuse.g = color.g
    defendData.ContainedObjects[1].ColorDiffuse.b = color.b
    for _,stateData in pairs(defendData.ContainedObjects[1].States) do
        stateData.Nickname = player_color.."'s "..stateData.Nickname
        stateData.ColorDiffuse.r = color.r
        stateData.ColorDiffuse.g = color.g
        stateData.ColorDiffuse.b = color.b
    end
    local defend = spawnObjectData({
        data = defendData,
        position = spos + Vector(-10.31, -0.1, 20.21),
        rotation = Vector(0, 180, 0),
    })
    defend.setLock(true)
    local isolateData = objsData[1]
    isolateData.ColorDiffuse.r = color.r
    isolateData.ColorDiffuse.g = color.g
    isolateData.ColorDiffuse.b = color.b
    isolateData.ContainedObjects[1].Nickname = player_color.."'s "..isolateData.ContainedObjects[1].Nickname
    isolateData.ContainedObjects[1].ColorDiffuse.r = color.r
    isolateData.ContainedObjects[1].ColorDiffuse.g = color.g
    isolateData.ContainedObjects[1].ColorDiffuse.b = color.b
    local isolate = spawnObjectData({
        data = isolateData,
        position = spos + Vector(-8.31, -0.1, 20.21),
        rotation = Vector(0, 180, 0),
    })
    isolate.setLock(true)

    -- Setup Scripting Zone
    local zone = spawnObject({
        type = "ScriptingTrigger",
        position = spos + Vector(0, 0.09, 5.81),
        scale = Vector(22, 0.64, 23),
    })

    -- Setup Progression Deck if enabled
    local useProgression = obj.getVar("useProgression")
    if useProgression then
        local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
        local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
        local progressionCard = obj.getVar("progressionCard")
        local progressionDeck
        if type(progressionCard) == "string" then
            progressionDeck = {}
            for guid,bool in progressionCard:gmatch "{\"(%w%w%w%w%w%w)\", (%l%l%l%l%l?)}" do
                table.insert(progressionDeck, {guid, bool == "true"})
            end
        else
            progressionDeck = progressionCard.getVar("progressionDeck")
        end

        for i,card in pairs(progressionDeck) do
            local deck
            if card[2] then
                deck = majorPowerDeck
            else
                deck = minorPowerDeck
            end

            local found = false
            for _,deckCard in pairs(deck.getObjects()) do
                if deckCard.guid == card[1] then
                    found = true
                    break
                end
            end

            if found then
                local powerCard = deck.takeObject({
                    position = spos + Vector(0, 0.05 + i, 14),
                    rotation = Vector(0,180,180),
                    guid = card[1],
                })
                powerCard.addTag("Progression")
            else
                for _,progression in pairs(getObjectsWithTag("Progression")) do
                    if progression.type == "Deck" then
                        for _,deckCard in pairs(progression.getObjects()) do
                            if deckCard.guid == card[1] then
                                local powerCard = spawnObjectData({
                                    data = progression.getData().ContainedObjects[deckCard.index + 1],
                                    position = Vector(0, 3, 0)
                                })
                                powerCard.setPositionSmooth(spos + Vector(0, 0.05 + i, 14))
                                found = true
                                break
                            end
                        end
                        if found then
                            break
                        end
                    elseif progression.type == "Card" then
                        if progression.guid == card[1] then
                            local powerCard = progression.clone()
                            powerCard.setPositionSmooth(spos + Vector(0, 0.05 + i, 14))
                            found = true
                            break
                        end
                    end
                end
                if not found then
                    broadcastToAll("Unable to find power progression card with guid "..card[1].." for "..obj.getName(), Color.Red)
                end
            end
        end
    end

    -- Setup objects in bag (or on top of board)
    if obj.type == "Bag" then
        local aspects = {}
        for _, o in pairs(obj.getObjects()) do
            for _,tag in pairs(o.tags) do
                if tag == "Aspect" then
                    table.insert(aspects, o)
                    break
                end
            end
        end
        handleAspect(obj, aspects, player_color)
        -- all aspect cards not used will be removed by this point
        for _, o in pairs(obj.getObjects()) do
            local ob = obj.takeObject({guid = o.guid})
            if ob.type == "Card" then
                if ob.getName() == "Progression" then
                    if useProgression then
                        ob.setPositionSmooth(spos + Vector(0, 8.05, 14))
                    else
                        ob.destruct()
                    end
                else
                    Wait.frames(function() ob.deal(1, player_color) end, 1)
                end
            else
                ob.setPositionSmooth(spos + Vector(-placed*xPadding, 0.05, 10))
                placed = placed + 1
            end

            if Global.getVar("gameStarted") and ob.hasTag("Setup") and not ob.getVar("setupComplete") and not ob.hasTag("Aspect") then
                Wait.frames(function()
                    local success = ob.call("doSetup", {color=player_color})
                    ob.setVar("setupComplete", success)
                end, 1)
            end
        end
        obj.destruct()
    else
        for _, o in pairs(castObjects) do
            o.setLock(false)
            if o.hasTag("Aspect") then
                handleAspect(obj, o, player_color)
            elseif o.type == "Deck" then
                Wait.frames(function() o.deal(#o.getObjects(),player_color) end, 1)
            elseif o.type == "Card" and o.getName() == "Progression" then
                if useProgression then
                    o.setPositionSmooth(spos + Vector(0, 8.05, 14))
                else
                    o.destruct()
                end
            else
                o.setPositionSmooth(spos + Vector(-placed*xPadding, 0.05, 10))
                placed = placed + 1
            end

            if Global.getVar("gameStarted") and o.hasTag("Setup") and not o.getVar("setupComplete") and not o.hasTag("Aspect") then
                local o = o  -- luacheck: ignore 423 (deliberate shadowing)
                Wait.frames(function()
                    local success = o.call("doSetup", {color=player_color})
                    o.setVar("setupComplete", success)
                end, 1)
            end
        end
    end

    Wait.condition(function()
        local broadcast = spirit.getVar("broadcast")
        if broadcast ~= nil then
            Player[player_color].broadcast("Spirit - "..spirit.getName(), Color.White)
            Player[player_color].broadcast(broadcast, Color.SoftBlue)
        end
    end, function() return not spirit.loading_custom end)

    Global.call("removeSpirit", {
        color = player_color,
        ready = ready,
        counter = counter,
        elements = elements,
        defend = defend,
        isolate = isolate,
        zone = zone,
    })
end
function ToggleProgression(obj)
    local useProgression = obj.getVar("useProgression")
    useProgression = not useProgression
    obj.setVar("useProgression", useProgression)
    if useProgression then
        obj.editButton({
            index          = 1,
            label          = "Progression: Yes",
        })
    else
        obj.editButton({
            index          = 1,
            label          = "Progression: No",
        })
    end
end
function ToggleAspect(obj, _, alt_click)
    local useAspect = obj.getVar("useAspect")
    if alt_click then
        useAspect = (useAspect - 1) % 3
    else
        useAspect = (useAspect + 1) % 3
    end
    obj.setVar("useAspect", useAspect)
    if useAspect == 0 then
        obj.editButton({
            index          = 2,
            label          = "Aspects: None",
        })
    elseif useAspect == 1 then
        obj.editButton({
            index          = 2,
            label          = "Aspects: Random",
        })
    else
        obj.editButton({
            index          = 2,
            label          = "Aspects: All",
        })
    end
end

function handleAspect(spirit, deck, color)
    if type(deck) == "table" then
        local newDeck = {}
        for _,aspect in pairs(deck) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                end
            end
            if enabled then
                table.insert(newDeck, aspect)
            else
                spirit.takeObject({guid = aspect.guid}).destruct()
            end
        end
        deck = newDeck
    elseif deck.type == "Deck" then
        for _,aspect in pairs(deck.getObjects()) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                end
            end
            if not enabled then
                deck.takeObject({guid = aspect.guid}).destruct()
            end
        end
    else
        if deck.hasTag("Requires Tokens") and not Global.call("usingSpiritTokens") then
            deck.destruct()
        elseif deck.hasTag("Requires Badlands") and not Global.call("usingBadlands") then
            deck.destruct()
        end
    end

    local useAspect = spirit.getVar("useAspect")
    if useAspect == 0 then
        if type(deck) == "table" then
            for _,aspect in pairs(deck) do
                spirit.takeObject({guid = aspect.guid}).destruct()
            end
        else
            deck.destruct()
        end
    elseif useAspect == 1 then
        local count
        if type(deck) == "table" then
            count = #deck
        elseif deck.type == "Deck" then
            count = #deck.getObjects()
        else
            count = 1
        end
        local index = math.random(0,count)
        if index == 0 then
            Player[color].broadcast("Your random Aspect is no Aspect", Color.SoftBlue)
            if type(deck) == "table" then
                for _,aspect in pairs(deck) do
                    spirit.takeObject({guid = aspect.guid}).destruct()
                end
            else
                deck.destruct()
            end
        else
            local name
            if type(deck) == "table" then
                for i,aspect in pairs(deck) do
                    if i == index then
                        name = aspect.name
                    else
                        spirit.takeObject({guid = aspect.guid}).destruct()
                    end
                end
            else
                local card
                if deck.type == "Deck" then
                    card = deck.takeObject({
                        index = index - 1,
                        position = deck.getPosition() + Vector(0,2,0),
                    })
                    if deck.remainder then deck = deck.remainder end
                    deck.destruct()
                else
                    card = deck
                end
                Wait.frames(function() card.deal(1, color) end, 1)
                name = card.getName()
            end
            Player[color].broadcast("Your random Aspect is "..name, Color.SoftBlue)
        end
    elseif useAspect == 2 then
        if type(deck) ~= "table" then
            local count
            if deck.type == "Deck" then
                count = #deck.getObjects()
            else
                count = 1
            end
            Wait.frames(function() deck.deal(count, color) end, 1)
        end
    elseif useAspect == 3 then
        local found = false
        local aspectName = spirit.getVar("aspect")
        if type(deck) == "table" then
            for _,aspect in pairs(deck) do
                if aspect.name == aspectName then
                    found = true
                else
                    spirit.takeObject({guid = aspect.guid}).destruct()
                end
            end
        elseif deck.type == "Deck" then
            for _, data in pairs(deck.getObjects()) do
                if data.name == aspectName then
                    found = true
                    local card = deck.takeObject({
                        index = data.index,
                        position = deck.getPosition() + Vector(0,2,0),
                    })
                    if deck.remainder then deck = deck.remainder end
                    deck.destruct()
                    Wait.frames(function() card.deal(1, color) end, 1)
                    break
                end
            end
        else
            if deck.getName() == aspectName then
                found = true
                Wait.frames(function() deck.deal(1, color) end, 1)
            end
        end
        if not found then
            Player[color].broadcast("Unable to find aspect "..aspectName, Color.Red)
        end
    end
end
function upCast(obj)
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,0.1,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBounds().size,
        orientation  = Vector(0, 180, 180),
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end
