
local LOADING = {

	ImageUrl = "rbxassetid://128826102335759", 
	SoundUrl = "https://www.myinstants.com/media/sounds/kururinnn.mp3",
	SoundVolume = 0.6,
	Duration = 2.8,
	Title = "HertaHub V3",
	Subtitle = "Loading...",
}
local KEY_SYSTEM = {
	Enabled = false,
	ValidKey = "HentaiHub-2026",
	SaveFile = "HentaiHubKey.txt",
	GetKeyLink = "https://link-center.net/9212709/lqK7CtWhOedH",
}


local function resolveAsset(url, fileName)
	if not url or url == "" then return nil end
	url = tostring(url):gsub("%s+", "")


	if tonumber(url) then
		url = "rbxassetid://" .. url
	end


	if url:find("rbxassetid://") or url:find("rbxasset://") or url:find("rbxthumb://") then
		return url
	end

	
	local ok, result = pcall(function()
		if not writefile or not getcustomasset then return nil end
		local data = game:HttpGet(url)
		if not data or #data < 32 then return nil end
		writefile(fileName, data)
		return getcustomasset(fileName)
	end)
	if ok and result then return result end
	return nil
end


local function resolveImageForGui(url)
	local id = tostring(url or ""):gsub("%s+", "")
	id = id:gsub("rbxassetid://", ""):gsub("rbxasset://", "")
	if not tonumber(id) and not tostring(url):find("http") then
		return resolveAsset(url, "HH_Herta_Loading.png")
	end
	if tonumber(id) then
		-- Prefer thumbnail for UI (reliable for Decals/Images on Creator Store)
		return string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", id)
	end
	return resolveAsset(url, "HH_Herta_Loading.png")
end

------------------ KEY SYSTEM ------------------
local function checkKey()
	if not KEY_SYSTEM.Enabled then return true end
	if isfile and isfile(KEY_SYSTEM.SaveFile) then
		return readfile(KEY_SYSTEM.SaveFile) == KEY_SYSTEM.ValidKey
	end
	return false
end

if KEY_SYSTEM.Enabled and not checkKey() then
	local LP = game:GetService("Players").LocalPlayer
	local pg = LP:WaitForChild("PlayerGui")
	local gui = Instance.new("ScreenGui")
	gui.Name = "KeySystem"
	gui.ResetOnSpawn = false
	gui.Parent = pg

	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 340, 0, 230)
	f.Position = UDim2.new(0.5, -170, 0.5, -115)
	f.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
	f.BorderSizePixel = 0
	f.Parent = gui
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 0, 40)
	t.BackgroundTransparency = 1
	t.Text = "HentaiHub V3 - Key System"
	t.TextColor3 = Color3.fromRGB(200, 160, 255)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 16
	t.Parent = f

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -40, 0, 36)
	box.Position = UDim2.new(0, 20, 0, 50)
	box.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.PlaceholderText = "Enter Key..."
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.Parent = f
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

	local sub = Instance.new("TextButton")
	sub.Size = UDim2.new(1, -40, 0, 36)
	sub.Position = UDim2.new(0, 20, 0, 100)
	sub.BackgroundColor3 = Color3.fromRGB(140, 90, 220)
	sub.Text = "Submit Key"
	sub.TextColor3 = Color3.new(1, 1, 1)
	sub.Font = Enum.Font.GothamBold
	sub.TextSize = 14
	sub.Parent = f
	Instance.new("UICorner", sub).CornerRadius = UDim.new(0, 8)

	local get = Instance.new("TextButton")
	get.Size = UDim2.new(1, -40, 0, 36)
	get.Position = UDim2.new(0, 20, 0, 148)
	get.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
	get.Text = "Click here for the key"
	get.TextColor3 = Color3.new(1, 1, 1)
	get.Font = Enum.Font.GothamBold
	get.TextSize = 14
	get.Parent = f
	Instance.new("UICorner", get).CornerRadius = UDim.new(0, 8)

	local st = Instance.new("TextLabel")
	st.Size = UDim2.new(1, -20, 0, 20)
	st.Position = UDim2.new(0, 10, 1, -28)
	st.BackgroundTransparency = 1
	st.Text = ""
	st.TextColor3 = Color3.fromRGB(255, 120, 150)
	st.Font = Enum.Font.Gotham
	st.TextSize = 12
	st.Parent = f

	get.MouseButton1Click:Connect(function()
		pcall(function()
			if setclipboard then setclipboard(KEY_SYSTEM.GetKeyLink) end
			game:GetService("GuiService"):OpenBrowserWindow(KEY_SYSTEM.GetKeyLink)
		end)
		st.TextColor3 = Color3.fromRGB(180, 150, 255)
		st.Text = "Link opened / copied"
	end)

	local ok = false
	sub.MouseButton1Click:Connect(function()
		if box.Text:gsub("%s+", "") == KEY_SYSTEM.ValidKey then
			ok = true
			if writefile then writefile(KEY_SYSTEM.SaveFile, KEY_SYSTEM.ValidKey) end
			st.TextColor3 = Color3.fromRGB(150, 255, 180)
			st.Text = "Key Accepted! Loading..."
			task.wait(0.5)
			gui:Destroy()
		else
			st.Text = "Invalid Key"
		end
	end)
	while not ok do task.wait(0.1) end
end

------------------ LOADING SCREEN ------------------
do
	local LP = game:GetService("Players").LocalPlayer
	local pg = LP:WaitForChild("PlayerGui")
	local SS = game:GetService("SoundService")

	local gui = Instance.new("ScreenGui")
	gui.Name = "HH_Loading"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = pg

	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 340, 0, 230)
	f.Position = UDim2.new(0.5, -170, 0.5, -115)
	f.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
	f.BorderSizePixel = 0
	f.Parent = gui
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(140, 90, 220)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4
	stroke.Parent = f

	-- Herta image area
	local imgFrame = Instance.new("Frame")
	imgFrame.Size = UDim2.new(0, 100, 0, 100)
	imgFrame.Position = UDim2.new(0.5, -50, 0, 18)
	imgFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
	imgFrame.BorderSizePixel = 0
	imgFrame.ClipsDescendants = true
	imgFrame.Parent = f
	Instance.new("UICorner", imgFrame).CornerRadius = UDim.new(0, 12)

	local img = Instance.new("ImageLabel")
	img.Size = UDim2.new(1, 0, 1, 0)
	img.BackgroundTransparency = 1
	img.ScaleType = Enum.ScaleType.Fit
	img.Image = ""
	img.Parent = imgFrame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 28)
	title.Position = UDim2.new(0, 10, 0, 128)
	title.BackgroundTransparency = 1
	title.Text = LOADING.Title
	title.TextColor3 = Color3.fromRGB(200, 160, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.Parent = f

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, -20, 0, 20)
	sub.Position = UDim2.new(0, 10, 0, 156)
	sub.BackgroundTransparency = 1
	sub.Text = LOADING.Subtitle
	sub.TextColor3 = Color3.fromRGB(180, 160, 210)
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 13
	sub.Parent = f

	-- Progress bar
	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.new(1, -40, 0, 8)
	barBg.Position = UDim2.new(0, 20, 0, 190)
	barBg.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
	barBg.BorderSizePixel = 0
	barBg.Parent = f
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 0, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	bar.BorderSizePixel = 0
	bar.Parent = barBg
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	-- Resolve image (rbxthumb works best for Creator Store decals/images)
	do
		local asset = resolveImageForGui(LOADING.ImageUrl)
		if asset then
			img.Image = asset
		else
			imgFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
			sub.Text = "Bad image id — use Creator Store image/decal number"
		end
	end

	-- Animate bar
	local t0 = os.clock()
	local dur = math.max(1.2, LOADING.Duration or 2.5)
	while os.clock() - t0 < dur do
		local a = math.clamp((os.clock() - t0) / dur, 0, 1)
		bar.Size = UDim2.new(a, 0, 1, 0)
		task.wait()
	end
	bar.Size = UDim2.new(1, 0, 1, 0)
	task.wait(0.15)
	gui:Destroy()

	-- Play loading-complete sound (optional URL)
	if LOADING.SoundUrl and LOADING.SoundUrl ~= "" then
		task.spawn(function()
			local sid = resolveAsset(LOADING.SoundUrl, "HH_Loading_Sound.mp3")
			if not sid then return end
			pcall(function()
				local s = Instance.new("Sound")
				s.SoundId = sid
				s.Volume = math.clamp(LOADING.SoundVolume or 0.6, 0, 2)
				s.Parent = SS
				s:Play()
				s.Ended:Connect(function() s:Destroy() end)
				task.delay(15, function() if s and s.Parent then s:Destroy() end end)
			end)
		end)
	end
end

