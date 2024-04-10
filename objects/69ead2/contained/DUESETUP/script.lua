spiritName = "Dances Up Earthquakes"

energyPoint = Vector(-0.99, 0.20, -0.41) -- location of the snap point where the presence for 2 impending energy/turn sits
impendTable = {}
g3Selected = false

aboveCard = 0.5
buttonVisibility = 0.4 -- increase for testing, 0 ultimately. May put this value dependent on a slider so people can vary?

------------------
-- setup functions
------------------

function onSave()
    local json = JSON.decode(self.script_state)
    if not json then
        json = {}
    end
    json.impendTable = impendTable
    json.g3Selected = g3Selected
    return JSON.encode(json)
end

function updateSave()
    local json = JSON.decode(self.script_state)
    if not json then
        json = {}
    end
    json.impendTable = impendTable
    json.g3Selected = g3Selected
    self.script_state = JSON.encode(json)
end

function onLoad(saved_data)
    -- this just makes the letter "i" above this object, if visuals change in any way, this can be removed
    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "i",
        position = {0,0.3,0.1},
        width = 0,
        height = 0,
        font_size = 450,
        font_color = {1,1,1},
    })

    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        setupComplete = loaded_data.setupComplete
        impendTable = loaded_data.impendTable
        g3Selected = loaded_data.g3Selected
    end

    if setupComplete then
        createPanelButtons()
        createAllCardButtons()
    end
end

function null()
end

function doSetup(params)
    local color = params.color
    local panel = Global.call("getSpirit", {name = spiritName})
    self.locked = true
    local position = panel.getPosition() + Vector(-8.2,-0.22,6.8)
    self.setPosition(position)
    
    -- hand for impending cards:
    local position1 = Player[color].getHandTransform(2).position
    position1.z = position1.z - 5.5
    Global.call("SpawnHand", {color = color, position = position1})
    
    Wait.condition(function() createPanelButtons() end, function() return not panel.isSmoothMoving() end) -- without a wait, if spirit chosen after setup, buttons don't appear
    
    return true
end

-----------------------------------------
-- buttons and functions for spirit panel
-----------------------------------------

function createPanelButtons()
    local dances = Global.call("getSpirit", {name = spiritName})
    dances.createButton({
        click_function = "impendCard",
        function_owner = self,
        label = "Impend a card!",
        position = {-0.93,0.5,0},
        scale = {x=0.08, y=0.08, z=0.08},
        width = 5000,
        height = 750,
        font_size = 750,
        color = {1,1,1},
        font_color = {0,0,0},
        tooltip = "Place a card on the panel art\nand press the button to impend it!",
    })
    
    local label
    if g3Selected then
        label = "☑\n\n\n"
    else
        label = "☐\n\n\n"
    end
    dances.createButton({
        click_function = "g3Toggle",
        function_owner = self,
        label = label,
        position = {1.1,0.2,-0.78},
        scale = {x=0.08, y=0.08, z=0.08},
        width = 1800,
        height = 1800,
        font_size = 450,
        color = {0,0,0,0.5},
        font_color = {0,0,0,100},
        tooltip = "Press this if you are choosing the third growth option in order to show buttons on impending cards.",
    })
end

function impendCard(obj)
    local color = Global.call("getSpiritColor", {name = spiritName})
    local hits = Physics.cast({
        origin = obj.getPosition() + Vector(-5,0,2),
        direction = Vector(0,1,0),
        type = 3,
        size = {6,1,6.5},
        max_distance = 1,
        -- debug = true
    })
    for _,hit in pairs(hits) do
            local card = hit.hit_object
        if Global.call("isPowerCard", {card=card}) then
            if impendTable[card.guid] == nil then
                local costs = {}
                costs[card.guid] = card.getVar("energy")
                local energy = Global.call("modifyCost",{color = color, costs = costs})[card.guid]
                card.hide_when_face_down = false
                impendTable[card.guid] = {
                    guid = card.guid,
                    name = card.getName(),
                    maxEnergy = energy,
                    turnSelected = Global.getVar("turn"),
                    energy = {0,0,0},
                }
            end
            if impendTable[card.guid] then -- don't think this is necessary any more, but useful is a case arises
                createCardButtons(card)
                updateEnergyDisplay(card.guid)
                card.deal(1, color, 3)
            end
        end
    end
    updateSave()
