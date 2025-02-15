--[[
Copyright 2012-2023 João Cardoso
PetTracker is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of PetTracker.
--]]

local ADDON, Addon = ...
local Addon = LibStub('WildAddon-1.0'):NewAddon(ADDON, Addon, 'MutexDelay-1.0')
Addon.MaxQuality = 6
Addon.MaxLevel = 25


--[[ Events ]]--

function Addon:OnEnable()
	PetTracker_State = PetTracker_State or {}
	PetTracker_Sets = setmetatable(PetTracker_Sets or {}, {__index = {
		trackPets = true, capturedPets = true, specieIcons = true, rivalPortraits = true,
		switcher = true, alertUpgrades = true, forfeit = true,
	}})

	self.sets, self.state = PetTracker_Sets, PetTracker_State
	if self.sets.tutorial == 12 then
		CreateFrame('Frame', nil, InterfaceOptionsFrame or SettingsPanel):SetScript('OnShow', function()
			LoadAddOn(ADDON .. '_Config')
		end)
	else
		LoadAddOn(ADDON .. '_Config')
	end

	LibStub('LibPetJournal-2.0').RegisterCallback(self, 'PostPetListUpdated', 'OnPetsChanged')
	self:RegisterEvent('PET_BATTLE_OPENING_START', 'OnBattle')
end

function Addon:OnPetsChanged()
	self:Delay(.1, 'SendSignal', 'COLLECTION_CHANGED')
end

function Addon:OnBattle()
	if LoadAddOn(ADDON .. '_Battle') then
		self:SendSignal('BATTLE_STARTED')
	end
end


--[[ Utility ]]--

function Addon:GetColor(quality)
	return quality > 0 and ITEM_QUALITY_COLORS[quality - 1].color or RED_FONT_COLOR
end