------------------ MAIN ------------------
local SAVE = "HentaiHubConfig.json"
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HS = game:GetService("HttpService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TS = game:GetService("TeleportService")
local SS = game:GetService("SoundService")
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = workspace.CurrentCamera

local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Drops = workspace:FindFirstChild("Drops") or workspace:WaitForChild("Drops", 5)
local Monsters = workspace:FindFirstChild("Monsters")

local S = {
	running = true,
	esp = false, autoCollect = false, chestEsp = false, bossEsp = false,
	fullBright = false, minimized = false,
	filterOpen = false, funnyOpen = false, wpOpen = false, setOpen = false,
	speed = false, fly = false, noclip = false, rgb = false, autoChest = false,
	chestTween = false,  -- priority tween to chests
	wpRoute = false,     -- loop named waypoints 1→2→3→...
	wpRouteIndex = 1,
	wpTweenSpeed = 14,   -- studs/sec for waypoint route
	wpArriveDelay = 2,   -- seconds to wait at each waypoint before next
	chestTweenSpeed = 16,-- studs/sec for chest approach
	chestDropWait = 2.5, -- seconds to wait for loot after open before leaving
	farmHopTimer = false,   -- after N minutes of farm, hop lowest
	farmHopMinutes = 5,
	farmSessionStart = 0,   -- set when route/chest farm becomes active
	hopNearPlayer = false,  -- hop if another player within hopNearDist
	hopNearDist = 1000,
	collectRange = 30,      -- filtered item auto-collect range
	alert = false, alertId = "rbxassetid://1000123073", alertVol = 50,
	customSpeed = 30, flySpeed = 50,
	orbit = false, lockTop = false, orbitPart = nil, orbitLabel = "",
	orbitR = 18, orbitSpd = 2.5, orbitAng = 0, orbitH = 8,
	SpeedKey = Enum.KeyCode.V, FlyKey = Enum.KeyCode.F,
}

local BossNames = {
	["Goblin Warlock"] = true, ["Hiveling Titan"] = true, ["Smelter Demon"] = true,
	["The Beholder"] = true, ["The Crowned Nothing"] = true, ["The Masquerade"] = true,
	["The Puppeteer"] = true, ["The Stormcaller"] = true, ["The Unfinished"] = true,
	["The Cell Of Life"] = true, ["The Festering Wound"] = true,
}

local Rarities = { Common = true, Uncommon = true, Rare = true, Elite = true, Legendary = true, Mythic = true }
local NameFilters = { ["Idol of Hatred"] = true, ["Stone Accord"] = true, ["Raining Taco"] = true }
local NameFilterRarities = {}
local Waypoints = {}
local WpVisuals = {}

pcall(function()
	local a = Lighting:FindFirstChildOfClass("Atmosphere")
	if a then a:Destroy() end
end)
Lighting.ChildAdded:Connect(function(c)
	if c:IsA("Atmosphere") then c:Destroy() end
end)

local oldL = {}
local function setBright(on)
	if on then
		oldL = { Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows }
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e5
		Lighting.GlobalShadows = false
	elseif oldL[1] then
		Lighting.Ambient, Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows =
			oldL[1], oldL[2], oldL[3], oldL[4], oldL[5]
	end
end

local function normalizeWaypoints(raw)
	local out = {}
	if type(raw) ~= "table" then return out end
	for _, wp in pairs(raw) do
		if type(wp) == "table" and wp.x and wp.y and wp.z then
			local kind = tostring(wp.kind or "route"):lower()
			if kind ~= "marker" and kind ~= "route" then kind = "route" end
			table.insert(out, {
				name = tostring(wp.name or "Waypoint"),
				x = tonumber(wp.x) or 0,
				y = tonumber(wp.y) or 0,
				z = tonumber(wp.z) or 0,
				kind = kind, -- "route" = tween in loop / optional TP | "marker" = pillar only, no TP
			})
		end
	end
	return out
end

-- Route-only list (markers excluded from 1→2→3 loop)
local function getRouteWaypoints()
	local list = {}
	for _, wp in ipairs(Waypoints) do
		if (wp.kind or "route") == "route" then
			table.insert(list, wp)
		end
	end
	return list
end

local function loadCfg()
	if not (isfile and isfile(SAVE)) then return end
	local ok, d = pcall(function() return HS:JSONDecode(readfile(SAVE)) end)
	if not ok or not d then return end
	if d.Rarities then for k, v in pairs(d.Rarities) do Rarities[k] = v end end
	if d.NameFilters then NameFilters = d.NameFilters end
	if d.NameFilterRarities then NameFilterRarities = d.NameFilterRarities end
	if d.Waypoints then Waypoints = normalizeWaypoints(d.Waypoints) end
	for _, k in ipairs({
		"autoCollect", "chestEsp", "fullBright", "esp", "bossEsp", "customSpeed", "flySpeed",
		"speed", "noclip", "rgb", "autoChest", "chestTween", "wpRoute", "wpTweenSpeed", "wpArriveDelay", "chestTweenSpeed", "chestDropWait", "farmHopTimer", "farmHopMinutes", "hopNearPlayer", "hopNearDist", "collectRange", "alert", "alertId", "alertVol",
		"orbitR", "orbitSpd", "orbitH"
	}) do
		if d[k] ~= nil then S[k] = d[k] end
	end
	if d.SpeedKey then pcall(function() S.SpeedKey = Enum.KeyCode[d.SpeedKey] end) end
	if d.FlyKey then pcall(function() S.FlyKey = Enum.KeyCode[d.FlyKey] end) end
end

local function saveCfg()
	if not writefile then return end
	pcall(function()
		writefile(SAVE, HS:JSONEncode({
			Rarities = Rarities, NameFilters = NameFilters, NameFilterRarities = NameFilterRarities,
			Waypoints = normalizeWaypoints(Waypoints),
			autoCollect = S.autoCollect, chestEsp = S.chestEsp, fullBright = S.fullBright,
			esp = S.esp, bossEsp = S.bossEsp, customSpeed = S.customSpeed, flySpeed = S.flySpeed,
			speed = S.speed, noclip = S.noclip, rgb = S.rgb, autoChest = S.autoChest,
			chestTween = S.chestTween,
			wpRoute = S.wpRoute,
			wpTweenSpeed = S.wpTweenSpeed,
			wpArriveDelay = S.wpArriveDelay,
			chestTweenSpeed = S.chestTweenSpeed,
			chestDropWait = S.chestDropWait,
			farmHopTimer = S.farmHopTimer,
			farmHopMinutes = S.farmHopMinutes,
			hopNearPlayer = S.hopNearPlayer,
			hopNearDist = S.hopNearDist,
			collectRange = S.collectRange,
			alert = S.alert, alertId = S.alertId, alertVol = S.alertVol,
			orbitR = S.orbitR, orbitSpd = S.orbitSpd, orbitH = S.orbitH,
			SpeedKey = S.SpeedKey.Name, FlyKey = S.FlyKey.Name,
		}))
	end)
end
loadCfg()

pcall(function() game:BindToClose(function() saveCfg() end) end)
Players.PlayerRemoving:Connect(function(p) if p == LP then saveCfg() end end)

local function playAlert(name, rarity)
	if not S.alert then return end
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = S.alertId
		s.Volume = math.clamp(S.alertVol / 10, 0, 10)
		s.Parent = SS
		s:Play()
		s.Ended:Connect(function() s:Destroy() end)
		task.delay(8, function() if s.Parent then s:Destroy() end end)
	end)
	print("[Alert]", rarity, name)
end

if Drops then
	Drops.ChildAdded:Connect(function(drop)
		task.wait(0.2)
		local r = drop:GetAttribute("Rarity")
		if r == "Legendary" or r == "Mythic" then playAlert(drop.Name, r) end
	end)
end

local function setNoClip(on)
	local c = LP.Character
	if not c then return end
	for _, p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = not on end
	end
end

local flyBV, flyBG
local function startFly()
	local c = LP.Character
	if not c then return end
	local hrp = c:FindFirstChild("HumanoidRootPart")
	local hum = c:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	hum.PlatformStand = true
	flyBV = Instance.new("BodyVelocity")
	flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Velocity = Vector3.zero
	flyBV.Parent = hrp
	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.P = 9e4
	flyBG.Parent = hrp
	S.noclip = true
	setNoClip(true)
end

local function stopFly()
	local c = LP.Character
	if c then
		local h = c:FindFirstChildOfClass("Humanoid")
		if h then h.PlatformStand = false end
	end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
end

local function updateFly()
	if not S.fly or not flyBV or not flyBG or not Cam then return end
	local m = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then m = m + Cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then m = m - Cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then m = m - Cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then m = m + Cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.yAxis end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then m = m - Vector3.yAxis end
	flyBV.Velocity = m.Magnitude > 0 and m.Unit * S.flySpeed or Vector3.zero
	flyBG.CFrame = Cam.CFrame
end

local function pressE()
	pcall(function()
		VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(0.02)
		VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	end)
end

-- true if any name is toggled on in the filter list
local function hasActiveNameFilters()
	for _, on in pairs(NameFilters) do
		if on then return true end
	end
	return false
end

--[[
  Filter rules:
  - If specific item names are ON → only those names (rarity checked when available)
  - Else → any drop whose Rarity is enabled in the rarity toggles
  - Name match still works if Rarity attribute is not set yet (chest just opened)
]]
local function isAllowed(drop)
	if not drop then return false end
	local name = drop.Name
	if type(name) ~= "string" or name:lower():find("chest") then return false end

	local r = drop:GetAttribute("Rarity")

	if hasActiveNameFilters() then
		if NameFilters[name] ~= true then
			-- also try case-insensitive / partial for safety
			local lower = name:lower()
			local matched = false
			for n, on in pairs(NameFilters) do
				if on and n:lower() == lower then matched = true break end
			end
			if not matched then return false end
		end
		-- name is wanted
		if r ~= nil and Rarities[r] == false then return false end
		if r ~= nil and Rarities[r] ~= true then return false end
		return true
	end

	-- rarity-only mode
	if not r then return false end
	return Rarities[r] == true
end

local function forceInteractable(drop)
	if not drop then return end
	pcall(function()
		local iv = drop:FindFirstChild("IsInteractable")
		if not iv then
			local b = Instance.new("BoolValue")
			b.Name = "IsInteractable"
			b.Value = true
			b.Parent = drop
		elseif iv:IsA("BoolValue") then
			iv.Value = true
		end
		-- common click / prompt enable
		for _, d in ipairs(drop:GetDescendants()) do
			if d:IsA("ProximityPrompt") then
				d.Enabled = true
				d.HoldDuration = 0
				d.MaxActivationDistance = math.max(d.MaxActivationDistance, 50)
			elseif d:IsA("ClickDetector") then
				d.MaxActivationDistance = math.max(d.MaxActivationDistance, 50)
			end
		end
	end)
end

local function manageInteract()
	if not Drops then return end
	for _, drop in ipairs(Drops:GetChildren()) do
		if NameFilters[drop.Name] and not NameFilterRarities[drop.Name] then
			NameFilterRarities[drop.Name] = drop:GetAttribute("Rarity")
		end
		if isAllowed(drop) then
			forceInteractable(drop)
		else
			local iv = drop:FindFirstChild("IsInteractable")
			if iv then iv:Destroy() end
		end
	end
end

local function getDropPart(d)
	if not d then return nil end
	return d.PrimaryPart or d:FindFirstChild("Handle") or d:FindFirstChildWhichIsA("BasePart", true)
end

local function getNearestFilteredDrop(maxRange)
	if not HRP or not Drops then return nil, nil, math.huge end
	maxRange = maxRange or 120
	local best, bestPart, bestDist = nil, nil, math.huge
	for _, d in ipairs(Drops:GetChildren()) do
		if isAllowed(d) then
			local p = getDropPart(d)
			if p then
				local dist = (p.Position - HRP.Position).Magnitude
				if dist < bestDist and dist <= maxRange then
					best, bestPart, bestDist = d, p, dist
				end
			end
		end
	end
	return best, bestPart, bestDist
end

local function nearItem()
	local _, _, d = getNearestFilteredDrop(math.clamp(tonumber(S.collectRange) or 30, 8, 80))
	return d < math.huge
end

local function fireDropPrompts(drop)
	forceInteractable(drop)
	pcall(function()
		for _, pr in ipairs(drop:GetDescendants()) do
			if pr:IsA("ProximityPrompt") then
				if fireproximityprompt then
					pcall(function() fireproximityprompt(pr, 1) end)
					pcall(function() fireproximityprompt(pr) end)
				end
			end
		end
	end)
end

local function spamCollectDrop(drop, times)
	times = times or 8
	for _ = 1, times do
		if not drop or not drop.Parent then return true end
		fireDropPrompts(drop)
		pressE()
		task.wait(0.03)
	end
	return not drop.Parent
end

local function tryCollectNearby()
	if not S.autoCollect or not HRP or not Drops then return false end
	local range = math.clamp(tonumber(S.collectRange) or 30, 8, 80)
	local any = false
	for _, d in ipairs(Drops:GetChildren()) do
		if isAllowed(d) then
			local p = getDropPart(d)
			if p and (p.Position - HRP.Position).Magnitude <= range then
				any = true
				spamCollectDrop(d, 4)
			end
		end
	end
	return any
end

-- Go to filtered drop and grab (priority over waypoint route)
local function collectFilteredDropNow()
	if not S.autoCollect or not HRP then return false end
	pcall(manageInteract)
	local drop, part, dist = getNearestFilteredDrop(100)
	if not part or not drop then return false end

	-- move onto the item if a bit far
	if dist > 8 then
		cancelMoveTween()
		-- snap close (reliable for chest loot), then spam
		pcall(function()
			HRP.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
		end)
		task.wait(0.05)
	end

	spamCollectDrop(drop, 12)
	-- extra general spam
	for _ = 1, 6 do
		tryCollectNearby()
		task.wait(0.03)
	end
	return true
end

-- Instant when drop folder gets a child
task.spawn(function()
	local function hookDrops(folder)
		if not folder then return end
		folder.ChildAdded:Connect(function(drop)
			task.spawn(function()
				if not S.autoCollect then return end
				-- rarity/name may appear a moment later
				for _ = 1, 20 do
					if not drop or not drop.Parent then return end
					if isAllowed(drop) then break end
					task.wait(0.05)
				end
				if not drop or not drop.Parent or not isAllowed(drop) then return end
				collectFilteredDropNow()
			end)
		end)
	end
	local d = workspace:FindFirstChild("Drops") or workspace:WaitForChild("Drops", 30)
	if d then
		Drops = d
		hookDrops(d)
	end
end)

local function getChestFolders()
	local t = {}
	local sys = workspace:FindFirstChild("Systems")
	if not sys then return t end
	local rs = sys:FindFirstChild("RandomSpawns")
	if rs and rs:FindFirstChild("Active") then table.insert(t, rs.Active) end
	local tr = sys:FindFirstChild("Traps")
	if tr and tr:FindFirstChild("ActiveTraps") then table.insert(t, tr.ActiveTraps) end
	return t
end

local function nearChest()
	if not HRP then return false end
	for _, folder in ipairs(getChestFolders()) do
		for _, o in ipairs(folder:GetDescendants()) do
			if o.Name == "Chest" then
				local p = o:IsA("BasePart") and o or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
				if p and (p.Position - HRP.Position).Magnitude <= 12 then return true end
			end
		end
	end
	return false
end


------------------ CHEST SPAWN SOUND + TWEEN ------------------
local CHEST_ALERT = {
	Enabled = true,
	Range = 200,  -- alert if chest spawns within this many studs
	-- Prefer a sound that works; empty = print only (no archived errors)
	SoundId = "rbxassetid://911167971",
	Volume = 4,
	Cooldown = 0.5,
}
local lastChestAlert = 0
local knownChests = {}  -- track for collect cleanup

