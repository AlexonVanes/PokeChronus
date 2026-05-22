function onMove(creature, toPosition, fromPosition)
	local player = Player(creature:getId())
	if not hasSummons(player) then
		return true
	end

	local summon = player:getSummon()
	if summon:getSpeed() == 0 then
		summon:changeSpeed(summon:getTotalSpeed())
	end

	return true
end
