--[[
BloodSurge
		Instant SLAM! Notification

File Author: @file-author@
File Revision: @file-revision@
File Date: @file-date-iso@

* Copyright (c) 2008, Evonder
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
* THIS SOFTWARE IS PROVIDED BY <copyright holder> ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]
BloodSurge = LibStub("AceAddon-3.0"):NewAddon("BloodSurge", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("BloodSurge")
local BS = BloodSurge

local MAJOR_VERSION = "1.0"
local MINOR_VERSION = 000 + tonumber(("$Revision: @project-revision@ $"):match("%d+"))
BS.version = MAJOR_VERSION .. "." .. MINOR_VERSION
BS.date = string.sub("$Date: @file-date-iso@ $", 8, 17)

--[[ Locals ]]--
local find = _G.string.find

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
			Y = 0,
		},
		Msg = false,
		Color = {},
		SID = {
			"168"
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
	
	local ACR = LibStub("AceConfigRegistry-3.0")
	ACR:RegisterOptionsTable("BloodSurge", options)
	ACR:RegisterOptionsTable("BloodSurgeP", ACP)

	-- Set up options panels.
	self.OptionsPanel = ACD:AddToBlizOptions(self.name, self.name, nil, "generalGroup")
	self.OptionsPanel.profiles = ACD:AddToBlizOptions("BloodSurgeP", "Profiles", self.name)
	self.OptionsPanel.about = LAP.new(self.name, self.name)
	
	if IsLoggedIn() then
		self:IsLoggedIn()
	else
		self:RegisterEvent("PLAYER_LOGIN", "IsLoggedIn")
	end
end

-- :OpenOptions(): Opens the options window.
function BS:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
end

function BS:IsLoggedIn()
	self:RegisterEvent("COMBAT_LOG_EVENT", "BloodSurge")
	self:UnregisterEvent("PLAYER_LOGIN")
	BS:RefreshLocals()
end

function BS:RefreshLocals()
	self.IconFrame = nil
  IconSize = BS.db.profile.IconSize
  IconX = BS.db.profile.IconLoc.X
  IconY = BS.db.profile.IconLoc.Y
end

--[[ Icon Func ]]--
function BS:Icon(spellId)
	local _,_,spellTexture = GetSpellInfo(spellId)
	if not self.IconFrame then
		local icon = CreateFrame("Frame", "BloodSurgeIconFrame")
		icon:SetFrameStrata("BACKGROUND")
		icon:SetWidth(IconSize)
		icon:SetHeight(IconSize)
		icon:EnableMouse(false)
		icon:Hide()
		icon.texture = icon:CreateTexture(nil, "BACKGROUND")
		icon.texture:SetTexture(spellTexture)
		icon.texture:SetAllPoints(icon)
		icon:ClearAllPoints()
		icon:SetPoint("CENTER", BS.db.profile.IconLoc.X, BS.db.profile.IconLoc.Y) 
		icon.texture:SetBlendMode("ADD")
		icon:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		icon:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < 2.6 then
				local alpha = elapsed % 1.3
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
	end
	self.IconFrame:Show()
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
		flasher.texture:SetTexture(c.r or 1.00, c.g or 0.49, c.b or 0.04, c.a or 0.25)
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < 2.6 then
				local alpha = elapsed % 1.3
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

function BS:BloodSurge(self, event, ...) 
	local combatEvent, sourceName = arg2, arg4 or select(2, 4)
	local spellId, spellName = arg9, arg10 or select(9, 10)
	
	for i,v in ipairs(BS.db.profile.SID) do
		if (combatEvent == "SPELL_AURA_APPLIED" and sourceName == UnitName("player") and find(spellId,v) and BS.db.profile.turnOn) then
			if (BS.db.profile.Sound == true) then
				PlaySoundFile("Interface\\AddOns\\b-thirst\\slam.mp3")
			end
			if (BS.db.profile.Flash) then
				BS:Flash()
			end
			if (BS.db.profile.Icon) then
				BS:Icon(spellId)
			end
			if (BS.db.profile.Msg) then
				UIErrorsFrame:AddMessage("Slam!",1,0,0,nil,3)
			end
		end
	end
end
