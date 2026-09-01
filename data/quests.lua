--==================================================
-- DEAL BLOX
-- DATA / QUESTS
-- Auto Farm - rotas por level
--==================================================

local Quests = {}

Quests.PlaceIds = {
	[2753915549] = 1,
	[4442272183] = 2,
	[7449423635] = 3,
}

local function Q(
	level,
	quest,
	questNum,
	mob,
	qx, qy, qz,
	mx, my, mz,
	extra
)
	local data = {
		Level = level,
		Quest = quest,
		QuestNum = questNum,
		Mob = mob,
		QuestPos = CFrame.new(qx, qy, qz),
		MobPos = CFrame.new(mx, my, mz),
	}

	if extra then
		for key, value in pairs(extra) do
			data[key] = value
		end
	end

	return data
end

--==================================================
-- SEA 1
--==================================================

Quests[1] = {
	Q(1, "BanditQuest1", 1, "Bandit",
		1060, 16, 1548,
		1038, 41, 1576),

	Q(10, "JungleQuest", 1, "Monkey",
		-1601, 37, 153,
		-1448, 51, 64),

	Q(15, "JungleQuest", 2, "Gorilla",
		-1601, 37, 153,
		-1142, 40, -515),

	Q(30, "BuggyQuest1", 1, "Pirate",
		-1140, 5, 3827,
		-1201, 41, 3857),

	Q(40, "BuggyQuest1", 2, "Brute",
		-1140, 5, 3827,
		-1387, 25, 4101),

	Q(60, "DesertQuest", 1, "Desert Bandit",
		897, 6, 4388,
		984, 16, 4417),

	Q(75, "DesertQuest", 2, "Desert Officer",
		897, 6, 4388,
		1547, 15, 4381),

	Q(90, "SnowQuest", 1, "Snow Bandit",
		1386, 87, -1297,
		1356, 105, -1328),

	Q(100, "SnowQuest", 2, "Snowman",
		1386, 87, -1297,
		1220, 138, -1488),

	Q(120, "MarineQuest2", 1, "Chief Petty Officer",
		-5035, 29, 4324,
		-4881, 23, 4273),

	Q(150, "SkyQuest", 1, "Sky Bandit",
		-4842, 718, -2623,
		-4953, 295, -2899),

	Q(175, "SkyQuest", 2, "Dark Master",
		-4842, 718, -2623,
		-5224, 431, -2278),

	Q(190, "PrisonerQuest", 1, "Prisoner",
		5308, 2, 475,
		5098, 0, 474),

	Q(210, "PrisonerQuest", 2, "Dangerous Prisoner",
		5308, 2, 475,
		5654, 16, 866),

	Q(250, "ColosseumQuest", 1, "Toga Warrior",
		-1580, 6, -2986,
		-1820, 52, -2741),

	Q(275, "ColosseumQuest", 2, "Gladiator",
		-1580, 6, -2986,
		-1293, 56, -3339),

	Q(300, "MagmaQuest", 1, "Military Soldier",
		-5313, 11, 8515,
		-5411, 11, 8454),

	Q(325, "MagmaQuest", 2, "Military Spy",
		-5313, 11, 8515,
		-5803, 86, 8829),

	Q(375, "FishmanQuest", 1, "Fishman Warrior",
		61122, 18, 1569,
		60878, 18, 1544),

	Q(400, "FishmanQuest", 2, "Fishman Commando",
		61122, 18, 1569,
		61922, 18, 1493),

	Q(450, "SkyExp1Quest", 1, "God's Guard",
		-4721, 845, -1954,
		-4628, 866, -1931),

	Q(475, "SkyExp1Quest", 2, "Shanda",
		-7859, 5544, -381,
		-7678, 5566, -497),

	Q(525, "SkyExp2Quest", 1, "Royal Squad",
		-7906, 5634, -1411,
		-7624, 5658, -1467),

	Q(550, "SkyExp2Quest", 2, "Royal Soldier",
		-7906, 5634, -1411,
		-7836, 5645, -1790),

	Q(625, "FountainQuest", 1, "Galley Pirate",
		5259, 38, 4050,
		5551, 79, 3930),

	Q(650, "FountainQuest", 2, "Galley Captain",
		5259, 38, 4050,
		5442, 43, 4950),
}

