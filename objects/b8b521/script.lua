difficulty=1
fearCards={1,0,0}

invaderDeckSetup=true
mapSetup=true
broadcast="For proper element counting, place 2 element tokens instead of 1 on the corners"

function InvaderDeckSetup(params)
    table.remove(params.deck,1)
    return params.deck
end

function MapSetup(params)
    if not params.extra then
        table.insert(params.pieces[6],"Town")
    end
    return params.pieces
end