--==================================================
-- DEAL BLOX
-- MODULES / ESP
-- Ilhas / Frutas / Berries
--==================================================

local ESP = {}

function ESP.Create(Debug)
	local Players = game:GetService("Players")
	local CollectionService = game:GetService("CollectionService")

	local Player = Players.LocalPlayer
	local Environment = getgenv and getgenv() or _G

	Environment.DealBloxESPToken =
		(Environment.DealBloxESPToken or 0) + 1

	local Token = Environment.DealBloxESPToken

	local Settings = {
		Islands = false,
		Fruits = false,
		Berries = false,
	}

	local MARKER_PREFIX = "DealBloxESP_"

	local Colors = {
		Island = Color3.fromRGB(0, 190, 255),
		Fruit = Color3.fromRGB(255, 80, 110),
		Berry = Color3.fromRGB(255, 220, 60),
	}

	local function Log(text)
		if Debug and Debug.Log then
			Debug.Log(text)
		else
			print("[DEAL BLOX / ESP] " .. tostring(text))
		end
	end

	local function GetRoot()
		local character = Player.Character
		return character and character:FindFirstChild("HumanoidRootPart")
	end

	local function GetPosition(object)
		if not object then
			return nil
		end

		if object:IsA("BasePart") then
			return object.Position
		end

		if object:IsA("Attachment") then
			return object.WorldPosition
		end

		if object:IsA("Model") then
			local ok, pivot = pcall(function()
				return object:GetPivot()
			end)
			if ok then
				return pivot.Position
			end
		end

		local part = object:FindFirstChildWhichIsA("BasePart", true)
		return part and part.Position or nil
	end

	local function GetAdornee(object)
		if not object then
			return nil
		end

		if object:IsA("BasePart") or object:IsA("Attachment") then
			return object
		end

		if object:IsA("Model") then
			return object.PrimaryPart
				or object:FindFirstChildWhichIsA("BasePart", true)
		end

		return object:FindFirstChildWhichIsA("BasePart", true)
	end

	local function DistanceFromPlayer(object)
		local root = GetRoot()
		local position = GetPosition(object)

		if not root or not position then
			return nil
		end

		return math.floor((root.Position - position).Magnitude)
	end

	local function MarkerName(kind)
		return MARKER_PREFIX .. kind
	end

	local function RemoveMarker(object, kind)
		if not object then
			return
		end

		local old = object:FindFirstChild(MarkerName(kind))
		if old then
			old:Destroy()
		end
	end

	local function CreateOrUpdateMarker(object, kind, displayName, color)
		if not object or not object.Parent then
			return
		end

		local adornee = GetAdornee(object)
		if not adornee then
			return
		end

		local marker = object:FindFirstChild(MarkerName(kind))

		if not marker then
			marker = Instance.new("BillboardGui")
			marker.Name = MarkerName(kind)
			marker.Parent = object
			marker.Adornee = adornee
			marker.AlwaysOnTop = true
			marker.LightInfluence = 0
			marker.Size = UDim2.fromOffset(230, 52)
			marker.StudsOffset = Vector3.new(0, 3, 0)
			marker.MaxDistance = 1000000

			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.Parent = marker
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.TextColor3 = color
			label.TextStrokeColor3 = Color3.new(0, 0, 0)
			label.TextStrokeTransparency = 0.25
			label.Font = Enum.Font.GothamBold
			label.TextSize = 14
			label.TextWrapped = true
		else
			marker.Adornee = adornee
		end

		local label = marker:FindFirstChild("Label")
		local distance = DistanceFromPlayer(object)

		if label then
			label.TextColor3 = color
			label.Text =
				tostring(displayName)
				.. "\n"
				.. (distance and (tostring(distance) .. " studs") or "distância ?")
		end
	end

	local function ClearKind(kind)
		for _, object in ipairs(workspace:GetDescendants()) do
			local marker = object:FindFirstChild(MarkerName(kind))
			if marker then
				marker:Destroy()
			end
		end
	end

	--==================================================
	-- ILHAS
	--==================================================

	local function UpdateIslands()
		local origin = workspace:FindFirstChild("_WorldOrigin")
		local locations = origin and origin:FindFirstChild("Locations")

		if not locations then
			return
		end

		for _, island in ipairs(locations:GetChildren()) do
			if island.Name ~= "Sea" then
				CreateOrUpdateMarker(
					island,
					"Island",
					island.Name,
					Colors.Island
				)
			end
		end
	end

	--==================================================
	-- FRUTAS
	--==================================================

	local function IsFruit(object)
		if not object then
			return false
		end

		if object:IsA("Tool") and object:FindFirstChild("Handle") then
			return string.find(string.lower(object.Name), "fruit", 1, true) ~= nil
		end

		return false
	end

	local function FruitName(tool)
		local name = tostring(tool.Name)
		name = name:gsub("%s*Fruit%s*$", "")
		name = name:gsub("%s*%[Fruit%]%s*$", "")

		if name == "" then
			name = tool.Name
		end

		return "Fruta: " .. name
	end

	local function UpdateFruits()
		for _, object in ipairs(workspace:GetChildren()) do
			if IsFruit(object) then
				CreateOrUpdateMarker(
					object,
					"Fruit",
					FruitName(object),
					Colors.Fruit
				)
			end
		end
	end

	--==================================================
	-- BERRIES
	--==================================================

	local function GetBerryNames(bush)
		local names = {}

		for attributeName, value in pairs(bush:GetAttributes()) do
			local berryName = nil

			if type(value) == "string" and value ~= "" then
				berryName = value
			elseif value == true then
				berryName = attributeName
			end

			if berryName then
				table.insert(names, tostring(berryName))
			end
		end

		return names
	end

	local function UpdateBerries()
		local bushes = CollectionService:GetTagged("BerryBush")

		for _, bush in ipairs(bushes) do
			if bush and bush.Parent then
				local names = GetBerryNames(bush)

				if #names > 0 then
					local display =
						"Berry: "
						.. table.concat(names, " / ")

					CreateOrUpdateMarker(
						bush.Parent,
						"Berry",
						display,
						Colors.Berry
					)
				else
					RemoveMarker(bush.Parent, "Berry")
				end
			end
		end
	end

	--==================================================
	-- API
	--==================================================

	local API = {}

	function API:SetIslands(value)
		Settings.Islands = value == true

		if not Settings.Islands then
			ClearKind("Island")
		end
	end

	function API:SetFruits(value)
		Settings.Fruits = value == true

		if not Settings.Fruits then
			ClearKind("Fruit")
		end
	end

	function API:SetBerries(value)
		Settings.Berries = value == true

		if not Settings.Berries then
			ClearKind("Berry")
		end
	end

	function API:GetIslands()
		return Settings.Islands
	end

	function API:GetFruits()
		return Settings.Fruits
	end

	function API:GetBerries()
		return Settings.Berries
	end

	function API:DisableAll()
		Settings.Islands = false
		Settings.Fruits = false
		Settings.Berries = false

		ClearKind("Island")
		ClearKind("Fruit")
		ClearKind("Berry")
	end

	--==================================================
	-- LOOP
	--==================================================

	task.spawn(function()
		while Environment.DealBloxESPToken == Token do
			if Settings.Islands then
				pcall(UpdateIslands)
			end

			if Settings.Fruits then
				pcall(UpdateFruits)
			end

			if Settings.Berries then
				pcall(UpdateBerries)
			end

			task.wait(0.35)
		end
	end)

	Log("ESP Engine carregado.")

	return API
end

return ESP