--==================================================
-- SEA 2
--==================================================

Quests[2] = {
	Q(700, "Area1Quest", 1, "Raider",
		-428, 73, 1836,
		69, 94, 2430),

	Q(725, "Area1Quest", 2, "Mercenary",
		-428, 73, 1836,
		-865, 122, 1453),

	Q(775, "Area2Quest", 1, "Swan Pirate",
		636, 73, 918,
		1065, 138, 1324),

	Q(800, "Area2Quest", 2, "Factory Staff",
		636, 73, 918,
		295, 73, -57),

	Q(875, "MarineQuest3", 1, "Marine Lieutenant",
		-2440, 72, -3216,
		-2821, 76, -3070),

	Q(900, "MarineQuest3", 2, "Marine Captain",
		-2440, 72, -3216,
		-1861, 80, -3255),

	Q(950, "ZombieQuest", 1, "Zombie",
		-5497, 48, -795,
		-5736, 126, -728),

	Q(975, "ZombieQuest", 2, "Vampire",
		-5497, 48, -795,
		-6033, 7, -1317),

	Q(1000, "SnowMountainQuest", 1, "Snow Trooper",
		604, 401, -5371,
		535, 432, -5485),

	Q(1050, "SnowMountainQuest", 2, "Winter Warrior",
		604, 401, -5371,
		1235, 456, -5175),

	Q(1100, "IceSideQuest", 1, "Lab Subordinate",
		-6064, 15, -4903,
		-5720, 63, -4785),

	Q(1125, "IceSideQuest", 2, "Horned Warrior",
		-6064, 15, -4903,
		-6341, 16, -5723),

	Q(1175, "FireSideQuest", 1, "Magma Ninja",
		-5428, 15, -5299,
		-5449, 77, -5808),

	Q(1200, "FireSideQuest", 2, "Lava Pirate",
		-5428, 15, -5299,
		-5213, 49, -4701),

	Q(1250, "ShipQuest1", 1, "Ship Deckhand",
		1040, 125, 32911,
		921, 126, 33088),

	Q(1275, "ShipQuest1", 2, "Ship Engineer",
		1040, 125, 32911,
		886, 40, 32801),

	Q(1300, "ShipQuest2", 1, "Ship Steward",
		971, 125, 33246,
		944, 130, 33444),

	Q(1325, "ShipQuest2", 2, "Ship Officer",
		971, 125, 33246,
		-14, 181, 33334),

	Q(1350, "FrostQuest", 1, "Arctic Warrior",
		5668, 27, -6486,
		5966, 63, -6179),

	Q(1375, "FrostQuest", 2, "Snow Lurker",
		5668, 27, -6486,
		5407, 69, -6881),

	Q(1425, "ForgottenQuest", 1, "Sea Soldier",
		-3054, 236, -10143,
		-3028, 65, -9775),

	Q(1450, "ForgottenQuest", 2, "Water Fighter",
		-3054, 236, -10143,
		-3262, 298, -10552),
}

--==================================================
-- SEA 3
--==================================================

