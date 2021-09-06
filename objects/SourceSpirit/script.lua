-- Spirit Panel for MJ & iakona's Spirit Island Mod --
useProgression = false
useAspect = 2

function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    getObjectFromGUID("SourceSpirit").call("load", {obj = self, saved_data = saved_data})
end
-- Source Spirit start
function load(params)
    if params.saved_data ~= "" then
        local loaded_data = JSON.decode(params.saved_data)
        params.obj.setVar("broadcast", loaded_data.broadcast)
        params.obj.setTable("trackElements", loaded_data.trackElements)
        params.obj.setTable("trackEnergy", loaded_data.trackEnergy)
        params.obj.setTable("bonusEnergy", loaded_data.bonusEnergy)
        params.obj.setTable("thresholds", loaded_data.thresholds)
    end
    Global.call("addSpirit", {spirit=params.obj})
    if Global.getVar("gameStarted") then return end

    params.obj.createButton({
        click_function = "SetupSpirit",
        function_owner = self,
        label          = "Choose Spirit",
        position       = Vector(0.7, -0.1, 0.9),
        rotation       = Vector(0,0,180),
        scale = Vector(0.2,0.2,0.2),
        width          = 1800,
        height         = 500,
        font_size      = 300,
    })
    params.obj.createButton({
        click_function = "ToggleProgression",
        function_owner = self,
        label          = "",
        position       = Vector(-0.7, -0.1, 0.9),
        rotation       = Vector(0,0,180),
        scale = Vector(0.2,0.2,0.2),
        width          = 0,
        height         = 0,
        font_size      = 300,
        tooltip        = "Enable/Disable Progression Deck",
    })
    params.obj.createButton({
        click_function = "ToggleAspect",
        function_owner = self,
        label          = "",
        position       = Vector(0.7, -0.2, 0.4),
        rotation       = Vector(0,0,180),
        scale = Vector(0.2,0.2,0.2),
        width          = 0,
        height         = 0,
        font_size      = 300,
        tooltip        = "Enable/Disable Aspect Deck",
    })
    for _,obj in pairs(upCast(params.obj)) do
        if obj.getName() == "Progression" then
            params.obj.setVar("progressionCard", obj)
            params.obj.editButton({
                index          = 1,
                label          = "Progression: No",
                width          = 2200,
                height         = 500,
            })
        elseif obj.hasTag("Aspect") then
            params.obj.editButton({
                index          = 2,
                label          = "Aspects: All",
                width          = 2300,
                height         = 500,
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
    for _,obj in pairs(upCast(params.obj)) do
        if obj.hasTag("Aspect") then
            return obj
        end
    end
    return nil
end
function RandomAspect(params)
    local obj = FindAspects(params)
    if obj == nil then
        return ""
    elseif obj.type == "Deck" then
        local objs = obj.getObjects()
        local index = math.random(0,#objs)
        if index == 0 then
            return ""
        end
        return objs[index].name
    elseif obj.type == "Card" then
        local index = math.random(0,1)
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
    local xPadding = 1.3
    local xOffset = 1
    local PlayerBag = getObjectFromGUID(Global.getTable("PlayerBags")[player_color])
    if #PlayerBag.getObjects() ~= 0 then
        local castObjects = upCast(obj)
        local hpos = Player[player_color].getHandTransform().position
        obj.setPosition(Vector(hpos.x,0,hpos.z) + Vector(0,1.05,12.5))
        obj.setRotation(Vector(0,180,0))
        obj.setLock(true)
        obj.clearButtons()
        local spos = obj.getPosition()
        local snaps = obj.getSnapPoints()
        local placed = 0

        -- Setup Presence
        for i = 1,13 do
            local p = snaps[i]
            if i <= #snaps then
                PlayerBag.takeObject({position = obj.positionToWorld(p.position)})
            else
                PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-placed*xPadding+xOffset,1.1,10)})
                placed = placed + 1
            end
        end

        -- Setup Ready Token
        local ready = PlayerBag.takeObject({
            position = Vector(spos.x,0,spos.z) + Vector(7.2, 1.1, 7),
            rotation = Vector(0, 180, 0),
        })

        -- Setup Energy Counter
        local counter = getObjectFromGUID(Global.getVar("counterBag")).takeObject({position = Vector(spos.x,0,spos.z) + Vector(-6.2,1,6.8)})
        counter.setLock(true)

        -- Setup Element Bags
        local elements = {}
        for i = 1,9 do
            elements[i] = PlayerBag.takeObject({
                position = Vector(spos.x,0,spos.z) + Vector(-8.31, 0.95, 20.21) + Vector(i * 2, 0, 0),
                rotation = Vector(0, 180, 0),
            })
            elements[i].setLock(true)
        end

        -- Setup Reminder Bags
        local defend = PlayerBag.takeObject({
            position = Vector(spos.x,0,spos.z) + Vector(-10.31, 0.95, 20.21),
            rotation = Vector(0, 180, 0),
        })
        defend.setLock(true)
        local isolate = PlayerBag.takeObject({
            position = Vector(spos.x,0,spos.z) + Vector(-8.31, 0.95, 20.21),
            rotation = Vector(0, 180, 0),
        })
        isolate.setLock(true)

        Global.call("removeSpirit", {
            spirit = obj.guid,
            color = player_color,
            ready = ready,
            counter = counter,
            elements = elements,
            defend = defend,
            isolate = isolate
        })

        -- Setup Progression Deck if enabled
        local useProgression = obj.getVar("useProgression")
        if useProgression then
            local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
            local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
            local progressionDeck = obj.getVar("progressionCard").getVar("progressionDeck")
            for i,card in pairs(progressionDeck) do
                if card[2] then
                    majorPowerDeck.takeObject({
                        position = Vector(spos.x,i,spos.z) + Vector(0,1.1,14),
                        rotation = Vector(0,180,180),
                        guid = card[1],
                    })
                else
                    minorPowerDeck.takeObject({
                        position = Vector(spos.x,i,spos.z) + Vector(0,1.1,14),
                        rotation = Vector(0,180,180),
                        guid = card[1],
                    })
                end
            end
        end

        -- Setup objects on top of board
        for _, o in pairs(castObjects) do
            o.setLock(false)
            if o.hasTag("Aspect") then
                handleAspect(obj, o, player_color)
            elseif o.type == "Deck" then
                o.deal(#o.getObjects(),player_color)
            elseif o.type == "Card" and o.getName() == "Progression" then
                if useProgression then
                    o.setPositionSmooth(Vector(spos.x,8,spos.z) + Vector(0,1.1,14))
                else
                    o.destruct()
                end
            elseif Global.getVar("gameStarted") and o.hasTag("Spirit Setup") then
                local o = o  -- luacheck: ignore 423 (deliberate shadowing)
                Wait.frames(function () o.call("doSpiritSetup", {color=player_color}) end, 1)
            else
                o.setPositionSmooth(Vector(spos.x,0,spos.z) + Vector(-placed*xPadding+xOffset,1.1,10))
                placed = placed + 1
            end
        end

        local broadcast = obj.getVar("broadcast")
        if broadcast ~= nil then
            Player[player_color].broadcast(broadcast, Color.SoftBlue)
        end
    else
        Player[player_color].broadcast("You already picked a spirit", "Red")
    end
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
    local useAspect = spirit.getVar("useAspect")
    if useAspect == 0 then
        deck.destruct()
    elseif useAspect == 1 then
        local count
        if deck.type == "Deck" then
            count = #deck.getObjects()
        else
            count = 1
        end
        local index = math.random(0,count)
        if index == 0 then
            Player[color].broadcast("Your random Aspect is no Aspect", Color.SoftBlue)
            deck.destruct()
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
            card.deal(1, color)
            Player[color].broadcast("Your random Aspect is "..card.getName(), Color.SoftBlue)
        end
    elseif useAspect == 2 then
        local count
        if deck.type == "Deck" then
            count = #deck.getObjects()
        else
            count = 1
        end
        deck.deal(count, color)
    elseif useAspect == 3 then
        local found = false
        local aspect = spirit.getVar("aspect")
        if deck.type == "Deck" then
            for _, data in pairs(deck.getObjects()) do
                if data.name == aspect then
                    found = true
                    local card = deck.takeObject({
                        index = data.index,
                        position = deck.getPosition() + Vector(0,2,0),
                    })
                    if deck.remainder then deck = deck.remainder end
                    deck.destruct()
                    card.deal(1, color)
                    break
                end
            end
        else
            if deck.getName() == aspect then
                found = true
                deck.deal(1, color)
            end
        end
        if not found then
            Player[color].broadcast("Unable to find aspect "..aspect, "Red")
        end
    end
end
function upCast(obj)
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,0.1,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBoundsNormalized().size,
        orientation  = Vector(0, 180, 180),
        --debug        = true,
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end
