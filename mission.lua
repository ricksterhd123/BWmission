local mission = 
{
	-- info = {}
}

--------------------------------------------
-- Load information onto mission table.
--------------------------------------------
function mission:loadMissionInfo()
	self.x, self.y, self.z, self.maxtime, self.cash = getRandomEndPosition()
	return true
end


--------------------------------------------
-- Create elements for client-side
-- cleans garbage if fails.
--------------------------------------------
function mission:buildElements()
	if self.x and self.y and self.z then
		self.marker = createMarker(self.x, self.y, self.z, "cylider", 2.5, 255, 50, 150, 250)
		self.blip = createBlip(self.x, self.y, self.z, 19)
		if self.marker and self.blip then
			outputDebugString("Resource "..getResourceName(getThisResource()).." has built elements client-side.")
			triggerServerEvent("setupVehicle", localPlayer)	-- Spawn vehicle, give the element data.

			addEventHandler("onClientMarkerHit", mission.marker, 
				function()
					if getElementType(source) == "vehicle" then
						if getElementData(source, "mission.owner") == localPlayer then
							mission.missionEnd = true
						end
					end
				end
			)
			return true
		end
	end
	assert(self.blip and self.marker, "Marker or blip will not build. Cleaning up.")
	self.blip, self.marker = nil, nil	-- Clean up.
	collectgarbage()
	return false
end

--------------------------------------------
-- Cleans up after mission or
-- when the unexpected happens.
--------------------------------------------

function mission:cleanup()
	self.x, self.y, self.z, self.maxtime, self.cash = nil, nil;
	self.missionEnd = nil	-- Variable for determination of mission end.
	if self.marker and self.blip then
		destroyElement(self.marker)
		destroyElement(self.blip)
	end

	setElementData(localPlayer, "mission.inGame", false)
	return true
end

--------------------------------------------
-- Give player data to detect if player has
-- started the mission.
--------------------------------------------
function mission:assignPlayer()
	if getElementData(localPlayer, "mission.inGame") == false then
		local assign = setElementData(localPlayer, "mission.inGame", true)
		if assign then
			return true
		end
		assert(assign, "Failed to give localPlayer elementData.")
	end
	return false
end

--------------------------------------------
-- Start the mission, load the elements
-- trigger server events.
--------------------------------------------
function mission:start()
	self:loadMissionInfo()
	local elem = self:buildElements() -- Build elements and spawn vehicle. 

	if elem then
		local player = self:assignPlayer()	-- Give localPlayer element data
		if player then
			return true
		end
	end
	mission:cleanup()	-- Cleanup otherwise
	return false
end


function mission:finish(time)
	if getElementData(localPlayer, "mission.inGame") then
		local time = time or nil; assert(time, "no time defined.")
		local multiplier = 1 + (time/self.maxtime)
		local money = getPlayerMoney() + (multiplier * maxtime)
		setPlayerMoney(money); outputDebugString("Gave player $"..tostring(money))
		self:cleanup()	-- Clean up.

		outputChatBox("#FF0000[Mission] #FFFFFFYou done the mission in "..tostring(time).." seconds")
	end
end

-- addEventHandler("onClientMarkerHit", mission.marker, 
-- 	function()
-- 		if getElementType(source) == "vehicle" then
-- 			if getElementData(source, "mission.owner") == localPlayer then
-- 				mission.missionEnd = true
-- 			end
-- 		end
-- 	end)

function mission:endMission(reason)
	reason = reason or "Mission has ended. Reason: Unknown"
	outputChatBox("#FF0000[Mission] #FFFFFF"..reason)
	self:cleanup()
end


addEventHandler("onClientResourceStop", getResourceRootElement(),
	function()
		mission:cleanup()
	end)