function onLoad(save_state)
    local data = {click_function = "next", function_owner = self, label = ">", position = {0.8, 0, 1.2}, scale = {0.5, 0.5, 0.5}, width = 400, height = 400, font_size = 400}
    self.createButton(data)
    local data = {click_function = "prev", function_owner = self, label = "<", position = {-0.8, 0, 1.2}, scale = {0.5, 0.5, 0.5}, width = 400, height = 400, font_size = 400}
    self.createButton(data)
end

function next()
    local state = self.getStateId()+1
    if state > #self.getStates()+1 then
        state = 1
    end
    self.setState(state)
end

function prev()
    local state = self.getStateId()-1
    if state < 1 then
        state = #self.getStates()+1
    end
    self.setState(state)
end