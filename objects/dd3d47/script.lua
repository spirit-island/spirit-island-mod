difficulty={[0] = 1, 2, 4, 6, 7, 9, 10}
fearCards={[0] = {0,0,0}, {0,0,0}, {0,0,0}, {0,1,0}, {1,1,0}, {1,1,0}, {1,1,1}}
invaderDeckSetup=true
mapSetup = true
hasUI = true

function InvaderDeckSetup(params)
    local stageIRemoved = 0
    local stageIIRemoved = 0
    if params.level >= 3 then
        stageIRemoved = stageIRemoved + 1
    end
    if params.level >= 4 then
        stageIIRemoved = stageIIRemoved + 1
    end
    if params.level >= 5 then
        stageIRemoved = stageIRemoved + 1
    end
    if params.level >= 6 then
        stageIRemoved = stageIRemoved + 1
    end
    local i = 1
    while (i <= #params.deck) do
        if stageIRemoved == 0 and stageIIRemoved == 0 then
            break
        end
        if params.deck[i] == 1 and stageIRemoved > 0 then
            table.remove(params.deck, i)
            stageIRemoved = stageIRemoved - 1
        elseif (params.deck[i] == 2 or params.deck[i] == "C") and stageIIRemoved > 0 then
            table.remove(params.deck, i)
            stageIIRemoved = stageIIRemoved - 1
        else
            i = i + 1
        end
    end

    if params.level >= 2 then
        local stageII = nil
        local stageIII = nil
        for j=1,#params.deck do
            if stageII == nil and (params.deck[j] == 2 or params.deck[j] == "C") then
                stageII = j
            elseif params.deck[j] == 3 then
                stageIII = j
            end
        end
        -- assumes a deck will always have stage 2 and 3 cards
        table.remove(params.deck, stageIII)
        table.insert(params.deck, stageII, "3*")
    end
    return params.deck
end

function AdversaryUI(params)
    local ui = {}
    ui.escalation = {}
    ui.escalation.tooltip = "On each board with a Town/City,\nadd 1 Town to a land without a Town."
    return ui
end

function MapSetup(params)
    if not params.extra and params.level >= 1 then
        table.insert(params.pieces[3],"Town")
    end
    return params.pieces
end