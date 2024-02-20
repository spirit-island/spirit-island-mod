spiritName = "Hearth-Vigil"

local startingEnergy = 1

function doSetup(params)
    local color = params.color
    Global.call("giveEnergy", {color=color, energy=startingEnergy, ignoreDebt=false})
    self.destruct()
    return true
end
