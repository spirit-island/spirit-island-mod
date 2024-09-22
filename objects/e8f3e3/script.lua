difficulty={[0] = 2, 3, 5, 7, 8, 9, 10}
fearCards={[0] = {0,0,0}, {0,0,0}, {0,1,0}, {1,1,0}, {1,1,1}, {1,2,1}, {1,2,2}}
invaderSetup = true
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
hasBroadcast = true

slaveRebellion = "1f0327"
slaveRebellion2 = "3f4bfc"

function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
end

function onObjectSpawn(obj)
    if obj.guid == slaveRebellion or obj.guid == slaveRebellion2 then
        obj.createButton({
            click_function = "slaveRebellionButton",
            function_owner = self,
            label          = "Draw and Return",
            position       = Vector(0,0.3,1.43),
            width          = 1200,
            scale          = Vector(0.65,1,0.65),
            height         = 160,
            font_size      = 150,
            tooltip = "Return Slave Rebellion back to the Event Deck as per Setup and Reveal new Event Card"
        })
    end
end

function InvaderSetup(params)
    local invaders = nil
    if params.level >= 6 then
        invaders = { explorer = { tooltip = "They are unable to be removed by fear cards and instead will be pushed", color = "9844CD" } }
    end
    return invaders
end

function ReminderSetup(params)
    local reminderTiles = {}
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 1 then
        reminderTiles.explore = adversaryBag.takeObject({guid="f4a568"})
    end
    if params.level >= 2 then
        reminderTiles.build = adversaryBag.takeObject({guid="be2c91"})
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
    updateCount({count=#townBag.getObjects()})

    ui.escalation = {}
    ui.escalation.tooltip = "After Exploring, on each board, pick a land\nof the shown terrain. If it has Town/City,\nadd 1 Blight. Otherwise, add 1 Town."
    if params.supporting then
        ui.escalation.random = true
    end

    ui.effects = {}
    if params.level >= 1 then
        ui.effects[1] = {}
        ui.effects[1].name = "Frontier Explorers"
        ui.effects[1].tooltip = "Except during Setup: After Invaders\nsuccessfully Explore into a land which\nhad no Town/City, add 1 Explorer there."
        ui.effects[1].explore = true
    end
    if params.level >= 2 then
        ui.effects[2] = {}
        ui.effects[2].name = "Slave Labor"
        ui.effects[2].tooltip = "After Invaders Build in a land with 2+\nExplorers replace all but 1 Explorer\nthere with an equal number of Town."
        ui.effects[2].build = true
    end
    if params.level >= 4 then
        ui.effects[4] = {}
        ui.effects[4].name = "Triangle Trade"
        ui.effects[4].tooltip = "Whenever Invaders Build a Coastal\nCity, add 1 Town to the adjacent\nland with the fewest Town."
        ui.effects[4].build = true
    end
    if params.level >= 5 then
        ui.effects[5] = {}
        ui.effects[5].name = "Slow-healing Ecosystem"
        ui.effects[5].tooltip = "When you remove Blight from the board,\nput it here instead of onto the Blight Card.\nAs soon as you have 3 Blight per player\nhere, move it all back to the Blight Card."
    end
    if params.level >= 6 then
        ui.effects[6] = {}
        ui.effects[6].name = "Persistent Explorers"
        ui.effects[6].tooltip = "After resolving an Explore Card, on each board\nadd 1 Explorer to a land without any. Fear\nCard effects never remove Explorer. If one\nwould, you may instead Push that Explorer."
        ui.effects[6].explore = true
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
        townBag.call("setCallback", {obj=self,func="updateCount",loss={adversary=self.getName()}})
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
        if Global.getVar("SetupChecker").getVar("optionalUniqueRebellion") and not thematicRebellion then
            card = card.setState(2)
        end
        local count = setupSlaveRebellion(card)
        local zone = Global.getVar("eventDeckZone")
        Wait.condition(function() postSetupComplete = true end, function()
            local objs = zone.getObjects() return #objs == 1 and ((objs[1].type == "Deck" and #objs[1].getObjects() == count) or objs[1].type == "Card")
        end)
    else
        postSetupComplete = true
    end
end
function slaveRebellionButton(card)
    local aidBoard = Global.getVar("aidBoard")
    aidBoard.call("EventCard", {ignore = card.guid})
    setupSlaveRebellion(card)
end
function setupSlaveRebellion(card)
    local zone = Global.getVar("eventDeckZone")
    local eventDeck = zone.getObjects()[1]
    local count = 0
    if eventDeck ~= nil and eventDeck.type == "Deck" then
        count = #eventDeck.getObjects()
        eventDeck.takeObject({
            position = eventDeck.getPosition() + Vector(0,1.2,0)
        })
        eventDeck.takeObject({
            position = eventDeck.getPosition() + Vector(0,1.1,0)
        })
        if not thematicRebellion or (thematicRebellion and math.random(1,2) == 1) then
            eventDeck.takeObject({
                position = eventDeck.getPosition() + Vector(0,1,0)
            })
        end
    end
    count = count + 1
    card.setRotationSmooth(Vector(0,180,180), false, true)
    card.setPositionSmooth(zone.getPosition() + Vector(0,0.1,0), false, true)
    return count
end

function Broadcast(params)
    if params.level >= 2 and params.other.level > 0 then
        return "Combining the French Plantation Colony - France's Additional Loss Condition has a greater Town limit"
    end
    return nil
end

function Requirements(params)
    return params.eventDeck
end
