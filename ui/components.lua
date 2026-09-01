--==================================================
-- DEAL BLOX
-- UI / COMPONENTS
--==================================================

local Components = {}

--==================================================
-- CANTO
--==================================================

function Components.Corner(parent, radius)

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			radius or 8
		)

	corner.Parent =
		parent

	return corner
end

--==================================================
-- BORDA
--==================================================

function Components.Stroke(
	parent,
	color,
	thickness,
	transparency
)

	local stroke =
		Instance.new("UIStroke")

	stroke.Color =
		color
		or
		Color3.fromRGB(
			0,
			180,
			255
		)

	stroke.Thickness =
		thickness or 1

	stroke.Transparency =
		transparency or 0

	stroke.Parent =
		parent

	return stroke
end

--==================================================
-- PADDING
--==================================================

function Components.Padding(
	parent,
	left,
	right,
	top,
	bottom
)

	local padding =
		Instance.new("UIPadding")

	padding.PaddingLeft =
		UDim.new(
			0,
			left or 0
		)

	padding.PaddingRight =
		UDim.new(
			0,
			right or 0
		)

	padding.PaddingTop =
		UDim.new(
			0,
			top or 0
		)

	padding.PaddingBottom =
		UDim.new(
			0,
			bottom or 0
		)

	padding.Parent =
		parent

	return padding
end

--==================================================
-- TÍTULO
--==================================================

function Components.Title(
	parent,
	text,
	config
)

	local label =
		Instance.new("TextLabel")

	label.Parent =
		parent

	label.Size =
		UDim2.new(
			1,
			-20,
			0,
			35
		)

	label.BackgroundTransparency =
		1

	label.Text =
		text or "Título"

	label.TextColor3 =
		config.Colors.Text

	label.TextSize =
		18

	label.Font =
		Enum.Font.GothamBold

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	return label
end

--==================================================
-- SUBTÍTULO
--==================================================

function Components.Subtitle(
	parent,
	text,
	config
)

	local label =
		Instance.new("TextLabel")

	label.Parent =
		parent

	label.Size =
		UDim2.new(
			1,
			-20,
			0,
			25
		)

	label.BackgroundTransparency =
		1

	label.Text =
		text or ""

	label.TextColor3 =
		config.Colors.SubText

	label.TextSize =
		12

	label.Font =
		Enum.Font.Gotham

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	return label
end

--==================================================
-- CARD
--==================================================

function Components.Card(
	parent,
	config,
	accentColor
)

	local card =
		Instance.new("Frame")

	card.Parent =
		parent

	card.BackgroundColor3 =
		config.Colors.Panel2

	card.BackgroundTransparency =
		0.14

	card.BorderSizePixel =
		0

	Components.Corner(
		card,
		12
	)

	Components.Stroke(
		card,
		accentColor
			or
			config.Colors.BlueNeon,
		1.5,
		0.15
	)

	return card
end

--==================================================
-- BOTÃO
--==================================================

function Components.Button(
	parent,
	text,
	config,
	color
)

	local button =
		Instance.new("TextButton")

	button.Parent =
		parent

	button.Size =
		UDim2.new(
			1,
			0,
			0,
			40
		)

	button.BackgroundColor3 =
		color
		or
		config.Colors.Blue

	button.BackgroundTransparency =
		0.06

	button.BorderSizePixel =
		0

	button.Text =
		text or "Botão"

	button.TextColor3 =
		config.Colors.Text

	button.TextSize =
		12

	button.Font =
		Enum.Font.GothamBold

	button.AutoButtonColor =
		true

	button.Active =
		true

	Components.Corner(
		button,
		8
	)

	return button
end

--==================================================
-- SEÇÃO
--==================================================

function Components.Section(
	parent,
	text,
	config,
	color
)

	local frame =
		Instance.new("Frame")

	frame.Parent =
		parent

	frame.Size =
		UDim2.new(
			1,
			0,
			0,
			34
		)

	frame.BackgroundColor3 =
		color
		or
		config.Colors.Blue

	frame.BackgroundTransparency =
		0.20

	frame.BorderSizePixel =
		0

	Components.Corner(
		frame,
		7
	)

	local label =
		Instance.new("TextLabel")

	label.Parent =
		frame

	label.Position =
		UDim2.fromOffset(
			12,
			0
		)

	label.Size =
		UDim2.new(
			1,
			-24,
			1,
			0
		)

	label.BackgroundTransparency =
		1

	label.Text =
		text or ""

	label.TextColor3 =
		config.Colors.Text

	label.TextSize =
		12

	label.Font =
		Enum.Font.GothamBold

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	return frame
end

