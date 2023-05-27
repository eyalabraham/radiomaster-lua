--
-- Lua script that converts flight battery voltage level to % capacity.
-- You must have a battery level telemetry value 'A3'.
-- Copy the directory 'BattLVL/' directory and script into the '/WIDGETS' folder on the radio.
--

local name = "BattLVL"

-- Create a table with default options
-- Options can be changed by the user from the Widget Settings menu
-- Source should be selected by the user to be A3 battery
local options = {
    { "Source", SOURCE, 0 },
    { "Cells",  VALUE,  3, 1, 4 }
}

-- Runs one time when the widget instance is registered
local function create(zone, options)
    return loadScript("/WIDGETS/" .. name .. "/loadable.lua")(zone, options)
end

-- Runs if options are changed from the Widget Settings menu
local function update(widget, options)
    widget.update(options)
end

-- Runs periodically only when widget instance is not visible
local function background(widget)
end

-- Runs periodically only when widget instance is visible
local function refresh(widget, event, touchState)
    widget.refresh(event, touchState)
end

return {
  name = name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}
