function onLoad()
    if not Global.getVar("gameStarted") then
        self.createButton({
            click_function = "getPowerCards",
            function_owner = self,
            label = "Add Days That Never Were",
            position = {0,0.2,0},
            rotation = {0,180,0},
            width = 3500,
            height = 500,
            font_size = 300,
        })
    end
end

function getPowerCards(_, color)
    doSpiritSetup{color=color}
end

function doSpiritSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing button!", "Red")
        return
    end

    local handZone = Player[color].getHandTransform(2)
    local newHandZone = {
        position = handZone.position,
        rotation = handZone.rotation,
        scale = handZone.scale,
    }
    newHandZone.position.z = newHandZone.position.z - 5.5
    Player[color].setHandTransform(newHandZone, 3)

    local zone = getObjectFromGUID(Global.getVar("elementScanZones")[color])
    local objs = zone.getObjects()
    local found = false
    for _,obj in pairs(objs) do
        if obj.guid == "013dfc" then
            found = true
            break
       end
    end
    if not found then
        Player[color].broadcast("You have not picked Fractured Days Split the Sky!", "Red")
        return
    end

    local count = 4
    if Global.getVar("numPlayers") <= 2 then
        count = 6
    end
    if Global.call("getMapCount", {norm = true, them = true}) == 1 then
        Player[color].broadcast("Don't forget to gain 1 Time", "Blue")
    end
    local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
    minorPowerDeck.deal(count, color, 3)
    local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
    majorPowerDeck.deal(count, color, 3)
    self.destruct()
end