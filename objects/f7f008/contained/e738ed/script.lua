spiritName = "Keeper of the Forbidden Wilds"

function doSetup(params)
    local keeper = params.spiritPanel
    if keeper then
        local json = JSON.decode(keeper.script_state)
        if not json.hostility then
            Global.call("giveEnergy", {color=params.color, energy=1, ignoreDebt=false})
            for _,data in pairs(json.trackEnergy) do
                data.count = math.ceil(data.count / 2)
            end
            json.hostility = true
            keeper.script_state = JSON.encode(json)
            keeper.setTable("trackEnergy", json.trackEnergy)
        end
    end
    return true
end

function onDestroy()
    local keeper = Global.call("getSpirit", {name = spiritName})
    if keeper then
        local json = JSON.decode(keeper.script_state)
        if json.hostility then
            for i,data in pairs(json.trackEnergy) do
                data.count = data.count * 2
                if i == 1 or i == 3 or i == 4 then
                    data.count = data.count + 1
                end
            end
            json.hostility = nil
            keeper.script_state = JSON.encode(json)
            keeper.setTable("trackEnergy", json.trackEnergy)
        end
    end
end
