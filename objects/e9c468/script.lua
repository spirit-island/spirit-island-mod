-- Spirit Tile for Bone White's Spirit Island Mod v2 --
useProgression = false
progressionCard = nil
useAspect = 2
aspect = nil

function onLoad()
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    if Global.getVar("gameStarted") then return end
    self.createButton({
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
    self.createButton({
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
    self.createButton({
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
    local castObjects = upCast(self)
    for _,obj in pairs (castObjects) do
        if string.find(obj.getName(),"Progression") then
            progressionCard = obj
            self.editButton({
                index          = 1,
                label          = "Progression: No",
                width          = 2200,
                height         = 500,
            })
        elseif string.find(obj.getName(),"Aspects") then
            self.editButton({
                index          = 2,
                label          = "Aspects: All",
                width          = 2300,
                height         = 500,
            })
        end
    end
    Global.call("addSpirit", {spirit=self})
end

function RandomAspect()
    for _,obj in pairs(upCast(self)) do
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
function PickSpirit(params)
    if params.aspect then
        if params.aspect == "Random" then
            useAspect = 1
        elseif params.aspect == "" then
            useAspect = 0
        else
            useAspect = 3
            aspect = params.aspect
        end
    end
    SetupSpirit(nil, params.color)
end
function SetupSpirit(object_pick,player_color)
    local xPadding = 1.3
    local xOffset = 1
    local PlayerBag = getObjectFromGUID(Global.getTable("PlayerBags")[player_color])
    if #PlayerBag.getObjects() ~= 0 then
        local castObjects = upCast(self)
        local hpos = Player[player_color].getHandTransform().position
        self.setPosition(Vector(hpos.x,0,hpos.z) + Vector(0,1.05,11.8))
        self.setRotation(Vector(0,180,0))
        self.setLock(true)
        self.clearButtons()
        local spos = self.getPosition()
        local snaps = self.getSnapPoints()
        local placed = 0

        -- Setup Presence
        for i = 1,13 do
            local p = snaps[i]
            if i <= #snaps then
                PlayerBag.takeObject({position = self.positionToWorld(p.position)})
            else
                PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-placed*xPadding+xOffset,1.1,10)})
                placed = placed + 1
            end
        end

        -- Setup Ready Token
        local ready = PlayerBag.takeObject({
            position = Vector(spos.x,0,spos.z) + Vector(7, 1.1, 7),
            rotation = Vector(0, 180, 180),
        })

        -- Setup Energy Counter
        local counter = getObjectFromGUID(Global.getVar("counterBag")).takeObject({position = Vector(spos.x,0,spos.z) + Vector(-5,1,5)})
        counter.setLock(true)

        Global.call("removeSpirit", {spirit=self.guid, color=player_color, ready=ready, counter=counter})

        -- Setup Progression Deck if enabled
        if useProgression then
            local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
            local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
            local progressionDeck = progressionCard.getVar("progressionDeck")
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
        for i,obj in pairs(castObjects) do
            obj.setLock(false)
            if obj.type == "Deck" then
                if obj.getName() == "Aspects" then
                    HandleAspect(obj, player_color)
                else
                    obj.deal(#obj.getObjects(),player_color)
                end
            elseif obj.type == "Card" and obj.getName() == "Progression" then
                if useProgression then
                    obj.setPositionSmooth(Vector(spos.x,8,spos.z) + Vector(0,1.1,14))
                else
                    obj.destruct()
                end
            else
                obj.setPositionSmooth(Vector(spos.x,0,spos.z) + Vector(-placed*xPadding+xOffset,1.1,10))
                placed = placed + 1
            end
        end
    else
        Player[player_color].broadcast("You already picked a spirit", "Red")
    end
end
function HandleAspect(deck, player_color)
    if useAspect == 0 then
        deck.destruct()
    elseif useAspect == 1 then
        local index = math.random(0,#deck.getObjects())
        if index == 0 then
            Player[player_color].broadcast("Your random Aspect is no Aspect", Color.SoftBlue)
            deck.destruct()
        else
            deck.takeObject({
                index = index - 1,
                position = deck.getPosition() + Vector(0,2,0),
                callback_function = function(obj) obj.deal(1, player_color) deck.destruct() Player[player_color].broadcast("Your random Aspect is "..obj.getName(), Color.SoftBlue) end,
            })
            if deck.remainder then deck = deck.remainder end
        end
    elseif useAspect == 3 then
        local found = false
        for index, data in pairs(deck.getObjects()) do
            if data.name == aspect then
                found = true
                deck.takeObject({
                    index = data.index,
                    position = deck.getPosition() + Vector(0,2,0),
                    callback_function = function(obj) obj.deal(1, player_color) deck.destruct() end,
                })
                if deck.remainder then deck = deck.remainder end
                break
            end
        end
        if not found then
            deck.destruct()
            Player[player_color].broadcast("Unable to find aspect "..aspect, "Red")
        end
    else
        deck.deal(#deck.getObjects(), player_color)
    end
end

function ToggleProgression()
    useProgression = not useProgression
    if useProgression then
        self.editButton({
            index          = 1,
            label          = "Progression: Yes",
        })
    else
        self.editButton({
            index          = 1,
            label          = "Progression: No",
        })
    end
end
function ToggleAspect(_, _, alt_click)
    if alt_click then
        useAspect = (useAspect - 1) % 3
    else
        useAspect = (useAspect + 1) % 3
    end
    if useAspect == 0 then
        self.editButton({
            index          = 2,
            label          = "Aspects: None",
        })
    elseif useAspect == 1 then
        self.editButton({
            index          = 2,
            label          = "Aspects: Random",
        })
    else
        self.editButton({
            index          = 2,
            label          = "Aspects: All",
        })
    end
end
-----
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
    for i,v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end
