--==================================================
-- DEAL BLOX
-- DATA / SHOP
--==================================================

local ShopData = {}

--==================================================
-- HABILIDADES
--==================================================

ShopData.Abilities = {
	{
		Id = "air_jump",
		Name = "Air Jump",
		Subtitle = "Geppo",
		Description = "Compra a habilidade de pulo no ar.",
		Calls = {
			{"BuyHaki", "Geppo"},
		},
	},
	{
		Id = "aura",
		Name = "Aura",
		Subtitle = "Haki do Armamento",
		Description = "Compra a habilidade Aura / Buso.",
		Calls = {
			{"BuyHaki", "Buso"},
		},
	},
	{
		Id = "flash_step",
		Name = "Flash Step",
		Subtitle = "Soru",
		Description = "Compra a habilidade de movimento rápido.",
		Calls = {
			{"BuyHaki", "Soru"},
		},
	},
	{
		Id = "instinct",
		Name = "Instinct",
		Subtitle = "Haki da Observação",
		Description = "Tenta comprar o Instinct pelo sistema do NPC.",
		Calls = {
			{"KenTalk", "Buy"},
		},
	},
}

--==================================================
-- ESTILOS DE LUTA
--==================================================

ShopData.FightingStyles = {
	{
		Id = "dark_step",
		Name = "Dark Step",
		Description = "Estilo de luta baseado em chutes.",
		Calls = {
			{"BuyBlackLeg"},
		},
	},
	{
		Id = "electric",
		Name = "Electric",
		Description = "Estilo elétrico básico.",
		Calls = {
			{"BuyElectro"},
		},
	},
	{
		Id = "water_kung_fu",
		Name = "Water Kung Fu",
		Description = "Estilo de luta aquático.",
		Calls = {
			{"BuyFishmanKarate"},
		},
	},
	{
		Id = "dragon_breath",
		Name = "Dragon Breath",
		Description = "Estilo baseado em técnicas de dragão.",
		Calls = {
			{"BlackbeardReward", "DragonClaw", "1"},
			{"BlackbeardReward", "DragonClaw", "2"},
		},
	},
	{
		Id = "superhuman",
		Name = "Superhuman",
		Description = "Estilo avançado.",
		Calls = {
			{"BuySuperhuman"},
		},
	},
	{
		Id = "death_step",
		Name = "Death Step",
		Description = "Evolução do Dark Step.",
		Calls = {
			{"BuyDeathStep"},
		},
	},
	{
		Id = "sharkman_karate",
		Name = "Sharkman Karate",
		Description = "Evolução do Water Kung Fu.",
		Calls = {
			{"BuySharkmanKarate", true},
			{"BuySharkmanKarate"},
		},
	},
	{
		Id = "electric_claw",
		Name = "Electric Claw",
		Description = "Evolução do Electric.",
		Calls = {
			{"BuyElectricClaw"},
		},
	},
	{
		Id = "dragon_talon",
		Name = "Dragon Talon",
		Description = "Evolução do Dragon Breath.",
		Calls = {
			{"BuyDragonTalon"},
		},
	},
	{
		Id = "godhuman",
		Name = "Godhuman",
		Description = "Estilo de luta avançado.",
		Calls = {
			{"BuyGodhuman"},
		},
	},
	{
		Id = "sanguine_art",
		Name = "Sanguine Art",
		Description = "Estilo de luta avançado.",
		Calls = {
			{"BuySanguineArt"},
		},
	},
}

--==================================================
-- LOJAS DE FRUTAS
--==================================================

ShopData.FruitStores = {
	{
		Id = "normal",
		Name = "Loja Normal",
		Subtitle = "Blox Fruit Dealer",
		Description = "Mostra o estoque normal sem precisar ir até o NPC.",
		Advanced = false,
	},
	{
		Id = "mirage",
		Name = "Loja Mirage",
		Subtitle = "Advanced Fruit Dealer",
		Description = "Mostra o estoque avançado/Mirage quando disponível.",
		Advanced = true,
	},
}

return ShopData
