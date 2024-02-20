function onRotate(_, flip)
    if flip == 180.0 then
        Wait.condition(function()
            Global.call("makeSacredSite", {obj = self})
        end, function() return not self.isSmoothMoving() end)
    else
        self.setDecals({})
    end
end