Quests[3] = {
	Q(1500, "PiratePortQuest", 1, "Pirate Millionaire",
		-290, 44, 5580,
		-373, 75, 5550),

	Q(1525, "PiratePortQuest", 2, "Pistol Billionaire",
		-290, 44, 5580,
		-470, 74, 5900),

	Q(1575, "DragonCrewQuest", 1, "Dragon Crew Warrior",
		6750, 127, -711,
		6709, 52, -1139),

	Q(1600, "DragonCrewQuest", 2, "Dragon Crew Archer",
		6750, 127, -711,
		6669, 481, 329),

	Q(1625, "VenomCrewQuest", 1, "Hydra Enforcer",
		5206, 1004, 748,
		4547, 1003, 334),

	Q(1650, "VenomCrewQuest", 2, "Venomous Assailant",
		5206, 1004, 748,
		4674, 1003, 777),

	Q(1700, "MarineTreeIsland", 1, "Marine Commodore",
		2180, 29, -6740,
		2198, 129, -7109),

	Q(1725, "MarineTreeIsland", 2, "Marine Rear Admiral",
		2180, 29, -6740,
		3294, 385, -7049),

	Q(1775, "DeepForestIsland3", 1, "Fishman Raider",
		-10583, 332, -8758,
		-10553, 521, -8177),

	Q(1800, "DeepForestIsland3", 2, "Fishman Captain",
		-10583, 332, -8758,
		-10993, 352, -9002),

	Q(1825, "DeepForestIsland", 1, "Forest Pirate",
		-13233, 332, -7625,
		-13270, 404, -7772),

	Q(1850, "DeepForestIsland", 2, "Mythological Pirate",
		-13233, 332, -7625,
		-13545, 470, -6917),

	Q(1900, "DeepForestIsland2", 1, "Jungle Pirate",
		-12682, 391, -9902,
		-12267, 460, -10277),

	Q(1925, "DeepForestIsland2", 2, "Musketeer Pirate",
		-12682, 391, -9902,
		-13291, 520, -9905),

	Q(1975, "HauntedQuest1", 1, "Reborn Skeleton",
		-9481, 142, 5566,
		-8762, 183, 6168),

	Q(2000, "HauntedQuest1", 2, "Living Zombie",
		-9481, 142, 5566,
		-10144, 140, 5932),

	Q(2025, "HauntedQuest2", 1, "Demonic Soul",
		-9516, 172, 6079,
		-9507, 172, 6158),

	Q(2050, "HauntedQuest2", 2, "Posessed Mummy",
		-9516, 172, 6079,
		-9585, 6, 6200),

	Q(2075, "NutsIslandQuest", 1, "Peanut Scout",
		-2103, 38, -10192,
		-2150, 122, -10358),

	Q(2100, "NutsIslandQuest", 2, "Peanut President",
		-2103, 38, -10192,
		-2150, 122, -10500),

	Q(2125, "IceCreamIslandQuest", 1, "Ice Cream Chef",
		-820, 66, -10966,
		-872, 66, -10918),

	Q(2150, "IceCreamIslandQuest", 2, "Ice Cream Commander",
		-820, 66, -10966,
		-620, 126, -11200),

	Q(2200, "CakeQuest1", 1, "Cookie Crafter",
		-2022, 37, -12031,
		-2322, 37, -12217),

	Q(2225, "CakeQuest1", 2, "Cake Guard",
		-2022, 37, -12031,
		-1418, 37, -12256),

	Q(2250, "CakeQuest2", 1, "Baking Staff",
		-1928, 38, -12841,
		-1980, 37, -12984),

	Q(2275, "CakeQuest2", 2, "Head Baker",
		-1928, 38, -12841,
		-2252, 52, -13033),

	Q(2300, "ChocQuest1", 1, "Cocoa Warrior",
		233, 30, -12201,
		-22, 81, -12352),

	Q(2325, "ChocQuest1", 2, "Chocolate Bar Battler",
		233, 30, -12201,
		583, 77, -12463),

	Q(2350, "ChocQuest2", 1, "Sweet Thief",
		151, 31, -12775,
		165, 76, -12601),

	Q(2375, "ChocQuest2", 2, "Candy Rebel",
		151, 31, -12775,
		135, 77, -12877),

	Q(2400, "CandyQuest1", 1, "Candy Pirate",
		-1150, 20, -14446,
		-1311, 26, -14562),

	Q(2425, "CandyQuest1", 2, "Snow Demon",
		-1150, 20, -14446,
		-880, 71, -14539),

	Q(2450, "TikiQuest1", 1, "Isle Outlaw",
		-16548, 61, -173,
		-16443, 116, -264),

	Q(2475, "TikiQuest1", 2, "Island Boy",
		-16548, 61, -173,
		-16901, 84, -193),

	Q(2500, "TikiQuest2", 1, "Sun-kissed Warrior",
		-16539, 56, 1052,
		-16321, 92, 1111),

	Q(2525, "TikiQuest2", 2, "Isle Champion",
		-16539, 56, 1052,
		-16642, 126, 1065),

	Q(2550, "TikiQuest3", 1, "Serpent Hunter",
		-16667, 105, 1574,
		-16551, 116, 1539),

	Q(2575, "TikiQuest3", 2, "Skull Slayer",
		-16667, 105, 1574,
		-16809, 121, 1480),

	--==================================================
	-- SUBMERGED ISLAND
	--==================================================

	Q(2600, "SubmergedQuest1", 1, "Reef Bandit",
		10778.875, -2087.724, 9265.184,
		11019.132, -2146.068, 9342.392,
		{ RequiresSubmerged = true }),

	Q(2625, "SubmergedQuest1", 2, "Coral Pirate",
		10778.875, -2087.724, 9265.184,
		10808.601, -2030.361, 9364.233,
		{ RequiresSubmerged = true }),

	Q(2650, "SubmergedQuest2", 1, "Sea Chanter",
		10880.686, -2086.200, 10032.624,
		10671.272, -2057.592, 10047.259,
		{ RequiresSubmerged = true }),

	Q(2675, "SubmergedQuest2", 2, "Ocean Prophet",
		10880.686, -2086.200, 10032.624,
		11008.520, -2007.728, 10223.079,
		{ RequiresSubmerged = true }),

	Q(2700, "SubmergedQuest3", 1, "High Disciple",
		9640.088, -1992.445, 9613.652,
		9750.416, -1966.939, 9753.360,
		{ RequiresSubmerged = true }),

	Q(2725, "SubmergedQuest3", 2, "Grand Devotee",
		9640.088, -1992.445, 9613.652,
		9611.705, -1993.471, 9882.688,
		{ RequiresSubmerged = true }),
}

