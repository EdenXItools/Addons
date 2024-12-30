--[[
* chocotime - Displays Vana'diel time, date, and moon phase on screen.
* Author: EdenXI Lover
* Version: 1.0
* Dependencies: Requires the vanatime.lua library and moon_phases.lua.
* In game commands: '/chocotime blink' and '/chocotime visible'
]]

_addon.author   = 'EdenXI Lover'
_addon.name     = 'chocotime'
_addon.version  = '1.1'

require 'common'
require 'vanatime'
local moon_phases = require('moon_phases')

local font_object = nil -- Font object for displaying Vana'diel time and moon phase info
local update_interval = 1 -- Time interval for updating the display in seconds
local last_update_time = 0 -- Tracks last update to ensure updates occur only once per interval
local is_visible = true -- Tracks visibility state of the font object

----------------------------------------------------------------------------------------------------
-- initialize_font
-- Creates and initializes the font object for displaying Vana'diel time, date, and moon phase info.
----------------------------------------------------------------------------------------------------
local function initialize_font()
    font_object = AshitaCore:GetFontManager():Create('__chocotime')
    font_object:SetFontFamily('Arial')
    font_object:SetFontHeight(14)
    font_object:SetBold(true)
    font_object:SetColor(math.d3dcolor(255, 255, 255, 255)) -- White color
    font_object:SetPositionX(100) -- X position on the screen
    font_object:SetPositionY(100) -- Y position on the screen
    font_object:SetText('')
    font_object:SetVisibility(is_visible)
end

----------------------------------------------------------------------------------------------------
-- toggle_visibility
-- Toggles the visibility of the font object and displays a message indicating the current state.
----------------------------------------------------------------------------------------------------
local function toggle_visibility()
    is_visible = not is_visible
    font_object:SetVisibility(is_visible)
    print(string.format('Chocotime is now %s.', is_visible and 'visible' or 'hidden'))
end

----------------------------------------------------------------------------------------------------
-- blink_display
-- Temporarily displays the font object for 10 seconds, then hides it again.
----------------------------------------------------------------------------------------------------
local function blink_display()
    if is_visible then
        print('Chocotime is already visible. You can hide chocotime by typeing "/chocotime visible".  Blink works when chocotime is invisible.')
        return
    end

    font_object:SetVisibility(true)
    --print('Chocotime is now visible temporarily. Will hide after 10 seconds.')

    ashita.timer.once(10, function()
        font_object:SetVisibility(false)
        --print('Chocotime is now hidden again.')
    end)
end

----------------------------------------------------------------------------------------------------
-- get_vd_day_difference
-- Calculates the difference in Vana'diel days from a base date.
----------------------------------------------------------------------------------------------------
local function get_vd_day_difference(end_date)
    local start_date = { year = 1468, month = 7, day = 7 }
    local start_total_days = ((start_date.year - 1) * 360) + ((start_date.month - 1) * 30) + start_date.day
    local end_parts = { year = tonumber(end_date:sub(1, 4)), month = tonumber(end_date:sub(6, 7)), day = tonumber(end_date:sub(9, 10)) }
    local end_total_days = ((end_parts.year - 1) * 360) + ((end_parts.month - 1) * 30) + end_parts.day
    return end_total_days - start_total_days
end

----------------------------------------------------------------------------------------------------
-- get_seconds_elapsed
-- Converts a time string (hh:mm) to the total number of seconds.
----------------------------------------------------------------------------------------------------
local function get_seconds_elapsed(time_input)
    local hours, minutes = time_input:match("(%d+):(%d+)")
    return (tonumber(hours) * 3600) + (tonumber(minutes) * 60)
end

----------------------------------------------------------------------------------------------------
-- convert_seconds_to_time
-- Converts seconds into a formatted time string (hh:mm:ss).
----------------------------------------------------------------------------------------------------
local function convert_seconds_to_time(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remaining_seconds = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, remaining_seconds)
end

