function onObjectLeaveContainer(container, leave_object)
    if container == self then upd() end
end
function onObjectEnterContainer(container, enter_object)
    if container == self then
        local gameStarted = Global.getVar("gameStarted")
        if gameStarted then
            local blightTarget = Global.getVar("numPlayers") * 3
            if #self.getObjects() >= blightTarget then
                broadcastToAll("There is now 3 blight per player on the adversary card\nReturning the blight to the card due to Slow-healing Ecosystem - France Level 4", "Blue")
                local blightBag = Global.getVar("blightBag")
                for i = 1, blightTarget do
                    blightBag.putObject(self.takeObject({
                        position = vecSum(blightBag.getPosition(),{0,1,0}),
                        smooth = false,
                    }))
                end
            end
        end
        upd()
    end
end

function onLoad(saved_data)
    self.createButton({
        click_function = "nullFunc",
        function_owner = self,
        label          = #self.getObjects(),
        position       = {2.0,0.1,0},
        rotation       = {180,180,180},
        scale          = {2,2,2},
        width          = 0,
        height         = 0,
        font_size      = 500,
        font_color     = {0,0,0},
    })
end
function upd()
    self.editButton({
        index = 0,
        label = #self.getObjects(),
    })
end
function nullFunc() return end

function vecSum(vec1,vec2)
    return {vec1[1]+vec2[1], vec1[2]+vec2[2], vec1[3]+vec2[3]}
end