local function playChestSpawnSound()
	if not CHEST_ALERT.Enabled then return end
	local now = os.clock()
	if now - lastChestAlert < CHEST_ALERT.Cooldown then return end
	lastChestAlert = now
	print("[HertaHub] Chest spawned nearby!")
	local sid = CHEST_ALERT.SoundId
	if not sid or sid == "" then return end
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = sid
		s.Volume = math.clamp(CHEST_ALERT.Volume, 0, 10)
		s.PlayOnRemove = false
		s.Parent = SS
		s:Play()
		s.Ended:Connect(function() s:Destroy() end)
		task.delay(8, function() if s and s.Parent then s:Destroy() end end)
	end)
end

local function getChestPart(o)
	if not o then return nil end
	if o:IsA("BasePart") then return o end
	return o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart", true)
end

-- Opened / timed-out chests (instance + position so we never re-stick)
local finishedChests = setmetatable({}, { __mode = "k" })
local finishedChestPos = {} -- ["x_y_z"] = expireTime
local activeMoveTween = nil

local function posKey(pos)
	if not pos then return nil end
	return string.format("%d_%d_%d", math.floor(pos.X / 4), math.floor(pos.Y / 4), math.floor(pos.Z / 4))
end

local function markChestFinished(chest, part)
	if chest then finishedChests[chest] = true end
	local p = part or (chest and getChestPart(chest))
	if p then
		local k = posKey(p.Position)
		if k then finishedChestPos[k] = os.clock() + 90 end -- ignore that spot ~90s
	end
end

local function isChestFinished(chest, part)
	if chest and finishedChests[chest] then return true end
	local p = part or (chest and getChestPart(chest))
	if p then
		local k = posKey(p.Position)
		local exp = k and finishedChestPos[k]
		if exp and os.clock() < exp then return true end
	end
	return false
end

-- Opened / unusable chest heuristics (don't farm forever)
local function looksOpened(chest)
	if not chest or not chest.Parent then return true end
	local opened = false
	pcall(function()
		if chest:GetAttribute("Opened") or chest:GetAttribute("Open") or chest:GetAttribute("Looted") then
			opened = true
			return
		end
		for _, d in ipairs(chest:GetDescendants()) do
			if d:IsA("ProximityPrompt") then
				if d.Enabled == false then opened = true return end
			end
			if d:IsA("ClickDetector") and d.MaxActivationDistance == 0 then
				opened = true
				return
			end
		end
		-- lid/name patterns some maps use
		local n = string.lower(chest.Name)
		if n:find("open") or n:find("loot") or n:find("empty") then
			opened = true
		end
	end)
	return opened
end

local function getNearestHighlightedChest()
	if not HRP then return nil, nil, math.huge end
	local best, bestPart, bestDist = nil, nil, math.huge
	for _, folder in ipairs(getChestFolders()) do
		for _, o in ipairs(folder:GetDescendants()) do
			if o.Name == "Chest" then
				local part = getChestPart(o)
				if part and not isChestFinished(o, part) and not looksOpened(o) then
					local d = (part.Position - HRP.Position).Magnitude
					if d < bestDist then
						best, bestPart, bestDist = o, part, d
					end
				end
			end
		end
	end
	return best, bestPart, bestDist
end

--[[
  Frame-based move: reads speed EVERY frame from Settings.
  Change Waypoint/Chest tween speed mid-path and it applies immediately.
  kind = "wp" | "chest" | number (fixed studs/s)
]]
local moveBusy = false
local moveToken = 0

local function cancelMoveTween()
	moveToken = moveToken + 1
	if activeMoveTween then
		pcall(function() activeMoveTween:Cancel() end)
		activeMoveTween = nil
	end
	moveBusy = false
end

local function currentMoveSpeed(kind)
	if kind == "wp" then
		return math.clamp(tonumber(S.wpTweenSpeed) or 14, 1, 100)
	elseif kind == "chest" then
		return math.clamp(tonumber(S.chestTweenSpeed) or 16, 1, 100)
	end
	return math.clamp(tonumber(kind) or 14, 1, 100)
end

local function slowTweenTo(pos, kind)
	if not HRP or not pos then return false end
	cancelMoveTween()
	moveBusy = true
	moveToken = moveToken + 1
	local myToken = moveToken
	local target = pos
	kind = kind or "wp"

	local ok = pcall(function()
		while S.running and moveBusy and myToken == moveToken and HRP do
			local dist = (HRP.Position - target).Magnitude
			if dist <= 4 then break end

			-- live speed from settings (mid-tween changes work)
			local spd = currentMoveSpeed(kind)
			local dt = RS.Heartbeat:Wait()
			if not HRP or myToken ~= moveToken or not moveBusy then break end

			dist = (HRP.Position - target).Magnitude
			if dist <= 4 then break end
			local step = math.min(dist, spd * math.max(dt, 1/240))
			local dir = (target - HRP.Position)
			if dir.Magnitude < 0.01 then break end
			local newPos = HRP.Position + dir.Unit * step
			HRP.CFrame = CFrame.new(newPos)
		end
	end)

	if myToken == moveToken then
		moveBusy = false
	end
	return ok
end

local function tweenToChest(part)
	if not part or not part.Parent or not HRP then return end
	slowTweenTo(part.Position + Vector3.new(0, 3, 0), "chest")
end

local function tweenToWaypoint(wp)
	if not wp or not HRP then return end
	slowTweenTo(Vector3.new(wp.x, wp.y + 2, wp.z), "wp")
end

local function watchChestFolder(folder)
	if not folder then return end
	folder.DescendantAdded:Connect(function(obj)
		if obj.Name ~= "Chest" then return end
		task.wait(0.2)
		local part = getChestPart(obj)
		if not part then return end
		knownChests[obj] = true
		-- sound if near
		if HRP and (part.Position - HRP.Position).Magnitude <= CHEST_ALERT.Range then
			playChestSpawnSound()
		end
		-- when chest is removed (collected / despawn) clear tracking
		obj.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				knownChests[obj] = nil
			end
		end)
	end)
end

task.spawn(function()
	local watched = {}
	local function hookAll()
		for _, folder in ipairs(getChestFolders()) do
			if folder and not watched[folder] then
				watched[folder] = true
				watchChestFolder(folder)
			end
		end
	end
	hookAll()
	local sys = workspace:FindFirstChild("Systems") or workspace:WaitForChild("Systems", 30)
	if sys then
		sys.DescendantAdded:Connect(function(obj)
			if obj.Name == "Active" or obj.Name == "ActiveTraps" then
				task.wait(0.1)
				hookAll()
			end
		end)
	end
end)

--[[
  FARM LOOP
  Priority:
    1) If chestTween ON (+ optional route): tween to chest → open → wait drop time → leave
    2) Else if Route ON → tween waypoints (uses wpTweenSpeed)
  Speeds / wait from Settings. Finished/opened chests are skipped so you don't stick.
]]
local ROUTE = {
	ChestPriorityRange = 250,
	ArriveStuds = 8,
	ChestPressInterval = 0.18,
}

--[[
  Chest interact: ONE approach tween, then only E + wait drop time, then FORCE leave.
  Never re-tween mid-wait (that was causing the stuck loop on opened chests).
]]
local function waitForChestCollected(chest, part)
	local dropWait = math.clamp(tonumber(S.chestDropWait) or 4, 0.5, 30)
	local hardMax = math.min(dropWait + 3, 10) -- hard cap — never stick long
	local start = os.clock()
	local openedAt = nil
	local presses = 0
	local arrived = false

	-- snap-ish: if already near, don't tween again
	if part and HRP and (part.Position - HRP.Position).Magnitude <= 14 then
		arrived = true
	end

	while S.running and (os.clock() - start) < hardMax do
		-- gone from world
		if not chest or not chest.Parent or (part and not part.Parent) then
			markChestFinished(chest, part)
			task.wait(math.min(dropWait, 1))
			return true
		end

		-- game marked opened / prompt disabled
		if looksOpened(chest) then
			if not openedAt then openedAt = os.clock() end
		end

		if part and part.Parent and HRP then
			local d = (part.Position - HRP.Position).Magnitude
			if d <= 14 then
				arrived = true
			end
			-- ONLY press E once arrived — never tween again here
			if arrived then
				pressE()
				presses = presses + 1
				if not openedAt and presses >= 2 then
					openedAt = os.clock()
				end
			end
		end

		-- After interact: wait for drop, then leave even if chest still exists
		if openedAt and (os.clock() - openedAt) >= dropWait then
			markChestFinished(chest, part)
			cancelMoveTween()
			print("[HertaHub] Chest done — leave")
			return true
		end

		-- Absolute failsafe: enough presses → leave after short wait
		if presses >= 8 and (os.clock() - start) >= math.min(dropWait, 2.5) then
			markChestFinished(chest, part)
			cancelMoveTween()
			print("[HertaHub] Chest force-leave")
			return true
		end

		task.wait(0.15)
	end

	markChestFinished(chest, part)
	cancelMoveTween()
	print("[HertaHub] Chest timeout — leave")
	return false
end

task.spawn(function()
	while S.running do
		if S.orbit or S.lockTop or S.fly then
			task.wait(0.4)
		else
			local did = false
			-- 0) FILTERED LOOT priority (chest drops / world drops)
			if S.autoCollect then
				local drop, part, dist = getNearestFilteredDrop(90)
				if part and dist and dist <= 90 then
					did = true
					collectFilteredDropNow()
					task.wait(0.05)
				end
			end

			-- 1) CHEST PRIORITY when chestTween ON
			if not did and S.chestTween then
				local chest, part, dist = getNearestHighlightedChest()
				if part and dist and dist <= ROUTE.ChestPriorityRange then
					did = true
					-- single approach only (speed live from Settings)
					if dist > 12 then
						slowTweenTo(part.Position + Vector3.new(0, 3, 0), "chest")
					end
					waitForChestCollected(chest, part)
					-- grab filtered loot that just dropped
					collectFilteredDropNow()
					for _ = 1, 20 do
						tryCollectNearby()
						pcall(manageInteract)
						task.wait(0.03)
					end
					task.wait(0.1)
				end
			end

			-- 2) WAYPOINT ROUTE — only after no chest left to handle
			if not did and S.wpRoute and HRP then
				local routeList = getRouteWaypoints()
				if #routeList == 0 then
					task.wait(0.4)
				else
					if S.wpRouteIndex < 1 or S.wpRouteIndex > #routeList then
						S.wpRouteIndex = 1
					end
					local wp = routeList[S.wpRouteIndex]
					if wp then
						local pos = Vector3.new(wp.x, wp.y, wp.z)
						local d = (HRP.Position - pos).Magnitude
						local delaySec = math.clamp(tonumber(S.wpArriveDelay) or 2, 0, 60)
						local function arriveAndWait()
							-- wait at this waypoint before going to next
							if delaySec > 0 then
								print(string.format("[HertaHub] At WP %d — wait %.1fs", S.wpRouteIndex, delaySec))
								local t0 = os.clock()
								while S.running and (os.clock() - t0) < delaySec do
									-- still collect / chest can interrupt next loop; just hold here
									if S.autoCollect then pcall(tryCollectNearby) end
									-- if chest priority should break early, leave delay
									if S.chestTween then
										local _, _, cd = getNearestHighlightedChest()
										if cd and cd <= ROUTE.ChestPriorityRange then
											break
										end
									end
									task.wait(0.15)
								end
							end
							S.wpRouteIndex = S.wpRouteIndex % #routeList + 1
						end
						if d <= ROUTE.ArriveStuds then
							arriveAndWait()
						else
							tweenToWaypoint(wp)
							if HRP then
								local d2 = (HRP.Position - Vector3.new(wp.x, wp.y, wp.z)).Magnitude
								if d2 <= ROUTE.ArriveStuds + 4 then
									arriveAndWait()
								end
							end
						end
					end
				end
			elseif not did then
				task.wait(0.35)
			end
		end
		task.wait(0.05)
	end
end)

local function getNearestBoss()
	if not Monsters or not HRP then return nil, nil, math.huge end
	local best, root, dist = nil, nil, math.huge
	for _, m in ipairs(Monsters:GetChildren()) do
		if BossNames[m.Name] then
			local r = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
			if r then
				local d = (r.Position - HRP.Position).Magnitude
				if d < dist then best, root, dist = m, r, d end
			end
		end
	end
	return best, root, dist
end

local function tpNear(part)
	if part and HRP then
		HRP.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 12))
		return true
	end
end

