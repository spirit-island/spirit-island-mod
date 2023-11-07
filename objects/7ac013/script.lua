difficulty=3

postSetup=true
postSetupComplete=false

function onLoad()
    if Global.getVar("gameStarted") then
        self.createButton({
            click_function = "Victory",
            function_owner = self,
            label          = "Victory Achieved",
            position       = Vector(0.6, 1, -1.1),
            rotation       = Vector(0,0,0),
            scale          = Vector(0.2,0.2,0.2),
            width          = 2200,
            height         = 500,
            font_size      = 300,
        })
    end
end

function PostSetup()
    self.createButton({
        click_function = "Victory",
        function_owner = self,
        label          = "Victory Achieved",
        position       = Vector(0.6, 1, -1.1),
        rotation       = Vector(0,0,0),
        scale          = Vector(0.2,0.2,0.2),
        width          = 2200,
        height         = 500,
        font_size      = 300,
    })

    local deck = Player["Black"].getHandObjects(1)
    local dividersSetup = 0
    for _, obj in pairs(deck) do
        if obj.getName() == "Terror II" then
            obj.setPosition(Vector(-46.18, 0.82, 35.58))
            obj.setRotation(Vector(0, 180, 0))
            dividersSetup = dividersSetup + 1
        elseif obj.getName() == "Terror III" then
            obj.setPosition(Vector(-41.70, 0.82, 35.58))
            obj.setRotation(Vector(0, 180, 0))
            dividersSetup = dividersSetup + 1
        end
        if dividersSetup == 2 then
            break
        end
    end

    local fearDeck = Global.getVar("fearDeckSetupZone").getObjects()[1]
    if fearDeck ~= nil then
        local handZone = Player["Black"].getHandTransform(1)
        if fearDeck.type == "Deck" then
            for i=1,#fearDeck.getObjects() do
                fearDeck.takeObject({
                    position = handZone.position + Vector(-5 - (0.75 * i), 0, 0),
                    smooth = false,
                })
            end
            Wait.condition(function() postSetupComplete = true end, function() return fearDeck == nil end)
        elseif fearDeck.type == "Card" then
            fearDeck.setPosition(handZone.position + Vector(-5, 0, 0))
            postSetupComplete = true
        end
    else
        postSetupComplete = true
    end
end

function Victory()
    Global.setVar("terrorLevel", 4)
    Global.call("Victory")
end