--==================================================
-- SCROLL
--==================================================

function Components.Scroll(
	parent,
	config
)

	local scroll =
		Instance.new("ScrollingFrame")

	scroll.Parent =
		parent

	scroll.Size =
		UDim2.fromScale(
			1,
			1
		)

	scroll.BackgroundTransparency =
		1

	scroll.BorderSizePixel =
		0

	scroll.ScrollBarThickness =
		3

	scroll.ScrollBarImageColor3 =
		config.Colors.BlueNeon

	scroll.AutomaticCanvasSize =
		Enum.AutomaticSize.Y

	scroll.CanvasSize =
		UDim2.new()

	return scroll
end

--==================================================
-- LISTA
--==================================================

function Components.List(
	parent,
	spacing
)

	local layout =
		Instance.new("UIListLayout")

	layout.Parent =
		parent

	layout.Padding =
		UDim.new(
			0,
			spacing or 7
		)

	layout.SortOrder =
		Enum.SortOrder.LayoutOrder

	return layout
end

--==================================================
-- AVATAR
--==================================================

function Components.Avatar(
	parent,
	player,
	config
)

	local avatar =
		Instance.new("ImageLabel")

	avatar.Parent =
		parent

	avatar.BackgroundColor3 =
		config.Colors.Panel

	avatar.BorderSizePixel =
		0

	avatar.ScaleType =
		Enum.ScaleType.Crop

	Components.Corner(
		avatar,
		999
	)

	Components.Stroke(
		avatar,
		config.Colors.RedNeon,
		2,
		0
	)

	task.spawn(function()

		local success, image =
			pcall(function()

				return game
					:GetService("Players")
					:GetUserThumbnailAsync(
						player.UserId,
						Enum.ThumbnailType.HeadShot,
						Enum.ThumbnailSize.Size420x420
					)

			end)

		if
			success
			and
			avatar.Parent
		then

			avatar.Image =
				image
		end
	end)

	return avatar
end

--==================================================
-- INFO ROW
--==================================================

function Components.InfoRow(
	parent,
	title,
	value,
	config
)

	local row =
		Instance.new("Frame")

	row.Parent =
		parent

	row.Size =
		UDim2.new(
			1,
			0,
			0,
			27
		)

	row.BackgroundTransparency =
		1

	local titleLabel =
		Instance.new("TextLabel")

	titleLabel.Parent =
		row

	titleLabel.Size =
		UDim2.new(
			0.45,
			0,
			1,
			0
		)

	titleLabel.BackgroundTransparency =
		1

	titleLabel.Text =
		title or ""

	titleLabel.TextColor3 =
		config.Colors.SubText

	titleLabel.TextSize =
		12

	titleLabel.Font =
		Enum.Font.Gotham

	titleLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	local valueLabel =
		Instance.new("TextLabel")

	valueLabel.Parent =
		row

	valueLabel.Position =
		UDim2.new(
			0.45,
			0,
			0,
			0
		)

	valueLabel.Size =
		UDim2.new(
			0.55,
			0,
			1,
			0
		)

	valueLabel.BackgroundTransparency =
		1

	valueLabel.Text =
		tostring(
			value or "—"
		)

	valueLabel.TextColor3 =
		config.Colors.Text

	valueLabel.TextSize =
		12

	valueLabel.Font =
		Enum.Font.GothamBold

	valueLabel.TextXAlignment =
		Enum.TextXAlignment.Right

	return row, valueLabel
end

--==================================================
-- DIVISOR NEON
--==================================================

function Components.Divider(
	parent,
	config
)

	local holder =
		Instance.new("Frame")

	holder.Parent =
		parent

	holder.Size =
		UDim2.new(
			1,
			0,
			0,
			2
		)

	holder.BackgroundTransparency =
		1

	local blue =
		Instance.new("Frame")

	blue.Parent =
		holder

	blue.Size =
		UDim2.new(
			0.5,
			0,
			1,
			0
		)

	blue.BackgroundColor3 =
		config.Colors.BlueNeon

	blue.BorderSizePixel =
		0

	local red =
		Instance.new("Frame")

	red.Parent =
		holder

	red.Position =
		UDim2.new(
			0.5,
			0,
			0,
			0
		)

	red.Size =
		UDim2.new(
			0.5,
			0,
			1,
			0
		)

	red.BackgroundColor3 =
		config.Colors.RedNeon

	red.BorderSizePixel =
		0

	return holder
end

--==================================================
-- SELECT MENU / DROPDOWN
--==================================================

