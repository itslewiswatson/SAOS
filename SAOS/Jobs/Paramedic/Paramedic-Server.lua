Paramedic = {}

function Paramedic.Pay(amount)
	if isElement(source) and amount then
		local money = client:getMoney()
		if money > amount then
			client:takeMoney(amount)
			source:giveMoney(amount)
			client:setHealth(client:getHealth()+amount)
		elseif money > 0 then
			client:setMoney(0)
			source:giveMoney(money)
			client:setHealth(client:getHealth()+money)
		end
	end
end
addEvent("SAOS.PayParamedic",true)
addEventHandler("SAOS.PayParamedic",root,Paramedic.Pay)