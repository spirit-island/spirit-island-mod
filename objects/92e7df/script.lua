-- Spirit Tile for Bone White's Spirit Island Mod v2 --
useProgression = false
progressionCard = nil
useAspect = 2

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
    local castObjects = upCast(self,1,0.5)
    for _,obj in pairs (castObjects) do
        if string.find(obj.getName(),"Progression") then
            progressionCard = obj
            self.editButton({
                index          = 1,
                label          = "No Progression",
                width          = 2000,
                height         = 500,
            })
        elseif string.find(obj.getName(),"Aspects") then
            self.editButton({
                index          = 2,
                label          = "Include Aspects",
                width          = 2000,
                height         = 500,
            })
        end
    end
    Global.call("addSpirit", {spirit=self})
end

function PickSpirit(params)
    if params.random.aspect then
        useAspect = 1
    end
    SetupSpirit(nil, params.color)
end
function SetupSpirit(object_pick,player_color)
    local xPadding = 1.3
    local xOffset = 1
    local PlayerBag = getObjectFromGUID(Global.getTable("PlayerBags")[player_color])
    if #PlayerBag.getObjects() ~= 0 then
        Global.call("removeSpirit", {spirit=self.guid, color=player_color})
        local castObjects = upCast(self,1,0.5)
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

        -- Setup Aid Tokens
        PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-10.2, 1.3, -4)})
        PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-10.2, 1.3, -2)})
        PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-10.2, 1.3, 0)})
        PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-9.2, 1.1, -5)})
        PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-9.2, 1.1, -3)})
        PlayerBag.takeObject({position = Vector(spos.x,0,spos.z) + Vector(-9.2, 1.1, -1)})

        -- Setup Energy Counter
        local counter = getObjectFromGUID(Global.getVar("counterBag")).takeObject({
            position       = Vector(spos.x,0,spos.z) + Vector(-5,1,5)
        })
        counter.setLock(true)

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
        for i,obj in pairs (castObjects) do
            obj.setLock(false)
            if obj.tag == "Deck" then
                if string.find(obj.getName(),"Aspects") then
                    HandleAspect(obj, player_color)
                else
                    obj.deal(#obj.getObjects(),player_color)
                end
            elseif obj.tag == "Card" and string.find(obj.getName(),"Progression") then
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
        broadcastToColor("You already picked a spirit", player_color, "Red")
    end
end
function HandleAspect(deck, player_color)
    if useAspect == 0 then
        deck.destruct()
    elseif useAspect == 1 then
        local index = math.random(0,#deck.getObjects())
        if index == 0 then
            broadcastToColor("Your random Aspect is no Aspect", player_color, Color.SoftBlue)
            deck.destruct()
        else
            deck.takeObject({
                index = index - 1,
                position = deck.getPosition() + Vector(0,2,0),
                callback_function = function(obj) obj.deal(1, player_color) deck.destruct() broadcastToColor("Your random Aspect is "..obj.getName(), player_color, Color.SoftBlue) end,
            })
            if deck.remainder then deck = deck.remainder end
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
            label          = "Progression",
        })
    else
        self.editButton({
            index          = 1,
            label          = "No Progression",
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
            label          = "No Aspects",
        })
    elseif useAspect == 1 then
        self.editButton({
            index          = 2,
            label          = "Random Aspect",
        })
    else
        self.editButton({
            index          = 2,
            label          = "Include Aspects",
        })
    end
end
-----
function upCast(obj,dist,offset,multi)
    local dist = dist or 1
    local offset = offset or 0
    local multi = multi or 1
    local oPos = obj.getPosition()
    local oBounds = obj.getBoundsNormalized()
    local oRot = obj.getRotation()
    local orig = Vector(oPos[1],oPos[2]+offset,oPos[3])
    local siz = Vector(oBounds.size.x*multi,dist,oBounds.size.z*multi)
    local orient = Vector(oRot[1],oRot[2],oRot[3])
    local hits = Physics.cast({
        origin       = orig,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = siz,
        orientation  = orient,
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for i,v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end