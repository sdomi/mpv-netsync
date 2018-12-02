-- Config
connection_url = "http://localhost:9000"
pass = "baka"

require "luarocks.loader"
http = require('httpclient').new()

pause = false
url = connection_url .. "?pass=" .. pass

function onPauseChange()
    if pause == true then
        mp.set_property("pause", "no")
        r = http:get(url .. '&play')
        pause = false
    else
        mp.set_property("pause", "yes")
        r = http:get(url .. '&pause')
        pause = true
    end
end

function update()
    realTime = mp.get_property("playback-time")
    r = http:get(url .. '&setTime=' .. realTime)
end

function reset(event)
    if event['reason'] == 'eof' then
        r = http:get(url .. '&reset')
    end
end

function preload()
    r = http:get(url .. '&getTime')
    mp.set_property("playback-time", r.body)

    r = http:get(url .. '&play')
    mp.set_property("pause", "no")
    mp.add_periodic_timer(0.5,update)
end

mp.add_key_binding("space", "bool", onPauseChange)
mp.register_event("file-loaded", preload)
mp.register_event("end-file", reset)