--==================================================
-- SEA
--==================================================

local function Normalize(text)
	return string.lower(
		string.gsub(
			tostring(text or ""),
			"[%s%p_]+",
			""
		)
	)
end

local SeaLocations = {
	[1] = {
		"Middle Town",
		"Jungle",
		"Pirate Village",
		"Desert",
		"Frozen Village",
		"Marine Fortress",
		"Skylands",
		"Prison",
		"Magma Village",
		"Underwater City",
		"Fountain City",
	},

	[2] = {
		"Kingdom of Rose",
		"Green Zone",
		"Graveyard",
		"Snow Mountain",
		"Hot and Cold",
		"Cursed Ship",
		"Ice Castle",
		"Forgotten Island",
	},

	[3] = {
		"Port Town",
		"Hydra Island",
		"Great Tree",
		"Floating Turtle",
		"Castle on the Sea",
		"Haunted Castle",
		"Sea of Treats",
		"Tiki Outpost",
		"Submerged Island",
	},
}

local CachedSea = nil

local function DetectSeaFromMap()
	local origin =
		workspace:FindFirstChild("_WorldOrigin")

	local locations =
		origin
		and
		origin:FindFirstChild("Locations")

	if not locations then
		return 0
	end

	local existing = {}

	for _, child in ipairs(
		locations:GetChildren()
	) do
		existing[
			Normalize(child.Name)
		] = true
	end

	local bestSea = 0
	local bestScore = 0

	for sea, names in pairs(
		SeaLocations
	) do
		local score = 0

		for _, name in ipairs(names) do
			if existing[Normalize(name)] then
				score += 1
			end
		end

		if score > bestScore then
			bestScore = score
			bestSea = sea
		end
	end

	if bestScore > 0 then
		return bestSea
	end

	return 0
end

function Quests.GetSea()
	if CachedSea then
		return CachedSea
	end

	local placeSea =
		Quests.PlaceIds[
			game.PlaceId
		]

	if placeSea then
		CachedSea = placeSea
		return CachedSea
	end

	local mapSea =
		DetectSeaFromMap()

	if mapSea > 0 then
		CachedSea = mapSea
		return CachedSea
	end

	return 0
end

function Quests.GetRequiredSea(level)
	level = tonumber(level) or 1

	if level >= 1500 then
		return 3
	end

	if level >= 700 then
		return 2
	end

	return 1
end

function Quests.GetForLevel(level, sea)
	level = tonumber(level) or 1
	sea = sea or Quests.GetSea()

	local seaData =
		Quests[sea]

	if not seaData then
		return nil
	end

	local selected = nil

	for _, data in ipairs(
		seaData
	) do
		if level >= data.Level then
			selected = data
		else
			break
		end
	end

	return selected
end

return Quests
