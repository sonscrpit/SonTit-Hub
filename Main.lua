-- 📦 SonHub - UTD Simple Script (Mobile Friendly)
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local autoPlace, autoWave, autoReward, isRecording = false, false, false, false
local recorded = {}

createButton("⚔️ Auto Place Tower", 10, function()
	autoPlace = not autoPlace
	spawn(function()
		while autoPlace do
			local args = {"Goku", Vector3.new(10, 0, 10)} -- sửa tower và vị trí nếu muốn
			game.ReplicatedStorage.PlaceTower:FireServer(unpack(args))
			wait(3)
		end
	end)
end)

createButton("💰 Auto Reward", 50, function()
	autoReward = not autoReward
	spawn(function()
		while autoReward do
			game.ReplicatedStorage.Rewards:FireServer()
			wait(5)
		end
	end)
end)

createButton("⏭️ Auto Skip Wave", 90, function()
	autoWave = not autoWave
	spawn(function()
		while autoWave do
			game.ReplicatedStorage.VoteStart:FireServer()
			wait(6)
		end
	end)
end)

createButton("🎬 Bật/Tắt Ghi lại", 130, function()
	isRecording = not isRecording
	if isRecording then
		recorded = {}
	end
end)

createButton("▶️ Phát lại", 170, function()
	for _, data in ipairs(recorded) do
		game.ReplicatedStorage.PlaceTower:FireServer(data.name, data.pos)
		wait(1)
	end
end)

-- Hook giả để record tower nếu có sự kiện
game.ReplicatedStorage.PlaceTower.OnClientEvent:Connect(function(name, pos)
	if isRecording then
		table.insert(recorded, {name = name, pos = pos})
	end
end)
