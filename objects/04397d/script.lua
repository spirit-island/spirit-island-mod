difficulty=0
broadcast="Remember, in each inner land, add 1 Explorer and 1 Presence from the spirit starting on that board\nEach spirit also draws 1 Minor and 1 Major Power - Guard the Isle's Heart"

mapSetup=true

function MapSetup(params)
    for i=1,#params.pieces do
        for j=#params.pieces[i],1,-1 do
            if string.sub(params.pieces[i][j],1,4) == "Town" then
                table.remove(params.pieces[i],j)
            end
        end
    end
    return params.pieces
end