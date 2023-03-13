function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return false
    elseif color ~= Global.call("getSpiritColor", {name = "Lightning's Swift Strike"}) then
        Player[color].broadcast("You have not picked Lightning's Swift Strike!", Color.Red)
        return false
    end

    local lightning = Global.call("getSpirit", {name = "Lightning's Swift Strike"})
    local json = JSON.decode(lightning.script_state)
    if not json.immense then
        for _,data in pairs(json.trackEnergy) do
            data.count = data.count * 2
        end
        json.immense = true
        lightning.script_state = JSON.encode(json)
        lightning.setTable("trackEnergy", json.trackEnergy)
    end
    return true
end
