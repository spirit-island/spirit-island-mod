difficulty={[0] = 1, 3, 4, 6, 7, 8, 10}
fearCards={[0] = {0,0,0}, {0,1,0}, {1,1,0}, {1,2,1}, {2,2,1}, {2,3,1}, {3,3,1}}
reminderSetup = true
invaderDeckSetup = true
mapSetup = true
hasLossCondition = true
hasUI = true
hasBroadcast = true

function ReminderSetup(params)
    local reminderTiles = {}
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 1 then
        reminderTiles.explore = adversaryBag.takeObject({guid="16b426"})
    end
    if params.level >= 3 then
        reminderTiles.build = adversaryBag.takeObject({guid="76ab12"})
    end
    if params.level >= 5 then
        reminderTiles.ravage = adversaryBag.takeObject({guid="9f5e3b"})
    end
    if params.level >= 6 then
        reminderTiles.afterRavage = adversaryBag.takeObject({guid="aa65cf"})
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

    ui.effects = {}
    ui.invader = {}
    if params.level >= 1 then
        ui.effects[1] = {}
        ui.effects[1].name = "Trading Port"
        ui.effects[1].tooltip = "After Setup, in Coastal lands, Explore\nCards add 1 Town instead of 1 Explorer.\n\"Coastal Lands\" Invader Cards do this\nfor maximum 2 lands per board."
        ui.invader.explore = true
    end
    if params.level >= 3 then
        ui.effects[3] = {}
        ui.effects[3].name = "Chart the Coastline"
        ui.effects[3].tooltip = "In Coastal lands, Build Cards\naffect lands without Invaders, so\nlong as there is an adjacent City."
        ui.invader.build = true
    end
    if params.level >= 5 then
        ui.effects[5] = {}
        ui.effects[5].name = "Runoff and Bilgewater"
        ui.effects[5].tooltip = "After a Ravage Action adds Blight to a\nCoastal land, add 1 Blight to that board's\nOcean (without cascading). Treat the\nOcean as a Coastal Wetland for this rule\nand for Blight removal/movement."
        ui.invader.ravage = true
    end
    if params.level >= 6 then
        ui.effects[6] = {}
        ui.effects[6].name = "Exports Fuel Inward Growth"
        ui.effects[6].tooltip = "After the Ravage step, add 1 Town to\neach Inland land that matches a Ravage\ncard and is within 1 range of Town/City."
    end
    return ui
end

function MapSetup(params)
    if not params.extra and params.level >= 2 then
        table.insert(params.pieces[2],"City")
    end
    return params.pieces
end

function Broadcast(params)
    if params.other.level > 0 then
        return "Combining the Kingdom of Scotland - Push Coastal Cities inland if they are Added to lands other than land #2"
    end
    return nil
end
