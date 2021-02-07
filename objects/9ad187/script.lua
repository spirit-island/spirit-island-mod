canStart = true

adversaries = {
    ["None"] = "",
    ["Random"] = "",
    ["Prussia"] = "dd3d47",
    ["England"] = "b765cf",
    ["Sweden"] = "f114f8",
    ["France"] = "e8f3e3",
    ["Habsburg"] = "1d9bcd",
    ["Russia"] = "1ea4cf",
    ["Scotland"] = "37a592",
}
numAdversaries = 7
scenarios = {
    ["None"] = "",
    ["Random"] = "",
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
optionalBoardPairings = true
optionalScaleBoard = false

exploratoryVOTD = false
exploratoryBODAN = false
exploratoryWar = false

updateLayoutsID = 0
setupStarted = false

function onSave()
    local data_table = {}

    local adversaryList = {}
    for name,guid in pairs(adversaries) do
        table.insert(adversaryList, {name=name, guid=guid})
    end
    data_table.adversaryList = adversaryList

    local scenarioList = {}
    for name,guid in pairs(scenarios) do
        table.insert(scenarioList, {name=name, guid=guid})
    end
    data_table.scenarioList = scenarioList

    saved_data = JSON.encode(data_table)
    return saved_data
end
function onLoad(saved_data)
    if Global.getVar("gameStarted") then
        self.UI.hide("panelSetup")
        setupStarted = true
    end
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)

        adversaries = {}
        local count = 0
        for _,params in pairs(loaded_data.adversaryList) do
            adversaries[params.name] = params.guid
            if params.guid ~= "" then
                count = count + 1
            end
        end
        numAdversaries = count

        scenarios = {}
        count = 0
        for _,params in pairs(loaded_data.scenarioList) do
            scenarios[params.name] = params.guid
            if params.guid ~= "" then
                count = count + 1
            end
        end
        numScenarios = count

        if not setupStarted then
            toggleLeadingLevel(nil, Global.getVar("adversaryLevel"))
            toggleSupportingLevel(nil, Global.getVar("adversaryLevel2"))

            if Global.getVar("BnCAdded") then
                Global.setVar("useBnCEvents", true)
                self.UI.hide("bnc")
                self.UI.setAttribute("bncEvents", "isOn", "true")
            end
            if Global.getVar("JEAdded") then
                Global.setVar("useJEEvents", true)
                self.UI.hide("je")
                self.UI.setAttribute("jeEvents", "isOn", "true")
            end

            Wait.frames(updateAdversaryList, 1)
            Wait.frames(updateScenarioList, 3)
            Wait.frames(updateDifficulty, 5)
        end
    end
end

function onObjectSpawn(obj)
    if not setupStarted and obj.type == "Card" then
        local objType = type(obj.getVar("difficulty"))
        if objType == "table" then
            addAdversary(obj)
        elseif objType == "number" then
            -- Scenario
        end
    end
end
function addAdversary(obj)
    if adversaries[obj.getName()] == nil then
        numAdversaries = numAdversaries + 1
    end
    adversaries[obj.getName()] = obj.guid
    updateAdversaryList()
end
function onObjectDestroy(obj)
    if obj.hasTag("Spirit") then
        removeSpirit({spirit=obj.guid})
    elseif not setupStarted and obj.type == "Card" then
        local objType = type(obj.getVar("difficulty"))
        if objType == "table" then
            removeAdversary(obj)
        elseif objType == "number" then
            removeScenario(obj)
        end
    end
end
function removeAdversary(obj)
    for name,guid in pairs(adversaries) do
        if guid ~= "" and guid == obj.guid then
            adversaries[name] = nil
            numAdversaries = numAdversaries - 1
            if Global.getVar("adversaryCard") == obj then
                Global.setVar("adversaryCard", nil)
                toggleLeadingLevel(nil, 0)
            end
            if Global.getVar("adversaryCard2") == obj then
                Global.setVar("adversaryCard2", nil)
                toggleSupportingLevel(nil, 0)
            end
            Wait.frames(updateAdversaryList, 1)
            break
        end
    end