-- Waypoint pillars
local oldFolder = workspace:FindFirstChild("HentaiHub_Waypoints")
if oldFolder then oldFolder:Destroy() end
local WpFolder = Instance.new("Folder")
WpFolder.Name = "HentaiHub_Waypoints"
WpFolder.Parent = workspace

local function destroyWpVisual(i)
	if WpVisuals[i] then
		if WpVisuals[i].model then WpVisuals[i].model:Destroy() end
		WpVisuals[i] = nil
	end
end

local function createWpVisual(i, wp)
	destroyWpVisual(i)
	local isRoute = (wp.kind or "route") == "route"
	local model = Instance.new("Model")
	model.Name = "WP_" .. (wp.name or i)
	model.Parent = WpFolder

	-- Route = blue (tween/TP) | Marker = purple (no TP)
	local colA = isRoute and Color3.fromRGB(80, 180, 255) or Color3.fromRGB(180, 120, 255)
	local colB = isRoute and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(200, 150, 255)
	local colC = isRoute and Color3.fromRGB(60, 140, 255) or Color3.fromRGB(140, 80, 200)

	local base = Instance.new("Part")
	base.Anchored = true
	base.CanCollide = false
	base.Size = Vector3.new(2, 0.4, 2)
	base.Position = Vector3.new(wp.x, wp.y + 0.2, wp.z)
	base.Material = Enum.Material.Neon
	base.Color = colA
	base.Transparency = 0.2
	base.Parent = model

	local pillar = Instance.new("Part")
	pillar.Anchored = true
	pillar.CanCollide = false
	pillar.Size = Vector3.new(0.6, 80, 0.6)
	pillar.Position = Vector3.new(wp.x, wp.y + 40, wp.z)
	pillar.Material = Enum.Material.Neon
	pillar.Color = colB
	pillar.Transparency = 0.45
	pillar.Parent = model

	local glow = Instance.new("Part")
	glow.Anchored = true
	glow.CanCollide = false
	glow.Size = Vector3.new(2.5, 80, 2.5)
	glow.Position = Vector3.new(wp.x, wp.y + 40, wp.z)
	glow.Material = Enum.Material.Neon
	glow.Color = colC
	glow.Transparency = 0.85
	glow.Parent = model

	local light = Instance.new("PointLight")
	light.Color = colA
	light.Brightness = 2
	light.Range = 40
	light.Parent = base

	local bb = Instance.new("BillboardGui")
	bb.AlwaysOnTop = true
	bb.Size = UDim2.new(0, 170, 0, 50)
	bb.StudsOffset = Vector3.new(0, 12, 0)
	bb.Adornee = base
	bb.Parent = model

	local nameL = Instance.new("TextLabel")
	nameL.Size = UDim2.new(1, 0, 0.5, 0)
	nameL.BackgroundTransparency = 1
	nameL.Text = (isRoute and "[R] " or "[M] ") .. (wp.name or ("WP " .. i))
	nameL.TextColor3 = isRoute and Color3.fromRGB(180, 230, 255) or Color3.fromRGB(230, 200, 255)
	nameL.TextStrokeTransparency = 0.3
	nameL.Font = Enum.Font.GothamBold
	nameL.TextSize = 14
	nameL.Parent = bb

	local distL = Instance.new("TextLabel")
	distL.Size = UDim2.new(1, 0, 0.5, 0)
	distL.Position = UDim2.new(0, 0, 0.5, 0)
	distL.BackgroundTransparency = 1
	distL.Text = "0m"
	distL.TextColor3 = Color3.fromRGB(150, 220, 255)
	distL.TextStrokeTransparency = 0.3
	distL.Font = Enum.Font.Gotham
	distL.TextSize = 13
	distL.Parent = bb

	WpVisuals[i] = { model = model, distL = distL, pos = Vector3.new(wp.x, wp.y, wp.z) }
end

local function rebuildAllWpVisuals()
	for i in pairs(WpVisuals) do destroyWpVisual(i) end
	for i, wp in ipairs(Waypoints) do createWpVisual(i, wp) end
end

local function updateWpDistances()
	if not HRP then return end
	for _, v in pairs(WpVisuals) do
		if v.distL and v.pos then
			v.distL.Text = string.format("%.0fm", (v.pos - HRP.Position).Magnitude)
		end
	end
end

rebuildAllWpVisuals()

local function stopLock()
	S.orbit, S.lockTop = false, false
	S.orbitPart, S.orbitLabel = nil, ""
	local c = LP.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
	if not S.noclip and not S.fly then setNoClip(false) end
end

local function startOrbit(part, label)
	if not part then return end
	stopLock()
	S.orbitPart, S.orbitLabel, S.orbit, S.orbitAng = part, label or "T", true, 0
	setNoClip(true)
	local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = true end
end

local function startTop(part, label)
	if not part then return end
	stopLock()
	S.orbitPart, S.orbitLabel, S.lockTop = part, label or "T", true
	setNoClip(true)
	local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = true end
end

local function updateLock(dt)
	if not S.orbitPart or not S.orbitPart.Parent or not HRP then return end
	if S.orbit then
		S.orbitAng = S.orbitAng + S.orbitSpd * (dt or 0.016)
		local x = math.cos(S.orbitAng) * S.orbitR
		local z = math.sin(S.orbitAng) * S.orbitR
		HRP.CFrame = CFrame.new(S.orbitPart.Position + Vector3.new(x, S.orbitH, z), S.orbitPart.Position)
	elseif S.lockTop then
		HRP.CFrame = CFrame.new(S.orbitPart.Position + Vector3.new(0, S.orbitH, 0), S.orbitPart.Position + Vector3.new(0, 0, 0.1))
	end
end

RS.Heartbeat:Connect(function(dt)
	if not S.running then return end
	if S.speed then
		local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = S.customSpeed end
	end
	if S.noclip or S.fly or S.orbit or S.lockTop then setNoClip(true) end
	if S.fly then updateFly() end
	if S.orbit or S.lockTop then updateLock(dt) end
	updateWpDistances()
end)

task.spawn(function()
	while S.running do
		pcall(manageInteract)
		if S.autoCollect then
			tryCollectNearby()
		end
		if S.autoChest and nearChest() then
			pressE()
		end
		task.wait(0.025)
	end
end)

LP.CharacterAdded:Connect(function(c)
	Char = c
	HRP = c:WaitForChild("HumanoidRootPart")
	task.wait(0.5)
	if S.speed then
		local h = c:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = S.customSpeed end
	end
	if S.noclip or S.fly or S.orbit or S.lockTop then setNoClip(true) end
	if S.fly then startFly() end
	if S.orbit or S.lockTop then
		local h = c:FindFirstChildOfClass("Humanoid")
		if h then h.PlatformStand = true end
	end
end)

local function hop()
	print("[HertaHub] Server hopping (lowest players)...")
	saveCfg()
	local list, cursor = {}, ""
	for _ = 1, 6 do
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then url = url .. "&cursor=" .. cursor end
		local ok, res = pcall(function() return HS:JSONDecode(game:HttpGet(url)) end)
		if ok and res and res.data then
			for _, s in ipairs(res.data) do
				local p = s.playing or 0
				local maxp = s.maxPlayers or 50
				if p >= 1 and p < maxp and s.id ~= game.JobId then
					table.insert(list, { id = s.id, playing = p })
				end
			end
			cursor = res.nextPageCursor or ""
			if cursor == "" then break end
		else
			break
		end
	end
	table.sort(list, function(a, b) return a.playing < b.playing end)
	if #list == 0 then
		pcall(function() TS:Teleport(game.PlaceId, LP) end)
	else
		print("[HertaHub] Hop → server with", list[1].playing, "players")
		pcall(function() TS:TeleportToPlaceInstance(game.PlaceId, list[1].id, LP) end)
	end
end

local function otherPlayerNear()
	if not HRP then return false end
	local dist = math.clamp(tonumber(S.hopNearDist) or 1000, 50, 5000)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP then
			local ch = plr.Character
			local h = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso"))
			if h and (h.Position - HRP.Position).Magnitude <= dist then
				return true, plr.Name, (h.Position - HRP.Position).Magnitude
			end
		end
	end
	return false
end

-- Farm timer + near-player auto hop
task.spawn(function()
	while S.running do
		local farming = S.wpRoute or S.chestTween
		if farming then
			if not S.farmSessionStart or S.farmSessionStart == 0 then
				S.farmSessionStart = os.clock()
			end
		else
			S.farmSessionStart = 0
		end

		-- Timer hop
		if S.farmHopTimer and farming and S.farmSessionStart and S.farmSessionStart > 0 then
			local mins = math.clamp(tonumber(S.farmHopMinutes) or 5, 0.5, 120)
			local elapsed = (os.clock() - S.farmSessionStart) / 60
			if elapsed >= mins then
				print(string.format("[HertaHub] Farm timer %.1f min — hopping", elapsed))
				S.farmSessionStart = 0
				hop()
				task.wait(5)
			end
		end

		-- Player nearby hop
		if S.hopNearPlayer and farming then
			local near, name, d = otherPlayerNear()
			if near then
				print(string.format("[HertaHub] Player near (%.0fm) %s — hopping", d or 0, name or "?"))
				hop()
				task.wait(5)
			end
		end

		task.wait(1.5)
	end
end)

------------------ UI ------------------
local SG = Instance.new("ScreenGui")
SG.Name = "HentaiHubUI"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = PG

local ConfirmF, ConfirmT, ConfirmIn, pending, needIn
do
	ConfirmF = Instance.new("Frame")
	ConfirmF.Size = UDim2.new(0, 280, 0, 160)
	ConfirmF.Position = UDim2.new(0.5, -140, 0.5, -80)
	ConfirmF.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
	ConfirmF.BorderSizePixel = 0
	ConfirmF.Visible = false
	ConfirmF.ZIndex = 100
	ConfirmF.Parent = SG
	Instance.new("UICorner", ConfirmF).CornerRadius = UDim.new(0, 10)

	ConfirmT = Instance.new("TextLabel")
	ConfirmT.Size = UDim2.new(1, -20, 0, 40)
	ConfirmT.Position = UDim2.new(0, 10, 0, 10)
	ConfirmT.BackgroundTransparency = 1
	ConfirmT.TextColor3 = Color3.fromRGB(240, 230, 255)
	ConfirmT.Font = Enum.Font.Gotham
	ConfirmT.TextSize = 13
	ConfirmT.TextWrapped = true
	ConfirmT.ZIndex = 101
	ConfirmT.Parent = ConfirmF

	ConfirmIn = Instance.new("TextBox")
	ConfirmIn.Size = UDim2.new(1, -20, 0, 28)
	ConfirmIn.Position = UDim2.new(0, 10, 0, 52)
	ConfirmIn.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
	ConfirmIn.TextColor3 = Color3.fromRGB(240, 230, 255)
	ConfirmIn.PlaceholderText = "Name..."
	ConfirmIn.Font = Enum.Font.Gotham
	ConfirmIn.TextSize = 13
	ConfirmIn.Visible = false
	ConfirmIn.ZIndex = 101
	ConfirmIn.Parent = ConfirmF
	Instance.new("UICorner", ConfirmIn).CornerRadius = UDim.new(0, 6)

	local yes = Instance.new("TextButton")
	yes.Size = UDim2.new(0, 110, 0, 32)
	yes.Position = UDim2.new(0, 20, 1, -48)
	yes.BackgroundColor3 = Color3.fromRGB(160, 110, 255)
	yes.Text = "Confirm"
	yes.TextColor3 = Color3.new(1, 1, 1)
	yes.Font = Enum.Font.GothamBold
	yes.TextSize = 13
	yes.ZIndex = 101
	yes.Parent = ConfirmF
	Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 6)

	local no = Instance.new("TextButton")
	no.Size = UDim2.new(0, 110, 0, 32)
	no.Position = UDim2.new(1, -130, 1, -48)
	no.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
	no.Text = "Cancel"
	no.TextColor3 = Color3.new(1, 1, 1)
	no.Font = Enum.Font.GothamBold
	no.TextSize = 13
	no.ZIndex = 101
	no.Parent = ConfirmF
	Instance.new("UICorner", no).CornerRadius = UDim.new(0, 6)

	yes.MouseButton1Click:Connect(function()
		ConfirmF.Visible = false
		if pending then
			if needIn then pending(ConfirmIn.Text) else pending() end
			pending = nil
		end
	end)
	no.MouseButton1Click:Connect(function()
		ConfirmF.Visible = false
		pending = nil
	end)
