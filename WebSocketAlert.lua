
Instance.properties = properties({
	{ name="AlertName", type="Text", value="Alert", onUpdate="onNameUpdate" },
	{ name="onAction", type="Alert" },
	{ name="Variables", type="PropertyGroup", items={
		{ name="TextVariables", type="ObjectSet", set_types={type="PolyPopObject", index="WebSocket.TextVariables"} }
	}}
})

function Instance:onInit()
	self:onNameUpdate()
end

function Instance:onNameUpdate()
	self:setName(self.properties.AlertName)
end

function Instance:onMessage(data)
	local args = {}
	local textVariableCount = self.properties.Variables.TextVariables:getKit():getObjectCount()
	if (textVariableCount > 0) then
		for v=1,textVariableCount do
			local textVariable = self.properties.Variables.TextVariables:getKit():getObjectByIndex(v)
			args[textVariable.properties.VariableName] = textVariable.properties.Default
		end
	end
	if data.text then
		for k, v in pairs(data.text) do
			args[k] = v
		end
	end
	self.onAction:raise(args)
end