difficulty={[0] = 1, 3, 4, 6, 7, 9, 11}
fearCards={[0] = {0,0,0}, {0,0,1}, {1,0,1}, {1,1,0}, {1,1,1}, {1,2,1}, {2,2,1}}
invaderSetup = true
reminderSetup = true
invaderDeckSetup = true
mapSetup = true
postSetup = true
postSetupComplete = false
hasLossCondition = true
hasUI = true
supporting = false
requirements = true
automatedVictoryDefeat = true

destroyed = 0
checkLossID = 0

function InvaderSetup(params)
    local invaders = nil
    if params.level >= 2 then
        invaders = { explorer = { tooltip = "The first time each Action would Destroy Explorer: If possible, 1 of those Explorer is instead Pushed; 1 Fear when you do so.", color = "4351C8" } }
    end
    return invaders
end

function ReminderSetup(params)
    local reminderTiles = {}
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 1 then
        reminderTiles.ravage = adversaryBag.takeObject({guid="c077b7"})
    end
    if params.level >= 6 then
        reminderTiles.afterRavage = adversaryBag.takeObject({guid="b9fca6"})
    end
    return reminderTiles
end

function InvaderDeckSetup(params)
    if params.level >= 4 then
        for i=1,#params.deck do
            if params.deck[i] == 2 or params.deck[i] == "C" then
                -- assumes stage III cards are always at the end
                local value = table.remove(params.deck, #params.deck)
                table.insert(params.deck, i + 1, value)
            end
        end
    end
    return params.deck
end

function AdversaryUI(params)
    supporting = params.supporting
    local ui = {}

    ui.loss = {}
    ui.loss.tooltip = "Put Beasts Destroyed by Adversary\nrules on this panel. If there are\never more Beasts on this panel than\non the island, the Invaders win."
    ui.loss.counter = {}
    ui.loss.counter.text = "Destroyed Beasts Count: "

    local destroyedBeastsBag = getObjectFromGUID("15836a")
    if destroyedBeastsBag ~= nil then
        destroyedBeastsBag.call("setCallback", {obj=self,func="updateCount"})
        updateCount({count=#destroyedBeastsBag.getObjects()})
    end

    ui.escalation = {}
    ui.escalation.tooltip = "On each board: Add 2 Explorer (total)\namong land with Beasts. If you can't\ninstead add 2 Explorer among lands\nwith Beasts on a different board."

    ui.effects = {}
    ui.invader = {}
    if params.level >= 1 then
        ui.effects[1] = {}
        ui.effects[1].name = "Hunters Seek Shell and Hide"
        ui.effects[1].tooltip = "During Play, Explorer do\n+1 Damage. When Ravage\nadds Blight to a land\n(including cascades),\nDestroy 1 Beasts in that land."
        ui.invader.ravage = true
    end
    if params.level >= 2 then
        ui.effects[2] = {}
        ui.effects[2].name = "A Sense for Impending Disaster"
        ui.effects[2].tooltip = "The first time each Action would\nDestroy Explorer: If possible,\n1 of those Explorer is instead\nPushed; 1 Fear when you do so."
    end
    if params.level >= 3 then
        ui.effects[3] = {}
        ui.effects[3].name = "Competition Among Hunters"
        ui.effects[3].tooltip = "Ravage Cards also match lands\nwith 3 or more Explorer. (If the\nland already matched the Ravage\nCard, it still Ravages just once.)"
    end
    if params.level >= 6 then
        ui.effects[6] = {}
        ui.effects[6].name = "Pressure for Fast Profit"
        ui.effects[6].tooltip = "After the Ravage Step of turn\n2+, on each board where it\nadded no Blight: In the land\nwith the most Explorer (min.\n1), add 1 Explorer and 1 Town."
    end
    return ui
end

function updateCount(params)
    destroyed = params.count
    Global.call("UpdateAdversaryLossCounter",{count=params.count,supporting=supporting})
end

function MapSetup(params)
    if params.level >= 1 then
        for i=#params.pieces,1,-1 do
            local landHasTownOrCity = false
            for _,v in pairs (params.pieces[i]) do
                if string.sub(v,1,4) == "Town" or string.sub(v,1,4) == "City" then
                    landHasTownOrCity = true
                    break
                end
            end
            if not landHasTownOrCity then
                table.insert(params.pieces[i],"Beasts")
                if not params.extra then
                    table.insert(params.pieces[i],"Explorer")
                end
                break
            end
        end
    end
    return params.pieces
end

function PostSetup(params)
    local adversaryBag = Global.getVar("adversaryBag")
    adversaryBag.takeObject({
        guid = "15836a",
        position = self.getPosition() + Vector(1.9, 0, 1.9),
        rotation = {0,180,0},
        callback_function = function(obj)
            obj.setLock(true)
            obj.call("setCallback", {obj=self,func="updateCount"})
            updateCount({count=#obj.getObjects()})
        end,
    })

    if params.level >= 1 then
        local explorerDamage = Global.getVar("explorerDamage")
        local current = tonumber(explorerDamage.TextTool.getValue())
        explorerDamage.TextTool.setValue(tostring(current + 1))
        explorerDamage.TextTool.setFontColor({1,0.2,0.2})
    end

    if params.level >= 5 then
        -- Setup extra invader cards
        local fearDeck = Player["White"].getHandObjects(1)
        local stage3 = setupInvaderCard(fearDeck, 7, Global.getVar("stage3DeckZone"))
        local stage2 = setupInvaderCard(fearDeck, 3, Global.getVar("stage2DeckZone"))
        Wait.condition(function()
            Wait.time(function() postSetupComplete = true end, 0.5)
        end, function()
            return (stage3 == nil or not stage3.isSmoothMoving()) and (stage2 == nil or not stage2.isSmoothMoving())
        end)
    else
        postSetupComplete = true
    end
end
function setupInvaderCard(fearDeck, depth, zoneGuid)
    local count = 0
    for i = #fearDeck, 1, -1 do
        local card = fearDeck[i]
        if card.hasTag("Fear") then
            count = count + 1
            if count == depth then
                local pos = card.getPosition() + Vector(-0.5, 0, 0)
                local obj = getObjectFromGUID(zoneGuid).getObjects()[1]
                if obj ~= nil then
                    if obj.type == "Deck" then
                        return obj.takeObject({
                            position = pos,
                            smooth = false,
                            callback_function = function(o)
                                o.scale(1.37)
                            end,
                        })
                    elseif obj.type == "Card" then
                        obj.scale(1.37)
                        obj.setPosition(pos)
                        return obj
                    end
                end
                return nil
            end
        end
    end
    return nil
end
function getPlayerColor()
    local zoneGuids = {}
    for color,guid in pairs(Global.getTable("elementScanZones")) do
        zoneGuids[guid] = color
    end
    for _,zone in pairs(getObjectFromGUID("a576cc").getZones()) do
        if zoneGuids[zone.guid] then
            return zoneGuids[zone.guid]
        end
    end
    return ""
end

function Requirements(params)
    return params.expansions["Branch & Claw"] or params.expansions["Jagged Earth"]
end

function AutomatedVictoryDefeat()
    if checkLossID ~= nil then
        Wait.stop(checkLossID)
        checkLossID = nil
    end
    checkLossID = Wait.time(checkLoss, 5, -1)
end
function checkLoss()
    local count = 0
    local beasts = getObjectsWithTag("Beasts")
    for _,obj in pairs(beasts) do
        local quantity = obj.getQuantity()
        if quantity == -1 then
            count = count + 1
        else
            count = count + quantity
        end
    end
    if not Global.getVar("SetupChecker").call("isSpiritPickable", {guid="165f82"}) then
        local color = getPlayerColor()
        for _,obj in pairs(getObjectsWithTag("Presence")) do
            -- Presence is not in player area
            if #obj.getZones() == 0 then
                if color == string.sub(obj.getName(),1,-12) then
                    if obj.getQuantity() >= 2 then
                        local bounds = obj.getBounds()
                        local hits = Physics.cast({
                            origin = bounds.center + bounds.offset,
                            direction = Vector(0,-1,0),
                            max_distance = 6,
                            --debug = true,
                        })
                        for _,v in pairs(hits) do
                            if v.hit_object ~= obj and Global.call("isIslandBoard", {obj=v.hit_object}) then
                                count = count + 1
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if destroyed > count then
        Wait.stop(checkLossID)
        Global.call("Defeat", {adversary = self.getName()})
    end
end
