--==================================================
-- DEAL BLOX
-- UI / SHOP
--==================================================

local ShopUI = {}

function ShopUI.Create(
	App,
	Config,
	Debug,
	ShopEngine
)
	local Page =
		App:GetPage(
			"Loja"
		)

	if not Page then
		Debug.Warn(
			"Aba Loja não encontrada."
		)

		return
	end

	for _, object in ipairs(
		Page:GetChildren()
	) do
		object:Destroy()
	end

	local Colors =
		Config.Colors
		or
		{}

	local C = {
		Background =
			Colors.Background
			or
			Color3.fromRGB(8, 12, 22),

		Panel =
			Colors.Panel2
			or
			Color3.fromRGB(20, 27, 41),

		Text =
			Colors.Text
			or
			Color3.fromRGB(245, 247, 255),

		Sub =
			Colors.SubText
			or
			Color3.fromRGB(155, 166, 185),

		Blue =
			Colors.Blue
			or
			Color3.fromRGB(30, 90, 190),

		Neon =
			Colors.BlueNeon
			or
			Color3.fromRGB(0, 180, 255),

		Green =
			Color3.fromRGB(28, 135, 82),

		Red =
			Color3.fromRGB(170, 45, 65),
	}

	local function Corner(
		parent,
		radius
	)
		local x =
			Instance.new(
				"UICorner"
			)

		x.CornerRadius =
			UDim.new(
				0,
				radius
				or
				9
			)

		x.Parent =
			parent
	end

	local function Stroke(
		parent,
		color,
		transparency
	)
		local x =
			Instance.new(
				"UIStroke"
			)

		x.Color =
			color
			or
			C.Neon

		x.Thickness =
			1.2

		x.Transparency =
			transparency
			or
			0.25

		x.Parent =
			parent
	end

	local function Label(
		parent,
		text,
		position,
		size,
		textSize,
		font,
		color
	)
		local x =
			Instance.new(
				"TextLabel"
			)

		x.Parent =
			parent

		x.Position =
			position

		x.Size =
			size

		x.BackgroundTransparency =
			1

		x.Text =
			text
			or
			""

		x.TextColor3 =
			color
			or
			C.Text

		x.TextSize =
			textSize
			or
			12

		x.Font =
			font
			or
			Enum.Font.Gotham

		x.TextXAlignment =
			Enum.TextXAlignment.Left

		x.TextYAlignment =
			Enum.TextYAlignment.Center

		x.TextWrapped =
			true

		return x
	end

	local Root =
		Instance.new(
			"Frame"
		)

	Root.Parent =
		Page

	Root.Size =
		UDim2.fromScale(
			1,
			1
		)

	Root.BackgroundTransparency =
		1

	--==================================================
	-- HEADER
	--==================================================

	Label(
		Root,
		"LOJA",
		UDim2.fromOffset(
			18,
			12
		),
		UDim2.new(
			1,
			-36,
			0,
			30
		),
		21,
		Enum.Font.GothamBold,
		C.Text
	)

	Label(
		Root,
		"Compre habilidades, estilos e consulte lojas de frutas sem viajar até o NPC.",
		UDim2.fromOffset(
			18,
			43
		),
		UDim2.new(
			1,
			-36,
			0,
			36
		),
		11,
		Enum.Font.Gotham,
		C.Sub
	)

	--==================================================
	-- MONEY
	--==================================================

	local Wallet =
		Instance.new(
			"Frame"
		)

	Wallet.Parent =
		Root

	Wallet.Position =
		UDim2.new(
			1,
			-220,
			0,
			12
		)

	Wallet.Size =
		UDim2.fromOffset(
			202,
			55
		)

	Wallet.BackgroundColor3 =
		C.Panel

	Wallet.BackgroundTransparency =
		0.05

	Wallet.BorderSizePixel =
		0

	Corner(
		Wallet,
		10
	)

	Stroke(
		Wallet,
		C.Neon,
		0.35
	)

	local WalletLabel =
		Label(
			Wallet,
			"Carregando...",
			UDim2.fromOffset(
				12,
				5
			),
			UDim2.new(
				1,
				-24,
				1,
				-10
			),
			11,
			Enum.Font.GothamSemibold,
			C.Text
		)

	--==================================================
	-- NAV
	--==================================================

	local Nav =
		Instance.new(
			"Frame"
		)

	Nav.Parent =
		Root

	Nav.Position =
		UDim2.fromOffset(
			18,
			88
		)

	Nav.Size =
		UDim2.new(
			1,
			-36,
			0,
			44
		)

	Nav.BackgroundTransparency =
		1

	local NavList =
		Instance.new(
			"UIListLayout"
		)

	NavList.Parent =
		Nav

	NavList.FillDirection =
		Enum.FillDirection.Horizontal

	NavList.Padding =
		UDim.new(
			0,
			8
		)

	local Content =
		Instance.new(
			"Frame"
		)

	Content.Parent =
		Root

	Content.Position =
		UDim2.fromOffset(
			18,
			140
		)

	Content.Size =
		UDim2.new(
			1,
			-36,
			1,
			-154
		)

	Content.BackgroundTransparency =
		1

	Content.ClipsDescendants =
		true

	local Sections = {}

	local function CreateSection(
		name
	)
		local frame =
			Instance.new(
				"ScrollingFrame"
			)

		frame.Name =
			name

		frame.Parent =
			Content

		frame.Size =
			UDim2.fromScale(
				1,
				1
			)

		frame.BackgroundTransparency =
			1

		frame.BorderSizePixel =
			0

		frame.ScrollBarThickness =
			4

		frame.ScrollBarImageColor3 =
			C.Neon

		frame.AutomaticCanvasSize =
			Enum.AutomaticSize.Y

		frame.CanvasSize =
			UDim2.new()

		frame.Visible =
			false

		local padding =
			Instance.new(
				"UIPadding"
			)

		padding.Parent =
			frame

		padding.PaddingBottom =
			UDim.new(
				0,
				14
			)

		local list =
			Instance.new(
				"UIListLayout"
			)

		list.Parent =
			frame

		list.Padding =
			UDim.new(
				0,
				10
			)

		list.SortOrder =
			Enum.SortOrder.LayoutOrder

		Sections[name] =
			frame

		return frame
	end

	local AbilitiesSection =
		CreateSection(
			"Habilidades"
		)

	local StylesSection =
		CreateSection(
			"Estilos"
		)

	local FruitsSection =
		CreateSection(
			"Frutas"
		)

	local Current =
		nil

	local NavButtons =
		{}

	local function Select(
		name
	)
		Current =
			name

		for sectionName, section in pairs(
			Sections
		) do
			section.Visible =
				sectionName
				==
				name
		end

		for buttonName, button in pairs(
			NavButtons
		) do
			local active =
				buttonName
				==
				name

			button.BackgroundColor3 =
				active
					and
					C.Blue
					or
					C.Panel

			button.TextColor3 =
				active
					and
					C.Text
					or
					C.Sub
		end
	end

	local function NavButton(
		name
	)
		local button =
			Instance.new(
				"TextButton"
			)

		button.Parent =
			Nav

		button.Size =
			UDim2.new(
				0,
				135,
				1,
				0
			)

		button.BackgroundColor3 =
			C.Panel

		button.BorderSizePixel =
			0

		button.Text =
			name

		button.TextColor3 =
			C.Sub

		button.TextSize =
			11

		button.Font =
			Enum.Font.GothamBold

		button.AutoButtonColor =
			false

		Corner(
			button,
			9
		)

		Stroke(
			button,
			C.Neon,
			0.45
		)

		button.Activated:
			Connect(function()
				Select(
					name
				)
			end)

		NavButtons[name] =
			button
	end

	NavButton(
		"Habilidades"
	)

	NavButton(
		"Estilos"
	)

	NavButton(
		"Frutas"
	)

	--==================================================
	-- TOAST
	--==================================================

	local Toast =
		Instance.new(
			"TextLabel"
		)

	Toast.Parent =
		Root

	Toast.AnchorPoint =
		Vector2.new(
			0.5,
			1
		)

	Toast.Position =
		UDim2.new(
			0.5,
			0,
			1,
			-12
		)

	Toast.Size =
		UDim2.new(
			0.72,
			0,
			0,
			42
		)

	Toast.BackgroundColor3 =
		C.Panel

	Toast.BackgroundTransparency =
		0.03

	Toast.BorderSizePixel =
		0

	Toast.Text =
		""

	Toast.TextColor3 =
		C.Text

	Toast.TextSize =
		11

	Toast.Font =
		Enum.Font.GothamSemibold

	Toast.TextWrapped =
		true

	Toast.Visible =
		false

	Toast.ZIndex =
		60

	Corner(
		Toast,
		10
	)

	local ToastVersion =
		0

	local function ShowToast(
		text,
		ok
	)
		ToastVersion +=
			1

		local version =
			ToastVersion

		Toast.Text =
			tostring(
				text
			)

		Toast.BackgroundColor3 =
			ok
				and
				C.Green
				or
				C.Red

		Toast.Visible =
			true

		task.delay(
			3.5,
			function()
				if
					ToastVersion
					==
					version
				then
					Toast.Visible =
						false
				end
			end
		)
	end

	--==================================================
	-- ACTION CARD
	--==================================================

	local function ActionCard(
		parent,
		name,
		subtitle,
		description,
		buttonText,
		callback
	)
		local Card =
			Instance.new(
				"Frame"
			)

		Card.Parent =
			parent

		Card.Size =
			UDim2.new(
				1,
				-4,
				0,
				92
			)

		Card.BackgroundColor3 =
			C.Panel

		Card.BackgroundTransparency =
			0.04

		Card.BorderSizePixel =
			0

		Corner(
			Card,
			11
		)

		Stroke(
			Card,
			C.Neon,
			0.52
		)

		Label(
			Card,
			name,
			UDim2.fromOffset(
				15,
				11
			),
			UDim2.new(
				1,
				-155,
				0,
				23
			),
			14,
			Enum.Font.GothamBold,
			C.Text
		)

		if
			subtitle
			and
			subtitle
				~=
				""
		then
			Label(
				Card,
				subtitle,
				UDim2.fromOffset(
					15,
					34
				),
				UDim2.new(
					1,
					-155,
					0,
					18
				),
				10,
				Enum.Font.GothamSemibold,
				C.Neon
			)
		end

		Label(
			Card,
			description,
			UDim2.fromOffset(
				15,
				54
			),
			UDim2.new(
				1,
				-155,
				0,
				27
			),
			10,
			Enum.Font.Gotham,
			C.Sub
		)

		local Button =
			Instance.new(
				"TextButton"
			)

		Button.Parent =
			Card

		Button.AnchorPoint =
			Vector2.new(
				1,
			0.5
		)

		Button.Position =
			UDim2.new(
				1,
				-14,
				0.5,
				0
			)

		Button.Size =
			UDim2.fromOffset(
				122,
				42
			)

		Button.BackgroundColor3 =
			C.Blue

		Button.BorderSizePixel =
			0

		Button.Text =
			buttonText

		Button.TextColor3 =
			C.Text

		Button.TextSize =
			11

		Button.Font =
			Enum.Font.GothamBold

		Corner(
			Button,
			9
		)

		Button.Activated:
			Connect(function()
				Button.Text =
					"AGUARDE..."

				Button.Active =
					false

				local success,
					result =
						pcall(
							callback
						)

				if
					success
					and
					type(result)
						==
						"table"
				then
					success =
						result[1]
				end

				task.wait(
					0.15
				)

				Button.Text =
					buttonText

				Button.Active =
					true
			end)

		return Card
	end

	--==================================================
	-- HABILIDADES
	--==================================================

	local Data =
		ShopEngine:GetData()

	for _, item in ipairs(
		Data.Abilities
	) do
		ActionCard(
			AbilitiesSection,
			item.Name,
			item.Subtitle,
			item.Description,
			"COMPRAR",
			function()
				local ok,
					response =
						ShopEngine:
							BuyAbility(
								item.Id
							)

				if ok then
					ShowToast(
						item.Name
						..
						": solicitação enviada.",
						true
					)
				else
					ShowToast(
						item.Name
						..
						": "
						..
						tostring(
							response
						),
						false
					)
				end

				return {
					ok,
					response
				}
			end
		)
	end

	--==================================================
	-- ESTILOS
	--==================================================

	for _, item in ipairs(
		Data.FightingStyles
	) do
		ActionCard(
			StylesSection,
			item.Name,
			"",
			item.Description,
			"APRENDER",
			function()
				local ok,
					response =
						ShopEngine:
							BuyFightingStyle(
								item.Id
							)

				if ok then
					ShowToast(
						item.Name
						..
						": solicitação enviada.",
						true
					)
				else
					ShowToast(
						item.Name
						..
						": "
						..
						tostring(
							response
						),
						false
					)
				end

				return {
					ok,
					response
				}
			end
		)
	end

	--==================================================
	-- FRUIT STORE
	--==================================================

	local function FormatNumber(
		number
	)
		number =
			math.floor(
				tonumber(number)
				or
				0
			)

		local text =
			tostring(
				number
			)

		local changed =
			0

		repeat
			text,
				changed =
					text:gsub(
						"^(-?%d+)(%d%d%d)",
						"%1.%2"
					)
		until
			changed
			==
			0

		return text
	end

	local function FruitStoreCard(
		storeData
	)
		local Card =
			Instance.new(
				"Frame"
			)

		Card.Parent =
			FruitsSection

		Card.Size =
			UDim2.new(
				1,
				-4,
				0,
				318
			)

		Card.BackgroundColor3 =
			C.Panel

		Card.BackgroundTransparency =
			0.04

		Card.BorderSizePixel =
			0

		Corner(
			Card,
			12
		)

		Stroke(
			Card,
			storeData.Advanced
				and
				Color3.fromRGB(
					180,
					80,
					255
				)
				or
				C.Neon,
			0.35
		)

		Label(
			Card,
			storeData.Name,
			UDim2.fromOffset(
				15,
				10
			),
			UDim2.new(
				1,
				-150,
				0,
				25
			),
			15,
			Enum.Font.GothamBold,
			C.Text
		)

		Label(
			Card,
			storeData.Subtitle,
			UDim2.fromOffset(
				15,
				34
			),
			UDim2.new(
				1,
				-150,
				0,
				20
			),
			10,
			Enum.Font.GothamSemibold,
			storeData.Advanced
				and
				Color3.fromRGB(
					200,
					120,
					255
				)
				or
				C.Neon
		)

		Label(
			Card,
			storeData.Description,
			UDim2.fromOffset(
				15,
				55
			),
			UDim2.new(
				1,
				-30,
				0,
				30
			),
			10,
			Enum.Font.Gotham,
			C.Sub
		)

		local Refresh =
			Instance.new(
				"TextButton"
			)

		Refresh.Parent =
			Card

		Refresh.Position =
			UDim2.new(
				1,
				-132,
				0,
				12
			)

		Refresh.Size =
			UDim2.fromOffset(
				116,
				38
			)

		Refresh.BackgroundColor3 =
			C.Blue

		Refresh.BorderSizePixel =
			0

		Refresh.Text =
			"ATUALIZAR"

		Refresh.TextColor3 =
			C.Text

		Refresh.TextSize =
			10

		Refresh.Font =
			Enum.Font.GothamBold

		Corner(
			Refresh,
			8
		)

		local Stock =
			Instance.new(
				"ScrollingFrame"
			)

		Stock.Parent =
			Card

		Stock.Position =
			UDim2.fromOffset(
				14,
				94
			)

		Stock.Size =
			UDim2.new(
				1,
				-28,
				0,
				208
			)

		Stock.BackgroundColor3 =
			C.Background

		Stock.BackgroundTransparency =
			0.22

		Stock.BorderSizePixel =
			0

		Stock.ScrollBarThickness =
			3

		Stock.ScrollBarImageColor3 =
			C.Neon

		Stock.AutomaticCanvasSize =
			Enum.AutomaticSize.Y

		Stock.CanvasSize =
			UDim2.new()

		Corner(
			Stock,
			9
		)

		local Padding =
			Instance.new(
				"UIPadding"
			)

		Padding.Parent =
			Stock

		Padding.PaddingTop =
			UDim.new(
				0,
				8
			)

		Padding.PaddingBottom =
			UDim.new(
				0,
				8
			)

		Padding.PaddingLeft =
			UDim.new(
				0,
				8
			)

		Padding.PaddingRight =
			UDim.new(
				0,
				8
			)

		local List =
			Instance.new(
				"UIListLayout"
			)

		List.Parent =
			Stock

		List.Padding =
			UDim.new(
				0,
				6
			)

		local function ClearStock()
			for _, child in ipairs(
				Stock:GetChildren()
			) do
				if
					child:IsA(
						"GuiObject"
					)
				then
					child:
						Destroy()
				end
			end
		end

		local function FruitRow(
			fruit
		)
			local Row =
				Instance.new(
					"Frame"
				)

			Row.Parent =
				Stock

			Row.Size =
				UDim2.new(
					1,
					0,
					0,
					48
				)

			Row.BackgroundColor3 =
				C.Panel

			Row.BackgroundTransparency =
				0.12

			Row.BorderSizePixel =
				0

			Corner(
				Row,
				8
			)

			Label(
				Row,
				fruit.Name,
				UDim2.fromOffset(
					10,
					5
				),
				UDim2.new(
					1,
					-150,
					0,
					20
				),
				11,
				Enum.Font.GothamBold,
				C.Text
			)

			Label(
				Row,
				"$"
				..
				FormatNumber(
					fruit.Price
				),
				UDim2.fromOffset(
					10,
					25
				),
				UDim2.new(
					1,
					-150,
					0,
					17
				),
				9,
				Enum.Font.Gotham,
				C.Sub
			)

			local Buy =
				Instance.new(
					"TextButton"
				)

			Buy.Parent =
				Row

			Buy.AnchorPoint =
				Vector2.new(
					1,
					0.5
				)

			Buy.Position =
				UDim2.new(
					1,
					-7,
					0.5,
					0
				)

			Buy.Size =
				UDim2.fromOffset(
					105,
					34
				)

			Buy.BackgroundColor3 =
				C.Green

			Buy.BorderSizePixel =
				0

			Buy.Text =
				"COMPRAR"

			Buy.TextColor3 =
				C.Text

			Buy.TextSize =
				10

			Buy.Font =
				Enum.Font.GothamBold

			Corner(
				Buy,
				7
			)

			Buy.Activated:
				Connect(function()
					local ok,
						response =
							ShopEngine:
								BuyFruit(
									fruit.RawName
								)

					if ok then
						ShowToast(
							fruit.Name
							..
							": compra solicitada.",
							true
						)
					else
						ShowToast(
							"Erro: "
							..
							tostring(
								response
							),
							false
						)
					end
				end)
		end

		local function LoadStock()
			Refresh.Text =
				"CARREGANDO..."

			Refresh.Active =
				false

			ClearStock()

			local Loading =
				Label(
					Stock,
					"Consultando estoque...",
					UDim2.fromOffset(
						4,
						0
					),
					UDim2.new(
						1,
						-8,
						0,
						34
					),
					10,
					Enum.Font.Gotham,
					C.Sub
				)

			local ok,
				result =
					ShopEngine:
						GetFruitStock(
							storeData.Advanced
						)

			if Loading then
				Loading:
					Destroy()
			end

			if
				not ok
			then
				Label(
					Stock,
					"Não foi possível consultar esta loja.\n"
					..
					tostring(
						result
					),
					UDim2.fromOffset(
						4,
						0
					),
					UDim2.new(
						1,
						-8,
						0,
						55
					),
					10,
					Enum.Font.Gotham,
					C.Sub
				)

				ShowToast(
					"Falha ao atualizar "
					..
					storeData.Name
					..
					".",
					false
				)
			elseif
				#result
				==
				0
			then
				Label(
					Stock,
					"Nenhuma fruta disponível foi detectada agora.",
					UDim2.fromOffset(
						4,
						0
					),
					UDim2.new(
						1,
						-8,
						0,
						44
					),
					10,
					Enum.Font.Gotham,
					C.Sub
				)
			else
				for _, fruit in ipairs(
					result
				) do
					FruitRow(
						fruit
					)
				end
			end

			Refresh.Text =
				"ATUALIZAR"

			Refresh.Active =
				true
		end

		Refresh.Activated:
			Connect(
				LoadStock
			)

		task.spawn(
			LoadStock
		)
	end

	for _, store in ipairs(
		Data.FruitStores
	) do
		FruitStoreCard(
			store
		)
	end

	--==================================================
	-- WALLET LOOP
	--==================================================

	task.spawn(function()
		while
			Root.Parent
		do
			WalletLabel.Text =
				"$"
				..
				FormatNumber(
					ShopEngine:
						GetMoney()
				)
				..
				"\n"
				..
				"Fragments: "
				..
				FormatNumber(
					ShopEngine:
						GetFragments()
				)

			task.wait(
				0.5
			)
		end
	end)

	Select(
		"Habilidades"
	)

	Debug.Log(
		"✅ Aba Loja criada."
	)

	return {
		Page = Page,
		Root = Root,
	}
end

return ShopUI
