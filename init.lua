
permatime = {
	override = nil
}

local storage = core.get_mod_storage()
local S = core.get_translator('permatime')

local function time_to_override(time)
	if time == nil then return nil end

	if time + 0.5 > 1 then
		return 1 - (time-0.5)*2
	else
		return time *2
	end
end

local function set_override(timeofday)
	permatime.override = timeofday
	if timeofday then
		storage:set_float('permatime', timeofday)
	else
		storage:set_string('permatime', "")
	end

	for _, player in pairs(core.get_connected_players()) do
		player:override_day_night_ratio(time_to_override(timeofday))
	end
end

local function update_time()
	if permatime.override then
		core.set_timeofday(permatime.override)

		core.after(1, update_time)
	end
end

core.register_on_mods_loaded(function()
	permatime.override = storage:get('permatime')

	if permatime.override then
		core.after(1, update_time)
	end
end)

core.register_chatcommand("permatime", {
	params = "<0..23>:<0..59>",
	description = S("Set the permanent time"),
	privs = {settime = true},
	func = function(name, param)
		if param == "" then
			set_override(nil)
			return true, S("Disabled permanent time.")
		end

		local hour, minute = param:match("^(%d+):(%d+)$")
		hour = tonumber(hour); minute = tonumber(minute)
		
		if not hour or not minute then
			return false, S("Invalid input.")
		end

		if hour < 0 or hour > 23 then
			return false, S("Invalid hour (must be between 0 and 23 inclusive).")
		elseif minute < 0 or minute > 59 then
			return false, S("Invalid minute (must be between 0 and 59 inclusive).")
		end

		set_override((hour * 60 + minute) / 1440)
		update_time()

		return true, S("Permanent time set to @1", core.colorize("#ffff00", param))
	end,
})
