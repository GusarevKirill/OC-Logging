-- Logging github.com/GusarevKirill/OC-Logging
-- Logging library for OpenComputers by Kirgus
local fs = require("filesystem")
--------------------------------
local logging = {}
local LOG_LEVEL = {
  DEBUG = "DEBUG",
  INFO = "INFO",
  WARNING = "WARNING",
  WARN = "WARNING",
  ERROR = "ERROR",
  CRITICAL = "CRITICAL",
  FATAL = "CRITICAL",
}
--------------------------------
local function now(timezone)
  if not timezone then
    timezone = 0
  end
  local f = io.open("/tmp/time", "w")
  f:close()
  local timestamp = fs.lastModified("/tmp/time") / 1000 + 3600 * timezone
  return os.date("%d.%m.%Y %H:%M:%S", timestamp)
end

local function log(self, message, level)
  if type(self) ~= "table" then
    error("Use `:`, not `.`")
  end
  message = tostring(message)
  local f = io.open(self._path, "a")
  --logText = "[" .. now() .. "] " .. level .. ": " .. message .. "\n"
  pattern = "[%s] %s: %s\n"
  logText = pattern:format(
    now(),
    level,
    message
  )
  f:write(logText)
  f:close()
end

local function debug(self, message)
  log(self, message, LOG_LEVEL.DEBUG)
end

local function info(self, message)
  log(self, message, LOG_LEVEL.INFO)
end

local function warning(self, message)
  log(self, message, LOG_LEVEL.WARNING)
end

local function error_(self, message)
  log(self, message, LOG_LEVEL.ERROR)
end

local function critical(self, message)
  log(self, message, LOG_LEVEL.CRITICAL)
end

function logging.getLogger(path)
  local logger = {
    _path = path,
    debug = debug,
    info = info,
    warning = warning,
    warn = warning,
    error = error_,
    critical = critical,
    fatal = critical,
  }
  return logger
end

return logging