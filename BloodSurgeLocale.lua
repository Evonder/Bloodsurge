--[[
File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@
]]--
local debug = false
--@debug@
debug = true
--@end-debug@

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "enUS", true)
if L then
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "enUS" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "deDE")
if L then
--@localization(locale="deDE", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "deDE" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "zhCN")
if L then
--@localization(locale="zhCN", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "zhCN" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "zhTW")
if L then
--@localization(locale="zhTW", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "zhTW" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "koKR")
if L then
--@localization(locale="koKR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "koKR" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "frFR")
if L then
--@localization(locale="frFR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "frFR" then return end
end

local L =  LibStub("AceLocale-3.0"):NewLocale("BloodSurge", "ruRU")
if L then
--@localization(locale="ruRU", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@
if GetLocale() == "ruRU" then return end
end
