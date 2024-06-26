spiritName = "Lightning's Swift Strike"

function doSetup(params)
    local lightning = params.spiritPanel
    if lightning then
        local json = JSON.decode(lightning.script_state)
        if not json.immense then
            for _,data in pairs(json.trackEnergy) do
                data.count = data.count * 2
            end
            json.immense = true
            lightning.script_state = JSON.encode(json)
            lightning.setTable("trackEnergy", json.trackEnergy)
        end
    end
    return true
end

function onDestroy()
    local lightning = Global.call("getSpirit", {name = spiritName})
    if lightning then
        local json = JSON.decode(lightning.script_state)
        if json.immense then
            for _,data in pairs(json.trackEnergy) do
                data.count = math.floor(data.count / 2)
            end
            json.immense = nil
            lightning.script_state = JSON.encode(json)
            lightning.setTable("trackEnergy", json.trackEnergy)
        end
    end
end