end

function g3Toggle(obj)
    local ind = getButtonIndex(obj,"g3Toggle")
    if g3Selected then
        g3Selected = false
        obj.editButton({
            index = ind,
            label = "☐\n\n\n",
        })
        removeAllG3Buttons()
    else    
        g3Selected = true
        obj.editButton({
            index = ind,
            label = "☑\n\n\n",
        })
        createAllG3Buttons()
    end
    updateSave()
end

--------------------------------------
-- impended card buttons and functions
--------------------------------------

function createCardButtons(card)
    if not getButtonIndex(card,"energyDisplay") then -- stop multiple buttons appearing, did prevent another way before but that removed other functionality
        card.createButton({ 
            click_function = "energyDisplay",
            function_owner = self,
            label = "0/0",
            position = {0.29,aboveCard,-0.55},
            width = 700,
            height = 550,
            font_size = 430,
            color = {0,0,0,buttonVisibility},
            font_color = {1,1,1,100},
            tooltip = "Select a card to impend",
        })
        
        card.createButton({
            click_function = "overridePlus",
            function_owner = self,
            label = "+",
            position = {-0.2,-aboveCard,0.8},
            rotation = {180,180,0},
            width = 200,
            height = 200,
            font_size = 250,
            color = {0,0,0,0.9},
            font_color = {1,0,0,100},
            tooltip = "Press this to override the value of impended energy.\nUseful for if time passes twice.",
        })
        
        card.createButton({
            click_function = "overrideMinus",
            function_owner = self,
            label = "-",
            position = {0.2,-aboveCard,0.8},
            rotation = {180,180,0},
            width = 200,
            height = 200,
            font_size = 250,
            color = {0,0,0,0.9},
            font_color = {1,0,0,100},
            tooltip = "Press this to override the value of impended energy.\nUseful for if time passes twice.",
        })
        
        card.createButton({
            click_function = "clearAll",
            function_owner = self,
            label = "FORCE RESET",
            position = {0,-aboveCard,1.2},
            rotation = {180,180,0},
            width = 950,
            height = 200,
            font_size = 150,
            color = {0,0,0,0.9},
            font_color = {1,0,0,100},
            tooltip = "Press this to delete the stored card data\nUse this for if impended card is forgotten\nThis cannot be undone!",
        })
    end
end
    
function energyDisplay(card,_color,alt_click)
    -- probably need tighter restriction that just turnSelected, since could be forgotten in fast phase. use Global.getVar("currentPhase")
    local tbl = impendTable[card.guid]
    local spiritColor = Global.call("getSpiritColor", {name = spiritName})
    if tbl.turnSelected == Global.getVar("turn") then
        if not alt_click then -- check if have energy and need energy
            if Global.getVar("selectedColors")[spiritColor].counter.getValue() > 0 and tbl.energy[1] < tbl.maxEnergy then
                Global.call("giveEnergy",{color = spiritColor, energy = -1, ignoreDebt = true})
                impendTable[card.guid].energy[1] = tbl.energy[1] + 1
            end
        elseif tbl.energy[1] > 0 then
            Global.call("giveEnergy",{color = spiritColor, energy = 1, ignoreDebt = true})
            impendTable[card.guid].energy[1] = tbl.energy[1] - 1
        end
        updateEnergyDisplay(card.guid)
    end
    updateSave()
end

function updateEnergyDisplay(guid)
    local card = getObjectFromGUID(guid)
    if card then -- prevents function if card is in bag/deck
        local ind = getButtonIndex(card,"energyDisplay")
        local tbl = impendTable[guid]
        local val = tbl.energy[1] + tbl.energy[2] + tbl.energy[3]
        local fontColor = {1,1,1,100}
        local ttText = val .. "/" .. tbl.maxEnergy .. "\n" .. card.getName()
        if val >= tbl.maxEnergy then
            fontColor = tbl.turnSelected == Global.getVar("turn") and {1,1,0,100} or {0,1,0,100}
        end
        card.editButton({
            index = ind,
            label = tostring(val) .. "/" .. tostring(tbl.maxEnergy),
            font_color = fontColor,
            tooltip = ttText,
        })
    end
