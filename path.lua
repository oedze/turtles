



function combine (...)
    local combined = ""
    for k, v in pairs(arg) do
        if k > 1 then
            combined = combined .. "/"
        end
        combined = combined .. v
    end
    return combined
end
