-- shutdown_or_sleep.lua
local sleep = false
local shutdown = false
local handler = nil

local function disable()
    if handler then
        mp.unregister_event(handler)
        handler = nil
    end
    if sleep then
        sleep = false
        mp.osd_message("Sleep canceled")
    end
    if shutdown then
        shutdown = false
        mp.osd_message("Shutdown canceled")
    end

end

local function enable()
    if shutdown then
        mp.osd_message("Shutdown after file activated")
    elseif sleep then
        mp.osd_message("Sleep after file activated")
    end
    handler = function(event)
        if event.reason == "eof" then
            if shutdown then
                os.execute("shutdown -h now")
            elseif sleep then
                os.execute("systemctl suspend")
            end
        end
    end
    mp.register_event("end-file", handler)
end


mp.add_key_binding("Ctrl+Shift+S", "toggle-shutdown", function()
    if shutdown then
        disable()
    else
        sleep = false
        shutdown = true
        enable()
    end
end)

mp.add_key_binding("Ctrl+Shift+L", "toggle-sleep", function()
    if sleep then
        disable()
    else
        shutdown = false
        sleep = true
        enable()
    end
end)