function Components.Dropdown(
	parent,
	title,
	options,
	defaultValue,
	config,
	callback
)

	local holder =
		Instance.new("Frame")

	holder.Parent =
		parent

	holder.Size =
		UDim2.new(
			1,
			0,
			0,
			72
		)

	holder.BackgroundTransparency =
		1

	holder.ClipsDescendants =
		false

	holder.ZIndex =
		40

	local label =
		Instance.new("TextLabel")

	label.Parent =
		holder

	label.Size =
		UDim2.new(
			1,
			0,
			0,
			22
		)

	label.BackgroundTransparency =
		1

	label.Text =
		title or "Selecione"

	label.TextColor3 =
		config.Colors.SubText

	label.TextSize =
		12

	label.Font =
		Enum.Font.GothamBold

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	label.ZIndex =
		41

	local selectButton =
		Instance.new("TextButton")

	selectButton.Parent =
		holder

	selectButton.Position =
		UDim2.fromOffset(
			0,
			27
		)

	selectButton.Size =
		UDim2.new(
			1,
			0,
			0,
			42
		)

	selectButton.BackgroundColor3 =
		config.Colors.Panel2

	selectButton.BorderSizePixel =
		0

	selectButton.TextColor3 =
		config.Colors.Text

	selectButton.TextSize =
		12

	selectButton.Font =
		Enum.Font.GothamBold

	selectButton.TextXAlignment =
		Enum.TextXAlignment.Left

	selectButton.ZIndex =
		42

	Components.Corner(
		selectButton,
		8
	)

	Components.Stroke(
		selectButton,
		config.Colors.BlueNeon,
		1.3,
		0.1
	)

	Components.Padding(
		selectButton,
		13,
		13,
		0,
		0
	)

	local listHeight =
		(#options * 38)
		+
		8

	local list =
		Instance.new("Frame")

	list.Parent =
		holder

	list.Position =
		UDim2.fromOffset(
			0,
			75
		)

	list.Size =
		UDim2.new(
			1,
			0,
			0,
			listHeight
		)

	list.BackgroundColor3 =
		config.Colors.Panel

	list.BackgroundTransparency =
		0.01

	list.BorderSizePixel =
		0

	list.Visible =
		false

	list.ZIndex =
		100

	Components.Corner(
		list,
		8
	)

	Components.Stroke(
		list,
		config.Colors.RedNeon,
		1.3,
		0.1
	)

	local padding =
		Instance.new("UIPadding")

	padding.Parent =
		list

	padding.PaddingTop =
		UDim.new(0, 4)

	padding.PaddingBottom =
		UDim.new(0, 4)

	padding.PaddingLeft =
		UDim.new(0, 4)

	padding.PaddingRight =
		UDim.new(0, 4)

	local layout =
		Instance.new("UIListLayout")

	layout.Parent =
		list

	layout.Padding =
		UDim.new(
			0,
			4
		)

	layout.SortOrder =
		Enum.SortOrder.LayoutOrder

	local currentValue =
		defaultValue
		or
		options[1]

	local opened =
		false

	local function refresh()

		selectButton.Text =
			"  "
			..
			tostring(
				currentValue
			)
			..
			(
				opened
				and
				"                         ▲"
				or
				"                         ▼"
			)

	end

	local function close()

		opened =
			false

		list.Visible =
			false

		holder.Size =
			UDim2.new(
				1,
				0,
				0,
				72
			)

		refresh()
	end

	local function open()

		opened =
			true

		list.Visible =
			true

		holder.Size =
			UDim2.new(
				1,
				0,
				0,
				80 + listHeight
			)

		refresh()
	end

	for index, value in ipairs(
		options
	) do

		local option =
			Instance.new("TextButton")

		option.Parent =
			list

		option.Size =
			UDim2.new(
				1,
				0,
				0,
				34
			)

		option.BackgroundColor3 =
			config.Colors.Panel2

		option.BorderSizePixel =
			0

		option.Text =
			tostring(value)

		option.TextColor3 =
			config.Colors.Text

		option.TextSize =
			12

		option.Font =
			Enum.Font.Gotham

		option.LayoutOrder =
			index

		option.ZIndex =
			101

		Components.Corner(
			option,
			6
		)

		option.Activated:Connect(
			function()

				currentValue =
					value

				close()

				if callback then

					callback(
						value
					)

				end
			end
		)
	end

	selectButton.Activated:Connect(
		function()

			if opened then
				close()
			else
				open()
			end
		end
	)

	refresh()

	return holder
end

return Components
