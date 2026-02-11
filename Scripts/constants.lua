local C = {
    DEFAULT_QT_RTG_POWER = 1.0,
    DEFAULT_RTG_POWER = 4.0,
    DELAY_MS = 2000
}

return setmetatable(C, {
    __newindex = function()
        error("Attempt to modify constant.")
    end
})
