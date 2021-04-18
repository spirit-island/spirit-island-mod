difficulty={[0] = 2, 3, 5, 7, 8, 9, 10}
fearCards={[0] = {0,0,0}, {0,0,0}, {0,1,0}, {1,1,0}, {1,1,1}, {1,2,1}, {1,2,2}}
preSetup = true
preSetupComplete = false
reminderSetup = true
limitSetup = true
limitSetupComplete = false
mapSetup = true
postSetup = true
postSetupComplete = false
hasLossCondition = true
hasUI = true
supporting = false
requirements = true
thematicRebellion = false

slaveRebellion = "1f0327"

function onSave()
    local data_table = {
        thematicRebellion = thematicRebellion
    }
    return JSON.encode(data_table)
end
function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        thematicRebellion = loaded_data.thematicRebellion
    end
end

function onObjectSpawn(obj)
    if obj.guid == slaveRebellion then
        obj.createButton({
            click_function = "setupSlaveRebellion",
            function_owner = self,
            label          = "Return to Deck",
            position       = Vector(0,0.3,1.43),
            width          = 1100,
            scale          = Vector(0.65,1,0.65),
            height         = 160,
            font_size      = 150,
            tooltip = "Return Slave Rebellion back to the Event Deck as per Setup"
        })
    end
end

function PreSetup(params)
    if params.level >= 6 then
        local adversaryBag = Global.getVar("adversaryBag")
        local explorerBag = Global.getVar("explorerBag")
        local explorerBagPosition = explorerBag.getPosition()
        local newGuid = "bf89e8"
        if explorerBag.guid == "3b674d" then
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
        reminderTiles.explore = "f4a568"
    end
    if params.level >= 2 then
        reminderTiles.build = "be2c91"
    end
    return reminderTiles
end

