canStart = true

adversaries = {
    ["None"] = "",
    ["Prussia"] = "dd3d47",
    ["England"] = "b765cf",
    ["Sweden"] = "f114f8",
    ["France"] = "e8f3e3",
    ["Habsburg"] = "1d9bcd",
    ["Russia"] = "1ea4cf",
    ["Scotland"] = "37a592",
}
scenarios = {
    ["None"] = "",
    ["Blitz"] = "1b39da",
    ["Guard the Isle's Heart"] = "04397d",
    ["Rituals of Terror"] = "7ac013",
    ["Dahan Insurrection"] = "ee90ad",
    ["Ward the Shores"] = "bd528e",
    ["Powers Long Forgotten"] = "ca88f0",
    ["Rituals of the Destroying Flame"] = "a69e8c",
    ["Second Wave"] = "e924fe",
    ["The Great River"] = "5a95bc",
    ["Elemental Invocation"] = "b8b521",
    ["Despicable Theft"] = "ec49d4",
    ["Varied Terrains"] = "64caee",
    ["A Diversity of Spirits"] = "3d1ba3",
}
numScenarios = 13

spiritGuids = {}
spiritTags = {}
spiritChoices = {}
spiritChoicesLength = 0

optionalSoloBlight = true
optionalStrangeMadness = false
optionalBlightSetup = true
optionalExtraBoard = false
optionalThematicRedo = false

exploratoryVOTD = false
exploratoryBODAN = false
exploratoryWar = false

updateLayoutsID = 0

function onObjectDestroy(obj)
    if spiritTags[obj.guid] ~= nil then
        removeSpirit({spirit=obj.guid})
    end
end

---- Setup UI Section
function toggleNumPlayers(_, value)
    if Global.getVar("alternateSetupIndex") > 1 then
        Global.setVar("alternateSetupIndex", 1)
    end
    Global.setVar("numPlayers", tonumber(value))
    self.UI.setAttribute("numPlayers", "text", "Number of Players: "..value)
    self.UI.setAttribute("numPlayersSlider", "value", value)

    -- Stop previous timer and start a new one
    if updateLayoutsID ~= 0 then
        Wait.stop(updateLayoutsID)
    end
    updateLayoutsID = Wait.time(function() updateBoardLayouts(value) end, 0.5)
end
function updateBoardLayouts(value)
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownList(v, "boardLayout", Global.getVar("alternateSetupNames")[tonumber(value)], Global.getVar("alternateSetupIndex"))
    end
    self.UI.setXmlTable(t, {})
end
function updateDropdownList(t, class, values, selected)
    if t.attributes.class ~= nil and string.match(t.attributes.class, class) then
        if t.attributes.id == class then
            t.children = {}
            for i,v in pairs(values) do
                -- Thematic is index 0, but should appear second in list
                local newIndex = i + 1
                if i == 0 then
                    newIndex = 2
                elseif i == 1 then
                    newIndex = 1
                end
                t.children[newIndex] = {
                    tag="Option",
                    value=v,
                    attributes={},
                    children={},
                }
                if i == selected then
                    t.children[newIndex].attributes.selected = "true"
                end
            end
        else
            for _, v in pairs(t.children) do
                updateDropdownList(v, class, values, selected)
            end
        end
    end
end

function toggleScenario(_, value)
    Global.setVar("scenarioCard", getObjectFromGUID(scenarios[value]))
    updateDifficulty()

    -- Wait for difficulty to update
    Wait.frames(function() updateScenarioSelection(value) end, 1)
end
function updateScenarioSelection(name)
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownSelection(v, "scenario", name)
    end
    self.UI.setXmlTable(t, {})
end

function toggleLeadingAdversary(_, value)
    Global.setVar("adversaryCard", getObjectFromGUID(adversaries[value]))
    if value == "None" then
        toggleLeadingLevel(nil, 0)
    else
        updateDifficulty()
        self.UI.setAttribute("leadingLevelSlider", "enabled", "true")
    end

    -- Wait for difficulty to update
    Wait.frames(function() updateLeadingSelection(value) end, 1)
end
function updateLeadingSelection(name)
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownSelection(v, "leadingAdversary", name)
    end
    self.UI.setXmlTable(t, {})
end
function toggleSupportingAdversary(_, value)
    Global.setVar("adversaryCard2", getObjectFromGUID(adversaries[value]))
    if value == "None" then
        toggleSupportingLevel(nil, 0)
    else
        updateDifficulty()
        self.UI.setAttribute("supportingLevelSlider", "enabled", "true")
    end

    -- Wait for difficulty to update
    Wait.frames(function() updateSupportingSelection(value) end, 1)
