--
-- Sample LUA script to test some ideas.
-- Place the script 'Useless.lua' and the graphics 'Useless.png'
-- in directory '/SCRIPTS/TOOLS' and run from the tools menu.
--

--
-- Some globals
--

-- Bitmap icon
local img = Bitmap.open("/SCRIPTS/TOOLS/Useless.png")

-- Screen location for various items
local system_id_x = 10
local system_id_y = 10

local button_w = 70
local button_h = 30
local button_x = ((LCD_W - button_w) / 2)
local button_y = LCD_H - button_h - 10
local button_color = RED

--
-- Print log text for debug
--
local function log(s)
  --return;
  print("useless: " .. s)
end

--
-- Check if the script is started in a graphical touch screen environement.
--
local function init()
  log("init()")

  -- Check the environement we're running in and
  -- exit if not TX16S
  local ver, radio, maj, minor, rev, osname = getVersion()
  if radio then
    local is_tx16s = string.find(radio, "tx16s")
    if is_tx16s == 1 then
      RUN_OK = true
      SYSTEM_ID = string.format("%s %d.%d.%d", osname, maj, minor, rev)
    else 
      RUN_OK = false
      SYSTEM_ID ="None"
    end
  end

  log(SYSTEM_ID)
end

--
-- Script will exit (not run) if the environement was determined to be incompatible.
-- Otherwise the script clears the screen and starts.
--
local function run(event, touchState)

  if not RUN_OK then
    log("incompatible system.")
    return 1
  end

  -- Clear the screen and position text and other controls
  lcd.clear(GREY)

  local width, height = Bitmap.getSize(img)
  lcd.drawBitmap(img, ((LCD_W - width) / 2), ((LCD_H - height) / 2))

  lcd.drawText(system_id_x, system_id_y, SYSTEM_ID, MIDSIZE + WHITE)

  lcd.drawFilledRectangle(button_x, button_y, button_w, button_h, button_color)
  lcd.drawText(button_x+10, button_y+7, "Click me", SMLSIZE + WHITE)

  -- Respond to a touch event
  if event == EVT_TOUCH_TAP then
    -- log(touchState.x)
    -- log(touchState.y)

    if touchState.x >= button_x and touchState.x <= (button_x + button_w) and
       touchState.y >= button_y and touchState.y <= (button_y + button_h) then

      if button_color == RED then
         button_color = DARKGREEN
      else
        button_color = RED
      end

      playTone(200, 200, 10, 0, 10)
    else
      playTone(50, 100, 10)
    end
  end

  -- run is called periodically only when screen is visible
  -- A non-zero return value will halt the script
  return 0
end

return { run=run, init=init }
