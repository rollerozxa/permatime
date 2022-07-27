# permatime
Set the day of time cycle to a certain time permanently.

Use `/permatime hh:mm` to set a permanent time (e.g. 12:00 for noon), `/permatime` to disable it. Requires the `settime` privilege.

### How's this different to _Xenon's [`ptime`](https://content.minetest.net/packages/_Xenon/ptime/) mod?
- This mod is global, the permanent time will affect all players.
- It will also freeze the day/night cycle, rather than only using `override_day_night_ratio`.
- You can specify arbitrary times, instead of cycling between noon and midnight.
