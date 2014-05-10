
local elements = {
	marker = {}, 
	blip = {},	
}

--------------------------------------------
-- When player has entered marker
-- open gui.
--------------------------------------------
local function onMarkerHit (source, dimension)
	-- TODO: Open GUI.
	if getElementType(source) == "player" and dimension then
		triggerClientEvent(source, "toggle", getResourceRootElement())
		outputDebugString("{DEBUG}:-> Player "..getPlayerName(source):upper().." has entered marker.")
	end
end

--------------------------------------------
-- When the resource starts build the 
-- following elements
--------------------------------------------
addEventHandler("onResourceStart", getResourceRootElement(),
	function()
		local x,y,z = startPos.x, startPos.y, startPos.z
		elements.blip[1] = createBlip(x,y,z, 53, 2)
		elements.marker[1] = createMarker(x,y,z+2, 'cylinder', 2.5, 72, 118, 255, 250)
		outputDebugString("Resource "..getResourceName(getThisResource()).." has built elements server-side.")
		addEventHandler("onMarkerHit", elements.marker[1], onMarkerHit)
	end
)





--------------------------------------------
-- Create a vehicle and assign the element
-- data with the client who 
-- triggered it.
--------------------------------------------
local function createMissionVehicle()
	local thePlayer = client
	local ID = getRandomCarID()
	if type(ID) == "number" and getElementType(thePlayer) == "player" then
		local vehicle = createVehicle(ID, startPos.car.pos[1],startPos.car.pos[2],startPos.car.pos[3],0,0,90)
		setElementData(vehicle, "mission.owner", thePlayer, true) -- Use this to detect car owner, when entering finish line.
		return vehicle
	end
	collectgarbage()
	return false
end
addEvent("setupVehicle", true)
addEventHandler("setupVehicle",getRootElement(), createMissionVehicle)

--------------------------------------------
-- Clean up, destroy elements. GC
-- destroyAll is a boolean given when 
-- you want to destroy all elements and non
-- elements.
--------------------------------------------
local function destruct(destroyAll)
	local nonElem, elem = 0,0	-- Define counters.

	for k, v in ipairs(elements) do
		if isElement(v) then
			destroyElement(v)
			v = nil
			elem = elem + 1
		else
			nonElem = nonElem + 1
			if destroyAll then v = nil end
		end
	end
	outputDebugString("Destroyed "..tostring(elem).." elements. Kept "..tostring(nonElem).." non elements.")
	collectgarbage()
	return true
end


