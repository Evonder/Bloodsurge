--[[
BloodSurge
		Instant SLAM! Notification

File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@

* Copyright (c) 2008, @file-author@
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY @file-author@ ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL @file-author@ BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

BloodSurge = LibStub("AceAddon-3.0"):NewAddon("BloodSurge", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("BloodSurge")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local MSQ = LibStub("Masque", true)
local BS = BloodSurge

--[[ Locals ]]--
local AddonName = "BloodSurge"
local find = string.find
local ipairs = ipairs
local pairs = pairs
local insert = table.insert
local len = string.len
local sort = table.sort
local sub = string.sub
local tocVersion = select(4, GetBuildInfo())

local MAJOR_VERSION = GetAddOnMetadata("BloodSurge", "Version")
if (len(MAJOR_VERSION)<=8) then
	BS.version = sub(MAJOR_VERSION, 0, 8)
else
	BS.version = MAJOR_VERSION .. " DEV"
end
BS.date = GetAddOnMetadata("BloodSurge", "X-Date")

defaults = {
	profile = {
		turnOn = true,
		Sound = true,
		Flash = true,
		Icon = true,
		UnlockIcon = false,
		IconSize = 75,
		IconLoc = {
			X = 0,
			Y = 50,
		},
    IconDura = 2.6,
    IconMod = 1.3,
    FlashDura = 2.6,
    FlashMod = 1.3,
		Msg = false,
		Color = {},
		DefSoundName = "Chimes",
		Skins = {
			SkinID = "Blizzard",
			Gloss = false,
			Backdrop = false,
			Colors = {},
		},
	},
}

function BS:OnInitialize()
	local ACD = LibStub("AceConfigDialog-3.0")
	local LAP = LibStub("LibAboutPanel")

	self.db = LibStub("AceDB-3.0"):New("BloodSurgeDB", defaults)

	local ACP = LibStub("AceDBOptions-3.0"):GetOptionsTable(BloodSurge.db)
	
	local AC = LibStub("AceConsole-3.0")
	AC:RegisterChatCommand("bs", function() BS:OpenOptions() end)
	AC:RegisterChatCommand("BloodSurge", function() BS:OpenOptions() end)
	
	local ACfg = LibStub("AceConfig-3.0")
	ACfg:RegisterOptionsTable("BloodSurge", BS:getOptions())

	-- Set up options panels.
	self.OptionsPanel = ACD:AddToBlizOptions(self.name, self.name, nil, "generalGroup")
	self.OptionsPanel.about = LAP.new(self.name, self.name)
	
	if (LSM) then
		LSM:Register("sound", "Chimes",[[Interface\AddOns\]]..AddonName..[[\sounds\Chime.ogg]])
		BS.SoundFile = LSM:Fetch("sound", BS.db.profile.DefSoundName)
	end
	
	if (IsLoggedIn()) then
		self:IsLoggedIn()
	else
		self:RegisterEvent("PLAYER_LOGIN", "IsLoggedIn")
	end
end

-- :OpenOptions(): Opens the options window.
function BS:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
end

function BS:IsLoggedIn()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "BloodSurge")
	BS:LoadMSQ()
	BS:RefreshLocals()
	self:UnregisterEvent("PLAYER_LOGIN")
end

function BS:PrintIt(txt)
	print(txt)
end

function BS:UpdateColors()
	local c = BS.db.profile.Color
	for k, v in ipairs(c) do
		v:SetVertexColor(c.r or 1.00, c.g or 0.49, c.b or 0.04, (c.a or 0.25) * (v.alphaFactor or 1) / BS:GetAlpha())
	end
	BS:RefreshLocals()
end

function BS:RefreshLocals()
	self.IconFrame = nil
	self.FlashFrame = nil
	BS.SoundFile = LSM:Fetch("sound", BS.db.profile.DefSoundName) or BS.db.profile.DefSound
  IconSize = BS.db.profile.IconSize
  IconX = BS.db.profile.IconLoc.X
  IconY = BS.db.profile.IconLoc.Y
  IconDura = BS.db.profile.IconDura
  IconMod = BS.db.profile.IconMod
  FlashDura = BS.db.profile.FlashDura
  FlashMod = BS.db.profile.FlashMod
	if (BS.db.profile.debug) then
		BS:PrintIt("BloodSurge: Icon Information: " .. IconSize .. " - " .. IconX .. " - " .. IconY .. " - " .. IconDura .. " - " .. FlashDura .. " - " .. IconMod .. " - " .. FlashMod)
	end
end

--[[ LibButtonFacade ]]--
function BS:LoadMSQ()
	if MSQ then
		local group = MSQ:Group("BloodSurge", "Icon")
		
		group.SkinID = BS.db.profile.Skins.SkinID
		group.Backdrop = BS.db.profile.Skins.Backdrop
		group.Gloss = BS.db.profile.Skins.Gloss
		group.Colors = BS.db.profile.Skins.Colors or {}
		
		MSQ:Register("BloodSurge", BS.SkinChanged, self)
		
		MSQGroup = group
	end
end

function BS:SkinChanged(SkinID, Gloss, Backdrop, Group, Button, Colors)
		BS.db.profile.Skins.SkinID = SkinID
		BS.db.profile.Skins.Gloss = Gloss
		BS.db.profile.Skins.Backdrop = Backdrop
		BS.db.profile.Skins.Colors = Colors
end

--[[ Icon Func ]]--
function BS:Icon(spellTexture)
	if (spellTexture and spellTexture ~= savedTexture or not self.IconFrame) then
		local icon = CreateFrame("Button", "BloodSurgeIconFrame")
		icon:SetFrameStrata("BACKGROUND")
		icon:SetWidth(IconSize)
		icon:SetHeight(IconSize)
		icon:EnableMouse(false)
		icon:Hide()
		icon.texture = icon:CreateTexture(nil, "BACKGROUND")
		icon.texture:SetAllPoints(icon)
		icon.texture:SetTexture(spellTexture)
		icon:ClearAllPoints()
		icon:SetPoint("CENTER", BS.db.profile.IconLoc.X, BS.db.profile.IconLoc.Y) 
		icon.texture:SetBlendMode("ADD")
		icon:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		icon:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < IconDura then
				local alpha = elapsed % IconMod
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.IconFrame = icon
		if (MSQGroup and icon) then
			MSQGroup:AddButton(icon)
		end
	end
	self.IconFrame:Show()
	local savedTexture = spellTexture
end

--[[ Flash Func - Taken from Omen ]]--
function BS:Flash()
	if not self.FlashFrame then
		local c = BS.db.profile.Color
		local flasher = CreateFrame("Frame", "BloodSurgeFlashFrame")
		flasher:SetToplevel(true)
		flasher:SetFrameStrata("FULLSCREEN_DIALOG")
		flasher:SetAllPoints(UIParent)
		flasher:EnableMouse(false)
		flasher:Hide()
		flasher.texture = flasher:CreateTexture(nil, "BACKGROUND")
		flasher.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < FlashDura then
				local alpha = elapsed % FlashMod
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.FlashFrame = flasher
	end

	self.FlashFrame:Show()
end

--[[ Registered Event ]]--
function BS:BloodSurge(event, ...)
	if (BS.db.profile.debug) then
		BS:PrintIt("BS:BloodSurge() Have an Event!")
	end
	if (event == "COMBAT_LOG_EVENT" or "COMBAT_LOG_EVENT_UNFILTERED") then
		if (BS.db.profile.debug) then
			BS:PrintIt("BloodSurge: COMBAT_LOG_EVENT or COMBAT_LOG_EVENT_UNFILTERED")
		end
		local timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = select(1, ...)
		BS:SpellWarn(combatEvent, sourceName, spellId, spellName)
	end
end

function BS:SpellWarn(combatEvent, sourceName, spellId, spellName)
	if (BS.db.profile.turnOn and combatEvent ~= "SPELL_AURA_REMOVED" and combatEvent ~= "SPELL_AURA_REFRESHED" and combatEvent == "SPELL_AURA_APPLIED" and sourceName == UnitName("player")) then
		for k,v in pairs(L.SID) do
			if (spellId == nil or spellName == nil) then
				break
			elseif (find(spellId,v) or find(spellName,v)) then
				local name,_,spellTexture = GetSpellInfo(spellId or spellName)
				if (BS.db.profile.Sound) then
					PlaySoundFile(BS.SoundFile, "SFX")
				end
				if (BS.db.profile.Flash) then
					BS:Flash()
				end
				if (BS.db.profile.Icon) then
					BS:Icon(spellTexture)
				end
				if (BS.db.profile.Msg) then
					UIErrorsFrame:AddMessage(name,1,0,0,nil,3)
				end
			end
		end
	end
end	
