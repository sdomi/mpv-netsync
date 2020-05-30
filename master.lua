-- Config
connection_url = "http://localhost:9000/"
pass = "baka"

pause = false
url = connection_url .. "?pass=" .. pass

function fetch(url)
	local f = assert(io.popen('curl --silent "' .. url .. '"', 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end

function onPauseChange()
    if pause == true then
        mp.set_property("pause", "no")
        r = fetch(url .. '&play')
        pause = false
    else
        mp.set_property("pause", "yes")
        r = fetch(url .. '&pause')
        pause = true
    end
end

function update()
    realTime = mp.get_property("playback-time")
    r = fetch(url .. '&setTime=' .. realTime)
end

function reset(event)
    if event['reason'] == 'eof' then
        r = fetch(url .. '&reset"')
    end
end

function preload()
    r = fetch(url .. '&getTime')
    mp.set_property("playback-time", r)

    r = fetch(url .. '&play')
    mp.set_property("pause", "no")
    mp.add_periodic_timer(0.5,update)
end

mp.add_key_binding("space", "bool", onPauseChange)
mp.register_event("file-loaded", preload)
mp.register_event("end-file", reset)