end
function updateSupportingSelection(name)
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownSelection(v, "supportingAdversary", name)
    end
    self.UI.setXmlTable(t, {})
end
function toggleLeadingLevel(player, value)
    if Global.getVar("adversaryCard") == nil then
        Global.setVar("adversaryLevel", 0)
        value = 0
    else
        Global.setVar("adversaryLevel", tonumber(value))
    end
    if player == nil then
        self.UI.setAttribute("leadingLevelSlider", "enabled", "false")
    end
    self.UI.setAttribute("leadingLevel", "text", "Level: "..value)
    self.UI.setAttribute("leadingLevelSlider", "value", value)
    updateDifficulty()
end
function toggleSupportingLevel(player, value)
    if Global.getVar("adversaryCard2") == nil then
        Global.setVar("adversaryLevel2", 0)
        value = 0
    else
        Global.setVar("adversaryLevel2", tonumber(value))
    end
    if player == nil then
        self.UI.setAttribute("supportingLevelSlider", "enabled", "false")
    end
    self.UI.setAttribute("supportingLevel", "text", "Level: "..value)
    self.UI.setAttribute("supportingLevelSlider", "value", value)
    updateDifficulty()
end
function addAdversary(params)
    adversaries[params.obj.getName()] = params.obj.guid
    updateAdversaryList()
end
function checkAdversaries()
    local adversaryRemoved = false
    for name,guid in pairs(adversaries) do
        if guid ~= "" then
            local obj = getObjectFromGUID(guid)
            if obj == nil then
                adversaries[name] = nil
                adversaryRemoved = true
                if Global.getVar("adversaryCard") == nil then
                    toggleLeadingLevel(nil, 0)
                end
                if Global.getVar("adversaryCard2") == nil then
                    toggleSupportingLevel(nil, 0)
                end
            end
        end
    end
    if adversaryRemoved then
        -- Wait for levels to update
        Wait.frames(updateAdversaryList, 1)
    end
end
function updateAdversaryList()
    local adversaryList = {}
    for name,_ in pairs(adversaries) do
        table.insert(adversaryList, name)
    end
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownList(v, "leadingAdversary", adversaryList)
        updateDropdownList(v, "supportingAdversary", adversaryList)
    end
    self.UI.setXmlTable(t, {})
end

function toggleBlightCard()
    local useBlightCard = Global.getVar("useBlightCard")
    useBlightCard = not useBlightCard
    Global.setVar("useBlightCard", useBlightCard)
    self.UI.setAttribute("blightCard", "isOn", useBlightCard)
end
function toggleEventDeck()
    if not Global.getVar("BnCAdded") and not Global.getVar("JEAdded") then
        self.UI.setAttribute("eventDeck", "isOn", "false")
        return
    end
    local useEventDeck = Global.getVar("useEventDeck")
    useEventDeck = not useEventDeck
    Global.setVar("useEventDeck", useEventDeck)
    self.UI.setAttribute("eventDeck", "isOn", useEventDeck)
end

function updateDropdownSelection(t, class, value)
    if t.attributes.class ~= nil and string.match(t.attributes.class, class) then
        if t.attributes.id == class then
            for _,v in pairs(t.children) do
                if v.value == value then
                    v.attributes.selected = "true"
                elseif v.attributes.selected == "true" then
                    v.attributes.selected = "false"
                end
            end
        else
            for _, v in pairs(t.children) do
                updateDropdownSelection(v, class, value)
            end
        end
    end
end
function toggleBoardLayout(_, value)
    local index = 1
    for i,v in pairs(Global.getVar("alternateSetupNames")[Global.getVar("numPlayers")]) do
        if v == value then
            index = i
        end
    end
    print(index)
    Global.setVar("alternateSetupIndex", index)
    updateDifficulty()

    -- Wait for difficulty to update
    Wait.frames(function() updateBoardLayout(value) end, 1)
end
function updateBoardLayout(name)
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownSelection(v, "boardLayout", name)
    end
    self.UI.setXmlTable(t, {})
end

function addBnC()
    Global.setVar("BnCAdded", true)
    Global.setVar("useEventDeck", true)

    self.UI.hide("bnc")
    self.UI.setAttribute("eventDeck", "isOn", "true")
    updateDifficulty()

    Wait.condition(function() startLuaCoroutine(self, "addBnCCo") end, function() return canStart end)
