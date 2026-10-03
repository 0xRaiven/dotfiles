HOME = os.getenv("HOME") or ""

function is_file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function bind(key, dispatcher, opts)
    pcall(hl.unbind, key)
    if opts then
        hl.bind(key, dispatcher, opts)
    else
        hl.bind(key, dispatcher)
    end
end
