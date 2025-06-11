local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local allowedVersions = { "1332", "1333", "1334", "1335", "1336" }

-- GUI setup
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ServerFinderGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 120)
frame.Position = UDim2.new(0.5, -120, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -20, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
btn.Text = "Find Version 1332–1336"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.new(0, 10, 0, 60)
status.BackgroundTransparency = 1
status.Text = "Waiting..."
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.Gotham
status.TextSize = 14

-- Search and retry logic
local function findServer()
	local cursor = ""
	while true do
		local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?limit=100&cursor=%s", placeId, cursor)
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)

		if success and result and result.data then
			for _, server in ipairs(result.data) do
				for _, version in ipairs(allowedVersions) do
					if string.find(server.id, version) and server.playing < server.maxPlayers then
						return server.id
					end
				end
			end
			if result.nextPageCursor then
				cursor = result.nextPageCursor
			else
				break
			end
		else
			status.Text = "⚠️ Failed to fetch servers."
			return nil
		end
		wait(0.5)
	end
	return nil
end

btn.MouseButton1Click:Connect(function()
	btn.Text = "Searching..."
	btn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

	while true do
		status.Text = "Searching for versions 1332–1336..."
		local jobId = findServer()

		if jobId then
			status.Text = "✅ Found! Teleporting..."
			btn.Text = "Joining..."
			local success, err = pcall(function()
				TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
			end)
			if not success then
				status.Text = "⚠️ Teleport failed. Retrying..."
				wait(3)
			else
				break
			end
		else
			status.Text = "❌ No servers with versions 1332–1336. Retrying..."
			wait(5)
		end
	end
end)
