difficulty={[0] = 1, 2, 3, 5, 6, 7, 8}
fearCards={[0] = {0,0,0}, {0,0,0}, {0,1,0}, {0,1,0}, {0,1,1}, {1,1,1}, {1,1,2}}
broadcast={
    [0] = nil,
    nil,
    nil,
    nil,
    "Remember, you need to do Royal Backing after the initial explore - Sweden Level 4",
    "Remember, you need to do Royal Backing after the initial explore - Sweden Level 4",
    "Remember, you need to do Royal Backing after the initial explore - Sweden Level 4",
}
preSetup = true
preSetupComplete = false
reminderSetup = true
mapSetup = true
hasUI = true

function PreSetup(params)
    if params.level >= 3 then
        local townDamage = Global.getVar("townDamage")
        local current = tonumber(townDamage.TextTool.getValue())
        townDamage.TextTool.setValue(tostring(current+1))
        townDamage.TextTool.setFontColor({1,0.2,0.2})
        local cityDamage = Global.getVar("cityDamage")
        current = tonumber(cityDamage.TextTool.getValue())
        cityDamage.TextTool.setValue(tostring(current+2))
        cityDamage.TextTool.setFontColor({1,0.2,0.2})
    end
    preSetupComplete = true
end

function ReminderSetup(params)
    local reminderTiles = {}
    if params.level >= 1 then
        reminderTiles.ravage = "16ab25"
    end
    return reminderTiles
end

function AdversaryUI(params)
    local ui = {}
    ui.escalation = {}
    ui.escalation.tooltip = "After Invaders Explore into each land this Phase,\nif that land has at least as many Invaders as\nDahan, replace 1 Dahan with 1 Town."
    if params.supporting then
        ui.escalation.random = true
    end
    if params.level >= 1 then
        ui.one = {}
        ui.one.name = "Heavy Mining"
        ui.one.tooltip = "If the Invaders do at least 6 Damage to the land\nduring Ravage, add an extra Blight. The additional\nBlight does not destroy Presence or cause cascades."
    end
    if params.level >= 3 then
        ui.three = {}
        ui.three.name = "Fine Steel for Tools and Guns"
        ui.three.tooltip = "Town deal 3 Damage. City deal 5 Damage."
    end
    if params.level >= 5 then
        ui.five = {}
        ui.five.name = "Mining Rush"
        ui.five.tooltip = "When Ravaging adds at least 1 Blight to a land,\nadd 1 Town to an adjacent land without Town/City.\nCascading Blight does not cause this effect."
    end
    return ui
end

function MapSetup(params)
    if not params.extra and params.level >= 2 then
        -- add 1 City to Land #4
        table.insert(params.pieces[4],"City")

        -- on boards where land #4 starts with Blight, put that blight in land #5 instead
        for i,v in ipairs (params.pieces[4]) do
            if v == "Box Blight" then
                table.remove(params.pieces[4],i)
                table.insert(params.pieces[5],"Box Blight")
                break
            end
        end
    end
    if not params.extra and params.level >= 6 then
        -- on each board add 1 Town and 1 Blight to land #8. The Blight comes from the box, not the Blight Card
        table.insert(params.pieces[8],"Town")
        table.insert(params.pieces[8],"Box Blight")
    end
    return params.pieces
end