end
function addBnCCo()
    canStart = false
    local BnCBag = getObjectFromGUID("ea7207")

    local fearDeck = BnCBag.takeObject({guid = "d16f70"})
    getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1].putObject(fearDeck)
    local minorPowers = BnCBag.takeObject({guid = "913789"})
    getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1].putObject(minorPowers)
    local majorPowers = BnCBag.takeObject({guid = "07ac50"})
    getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1].putObject(majorPowers)
    local blightCards = BnCBag.takeObject({guid = "788333"})
    getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)
    BnCBag.takeObject({
        guid = "05f7b7",
        position = getObjectFromGUID("b18505").getPosition(),
        rotation = {0,180,180},
    })

    wt(0.5)
    canStart = true
    return 1
end
function addJE()
    Global.setVar("JEAdded", true)
    Global.setVar("useEventDeck", true)

    self.UI.hide("je")
    self.UI.setAttribute("eventDeck", "isOn", "true")
    updateDifficulty()

    Wait.condition(function() startLuaCoroutine(self, "addJECo") end, function() return canStart end)
end
function addJECo()
    canStart = false
    local JEBag = getObjectFromGUID("850ac1")

    local fearDeck = JEBag.takeObject({guid = "723183"})
    getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1].putObject(fearDeck)
    local minorPowers = JEBag.takeObject({guid = "80b54a"})
    getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1].putObject(minorPowers)
    local majorPowers = JEBag.takeObject({guid = "98a916"})
    getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1].putObject(majorPowers)
    local blightCards = JEBag.takeObject({guid = "8120e0"})
    getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)
    JEBag.takeObject({
        guid = "299e38",
        position = getObjectFromGUID("b18505").getPosition(),
        rotation = {0,180,180},
    })

    wt(0.5)
    canStart = true
    return 1
end

function updateDifficulty()
    local difficulty = 0
    local leadingAdversary = Global.getVar("adversaryCard")
    if leadingAdversary ~= nil then
        difficulty = difficulty + leadingAdversary.getVar("difficulty")[Global.getVar("adversaryLevel")]
    end
    local supportingAdversary = Global.getVar("adversaryCard2")
    if supportingAdversary ~= nil then
        local difficulty2 = supportingAdversary.getVar("difficulty")[Global.getVar("adversaryLevel2")]
        if difficulty > difficulty2 then
            difficulty = difficulty + (0.5 * difficulty2)
        else
            difficulty = (0.5 * difficulty) + difficulty2
        end
    end
    local alternateSetupIndex = Global.getVar("alternateSetupIndex")
    if alternateSetupIndex == 0 then
        if Global.getVar("BnCAdded") or Global.getVar("JEAdded") then
            difficulty = difficulty + 1
        else
            difficulty = difficulty + 3
        end
    end
    local scenario = Global.getVar("scenarioCard")
    if scenario ~= nil then
        difficulty = difficulty + scenario.getVar("difficulty")
    end
    if optionalExtraBoard then
        local intNum = math.floor(difficulty / 3) + 2
        difficulty = difficulty + intNum
        if alternateSetupIndex == 0 then
            difficulty = difficulty - (intNum / 2)
        end
    end
    Global.setVar("difficulty", difficulty)
    self.UI.setAttribute("difficulty", "text", "Total Difficulty: "..difficulty)
end

function startGame()
    Global.call("SetupGame", {})
end
function showUI()
    self.UI.setAttribute("panelSetup", "visibility", "")
    self.UI.setAttribute("panelSetupSmall", "visibility", "Invisible")
    if self.UI.getAttribute("optionalRules", "isOn") == "true" then
        self.UI.setAttribute("panelOptional", "visibility", "")
    end
    if self.UI.getAttribute("randomizers", "isOn") == "true" then
        self.UI.setAttribute("panelRandom", "visibility", "")
    end
    if self.UI.getAttribute("exploratory", "isOn") == "true" then
        self.UI.setAttribute("panelExploratory", "visibility", "")
    end
    self.UI.setAttribute("panelAdvesaryScenario", "visibility", "")
end
function hideUI()
    closeUI()
    self.UI.setAttribute("panelSetupSmall", "visibility", "")
end
function closeUI()
    self.UI.setAttribute("panelSetup", "visibility", "Invisible")
    self.UI.setAttribute("panelSetupSmall", "visibility", "Invisible")
    self.UI.setAttribute("panelOptional", "visibility", "Invisible")
    self.UI.setAttribute("panelRandom", "visibility", "Invisible")
    self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
    self.UI.setAttribute("panelAdvesaryScenario", "visibility", "Invisible")