----------------------------------------------------------------------------------------------------
-- get_moon_phase_info
-- Calculates the current moon phase and relevant timings based on the Vana'diel date and time.
----------------------------------------------------------------------------------------------------
local function get_moon_phase_info(vd_date, vd_time)
    local vd_day_diff = get_vd_day_difference(vd_date)
    local cycle_day = (vd_day_diff % 84) + 1
    local vd_time_elapsed = get_seconds_elapsed(vd_time)

    -- Find the current moon phase information
    local current_phase = nil
    for _, phase in ipairs(moon_phases) do
        if phase.DayOfCycle == cycle_day then
            current_phase = phase
            break
        end
    end

    if not current_phase then
        return nil, "Cycle day not found in moon phase data."
    end

    local vd_seconds_until_next_phase = current_phase.VD_SecondsUntilNextPhase
    local vd_seconds_until_next_major_moon = current_phase.VD_SecondsUntilNextMajorMoon

    local earth_seconds_until_next_phase = (vd_seconds_until_next_phase - vd_time_elapsed) / 25
    local earth_seconds_until_next_major_moon = (vd_seconds_until_next_major_moon - vd_time_elapsed) / 25

    return {
        CurrentMoonPhase = current_phase.Phase,
        NextPhase = current_phase.NextPhaseName,
        TimeUntilNextPhase = convert_seconds_to_time(earth_seconds_until_next_phase),
        NextMajorMoon = current_phase.NextMajorMoon,
        TimeUntilNextMajorMoon = convert_seconds_to_time(earth_seconds_until_next_major_moon)
    }
end

----------------------------------------------------------------------------------------------------
-- update_vanadiel_time
-- Updates the Vana'diel date, time, and moon phase information displayed on the screen.
----------------------------------------------------------------------------------------------------
local function update_vanadiel_time()
    -- Get the current Vana'diel date and time
    local current_time = ashita.ffxi.vanatime.get_current_time()
    local current_date = ashita.ffxi.vanatime.get_current_date()

    -- Format the date and time as yyyy-mm-dd and hh:mm
    local vd_date = string.format("%04d-%02d-%02d", current_date.year, current_date.month, current_date.day)
    local vd_time = string.format("%02d:%02d", current_time.h, current_time.m)

    -- Get moon phase information
    local moon_phase_info, error_message = get_moon_phase_info(vd_date, vd_time)

    if not moon_phase_info then
        font_object:SetText("Error: " .. error_message)
        return
    end

    -- Update the font text
    local display_text = string.format(
        "Vana'diel Time: %s\nCurrent Moon Phase: %s\nNext Phase: %s\nTime Until Next Phase: %s\nNext Major Moon: %s\nTime Until Next Major Moon: %s",
        vd_date .. " " .. vd_time,
        moon_phase_info.CurrentMoonPhase,
        moon_phase_info.NextPhase,
        moon_phase_info.TimeUntilNextPhase,
        moon_phase_info.NextMajorMoon,
        moon_phase_info.TimeUntilNextMajorMoon
    )

    font_object:SetText(display_text)
end

----------------------------------------------------------------------------------------------------
-- render_event
-- Called every frame to update the Vana'diel time and moon phase info at the specified interval.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    local current_time = os.time()

    -- Update only if the interval has passed
    if current_time - last_update_time >= update_interval then
        update_vanadiel_time()
        last_update_time = current_time
    end
end)

----------------------------------------------------------------------------------------------------
-- command_event
-- Handles commands sent to the addon.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    local args = command:args()
    if not args or args[1]:lower() ~= '/chocotime' then
        return false
    end

    if #args < 2 then
        print('Invalid command. Usage: /chocotime [visible|blink]')
        return true
    end

    local subcommand = args[2]:lower()

    if subcommand == 'visible' then
        toggle_visibility()
    elseif subcommand == 'blink' then
        blink_display()
    else
        print('Unknown subcommand. Usage: /chocotime [visible|blink]')
    end

    return true
end)

----------------------------------------------------------------------------------------------------
-- unload_event
-- Cleans up the font object when the addon is unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    if font_object then
        AshitaCore:GetFontManager():Delete('__chocotime')
    end
end)

-- Initialize the font object when the addon is loaded
initialize_font()
