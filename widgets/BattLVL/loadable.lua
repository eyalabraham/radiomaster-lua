--
-- Lua run-time loadable script that converts flight battery voltage level to % capacity.
-- You must have a battery level telemetry value 'A3'.
-- Copy the directory 'BattLVL/' directory and script into the '/WIDGETS' folder on the radio.
--

local zone, options = ...

--local lipoPercent = {
--    { 3.000,  0 }, { 3.093,  1 }, { 3.196,  2 }, { 3.301,  3 }, { 3.401,  4 }, { 3.477,  5 }, { 3.544,  6 }, { 3.601,  7 }, { 3.637,  8 }, { 3.664,  9 },
--    { 3.679, 10 }, { 3.683, 11 }, { 3.689, 12 }, { 3.692, 13 }, { 3.705, 14 }, { 3.710, 15 }, { 3.713, 16 }, { 3.715, 17 }, { 3.720, 18 }, { 3.731, 19 },
--    { 3.735, 20 }, { 3.744, 21 }, { 3.753, 22 }, { 3.756, 23 }, { 3.758, 24 }, { 3.762, 25 }, { 3.767, 26 }, { 3.774, 27 }, { 3.780, 28 }, { 3.783, 29 },
--    { 3.786, 30 }, { 3.789, 31 }, { 3.794, 32 }, { 3.797, 33 }, { 3.800, 34 }, { 3.802, 35 }, { 3.805, 36 }, { 3.808, 37 }, { 3.811, 38 }, { 3.815, 39 },
--    { 3.818, 40 }, { 3.822, 41 }, { 3.825, 42 }, { 3.829, 43 }, { 3.833, 44 }, { 3.836, 45 }, { 3.840, 46 }, { 3.843, 47 }, { 3.847, 48 }, { 3.850, 49 },
--    { 3.854, 50 }, { 3.857, 51 }, { 3.860, 52 }, { 3.863, 53 }, { 3.866, 54 }, { 3.870, 55 }, { 3.874, 56 }, { 3.879, 57 }, { 3.888, 58 }, { 3.893, 59 },
--    { 3.897, 60 }, { 3.902, 61 }, { 3.906, 62 }, { 3.911, 63 }, { 3.918, 64 }, { 3.923, 65 }, { 3.928, 66 }, { 3.939, 67 }, { 3.943, 68 }, { 3.949, 69 },
--    { 3.955, 70 }, { 3.961, 71 }, { 3.968, 72 }, { 3.974, 73 }, { 3.981, 74 }, { 3.987, 75 }, { 3.994, 76 }, { 4.001, 77 }, { 4.007, 78 }, { 4.014, 79 },
--    { 4.021, 80 }, { 4.029, 81 }, { 4.036, 82 }, { 4.044, 83 }, { 4.052, 84 }, { 4.062, 85 }, { 4.074, 86 }, { 4.085, 87 }, { 4.095, 88 }, { 4.105, 89 },
--    { 4.111, 90 }, { 4.116, 91 }, { 4.120, 92 }, { 4.125, 93 }, { 4.129, 94 }, { 4.135, 95 }, { 4.145, 96 }, { 4.176, 97 }, { 4.179, 98 }, { 4.193, 99 },
--    { 4.200, 100 }
--}

local lipoPercent = {
    { 3.000,  0 }, { 3.196,  2 }, { 3.401,  4 }, { 3.544,  6 }, { 3.637,  8 },
    { 3.679, 10 }, { 3.689, 12 }, { 3.705, 14 }, { 3.713, 16 }, { 3.720, 18 },
    { 3.735, 20 }, { 3.753, 22 }, { 3.758, 24 }, { 3.767, 26 }, { 3.780, 28 },
    { 3.786, 30 }, { 3.794, 32 }, { 3.800, 34 }, { 3.805, 36 }, { 3.811, 38 },
    { 3.818, 40 }, { 3.825, 42 }, { 3.833, 44 }, { 3.840, 46 }, { 3.847, 48 },
    { 3.854, 50 }, { 3.860, 52 }, { 3.866, 54 }, { 3.874, 56 }, { 3.888, 58 },
    { 3.897, 60 }, { 3.906, 62 }, { 3.918, 64 }, { 3.928, 66 }, { 3.943, 68 },
    { 3.955, 70 }, { 3.968, 72 }, { 3.981, 74 }, { 3.994, 76 }, { 4.007, 78 },
    { 4.021, 80 }, { 4.036, 82 }, { 4.052, 84 }, { 4.074, 86 }, { 4.095, 88 },
    { 4.111, 90 }, { 4.120, 92 }, { 4.129, 94 }, { 4.145, 96 }, { 4.179, 98 },
    { 4.200, 100 }
}