end

function toggleRandomizers()
    local checked = self.UI.getAttribute("randomizers", "isOn")
    if checked == "true" then
        self.UI.setAttribute("randomizers", "isOn", "false")
        self.UI.setAttribute("panelRandom", "visibility", "Invisible")
    else
        self.UI.setAttribute("randomizers", "isOn", "true")
        self.UI.setAttribute("panelRandom", "visibility", "")
    end
end
function toggleOptionalRules()
    local checked = self.UI.getAttribute("optionalRules", "isOn")
    if checked == "true" then
        self.UI.setAttribute("optionalRules", "isOn", "false")
        self.UI.setAttribute("panelOptional", "visibility", "Invisible")
    else
        self.UI.setAttribute("optionalRules", "isOn", "true")
        self.UI.setAttribute("panelOptional", "visibility", "")
    end
end
function toggleExploratory()
    local checked = self.UI.getAttribute("exploratory", "isOn")
    if checked == "true" then
        self.UI.setAttribute("exploratory", "isOn", "false")
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
    else
        self.UI.setAttribute("exploratory", "isOn", "true")
        self.UI.setAttribute("panelExploratory", "visibility", "")
    end
end

function toggleRandomScenario()
    local useRandomScenario = Global.getVar("useRandomScenario")
    useRandomScenario = not useRandomScenario
    Global.setVar("useRandomScenario", useRandomScenario)
    self.UI.setAttribute("randomScenario", "isOn", useRandomScenario)
end
function toggleMinDifficulty(_, value)
    Global.setVar("useRandomAdversary", true)
    self.UI.setAttribute("randomAdversary", "isOn", "true")

    local maxDifficulty = Global.getVar("maxDifficulty")
    local minDifficulty = tonumber(value)
    if minDifficulty > maxDifficulty then
        Global.setVar("minDifficulty", maxDifficulty)
        self.UI.setAttribute("minDifficulty", "text", "Min Adversary Difficulty: "..maxDifficulty)
        self.UI.setAttribute("minDifficultySlider", "value", maxDifficulty)
        return
    end

    Global.setVar("minDifficulty", minDifficulty)
    self.UI.setAttribute("minDifficulty", "text", "Min Adversary Difficulty: "..value)
    self.UI.setAttribute("minDifficultySlider", "value", value)
end
function toggleMaxDifficulty(_, value)
    Global.setVar("useRandomAdversary", true)
    self.UI.setAttribute("randomAdversary", "isOn", "true")

    local minDifficulty = Global.getVar("minDifficulty")
    local maxDifficulty = tonumber(value)
    if maxDifficulty < minDifficulty  then
        Global.setVar("maxDifficulty", minDifficulty)
        self.UI.setAttribute("maxDifficulty", "text", "Max Adversary Difficulty: "..minDifficulty)
        self.UI.setAttribute("maxDifficultySlider", "value", minDifficulty)
        return
    end

    Global.setVar("maxDifficulty", maxDifficulty)
    self.UI.setAttribute("maxDifficulty", "text", "Max Adversary Difficulty: "..value)
    self.UI.setAttribute("maxDifficultySlider", "value", value)
end

function toggleRandomSupportingAdversary()
    Global.setVar("useRandomAdversary", true)
    self.UI.setAttribute("randomAdversary", "isOn", "true")

    local useSecondAdversary = Global.getVar("useSecondAdversary")
    useSecondAdversary = not useSecondAdversary
    Global.setVar("useSecondAdversary", useSecondAdversary)
    self.UI.setAttribute("randomSupportingAdversary", "isOn", useSecondAdversary)

    if useSecondAdversary then
        self.UI.setAttribute("minDifficultySlider", "maxValue", 16)
        self.UI.setAttribute("maxDifficultySlider", "minValue", 2)
        self.UI.setAttribute("maxDifficultySlider", "maxValue", 17)
        if Global.getVar("maxDifficulty") < 2 then
            Global.setVar("maxDifficulty", 2)
            self.UI.setAttribute("maxDifficulty", "text", "Max Adversary Difficulty: "..2)
            self.UI.setAttribute("maxDifficultySlider", "value", 2)
        end
    else
        self.UI.setAttribute("minDifficultySlider", "maxValue", 11)
        self.UI.setAttribute("maxDifficultySlider", "minValue", 1)
        self.UI.setAttribute("maxDifficultySlider", "maxValue", 11)
        if Global.getVar("minDifficulty") > 11 then
            Global.setVar("minDifficulty", 11)
            self.UI.setAttribute("minDifficulty", "text", "Min Adversary Difficulty: "..11)
            self.UI.setAttribute("minDifficultySlider", "value", 11)
        end
        if Global.getVar("maxDifficulty") > 11 then
            Global.setVar("maxDifficulty", 11)
            self.UI.setAttribute("maxDifficulty", "text", "Max Adversary Difficulty: "..11)
            self.UI.setAttribute("maxDifficultySlider", "value", 11)
        end
    end