end
function updateAdversaryList()
    local adversaryList = {}
    for name,_ in pairs(adversaries) do
        table.insert(adversaryList, name)
    end

    local leadName = "None"
    local adversary = Global.getVar("adversaryCard")
    if adversary ~= nil then
        leadName = adversary.getName()
    elseif Global.getVar("useRandomAdversary") then
        leadName = "Random"
    end
    local supportName = "None"
    local adversary = Global.getVar("adversaryCard2")
    if adversary ~= nil then
        supportName = adversary.getName()
    elseif Global.getVar("useSecondAdversary") then
        supportName = "Random"
    end

    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownList(v, "leadingAdversary", adversaryList, -1, leadName)
        updateDropdownList(v, "supportingAdversary", adversaryList, -1, supportName)
    end
    self.UI.setXmlTable(t, {})
end
function removeScenario(obj)
    for name,guid in pairs(scenarios) do
        if guid ~= "" and guid == obj.guid then
            scenarios[name] = nil
            numScenarios = numScenarios - 1
            if Global.getVar("scenarioCard") == obj then
                Global.setVar("scenarioCard", nil)
                updateDifficulty()
            end
            Wait.frames(updateScenarioList, 1)
            break
        end
    end
end
function updateScenarioList()
    local scenarioList = {}
    for name,_ in pairs(scenarios) do
        table.insert(scenarioList, name)
    end

    local scenarioName = "None"
    local scenario = Global.getVar("scenarioCard")
    if scenario ~= nil then
        scenarioName = scenario.getName()
    elseif Global.getVar("useRandomScenario") then
        scenarioName = "Random"
    end

    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        updateDropdownList(v, "scenario", scenarioList, -1, scenarioName)
    end
    self.UI.setXmlTable(t, {})
end
function randomAdversary()
    local value = math.random(1,numAdversaries)
    local i = 1
    for _,guid in pairs(adversaries) do
        if guid == "" then
            -- noop
        elseif i == value then
            return getObjectFromGUID(guid)
        else
            i = i + 1
        end
    end
    return nil
end
function randomScenario()
    local value = math.random(1,numScenarios)
    local i = 1
    for _,guid in pairs(scenarios) do
        if guid == "" then
            -- noop
        elseif i == value then
            return getObjectFromGUID(guid)
        else
            i = i + 1
        end
    end
    return nil
end

---- Setup UI Section
function toggleNumPlayers(_, value)
    if Global.getVar("alternateSetupIndex") > 4 then
        Global.setVar("alternateSetupIndex", 1)
    end
    local numPlayers = tonumber(value)
    if numPlayers > 5 and optionalExtraBoard then
        numPlayers = 5
    end
    Global.setVar("numPlayers", numPlayers)
    self.UI.setAttribute("numPlayers", "text", "Number of Players: "..numPlayers)
    self.UI.setAttribute("numPlayersSlider", "value", numPlayers)

    -- Stop previous timer and start a new one
    if updateLayoutsID ~= 0 then
        Wait.stop(updateLayoutsID)
    end
    updateLayoutsID = Wait.time(function() updateBoardLayouts(numPlayers) end, 0.5)
end
function updateBoardLayouts(numPlayers)
    local t = self.UI.getXmlTable()
    if optionalExtraBoard then
        numPlayers = numPlayers + 1
    end
    for _,v in pairs(t) do
        updateDropdownList(v, "boardLayout", Global.getVar("alternateSetupNames")[numPlayers], Global.getVar("alternateSetupIndex"))
    end
    self.UI.setXmlTable(t, {})
end
function updateDropdownList(t, class, values, selectedIndex, selectedValue)
    if t.attributes.class ~= nil and string.match(t.attributes.class, class) then
        if t.attributes.id == class then
            t.children = {}
            for i,v in pairs(values) do
                t.children[i] = {
                    tag="Option",
                    value=v,
                    attributes={},
                    children={},
                }
                if i == selectedIndex then
                    t.children[i].attributes.selected = "true"
                elseif v == selectedValue then
                    t.children[i].attributes.selected = "true"
                end
            end
        else
            for _, v in pairs(t.children) do
                updateDropdownList(v, class, values, selectedIndex, selectedValue)
            end
        end
    end
end

function toggleScenario(_, value)
    if value == "Random" then
        Global.setVar("scenarioCard", nil)
        Global.setVar("useRandomScenario", true)
    else
        Global.setVar("scenarioCard", getObjectFromGUID(scenarios[value]))
        Global.setVar("useRandomScenario", false)
    end
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