end

local function ask(msg, fn, input)
	ConfirmT.Text = msg
	ConfirmIn.Visible = input == true
	ConfirmIn.Text = ""
	needIn = input == true
	pending = fn
	ConfirmF.Visible = true
end

local Main, HH
do
	Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 280, 0, 520)
	Main.Position = UDim2.new(0.5, -140, 0.05, 0)
	Main.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = SG
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, 32)
	bar.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
	bar.BorderSizePixel = 0
	bar.Parent = Main

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "HertaHub V3  |  Herta"
	title.TextColor3 = Color3.fromRGB(200, 160, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = bar

	local minB = Instance.new("TextButton")
	minB.Size = UDim2.new(0, 26, 0, 26)
	minB.Position = UDim2.new(1, -58, 0, 3)
	minB.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
	minB.Text = "–"
	minB.TextColor3 = Color3.new(1, 1, 1)
	minB.Font = Enum.Font.GothamBold
	minB.TextSize = 18
	minB.Parent = bar
	Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 6)

	local closeB = Instance.new("TextButton")
	closeB.Size = UDim2.new(0, 26, 0, 26)
	closeB.Position = UDim2.new(1, -29, 0, 3)
	closeB.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
	closeB.Text = "X"
	closeB.TextColor3 = Color3.new(1, 1, 1)
	closeB.Font = Enum.Font.GothamBold
	closeB.TextSize = 14
	closeB.Parent = bar
	Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, 6)

	closeB.MouseButton1Click:Connect(function()
		saveCfg()
		S.running = false
		stopFly()
		stopLock()
		if S.fullBright then setBright(false) end
		if S.noclip then setNoClip(false) end
		for i in pairs(WpVisuals) do destroyWpVisual(i) end
		if WpFolder then WpFolder:Destroy() end
		SG:Destroy()
	end)

	local drag, d0, p0
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag, d0, p0 = true, i.Position, Main.Position
		end
	end)
	bar.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - d0
			Main.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
		end
	end)

	local Content = Instance.new("ScrollingFrame")
	Content.Size = UDim2.new(1, -16, 1, -48)
	Content.Position = UDim2.new(0, 8, 0, 36)
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.ScrollBarThickness = 4
	Content.Parent = Main

	local lay = Instance.new("UIListLayout")
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Padding = UDim.new(0, 6)
	lay.Parent = Content
	lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Content.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
	end)

	local function chk(txt, def)
		local fr = Instance.new("Frame")
		fr.Size = UDim2.new(1, 0, 0, 26)
		fr.BackgroundTransparency = 1
		fr.Parent = Content
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 22, 0, 22)
		b.Position = UDim2.new(0, 0, 0, 2)
		b.BackgroundColor3 = def and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		b.Text = def and "✓" or ""
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 14
		b.Parent = fr
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1, -30, 1, 0)
		l.Position = UDim2.new(0, 30, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt
		l.TextColor3 = Color3.fromRGB(240, 230, 255)
		l.Font = Enum.Font.Gotham
		l.TextSize = 13
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = fr
		return b
	end

	local function btn(txt, col)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 28)
		b.BackgroundColor3 = col
		b.Text = txt
		b.TextColor3 = Color3.fromRGB(240, 230, 255)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 13
		b.Parent = Content
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		return b
	end

	local AC = chk("Auto Collect (Filtered)", S.autoCollect)
	local CE = chk("Chest ESP (All)", S.chestEsp)
	local PE = chk("Player ESP (Outline)", S.esp)
	local BE = chk("Boss ESP", S.bossEsp)
	local FB = chk("Full Bright", S.fullBright)
	local SP = chk("Speed Hack", S.speed)
	local FL = chk("Fly", S.fly)

	local FilterBtn = btn("Item Filter  →", Color3.fromRGB(55, 40, 80))
	local FunnyBtn = btn("Funny  →", Color3.fromRGB(180, 90, 160))
	local WpBtn = btn("Waypoint  →", Color3.fromRGB(70, 130, 180))
	local SetBtn = btn("Settings  →", Color3.fromRGB(55, 40, 80))
	local HopBtn = btn("Server Hop (1-3 Players)", Color3.fromRGB(100, 70, 170))

	local rOpen = false
	local RH = btn("Rarities  ▼", Color3.fromRGB(55, 40, 80))
	local RC = Instance.new("Frame")
	RC.Size = UDim2.new(1, 0, 0, 0)
	RC.BackgroundTransparency = 1
	RC.ClipsDescendants = true
	RC.Parent = Content
	for i, name in ipairs({ "Common", "Uncommon", "Rare", "Elite", "Legendary", "Mythic" }) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 24)
		b.Position = UDim2.new(0, 0, 0, (i - 1) * 26)
		b.BackgroundColor3 = Rarities[name] and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(45, 35, 60)
		b.TextColor3 = Color3.fromRGB(240, 230, 255)
		b.Text = name .. (Rarities[name] and " ✓" or "")
		b.Font = Enum.Font.Gotham
		b.TextSize = 12
		b.Parent = RC
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
		b.MouseButton1Click:Connect(function()
			Rarities[name] = not Rarities[name]
			b.BackgroundColor3 = Rarities[name] and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(45, 35, 60)
			b.Text = name .. (Rarities[name] and " ✓" or "")
			saveCfg()
		end)
	end
	RH.MouseButton1Click:Connect(function()
		rOpen = not rOpen
		RH.Text = rOpen and "Rarities  ▲" or "Rarities  ▼"
		RC.Size = UDim2.new(1, 0, 0, rOpen and 156 or 0)
	end)

	local function toggle(box, key, onE, onD)
		box.MouseButton1Click:Connect(function()
			S[key] = not S[key]
			box.Text = S[key] and "✓" or ""
			box.BackgroundColor3 = S[key] and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
			if S[key] and onE then onE() elseif not S[key] and onD then onD() end
			saveCfg()
		end)
	end

	toggle(AC, "autoCollect")
	toggle(CE, "chestEsp")
	toggle(PE, "esp")
	toggle(BE, "bossEsp")
	toggle(FB, "fullBright", function() setBright(true) end, function() setBright(false) end)
	toggle(SP, "speed", function()
		local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = S.customSpeed end
	end, function()
		local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 16 end
	end)
	toggle(FL, "fly", function() startFly() end, function() stopFly() end)
	HopBtn.MouseButton1Click:Connect(hop)

	minB.MouseButton1Click:Connect(function()
		S.minimized = not S.minimized
		minB.Text = S.minimized and "+" or "–"
		Content.Visible = not S.minimized
		if S.minimized then
			Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, 32)
		elseif Main.Size.Y.Offset < 150 then
			Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, 520)
		end
	end)

	HH = {
		Main = Main, FilterBtn = FilterBtn, FunnyBtn = FunnyBtn, WpBtn = WpBtn, SetBtn = SetBtn,
		AC = AC, CE = CE, PE = PE, BE = BE, FB = FB, SP = SP, FL = FL,
	}
end

local Panels = {}
local function updateSide()
	local p, s = HH.Main.AbsolutePosition, HH.Main.AbsoluteSize
	for _, panel in pairs(Panels) do
		if panel and panel.Parent then
			panel.Position = UDim2.new(0, p.X + s.X + 8, 0, p.Y)
		end
	end
end
HH.Main:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateSide)
HH.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSide)

-- Filter
do
	local P = Instance.new("Frame")
	P.Size = UDim2.new(0, 220, 0, 210)
	P.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
	P.BorderSizePixel = 0
	P.Visible = false
	P.Parent = SG
	Instance.new("UICorner", P).CornerRadius = UDim.new(0, 10)
	Panels.Filter = P

	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(1, -10, 0, 30)
	tl.Position = UDim2.new(0, 8, 0, 4)
	tl.BackgroundTransparency = 1
	tl.Text = "Item Filter"
	tl.TextColor3 = Color3.fromRGB(200, 160, 255)
	tl.Font = Enum.Font.GothamBold
	tl.TextSize = 14
	tl.TextXAlignment = Enum.TextXAlignment.Left
	tl.Parent = P

	local cl = Instance.new("TextButton")
	cl.Size = UDim2.new(0, 24, 0, 24)
	cl.Position = UDim2.new(1, -28, 0, 4)
	cl.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
	cl.Text = "X"
	cl.TextColor3 = Color3.new(1, 1, 1)
	cl.Font = Enum.Font.GothamBold
	cl.TextSize = 12
	cl.Parent = P
	Instance.new("UICorner", cl).CornerRadius = UDim.new(0, 5)

	local nb = Instance.new("TextBox")
	nb.Size = UDim2.new(1, -16, 0, 28)
	nb.Position = UDim2.new(0, 8, 0, 38)
	nb.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
	nb.TextColor3 = Color3.fromRGB(240, 230, 255)
	nb.PlaceholderText = "Item name..."
	nb.Font = Enum.Font.Gotham
	nb.TextSize = 13
	nb.Parent = P
	Instance.new("UICorner", nb).CornerRadius = UDim.new(0, 6)

	local ab = Instance.new("TextButton")
	ab.Size = UDim2.new(1, -16, 0, 28)
	ab.Position = UDim2.new(0, 8, 0, 72)
	ab.BackgroundColor3 = Color3.fromRGB(100, 70, 170)
	ab.Text = "Add Filter"
	ab.TextColor3 = Color3.fromRGB(240, 230, 255)
	ab.Font = Enum.Font.GothamBold
	ab.TextSize = 13
	ab.Parent = P
	Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 6)

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1, -16, 1, -110)
	list.Position = UDim2.new(0, 8, 0, 108)
	list.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 4
	list.Parent = P
	Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", list).Padding = UDim.new(0, 4)

	local function refresh()
		for _, c in ipairs(list:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		local n = 0
		for name in pairs(NameFilters) do
			n = n + 1
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -6, 0, 22)
			b.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
			b.TextColor3 = Color3.fromRGB(220, 180, 255)
			local r = NameFilterRarities[name]
			b.Text = r and (name .. " [" .. r .. "]  X") or (name .. "  X")
			b.Font = Enum.Font.Gotham
			b.TextSize = 12
			b.Parent = list
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
			b.MouseButton1Click:Connect(function()
				NameFilters[name] = nil
				NameFilterRarities[name] = nil
				refresh()
				saveCfg()
			end)
		end
		list.CanvasSize = UDim2.new(0, 0, 0, n * 26)
	end
	refresh()

	ab.MouseButton1Click:Connect(function()
		local text = nb.Text
		local final = text:gsub("%s", "") ~= "" and text or nil
		if Drops and text ~= "" then
			local low = text:lower()
			for _, d in ipairs(Drops:GetChildren()) do
				if d.Name:lower() == low or d.Name:lower():find(low, 1, true) then
					final = d.Name
					break
				end
			end
		end
		if final then
			NameFilters[final] = true
			if Drops then
				for _, d in ipairs(Drops:GetChildren()) do
					if d.Name == final then
						NameFilterRarities[final] = d:GetAttribute("Rarity")
						break
					end
				end
			end
			nb.Text = ""
			refresh()
			saveCfg()
		end
	end)

	HH.FilterBtn.MouseButton1Click:Connect(function()
		S.filterOpen = not S.filterOpen
		P.Visible = S.filterOpen
		HH.FilterBtn.Text = S.filterOpen and "Item Filter  ←" or "Item Filter  →"
		if S.filterOpen then updateSide() end
	end)
	cl.MouseButton1Click:Connect(function()
		S.filterOpen = false
		P.Visible = false
		HH.FilterBtn.Text = "Item Filter  →"
	end)
end

