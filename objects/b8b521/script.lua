difficulty=1
fearCards={1,0,0}

invaderDeckSetup=true
mapSetup=true
broadcast="For proper element counting, place 2 element tokens instead of 1 on the corners"

function InvaderDeckSetup(params)
    local found = false
    local stageTwo = -1
    local stageThree = -1
    for i, stage in pairs(params.deck) do
        if stage == 1 then
            table.remove(params.deck,i)
            found = true
            break
        elseif stage == 2 or stage == "C" then
            if stageTwo == -1 then
                stageTwo = i
            end
        elseif stage == 3 then
            if stageThree == -1 then
                stageThree = i
            end
        end
    end
    if not found then
        if stageTwo ~= -1 then
            table.remove(params.deck,stageTwo)
        else
            table.remove(params.deck,stageThree)
        end
    end
    return params.deck
end

function MapSetup(params)
    if not params.extra then
        table.insert(params.pieces[6],"Town")
    end
    return params.pieces
end