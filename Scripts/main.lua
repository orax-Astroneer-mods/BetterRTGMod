local logging = require("lib.lua-mods-libs.logging")
local C = require("constants") ---@type ModConstants

local format = string.format
local currentModDirectory = debug.getinfo(1, "S").source:gsub("\\", "/"):match("@?(.+)/[Ss]cripts/")

---@param filename string
---@return boolean
local function isFileExists(filename)
    local file = io.open(filename, "r")
    if file ~= nil then
        io.close(file)
        return true
    else
        return false
    end
end

---@return BetterRTGMod_Options
local function loadOptions()
    local file = format([[%s\options.lua]], currentModDirectory)

    if not isFileExists(file) then
        local cmd = format([[copy "%s\options.example.lua" "%s\options.lua"]],
            currentModDirectory,
            currentModDirectory)

        print("Copy example options to options.lua. Execute command: " .. cmd .. "\n")

        os.execute(cmd)
    end

    return dofile(file)
end

--------------------------------------------------------------------------------

-- Default logging levels. They can be overwritten in the options file.
LOG_LEVEL = "INFO" ---@type _LogLevel
MIN_LEVEL_OF_FATAL_ERROR = "ERROR" ---@type _LogLevel

local options = loadOptions()
local log = logging.new(LOG_LEVEL, MIN_LEVEL_OF_FATAL_ERROR)

--------------------------------------------------------------------------------

---@param rtg ARTG_T1_BP_C|ARTG_Base_C
local function onNewRTG(rtg, netPowerOutput)
    local counter = 0
    local loopHandle

    loopHandle = LoopInGameThreadWithDelay(C.LOOP_DELAY_MS, function()
        local power = rtg.Power

        if power and power:IsValid() and type(rtg.Power.NetPowerOutput) == "number" then
            log.debug("Set new power value: %s => %s. counter=%s", power.NetPowerOutput, netPowerOutput, counter)
            power.NetPowerOutput = netPowerOutput
            CancelDelayedAction(loopHandle)

            return
        end

        counter = counter + 1
        if counter >= C.MAX_ATTEMPTS then
            log.warn("Unable to get the `Power.NetPowerOutput` property.")
            CancelDelayedAction(loopHandle)
        end
    end)
end

if options.QT_RTG.NetPowerOutput ~= nil and options.QT_RTG.NetPowerOutput ~= C.DEFAULT_QT_RTG_POWER then
    ---@param rtg ARTG_T1_BP_C
    ---@diagnostic disable-next-line: redundant-parameter
    NotifyOnNewObject("/Game/Components_Small/RTG_T1_BP.RTG_T1_BP_C", function(rtg)
        onNewRTG(rtg, options.QT_RTG.NetPowerOutput)
    end)
end

if options.RTG.NetPowerOutput ~= nil and options.RTG.NetPowerOutput ~= C.DEFAULT_RTG_POWER then
    ---@param rtg ARTG_Base_C
    ---@diagnostic disable-next-line: redundant-parameter
    NotifyOnNewObject("/Game/Components_Medium/RTG_Base.RTG_Base_C", function(rtg)
        onNewRTG(rtg, options.RTG.NetPowerOutput)
    end)
end