end

function overridePlus(card)
    impendTable[card.guid].energy[1] = impendTable[card.guid].energy[1] + 1 -- unsure if need to set a limit on this
    updateEnergyDisplay(card.guid)
    updateSave()
end

function overrideMinus(card)
    impendTable[card.guid].energy[1] = math.max(impendTable[card.guid].energy[1] - 1, 0)
    updateEnergyDisplay(card.guid)
    updateSave()
end

function clearAll(card)
    clearCardData(card.guid)
end

function clearCardData(guid)
    clearCardButtons(guid)
    impendTable[guid] = nil
    local card = getObjectFromGUID(guid)
    if card then
        card.hide_when_face_down = true -- if card is in bag then oh well it can stay that way it really won't matter
    end
    updateSave()
end

function clearCardButtons(guid)
    local card = getObjectFromGUID(guid)
    if card then
        for _,func in pairs({"energyDisplay", "overridePlus", "overrideMinus", "clearAll", "g3Minus", "g3Plus"}) do -- add to if needed
            local ind = getButtonIndex(card, func)
            if ind then
                card.removeButton(ind)
            end
        end
    end
end

--------------------------------------------
-- card buttons for g3 and related functions
--------------------------------------------

function createAllG3Buttons()
    if g3Selected then
        for _,tbl in pairs(impendTable) do
            local card = getObjectFromGUID(tbl.guid)
            if card then
               createG3Buttons(card)
            end
        end
    end
end

function createG3Buttons(card)
    local tbl = impendTable[card.guid]
    if tbl.turnSelected ~= Global.getVar("turn") and getButtonIndex(card,"g3Plus") == nil then
        card.createButton({
            click_function = "g3Plus",
            function_owner = self,
            label = "+",
            position = {-0.55,aboveCard,-0.8},
            width = 120,
            height = 120,
            font_size = 150,
            color = {1,1,1,1},
            tooltip = "Add 1 impended energy using the third growth option",
        })

        card.createButton({
            click_function = "g3Minus",
            function_owner = self,
            label = "-",
            position = {-0.55,aboveCard,-0.4},
            width = 120,
            height = 120,
            font_size = 150,
            color = {1,1,1,1},
            tooltip = "Subtract 1 impended energy using the third growth option",
        })
    end
end

function removeAllG3Buttons()
    for _,tbl in pairs(impendTable) do
        local card = getObjectFromGUID(tbl.guid)
        if card then
            removeG3Buttons(card)
        end
    end
end

function removeG3Buttons(card)
    local tbl = impendTable[card.guid]
    if tbl.turnSelected ~= Global.getVar("turn") and getButtonIndex(card,"g3Plus") ~= nil then
        card.removeButton(getButtonIndex(card,"g3Plus"))
        card.removeButton(getButtonIndex(card,"g3Minus"))
        impendTable[tbl.guid].energy[3] = 0
        updateEnergyDisplay(tbl.guid)
    end
end

function updateG3Buttons(guid)
    local card = getObjectFromGUID(guid)
    if card then
        local plus_color = impendTable[guid].energy[3] == 1 and {1,1,0,1} or {1,1,1,1}
        local plus_ind = getButtonIndex(card,"g3Plus")
        card.editButton({
            index = plus_ind,
            color = plus_color,
        })
        local minus_color = impendTable[guid].energy[3] == -1 and {1,1,0,1} or {1,1,1,1}
        local minus_ind = getButtonIndex(card,"g3Minus")
        card.editButton({
            index = minus_ind,
            color = minus_color,
        })
    end
end

function g3CardsSelected()
    local count = 0
    for _,tbl in pairs(impendTable) do
        if tbl.energy[3] ~= 0 then
            count = count + 1
        end
    end
    return count
end

