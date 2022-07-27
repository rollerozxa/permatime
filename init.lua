
permatime = {
	override = nil
}

local storage = minetest.get_mod_storage()

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

	for _, player in pairs(minetest.get_connected_players()) do
		player:override_day_night_ratio(time_to_override(timeofday))
	end
end

local function update_time()
	if permatime.override then
		minetest.set_timeofday(permatime.override)

		minetest.after(1, update_time)
	end
end

minetest.register_on_mods_loaded(function()
	permatime.override = storage:get('permatime')

	if permatime.override then
		minetest.after(1, update_time)
	end
end)

minetest.register_chatcommand("permatime", {
	params = "<0..23>:<0..59>",
	description = "Set the permanent time",
	privs = {},
	func = function(name, param)
		if not core.get_player_privs(name).settime then
			return false, "You don't have permission to run this command (missing privilege: settime)."
		end

		if param == "" then
			set_override(nil)
			return true, "Disabled permanent time"
		end

		local hour, minute = param:match("^(%d+):(%d+)$")
		hour = tonumber(hour); minute = tonumber(minute)

		if hour < 0 or hour > 23 then
			return false, "Invalid hour (must be between 0 and 23 inclusive)."
		elseif minute < 0 or minute > 59 then
			return false, "Invalid minute (must be between 0 and 59 inclusive)."
		end

		set_override((hour * 60 + minute) / 1440)
		update_time()

		return true, "Permanent time set to "..minetest.colorize("#ffff00", param)
	end,
})
