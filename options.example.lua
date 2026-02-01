--[[
# This file is a Lua file.
Lua (programming language): https://en.wikipedia.org/wiki/Lua_(programming_language)

## Comments
Everything after -- (two hyphens/dashes) is ignored (it's a commentary),
so if you want to turn off any option, just put -- in the beginning of the line.
https://www.codecademy.com/resources/docs/lua/comments
--]]

-- Valid values: ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF
LOG_LEVEL = "INFO" ---@type _LogLevel
MIN_LEVEL_OF_FATAL_ERROR = "ERROR" ---@type _LogLevel

---@type BetterRTGMod_Options
local options = {
    -- https://astroneer.fandom.com/wiki/QT-RTG
    QT_RTG = {
        -- Power Production Rate in U/s (game default = 1)
        NetPowerOutput = 2.0
    },
    -- https://astroneer.fandom.com/wiki/RTG
    RTG = {
        -- Power Production Rate in U/s (game default = 4)
        NetPowerOutput = 4.0
    }
}

return options
