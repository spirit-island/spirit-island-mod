function onLoad()
    self.createButton({
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
function removeCards(card)
    local zone = Global.getVar("invaderDeckZone")
    local deck = zone.getObjects()[1]
    if deck.is_face_down then
        if deck.type == "Deck" then
            local stage2Guid = nil
            local stage3Guid = nil
            for _,obj in pairs(deck.getObjects()) do
                local start, finish = string.find(obj.lua_script,"cardInvaderStage=")
                if start ~= nil then
                    local stage = string.sub(obj.lua_script,finish+1,finish+1)
                    if stage == "2" then
                        stage2Guid = obj.guid
                    elseif stage == "3" then
                        stage3Guid = obj.guid
                    end
                end
            end
            if stage2Guid ~= nil then
                deck.takeObject({guid=stage2Guid}).setPosition(getObjectFromGUID(Global.getVar("stage2DeckZone")).getPosition())
            end
            if stage3Guid ~= nil then
                if deck.remainder then
                    deck.remainder.setPosition(getObjectFromGUID(Global.getVar("stage3DeckZone")).getPosition())
                else
                    deck.takeObject({guid=stage3Guid}).setPosition(getObjectFromGUID(Global.getVar("stage3DeckZone")).getPosition())
                end
            end
        elseif deck.type == "Card" then
            local stage = deck.getVar("cardInvaderStage")
            if stage == 2 then
                deck.setPosition(getObjectFromGUID(Global.getVar("stage2DeckZone")).getPosition())
            elseif stage == 3 then
                deck.setPosition(getObjectFromGUID(Global.getVar("stage3DeckZone")).getPosition())
            end
        end
    end
    Global.call("removeButtons", {obj = card, click_function = "removeCards", function_owner = self})
end
