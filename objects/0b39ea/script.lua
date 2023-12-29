difficulty={[0] = 1, 3, 4, 5, 7, 9, 10}
fearCards={[0] = {0,0,0}, {0,0,0}, {0,0,1}, {0,1,1}, {1,1,1}, {1,2,1}, {1,2,1}}
reminderSetup = true
invaderDeckSetup = true
mapSetup = true
hasUI = true
customLoss = true

salt = "8dc86e"

function ReminderSetup(params)
    local reminderTiles = {}
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 1 then
        reminderTiles.build = adversaryBag.takeObject({guid="29298f"})
        reminderTiles.ravage = adversaryBag.takeObject({guid="6f3e77"})
    end
    if params.level >= 3 then
        reminderTiles.afterBuild = adversaryBag.takeObject({guid="0acfb2"})
    end
    if params.level >= 6 then
        reminderTiles.explore = adversaryBag.takeObject({guid="ec150e"})
    end
    return reminderTiles
end

function InvaderDeckSetup(params)
    if params.level >= 4 then
        -- first, pull salt card out of bag
        local adversaryBag = Global.getVar("adversaryBag")
        adversaryBag.takeObject({guid = salt})

        -- second, add the salt card to the global table of invader cards
        local invaderCards = Global.getTable("invaderCards")
        invaderCards["L"] = {["stage"] = 2, ["guid"] = salt}
        Global.setTable("invaderCards", invaderCards)

        -- third, blacklist the coastal lands card
        params.deck.blacklist["C"] = true

        -- finally, put the "L" in the invader deck order we'll return
        local stageIICount = 0
        for i=1,#params.deck do
            if params.deck[i] == 2 or (invaderCards[params.deck[i]] and invaderCards[params.deck[i]].stage == 2) then
                stageIICount = stageIICount + 1
                if stageIICount == 2 then
                    params.deck[i] = "L"
                    break
                end
            end
        end
    end
    return params.deck
end

function AdversaryUI(params)
    local ui = {}

    ui.loss = {}
    ui.loss.tooltip = "At the end of the Fast Phase, the\nInvaders win if any land has at least\n8 total Invaders/Blight (combined)."

    ui.escalation = {}
    ui.escalation.tooltip = "After Advancing Invader Cards: On each board,\nExplore in 2 lands whose terrains don't match\na Ravage or Build Card (no source required)."

    ui.effects = {}
    if params.level >= 1 then
        ui.effects[1] = {}
        ui.effects[1].name = "Avarice Rewarded"
        ui.effects[1].tooltip = "When Blight added by a Ravage Action\nwould cascade, instead Upgrade 1\nExplorer/Town (before Dahan counterattack)."
        ui.effects[1].ravage = true
        ui.effects[2] = {}
        ui.effects[2].name = "Ceaseless Mining"
        ui.effects[2].tooltip = "Lands with 3 or more Invaders are Mining lands.\nIn Mining lands: Disease and modifiers to Disease\naffect Ravage Actions as though they were Build\nActions. During the Build Step, Build Cards\ncause Ravage Actions (instead of Build Actions)."
        ui.effects[2].build = true
        -- TODO make this effect appear as level 1
    end
    if params.level >= 3 and params.level < 5 then
        ui.effects[3] = {}
        ui.effects[3].name = "Mining Boom (I)"
        ui.effects[3].tooltip = "After the Build Step, on each board:\nChoose a land with Explorers.\nUpgrade 1 Explorer there."
        ui.effects[3].afterBuild = true
    end
    if params.level >= 5 then
        ui.effects[5] = {}
        ui.effects[5].name = "Mining Boom (II)"
        ui.effects[5].tooltip = "After the Build Step, on each board: Choose\na land with Explorers. Build there, then Upgrade\n1 Explorer. (Build normally in a Mining land)."
        ui.effects[5].afterBuild = true
    end
    if params.level >= 6 then
        ui.effects[6] = {}
        ui.effects[6].name = "The Empire Ascendant"
        ui.effects[6].tooltip = "Setup and During the Explore Step:\nOn boards with 3 or fewer Blight, Add +1\nExplorer in each land successfully explored.\n(Max. 2 lands per board per Explore Card.)"
        ui.effects[6].explore = true
    end
    return ui
end

function MapSetup(params)
    if params.level >= 2 then
        for i=#params.original, 1, -1 do -- add disease and city into highest land with town setup symbol
            local found = false
            for _,v in pairs (params.original[i]) do
                if string.sub(v,1,4) == "Town" then
                    table.insert(params.pieces[i],"Disease")
                    if not params.extra then
                        table.insert(params.pieces[i],"City")
                    end
                    found = true
                    break
                end
            end
            if found then
                break
            end
        end
        if not params.extra then -- add 1 explorer in each land with no dahan
            for i=1, #params.pieces do
                local landHasDahan = false
                for _,v in pairs (params.pieces[i]) do
                    if string.sub(v,1,5) == "Dahan" then
                        landHasDahan = true
                        break
                    end
                end
                if not landHasDahan then
                    table.insert(params.pieces[i],"Explorer")
                end
            end
        end
    end
    return params.pieces
end
