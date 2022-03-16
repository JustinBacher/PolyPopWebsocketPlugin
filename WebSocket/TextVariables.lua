
Instance.properties = properties({
	{ name="VariableName", type="Text", value="NewVariable", onUpdate="onNameUpdate" },
	{ name="Default", type="Text", value=""},
})

function Instance:onInit()
	self:onNameUpdate()
end

function Instance:onNameUpdate()
	self:setName(self.properties.VariableName)
end