function PracticeStart( trigger )
	local caster = trigger.activator
	local caller = trigger.caller
	if caster:IsRealHero() == false then
		if caster:GetUnitName() == "heal_device" or caster:GetUnitName() == "heal_device_move" then
			caster = caster:GetOwner()
		elseif caster.currentHero then
			caster = caster.currentHero
		elseif caster:IsIllusion() then
			caster = caster.caster_hero
		end
	end
	if caller.unitRemaining == nil then
		caller.unitRemaining = {}
	end
	if caller.used == nil then
		caller.used = 0
	end
	for i=1,4 do
		 if caller:GetName() == "practice_"..tostring(i) then
	 		if caster:IsRealHero() then
			 	caller.used = caller.used + 1
				if caller.used == 1 and caller.onthink == false then
					PracticeThink(caller,caster)
					caller.onthink = true
				end
			end
	 		break
	 	end
	 end
	--print("[GuardingAthena]Practice Start")
end
function PracticeThink( caller, caster )
	Timers:CreateTimer(1,function()
		if caller.used >= 1 then
			if #caller.unitRemaining <= 0 then
				PracticeDoSpawn( caller, caster )
	        	return 2
			else
	        	return 2
	        end
	    end
	    caller.onthink = false
    end)
end
function PracticeDoSpawn( caller, caster )
	local practice_level = math.floor(caster.practice * 0.02)
	local unitName = Spawner.unitName or "practicer"
	for i=1,10 do
		PrecacheUnitByNameAsync( unitName, function()
			local SpawnPoint = caller:GetAbsOrigin()
			local unit = CreateUnitByName(unitName, SpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
			unit.practicer = true
			--local level = Spawner.gameRound or 1
			Spawner:UnitProperty(unit,Spawner.unitFactor)
			HeroState:InitUnit(unit)
			unit.percent_bonus_damage = unit.percent_bonus_damage - 50
			unit.percent_increase_damage = unit.percent_increase_damage + 100
			unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
			--unit:CreatureLevelUp(level)
			unit:SetDeathXP(unit:GetDeathXP() * 1.6 * (1 + 0.01 * practice_level))
			unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * 1.6 * (1 + 0.01 * practice_level))
			unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * 1.6 * (1 + 0.01 * practice_level))
			unit.room = caller
			table.insert(caller.unitRemaining,unit)
		end)
	end
end	
function PracticeEnd( trigger )
	local caster = trigger.activator
	local caller = trigger.caller
	if caster:IsRealHero() == false then
		if caster:GetUnitName() == "heal_device" or caster:GetUnitName() == "heal_device_move" then
			caster = caster:GetOwner()
		elseif caster.currentHero then
			caster = caster.currentHero
		elseif caster:IsIllusion() then
			caster = caster.caster_hero
		end
	end
	for i=1,4 do
	 	if caller:GetName() == "practice_"..tostring(i) then
	 		if caster:IsRealHero() then
				caller.used = caller.used - 1
			end
	 		break
	 	end
	end
end