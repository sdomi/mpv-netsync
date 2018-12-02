-- Config
connection_url = "http://localhost:9000/"
pass = "baka"

require "luarocks.loader"
http = require('httpclient').new()
url = connection_url .. "?password=" .. pass

function onPauseChange()
    print("You're the client - you can't pause!")
end

function update()
	r = http:get(url .. '&isPaused')
	if r.body == "1" then
		mp.set_property("pause", "yes")
	else
		mp.set_property("pause", "no")
	end
end

function updateTime()
	r = http:get(url .. '&getTime')
	localTime = mp.get_property("playback-time")
	if r.body+"2" < tonumber(localTime) or r.body-"2" > tonumber(localTime) then
		mp.set_property("playback-time", r.body)
	end
end

function preload()
	updateTime()
	mp.add_periodic_timer(0.5,update)
	mp.add_periodic_timer(1,updateTime)
end

mp.add_key_binding("space", "bool", onPauseChange)
mp.register_event("file-loaded", preload)
