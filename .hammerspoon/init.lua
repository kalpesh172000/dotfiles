-- List apps in the same order as in your Dock
local dockApps = {
	--[[ "Finder", ]]
	"WezTerm",
	"Google Chrome",
	"Antigravity IDE",
	"DBeaver",
	"WhatsApp Web",
	"Spotify",
}

hs.hotkey.bind({ "cmd", "alt" }, "H", function()
	hs.alert("Hammerspoon is running!")
end)

local lastWindowIndex = {} -- store per-app index

local function cycleAppWindows(appName)
	local app = hs.application.get(appName)

	-- If app is not running → launch it
	if not app then
		hs.application.launchOrFocus(appName)
		return
	end

	-- Get all windows
	local wins = app:allWindows()

	-- Filter real windows (visible + standard)
	wins = hs.fnutils.filter(wins, function(win)
		return win:isStandard() and win:isVisible()
	end)

	if #wins == 0 then
		-- fallback: focus the app
		app:activate()
		return
	end

	-- Sort windows by id so ordering is stable across presses
	table.sort(wins, function(a, b)
		return a:id() < b:id()
	end)

	-- Was this app already the frontmost app?
	local frontApp = hs.application.frontmostApplication()
	local wasFocused = frontApp and frontApp:pid() == app:pid()

	local idx

	if wasFocused then
		-- Already on this app → cycle to the NEXT window
		idx = lastWindowIndex[appName] or 1
		idx = idx + 1
		if idx > #wins then
			idx = 1
		end
	else
		-- Switching in from another app → try to focus the currently
		-- focused window of THIS app (if any), otherwise fall back
		-- to the last one we remember, otherwise window 1.
		local focusedWin = app:focusedWindow()
		idx = nil

		if focusedWin then
			for i, w in ipairs(wins) do
				if w:id() == focusedWin:id() then
					idx = i
					break
				end
			end
		end

		if not idx then
			idx = lastWindowIndex[appName] or 1
		end

		if idx > #wins then
			idx = 1
		end
	end

	-- Focus target window
	wins[idx]:focus()

	-- Remember index for next time
	lastWindowIndex[appName] = idx
end

-- Bind keys for your apps
for i, appName in ipairs(dockApps) do
	hs.hotkey.bind({ "cmd" }, tostring(i), function()
		cycleAppWindows(appName)
	end)
end

hs.hotkey.bind({ "cmd", "alt" }, "1", function()
	hs.alert("override works")
end)