-- TODO fix double adversary randomizer
function toggleLeadingAdversary(_, value)
    if value == "Random" then
        Global.setVar("adversaryCard", nil)
        Global.setVar("useRandomAdversary", true)
    else
        Global.setVar("adversaryCard", getObjectFromGUID(adversaries[value]))
        Global.setVar("useRandomAdversary", false)
    end
    if value == "None" or value == "Random" then
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
    if value == "Random" then
        Global.setVar("adversaryCard2", nil)
        Global.setVar("useSecondAdversary", true)
    else
        Global.setVar("adversaryCard2", getObjectFromGUID(adversaries[value]))
        Global.setVar("useSecondAdversary", false)
    end
    if value == "None" or value == "Random" then
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

function toggleBlightCard()
    local useBlightCard = Global.getVar("useBlightCard")
    useBlightCard = not useBlightCard
    Global.setVar("useBlightCard", useBlightCard)
    self.UI.setAttribute("blightCard", "isOn", useBlightCard)
end
function toggleBnCEvents()
    if not Global.getVar("BnCAdded") then
        self.UI.setAttribute("bncEvents", "isOn", "false")
        return
    end
    local useBnCEvents = Global.getVar("useBnCEvents")
    useBnCEvents = not useBnCEvents
    Global.setVar("useBnCEvents", useBnCEvents)
    self.UI.setAttribute("bncEvents", "isOn", useBnCEvents)
end
function toggleJEEvents()
    if not Global.getVar("JEAdded") then
        self.UI.setAttribute("jeEvents", "isOn", "false")
        return
    end
    local useJEEvents = Global.getVar("useJEEvents")
    useJEEvents = not useJEEvents
    Global.setVar("useJEEvents", useJEEvents)
    self.UI.setAttribute("jeEvents", "isOn", useJEEvents)
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
    if value == "Random" then
        Global.setVar("useRandomBoard", true)
        Global.setVar("includeThematic", false)
    elseif value == "Random with Thematic" then
        Global.setVar("useRandomBoard", true)
        Global.setVar("includeThematic", true)
    else
        Global.setVar("useRandomBoard", false)
        Global.setVar("includeThematic", false)
    end
    local index = 1
    for i,v in pairs(Global.getVar("alternateSetupNames")[Global.getVar("numPlayers")]) do
        if v == value then
            index = i
        end
    end
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
    Global.setVar("useBnCEvents", true)

    self.UI.hide("bnc")
    self.UI.setAttribute("bncEvents", "isOn", "true")
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

    wt(0.5)
    canStart = true
    return 1
end
function addJE()
    Global.setVar("JEAdded", true)
    Global.setVar("useJEEvents", true)

    self.UI.hide("je")
    self.UI.setAttribute("jeEvents", "isOn", "true")
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

    wt(0.5)
    canStart = true
    return 1
end

function updateDifficulty()
    local difficulty = difficultyCheck({})
    Global.setVar("difficulty", difficulty)
    self.UI.setAttribute("difficulty", "text", "Total Difficulty: "..difficulty)
end
function difficultyCheck(params)
    local difficulty = 0
    local leadingAdversary = Global.getVar("adversaryCard")
    if leadingAdversary ~= nil then
        difficulty = difficulty + leadingAdversary.getVar("difficulty")[Global.getVar("adversaryLevel")]
    elseif params.lead ~= nil then
        difficulty = difficulty + params.lead
    end
    local supportingAdversary = Global.getVar("adversaryCard2")
    if supportingAdversary ~= nil then
        local difficulty2 = supportingAdversary.getVar("difficulty")[Global.getVar("adversaryLevel2")]
        if difficulty > difficulty2 then
            difficulty = difficulty + (0.5 * difficulty2)
        else
            difficulty = (0.5 * difficulty) + difficulty2
        end
    elseif params.support ~= nil then
        local difficulty2 = params.support
        if difficulty > difficulty2 then
            difficulty = difficulty + (0.5 * difficulty2)
        else
            difficulty = (0.5 * difficulty) + difficulty2
        end
    end
    local alternateSetupIndex = Global.getVar("alternateSetupIndex")
    if alternateSetupIndex == 2 or params.thematic then
        if Global.getVar("BnCAdded") or Global.getVar("JEAdded") then
            difficulty = difficulty + 1
        else
            difficulty = difficulty + 3
        end
    end
    local scenario = Global.getVar("scenarioCard")
    if scenario ~= nil then
        difficulty = difficulty + scenario.getVar("difficulty")
    elseif params.scenario ~= nil then
        difficulty = difficulty + params.scenario
    end
    if optionalExtraBoard then
        local intNum = math.floor(difficulty / 3) + 2
        difficulty = difficulty + intNum
        if alternateSetupIndex == 2 then
            difficulty = difficulty - (intNum / 2)
        end
    end
    return difficulty
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

