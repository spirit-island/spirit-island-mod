-- Spirit Panel for MJ & iakona's Spirit Island Mod --
useProgression = false
useAspect = 2

function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    sourceSpirit = getObjectFromGUID("SourceSpirit")
    sourceSpirit.call("load", {obj = self, saved_data = saved_data})
end

function RandomAspect()
    return sourceSpirit.call("randomAspect", {obj = self})
end
function PickSpirit(params)
    sourceSpirit.call("pickSpirit", {obj = self, color = params.color, aspect = params.aspect})
end
function SetupSpirit(_, player_color)
    sourceSpirit.call("setupSpirit", {obj = self, color = player_color})
end
function ToggleProgression()
    sourceSpirit.call("toggleProgression", {obj = self})
end
function ToggleAspect(_, _, alt_click)
    sourceSpirit.call("toggleAspect", {obj = self, alt_click = alt_click})
end
-- Source Spirit start
function load(params)
    if params.saved_data ~= "" then
        local loaded_data = JSON.decode(params.saved_data)
        params.obj.setVar("broadcast", loaded_data.broadcast)
    end
    if Global.getVar("gameStarted") then return end

    params.obj.createButton({
        click_function = "SetupSpirit",
        function_owner = params.obj,
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
        function_owner = params.obj,
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
        function_owner = params.obj,
        label          = "",
        position       = Vector(0.7, -0.2, 0.4),
        rotation       = Vector(0,0,180),
        scale = Vector(0.2,0.2,0.2),
        width          = 0,
        height         = 0,
        font_size      = 300,
        tooltip        = "Enable/Disable Aspect Deck",
    })
    local castObjects = upCast(params.obj)
    for _,obj in pairs (castObjects) do
        if string.find(obj.getName(),"Progression") then
            params.obj.setVar("progressionCard", obj)
            params.obj.editButton({
                index          = 1,
                label          = "Progression: No",
                width          = 2200,
                height         = 500,
            })
        elseif string.find(obj.getName(),"Aspects") then
            params.obj.editButton({
                index          = 2,
                label          = "Aspects: All",
                width          = 2300,
                height         = 500,
            })
        end
    end
    Global.call("addSpirit", {spirit=params.obj})
