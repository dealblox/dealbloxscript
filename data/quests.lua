--==================================================
-- DEAL BLOX
-- DATA / QUESTS
-- Rota base do Auto Farm
--==================================================

local Quests = {}

Quests.PlaceIds = {
	[2753915549] = 1,
	[4442272183] = 2,
	[7449423635] = 3,
}

--==================================================
-- SEA 1
--==================================================

Quests[1] = {

	{
		Level = 1,
		Quest = "BanditQuest1",
		QuestNum = 1,
		Mob = "Bandit",

		QuestPos = CFrame.new(
			1060, 16, 1548
		),

		MobPos = CFrame.new(
			1038, 41, 1576
		)
	},

	{
		Level = 10,
		Quest = "JungleQuest",
		QuestNum = 1,
		Mob = "Monkey",

		QuestPos = CFrame.new(
			-1601, 37, 153
		),

		MobPos = CFrame.new(
			-1448, 51, 64
		)
	},

	{
		Level = 15,
		Quest = "JungleQuest",
		QuestNum = 2,
		Mob = "Gorilla",

		QuestPos = CFrame.new(
			-1601, 37, 153
		),

		MobPos = CFrame.new(
			-1142, 40, -515
		)
	},

	{
		Level = 30,
		Quest = "BuggyQuest1",
		QuestNum = 1,
		Mob = "Pirate",

		QuestPos = CFrame.new(
			-1140, 5, 3827
		),

		MobPos = CFrame.new(
			-1201, 41, 3857
		)
	},

	{
		Level = 40,
		Quest = "BuggyQuest1",
		QuestNum = 2,
		Mob = "Brute",

		QuestPos = CFrame.new(
			-1140, 5, 3827
		),

		MobPos = CFrame.new(
			-1387, 25, 4101
		)
	},

	{
		Level = 60,
		Quest = "DesertQuest",
		QuestNum = 1,
		Mob = "Desert Bandit",

		QuestPos = CFrame.new(
			897, 6, 4388
		),

		MobPos = CFrame.new(
			984, 16, 4417
		)
	},

	{
		Level = 75,
		Quest = "DesertQuest",
		QuestNum = 2,
		Mob = "Desert Officer",

		QuestPos = CFrame.new(
			897, 6, 4388
		),

		MobPos = CFrame.new(
			1547, 15, 4381
		)
	},

	{
		Level = 90,
		Quest = "SnowQuest",
		QuestNum = 1,
		Mob = "Snow Bandit",

		QuestPos = CFrame.new(
			1386, 87, -1297
		),

		MobPos = CFrame.new(
			1356, 105, -1328
		)
	},

	{
		Level = 100,
		Quest = "SnowQuest",
		QuestNum = 2,
		Mob = "Snowman",

		QuestPos = CFrame.new(
			1386, 87, -1297
		),

		MobPos = CFrame.new(
			1220, 138, -1488
		)
	},

	{
		Level = 120,
		Quest = "MarineQuest2",
		QuestNum = 1,
		Mob = "Chief Petty Officer",

		QuestPos = CFrame.new(
			-5035, 29, 4324
		),

		MobPos = CFrame.new(
			-4881, 23, 4273
		)
	},

	{
		Level = 150,
		Quest = "SkyQuest",
		QuestNum = 1,
		Mob = "Sky Bandit",

		QuestPos = CFrame.new(
			-4842, 718, -2623
		),

		MobPos = CFrame.new(
			-4953, 295, -2899
		)
	},

	{
		Level = 175,
		Quest = "SkyQuest",
		QuestNum = 2,
		Mob = "Dark Master",

		QuestPos = CFrame.new(
			-4842, 718, -2623
		),

		MobPos = CFrame.new(
			-5224, 431, -2278
		)
	},

	{
		Level = 190,
		Quest = "PrisonerQuest",
		QuestNum = 1,
		Mob = "Prisoner",

		QuestPos = CFrame.new(
			5308, 2, 475
		),

		MobPos = CFrame.new(
			5098, 0, 474
		)
	},

	{
		Level = 210,
		Quest = "PrisonerQuest",
		QuestNum = 2,
		Mob = "Dangerous Prisoner",

		QuestPos = CFrame.new(
			5308, 2, 475
		),

		MobPos = CFrame.new(
			5654, 16, 866
		)
	},

	{
		Level = 250,
		Quest = "ColosseumQuest",
		QuestNum = 1,
		Mob = "Toga Warrior",

		QuestPos = CFrame.new(
			-1580, 6, -2986
		),

		MobPos = CFrame.new(
			-1820, 52, -2741
		)
	},

	{
		Level = 275,
		Quest = "ColosseumQuest",
		QuestNum = 2,
		Mob = "Gladiator",

		QuestPos = CFrame.new(
			-1580, 6, -2986
		),

		MobPos = CFrame.new(
			-1293, 56, -3339
		)
	},

	{
		Level = 300,
		Quest = "MagmaQuest",
		QuestNum = 1,
		Mob = "Military Soldier",

		QuestPos = CFrame.new(
			-5313, 11, 8515
		),

		MobPos = CFrame.new(
			-5411, 11, 8454
		)
	},

	{
		Level = 325,
		Quest = "MagmaQuest",
		QuestNum = 2,
		Mob = "Military Spy",

		QuestPos = CFrame.new(
			-5313, 11, 8515
		),

		MobPos = CFrame.new(
			-5803, 86, 8829
		)
	},

	{
		Level = 375,
		Quest = "FishmanQuest",
		QuestNum = 1,
		Mob = "Fishman Warrior",

		QuestPos = CFrame.new(
			61122, 18, 1569
		),

		MobPos = CFrame.new(
			60878, 18, 1544
		)
	},

	{
		Level = 400,
		Quest = "FishmanQuest",
		QuestNum = 2,
		Mob = "Fishman Commando",

		QuestPos = CFrame.new(
			61122, 18, 1569
		),

		MobPos = CFrame.new(
			61922, 18, 1493
		)
	},

	{
		Level = 450,
		Quest = "SkyExp1Quest",
		QuestNum = 1,
		Mob = "God's Guard",

		QuestPos = CFrame.new(
			-4721, 845, -1954
		),

		MobPos = CFrame.new(
			-4628, 866, -1931
		)
	},

	{
		Level = 475,
		Quest = "SkyExp1Quest",
		QuestNum = 2,
		Mob = "Shanda",

		QuestPos = CFrame.new(
			-7859, 5544, -381
		),

		MobPos = CFrame.new(
			-7678, 5566, -497
		)
	},

	{
		Level = 525,
		Quest = "SkyExp2Quest",
		QuestNum = 1,
		Mob = "Royal Squad",

		QuestPos = CFrame.new(
			-7906, 5634, -1411
		),

		MobPos = CFrame.new(
			-7624, 5658, -1467
		)
	},

	{
		Level = 550,
		Quest = "SkyExp2Quest",
		QuestNum = 2,
		Mob = "Royal Soldier",

		QuestPos = CFrame.new(
			-7906, 5634, -1411
		),

		MobPos = CFrame.new(
			-7836, 5645, -1790
		)
	},

	{
		Level = 625,
		Quest = "FountainQuest",
		QuestNum = 1,
		Mob = "Galley Pirate",

		QuestPos = CFrame.new(
			5259, 38, 4050
		),

		MobPos = CFrame.new(
			5551, 79, 3930
		)
	},

	{
		Level = 650,
		Quest = "FountainQuest",
		QuestNum = 2,
		Mob = "Galley Captain",

		QuestPos = CFrame.new(
			5259, 38, 4050
		),

		MobPos = CFrame.new(
			5442, 43, 4950
		)
	},
}

