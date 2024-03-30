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
        choose = Vector(-0.75, 0.21, 0.9)
        progression = Vector(-0.75, 0.21, 0.4)
        aspect = Vector(-0.75, 0.21, 0.65)
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
            local powerCard = Global.call("getPowerCard", {guid = card[1], major = card[2]})
            if powerCard then
                powerCard.setPositionSmooth(spos + Vector(0, 0.05 + i, 14))
                powerCard.setRotation(Vector(0, 180, 180))
                powerCard.addTag("Progression")
            end
        end
    end

    -- Setup objects in bag (or on top of board)
    local offset = 0
    if obj.type == "Bag" then
        local randomAspect = nil
        if obj.getVar("useAspect") == 1 then
            randomAspect = Global.getVar("SetupChecker").call("RandomAspect", {obj = obj})
            if randomAspect == "" then
                Player[player_color].broadcast("Your random Aspect is no Aspect", Color.SoftBlue)
            else
                Player[player_color].broadcast("Your random Aspect is "..randomAspect, Color.SoftBlue)
            end
        end
        for _, o in pairs(obj.getObjects()) do
            local ob = obj.takeObject({guid = o.guid})
            Wait.frames(function()
                if ob.hasTag("Aspect") then
                    handleAspect(obj, ob, player_color, randomAspect)
                elseif ob.type == "Card" then
                    if ob.getName() == "Progression" then
                        if useProgression then
                            ob.setPositionSmooth(spos + Vector(-3.6, 0.05, 14))
                        else
                            ob.destruct()
                        end
                    else
                        ob.deal(1, player_color)
                    end
                else
                    if ob.getName() == "Incarna" then
                        ob.setColorTint(Color.fromHex(playerTints.Presence))
                        if ob.getDecals() then
                            Global.call("makeSacredSite", {obj = ob, color = player_color})
                        end
                    end
                    local bounds = math.max(ob.getBounds().size.x, 0.04)
                    offset = offset + bounds * xPadding / 2
                    ob.setPositionSmooth(spos + Vector(-placed*xPadding+xOffset-offset, 0.05, 10))
                    offset = offset + bounds * xPadding / 2
                end

                if Global.getVar("gameStarted") and ob.hasTag("Setup") and not ob.getVar("setupComplete") and not ob.hasTag("Aspect") then
                    Wait.frames(function()
                        local success = ob.call("doSetup", {color=player_color})
                        ob.setVar("setupComplete", success)
                    end, 1)
                end
            end, 3)
        end
        obj.destruct()
    else
        for _, o in pairs(castObjects) do
            o.setLock(false)
            if o.hasTag("Aspect") then
                handleAspect(obj, o, player_color)
            elseif o.type == "Deck" then
                o.deal(#o.getObjects(),player_color)
            elseif o.type == "Card" and o.getName() == "Progression" then
                if useProgression then
                    o.setPositionSmooth(spos + Vector(-3.6, 0.05, 14))
                else
                    o.destruct()
                end
            else
                if o.getName() == "Incarna" then
                    o.setColorTint(Color.fromHex(playerTints.Presence))
                    if o.getDecals() then
                        Global.call("makeSacredSite", {obj = o, color = player_color})
                    end
                end
                local bounds = math.max(o.getBounds().size.x, 0.04)
                offset = offset + bounds * xPadding / 2
                o.setPositionSmooth(spos + Vector(-placed*xPadding+xOffset-offset, 0.05, 10))
                offset = offset + bounds * xPadding / 2
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

function handleAspect(spirit, deck, color, randomAspect)
    if deck.type == "Deck" then
        for _,aspect in pairs(deck.getObjects()) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                elseif tag == "Requires Isolate" and not Global.call("usingIsolate") then
                    enabled = false
                elseif tag == "Requires Vitality" and not Global.call("usingVitality") then
                    enabled = false
                elseif tag == "Requires Incarna" and not Global.call("usingIncarna") then
                    enabled = false
                end
            end
            if not enabled then
                deck.takeObject({guid = aspect.guid}).destruct()
                return
            end
        end
    elseif deck.type == "Card" then
        if deck.hasTag("Requires Tokens") and not Global.call("usingSpiritTokens") then
            deck.destruct()
            return
        elseif deck.hasTag("Requires Badlands") and not Global.call("usingBadlands") then
            deck.destruct()
            return
        elseif deck.hasTag("Requires Isolate") and not Global.call("usingIsolate") then
            deck.destruct()
            return
        elseif deck.hasTag("Requires Vitality") and not Global.call("usingVitality") then
            deck.destruct()
            return
        elseif deck.hasTag("Requires Incarna") and not Global.call("usingIncarna") then
            deck.destruct()
            return
        end
    end

    local useAspect = spirit.getVar("useAspect")
    if useAspect == 0 then
        deck.destruct()
    elseif useAspect == 1 then
        if randomAspect then
            if randomAspect == "" then
                deck.destruct()
            else
                local card
                if deck.type == "Deck" then
                    for _, data in pairs(deck.getObjects()) do
                        if data.name == randomAspect then
                            card = deck.takeObject({
                                index = data.index,
                                position = deck.getPosition() + Vector(0,2,0),
                            })
                            if deck.remainder then deck = deck.remainder end
                            break
                        end
                    end
                    deck.destruct()
                elseif deck.type == "Card" then
                    if deck.getName() == randomAspect then
                        card = deck
                    else
                        deck.destruct()
                    end
                end
                if card then
                    card.deal(1, color)
                end
            end
        else
            local count
            if deck.type == "Deck" then
                count = 0
                local aspectNames = {}
                for _,aspect in pairs(deck.getObjects()) do
                    if not aspectNames[aspect.name] then
                        count = count + 1
                        aspectNames[aspect.name] = true
                    end
                end
            elseif deck.type == "Card" then
                count = 1
            end
            local index = math.random(0,count)
            if index == 0 then
                Player[color].broadcast("Your random Aspect is no Aspect", Color.SoftBlue)
                deck.destruct()
            else
                local card
                if deck.type == "Deck" then
                    count = 0
                    local aspectNames = {}
                    for _,aspect in pairs(deck.getObjects()) do
                        if not aspectNames[aspect.name] then
                            count = count + 1
                            aspectNames[aspect.name] = true
                            if count == index then
                                card = deck.takeObject({
                                    guid = aspect.guid,
                                    position = deck.getPosition() + Vector(0,2,0),
                                })
                                card.deal(1, color)
                            end
                        elseif card.getName() == aspect.name then
                            if deck.remainder then
                                deck.deal(1, color)
                                deck = nil
                            else
                                local newCard = deck.takeObject({
                                    guid = aspect.guid,
                                    position = deck.getPosition() + Vector(0,2,0),
                                })
                                newCard.deal(1, color)
                            end
                        end
                    end
                    if deck then
                        if deck.remainder then deck = deck.remainder end
                        deck.destruct()
                    end
                elseif deck.type == "Card" then
                    card = deck
                    card.deal(1, color)
                end
                Player[color].broadcast("Your random Aspect is "..card.getName(), Color.SoftBlue)
            end
        end
    elseif useAspect == 2 then
        local count
        if deck.type == "Deck" then
            count = #deck.getObjects()
        elseif deck.type == "Card" then
            count = 1
        end
        deck.deal(count, color)
    elseif useAspect == 3 then
        local aspectName = spirit.getVar("aspect")
        if deck.type == "Deck" then
            for _, data in pairs(deck.getObjects()) do
                if data.name == aspectName then
                    local card = deck.takeObject({
                        index = data.index,
                        position = deck.getPosition() + Vector(0,2,0),
                    })
                    if deck.remainder then deck = deck.remainder end
                    card.deal(1, color)
                    break
                end
            end
            deck.destruct()
        elseif deck.type == "Card" then
            if deck.getName() == aspectName then
                deck.deal(1, color)
            else
                deck.destruct()
            end
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
