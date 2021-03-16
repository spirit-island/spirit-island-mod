difficulty={[0] = 1, 3, 4, 6, 7, 9, 11}
fearCards={[0] = {0,0,0}, {0,0,1}, {1,0,1}, {1,1,0}, {1,1,1}, {1,2,1}, {2,2,1}}
preSetup = true
preSetupComplete = false
reminderSetup = true
invaderDeckSetup = true
mapSetup = true
postSetup = true
postSetupComplete = false
hasLossCondition = true
hasUI = true
supporting = false
requirements = true

destroyed = 0
checkLossID = 0

function onLoad(saved_data)
    Color.Add("SoftYellow", Color.new(0.9,0.7,0.1))
end

function PreSetup(params)
    if params.level >= 1 then
        local explorerDamage = Global.getVar("explorerDamage")
        local current = tonumber(explorerDamage.TextTool.getValue())
        explorerDamage.TextTool.setValue(tostring(current + 1))
        explorerDamage.TextTool.setFontColor({1,0.2,0.2})
    end
    if params.level >= 2 then
        local adversaryBag = Global.getVar("adversaryBag")
        local explorerBag = Global.getVar("explorerBag")
        local explorerBagPosition = explorerBag.getPosition()
        local newGuid = "3b674d"
        if explorerBag.guid == "bf89e8" then
            newGuid = "24908a"
        end
        explorerBag.destruct()
        explorerBag = adversaryBag.takeObject({
            guid = newGuid,
            position = explorerBagPosition,
            rotation = {0,180,0},
            smooth = false,
            callback_function = function(obj) obj.setLock(true) end,
        })
        Global.setVar("explorerBag", explorerBag)
        Wait.condition(function() preSetupComplete = true end, function() return not explorerBag.isSmoothMoving() end)
    else
        preSetupComplete = true
    end
end

function ReminderSetup(params)
    local reminderTiles = {}
    if params.level >= 1 then
        reminderTiles.ravage = "c077b7"
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
    checkLossID = Wait.time(checkLoss, 5, -1)

    ui.escalation = {}
    ui.escalation.tooltip = "On each board: Add 2 Explorer (total)\namong land with Beasts. If you can't\ninstead add 2 Explorer among lands\nwith Beasts on a different board."
    if params.level >= 1 then
        ui.one = {}
        ui.one.name = "Hunters Seek Shell and Hide"
        ui.one.tooltip = "During Play, Explorer do\n+1 Damage. When Ravage\nadds Blight to a land\n(including cascades),\nDestroy 1 Beasts in that land."
    end
    if params.level >= 2 then
        ui.two = {}
        ui.two.name = "A Sense for Impending Disaster"
        ui.two.tooltip = "The first time each Action would\nDestroy Explorer: If possible,\n1 of those Explorer is instead\nPushed; 1 Fear when you do so."
    end
    if params.level >= 3 then
        ui.three = {}
        ui.three.name = "Competition Among Hunters"
        ui.three.tooltip = "Ravage Cards also match lands\nwith 3 or more Explorer. (If the\nland already matched the Ravage\nCard, it still Ravages just once.)"
    end
    if params.level >= 6 then
        ui.six = {}
        ui.six.name = "Pressure for Fast Profit"
        ui.six.tooltip = "After the Ravage Step of turn\n2+, on each board where it\nadded no Blight: In the land\nwith the most Explorer (min.\n1), add 1 Explorer and 1 Town."
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

    if params.level >= 6 then
        local aidBoard = Global.getVar("aidBoard")
        adversaryBag.takeObject({
            guid = "b9fca6",
            position = aidBoard.positionToWorld(Vector(-0.47,-0.09,1.9)),
            rotation = {0,90,0},
            callback_function = function(obj) obj.setLock(true) end,
        })
    end

    if params.level >= 5 then
        -- Setup extra invader cards
        local fearDeckZone = getObjectFromGUID(Global.getVar("fearDeckZone"))
        local count = #fearDeckZone.getObjects()[1].getObjects()
        local fearCards = Global.getVar("fearCards")
        setupInvaderCard(fearDeckZone, fearCards, 7, Global.getVar("stage3DeckZone"))
        Wait.condition(function()
            setupInvaderCard(fearDeckZone, fearCards, 3, Global.getVar("stage2DeckZone"))
            Wait.condition(function() postSetupComplete = true end, function()
                local objs = fearDeckZone.getObjects() return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == count + 2
            end)
        end, function()
            local objs = fearDeckZone.getObjects() return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == count + 1
        end)
    else
        postSetupComplete = true
    end
end
function setupInvaderCard(fearDeckZone, fearCards, depth, zoneGuid)
    local count = depth
    if fearCards[1] < depth then
        count = count + 1
        if fearCards[1] + 1 + fearCards[2] < depth then
            count = count + 1
        end
    end
    local fearDeck = fearDeckZone.getObjects()[1]
    for i=1,count do
        fearDeck.takeObject({
            position = fearDeck.getPosition() + Vector(0,2+(count-i)*0.5,0)
        })
    end
    local obj = getObjectFromGUID(zoneGuid).getObjects()[1]
    if obj ~= nil then
        if obj.type == "Deck" then
            obj.takeObject({
                position = obj.getPosition() + Vector(0,1,0),
                callback_function = function(card)
                    card.scale(1.37)
                    card.setPosition(fearDeck.getPosition() + Vector(0,0.1,0))
                end,
            })
        elseif obj.type == "Card" then
            obj.scale(1.37)
            obj.setPosition(fearDeck.getPosition() + Vector(0,0.1,0))
        end
    end
end
function checkLoss()
    local beasts = #getObjectsWithTag("Beasts")
    local SetupChecker = Global.getVar("SetupChecker")
    if SetupChecker.call("isSpiritPickable", {guid="f7422a"}) then
        -- TODO figure out a more elegant solution here
        beasts = beasts - 1
    end
    if SetupChecker.call("isSpiritPickable", {guid="a576cc"}) then
        -- TODO figure out a more elegant solution here
        beasts = beasts - 1
    end
    if SetupChecker.call("isSpiritPickable", {guid="b35fd5"}) then
        -- TODO figure out a more elegant solution here
        beasts = beasts - 1
    end
    if destroyed > beasts then
        broadcastToAll("Russia wins via Additional Loss Condition!", "Red")
        Wait.stop(checkLossID)
    end
end

function Requirements(params)
    return params.expansions.bnc or params.expansions.je
end