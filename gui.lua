
gui = {
    button = {},
    window = {},
    label = {}
}
gui.window[1] = guiCreateWindow(0.32, 0.40, 0.35, 0.20, "Cargo race", true)
guiWindowSetMovable(gui.window[1], false)
guiWindowSetSizable(gui.window[1], false)

gui.label[1] = guiCreateLabel(0.02, 0.18, 0.96, 0.24, "Need money? Well you've came to the right place! You must drive from A to B in an amount of time. The faster you are the more money you get.", true, gui.window[1])
guiSetFont(gui.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(gui.label[1], "center", true)
guiLabelSetVerticalAlign(gui.label[1], "center")
gui.button[1] = guiCreateButton(0.04, 0.66, 0.40, 0.21, "GO", true, gui.window[1])
gui.button[2] = guiCreateButton(0.56, 0.65, 0.40, 0.22, "Cancel", true, gui.window[1])


guiSetVisible(gui.window[1], false)


function gui:getVisible()
	return guiGetVisible(gui.window[1])
end

function gui:toggle()
	guiSetVisible(self.window[1], not self:getVisible())
	showCursor(not isCursorShowing())
end

-- Register event for server-side trigger.
addEvent("toggle", true)
addEventHandler("toggle", getRootElement(),
	function()
		gui:toggle()
	end)


addEventHandler("onClientGUIClick", gui.button[2],
	function()
		gui:toggle()
	end
)

addEventHandler("onClientGUIClick", gui.button[1],
	function()
		mission:start()
	end
)


addEventHandler("onClientRender", root,
    function()

    	if getElementData(localPlayer, "mission.inGame")  ~= false then
    		if time[1] == nil then time[1] = getTickCount() end
    		time[2] = getTickCount()
        	dxDrawText(tostring((mission.maxtime/1000) - round((time[2] - time[1])/1000)), Y((screenW - 269) / 2), Y(0), X((screenW - 269) / 2 + 269), Y(46), tocolor(255, 255, 255, 255), 1.00, "pricedown", "center", "center", false, false, false, false, false)
    		if (mission.maxtime - (time[2] - time[1])) <= 0 and mission.missionEnd ~= true then
    			--triggerEvent()
    			setElementData(getLocalPlayer(), "mission.inGame", false, true)
    			time[1], time[2] = nil, nil
    			mission:endMission("You are out of time.")
    		elseif mission.missionEnd then
    			mission:finish(mission.maxTime - (time[2] - time[1]))
    			time[1], time[2] = nil, nil
    		end
    	end
    end
)