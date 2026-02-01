local C = {
    DEFAULT_QT_RTG_POWER = 1.0,
    DEFAULT_RTG_POWER = 4.0,
    MAX_ATTEMPTS = 5,
    LOOP_DELAY_MS = 500
}

return setmetatable(C, {
    __newindex = function()
        error("Attempt to modify constant.")
    end
})
