--==================================================
-- DEAL BLOX
-- MODULES / SHOP
--==================================================

local Shop = {}

function Shop.Create(
	ShopData,
	Debug
)
	local ReplicatedStorage =
		game:GetService("ReplicatedStorage")

	local Players =
		game:GetService("Players")

	local Player =
		Players.LocalPlayer

	local function Log(text)
		if Debug and Debug.Log then
			Debug.Log(text)
		else
			print("[DEAL BLOX / SHOP] " .. tostring(text))
		end
	end

	local function Warn(text)
		if Debug and Debug.Warn then
			Debug.Warn(text)
		else
			warn("[DEAL BLOX / SHOP] " .. tostring(text))
		end
	end

	local function GetCommF()
		local Remotes =
			ReplicatedStorage:
				FindFirstChild(
					"Remotes"
				)

		return
			Remotes
			and
			Remotes:
				FindFirstChild(
					"CommF_"
				)
			or
			nil
	end

	local function Invoke(...)
		local Remote =
			GetCommF()

		if not Remote then
			return false, "CommF_ não encontrada."
		end

		local args = {...}

		local success, result =
			pcall(function()
				return Remote:
					InvokeServer(
						table.unpack(
							args
						)
					)
			end)

		if not success then
			Warn(result)
			return false, result
		end

		return true, result
	end

	local function FindById(
		list,
		id
	)
		for _, item in ipairs(
			list
		) do
			if item.Id == id then
				return item
			end
		end

		return nil
	end

	local function RunCalls(
		item
	)
		if
			not item
			or
			type(item.Calls)
				~=
				"table"
		then
			return false, "Ação inválida."
		end

		local lastResult =
			nil

		for _, call in ipairs(
			item.Calls
		) do
			local success,
				result =
					Invoke(
						table.unpack(
							call
						)
					)

			if not success then
				return false, result
			end

			lastResult =
				result

			task.wait(
				0.08
			)
		end

		return true, lastResult
	end

	local function NormalizeFruitName(
		name
	)
		name =
			tostring(
				name
				or
				"Fruta"
			)

		name =
			name:gsub(
				"%-",
				" "
			)

		return name
	end

	local function ParseFruitStock(
		raw
	)
		local result = {}

		if type(raw) ~= "table" then
			return result
		end

		for _, fruit in pairs(
			raw
		) do
			if type(fruit) == "table" then
				local onSale =
					fruit.OnSale

				if onSale == nil then
					onSale =
						fruit.Stock
				end

				if onSale == true then
					local name =
						fruit.Name
						or
						fruit.Fruit
						or
						fruit.DisplayName
						or
						"Fruta"

					table.insert(
						result,
						{
							Name =
								NormalizeFruitName(
									name
								),

							RawName =
								tostring(
									fruit.Name
									or
									fruit.Fruit
									or
									fruit.DisplayName
									or
									name
								),

							Price =
								tonumber(
									fruit.Price
									or
									fruit.Cost
									or
									0
								)
								or
								0,

							Robux =
								tonumber(
									fruit.PriceRobux
									or
									fruit.Robux
									or
									0
								)
								or
								0,
						}
					)
				end
			end
		end

		table.sort(
			result,
			function(a, b)
				return
					(a.Price or 0)
					<
					(b.Price or 0)
			end
		)

		return result
	end

	local API = {}

	function API:GetData()
		return ShopData
	end

	function API:GetMoney()
		local Data =
			Player:
				FindFirstChild(
					"Data"
				)

		local Beli =
			Data
			and
			(
				Data:
					FindFirstChild(
						"Beli"
					)
				or
				Data:
					FindFirstChild(
						"Money"
					)
			)

		return
			tonumber(
				Beli
				and
				Beli.Value
			)
			or
			0
	end

	function API:GetFragments()
		local Data =
			Player:
				FindFirstChild(
					"Data"
				)

		local Fragments =
			Data
			and
			Data:
				FindFirstChild(
					"Fragments"
				)

		return
			tonumber(
				Fragments
				and
				Fragments.Value
			)
			or
			0
	end

	function API:BuyAbility(
		id
	)
		local item =
			FindById(
				ShopData.Abilities,
				id
			)

		return
			RunCalls(
				item
			)
	end

	function API:BuyFightingStyle(
		id
	)
		local item =
			FindById(
				ShopData.FightingStyles,
				id
			)

		return
			RunCalls(
				item
			)
	end

	function API:GetFruitStock(
		advanced
	)
		local success, raw =
			Invoke(
				"GetFruits",
				advanced
					==
					true
			)

		if not success then
			return false, raw
		end

		return
			true,
			ParseFruitStock(
				raw
			)
	end

	function API:BuyFruit(
		fruitName
	)
		return
			Invoke(
				"PurchaseRawFruit",
				fruitName
			)
	end

	Log(
		"Shop Engine carregado."
	)

	return API
end

return Shop
