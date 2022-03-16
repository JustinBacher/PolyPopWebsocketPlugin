
Instance.properties = properties({
	{ name="Port", type="Int", value=38031, range={min=1, max=65535}, onUpdate="onPortUpdate" },
	{ name="Status", type="Text", value="Disconnected", ui={readonly=true} },
	{ name="Alerts", type="ObjectSet", set_types={type="PolyPopObject", index="WebSocket.WebSocketAlert"} }
})

function Instance:onInit()
	self:connect()
end

function Instance:send(cmd, data)
	if (not self.webSocket or not self.webSocket:isConnected()) then
		return
	end

	if (data) then
		self.webSocket:send(cmd .. ":" .. tostring(self:getUniqueID()) .. ":" .. tostring(data))
	else
		self.webSocket:send(cmd .. ":" .. tostring(self:getUniqueID()))
	end
end

function Instance:connect()
	getAnimator():createTimer(self, self.attemptConnection, seconds(5), true)
end

function Instance:attemptConnection()
	self:disconnect()

	local host = getNetwork():getHost("localhost")
	self.webSocket = host:openWebSocket("ws://127.0.0.1:" .. tostring(self.properties.Port))
	self.webSocket:setAutoReconnect(true)

	self.webSocket:addEventListener("onMessage", self, self.onMessage)
	self.webSocket:addEventListener("onConnected", self, self._onWsConnected)
	self.webSocket:addEventListener("onDisconnected", self, self._onWsDisconnected)
	--getEditor():addEventListener("onSceneChange", self, self.onSceneChange)
end

function Instance:_onWsConnected()
	getAnimator():stopTimer(self, self.attemptConnection)
	self.properties.Status = "Connected"
end

function Instance:_onWsDisconnected()
	self.properties.Status = "Disconnected"
	
	self:connect()
end

function Instance:onMessage(msg)
	local payload = json.decode(msg)

	if (payload.type == 'ALERT') then
		-- local data = json.decode(obj.data)
		-- Find the alert with the matching title
		local AlertCount = self.properties.Alerts:getKit():getObjectCount()
		for i=1,AlertCount do
			local Alert = self.properties.Alerts:getKit():getObjectByIndex(i)
			if (Alert.properties.AlertName == payload.title) then
				Alert:onMessage(payload.variables)
			end
		end
	end
end

function Instance:onPortUpdate()
	self:connect()
end

function Instance:disconnect()
	if (self.webSocket and self.webSocket:isConnected()) then
		self:send("disconnect", "unload")
		if (self.webSocket) then
			self.webSocket:disconnect()
		end
	end
end