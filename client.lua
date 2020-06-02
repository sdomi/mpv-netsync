-- Config
connection_url = "http://localhost:9000/"
pass = "baka"

url = connection_url .. "?pass=" .. pass
time = 0
pause_time=-1

function fetch(url)
	local f = assert(io.popen('curl --silent "' .. url .. '"', 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end

function onPauseChange()
    print("You're the client - you can't pause!")
end

function update()
	r = fetch(url .. '&isPaused')
	if r == "1" or time == pause_time then
		mp.set_property("pause", "yes")
	else
		mp.set_property("pause", "no")
	end
end

function updateTime()
	r = fetch(url .. '&getTime')
	localTime = mp.get_property("playback-time")
	if r+"2" < tonumber(localTime) or r-"2" > tonumber(localTime) then
		if r == time then
			mp.set_property("pause", "yes")
			print("It appears that the master has been disconnected - pausing.")
			pause_time=r
		else
			mp.set_property("playback-time", r)
		end
	end
	time = r
end

function preload()
	updateTime()
	mp.add_periodic_timer(0.5,update)
	mp.add_periodic_timer(1,updateTime)
end

mp.add_key_binding("space", "bool", onPauseChange)
mp.register_event("file-loaded", preload)
