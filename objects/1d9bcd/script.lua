difficulty={[0] = 2, 3, 5, 6, 8, 9, 10}
fearCards={[0] = {0,0,0}, {0,1,0}, {1,2,-1}, {1,2,0}, {1,2,0}, {1,3,0}, {2,3,0}}
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
count = 0

function onSave()
    if supporting then
        count = Global.UI.getAttribute("panelAdversary2LossCounterCount","text")
    else
        count = Global.UI.getAttribute("panelAdversaryLossCounterCount","text")
    end
    if count == nil then count = 0 end
    local data_table = {
        count = count,
    }
    return JSON.encode(data_table)
end

function onLoad(saved_data)
    local loaded_data = JSON.decode(saved_data)
    count = loaded_data.count
end

function PreSetup(params)
    if params.level >= 4 then
        local townHealth = Global.getVar("townHealth")
        local current = tonumber(townHealth.TextTool.getValue())
        townHealth.TextTool.setValue(tostring(current + 2))
        townHealth.TextTool.setFontColor({1,0.2,0.2})

        local adversaryBag = Global.getVar("adversaryBag")
        local townBag = Global.getVar("townBag")
        local townBagPosition = townBag.getPosition()
        local newGuid = "fabcad"
        if townBag.guid == "942899" then
            newGuid = "aeb4fa"
        end
        townBag.destruct()
        townBag = adversaryBag.takeObject({
            guid = newGuid,
            position = townBagPosition,
            rotation = {0,270,0},
            smooth = false,
            callback_function = function(obj) obj.setLock(true) end,
        })
        Global.setVar("townBag", townBag)
        Wait.condition(function() preSetupComplete = true end, function() return not townBag.isSmoothMoving() end)
    else
        preSetupComplete = true
    end
end

function ReminderSetup(params)
    local reminderTiles = {}
    if params.level >= 1 then
        reminderTiles.build = "05e46d"
    end
    if params.level >= 6 then
        reminderTiles.ravage = "3876aa"
    end
    return reminderTiles
end

function InvaderDeckSetup(params)
    if params.level >= 3 then
        for i=1,#params.deck do
            if params.deck[i] == 1 then
                table.remove(params.deck, i)
                break
            end
        end
    end
    return params.deck
end

function AdversaryUI(params)
    supporting = params.supporting
    local ui = {}

    ui.loss = {}
    ui.loss.tooltip = "Track how many Blight came off the\nBlight Card during Ravages that do 8+\nDamage to the land. If that number\never exceeds players, the Invaders win."
    ui.loss.counter = {}
    ui.loss.counter.text = "Blight Count: "
    ui.loss.counter.buttons = true
    ui.loss.counter.callback = "updateCount"
    Global.call("UpdateAdversaryLossCounter",{count=count,supporting=supporting})

    ui.escalation = {}
    ui.escalation.tooltip = "After Exploring: On each board with\n4 or fewer Blight, add 1 Town to a\nland without Town/Blight. On each board\nwith 2 or fewer Blight, do so again."
    if params.level >= 1 then
        ui.one = {}
        ui.one.name = "Migratory Herders"
        ui.one.tooltip = "After the normal Build Step: In each\nland matching a Build card, Gather\n1 Town from a land not matching\na Build Card. (In board/land order.)"
    end
    if params.level >= 2 then
        ui.two = {}
        ui.two.name = "More Rural Than Urban"
        ui.two.tooltip = "During Play, when Invaders\nwould Build 1 City in an Inland\nland, they instead Build 2 Town."
    end
    if params.level >= 4 then
        ui.four = {}
        ui.four.name = "Herds Thrive in Verdant Lands"
        ui.four.tooltip = "Town in lands without Blight are Durable:\nthey have +2 Health, and \"Destroy Town\"\neffects instead deal 2 Damage (to Town\nonly) per Town they could Destroy.\n(\"Destroy all Town\" works normally.)"
    end
    if params.level >= 5 then
        ui.five = {}
        ui.five.name = "Wave of Immigration"
        ui.five.tooltip = "When the Habsburg Reminder Card is\nrevealed, on each board, add 1 City to a\nCoastal land without City and 1 Town to\nthe 3 Inland lands with the fewest Blight."
    end
    if params.level >= 6 then
        ui.six = {}
        ui.six.name = "Far-Flung Herds"
        ui.six.tooltip = "Ravages do +2 Damage (total) if any\nadjacent lands have Town. (This does not\ncause lands without Invaders to Ravage.)"
    end
    return ui
end
function updateCount(params)
    if params.count > Global.getVar("numBoards") then
        broadcastToAll("Habsburg wins via Additional Loss Condition!", "Red")
    end
end

function MapSetup(params)
    if not params.extra and params.level >= 2 then
        table.insert(params.pieces[2],"Town")
        for i=#params.original, 1, -1 do
            if #params.original[i] == 0 then
                table.insert(params.pieces[i],"Town")
                break
            end
        end
    end
    return params.pieces
end

function PostSetup(params)
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 1 then
        local aidBoard = Global.getVar("aidBoard")
        adversaryBag.takeObject({
            guid = "0cea08",
            position = aidBoard.positionToWorld(Vector(-0.98,-0.09,1.9)),
            rotation = {0,90,0},
            callback_function = function(obj) obj.setLock(true) end,
        })
    end
    if params.level >= 5 then
        local zone = Global.getVar("invaderDeckZone")
        local invaderDeck = zone.getObjects()[1]
        if invaderDeck ~= nil then
            local count = #invaderDeck.getObjects()
            invaderDeck.takeObject({
                position = invaderDeck.getPosition() + Vector(0,4,0)
            })
            invaderDeck.takeObject({
                position = invaderDeck.getPosition() + Vector(0,3.5,0)
            })
            invaderDeck.takeObject({
                position = invaderDeck.getPosition() + Vector(0,3,0)
            })
            invaderDeck.takeObject({
                position = invaderDeck.getPosition() + Vector(0,2.5,0)
            })
            invaderDeck.takeObject({
                position = invaderDeck.getPosition() + Vector(0,2,0)
            })
            adversaryBag.takeObject({
                guid = "d90af8",
                position = invaderDeck.getPosition() + Vector(0,0.1,0),
                rotation = {0,180,180},
                smooth = false,
            })
            Wait.condition(function() postSetupComplete = true end, function()
                local objs = zone.getObjects() return #objs == 1 and objs[1].type == "Deck" and #objs[1].getObjects() == count + 1
            end)
        else
            postSetupComplete = true
        end
    else
        postSetupComplete = true
    end
end