function AdversaryUI(params)
    supporting = params.supporting
    local ui = {}

    ui.loss = {}
    ui.loss.tooltip = "Invaders win if you ever cannot place a Town."
    ui.loss.counter = {}
    ui.loss.counter.text = "Town Count: "

    local townBag = Global.getVar("townBag")
    townBag.call("setCallback", {obj=self,func="updateCount"})
    updateCount({count=#townBag.getObjects()})

    ui.escalation = {}
    ui.escalation.tooltip = "After Exploring, on each board, pick a land\nof the shown terrain. If it has Town/City,\nadd 1 Blight. Otherwise, add 1 Town."
    if params.supporting then
        ui.escalation.random = true
    end
    if params.level >= 1 then
        ui.one = {}
        ui.one.name = "Frontier Explorers"
        ui.one.tooltip = "Except during Setup: After Invaders\nsuccessfully Explore into a land which\nhad no Town/City, add 1 Explorer there."
    end
    if params.level >= 2 then
        ui.two = {}
        ui.two.name = "Slave Labor"
        ui.two.tooltip = "After Invaders Build in a land with 2+\nExplorers replace all but 1 Explorer\nthere with an equal number of Town."
    end
    if params.level >= 4 then
        ui.four = {}
        ui.four.name = "Triangle Trade"
        ui.four.tooltip = "Whenever Invaders Build a Coastal\nCity, add 1 Town to the adjacent\nland with the fewest Town."
    end
    if params.level >= 5 then
        ui.five = {}
        ui.five.name = "Slow-healing Ecosystem"
        ui.five.tooltip = "When you remove Blight from the board,\nput it here instead of onto the Blight Card.\nAs soon as you have 3 Blight per player\nhere, move it all back to the Blight Card."
    end
    if params.level >= 6 then
        ui.six = {}
        ui.six.name = "Persistent Explorers"
        ui.six.tooltip = "After the normal Explore Phase, on each board\nadd 1 Explorer to a land without any. Fear\nCard effects never remove Explorer. If one\nwould, you may instead Push that Explorer."
    end
    return ui
end

function updateCount(params)
    Global.call("UpdateAdversaryLossCounter",{count=params.count,supporting=supporting})
end

function LimitSetup(params)
    -- Adversary None should always be level 0
    local townLimit = 7
    if params.level >= 2 then
        townLimit = townLimit + params.other.level
        if Global.getVar("adversaryCard") ~= nil and Global.getVar("adversaryCard2") ~= nil then
            broadcastToAll("As you are playing with multiple adversaries, you will be playing with additional towns for France's Loss Condition - Sprawling Plantations", Color.SoftBlue)
        end
    end
    townLimit = townLimit * Global.getVar("numBoards")
    local townBag = Global.getVar("townBag")

    local customO = townBag.getCustomObject()
    customO.type = 6
    townBag.setCustomObject(customO)
    local id = townBag.guid
    townBag.reload()

    Wait.condition(function()
        townBag = getObjectFromGUID(id)
        Global.setVar("townBag", townBag)
        local tempObject = townBag.takeObject({
            position = townBag.getPosition() + Vector(0,2,0),
            rotation = Vector(0,180,0),
        })
        -- Loop starts at 2 since tempObject will be added to the bag at the end
        for _ = 2, townLimit do
            townBag.putObject(tempObject.clone({
                position = townBag.getPosition() + Vector(0,3,0),
                rotation = Vector(0,180,0),
            }))
        end
        townBag.putObject(tempObject)
        townBag.call("setCallback", {obj=self,func="updateCount"})
        Wait.condition(function() limitSetupComplete = true end, function() return #townBag.getObjects() == townLimit end)
    end, function() return getObjectFromGUID(id).type == "Bag" end)
end

function MapSetup(params)
    if not params.extra and params.level >= 3 then
        -- on each board add 1 Town to the highest-numbered land without a Town. Add 1 Town to land #1
        for i=#params.pieces,1,-1 do
            local landHasTown = false
            for _,v in pairs (params.pieces[i]) do
                if string.sub(v,1,4) == "Town" then
                    landHasTown = true
                    break
                end
            end
            if not landHasTown then
                table.insert(params.pieces[i],"Town")
                break
            end
        end
        table.insert(params.pieces[1],"Town")
    end
    return params.pieces
end

function PostSetup(params)
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 5 then
        local returnBlightBag = adversaryBag.takeObject({
            guid = "2ea157",
            position = self.getPosition() + Vector(1.9, 0, 1.9),
            rotation = {0,180,0},
            callback_function = function(obj) obj.setLock(true) end,
        })
        Global.setVar("returnBlightBag", returnBlightBag)
    end
    if params.level >= 2 then
        local card = adversaryBag.takeObject({guid = slaveRebellion})
        local count = setupSlaveRebellion(card)
        local zone = getObjectFromGUID(Global.getVar("eventDeckZone"))
        Wait.condition(function() postSetupComplete = true end, function()
            local objs = zone.getObjects() return #objs == 1 and ((objs[1].type == "Deck" and #objs[1].getObjects() == count) or objs[1].type == "Card")
        end)
    else
        postSetupComplete = true
    end
end
function setupSlaveRebellion(card)
    local zone = getObjectFromGUID(Global.getVar("eventDeckZone"))
    local eventDeck = zone.getObjects()[1]
    local count = 0
    if eventDeck ~= nil then
        count = #eventDeck.getObjects()
        eventDeck.takeObject({
            position = eventDeck.getPosition() + Vector(0,2,0)
        })
        eventDeck.takeObject({
            position = eventDeck.getPosition() + Vector(0,2,0)
        })
        if not thematicRebellion or (thematicRebellion and math.random(1,2) == 1) then
            eventDeck.takeObject({
                position = eventDeck.getPosition() + Vector(0,2,0)
            })
        end
    end
    count = count + 1
    card.setRotationSmooth(Vector(0,180,180), false, true)
    card.setPositionSmooth(zone.getPosition() + Vector(0,0.1,0), false, true)
    return count
end

function Requirements(params)
    return params.eventDeck
end