-- Funny
do
	local P = Instance.new("Frame")
	P.Size = UDim2.new(0, 280, 0, 460)
	P.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
	P.BorderSizePixel = 0
	P.Visible = false
	P.Parent = SG
	Instance.new("UICorner", P).CornerRadius = UDim.new(0, 10)
	Panels.Funny = P

	local function L(txt, y, bold)
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, -16, 0, 18)
		t.Position = UDim2.new(0, 8, 0, y)
		t.BackgroundTransparency = 1
		t.Text = txt
		t.TextColor3 = bold and Color3.fromRGB(200, 160, 255) or Color3.fromRGB(180, 160, 210)
		t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
		t.TextSize = bold and 12 or 11
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = P
		return t
	end
	local function B(txt, x, y, w, col)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(w, -4, 0, 28)
		b.Position = UDim2.new(x, x == 0 and 8 or 0, 0, y)
		b.BackgroundColor3 = col
		b.Text = txt
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.Parent = P
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		return b
	end

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -10, 0, 28)
	title.Position = UDim2.new(0, 8, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "Funny  ·  Boss / Players"
	title.TextColor3 = Color3.fromRGB(255, 160, 220)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = P

	local cl = Instance.new("TextButton")
	cl.Size = UDim2.new(0, 24, 0, 24)
	cl.Position = UDim2.new(1, -28, 0, 4)
	cl.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
	cl.Text = "X"
	cl.TextColor3 = Color3.new(1, 1, 1)
	cl.Font = Enum.Font.GothamBold
	cl.TextSize = 12
	cl.Parent = P
	Instance.new("UICorner", cl).CornerRadius = UDim.new(0, 5)

	local status = L("Lock: OFF", 32, false)
	L("Nearest Boss", 54, true)
	local bossLbl = L("None nearby", 72, false)

	local tpB = B("TP", 0, 94, 0.32, Color3.fromRGB(100, 70, 170))
	local orB = B("Orbit", 0.34, 94, 0.32, Color3.fromRGB(180, 90, 160))
	local toB = B("Top", 0.66, 94, 0.32, Color3.fromRGB(80, 160, 200))

	tpB.MouseButton1Click:Connect(function()
		local m, r, d = getNearestBoss()
		if not r then status.Text = "No boss" return end
		ask(string.format("TP near %s? (%.0fm)", m.Name, d), function()
			tpNear(r)
			status.Text = "TP: " .. m.Name
		end)
	end)
	orB.MouseButton1Click:Connect(function()
		local m, r = getNearestBoss()
		if not r then return end
		ask("Orbit " .. m.Name .. "?", function()
			startOrbit(r, m.Name)
			status.Text = "Orbit: " .. m.Name
		end)
	end)
	toB.MouseButton1Click:Connect(function()
		local m, r = getNearestBoss()
		if not r then return end
		ask("Top lock " .. m.Name .. "?", function()
			startTop(r, m.Name)
			status.Text = "Top: " .. m.Name
		end)
	end)

	local stopB = B("Stop Lock", 0, 128, 1, Color3.fromRGB(200, 70, 110))
	stopB.Size = UDim2.new(1, -16, 0, 26)
	stopB.Position = UDim2.new(0, 8, 0, 128)
	stopB.MouseButton1Click:Connect(function()
		stopLock()
		status.Text = "Lock: OFF"
	end)

	L("Players", 160, true)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -16, 0, 130)
	scroll.Position = UDim2.new(0, 8, 0, 180)
	scroll.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.Parent = P
	Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

	local function refreshPlayers()
		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		local n = 0
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP then
			n = n + 1
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, -6, 0, 28)
			row.BackgroundTransparency = 1
			row.Parent = scroll
			local nl = Instance.new("TextLabel")
			nl.Size = UDim2.new(0.34, 0, 1, 0)
			nl.BackgroundTransparency = 1
			nl.Text = plr.DisplayName ~= plr.Name and plr.DisplayName or plr.Name
			nl.TextColor3 = Color3.fromRGB(240, 230, 255)
			nl.Font = Enum.Font.Gotham
			nl.TextSize = 11
			nl.TextXAlignment = Enum.TextXAlignment.Left
			nl.TextTruncate = Enum.TextTruncate.AtEnd
			nl.Parent = row
			local function mk(txt, x, col, mode)
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(0, mode == "Orbit" and 42 or 36, 0, 24)
				b.Position = UDim2.new(x, 0, 0, 2)
				b.BackgroundColor3 = col
				b.Text = txt
				b.TextColor3 = Color3.new(1, 1, 1)
				b.Font = Enum.Font.GothamBold
				b.TextSize = 10
				b.Parent = row
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
				b.MouseButton1Click:Connect(function()
					local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if not r then return end
					ask(txt .. " " .. plr.Name .. "?", function()
						if mode == "TP" then tpNear(r)
						elseif mode == "Orbit" then startOrbit(r, plr.Name)
						else startTop(r, plr.Name) end
						status.Text = txt .. ": " .. plr.Name
					end)
				end)
			end
			mk("TP", 0.36, Color3.fromRGB(100, 70, 170), "TP")
			mk("Orbit", 0.52, Color3.fromRGB(180, 90, 160), "Orbit")
			mk("Top", 0.72, Color3.fromRGB(80, 160, 200), "Top")
			end -- plr ~= LP
		end
		scroll.CanvasSize = UDim2.new(0, 0, 0, n * 32)
	end

	L("Radius / Spin / Height", 318, false)
	local function box(x, y, w, val, cb)
		local t = Instance.new("TextBox")
		t.Size = UDim2.new(w, -6, 0, 26)
		t.Position = UDim2.new(x, 8, 0, y)
		t.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
		t.TextColor3 = Color3.fromRGB(240, 230, 255)
		t.Text = tostring(val)
		t.Font = Enum.Font.Gotham
		t.TextSize = 13
		t.Parent = P
		Instance.new("UICorner", t).CornerRadius = UDim.new(0, 5)
		t.FocusLost:Connect(function()
			local n = tonumber(t.Text)
			if n then cb(n) saveCfg() else t.Text = tostring(val) end
		end)
	end
	box(0, 336, 0.32, S.orbitR, function(n) if n >= 3 then S.orbitR = n end end)
	box(0.32, 336, 0.32, S.orbitSpd, function(n) if n > 0 then S.orbitSpd = n end end)
	box(0.64, 336, 0.32, S.orbitH, function(n) if n >= 2 then S.orbitH = n end end)

	local ref = B("Refresh Players", 0, 372, 1, Color3.fromRGB(55, 40, 80))
	ref.Size = UDim2.new(1, -16, 0, 26)
	ref.Position = UDim2.new(0, 8, 0, 372)
	ref.MouseButton1Click:Connect(refreshPlayers)

	task.spawn(function()
		while S.running do
			if S.funnyOpen then
				local m, _, d = getNearestBoss()
				bossLbl.Text = m and string.format("%s (%.0fm)", m.Name, d) or "None nearby"
			end
			task.wait(0.5)
		end
	end)

	HH.FunnyBtn.MouseButton1Click:Connect(function()
		S.funnyOpen = not S.funnyOpen
		P.Visible = S.funnyOpen
		HH.FunnyBtn.Text = S.funnyOpen and "Funny  ←" or "Funny  →"
		if S.funnyOpen then refreshPlayers() updateSide() end
	end)
	cl.MouseButton1Click:Connect(function()
		S.funnyOpen = false
		P.Visible = false
		HH.FunnyBtn.Text = "Funny  →"
	end)
end

