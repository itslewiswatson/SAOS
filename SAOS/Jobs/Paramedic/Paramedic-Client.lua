Paramedic = {}

function Paramedic.Heal(paramedic,weapon,loss)
	if isElement(paramedic) and paramedic:getType() == "player" and paramedic:getData("job") == "Paramedic" and weapon == 41 then
		cancelEvent()
		if not Paramedic.Cooldown then
			local health = localPlayer:getHealth()
			if health < 100 then
				triggerServerEvent("SAOS.PayParamedic",paramedic,health < 95 and 5 or 100-health)
				Paramedic.Cooldown = setTimer(function() Paramedic.Cooldown = nil end,500,1)
			end
		end
	end
end
addEventHandler("onClientPlayerDamage",root,Paramedic.Heal)