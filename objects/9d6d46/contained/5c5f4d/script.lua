function onRotate()
    Wait.condition(function()
        Global.call("makeSacredSite", {obj = self})
    end, function() return not self.isSmoothMoving() end)
end