-- Waypoint (no TP, no info text)
do
	local P = Instance.new("Frame")
	P.Size = UDim2.new(0, 270, 0, 400)
	P.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
	P.BorderSizePixel = 0
	P.Visible = false
	P.Parent = SG
	Instance.new("UICorner", P).CornerRadius = UDim.new(0, 10)
	Panels.WP = P

	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(1, -10, 0, 28)
	tl.Position = UDim2.new(0, 8, 0, 4)
	tl.BackgroundTransparency = 1
	tl.Text = "Waypoints  ·  Route Farm"
	tl.TextColor3 = Color3.fromRGB(120, 200, 255)
	tl.Font = Enum.Font.GothamBold
	tl.TextSize = 14
	tl.TextXAlignment = Enum.TextXAlignment.Left
	tl.Parent = P

	local cl = Instance.new("TextButton")
	cl.Size = UDim2.new(0, 24, 0, 24)
	cl.Position = UDim2.new(1, -28, 0, 4)
	cl.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
	cl.Text = "X"
	cl.TextColor3 = Color3.new(1, 1, 1)
	cl.Font = Enum.Font.GothamBold
	cl.TextSize = 12
	cl.Parent = P
	Instance.new("UICorner", cl).CornerRadius = UDim.new(0, 5)

	local routeBtn = Instance.new("TextButton")
	routeBtn.Size = UDim2.new(1, -16, 0, 30)
	routeBtn.Position = UDim2.new(0, 8, 0, 34)
	routeBtn.BackgroundColor3 = S.wpRoute and Color3.fromRGB(80, 180, 120) or Color3.fromRGB(55, 40, 80)
	routeBtn.Text = S.wpRoute and "Route Loop: ON  (1→2→3…)" or "Route Loop: OFF"
	routeBtn.TextColor3 = Color3.new(1, 1, 1)
	routeBtn.Font = Enum.Font.GothamBold
	routeBtn.TextSize = 12
	routeBtn.Parent = P
	Instance.new("UICorner", routeBtn).CornerRadius = UDim.new(0, 6)

	local routeStatus = Instance.new("TextLabel")
	routeStatus.Size = UDim2.new(1, -16, 0, 18)
	routeStatus.Position = UDim2.new(0, 8, 0, 66)
	routeStatus.BackgroundTransparency = 1
	routeStatus.Text = "Mark 1, 2, 3… then enable Route"
	routeStatus.TextColor3 = Color3.fromRGB(160, 200, 230)
	routeStatus.Font = Enum.Font.Gotham
	routeStatus.TextSize = 11
	routeStatus.TextXAlignment = Enum.TextXAlignment.Left
	routeStatus.Parent = P

	local addRoute = Instance.new("TextButton")
	addRoute.Size = UDim2.new(0.48, -6, 0, 28)
	addRoute.Position = UDim2.new(0, 8, 0, 88)
	addRoute.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	addRoute.Text = "+ Route (tween)"
	addRoute.TextColor3 = Color3.new(1, 1, 1)
	addRoute.Font = Enum.Font.GothamBold
	addRoute.TextSize = 11
	addRoute.Parent = P
	Instance.new("UICorner", addRoute).CornerRadius = UDim.new(0, 6)

	local addMark = Instance.new("TextButton")
	addMark.Size = UDim2.new(0.48, -6, 0, 28)
	addMark.Position = UDim2.new(0.52, 0, 0, 88)
	addMark.BackgroundColor3 = Color3.fromRGB(120, 80, 180)
	addMark.Text = "+ Marker (no TP)"
	addMark.TextColor3 = Color3.new(1, 1, 1)
	addMark.Font = Enum.Font.GothamBold
	addMark.TextSize = 11
	addMark.Parent = P
	Instance.new("UICorner", addMark).CornerRadius = UDim.new(0, 6)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -16, 1, -128)
	scroll.Position = UDim2.new(0, 8, 0, 122)
	scroll.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.Parent = P
	Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
	Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

	local function refreshWP()
		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		local routeList = getRouteWaypoints()
		local n = 0
		for i, wp in ipairs(Waypoints) do
			n = n + 1
			local isRoute = (wp.kind or "route") == "route"
			local dist = HRP and (Vector3.new(wp.x, wp.y, wp.z) - HRP.Position).Magnitude or 0
			-- current route step index among route-only list
			local routeIdx = nil
			if isRoute then
				for ri, rwp in ipairs(routeList) do
					if rwp == wp then routeIdx = ri break end
				end
			end
			local isCur = S.wpRoute and isRoute and routeIdx == S.wpRouteIndex
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, -6, 0, 36)
			row.BackgroundColor3 = isCur and Color3.fromRGB(50, 90, 70)
				or (isRoute and Color3.fromRGB(40, 55, 80) or Color3.fromRGB(55, 40, 75))
			row.Parent = scroll
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

			local nl = Instance.new("TextLabel")
			nl.Size = UDim2.new(0.55, 0, 0.55, 0)
			nl.Position = UDim2.new(0, 6, 0, 2)
			nl.BackgroundTransparency = 1
			local tag = isRoute and "R" or "M"
			nl.Text = (isCur and "▶ " or "") .. tag .. i .. " " .. (wp.name or ("WP " .. i))
			nl.TextColor3 = Color3.fromRGB(240, 230, 255)
			nl.Font = Enum.Font.GothamBold
			nl.TextSize = 11
			nl.TextXAlignment = Enum.TextXAlignment.Left
			nl.TextTruncate = Enum.TextTruncate.AtEnd
			nl.Parent = row

			local dl = Instance.new("TextLabel")
			dl.Size = UDim2.new(0.55, 0, 0.4, 0)
			dl.Position = UDim2.new(0, 6, 0.55, 0)
			dl.BackgroundTransparency = 1
			dl.Text = string.format("%s  %.0fm", isRoute and "tween/TP" or "marker", dist)
			dl.TextColor3 = Color3.fromRGB(150, 200, 255)
			dl.Font = Enum.Font.Gotham
			dl.TextSize = 10
			dl.TextXAlignment = Enum.TextXAlignment.Left
			dl.Parent = row

			-- TP only for route waypoints
			if isRoute then
				local tp = Instance.new("TextButton")
				tp.Size = UDim2.new(0, 32, 0, 24)
				tp.Position = UDim2.new(1, -78, 0.5, -12)
				tp.BackgroundColor3 = Color3.fromRGB(70, 150, 200)
				tp.Text = "TP"
				tp.TextColor3 = Color3.new(1, 1, 1)
				tp.Font = Enum.Font.GothamBold
				tp.TextSize = 11
				tp.Parent = row
				Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 4)
				tp.MouseButton1Click:Connect(function()
					if HRP then
						HRP.CFrame = CFrame.new(wp.x, wp.y + 3, wp.z)
					end
				end)
			end

			local del = Instance.new("TextButton")
			del.Size = UDim2.new(0, 28, 0, 24)
			del.Position = UDim2.new(1, -40, 0.5, -12)
			del.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
			del.Text = "X"
			del.TextColor3 = Color3.new(1, 1, 1)
			del.Font = Enum.Font.GothamBold
			del.TextSize = 12
			del.Parent = row
			Instance.new("UICorner", del).CornerRadius = UDim.new(0, 4)
			del.MouseButton1Click:Connect(function()
				ask('Delete "' .. (wp.name or "?") .. '"?', function()
					table.remove(Waypoints, i)
					rebuildAllWpVisuals()
					refreshWP()
					saveCfg()
				end)
			end)
		end
		scroll.CanvasSize = UDim2.new(0, 0, 0, n * 40)
	end

	routeBtn.MouseButton1Click:Connect(function()
		S.wpRoute = not S.wpRoute
		if S.wpRoute then
			S.wpRouteIndex = 1
		end
		routeBtn.Text = S.wpRoute and "Route Loop: ON  (1→2→3…)" or "Route Loop: OFF"
		routeBtn.BackgroundColor3 = S.wpRoute and Color3.fromRGB(80, 180, 120) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)

	task.spawn(function()
		while S.running do
			if S.wpOpen and routeStatus then
				local rl = getRouteWaypoints()
				if S.wpRoute and #rl > 0 then
					local wp = rl[S.wpRouteIndex]
					local nm = wp and (wp.name or ("#" .. S.wpRouteIndex)) or "?"
					routeStatus.Text = string.format("Tween → %d/%d  %s  | chest first", S.wpRouteIndex, #rl, nm)
				elseif S.wpRoute then
					routeStatus.Text = "Route ON — add Route points (+ Route)"
				else
					routeStatus.Text = "+ Route = tween loop | + Marker = no TP"
				end
			end
			task.wait(0.5)
		end
	end)

	local function addWp(kind)
		if not HRP then return end
		local pos = HRP.Position
		local prompt = kind == "route" and "Name route point (tween/TP):" or "Name marker (no TP):"
		ask(prompt, function(name)
			name = (name or ""):gsub("^%s*(.-)%s*$", "%1")
			if name == "" then
				if kind == "route" then
					name = tostring(#getRouteWaypoints() + 1)
				else
					name = "Mark " .. tostring(#Waypoints + 1)
				end
			end
			table.insert(Waypoints, {
				name = name,
				x = pos.X, y = pos.Y, z = pos.Z,
				kind = kind,
			})
			rebuildAllWpVisuals()
			refreshWP()
			saveCfg()
		end, true)
	end

	addRoute.MouseButton1Click:Connect(function() addWp("route") end)
	addMark.MouseButton1Click:Connect(function() addWp("marker") end)

	task.spawn(function()
		while S.running do
			if S.wpOpen then refreshWP() end
			task.wait(1)
		end
	end)

	HH.WpBtn.MouseButton1Click:Connect(function()
		S.wpOpen = not S.wpOpen
		P.Visible = S.wpOpen
		HH.WpBtn.Text = S.wpOpen and "Waypoint  ←" or "Waypoint  →"
		if S.wpOpen then refreshWP() updateSide() end
	end)
	cl.MouseButton1Click:Connect(function()
		S.wpOpen = false
		P.Visible = false
		HH.WpBtn.Text = "Waypoint  →"
	end)
end

-- Settings (no silent aim)
do
	local P = Instance.new("Frame")
	P.Size = UDim2.new(0, 270, 0, 420)
	P.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
	P.BorderSizePixel = 0
	P.Visible = false
	P.Parent = SG
	Instance.new("UICorner", P).CornerRadius = UDim.new(0, 10)
	Panels.Set = P

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -10, 0, 28)
	title.Position = UDim2.new(0, 8, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "Settings"
	title.TextColor3 = Color3.fromRGB(200, 160, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = P

	local cl = Instance.new("TextButton")
	cl.Size = UDim2.new(0, 24, 0, 24)
	cl.Position = UDim2.new(1, -28, 0, 4)
	cl.BackgroundColor3 = Color3.fromRGB(200, 70, 110)
	cl.Text = "X"
	cl.TextColor3 = Color3.new(1, 1, 1)
	cl.Font = Enum.Font.GothamBold
	cl.TextSize = 12
	cl.Parent = P
	Instance.new("UICorner", cl).CornerRadius = UDim.new(0, 5)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -12, 1, -36)
	scroll.Position = UDim2.new(0, 6, 0, 32)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.CanvasSize = UDim2.new(0, 0, 0, 980)
	scroll.Parent = P

	local function label(txt, y)
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, -16, 0, 16)
		t.Position = UDim2.new(0, 6, 0, y)
		t.BackgroundTransparency = 1
		t.Text = txt
		t.TextColor3 = Color3.fromRGB(180, 160, 210)
		t.Font = Enum.Font.Gotham
		t.TextSize = 11
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = scroll
	end
	local function tbox(y, val)
		local t = Instance.new("TextBox")
		t.Size = UDim2.new(1, -16, 0, 26)
		t.Position = UDim2.new(0, 6, 0, y)
		t.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
		t.TextColor3 = Color3.fromRGB(240, 230, 255)
		t.Text = tostring(val)
		t.Font = Enum.Font.Gotham
		t.TextSize = 13
		t.Parent = scroll
		Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
		return t
	end
	local function tgl(y, txt, on)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -16, 0, 28)
		b.Position = UDim2.new(0, 6, 0, y)
		b.BackgroundColor3 = on and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		b.Text = txt
		b.TextColor3 = Color3.fromRGB(240, 230, 255)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.Parent = scroll
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		return b
	end

	label("Walk Speed Value:", 4)
	local sBox = tbox(22, S.customSpeed)
	label("Fly Speed:", 54)
	local fBox = tbox(72, S.flySpeed)
	local sk = tgl(106, "Speed Key: " .. S.SpeedKey.Name, false)
	local fk = tgl(140, "Fly Key: " .. S.FlyKey.Name, false)
	local nc = tgl(174, S.noclip and "NoClip: ON" or "NoClip: OFF", S.noclip)
	local rg = tgl(208, S.rgb and "RGB Outline: ON" or "RGB Outline: OFF", S.rgb)

	label("--- Chest / Route ---", 244)
	local ac = tgl(264, S.autoChest and "Auto Open Chest: ON" or "Auto Open Chest: OFF", S.autoChest)
	local ct = tgl(298, S.chestTween and "Chest Tween: ON" or "Chest Tween: OFF", S.chestTween)
	label("Waypoint tween speed (1=slow, 14=med):", 334)
	local wpSpdBox = tbox(352, S.wpTweenSpeed)
	label("Delay at each waypoint (sec):", 384)
	local wpDelayBox = tbox(402, S.wpArriveDelay)
	label("Chest tween speed (1=slow, 16=med):", 434)
	local chSpdBox = tbox(452, S.chestTweenSpeed)
	label("Wait after open for drop (sec):", 484)
	local dropWaitBox = tbox(502, S.chestDropWait)
	label("Collect range (studs):", 534)
	local colRangeBox = tbox(552, S.collectRange)

	label("--- Auto Hop ---", 586)
	local fht = tgl(606, S.farmHopTimer and "Farm Timer Hop: ON" or "Farm Timer Hop: OFF", S.farmHopTimer)
	label("Farm minutes before hop:", 640)
	local farmMinBox = tbox(658, S.farmHopMinutes)
	local hnp = tgl(692, S.hopNearPlayer and "Hop if player near: ON" or "Hop if player near: OFF", S.hopNearPlayer)
	label("Detect player within (meters/studs):", 726)
	local nearDistBox = tbox(744, S.hopNearDist)

	local al = tgl(782, S.alert and "L/M Drop Alert: ON" or "L/M Drop Alert: OFF", S.alert)
	label("Alert Sound ID:", 816)
	local idBox = tbox(834, S.alertId)
	label("Alert Volume (0–100):", 866)
	local volBox = tbox(884, S.alertVol)
	local test = tgl(918, "Test Alert Sound", false)
	test.BackgroundColor3 = Color3.fromRGB(100, 70, 170)

	sBox.FocusLost:Connect(function()
		local n = tonumber(sBox.Text)
		if n and n >= 1 then S.customSpeed = math.floor(n) saveCfg() else sBox.Text = tostring(S.customSpeed) end
	end)
	fBox.FocusLost:Connect(function()
		local n = tonumber(fBox.Text)
		if n and n >= 1 then S.flySpeed = math.floor(n) saveCfg() else fBox.Text = tostring(S.flySpeed) end
	end)
	wpSpdBox.FocusLost:Connect(function()
		local n = tonumber(wpSpdBox.Text)
		if n and n >= 1 and n <= 100 then S.wpTweenSpeed = n saveCfg() else wpSpdBox.Text = tostring(S.wpTweenSpeed) end
	end)
	wpDelayBox.FocusLost:Connect(function()
		local n = tonumber(wpDelayBox.Text)
		if n and n >= 0 and n <= 60 then S.wpArriveDelay = n saveCfg() else wpDelayBox.Text = tostring(S.wpArriveDelay) end
	end)
	chSpdBox.FocusLost:Connect(function()
		local n = tonumber(chSpdBox.Text)
		if n and n >= 1 and n <= 100 then S.chestTweenSpeed = n saveCfg() else chSpdBox.Text = tostring(S.chestTweenSpeed) end
	end)
	dropWaitBox.FocusLost:Connect(function()
		local n = tonumber(dropWaitBox.Text)
		if n and n >= 0.5 and n <= 30 then S.chestDropWait = n saveCfg() else dropWaitBox.Text = tostring(S.chestDropWait) end
	end)
	colRangeBox.FocusLost:Connect(function()
		local n = tonumber(colRangeBox.Text)
		if n and n >= 8 and n <= 60 then S.collectRange = n saveCfg() else colRangeBox.Text = tostring(S.collectRange) end
	end)
	farmMinBox.FocusLost:Connect(function()
		local n = tonumber(farmMinBox.Text)
		if n and n >= 0.5 and n <= 120 then S.farmHopMinutes = n saveCfg() else farmMinBox.Text = tostring(S.farmHopMinutes) end
	end)
	nearDistBox.FocusLost:Connect(function()
		local n = tonumber(nearDistBox.Text)
		if n and n >= 50 and n <= 5000 then S.hopNearDist = n saveCfg() else nearDistBox.Text = tostring(S.hopNearDist) end
	end)
	fht.MouseButton1Click:Connect(function()
		S.farmHopTimer = not S.farmHopTimer
		if S.farmHopTimer then S.farmSessionStart = os.clock() end
		fht.Text = S.farmHopTimer and "Farm Timer Hop: ON" or "Farm Timer Hop: OFF"
		fht.BackgroundColor3 = S.farmHopTimer and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)
	hnp.MouseButton1Click:Connect(function()
		S.hopNearPlayer = not S.hopNearPlayer
		hnp.Text = S.hopNearPlayer and "Hop if player near: ON" or "Hop if player near: OFF"
		hnp.BackgroundColor3 = S.hopNearPlayer and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)
	idBox.FocusLost:Connect(function()
		local t = idBox.Text:gsub("%s+", "")
		if t ~= "" then
			if not t:find("rbxassetid://") and tonumber(t) then t = "rbxassetid://" .. t end
			S.alertId = t
			idBox.Text = t
			saveCfg()
		end
	end)
	volBox.FocusLost:Connect(function()
		local n = tonumber(volBox.Text)
		if n and n >= 0 and n <= 100 then S.alertVol = n saveCfg() else volBox.Text = tostring(S.alertVol) end
	end)

	local waitKey
	sk.MouseButton1Click:Connect(function() waitKey = "S" sk.Text = "Press key..." end)
	fk.MouseButton1Click:Connect(function() waitKey = "F" fk.Text = "Press key..." end)
	UIS.InputBegan:Connect(function(i, gp)
		if waitKey and i.UserInputType == Enum.UserInputType.Keyboard then
			if waitKey == "S" then S.SpeedKey = i.KeyCode sk.Text = "Speed Key: " .. S.SpeedKey.Name
			else S.FlyKey = i.KeyCode fk.Text = "Fly Key: " .. S.FlyKey.Name end
			waitKey = nil
			saveCfg()
			return
		end
		if gp or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if i.KeyCode == S.SpeedKey then
			S.speed = not S.speed
			HH.SP.Text = S.speed and "✓" or ""
			HH.SP.BackgroundColor3 = S.speed and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
			local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
			if h then h.WalkSpeed = S.speed and S.customSpeed or 16 end
			saveCfg()
		elseif i.KeyCode == S.FlyKey then
			S.fly = not S.fly
			HH.FL.Text = S.fly and "✓" or ""
			HH.FL.BackgroundColor3 = S.fly and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
			if S.fly then startFly() else stopFly() end
			saveCfg()
		end
	end)

	nc.MouseButton1Click:Connect(function()
		S.noclip = not S.noclip
		nc.Text = S.noclip and "NoClip: ON" or "NoClip: OFF"
		nc.BackgroundColor3 = S.noclip and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		setNoClip(S.noclip)
		saveCfg()
	end)
	rg.MouseButton1Click:Connect(function()
		S.rgb = not S.rgb
		rg.Text = S.rgb and "RGB Outline: ON" or "RGB Outline: OFF"
		rg.BackgroundColor3 = S.rgb and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)
	ac.MouseButton1Click:Connect(function()
		S.autoChest = not S.autoChest
		ac.Text = S.autoChest and "Auto Open Chest: ON" or "Auto Open Chest: OFF"
		ac.BackgroundColor3 = S.autoChest and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)
	ct.MouseButton1Click:Connect(function()
		S.chestTween = not S.chestTween
		ct.Text = S.chestTween and "Chest Tween: ON" or "Chest Tween: OFF"
		ct.BackgroundColor3 = S.chestTween and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)
	al.MouseButton1Click:Connect(function()
		S.alert = not S.alert
		al.Text = S.alert and "L/M Drop Alert: ON" or "L/M Drop Alert: OFF"
		al.BackgroundColor3 = S.alert and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(55, 40, 80)
		saveCfg()
	end)
	test.MouseButton1Click:Connect(function() playAlert("Test", "Legendary") end)

	HH.SetBtn.MouseButton1Click:Connect(function()
		S.setOpen = not S.setOpen
		P.Visible = S.setOpen
		HH.SetBtn.Text = S.setOpen and "Settings  ←" or "Settings  →"
		if S.setOpen then
			sBox.Text = tostring(S.customSpeed)
			fBox.Text = tostring(S.flySpeed)
			idBox.Text = S.alertId
			volBox.Text = tostring(S.alertVol)
			updateSide()
		end
	end)
	cl.MouseButton1Click:Connect(function()
		S.setOpen = false
		P.Visible = false
		HH.SetBtn.Text = "Settings  →"
	end)
end

-- ESP
do
	local pEsp, bEsp, iEsp, cEsp = {}, {}, {}, {}
	local pFold = Instance.new("Folder", SG) pFold.Name = "PESP"
	local bFold = Instance.new("Folder", SG) bFold.Name = "BESP"
	local iFold = Instance.new("Folder", SG) iFold.Name = "IESP"
	local cFold = Instance.new("Folder", SG) cFold.Name = "CESP"
	local hue = 0

	RS.RenderStepped:Connect(function()
		if not S.running then return end
		if S.esp then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LP then
					local ch = plr.Character
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")
					local root = ch and ch:FindFirstChild("HumanoidRootPart")
					if not pEsp[plr] then
						local hl = Instance.new("Highlight")
						hl.FillTransparency = 0.7
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						local bb = Instance.new("BillboardGui")
						bb.AlwaysOnTop = true
						bb.Size = UDim2.new(0, 160, 0, 36)
						bb.StudsOffset = Vector3.new(0, 3.5, 0)
						bb.Parent = pFold
						local nl = Instance.new("TextLabel")
						nl.Size = UDim2.new(1, 0, 1, 0)
						nl.BackgroundTransparency = 1
						nl.TextColor3 = Color3.new(1, 1, 1)
						nl.TextStrokeTransparency = 0.5
						nl.Font = Enum.Font.GothamBold
						nl.TextSize = 12
						nl.Text = plr.DisplayName
						nl.Parent = bb
						pEsp[plr] = { bb = bb, hl = hl, nl = nl }
					end
					local d = pEsp[plr]
					if root and hum and hum.Health > 0 then
						d.bb.Adornee = root
						d.bb.Enabled = true
						d.hl.Adornee = ch
						d.hl.Parent = ch
						d.hl.Enabled = true
						local dist = HRP and (root.Position - HRP.Position).Magnitude or 0
						d.nl.Text = string.format("%s\n%dm", plr.DisplayName, math.floor(dist))
					else
						d.bb.Enabled = false
						d.hl.Enabled = false
					end
				end
			end
		else
			for _, d in pairs(pEsp) do d.bb.Enabled = false d.hl.Enabled = false end
		end

		if S.bossEsp and Monsters then
			for _, m in ipairs(Monsters:GetChildren()) do
				if BossNames[m.Name] then
					local root = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
					if not bEsp[m] then
						local hl = Instance.new("Highlight")
						hl.FillColor = Color3.fromRGB(255, 80, 120)
						hl.OutlineColor = Color3.fromRGB(255, 180, 220)
						hl.FillTransparency = 0.6
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						local bb = Instance.new("BillboardGui")
						bb.AlwaysOnTop = true
						bb.Size = UDim2.new(0, 180, 0, 40)
						bb.StudsOffset = Vector3.new(0, 4, 0)
						bb.Parent = bFold
						local nl = Instance.new("TextLabel")
						nl.Size = UDim2.new(1, 0, 1, 0)
						nl.BackgroundTransparency = 1
						nl.TextColor3 = Color3.fromRGB(255, 120, 160)
						nl.TextStrokeTransparency = 0.4
						nl.Font = Enum.Font.GothamBold
						nl.TextSize = 12
						nl.Parent = bb
						bEsp[m] = { bb = bb, nl = nl, hl = hl }
					end
					local d = bEsp[m]
					if root then
						d.bb.Adornee = root
						d.bb.Enabled = true
						d.hl.Adornee = m
						d.hl.Parent = m
						d.hl.Enabled = true
						local dist = HRP and (root.Position - HRP.Position).Magnitude or 0
						d.nl.Text = string.format("%s\n%dm", m.Name, math.floor(dist))
					else
						d.bb.Enabled = false
						d.hl.Enabled = false
					end
				end
			end
		else
			for _, d in pairs(bEsp) do d.bb.Enabled = false d.hl.Enabled = false end
		end

		if S.autoCollect and Drops then
			for _, drop in ipairs(Drops:GetChildren()) do
				if not drop.Name:lower():find("chest") and isAllowed(drop) then
					if not iEsp[drop] then
						local bb = Instance.new("BillboardGui")
						bb.AlwaysOnTop = true
						bb.Size = UDim2.new(0, 150, 0, 36)
						bb.StudsOffset = Vector3.new(0, 2.5, 0)
						bb.Parent = iFold
						local l = Instance.new("TextLabel")
						l.Size = UDim2.new(1, 0, 1, 0)
						l.BackgroundTransparency = 1
						l.TextColor3 = Color3.new(1, 1, 1)
						l.TextStrokeTransparency = 0.4
						l.Font = Enum.Font.GothamBold
						l.TextSize = 11
						l.Parent = bb
						iEsp[drop] = bb
					end
					local bb = iEsp[drop]
					local part = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
					if part then
						bb.Adornee = part
						bb.Enabled = true
						local lab = bb:FindFirstChildOfClass("TextLabel")
						if lab then
							local dist = HRP and (part.Position - HRP.Position).Magnitude or 0
							lab.Text = string.format("%s\n%s | %dm", drop.Name, drop:GetAttribute("Rarity") or "?", math.floor(dist))
						end
					end
				elseif iEsp[drop] then
					iEsp[drop].Enabled = false
				end
			end
		else
			for _, bb in pairs(iEsp) do bb.Enabled = false end
		end

		if S.chestEsp then
			local still = {}
			for _, folder in ipairs(getChestFolders()) do
				for _, o in ipairs(folder:GetDescendants()) do
					if o.Name == "Chest" then
						local part = o:IsA("BasePart") and o or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
						if part and part.Parent then
							still[o] = true
							if not cEsp[o] then
								local hl = Instance.new("Highlight")
								hl.FillColor = Color3.fromRGB(255, 200, 80)
								hl.OutlineColor = Color3.fromRGB(255, 230, 120)
								hl.FillTransparency = 0.55
								hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								local bb = Instance.new("BillboardGui")
								bb.AlwaysOnTop = true
								bb.Size = UDim2.new(0, 100, 0, 32)
								bb.StudsOffset = Vector3.new(0, 2.5, 0)
								bb.Parent = cFold
								local l = Instance.new("TextLabel")
								l.Size = UDim2.new(1, 0, 1, 0)
								l.BackgroundTransparency = 1
								l.TextColor3 = Color3.fromRGB(255, 230, 120)
								l.TextStrokeTransparency = 0.4
								l.Font = Enum.Font.GothamBold
								l.TextSize = 12
								l.Parent = bb
								cEsp[o] = { bb = bb, l = l, hl = hl }
							end
							local d = cEsp[o]
							d.bb.Adornee = part
							d.bb.Enabled = true
							d.hl.Adornee = o:IsA("Model") and o or part
							d.hl.Parent = o:IsA("Model") and o or part
							d.hl.Enabled = true
							local dist = HRP and (part.Position - HRP.Position).Magnitude or 0
							d.l.Text = string.format("Chest\n%dm", math.floor(dist))
						end
					end
				end
			end
			-- collected / despawned chests: destroy highlight (no longer highlighted)
			for o, d in pairs(cEsp) do
				if not still[o] or not o.Parent then
					pcall(function()
						if d.bb then d.bb:Destroy() end
						if d.hl then d.hl:Destroy() end
					end)
					cEsp[o] = nil
				end
			end
		else
			for o, d in pairs(cEsp) do
				pcall(function()
					if d.bb then d.bb.Enabled = false end
					if d.hl then d.hl.Enabled = false end
				end)
			end
		end

		if S.rgb then
			hue = (hue + 0.005) % 1
			local col = Color3.fromHSV(hue, 1, 1)
			if S.esp then
				for _, d in pairs(pEsp) do
					if d.hl.Enabled then d.hl.OutlineColor = col d.hl.FillColor = col end
				end
			end
		end
	end)

	Players.PlayerRemoving:Connect(function(p)
		if pEsp[p] then
			pEsp[p].bb:Destroy()
			if pEsp[p].hl then pEsp[p].hl:Destroy() end
			pEsp[p] = nil
		end
	end)
end

task.spawn(function()
	task.wait(0.5)
	local map = {
		{ HH.AC, "autoCollect" }, { HH.CE, "chestEsp" }, { HH.PE, "esp" },
		{ HH.BE, "bossEsp" }, { HH.FB, "fullBright" }, { HH.SP, "speed" }, { HH.FL, "fly" },
	}
	for _, v in ipairs(map) do
		if S[v[2]] then
			v[1].Text = "✓"
			v[1].BackgroundColor3 = Color3.fromRGB(160, 110, 255)
		end
	end
	if S.fullBright then setBright(true) end
	if S.speed then
		local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = S.customSpeed end
	end
	if S.fly then startFly() end
	if S.noclip then setNoClip(true) end
end)

print("HertaHub V3")
