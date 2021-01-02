



function combine (...)
    local combined = ""
    for k, v in ipairs(arg) do
        if tonumber(k) > 1 then
            combined = combined .. "/"
        end
        combined = combined .. v
    end
    return combined
end
