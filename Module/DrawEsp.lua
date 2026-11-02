local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local cache = {}

local bones = {
	{"Head", "UpperTorso"},
	{"UpperTorso", "RightUpperArm"},
	{"RightUpperArm", "RightLowerArm"},
	{"RightLowerArm", "RightHand"},
	{"UpperTorso", "LeftUpperArm"},
	{"LeftUpperArm", "LeftLowerArm"},
	{"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "LowerTorso"},
	{"LowerTorso", "LeftUpperLeg"},
	{"LeftUpperLeg", "LeftLowerLeg"},
	{"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"},
	{"RightUpperLeg", "RightLowerLeg"},
	{"RightLowerLeg", "RightFoot"}
}

local cfg = {
	["BoxOutlineColor"] = Color3.new(0, 0, 0),
	["BoxColor"] = Color3.new(1, 1, 1),
	["NameColor"] = Color3.new(1, 1, 1),
	["HealthOutlineColor"] = Color3.new(0, 0, 0),
	["HealthHighColor"] = Color3.new(0, 1, 0),
	["HealthLowColor"] = Color3.new(1, 0, 0),
	["SkeletonsColor"] = Color3.new(1, 1, 1),
	["Teamcheck"] = true,
	["WallCheck"] = false,
	["Enabled"] = true,
	["ShowBox"] = false,
	["BoxType"] = "2D",
	["ShowName"] = false,
	["ShowHealth"] = false,
	["ShowDistance"] = false,
	["ShowSkeletons"] = false,
}

local function create(class, props)
	local d = Drawing.new(class)
	for k, v in pairs(props) do
		d[k] = v
	end
	return d
end

local function createEsp(plr)
	local esp = {
		["boxOutline"] = create("Square", {
			Color = cfg["BoxOutlineColor"],
			Thickness = 1,
			Filled = false,
			Transparency = 0.55
		}),
		["box"] = create("Square", {
			Color = cfg["BoxColor"],
			Thickness = 1,
			Filled = false,
			Transparency = 0.2
		}),
		["name"] = create("Text", {
			Color = cfg["NameColor"],
			Outline = true,
			Center = true,
			Size = 13,
			Transparency = 0.25
		}),
		["healthOutline"] = create("Square", {
			Color = cfg["HealthOutlineColor"],
			Thickness = 1,
			Filled = true,
			Transparency = 0.5
		}),
		["health"] = create("Square", {
			Thickness = 1,
			Filled = true,
			Transparency = 0.1
		}),
		["distance"] = create("Text", {
			Color = Color3.new(1, 1, 1),
			Size = 12,
			Outline = true,
			Center = true,
			Transparency = 0.25
		}),
		["boxLines"] = {},
		["skeletonlines"] = {}
	}
	cache[plr] = esp
end

local function isBehindWall(plr)
	local char = plr.Character
	if not char then return false end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	local origin = cam.CFrame.Position
	local dir = (root.Position - origin)
	local ray = Ray.new(origin, dir.Unit * dir.Magnitude)
	local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, char})
	return hit and hit:IsA("BasePart")
end

local function removeEsp(plr)
	local esp = cache[plr]
	if not esp then return end
	for _, d in pairs(esp) do
		if typeof(d) == "table" then
			for _, v in pairs(d) do
				if typeof(v) == "table" then
					v[1]:Remove()
				else
					v:Remove()
				end
			end
		elseif d.Remove then
			d:Remove()
		end
	end
	cache[plr] = nil
end

local function clearDrawings(esp)
	for _, d in pairs(esp) do
		if type(d) == "userdata" and d.Visible ~= nil then
			d.Visible = false
		end
	end
	for _, data in ipairs(esp["skeletonlines"]) do
		data[1]:Remove()
	end
	esp["skeletonlines"] = {}
	for _, line in ipairs(esp["boxLines"]) do
		line:Remove()
	end
	esp["boxLines"] = {}
end

