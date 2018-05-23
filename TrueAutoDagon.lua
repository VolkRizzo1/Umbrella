local AutoDagon122112 = {}
AutoDagon122112.optionEnable = Menu.AddOptionBool({"TheCrazy88","AutoDagon"},"Activation", true)

function AutoDagon122112.OnUpdate()
	if not Menu.IsEnabled(AutoDagon122112.optionEnable) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if not Entity.IsAlive(myHero) or NPC.IsStunned(myHero) then return end
	local dagon = NPC.GetItem(myHero, "item_dagon", true)
	if not dagon then dagon = NPC.GetItem(myHero, "item_dagon_2", true)
	if not dagon then dagon = NPC.GetItem(myHero, "item_dagon_3", true)
	if not dagon then dagon = NPC.GetItem(myHero, "item_dagon_4", true)
	if not dagon then dagon = NPC.GetItem(myHero, "item_dagon_5", true) 
	end	end	end	end
	if dagon and Ability.IsReady(dagon) and Ability.GetManaCost(dagon) <= NPC.GetMana(myHero) then
		local damageDagon = Ability.GetLevelSpecialValueFor(dagon, "damage")
		local BuffDmg = 0
		if Hero.GetPrimaryAttribute(myHero) == 2 then BuffDmg = Hero.GetIntellectTotal(myHero) * 0.0855
		else BuffDmg = Hero.GetIntellectTotal(myHero) * 0.069 end
		if NPC.GetItem(myHero, "item_kaya", true) then BuffDmg = BuffDmg + 10 end
		for _,hero in pairs(Heroes.GetAll()) do
			if hero ~= nil and hero ~= 0 and NPCs.Contains(hero) and NPC.IsEntityInRange(myHero,hero,Ability.GetCastRange(dagon)) and not Entity.IsSameTeam(hero,myHero) then
				if Entity.IsAlive(hero) and not Entity.IsDormant(hero) and not NPC.IsIllusion(hero) and AutoDagon122112.IsHasGuard(hero) == "nil" then
					local totaldomage = (damageDagon * NPC.GetMagicalArmorDamageMultiplier(hero)) * (BuffDmg/100+1)
					if Entity.GetHealth(hero) <= totaldomage then
						Ability.CastTarget(dagon, hero)
					end
				end
			end
		end
	end
end

function AutoDagon122112.IsHasGuard(npc)
	local guarditis = "nil"
	if NPC.IsLinkensProtected(npc) then guarditis = "Linkens" end
	if NPC.HasModifier(npc,"modifier_item_blade_mail_reflect") then guarditis = "BM" end
	local spell_shield = NPC.GetAbility(npc, "antimage_spell_shield")
	if spell_shield and Ability.IsReady(spell_shield) and (NPC.HasModifier(npc, "modifier_item_ultimate_scepter") or NPC.HasModifier(npc, "modifier_item_ultimate_scepter_consumed")) then
		guarditis = "Lotus"
	end
	if NPC.HasModifier(npc,"modifier_item_lotus_orb_active") then guarditis = "Lotus" end
	if 	NPC.HasState(npc,Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or 
		NPC.HasState(npc,Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME) or
		NPC.HasModifier(npc,"modifier_medusa_stone_gaze_stone") or
		NPC.HasModifier(npc,"modifier_winter_wyvern_winters_curse") or
		NPC.HasModifier(npc,"modifier_templar_assassin_refraction_absorb") or
		NPC.HasModifier(npc,"modifier_nyx_assassin_spiked_carapace") or
		NPC.HasModifier(npc,"modifier_abaddon_borrowed_time") or
		NPC.HasModifier(npc,"modifier_item_aeon_disk_buff") then
			guarditis = "Immune"
	end
	if NPC.HasModifier(npc,"modifier_legion_commander_duel") then
		local duel = NPC.GetAbility(npc, "legion_commander_duel")
		if duel then
			if NPC.HasModifier(npc, "modifier_item_ultimate_scepter") or NPC.HasModifier(npc, "modifier_item_ultimate_scepter_consumed") then
				guarditis = "Immune"
			end
		else
			for _,hero in pairs(Heroes.GetAll()) do
				if hero ~= nil and hero ~= 0 and NPCs.Contains(hero) and not Entity.IsSameTeam(hero,npc) and NPC.HasModifier(hero,"modifier_legion_commander_duel") then
					local dueltarget = NPC.GetAbility(hero, "legion_commander_duel")
					if dueltarget then
						if NPC.HasModifier(hero, "modifier_item_ultimate_scepter") or NPC.HasModifier(hero, "modifier_item_ultimate_scepter_consumed") then
							guarditis = "Immune"
						end
					end
				end
			end
		end
	end
	local aeon_disk = NPC.GetItem(npc, "item_aeon_disk")
	if aeon_disk and Ability.IsReady(aeon_disk) then guarditis = "Immune" end
	return guarditis
end

return AutoDagon122112
