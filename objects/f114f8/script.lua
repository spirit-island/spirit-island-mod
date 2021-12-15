difficulty={[0] = 1, 2, 3, 5, 6, 7, 8}
fearCards={[0] = {0,0,0}, {0,0,0}, {0,1,0}, {0,1,0}, {0,1,1}, {1,1,1}, {1,1,2}}
postSetup = true
postSetupComplete = false
reminderSetup = true
mapSetup = true
hasUI = true
hasBroadcast = true
exploratory = false

function ReminderSetup(params)
    local reminderTiles = {}
    local adversaryBag = Global.getVar("adversaryBag")
    if params.level >= 1 then
        reminderTiles.ravage = adversaryBag.takeObject({guid="16ab25"})
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

    ui.effects = {}
    ui.invader = {}
    if params.level >= 1 then
        ui.effects[1] = {}
        ui.effects[1].name = "Heavy Mining"
        ui.effects[1].tooltip = "If the Invaders do at least 6 Damage to the land\nduring Ravage, add an extra Blight. (The additional\nBlight does not destroy Presence or cause cascades.)"
        ui.invader.ravage = true
    end
    if params.level >= 3 then
        ui.effects[3] = {}
        ui.effects[3].name = "Fine Steel for Tools and Guns"
        ui.effects[3].tooltip = "Town deal 3 Damage. City deal 5 Damage."
    end
    if params.level >= 5 then
        ui.effects[5] = {}
        ui.effects[5].name = "Mining Rush"
        ui.effects[5].tooltip = "When Ravaging adds at least 1 Blight to a land,\nadd 1 Town to an adjacent land without Town/City.\nCascading Blight does not cause this effect."
    end
    if exploratory and params.level >= 7 then
        ui.effects[7] = {}
        ui.effects[7].name = "Royal Focus"
        ui.effects[7].tooltip = "When an Invader Card is discarded\nduring Advance Invader Cards, On\nEach Board: add 1 Town to the\nmatching land with the fewest Invaders."
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

function PostSetup(params)
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
    postSetupComplete = true
end

function Broadcast(params)
    if params.level >= 4 then
        return "Sweden Level 4 - At the end of Setup (after the Explore Card), Accelerate the Invader Deck and on each board, add 1 Town to the land with the fewest invaders that matches the discarded card"
    end
    return nil
end
