--==================================================
-- DEAL BLOX
-- CORE / STATE
-- Estado compartilhado entre os módulos
--==================================================

local State = {}

State.Settings = {
	AutoFarm = false,

	-- Categoria usada para atacar
	AttackType = "Estilo de luta",

	-- Altura acima do NPC
	FarmHeight = 24,

	-- Intervalo entre ataques
	AttackDelay = 0.10,

	-- Velocidade dos Tweens
	TweenSpeed = 350,

	-- Haki automático
	AutoBuso = true,
}

State.Runtime = {
	Status = "Parado",

	Sea = 0,
	Level = 0,

	Quest = "Nenhuma",
	Target = "Nenhum",

	Warning = "",
	WarningUntil = 0,
}

State.Changed = Instance.new("BindableEvent")

function State:SetSetting(name, value)
	self.Settings[name] = value

	self.Changed:Fire(
		"Setting",
		name,
		value
	)
end

function State:SetRuntime(name, value)
	if self.Runtime[name] == value then
		return
	end

	self.Runtime[name] = value

	self.Changed:Fire(
		"Runtime",
		name,
		value
	)
end

function State:SetWarning(text, duration)
	duration = duration or 5

	self.Runtime.Warning = tostring(text)
	self.Runtime.WarningUntil = tick() + duration

	self.Changed:Fire(
		"Warning",
		self.Runtime.Warning,
		duration
	)
end

function State:ClearWarning()
	self.Runtime.Warning = ""
	self.Runtime.WarningUntil = 0
end

return State