end
function toggleRandomAdversary()
    local useRandomAdversary = Global.getVar("useRandomAdversary")
    useRandomAdversary = not useRandomAdversary
    Global.setVar("useRandomAdversary", useRandomAdversary)
    self.UI.setAttribute("randomAdversary", "isOn", useRandomAdversary)
end
function toggleRandomLayoutThematic()
    Global.setVar("useRandomBoard", true)
    self.UI.setAttribute("randomLayout", "isOn", "true")

    local includeThematic = Global.getVar("includeThematic")
    includeThematic = not includeThematic
    Global.setVar("includeThematic", includeThematic)
    self.UI.setAttribute("randomLayoutThematic", "isOn", includeThematic)
end
function toggleRandomLayout()
    local useRandomBoard = Global.getVar("useRandomBoard")
    useRandomBoard = not useRandomBoard
    Global.setVar("useRandomBoard", useRandomBoard)
    self.UI.setAttribute("randomLayout", "isOn", useRandomBoard)
end

function randomSpirit(player)
    if #getObjectFromGUID(Global.getVar("PlayerBags")[player.color]).getObjects() == 0 then
        broadcastToColor("You already picked a spirit", player.color, "Red")
        return
    end

    local spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    spirit.call("PickSpirit", {color = player.color, random = {aspect = true}})
    broadcastToColor("Your randomised spirit is "..spirit.getName(), player.color, "Blue")
