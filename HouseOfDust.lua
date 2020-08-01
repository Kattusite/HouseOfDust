-- Credit: https://nickm.com/memslam/a_house_of_dust.py for python implementation

function Initialize()
	material = {'SAND', 'DUST', 'LEAVES', 'PAPER', 'TIN', 'ROOTS', 'BRICK', 'STONE', 'DISCARDED CLOTHING', 'GLASS', 'STEEL', 'PLASTIC', 'MUD', 'BROKEN DISHES', 'WOOD', 'STRAW', 'WEEDS'}
	location = {'IN A GREEN, MOSSY TERRAIN', 'IN AN OVERPOPULATED AREA', 'BY THE SEA', 'BY AN ABANDONED LAKE', 'IN A DESERTED FACTORY', 'IN DENSE WOODS', 'IN JAPAN', 'AMONG SMALL HILLS', 'IN SOUTHERN FRANCE', 'AMONG HIGH MOUNTAINS', 'ON AN ISLAND', 'IN A COLD, WINDY CLIMATE', 'IN A PLACE WITH BOTH HEAVY RAIN AND BRIGHT SUN', 'IN A DESERTED AIRPORT', 'IN A HOT CLIMATE', 'INSIDE A MOUNTAIN', 'ON THE SEA', 'IN MICHIGAN', 'IN HEAVY JUNGLE UNDERGROWTH', 'BY A RIVER', 'AMONG OTHER HOUSES', 'IN A DESERTED CHURCH', 'IN A METROPOLIS', 'UNDERWATER'}
	light_source = {'CANDLES', 'ALL AVAILABLE LIGHTING', 'ELECTRICITY', 'NATURAL LIGHT'}
	inhabitants = {'PEOPLE WHO SLEEP VERY LITTLE', 'VEGETARIANS', 'HORSES AND BIRDS', 'PEOPLE SPEAKING MANY LANGUAGES WEARING LITTLE OR NO CLOTHING', 'ALL RACES OF MEN REPRESENTED WEARING PREDOMINANTLY RED CLOTHING', 'CHILDREN AND OLD PEOPLE', 'VARIOUS BIRDS AND FISH', 'LOVERS', 'PEOPLE WHO ENJOY EATING TOGETHER', 'PEOPLE WHO EAT A GREAT DEAL', 'COLLECTORS OF ALL TYPES', 'FRIENDS AND ENEMIES', 'PEOPLE WHO SLEEP ALMOST ALL THE TIME', 'VERY TALL PEOPLE', 'AMERICAN INDIANS', 'LITTLE BOYS', 'PEOPLE FROM MANY WALKS OF LIFE', 'NEGROS WEARING ALL COLORS', 'FRIENDS', 'FRENCH AND GERMAN SPEAKING PEOPLE', 'FISHERMEN AND FAMILIES', 'PEOPLE WHO LOVE TO READ'}

	Choices={material=material, location=location, light_source=light_source, inhabitants=inhabitants}

	lets = {'P', 'Q', 'A', 'B', 'C', 'D'}
	iA = 3 -- index of 'A'

	for i = 1, 19 do
		for j = 1, #lets do
			tag = i..lets[j]
			meter = SKIN:GetMeter("Meter"..tag)
			InitMeter(meter)
		end
	end

	-- number of messages currently shown on screen
	num_messages = 0

end

function Choose(table)
	return table[math.random(#table)]
end

function MeterID(meter)
	-- Meters are named Meter1A, Meter1B, ... Meter19C, Meter19D
	-- Extract the number and letter of the ID
	tag=meter:GetName():gsub("Meter", "")
	len=tag:len()
	a = tag:sub(1, len-1)
	b = tag:sub(len, len)
	return a, b
end

function SetOption(meter, key, value)
	SKIN:Bang('!SetOption', meter:GetName(), key, value)
end

function InitMeter(meter)
	IDa, IDb = MeterID(meter)

	-- Only display the first N groups
	if tonumber(IDa) > tonumber(SKIN:GetVariable('MaxGroups', 20)) then
		SetOption(meter, 'Hidden', 1)
	end

	-- If ABCD, then apply text-only styling
	if IDb == 'A' or IDb == 'B' or IDb == 'C' or IDb == 'D' then
		SetOption(meter, 'Text', meter:GetName())
		SetOption(meter, 'MeterStyle', 'TextStyle')
	elseif IDb == 'P' then
		SetOption(meter, 'MeterStyle', 'ShapeStyle')
	elseif IDb == 'Q' then
		SetOption(meter, 'MeterStyle', 'ShapeStyle2')
	end

	-- Position the element
	xOffsets = {P=-3, Q=0, A=0, B=1, C=1, D=1}
	xIndent = SKIN:GetVariable('LineIndent')
	x = (xOffsets[IDb] * xIndent)..'r'

	yLN = SKIN:GetVariable('LineSpacing')
	yGP = SKIN:GetVariable('GroupSpacing')
	yOffsets = {P=yLN..'R', Q='0r', A='0r', B=yLN..'R', C=yLN..'R', D=yLN..'R'}
	y = yOffsets[IDb]

	if IDa == '1' and IDb == 'P' then
		x = SKIN:GetVariable('X', 50)
		y = SKIN:GetVariable('Y', 50)
	end

	SetOption(meter, 'X', x)
	SetOption(meter, 'Y', y)
end

-- Given the number of a group of meters, and a table mapping letters ABCD to
-- the text to be inserted into each meter, insert that text into each meter.
-- e.g. Given (4, {A=hello, B=world, C=foo, D=bar}), set:
-- Meter4A.Text = hello
-- Meter4B.Text = world
-- ...
function SetGroupText(groupNum, texts)
	print(texts, texts['A'], texts['B'])
	for i = iA, #lets do -- for let in A-D
		ltr = lets[i]
		meter = SKIN:GetMeter('Meter'..groupNum..ltr)
		SetOption(meter, 'Text', texts[ltr])
	end
end

-- Build a random message of the form given in TextA, TextB, TextC, TextD and
-- return the result as a table {A=MsgA, B=MsgB, C=MsgC, D=MsgD}
function RandomMessage()
	result = {}

	for i = iA, #lets do -- for ltr in A-D
		ltr = lets[i]
		template = SKIN:GetVariable('Text'..ltr)

		-- WARNING: Currently this limits to a single random choice per line.
		-- To do more random choices, you'll need to iteratively trim off the
		-- prefixes in which a match has already been found.
		first, last = template:find('{..*}')

		pre = template:sub(1,first-1)
		post = template:sub(last+1, template:len())

		randName = template:sub(first+1, last-1)
		randTable = Choices[randName] -- lookup variable named randName

		mid = Choose(randTable)

		result[ltr] = pre..mid..post
	end

	return result
end

function Update()
	min = SELF:GetOption("Min", 0)
	max = SELF:GetOption("Max", 10)
	x = math.random(min, max)

	-- Generate a new message for the bottom-most empty cell
	-- Move all other cells up by one if not full, deleting the first one if needed
	-- If not at the max number of cells,
	for i = 1, 19 do
		newMsg = RandomMessage()
		SetGroupText(i, newMsg)
	end
	return Choose(material)
end