function g3Plus(card, color)
    local selected = g3CardsSelected()
    local guid = card.guid
    if impendTable[guid].energy[3] == 1 then
        impendTable[guid].energy[3] = 0
    elseif impendTable[guid].energy[3] == -1 or selected < 2 then
        impendTable[guid].energy[3] = 1
    else
        broadcastToColor("You have already made your two selections for G3 energy adjustments!", color, {r=1, g=1, b=0})
    end
    updateEnergyDisplay(guid)
    updateG3Buttons(guid)
    updateSave()
end

function g3Minus(card, color)
    local selected = g3CardsSelected()
    local guid = card.guid
    if impendTable[guid].energy[3] == -1 then
        impendTable[guid].energy[3] = 0
    elseif impendTable[guid].energy[3] == 1 or selected < 2 then
        impendTable[guid].energy[3] = -1
    else
        broadcastToColor("You have already made your two selections for G3 energy adjustments!", color, {r=1, g=1, b=0})
    end
    updateEnergyDisplay(guid)
    updateG3Buttons(guid)
    updateSave()
end

function createAllCardButtons()
    createAllG3Buttons()
    for guid,_ in pairs(impendTable) do
        local card = getObjectFromGUID(guid)
        if card then
            Wait.time(function()
                createCardButtons(card)
                updateEnergyDisplay(guid)
                if g3Selected and impendTable[guid].turnSelected ~= Global.getVar("turn") then
                    createG3Buttons(card)
                    updateG3Buttons(guid)
                end
            end, 0.01)
        end
    end
    updateSave()
end

------------------
-- other functions
------------------

function getButtonIndex(obj,str) -- needed for cards that already have buttons so can be edited normally
    if obj.getButtons() then
        for _,tbl in pairs(obj.getButtons()) do
            if tbl.click_function == str then
                return tbl.index
            end
        end
    end
    return nil
end

function timePasses()
    local dances = Global.call("getSpirit", {name = spiritName})
    for _,tbl in pairs(impendTable) do
        local var = tbl.energy[1] + tbl.energy[2] + tbl.energy[3]
        if var >= tbl.maxEnergy and tbl.turnSelected ~= Global.getVar("turn") - 1 then
            clearCardData(tbl.guid)
        else
            tbl.energy[1] = var
            tbl.energy[2] = 0
            tbl.energy[3] = 0
            updateEnergyDisplay(tbl.guid)
        end
    end
    g3Selected = true
    g3Toggle(dances)
    updateSave()
end

local function energyPerTurn(dances)
    local hits = Physics.cast({
        origin = dances.positionToWorld(energyPoint),
        direction = Vector(0, 1, 0),
        max_distance = 1,
        type = 1, --ray
        -- debug = true
    })
    for _, hit in pairs(hits) do
        if hit.hit_object.hasTag("Presence") then
            return 1
        end
    end
    return 2
end

