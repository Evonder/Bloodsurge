--[[
File Author: @file-author@
File Revision: @file-revision@
File Date: @file-date-iso@
]]--
local BloodSurge = LibStub("AceAddon-3.0"):GetAddon("BloodSurge")
local L = LibStub("AceLocale-3.0"):GetLocale("BloodSurge")
local BS = BloodSurge
local coloredTextures = {}

function BS:UpdateColors()
	local c = BS.db.profile.Color
	for k, v in ipairs(coloredTextures) do
		v:SetVertexColor(c.r or 1.00, c.g or 0.49, c.b or 0.04, (c.a or 0.25) * (v.alphaFactor or 1) / BS:GetAlpha())
	end
end

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
					name = L["BSD"].."\n",
					order = 1,
				},
				turnOn = {
					type = 'toggle',
					order = 2,
					width = "full",
					name = L["turnOn"],
					desc = L["turnOnD"],
					get = function() return BS.db.profile.turnOn end,
					set = function() BS.db.profile.turnOn = not BS.db.profile.turnOn end,
				},
				options = {
					type = "group",
					name = "Options",
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
						Msg = {
							type = 'toggle',
							order = 3,
							width = "full",
							name = L["Msg"],
							desc = L["MsgD"],
							get = function() return BS.db.profile.Msg end,
							set = function() BS.db.profile.Msg = not BS.db.profile.Msg end,
						},
						Icon = {
							type = 'toggle',
							order = 4,
							width = "half",
							name = L["Icon"],
							desc = L["IconD"],
							get = function() return BS.db.profile.Icon end,
							set = function() BS.db.profile.Icon = not BS.db.profile.Icon end,
						},
						IconSize = {
							type = 'range',
							order = 4,
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
							set = function(info,v) BS.db.profile.IconSize = v; BloodSurgeIconFrame:SetWidth(v); BloodSurgeIconFrame:SetHeight(v) end,
						},
						Flash = {
							type = 'toggle',
							order = 5,
							width = "half",
							name = L["Flash"],
							desc = L["FlashD"],
							get = function() return BS.db.profile.Flash end,
							set = function() BS.db.profile.Flash = not BS.db.profile.Flash end,
						},
						Color = {
							type = 'color',
							hasAlpha = true,
							order = 6,
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
						optionsHeader2 = {
							type	= "header",
							order	= 6,
							hidden = true,
							name	= "SpellID",
						},
						SID = {
							type = 'input',
--~ 							multiline = true,
							order = 7,
							hidden = true,
							width = "full",
							name = "SpellID",
							desc = "SpellID",
							get = function(info)
								return BS.db.profile.SID[1]
							end,
							set = function(info, value)
								BS.db.profile.SID[1] = value
								print("The " .. BS.db.profile.SID[1] .. " was set to: " .. tostring(value))
							end,
						},
					},
				},
			},
		},
	},
}

