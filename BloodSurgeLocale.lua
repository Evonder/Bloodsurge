--[[
File Author: @file-author@
File Revision: @file-revision@
File Date: @file-date-iso@
]]--
local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "enUS", true, debug)
if L then
L["turnOn"] = "Turn On"
L["turnOnD"] = "Enable/Disable AddOn"
L["Sound"] = "Sound"
L["SoundD"] = "Play sound on Bloodsurge gain."
L["Flash"] = "Flash"
L["FlashD"] = "Flash Screen on Bloodsurge gain."
L["Icon"] = "Icon"
L["IconD"] = "Flash Icon on Bloodsurge gain."
L["IconSize"] = "Icon Size"
L["IconSizeD"] = "Set Icon Size to be Flashed."
L["Msg"] = "Message"
L["MsgD"] = "Print message in UI Error Frame on Bloodsurge gain."
L["Color"] = "Color"
L["ColorD"] = "Set flash color."
L["BSD"] = "Instant SLAM! notification"
L["Options"] = "Notification Options"

if GetLocale() == "enUS" then return end
end