end
function randomAspect(params)
    for _,obj in pairs(upCast(params.obj)) do
        if obj.type == "Deck" and obj.getName() == "Aspects" then
            local objs = obj.getObjects()
            local index = math.random(0,#objs)
            if index == 0 then
                return ""
            end
            return objs[index].name
        end
    end
    return nil
end
function pickSpirit(params)
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
    setupSpirit({obj = params.obj, color = params.color})
end
function setupSpirit(params)
    local xPadding = 1.3
    local xOffset = 1
    local PlayerBag = getObjectFromGUID(Global.getTable("PlayerBags")[params.color])
    if #PlayerBag.getObjects() ~= 0 then
        local castObjects = upCast(params.obj)
        local hpos = Player[params.color].getHandTransform().position
        params.obj.setPosition(Vector(hpos.x,0,hpos.z) + Vector(0,1.05,13.9))
        params.obj.setRotation(Vector(0,180,0))
        params.obj.setLock(true)
        params.obj.clearButtons()
        local spos = params.obj.getPosition()
        local snaps = params.obj.getSnapPoints()
        local placed = 0

        -- Setup Presence
        for i = 1,13 do
            local p = snaps[i]
            if i <= #snaps then
                PlayerBag.takeObject({position = params.obj.positionToWorld(p.position)})
            else
                PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-placed*xPadding+xOffset,1.1,10)})
                placed = placed + 1
            end
        end

        -- Setup Ready Token
        local ready = PlayerBag.takeObject({
            position = Vector(spos.x,0,spos.z) + Vector(7.5, 1.1, 6.5),
            rotation = Vector(0, 180, 0),
        })

        -- Setup Energy Counter
        local counter = getObjectFromGUID(Global.getVar("counterBag")).takeObject({position = Vector(spos.x,0,spos.z) + Vector(-5,1,5)})
        counter.setLock(true)

        Global.call("removeSpirit", {spirit=params.obj.guid, color=params.color, ready=ready, counter=counter})

        -- Setup Progression Deck if enabled
        local useProgression = params.obj.getVar("useProgression")
        if useProgression then
            local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
            local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
            local progressionDeck = params.obj.getVar("progressionCard").getVar("progressionDeck")
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
        for _, obj in pairs(castObjects) do
            obj.setLock(false)
            if obj.type == "Deck" then
                if obj.getName() == "Aspects" then
                    handleAspect(params.obj, obj, params.color)
                else
                    obj.deal(#obj.getObjects(),params.color)
                end
            elseif obj.type == "Card" and obj.getName() == "Progression" then
                if useProgression then
                    obj.setPositionSmooth(Vector(spos.x,8,spos.z) + Vector(0,1.1,14))
                else
                    obj.destruct()
                end
            elseif Global.getVar("gameStarted") and obj.hasTag("Spirit Setup") then
                local obj = obj  -- luacheck: ignore 423 (deliberate shadowing)
                Wait.frames(function () obj.call("doSpiritSetup", {color=params.color}) end, 1)
            else
                obj.setPositionSmooth(Vector(spos.x,0,spos.z) + Vector(-placed*xPadding+xOffset,1.1,10))
                placed = placed + 1
            end
        end

        local broadcast = params.obj.getVar("broadcast")
        if broadcast ~= nil then
            Player[params.color].broadcast(broadcast, Color.SoftBlue)
        end
    else
        Player[params.color].broadcast("You already picked a spirit", "Red")
    end
end
function handleAspect(spirit, deck, color)
    local useAspect = spirit.getVar("useAspect")
    if useAspect == 0 then
        deck.destruct()
    elseif useAspect == 1 then
        local index = math.random(0,#deck.getObjects())
        if index == 0 then
            Player[color].broadcast("Your random Aspect is no Aspect", Color.SoftBlue)
            deck.destruct()
        else
            deck.takeObject({
                index = index - 1,
                position = deck.getPosition() + Vector(0,2,0),
                callback_function = function(obj) obj.deal(1, color) deck.destruct() Player[color].broadcast("Your random Aspect is "..obj.getName(), Color.SoftBlue) end,
            })
            if deck.remainder then deck = deck.remainder end
        end
    elseif useAspect == 3 then
        local found = false
        local aspect = spirit.getVar("aspect")
        for _, data in pairs(deck.getObjects()) do
            if data.name == aspect then
                found = true
                deck.takeObject({
                    index = data.index,
                    position = deck.getPosition() + Vector(0,2,0),
                    callback_function = function(obj) obj.deal(1, color) deck.destruct() end,
                })
                if deck.remainder then deck = deck.remainder end
                break
            end
        end
        if not found then
            deck.destruct()
            Player[color].broadcast("Unable to find aspect "..aspect, "Red")
        end
    else
        deck.deal(#deck.getObjects(), color)
    end
end

function toggleProgression(params)
    local useProgression = params.obj.getVar("useProgression")
    useProgression = not useProgression
    params.obj.setVar("useProgression", useProgression)
    if useProgression then
        params.obj.editButton({
            index          = 1,
            label          = "Progression: Yes",
        })
    else
        params.obj.editButton({
            index          = 1,
            label          = "Progression: No",
        })
    end
end
function toggleAspect(params)
    local useAspect = params.obj.getVar("useAspect")
    if params.alt_click then
        useAspect = (useAspect - 1) % 3
    else
        useAspect = (useAspect + 1) % 3
    end
    params.obj.setVar("useAspect", useAspect)
    if useAspect == 0 then
        params.obj.editButton({
            index          = 2,
            label          = "Aspects: None",
        })
    elseif useAspect == 1 then
        params.obj.editButton({
            index          = 2,
            label          = "Aspects: Random",
        })
    else
        params.obj.editButton({
            index          = 2,
            label          = "Aspects: All",
        })
    end
end

function upCast(obj)
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,0.1,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBoundsNormalized().size,
        orientation  = obj.getRotation(),
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end
