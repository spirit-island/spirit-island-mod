difficulty=2

postSetup=true
postSetupComplete=false

thievesBag="baeea1"

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    local bag = scenarioBag.takeObject({
        guid = thievesBag,
        position = {-42.14, 0.71, 35.97},
        rotation = {0,0,0},
        smooth = false,
        callback_function = function(obj) obj.setLock(true) end,
    })
    bag.shuffle()
    postSetupComplete = true
end

function onObjectEnterContainer(container, _)
    if container.guid == thievesBag and Global.getVar("gameStarted") then
        container.shuffle()
    end
end