function onGainPay(params)
    if not params.color == Global.call("getSpiritColor", {name = spiritName}) then return end
    local dances = Global.call("getSpirit", {name = spiritName})
    if params.isGain then
        for _,tbl in pairs(impendTable) do
            if params.isUndo then
                impendTable[tbl.guid].energy[2] = 0
            elseif tbl.turnSelected ~= Global.getVar("turn") then
                impendTable[tbl.guid].energy[2] = energyPerTurn(dances)
            end
            updateEnergyDisplay(tbl.guid)
        end
        updateSave()
    else
        local zone = Global.getTable("selectedColors")[params.color].zone
        if params.isUndo then
            for _,obj in pairs(zone.getObjects()) do
                local tbl = impendTable[obj.guid]
                if tbl then
                    -- originally pulled all impend cards back to impend hand but that can be annoying
                    -- swapping to only pull back cards not currently with sufficient energy
                    if tbl.energy[1] + tbl.energy[2] + tbl.energy[3] < tbl.maxEnergy then
                        obj.deal(1, params.color, 3)
                    end
                end
            end
        else
            -- Store all impended cards with enough energy into a table
            local toPlayFast = {}
            local toPlaySlow = {}
            local impendInPlay = {}
            for _,obj in pairs(zone.getObjects()) do
                local tbl = impendTable[obj.guid]
                if tbl then
                    if tbl.energy[1] + tbl.energy[2] + tbl.energy[3] >= tbl.maxEnergy then
                        impendInPlay[obj] = true
                    else
                        obj.deal(1, params.color, 3)
                    end
                end
            end
            for _,tbl in pairs(impendTable) do
                local card = getObjectFromGUID(tbl.guid)
                local energy = tbl.energy[1] + tbl.energy[2] + tbl.energy[3]
                if tbl.turnSelected ~= Global.getVar("turn") and energy >= tbl.maxEnergy then
                    -- Check the card is not in a bag/deck
                    if card then -- possibly also check card is not in zone as may annoy people if their cards keep moving
                        local card_z = card.getPosition().z
                        local zone_z = zone.getPosition().z
                        if not (impendInPlay[card] and card_z > zone_z and card_z < zone_z + 9.5) then
                            if card.hasTag("Fast") then
                                table.insert(toPlayFast,card)
                            else
                                table.insert(toPlaySlow,card)
                            end
                        end
                    else
                        if tbl.container then
                            Player[params.color].broadcast("Cannot find impended card: " .. tbl.name .. "\nThis is in bag or deck with guid: " .. tbl.container .. "\nIf expected, ignore this message. Otherwise, please find it and put it in play!", Color.Orange)
                        else
                            Player[params.color].broadcast("Cannot find impended card: " .. tbl.name .. "\nIf expected, ignore this message. Otherwise, please find it and put it in play!", Color.Orange)
                        end
                    end
                end
            end
            -- Place all ready cards into play
            local spos = dances.getPosition()
            local xOffset = -9.5
            local xScale = 19
            local xSpacing = 1/math.max(5, #toPlayFast + #toPlaySlow - 1)
            local yOffset = -0.22
            local ySpacing = 0.05
            local zOffset = 16
            for ind,card in pairs(toPlayFast) do
                card.use_hands = false
                card.setPositionSmooth(spos + Vector(xOffset+xScale*(ind-1)*xSpacing, yOffset+(ind-1)*ySpacing, zOffset), false, false)
                card.setRotation({0,180,0})
                Wait.condition(
                    function() card.use_hands = true end,
                    function() return not card.isSmoothMoving() end,
                    3, -- don't think this timeout function will be necessary, but thought I'd add it to be safe
                    function()
                        card.use_hands = true
                        card.setPosition(spos + Vector(xOffset+xScale*(ind-1)*xSpacing, yOffset+(ind-1)*ySpacing, zOffset))
                    end
                )
            end
            for ind,card in pairs(toPlaySlow) do
                card.use_hands = false
                card.setPositionSmooth(spos + Vector(xOffset+xScale*(ind+#toPlayFast-1)*xSpacing, yOffset+(ind+#toPlayFast-1)*ySpacing, zOffset), false, false)
                card.setRotation({0,180,0})
                Wait.condition(
                    function() card.use_hands = true end,
                    function() return not card.isSmoothMoving() end,
                    3, -- don't think this timeout function will be necessary, but thought I'd add it to be safe
                    function()
                        card.use_hands = true
                        card.setPosition(spos + Vector(xOffset+xScale*(ind-1)*xSpacing, yOffset+(ind-1)*ySpacing, zOffset))
                    end
                )
            end
        end
    end
end

function onObjectEnterContainer(cont, obj)
    local guid = obj.guid
    if impendTable[guid] then
        impendTable[guid].container = cont.guid
    end
    updateSave()
end

function onObjectLeaveContainer(_container, obj)
    if impendTable[obj.guid] then
        impendTable[obj.guid].container = nil
        Wait.time(function() -- needs a wait otherwise the card's energy variable is nil
            createCardButtons(obj)
            updateEnergyDisplay(obj.guid)
            if g3Selected and impendTable[obj.guid].turnSelected ~= Global.getVar("turn") then
                createG3Buttons(obj)
                updateG3Buttons(obj.guid)
            end
        end, 0.01)
    end
    updateSave()
end

function modifyCost(params)
    local costs = params.costs
    if params.color == Global.call("getSpiritColor", {name = spiritName}) then
        for guid,_ in pairs(costs) do
            if impendTable[guid] then
                costs[guid] = 0
            end
        end
    end
    return costs
end