local function updateEsp()
	for plr, esp in pairs(cache) do
		local char = plr.Character
		local team = plr.Team

		if not char or (cfg["Teamcheck"] and team and team == lp.Team) then
			clearDrawings(esp)
			continue
		end

		local root = char:FindFirstChild("HumanoidRootPart")
		local head = char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		local behind = cfg["WallCheck"] and isBehindWall(plr)
		local show = cfg["Enabled"] and not behind

		if not (root and head and hum and show) then
			clearDrawings(esp)
			continue
		end

		local pos, onScreen = cam:WorldToViewportPoint(root.Position)
		if not onScreen then
			clearDrawings(esp)
			continue
		end

		local hrp2D = cam:WorldToViewportPoint(root.Position)
		local top = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 2.6, 0))
		local bottom = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
		local charSize = (bottom.Y - top.Y) / 2
		local boxSize = Vector2.new(math.floor(charSize * 1.8), math.floor(charSize * 1.9))
		local boxPos = Vector2.new(math.floor(hrp2D.X - boxSize.X / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

		if cfg["ShowName"] then
			esp["name"].Visible = true
			esp["name"].Text = string.lower(plr.Name)
			esp["name"].Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y - 16)
			esp["name"].Color = cfg["NameColor"]
			esp["name"].Transparency = 0.25
		else
			esp["name"].Visible = false
		end

		if cfg["ShowBox"] then
			if cfg["BoxType"] == "2D" then
				esp["boxOutline"].Size = boxSize
				esp["boxOutline"].Position = boxPos
				esp["boxOutline"].Thickness = 1
				esp["boxOutline"].Transparency = 0.55
				esp["box"].Size = boxSize
				esp["box"].Position = boxPos
				esp["box"].Color = cfg["BoxColor"]
				esp["box"].Thickness = 1
				esp["box"].Transparency = 0.2
				esp["box"].Visible = true
				esp["boxOutline"].Visible = true
				for _, line in ipairs(esp["boxLines"]) do
					line:Remove()
				end
				esp["boxLines"] = {}
			elseif cfg["BoxType"] == "Corner Box Esp" then
				local w = boxSize.X / 5
				local h = boxSize.Y / 6
				local t = 1

				if #esp["boxLines"] == 0 then
					for i = 1, 16 do
						esp["boxLines"][i] = create("Line", {
							Thickness = 1,
							Color = cfg["BoxColor"],
							Transparency = 0.25
						})
					end
				end

				local lines = esp["boxLines"]

				lines[1].From = Vector2.new(boxPos.X - t, boxPos.Y - t)
				lines[1].To = Vector2.new(boxPos.X + w, boxPos.Y - t)
				lines[2].From = Vector2.new(boxPos.X - t, boxPos.Y - t)
				lines[2].To = Vector2.new(boxPos.X - t, boxPos.Y + h)

				lines[3].From = Vector2.new(boxPos.X + boxSize.X - w, boxPos.Y - t)
				lines[3].To = Vector2.new(boxPos.X + boxSize.X + t, boxPos.Y - t)
				lines[4].From = Vector2.new(boxPos.X + boxSize.X + t, boxPos.Y - t)
				lines[4].To = Vector2.new(boxPos.X + boxSize.X + t, boxPos.Y + h)

				lines[5].From = Vector2.new(boxPos.X - t, boxPos.Y + boxSize.Y - h)
				lines[5].To = Vector2.new(boxPos.X - t, boxPos.Y + boxSize.Y + t)
				lines[6].From = Vector2.new(boxPos.X - t, boxPos.Y + boxSize.Y + t)
				lines[6].To = Vector2.new(boxPos.X + w, boxPos.Y + boxSize.Y + t)

				lines[7].From = Vector2.new(boxPos.X + boxSize.X - w, boxPos.Y + boxSize.Y + t)
				lines[7].To = Vector2.new(boxPos.X + boxSize.X + t, boxPos.Y + boxSize.Y + t)
				lines[8].From = Vector2.new(boxPos.X + boxSize.X + t, boxPos.Y + boxSize.Y - h)
				lines[8].To = Vector2.new(boxPos.X + boxSize.X + t, boxPos.Y + boxSize.Y + t)

				for i = 9, 16 do
					lines[i].Thickness = 1
					lines[i].Color = cfg["BoxOutlineColor"]
					lines[i].Transparency = 0.55
				end

				lines[9].From = Vector2.new(boxPos.X, boxPos.Y)
				lines[9].To = Vector2.new(boxPos.X, boxPos.Y + h)
				lines[10].From = Vector2.new(boxPos.X, boxPos.Y)
				lines[10].To = Vector2.new(boxPos.X + w, boxPos.Y)
				lines[11].From = Vector2.new(boxPos.X + boxSize.X - w, boxPos.Y)
				lines[11].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y)
				lines[12].From = Vector2.new(boxPos.X + boxSize.X, boxPos.Y)
				lines[12].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + h)
				lines[13].From = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y - h)
				lines[13].To = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y)
				lines[14].From = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y)
				lines[14].To = Vector2.new(boxPos.X + w, boxPos.Y + boxSize.Y)
				lines[15].From = Vector2.new(boxPos.X + boxSize.X - w, boxPos.Y + boxSize.Y)
				lines[15].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y)
				lines[16].From = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y - h)
				lines[16].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y)

				for _, line in ipairs(lines) do
					line.Visible = true
					line.Thickness = 1
				end
				esp["box"].Visible = false
				esp["boxOutline"].Visible = false
			end
		else
			esp["box"].Visible = false
			esp["boxOutline"].Visible = false
			for _, line in ipairs(esp["boxLines"]) do
				line:Remove()
			end
			esp["boxLines"] = {}
		end

		if cfg["ShowHealth"] then
			local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
			local barH = boxSize.Y
			local barW = 2
			local x = boxPos.X - 6
			local y = boxPos.Y

			esp["healthOutline"].Visible = true
			esp["health"].Visible = true

			esp["healthOutline"].Size = Vector2.new(barW + 2, barH)
			esp["healthOutline"].Position = Vector2.new(x - 1, y)
			esp["healthOutline"].Color = cfg["HealthOutlineColor"]
			esp["healthOutline"].Transparency = 0.5

			esp["health"].Size = Vector2.new(barW, barH * pct)
			esp["health"].Position = Vector2.new(x, y + barH * (1 - pct))
			esp["health"].Color = cfg["HealthLowColor"]:Lerp(cfg["HealthHighColor"], pct)
			esp["health"].Transparency = 0.1
		else
			esp["healthOutline"].Visible = false
			esp["health"].Visible = false
		end

		if cfg["ShowDistance"] then
			local dist = (cam.CFrame.Position - root.Position).Magnitude
			esp["distance"].Text = string.format("%.1f studs", dist)
			esp["distance"].Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 5)
			esp["distance"].Visible = true
			esp["distance"].Transparency = 0.25
		else
			esp["distance"].Visible = false
		end

		if cfg["ShowSkeletons"] then
			if #esp["skeletonlines"] == 0 then
				for _, pair in ipairs(bones) do
					local a, b = pair[1], pair[2]
					if char:FindFirstChild(a) and char:FindFirstChild(b) then
						local line = create("Line", {
							Thickness = 1,
							Color = cfg["SkeletonsColor"],
							Transparency = 0.4
						})
						table.insert(esp["skeletonlines"], {line, a, b})
					end
				end
			end

			for _, data in ipairs(esp["skeletonlines"]) do
				local line, a, b = data[1], data[2], data[3]
				local p1 = char:FindFirstChild(a)
				local p2 = char:FindFirstChild(b)
				if p1 and p2 then
					local from = cam:WorldToViewportPoint(p1.Position)
					local to = cam:WorldToViewportPoint(p2.Position)
					line.From = Vector2.new(from.X, from.Y)
					line.To = Vector2.new(to.X, to.Y)
					line.Color = cfg["SkeletonsColor"]
					line.Thickness = 1
					line.Transparency = 0.4
					line.Visible = true
				else
					line.Visible = false
				end
			end
		else
			for _, data in ipairs(esp["skeletonlines"]) do
				data[1]:Remove()
			end
			esp["skeletonlines"] = {}
		end
	end
end

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= lp then
		createEsp(plr)
	end
end

Players.PlayerAdded:Connect(function(plr)
	if plr ~= lp then
		createEsp(plr)
	end
end)

Players.PlayerRemoving:Connect(removeEsp)
RunService.RenderStepped:Connect(updateEsp)

return cfg
