-- List apps in the same order as in your Dock
local dockApps = {
	--[[ "Finder", ]]
	"WezTerm",
	"Google Chrome",
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

	-- Sort windows by last use time (Chrome likes this better)
	table.sort(wins, function(a, b)
		return a:application():pid() == b:application():pid() and a:id() < b:id()
	end)

	-- Retrieve index for this app
	local idx = lastWindowIndex[appName] or 1

	if idx > #wins then
		idx = 1
	end

	-- Focus target window
	wins[idx]:focus()

	-- Prepare next index
	idx = idx + 1
	if idx > #wins then
		idx = 1
	end

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
