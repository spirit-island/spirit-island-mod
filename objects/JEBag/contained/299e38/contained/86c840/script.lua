function onObjectSpawn(obj)
    if obj == self then
        obj.createButton({
            click_function = "removeCards",
            function_owner = self,
            label          = "Remove Invader Cards",
            position       = Vector(0,0.3,0.72),
            width          = 1500,
            scale          = Vector(0.65,1,0.65),
            height         = 160,
            font_size      = 150,
            tooltip = "Remove the bottommost Stage II and Stage III cards in the Invader Deck from the game"
        })
    end
end
function removeCards()
    local zone = Global.getVar("invaderDeckZone")
    local obj = zone.getObjects()[1]
    if obj.is_face_down then
        if obj.type == "Deck" then
            local stage2Guid = nil
            local stage3Guid = nil
            for _,card in pairs(obj.getObjects()) do
                local _, finish = string.find(card.lua_script,"cardInvaderStage=")
                local stage = string.sub(card.lua_script,finish+1)
                if stage == "2" then
                    stage2Guid = card.guid
                elseif stage == "3" then
                    stage3Guid = card.guid
                end
            end
            if stage2Guid ~= nil then
                local card = obj.takeObject({guid=stage2Guid})
                card.setPosition(getObjectFromGUID(Global.getVar("stage2DeckZone")).getPosition())
            end
            if stage3Guid ~= nil then
                if obj.remainder then
                    obj.remainder.setPosition(getObjectFromGUID(Global.getVar("stage3DeckZone")).getPosition())
                else
                    local card = obj.takeObject({guid=stage3Guid})
                    card.setPosition(getObjectFromGUID(Global.getVar("stage3DeckZone")).getPosition())
                end
            end
        elseif obj.type == "Card" then
            local stage = obj.getVar("cardInvaderStage")
            if stage == 2 then
                obj.setPosition(getObjectFromGUID(Global.getVar("stage2DeckZone")).getPosition())
            elseif stage == 3 then
                obj.setPosition(getObjectFromGUID(Global.getVar("stage3DeckZone")).getPosition())
            end
        end
    end
end
