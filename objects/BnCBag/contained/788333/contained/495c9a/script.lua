blight=2

function modifyGain(params)
    if Global.getVar("blightedIsland") and Global.getVar("blightedIslandCard").guid == self.guid then
        return params.amount + 1
    else
        return params.amount
    end
end