--==================================================
-- SEA 2
--==================================================

Quests[2] = {

	{
		Level = 700,
		Quest = "Area1Quest",
		QuestNum = 1,
		Mob = "Raider",

		QuestPos = CFrame.new(
			-428, 73, 1836
		),

		MobPos = CFrame.new(
			69, 94, 2430
		)
	},

	{
		Level = 725,
		Quest = "Area1Quest",
		QuestNum = 2,
		Mob = "Mercenary",

		QuestPos = CFrame.new(
			-428, 73, 1836
		),

		MobPos = CFrame.new(
			-865, 122, 1453
		)
	},

	{
		Level = 775,
		Quest = "Area2Quest",
		QuestNum = 1,
		Mob = "Swan Pirate",

		QuestPos = CFrame.new(
			636, 73, 918
		),

		MobPos = CFrame.new(
			1065, 138, 1324
		)
	},

	{
		Level = 800,
		Quest = "Area2Quest",
		QuestNum = 2,
		Mob = "Factory Staff",

		QuestPos = CFrame.new(
			636, 73, 918
		),

		MobPos = CFrame.new(
			295, 73, -57
		)
	},

	{
		Level = 875,
		Quest = "MarineQuest3",
		QuestNum = 1,
		Mob = "Marine Lieutenant",

		QuestPos = CFrame.new(
			-2440, 72, -3216
		),

		MobPos = CFrame.new(
			-2821, 76, -3070
		)
	},

	{
		Level = 900,
		Quest = "MarineQuest3",
		QuestNum = 2,
		Mob = "Marine Captain",

		QuestPos = CFrame.new(
			-2440, 72, -3216
		),

		MobPos = CFrame.new(
			-1861, 80, -3255
		)
	},

	{
		Level = 950,
		Quest = "ZombieQuest",
		QuestNum = 1,
		Mob = "Zombie",

		QuestPos = CFrame.new(
			-5497, 48, -795
		),

		MobPos = CFrame.new(
			-5736, 126, -728
		)
	},

	{
		Level = 975,
		Quest = "ZombieQuest",
		QuestNum = 2,
		Mob = "Vampire",

		QuestPos = CFrame.new(
			-5497, 48, -795
		),

		MobPos = CFrame.new(
			-6033, 7, -1317
		)
	},

	{
		Level = 1000,
		Quest = "SnowMountainQuest",
		QuestNum = 1,
		Mob = "Snow Trooper",

		QuestPos = CFrame.new(
			604, 401, -5371
		),

		MobPos = CFrame.new(
			535, 432, -5485
		)
	},

	{
		Level = 1050,
		Quest = "SnowMountainQuest",
		QuestNum = 2,
		Mob = "Winter Warrior",

		QuestPos = CFrame.new(
			604, 401, -5371
		),

		MobPos = CFrame.new(
			1235, 456, -5175
		)
	},

	{
		Level = 1100,
		Quest = "IceSideQuest",
		QuestNum = 1,
		Mob = "Lab Subordinate",

		QuestPos = CFrame.new(
			-6064, 15, -4903
		),

		MobPos = CFrame.new(
			-5720, 63, -4785
		)
	},

	{
		Level = 1125,
		Quest = "IceSideQuest",
		QuestNum = 2,
		Mob = "Horned Warrior",

		QuestPos = CFrame.new(
			-6064, 15, -4903
		),

		MobPos = CFrame.new(
			-6341, 16, -5723
		)
	},

	{
		Level = 1175,
		Quest = "FireSideQuest",
		QuestNum = 1,
		Mob = "Magma Ninja",

		QuestPos = CFrame.new(
			-5428, 15, -5299
		),

		MobPos = CFrame.new(
			-5449, 77, -5808
		)
	},

	{
		Level = 1200,
		Quest = "FireSideQuest",
		QuestNum = 2,
		Mob = "Lava Pirate",

		QuestPos = CFrame.new(
			-5428, 15, -5299
		),

		MobPos = CFrame.new(
			-5213, 49, -4701
		)
	},

	{
		Level = 1250,
		Quest = "ShipQuest1",
		QuestNum = 1,
		Mob = "Ship Deckhand",

		QuestPos = CFrame.new(
			1040, 125, 32911
		),

		MobPos = CFrame.new(
			921, 126, 33088
		)
	},

	{
		Level = 1275,
		Quest = "ShipQuest1",
		QuestNum = 2,
		Mob = "Ship Engineer",

		QuestPos = CFrame.new(
			1040, 125, 32911
		),

		MobPos = CFrame.new(
			886, 40, 32801
		)
	},

	{
		Level = 1300,
		Quest = "ShipQuest2",
		QuestNum = 1,
		Mob = "Ship Steward",

		QuestPos = CFrame.new(
			971, 125, 33246
		),

		MobPos = CFrame.new(
			944, 130, 33444
		)
	},

	{
		Level = 1325,
		Quest = "ShipQuest2",
		QuestNum = 2,
		Mob = "Ship Officer",

		QuestPos = CFrame.new(
			971, 125, 33246
		),

		MobPos = CFrame.new(
			-14, 181, 33334
		)
	},

	{
		Level = 1350,
		Quest = "FrostQuest",
		QuestNum = 1,
		Mob = "Arctic Warrior",

		QuestPos = CFrame.new(
			5668, 27, -6486
		),

		MobPos = CFrame.new(
			5966, 63, -6179
		)
	},

	{
		Level = 1375,
		Quest = "FrostQuest",
		QuestNum = 2,
		Mob = "Snow Lurker",

		QuestPos = CFrame.new(
			5668, 27, -6486
		),

		MobPos = CFrame.new(
			5407, 69, -6881
		)
	},

	{
		Level = 1425,
		Quest = "ForgottenQuest",
		QuestNum = 1,
		Mob = "Sea Soldier",

		QuestPos = CFrame.new(
			-3054, 236, -10143
		),

		MobPos = CFrame.new(
			-3028, 65, -9775
		)
	},

	{
		Level = 1450,
		Quest = "ForgottenQuest",
		QuestNum = 2,
		Mob = "Water Fighter",

		QuestPos = CFrame.new(
			-3054, 236, -10143
		),

		MobPos = CFrame.new(
			-3262, 298, -10552
		)
	},
}

