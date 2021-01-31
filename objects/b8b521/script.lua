difficulty=1
fearCards={1,0,0}

invaderDeckSetup=true
mapSetup=true

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