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
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
if GetLocale() == "enUS" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "deDE", true, debug)
if L then
--@localization(locale="deDE", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
if GetLocale() == "deDE" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "zhCN", true, debug)
if L then
--@localization(locale="zhCN", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
if GetLocale() == "zhCN" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "zhTW", true, debug)
if L then
--@localization(locale="zhTW", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
if GetLocale() == "zhTW" then return end
end