end
function randomJESpirit(player)
    if #getObjectFromGUID(Global.getVar("PlayerBags")[player.color]).getObjects() == 0 then
        broadcastToColor("You already picked a spirit", player.color, "Red")
        return
    end

    local guid = spiritGuids[math.random(1,#spiritGuids)]
    while(spiritTags[guid] ~= "JE") do
        guid = spiritGuids[math.random(1,#spiritGuids)]
    end
    local spirit = getObjectFromGUID(guid)
    spirit.call("PickSpirit", {color = player.color, random = {aspect = true}})
    broadcastToColor("Your randomised Jagged Earth spirit is "..spirit.getName(), player.color, "Blue")
end
function gainSpirit(player)
    local obj = getObjectFromGUID(Global.getVar("elementScanZones")[player.color])
    if obj.getButtons() ~= nil and #obj.getButtons() ~= 0 then
        broadcastToColor("You already have Spirit options", player.color, Color.SoftYellow)
        return
    elseif #getObjectFromGUID(Global.getVar("PlayerBags")[player.color]).getObjects() == 0 then
        broadcastToColor("You already picked a spirit", player.color, "Red")
        return
    end
    broadcastToColor("Your 4 randomised spirits to choose from are in your play area", player.color, Color.SoftBlue)

    local spirit1 = getNewSpirit()
    local spirit2 = getNewSpirit()
    local spirit3 = getNewSpirit()
    local spirit4 = getNewSpirit()

    if spirit1 ~= nil then
        obj.createButton({
            click_function = "pickSpirit1",
            function_owner = self,
            label = spirit1.getName(),
            position = Vector(0,0,-0.15),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
    if spirit2 ~= nil then
        obj.createButton({
            click_function = "pickSpirit2",
            function_owner = self,
            label = spirit2.getName(),
            position = Vector(0,0,-0.3),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
    if spirit3 ~= nil then
        obj.createButton({
            click_function = "pickSpirit3",
            function_owner = self,
            label = spirit3.getName(),
            position = Vector(0,0,-0.45),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
    if spirit4 ~= nil then
        obj.createButton({
            click_function = "pickSpirit4",
            function_owner = self,
            label = spirit4.getName(),
            position = Vector(0,0,-0.6),
            rotation = Vector(0,180,0),
            scale = Vector(0.1,0.1,0.1),
            width = 4850,
            height = 600,
            font_size = 290,
        })
    end
end
function getNewSpirit()
    if spiritChoicesLength >= #spiritGuids then
        return nil
    end
    local spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    while (spiritChoices[spirit.getName()]) do
        spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    end
    spiritChoices[spirit.getName()] = spirit.guid
    spiritChoicesLength = spiritChoicesLength + 1
    return spirit
end
function pickSpirit1(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 0, color)
end
function pickSpirit2(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 1, color)
end
function pickSpirit3(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 2, color)
end
function pickSpirit4(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 3, color)
end
function pickSpirit(obj, index, color)
    local name = obj.getButtons()[index+1].label
    if isSpiritPickable({guid = spiritChoices[name]}) then
        getObjectFromGUID(spiritChoices[name]).call("PickSpirit", {color = color, random = {aspect = true}})
        obj.clearButtons()
    else
        broadcastToColor("Spirit unavailable getting new one", color, Color.SoftYellow)
        local spirit = getNewSpirit()
        if spirit ~= nil then
            obj.editButton({
                index = index,
                label = spirit.getName(),
            })
        else
            obj.editButton({
                index = index,
                label = "",
                width = 0,
                height = 0,
            })
        end
    end
end
function isSpiritPickable(params)
    for _,v in pairs(spiritGuids) do
        if v == params.guid then
            return true
        end
    end
    return false
end
function addSpirit(params)
    -- Ignore Source Spirit
    if params.spirit.guid == "21f561" then return end

    -- If spirit has multiple states remove the other copies of it from the spirit table
    local states = params.spirit.getStates()
    if states ~= nil and #states ~= 0 then
        for _,state in pairs(states) do
            if spiritTags[state.guid] ~= nil then
                removeSpirit({spirit=state.guid})
                spiritTags[state.guid] = nil
            end
        end
    end

    table.insert(spiritGuids, params.spirit.guid)
    spiritTags[params.spirit.guid] = params.spirit.getDescription()
end
function removeSpirit(params)
    for i,guid in pairs(spiritGuids) do
        if guid == params.spirit then
            table.remove(spiritGuids, i)
            break
        end
    end
end

function toggleSoloBlight()
    optionalSoloBlight = not optionalSoloBlight
    self.UI.setAttribute("soloBlight", "isOn", optionalSoloBlight)
end
function toggleStrangeMadness()
    optionalStrangeMadness = not optionalStrangeMadness
    self.UI.setAttribute("strangeMadness", "isOn", optionalStrangeMadness)
end
function toggleSlaveRebellion()
    local checked = self.UI.getAttribute("slaveRebellion", "isOn")
    local obj = getObjectFromGUID(adversaries.France)
    if checked == "true" then
        checked = "false"
        if obj ~= nil then
            obj.setVar("thematicRebellion", false)
        end
    else
        checked = "true"
        if obj ~= nil then
            obj.setVar("thematicRebellion", true)
        end
    end
    self.UI.setAttribute("slaveRebellion", "isOn", checked)
end
function toggleEngland6()
    local checked = self.UI.getAttribute("england6", "isOn")
    local obj = getObjectFromGUID(adversaries.England)
    if checked == "true" then
        checked = "false"
        if obj ~= nil then
            obj.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 10})
            updateDifficulty()
        end
    else
        checked = "true"
        if obj ~= nil then
            obj.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 11})
            updateDifficulty()
        end
    end
    self.UI.setAttribute("england6", "isOn", checked)
end
function toggleBlightSetup()
    optionalBlightSetup = not optionalBlightSetup
    self.UI.setAttribute("blightSetup", "isOn", optionalBlightSetup)
end
function toggleExtraBoard()
    optionalExtraBoard = not optionalExtraBoard
    self.UI.setAttribute("extraBoard", "isOn", optionalExtraBoard)
    updateDifficulty()
end
function toggleThematicRedo()
    optionalThematicRedo = not optionalThematicRedo
    self.UI.setAttribute("thematicRedo", "isOn", optionalThematicRedo)
end

function toggleVOTD()
    exploratoryVOTD = not exploratoryVOTD
    self.UI.setAttribute("votd", "isOn", exploratoryVOTD)
end
function toggleBODAN()
    exploratoryBODAN = not exploratoryBODAN
    self.UI.setAttribute("bodan", "isOn", exploratoryBODAN)
end
function toggleWar()
    exploratoryWar = not exploratoryWar
    self.UI.setAttribute("war", "isOn", exploratoryWar)
end

function wt(some)
    local Time = os.clock() + some
    while os.clock() < Time do
        coroutine.yield(0)
    end
end