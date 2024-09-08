local highlighter = {}

local keywords = {
	lua = {
		"and", "break", "or", "else", "elseif", "if", "then", "until", "repeat", "while", "do", "for", "in", "end",
		"local", "return", "function", "export", "not", "nil", "true", "false", "goto", "self", "assert", "error",
		"pcall", "xpcall", "require", "module", "setmetatable", "getmetatable", "load", "loadfile", "dofile"
	},
	rbx = {
		"game", "workspace", "script", "math", "string", "table", "task", "wait", "select", "next", "Enum", "Instance",
		"error", "warn", "tick", "assert", "shared", "loadstring", "tonumber", "tostring", "type", "typeof", "unpack",
		"print", "Instance", "CFrame", "Vector3", "Vector2", "Color3", "UDim", "UDim2", "Ray", "BrickColor",
		"OverlapParams", "RaycastParams", "Axes", "Random", "Region3", "Rect", "TweenInfo", "Vector3int16",
		"collectgarbage", "utf8", "pcall", "xpcall", "_G", "setmetatable", "getmetatable", "os", "pairs", "ipairs",
		"tick", "GetChildren", "FindFirstChild", "GetService", "Clone", "Destroy", "FindFirstChildOfClass", "WaitForChild",
		"GetPlayerFromCharacter", "UserInputService", "Players", "Lighting", "TweenService", "RunService", "Debris",
		"Players", "Teams", "Chat", "NetworkClient", "NetworkServer", "ReplicatedStorage", "StarterGui", "StarterPack",
		"StarterCharacterScripts", "PlayerScripts", "CoreGui", "CorePackages", "CoreScripts", "ContentProvider"
	},
	synapse = {
		"getgenv", "getrenv", "getsenv", "getfenv", "setfenv", "getreg", "getgc", "getupvalues", "setupvalue", "getupvalue",
		"setreadonly", "isreadonly", "hookfunction", "debug.getinfo", "debug.setupvalue", "debug.getupvalue", "newcclosure",
		"checkcaller", "fireclickdetector", "firetouchinterest", "isfile", "isfolder", "makefolder", "writefile", "delfile",
		"delfolder", "readfile", "appendfile", "loadstring", "HttpGet", "HttpGetAsync", "request", "getconnections", "fireproximityprompt",
		"getnamecallmethod", "setnamecallmethod", "hookmetamethod", "getrawmetatable", "setrawmetatable", "identifyexecutor", 
		"is_synapse_function", "syn_crypt_b64_encode", "syn_crypt_b64_decode", "syn_crypt_encrypt", "syn_crypt_decrypt",
		"gethui", "isrbxactive", "syn.secure_call", "syn_context_set", "syn_context_get", "syn.request",
		"syn_getgc", "syn_setmetatable", "syn_getmetatable", "syn_random", "syn_is_prototype", "syn_create_prototype"
	},
	functions = {
		"print", "warn", "error", "assert", "type", "typeof", "tonumber", "tostring", "loadstring", "select", "spawn",
		"delay", "wait", "pcall", "xpcall", "pairs", "ipairs", "coroutine.create", "coroutine.resume", "coroutine.yield",
		"coroutine.status", "coroutine.wrap", "debug.traceback", "debug.getupvalue", "debug.setupvalue", "debug.getinfo",
		"string.char", "string.byte", "string.sub", "string.find", "string.match", "string.gsub", "string.format", "table.insert",
		"table.remove", "table.sort", "table.concat", "table.pack", "table.unpack", "math.random", "math.randomseed",
		"math.max", "math.min", "math.abs", "math.sin", "math.cos", "math.tan", "math.sqrt", "math.floor", "math.ceil"
	},
	properties = {
		"Name", "ClassName", "Parent", "Position", "Size", "Color", "Transparency", "AnchorPoint", "Visible",
		"BackgroundColor3", "BorderSizePixel", "Text", "TextColor3", "TextSize", "TextStrokeTransparency", "BackgroundTransparency",
		"TextTransparency", "Image", "ImageRectOffset", "ImageRectSize", "ZIndex", "Rotation", "Material", "BrickColor", "Reflectance",
		"CanCollide", "CanQuery", "CanTouch", "Anchored", "Locked", "Massless", "Velocity", "AssemblyLinearVelocity", "AssemblyAngularVelocity",
		"AssemblyMass", "SizeConstraint", "UICorner", "UIStroke", "UITextSizeConstraint", "UITextButton", "UIGridLayout", "UIListLayout",
		"UIAspectRatioConstraint", "UIScale", "TextBounds", "TextLabel", "TextButton", "TextBox", "ScrollingFrame", "Frame", "ImageLabel",
		"ImageButton", "TextButton", "TextLabel", "BillboardGui", "SurfaceGui", "ViewportFrame"
	},
	operators = {
		"#", "+", "-", "*", "%", "/", "^", "=", "~=", "<", ">", ",", ".", "(", ")", "{", "}", "[", "]", ";", ":", "::",
		"==", "<=", ">=", "..", "::", "==", "not", "or", "and", "break", "continue", "return", "goto", "self", "elseif", "end"
	},
	comment_delimiters = {
		"--", "--[[", "--]]"
	}
}

local colors = {
	numbers = Color3.fromRGB(255, 198, 0),
	boolean = Color3.fromRGB(214, 128, 23),
	operator = Color3.fromRGB(232, 210, 40),
	lua = Color3.fromRGB(160, 87, 248),
	rbx = Color3.fromRGB(146, 180, 253),
	str = Color3.fromRGB(56, 241, 87),
	comment = Color3.fromRGB(103, 110, 149),
	null = Color3.fromRGB(79, 79, 79),
	call = Color3.fromRGB(130, 170, 255),
	self_call = Color3.fromRGB(227, 201, 141),
	local_color = Color3.fromRGB(199, 146, 234),
	function_color = Color3.fromRGB(241, 122, 124),
	self_color = Color3.fromRGB(146, 134, 234),
	local_property = Color3.fromRGB(129, 222, 255),
	keyword_color = Color3.fromRGB(188, 169, 100), 
	property_color = Color3.fromRGB(177, 144, 224), 
}

local function createKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in ipairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local luaSet = createKeywordSet(keywords.lua)
local rbxSet = createKeywordSet(keywords.rbx)
local synapseSet = createKeywordSet(keywords.synapse)
local operatorsSet = createKeywordSet(keywords.operators)
local functionsSet = createKeywordSet(keywords.functions)
local propertiesSet = createKeywordSet(keywords.properties)

local function getHighlight(tokens, index)
	local token = tokens[index]

	if colors[token .. "_color"] then
		return colors[token .. "_color"]
	end

	if tonumber(token) then
		return colors.numbers
	elseif token == "nil" then
		return colors.null
	elseif token:sub(1, 2) == "--" then
		return colors.comment
	elseif operatorsSet[token] then
		return colors.operator
	elseif luaSet[token] or functionsSet[token] then
		return colors.lua
	elseif rbxSet[token] or propertiesSet[token] then
		return colors.rbx
	elseif synapseSet[token] then
		return colors.lua
	elseif token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'" then
		return colors.str
	elseif token == "true" or token == "false" then
		return colors.boolean
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return colors.self_call
		end

		return colors.call
	end

	if propertiesSet[token] then
		return colors.property_color
	end

	return colors.null
end

local function highlightText(text)
	local tokens = {}
	local highlighted = {}

	for i, token in ipairs(tokens) do
		local color = getHighlight(tokens, i)
		table.insert(highlighted, {text = token, color = color})
	end

	return highlighted
end

return highlighter