local BAR_HEIGHT = 12       -- Pixels
local RED_ZONE = 0.14       -- 14% starts red zone
local YELLOW_ZONE = 0.3     -- 30% starts yellow zone

-- The widget table will be returned to the main script.
local widget = { }

-- Function draws the battery gauge rectangles
-- Accepts x,y : top left coordinates
--         w,h : width and height of rectangle
--         color : color of bar segment
local function drawBarSegment(x, y, w, h, color)
    lcd.drawFilledRectangle(x, y, w, h, color)
end

-- Called periodically when widget instance is visible
function widget.refresh(event, touchState)

    local totalA3
    local averageBattCell
    local percentBattDisplay
    local cells_string
    local val_string
    local redZoneEndPixel
    local yellowZoneEndPixel
    local greenZoneEndPixel
    local value_good = false
    
    -- Guard against no data source selected
    if ( options.Source == 0 ) then
        lcd.drawText(1, 1, "N/A", LEFT + WHITE + BLINK)
        return
    end
  
    -- Get battery voltage sensor value and
    -- guard against bad/no telemetry
    totalA3 = getValue(options.Source)
    if ( totalA3 == nil ) then
        averageBattCell = 0.0
        value_good = false
    else
        averageBattCell = totalA3 / options.Cells
        value_good = true
    end
    
    -- Convert average cell voltage to percent capacity
    value_good = false
    if ( averageBattCell < 3.0 ) then
        percentBattDisplay = 0
    elseif ( averageBattCell > lipoPercent[#lipoPercent][1] ) then
        percentBattDisplay = 999
    else
        for i, v in pairs(lipoPercent) do
            if ( v[1] >= averageBattCell ) then
                percentBattDisplay = v[2]
                value_good = true
                break
            end
        end
    end

    --print(totalA3, averageBattCell, percentBattDisplay, value_good)
    
    -- Display widget values
    cells_string = string.format("%1dS", options.Cells)
    if ( value_good ) then
        val_string = string.format("%d%%", percentBattDisplay)
    else
        val_string = "??"
    end
    
    lcd.drawText(1, 4, cells_string, LEFT + WHITE + SMLSIZE)
    lcd.drawText(25, 1, val_string, LEFT + WHITE)
    
    -- Display widget color bars
    if ( value_good ) then
        batteryPercent = percentBattDisplay / 100
        if ( batteryPercent > RED_ZONE ) then
            redZoneEndPixel = math.floor(zone.w * RED_ZONE)
            drawBarSegment(0, (zone.h-BAR_HEIGHT-1), redZoneEndPixel, BAR_HEIGHT, RED)
            if ( batteryPercent > YELLOW_ZONE ) then
                yellowZoneEndPixel = math.floor(zone.w * YELLOW_ZONE)
                greenZoneEndPixel = math.floor(zone.w * batteryPercent) - 1
                drawBarSegment(yellowZoneEndPixel, (zone.h-BAR_HEIGHT-1), (greenZoneEndPixel - yellowZoneEndPixel), BAR_HEIGHT, GREEN)
            else
                yellowZoneEndPixel = math.floor(zone.w * batteryPercent) - 1
            end
            drawBarSegment(redZoneEndPixel, (zone.h-BAR_HEIGHT-1), (yellowZoneEndPixel - redZoneEndPixel), BAR_HEIGHT, YELLOW)
        else
            redZoneEndPixel = math.floor(zone.w * batteryPercent) - 1
            drawBarSegment(0, (zone.h-BAR_HEIGHT-1), redZoneEndPixel, BAR_HEIGHT, RED)
        end
    else
        lcd.drawRectangle(0, (zone.h-BAR_HEIGHT-1), (zone.w-1), BAR_HEIGHT, RED)
    end

    --print(redZoneEndPixel, yellowZoneEndPixel, greenZoneEndPixel)
end

-- Called if options are changed from the Widget Settings menu
function widget.update(opt)
    options = opt
    -- update code here
end

-- Return to the create(...) function in the main script
return widget