--==================================================
-- SEA 3
--==================================================

Quests[3] = {

	{
		Level = 1500,
		Quest = "PiratePortQuest",
		QuestNum = 1,
		Mob = "Pirate Millionaire",

		QuestPos = CFrame.new(
			-290, 44, 5580
		),

		MobPos = CFrame.new(
			-373, 75, 5550
		)
	},

	{
		Level = 1525,
		Quest = "PiratePortQuest",
		QuestNum = 2,
		Mob = "Pistol Billionaire",

		QuestPos = CFrame.new(
			-290, 44, 5580
		),

		MobPos = CFrame.new(
			-470, 74, 5900
		)
	},

	{
		Level = 1575,
		Quest = "DragonCrewQuest",
		QuestNum = 1,
		Mob = "Dragon Crew Warrior",

		QuestPos = CFrame.new(
			6750, 127, -711
		),

		MobPos = CFrame.new(
			6709, 52, -1139
		)
	},

	{
		Level = 1600,
		Quest = "DragonCrewQuest",
		QuestNum = 2,
		Mob = "Dragon Crew Archer",

		QuestPos = CFrame.new(
			6750, 127, -711
		),

		MobPos = CFrame.new(
			6669, 481, 329
		)
	},

	{
		Level = 1625,
		Quest = "VenomCrewQuest",
		QuestNum = 1,
		Mob = "Hydra Enforcer",

		QuestPos = CFrame.new(
			5206, 1004, 748
		),

		MobPos = CFrame.new(
			4547, 1003, 334
		)
	},

	{
		Level = 1650,
		Quest = "VenomCrewQuest",
		QuestNum = 2,
		Mob = "Venomous Assailant",

		QuestPos = CFrame.new(
			5206, 1004, 748
		),

		MobPos = CFrame.new(
			4674, 1003, 777
		)
	},

	{
		Level = 1700,
		Quest = "MarineTreeIsland",
		QuestNum = 1,
		Mob = "Marine Commodore",

		QuestPos = CFrame.new(
			2180, 29, -6740
		),

		MobPos = CFrame.new(
			2198, 129, -7109
		)
	},

	{
		Level = 1725,
		Quest = "MarineTreeIsland",
		QuestNum = 2,
		Mob = "Marine Rear Admiral",

		QuestPos = CFrame.new(
			2180, 29, -6740
		),

		MobPos = CFrame.new(
			3294, 385, -7049
		)
	},

	{
		Level = 1775,
		Quest = "DeepForestIsland3",
		QuestNum = 1,
		Mob = "Fishman Raider",

		QuestPos = CFrame.new(
			-10583, 332, -8758
		),

		MobPos = CFrame.new(
			-10553, 521, -8177
		)
	},

	{
		Level = 1800,
		Quest = "DeepForestIsland3",
		QuestNum = 2,
		Mob = "Fishman Captain",

		QuestPos = CFrame.new(
			-10583, 332, -8758
		),

		MobPos = CFrame.new(
			-10993, 352, -9002
		)
	},

	{
		Level = 1825,
		Quest = "DeepForestIsland",
		QuestNum = 1,
		Mob = "Forest Pirate",

		QuestPos = CFrame.new(
			-13233, 332, -7625
		),

		MobPos = CFrame.new(
			-13270, 404, -7772
		)
	},

	{
		Level = 1850,
		Quest = "DeepForestIsland",
		QuestNum = 2,
		Mob = "Mythological Pirate",

		QuestPos = CFrame.new(
			-13233, 332, -7625
		),

		MobPos = CFrame.new(
			-13545, 470, -6917
		)
	},

	{
		Level = 1900,
		Quest = "DeepForestIsland2",
		QuestNum = 1,
		Mob = "Jungle Pirate",

		QuestPos = CFrame.new(
			-12682, 391, -9902
		),

		MobPos = CFrame.new(
			-12267, 460, -10277
		)
	},

	{
		Level = 1925,
		Quest = "DeepForestIsland2",
		QuestNum = 2,
		Mob = "Musketeer Pirate",

		QuestPos = CFrame.new(
			-12682, 391, -9902
		),

		MobPos = CFrame.new(
			-13291, 520, -9905
		)
	},

	{
		Level = 1975,
		Quest = "HauntedQuest1",
		QuestNum = 1,
		Mob = "Reborn Skeleton",

		QuestPos = CFrame.new(
			-9481, 142, 5566
		),

		MobPos = CFrame.new(
			-8762, 183, 6168
		)
	},

	{
		Level = 2000,
		Quest = "HauntedQuest1",
		QuestNum = 2,
		Mob = "Living Zombie",

		QuestPos = CFrame.new(
			-9481, 142, 5566
		),

		MobPos = CFrame.new(
			-10144, 140, 5932
		)
	},

	{
		Level = 2025,
		Quest = "HauntedQuest2",
		QuestNum = 1,
		Mob = "Demonic Soul",

		QuestPos = CFrame.new(
			-9516, 172, 6079
		),

		MobPos = CFrame.new(
			-9507, 172, 6158
		)
	},

	{
		Level = 2050,
		Quest = "HauntedQuest2",
		QuestNum = 2,
		Mob = "Posessed Mummy",

		QuestPos = CFrame.new(
			-9516, 172, 6079
		),

		MobPos = CFrame.new(
			-9585, 6, 6200
		)
	},

	{
		Level = 2075,
		Quest = "NutsIslandQuest",
		QuestNum = 1,
		Mob = "Peanut Scout",

		QuestPos = CFrame.new(
			-2103, 38, -10192
		),

		MobPos = CFrame.new(
			-2150, 122, -10358
		)
	},

	{
		Level = 2100,
		Quest = "NutsIslandQuest",
		QuestNum = 2,
		Mob = "Peanut President",

		QuestPos = CFrame.new(
			-2103, 38, -10192
		),

		MobPos = CFrame.new(
			-2150, 122, -10500
		)
	},

	{
		Level = 2125,
		Quest = "IceCreamIslandQuest",
		QuestNum = 1,
		Mob = "Ice Cream Chef",

		QuestPos = CFrame.new(
			-820, 66, -10966
		),

		MobPos = CFrame.new(
			-872, 66, -10918
		)
	},

	{
		Level = 2150,
		Quest = "IceCreamIslandQuest",
		QuestNum = 2,
		Mob = "Ice Cream Commander",

		QuestPos = CFrame.new(
			-820, 66, -10966
		),

		MobPos = CFrame.new(
			-620, 126, -11200
		)
	},

	{
		Level = 2200,
		Quest = "CakeQuest1",
		QuestNum = 1,
		Mob = "Cookie Crafter",

		QuestPos = CFrame.new(
			-2022, 37, -12031
		),

		MobPos = CFrame.new(
			-2322, 37, -12217
		)
	},

	{
		Level = 2225,
		Quest = "CakeQuest1",
		QuestNum = 2,
		Mob = "Cake Guard",

		QuestPos = CFrame.new(
			-2022, 37, -12031
		),

		MobPos = CFrame.new(
			-1418, 37, -12256
		)
	},

	{
		Level = 2250,
		Quest = "CakeQuest2",
		QuestNum = 1,
		Mob = "Baking Staff",

		QuestPos = CFrame.new(
			-1928, 38, -12841
		),

		MobPos = CFrame.new(
			-1980, 37, -12984
		)
	},

	{
		Level = 2275,
		Quest = "CakeQuest2",
		QuestNum = 2,
		Mob = "Head Baker",

		QuestPos = CFrame.new(
			-1928, 38, -12841
		),

		MobPos = CFrame.new(
			-2252, 52, -13033
		)
	},

	{
		Level = 2300,
		Quest = "ChocQuest1",
		QuestNum = 1,
		Mob = "Cocoa Warrior",

		QuestPos = CFrame.new(
			233, 30, -12201
		),

		MobPos = CFrame.new(
			-22, 81, -12352
		)
	},

	{
		Level = 2325,
		Quest = "ChocQuest1",
		QuestNum = 2,
		Mob = "Chocolate Bar Battler",

		QuestPos = CFrame.new(
			233, 30, -12201
		),

		MobPos = CFrame.new(
			583, 77, -12463
		)
	},

	{
		Level = 2350,
		Quest = "ChocQuest2",
		QuestNum = 1,
		Mob = "Sweet Thief",

		QuestPos = CFrame.new(
			151, 31, -12775
		),

		MobPos = CFrame.new(
			165, 76, -12601
		)
	},

	{
		Level = 2375,
		Quest = "ChocQuest2",
		QuestNum = 2,
		Mob = "Candy Rebel",

		QuestPos = CFrame.new(
			151, 31, -12775
		),

		MobPos = CFrame.new(
			135, 77, -12877
		)
	},

	{
		Level = 2400,
		Quest = "CandyQuest1",
		QuestNum = 1,
		Mob = "Candy Pirate",

		QuestPos = CFrame.new(
			-1150, 20, -14446
		),

		MobPos = CFrame.new(
			-1311, 26, -14562
		)
	},

	{
		Level = 2425,
		Quest = "CandyQuest1",
		QuestNum = 2,
		Mob = "Snow Demon",

		QuestPos = CFrame.new(
			-1150, 20, -14446
		),

		MobPos = CFrame.new(
			-880, 71, -14539
		)
	},

	{
		Level = 2450,
		Quest = "TikiQuest1",
		QuestNum = 1,
		Mob = "Isle Outlaw",

		QuestPos = CFrame.new(
			-16548, 61, -173
		),

		MobPos = CFrame.new(
			-16443, 116, -264
		)
	},

	{
		Level = 2475,
		Quest = "TikiQuest1",
		QuestNum = 2,
		Mob = "Island Boy",

		QuestPos = CFrame.new(
			-16548, 61, -173
		),

		MobPos = CFrame.new(
			-16901, 84, -193
		)
	},

	{
		Level = 2500,
		Quest = "TikiQuest2",
		QuestNum = 1,
		Mob = "Sun-kissed Warrior",

		QuestPos = CFrame.new(
			-16539, 56, 1052
		),

		MobPos = CFrame.new(
			-16321, 92, 1111
		)
	},

	{
		Level = 2525,
		Quest = "TikiQuest2",
		QuestNum = 2,
		Mob = "Isle Champion",

		QuestPos = CFrame.new(
			-16539, 56, 1052
		),

		MobPos = CFrame.new(
			-16642, 126, 1065
		)
	},

	{
		Level = 2550,
		Quest = "TikiQuest3",
		QuestNum = 1,
		Mob = "Serpent Hunter",

		QuestPos = CFrame.new(
			-16667, 105, 1574
		),

		MobPos = CFrame.new(
			-16551, 116, 1539
		)
	},

	{
		-- Por enquanto esta rota permanece
		-- ativa até o level máximo.
		-- Depois criaremos suporte específico
		-- para Submerged Island.
		
		Level = 2575,
		Quest = "TikiQuest3",
		QuestNum = 2,
		Mob = "Skull Slayer",

		QuestPos = CFrame.new(
			-16667, 105, 1574
		),

		MobPos = CFrame.new(
			-16809, 121, 1480
		)
	},
}

--==================================================
-- FUNÇÕES
--==================================================

function Quests.GetSea()
	return Quests.PlaceIds[
		game.PlaceId
	] or 0
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

	local seaData = Quests[sea]

	if not seaData then
		return nil
	end

	local selected = nil

	for _, data in ipairs(seaData) do

		if level >= data.Level then
			selected = data
		else
			break
		end

	end

	return selected
end

return Quests
