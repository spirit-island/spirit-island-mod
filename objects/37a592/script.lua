difficulty={[0] = 1, 3, 4, 6, 7, 8, 10}
fearCards={[0] = {0,0,0}, {0,1,0}, {1,1,0}, {1,2,1}, {2,2,1}, {2,3,1}, {3,3,1}}
reminderSetup = true
invaderDeckSetup = true
mapSetup = true
postSetup = true
postSetupComplete = false
hasLossCondition = true
hasUI = true

function ReminderSetup(params)
    local reminderTiles = {}
    if params.level >= 1 then
        reminderTiles.explore = "16b426"
    end
    if params.level >= 3 then
        reminderTiles.build = "76ab12"
    end
    if params.level >= 5 then
        reminderTiles.ravage = "9f5e3b"
    end
    return reminderTiles
end

function InvaderDeckSetup(params)
    if params.level >= 2 then
        local stageIICount = 0
        for i=1,#params.deck do
            if params.deck[i] == 2 then
                stageIICount = stageIICount + 1
                if stageIICount == 3 then
                    params.deck[i] = "C"
                    break
                elseif i - 1 >= 1 then
                    local value = table.remove(params.deck, i)
                    table.insert(params.deck, i - 1, value)
                end
            end
        end
    end
    if params.level >= 4 then
        local stageI = nil
        local stageIII = nil
        for index,value in pairs(params.deck) do
            if value == 1 then
                stageI = index
            elseif value == 3 then
                stageIII = index
            end
        end
        -- assumes a deck will always have stage 3 cards
        table.remove(params.deck, stageIII)
        if stageI ~= nil then
            params.deck[stageI] = 3
        else
            table.insert(params.deck, 1, 3)
        end
    end
    return params.deck
end

function AdversaryUI(params)
    local ui = {}

    ui.loss = {}
    ui.loss.tooltip = "If the number of Coastal lands\nwith City is ever greater than\n(2 x # boards), the Invaders win."

    ui.escalation = {}
    ui.escalation.tooltip = "On the single board with the most Coastal\nTown/City, add 1 Town to the N lands\nwith the fewest Town (N = # players)."
    if params.level >= 1 then
        ui.one = {}
        ui.one.name = "Trading Port"
        ui.one.tooltip = "After Setup, in Coastal lands, Explore\nCards add 1 Town instead of 1 Explorer.\n\"Coastal Lands\" Invader Cards do this\nfor maximum 2 lands per board."
    end
    if params.level >= 3 then
        ui.three = {}
        ui.three.name = "Chart the Coastline"
        ui.three.tooltip = "In Coastal lands, Build Cards\naffect lands without Invaders, so\nlong as there is an adjacent City."
    end
    if params.level >= 5 then
        ui.five = {}
        ui.five.name = "Runoff and Bilgewater"
        ui.five.tooltip = "After a Ravage Action adds Blight to a\nCoastal land, add 1 Blight to that board's\nOcean (without cascading). Treat the\nOcean as a Coastal Wetland for this rule\nand for Blight removal/movement."
    end
    if params.level >= 6 then
        ui.six = {}
        ui.six.name = "Exports Fuel Inward Growth"
        ui.six.tooltip = "After the Ravage step, add 1 Town to\neach Inland land that matches a Ravage\ncard and is within 1 range of Town/City."
    end
    return ui
end

function MapSetup(params)
    if not params.extra and params.level >= 2 then
        table.insert(params.pieces[2],"City")
    end
    return params.pieces
end

function PostSetup(params)
    if params.other.level > 0 then
        broadcastToAll("Push all Adversary Coastal Cities not in land #2 to an adjacent Inland land", "Blue")
    end
    if params.level >= 6 then
        local aidBoard = Global.getVar("aidBoard")
        local adversaryBag = Global.getVar("adversaryBag")
        adversaryBag.takeObject({
            guid = "aa65cf",
            position = aidBoard.positionToWorld(Vector(-0.47,-0.09,1.9)),
            rotation = {0,90,0},
            callback_function = function(obj) obj.setLock(true) end,
        })
    end
    postSetupComplete = true
end