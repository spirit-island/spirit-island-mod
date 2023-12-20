function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "Ocean's Hungry Grasp"

function onDestroy()
    for _, obj in pairs(getAllObjects()) do
        if obj.getName() == "Deeps" and obj.getDescription() == spiritName then
            obj.destruct()
            break
        end
    end
end
