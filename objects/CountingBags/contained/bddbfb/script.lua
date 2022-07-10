
function onLoad()
    upd()
end
function tryObjectEnter(object)
    if object.hasTag("Explorer") or object.hasTag("Town") or object.hasTag("City") or object.hasTag("Dahan") then
        return true
    else
        return false
    end
end
function onObjectEnterContainer(container, _)
    if container == self then upd() end
end
function onObjectLeaveContainer(container, _)
    if container == self then upd() end
end
function upd()
    local objects = {}
    for _, obj in pairs (self.getObjects()) do
        if objects[obj.name] == nil then
            objects[obj.name] = 1
        else
            objects[obj.name] = objects[obj.name]+1
        end
    end
    local keyset = {}
    local n = 0
    for k, _ in pairs(objects) do
        n=n+1
        keyset[n]=k
    end
    table.sort(keyset)
    local strings = {}
    for _, objName in pairs (keyset) do
        table.insert(strings,objects[objName].." x "..objName)
    end
    self.clearButtons()
    for i,string in pairs(strings) do
        self.createButton({
            click_function = "nullFunc",
            function_owner = self,
            label          = string,
            position       = {0,0.3,-1-i*(300 + 100 / #keyset)/450},
            rotation       = {0,180,0},
            width          = 00,
            height         = 0,
            font_size      = 300 + 100 / #keyset,
            font_color     = "White",
        })
    end
end
function nullFunc() end
