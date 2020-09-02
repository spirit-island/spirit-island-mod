function onLoad()
    elementBags = {
        getObjectFromGUID("7651b3"),
        getObjectFromGUID("0925a3"),
        getObjectFromGUID("571055"),
        getObjectFromGUID("4daa3b"),
        getObjectFromGUID("0b27de"),
        getObjectFromGUID("be2784"),
        getObjectFromGUID("7625bc"),
        getObjectFromGUID("48cf16"),
    }

    --Sets position/color for the button, spawns it
    self.createButton({
        label="Energy Cost: 0", click_function="none", function_owner=self,
        position={0,2.24,-11.2}, rotation={0,180,0}, height=0, width=0,
        font_color={1,1,1}, font_size=500
    })
    for i = 1,8 do
        elementBags[i].createButton({
            label="0", click_function="none", function_owner=self,
            position={0,2.04,1.2}, rotation={0,0,0}, height=0, width=0,
            font_color={1,1,1}, font_size=500
        })
    end
    Wait.time(countItems,1,-1)
end
energy = 0
--Activated once per second, counts items in bowls
function countItems()
    local totalValue = 0
    local zone = getObjectFromGUID("190f05")
    local itemsInZone = zone.getObjects()
    local elemCardTable = {}
    energy = 0
    --Go through all items found in the zone
    for _, entry in ipairs(itemsInZone) do
        --Ignore non-cards
        if entry.tag == "Card" then
            --Ignore if no elements entry
            if entry.getVar("elements") ~= nil then
                if not entry.is_face_down and entry.getPosition().z > zone.getPosition().z then
                    table.insert(elemCardTable, entry)
                end
            end
        elseif entry.tag == "Tile" then
            if entry.getVar("elements") ~= nil then
                table.insert(elemCardTable, entry)
            end
        elseif entry.tag == "Generic" then
            if entry.getName() == "1 Energy" then
                energy = energy - 1
            elseif entry.getName() == "3 Energy" then
                energy = energy - 3
            end
        end
    end
    combinedElements = elemCombine(elemCardTable)
    self.editButton({index=0, label="Energy Cost: "..energy})
    for i,v in ipairs(combinedElements) do
        elementBags[i].editButton({index=0, label=v})
    end
    --Updates the number display
end

function elemStrToArr(elemStr)
    local outArr = {}
    for i = 1, string.len(elemStr) do
        table.insert(outArr,(math.floor(string.sub(elemStr, i, i))))
    end
    return outArr
end

function elemCombine(inTableOfElemStrCards)
    outTable = {0,0,0,0,0,0,0,0}
    for i = 1, #inTableOfElemStrCards do
        local elemTable = elemStrToArr(inTableOfElemStrCards[i].getVar("elements"))
        for j = 1, 8 do
            outTable[j] = outTable[j] + elemTable[j]
        end
        if inTableOfElemStrCards[i].getVar("energy") ~= nil then
            energy = energy + inTableOfElemStrCards[i].getVar("energy")
        end
    end
    return outTable
end