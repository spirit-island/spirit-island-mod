function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "A Spread of Rampant Green"

function doSetup(params)
    local player_color = params.color
    local spirit = Global.call("getSpirit", {name = spiritName})

    -- Set up additional presence
    -- Mostly copied from SourceSpirit's setupSpirit() function
    local zOffset = 2.6

    local objsData = Global.getVar("playerBag").getData().ContainedObjects
    local spos = spirit.getPosition()

    local playerTints = Global.getTable("Tints")[player_color]
    local color = Color.fromHex(playerTints.Presence)
    local presenceData = objsData[13]
    presenceData.Nickname = player_color.."'s "..presenceData.Nickname
    presenceData.ColorDiffuse.r = color.r
    presenceData.ColorDiffuse.g = color.g
    presenceData.ColorDiffuse.b = color.b
    presenceData.States[2].Nickname = player_color.."'s "..presenceData.States[2].Nickname
    presenceData.States[2].ColorDiffuse.r = color.r
    presenceData.States[2].ColorDiffuse.g = color.g
    presenceData.States[2].ColorDiffuse.b = color.b
    presenceData.States[2].AttachedDecals[1].CustomDecal.Name = player_color.."'s "..presenceData.States[2].AttachedDecals[1].CustomDecal.Name
    presenceData.States[2].AttachedDecals[1].CustomDecal.ImageURL = Global.call("GetSacredSiteUrl", {color = player_color})
    for i = 0,12 do
        spawnObjectData({
            data = presenceData,
            position = spos + Vector(0,0.05+i,10+zOffset),
            rotation = Vector(0, 180, 0),
        })
    end

    return true
end
