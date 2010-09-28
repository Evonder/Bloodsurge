--[[
File Author: @file-author@
File Revision: @file-revision@
File Date: @file-date-iso@
]]--
local BloodSurge = LibStub("AceAddon-3.0"):GetAddon("BloodSurge")
local L = LibStub("AceLocale-3.0"):GetLocale("BloodSurge")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local BS = BloodSurge

--[[ Locals ]]--
local find = string.find
local ipairs = ipairs
local pairs = pairs
local insert = table.insert
local sort = table.sort

--[[ Options Table ]]--
options = {
	type="group",
	name = BS.name,
	handler = BS,
	childGroups = "tab",
	args = {
		generalGroup = {
			type = "group",
			name = BS.name,
			args = {
				mainHeader = {
					type = "description",
					name = "  " .. L["BSD"] .. "\n  " .. BS.version .. "\n",
					order = 1,
					image = "Interface\\Icons\\Ability_Warrior_Bloodsurge",
					imageWidth = 32, imageHeight = 32,
				},
				turnOn = {
					type = 'toggle',
					order = 2,
					width = "full",
					name = L["turnOn"],
					desc = L["turnOnD"],
					get = function() return BS.db.profile.turnOn end,
					set = function()
						if (BS.db.profile.turnOn == false) then
							print("|cFF33FF99BloodSurge|r: " .. BS.version .. " |cff00ff00Enabled|r")
							BS.db.profile.turnOn = not BS.db.profile.turnOn
						else
							print("|cFF33FF99BloodSurge|r: " .. BS.version .. " |cffff8080Disabled|r")
							BS.db.profile.turnOn = not BS.db.profile.turnOn
						end
					end,
				},
				options = {
					type = "group",
					name = "Options",
					childGroups = "tab",
					disabled = function()
						return not BS.db.profile.turnOn
					end,
					args = {
						main = {
							type = "group",
							name = "Main",
							order = 1,
							disabled = function()
								return not BS.db.profile.turnOn
							end,
							args = {
								optionsHeader = {
									type	= "header",
									order	= 1,
									name	= L["Options"],
								},
								Sound = {
									type = 'toggle',
									order = 2,
									width = "full",
									name = L["Sound"],
									desc = L["SoundD"],
									get = function() return BS.db.profile.Sound end,
									set = function() BS.db.profile.Sound = not BS.db.profile.Sound end,
								},
								LSMSounds = {
									type = 'select',
									order = 3,
									width = "double",
									dialogControl = 'LSM30_Sound',
									name = L["Sound"],
									desc = L["SoundD"],
									values = AceGUIWidgetLSMlists.sound,
									get = function()
										return BS.db.profile.DefSoundName
									end,
									set = function(self,key)
										BS.db.profile.DefSoundName = key
										 BS:RefreshLocals()
									end,
								},
								Msg = {
									type = 'toggle',
									order = 4,
									width = "full",
									name = L["Msg"],
									desc = L["MsgD"],
									get = function() return BS.db.profile.Msg end,
									set = function() BS.db.profile.Msg = not BS.db.profile.Msg end,
								},
								Icon = {
									type = 'toggle',
									order = 5,
									width = "full",
									name = L["Icon"],
									desc = L["IconD"],
									get = function() return BS.db.profile.Icon end,
									set = function() BS.db.profile.Icon = not BS.db.profile.Icon end,
								},
								Flash = {
									type = 'toggle',
									order = 6,
									width = "half",
									name = L["Flash"],
									desc = L["FlashD"],
									get = function() return BS.db.profile.Flash end,
									set = function() BS.db.profile.Flash = not BS.db.profile.Flash end,
								},
								Color = {
									type = 'color',
									hasAlpha = true,
									order = 7,
									disabled = function()
										return not BS.db.profile.Flash
									end,
									width = "half",
									name = L["Color"],
									desc = L["ColorD"],
									get = function()
										local c = BS.db.profile.Color
										return c.r or 1.00, c.g or 0.49, c.b or 0.04, c.a or 0.25
									end,
									set = function(info, r, g, b, a)
										local c = BS.db.profile.Color
										c.r, c.g, c.b, c.a = r, g, b, a
										BS:UpdateColors()
									end,
								},
								Blank0 = {
									type = 'description',
									order = 8,
									width = "full",
									name = "",
								},
								IconSize = {
									type = 'range',
									order = 9,
									disabled = function()
										return not BS.db.profile.Icon
									end,
									min = 25,
									max = 200,
									step = 1.00,
									width = "double",
									name = L["IconSize"],
									desc = L["IconSizeD"],
									get = function(info) return BS.db.profile.IconSize or 75 end,
									set = function(info,v) BS.db.profile.IconSize = v; BloodSurgeIconFrame:SetWidth(v); BloodSurgeIconFrame:SetHeight(v); BS:RefreshLocals(); end,
								},
								Blank1 = {
									type = 'description',
									order = 10,
									width = "full",
									name = "",
								},
								IconX = {
									type = 'range',
									order = 11,
									disabled = function()
										return not BS.db.profile.Icon
									end,
									min = -500,
									max = 500,
									step = 10,
									name = L["IconX"],
									desc = L["IconXD"],
									get = function(info) return BS.db.profile.IconLoc.X or 0 end,
									set = function(info,v) BS.db.profile.IconLoc.X = v; BS:RefreshLocals(); end,
								},
								IconY = {
									type = 'range',
									order = 13,
									disabled = function()
										return not BS.db.profile.Icon
									end,
									min = -350,
									max = 350,
									step = 5,
									name = L["IconY"],
									desc = L["IconYD"],
									get = function(info) return BS.db.profile.IconLoc.Y or 50 end,
									set = function(info,v) BS.db.profile.IconLoc.Y = v; BS:RefreshLocals(); end,
								},
								Blank3 = {
									type = 'description',
									order = 14,
									width = "full",
									name = "",
								},
								IconDuration = {
									type = 'range',
									order = 15,
									disabled = function()
										return not BS.db.profile.Icon
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["IconDur"],
									desc = L["IconDurD"],
									get = function(info) return BS.db.profile.IconDura or 2.6 end,
									set = function(info,v) BS.db.profile.IconDura = v; BS:RefreshLocals(); end,
								},
								IconModulation = {
									type = 'range',
									order = 16,
									disabled = function()
										return not BS.db.profile.Icon
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["IconMod"],
									desc = L["IconModD"],
									get = function(info) return BS.db.profile.IconMod or 1.3 end,
									set = function(info,v) BS.db.profile.IconMod = v; BS:RefreshLocals(); end,
								},
								Blank4 = {
									type = 'description',
									order = 17,
									width = "full",
									name = "",
								},
								FlashDuration = {
									type = 'range',
									order = 18,
									disabled = function()
										return not BS.db.profile.Flash
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["FlashDur"],
									desc = L["FlashDurD"],
									get = function(info) return BS.db.profile.FlashDura or 2.6 end,
									set = function(info,v) BS.db.profile.FlashDura = v; BS:RefreshLocals(); end,
								},
								FlashModulation = {
									type = 'range',
									order = 19,
									disabled = function()
										return not BS.db.profile.Flash
									end,
									min = 0.5,
									max = 3.0,
									step = 0.1,
									name = L["FlashMod"],
									desc = L["FlashModD"],
									get = function(info) return BS.db.profile.FlashMod or 1.3 end,
									set = function(info,v) BS.db.profile.FlashMod = v; BS:RefreshLocals(); end,
								},
								Blank5 = {
									type = 'description',
									order = 20,
									width = "full",
									name = "",
								},
								IconTest = {
									type = 'execute',
									order = 21,
									disabled = function()
										return not BS.db.profile.Icon
									end,
									width = "double",
									name = L["IconTest"],
									desc = L["IconTestD"],
									func = function() 
										local spellTexture = "Interface\\Icons\\Ability_Warrior_Bloodsurge"
										if (BS.db.profile.Icon) then
											BS:Icon(spellTexture)
										end
										if (BS.db.profile.Sound) then
											PlaySoundFile(BS.SoundFile)
										end
										if (BS.db.profile.Msg) then
											UIErrorsFrame:AddMessage("Slam!",1,0,0,nil,3)
										end
										if (BS.db.profile.Flash) then
											BS:Flash()
										end
									end,
								},
								Blank6 = {
									type = 'description',
									order = 22,
									width = "full",
									name = "",
								},
								optionsHeader3 = {
									type	= "header",
									order	= 23,
									name	= L["Custom Procs"],
								},
								SID = {
									type = 'input',
									multiline = 8,
									order = 24,
									width = "double",
									name = L["spellID or spellName"],
									desc = L["Enter spellID or spellName to watch for."],
									usage= L["You can enter either spellID or spellName to search for."],
									get = function(info)
										local a = {}
										local ret = ""
										if (BS.db.profile.SID == nil) then
											BS.db.profile.SID = L.SID
										end
										for _,v in pairs(BS.db.profile.SID) do
											insert(a, v)
										end
										sort(a)
										for _,v in ipairs(a) do
											if ret == "" then
												ret = v
											else
												ret = ret .. "\n" .. v
											end
										end
										return ret
									end,
									set = function(info, value)
										BS:WipeTable(BS.db.profile.SID)
										local tbl = { strsplit("\n", value) }
										for k, v in pairs(tbl) do
											key = "SID"
											BS.db.profile.SID[key..k] = v
										end
									end,
								},
								Blank8 = {
									type = 'description',
									order = 25,
									width = "full",
									name = "",
								},
								Reset_SID = {
									type = 'execute',
									order = 26,
									width = "half",
									name = "Reset",
									desc = "Reset",
									func = function() BS.db.profile.SID = BS:CopyTable(L.SID) end,
								},
							},
						},
						advanced = {
							type = "group",
							name = "Advanced",
							order = 2,
							disabled = function()
								return not BS.db.profile.turnOn
							end,
							args = {
								optionsHeader2 = {
									type	= "header",
									order	= 1,
									name	= L["Alternative Combat Log Filtering"],
								},
								AltCL = {
									type = 'toggle',
									order = 2,
									width = "full",
									name = L["AltCL"],
									desc = L["AltCLD"],
									get = function() return BS.db.profile.AltCL end,
									set = function() BS.db.profile.AltCL = not BS.db.profile.AltCL; BS:RefreshRegisters(); end,
								},
								Debug = {
									type = 'toggle',
									order = 3,
									width = "full",
									name = L["Enable Debugging"],
									desc = L["Enable Debugging"],
									get = function() return BS.db.profile.debug end,
									set = function() BS.db.profile.debug = not BS.db.profile.debug; end,
								},
								Blank9 = {
									type = 'description',
									order = 4,
									width = "full",
									name = "",
								},
								optionsHeader4 = {
									type	= "header",
									order	= 5,
									name	= L["Custom Procs"],
								},
								SoundAllProc = {
									type = 'toggle',
									order = 6,
									width = "full",
									name = L["Sound on Custom Procs"],
									desc = L["Play selected sound for all Custom Procs."],
									get = function() return BS.db.profile.SoundAllProc end,
									set = function() BS.db.profile.SoundAllProc = not BS.db.profile.SoundAllProc end,
								},
							},
						},
					},
				},
			},
		},
	},
}
