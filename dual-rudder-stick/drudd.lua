--
-- LUA custom mixer script that allows both right and left sticks to
-- control the rudder in a 3-channel RC plane.
-- 1. Place the script 'drudd.lua' in the '/SCRIPTS/MIXES' directory.
-- 2. Add the custom mix in the mixer radio page
--

local input =
    {
        { "right_stick", SOURCE},
        { "left_stick", SOURCE},
    }

local output = { "lua_rudder_mix" }

local DEAD_BAND = 5
local lua_rudder_mix = 0

--
-- Called once when the script is loaded
-- Initialize variables
--
local function init()
-- Nothing to initialize
end

--
-- Called periodically about 30 times per second
-- Calculate stick mix based on channel 1 and 4 inputs
-- Track state of right CH1 and left CH4 sticks
-- and assign output based on location/direction of deflection
--
local function run(right_stick, left_stick)

    --
    -- Both stick are to the right of center, and larger then
    -- dead band range. Output is equal to the largest reading.
    --
    if ((right_stick > DEAD_BAND) and (left_stick > DEAD_BAND)) then
        lua_rudder_mix = math.max(right_stick,left_stick)
    --
    -- Both stick are to the left of center, and smaller then
    -- dead band range. Output is equal to the smallest reading.
    --
    elseif ((right_stick < -DEAD_BAND) and (left_stick < -DEAD_BAND)) then
            lua_rudder_mix = math.min(right_stick,left_stick)
    --
    -- When moving only right stick.
    -- Output is equal to the right stick deflection.
    --
    elseif ((math.abs(right_stick) > DEAD_BAND) and (math.abs(left_stick) <= DEAD_BAND)) then
            lua_rudder_mix = right_stick
    --
    -- When moving only left stick.
    -- Output is equal to the left stick deflection.
    --
    elseif ((math.abs(left_stick) > DEAD_BAND) and (math.abs(right_stick) <= DEAD_BAND)) then
            lua_rudder_mix = left_stick
    --
    -- When stick are outside of dead band but in opposite deflection.
    -- Output is equal to the left stick deflection.
    --
    else
        lua_rudder_mix = 0
    
    end

    return lua_rudder_mix
end

return { input=input, output=output, run=run, init=init }