function toggleSimpleMode()
    local checked = self.UI.getAttribute("simpleMode", "isOn")
    if checked == "true" then
        self.UI.setAttribute("simpleMode", "isOn", "false")
        self.UI.setAttribute("leadingText", "text", "Adversary")
        self.UI.setAttribute("supportingHeader", "visibility", "Invisible")
        self.UI.setAttribute("supportingRow", "visibility", "Invisible")
        self.UI.setAttribute("events", "visibility", "Invisible")
        self.UI.setAttribute("optionalCell", "visibility", "Invisible")
        self.UI.setAttribute("toggles", "visibility", "Invisible")
        self.UI.setAttribute("panelOptional", "visibility", "Invisible")
        self.UI.setAttribute("panelRandom", "visibility", "Invisible")
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
    else
        self.UI.setAttribute("simpleMode", "isOn", "true")
        self.UI.setAttribute("leadingText", "text", "Leading Adversary")
        self.UI.setAttribute("supportingHeader", "visibility", "")
        self.UI.setAttribute("supportingRow", "visibility", "")
        self.UI.setAttribute("events", "visibility", "")
        self.UI.setAttribute("optionalCell", "visibility", "")
        self.UI.setAttribute("toggles", "visibility", "")
        showUI()
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

function toggleMinDifficulty(_, value)
    local maxDifficulty = Global.getVar("maxDifficulty")
    local minDifficulty = tonumber(value)
    if minDifficulty > maxDifficulty then
        Global.setVar("minDifficulty", maxDifficulty)
        self.UI.setAttribute("minDifficulty", "text", "Min Difficulty: "..maxDifficulty)
        self.UI.setAttribute("minDifficultySlider", "value", maxDifficulty)
        return
    end

    Global.setVar("minDifficulty", minDifficulty)
    self.UI.setAttribute("minDifficulty", "text", "Min Difficulty: "..value)
    self.UI.setAttribute("minDifficultySlider", "value", value)
end
function toggleMaxDifficulty(_, value)
    local minDifficulty = Global.getVar("minDifficulty")
    local maxDifficulty = tonumber(value)
    if maxDifficulty < minDifficulty  then
        Global.setVar("maxDifficulty", minDifficulty)
        self.UI.setAttribute("maxDifficulty", "text", "Max Difficulty: "..minDifficulty)
        self.UI.setAttribute("maxDifficultySlider", "value", minDifficulty)
        return
    end

    Global.setVar("maxDifficulty", maxDifficulty)
    self.UI.setAttribute("maxDifficulty", "text", "Max Difficulty: "..value)
    self.UI.setAttribute("maxDifficultySlider", "value", value)
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

    local numPlayers = Global.getVar("numPlayers")
    if optionalExtraBoard and numPlayers > 5 then
        toggleNumPlayers(nil, 5)
    else
        -- Stop previous timer and start a new one
        if updateLayoutsID ~= 0 then
            Wait.stop(updateLayoutsID)
        end
        updateLayoutsID = Wait.time(function() updateBoardLayouts(numPlayers) end, 0.5)
    end
end
function toggleThematicRedo()
    optionalThematicRedo = not optionalThematicRedo
    self.UI.setAttribute("thematicRedo", "isOn", optionalThematicRedo)
end
function toggleBoardPairings()
    optionalBoardPairings = not optionalBoardPairings
    self.UI.setAttribute("boardPairings", "isOn", optionalBoardPairings)
end
function toggleScale()
    optionalScaleBoard = not optionalScaleBoard
    self.UI.setAttribute("scaleBoard", "isOn", optionalScaleBoard)
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