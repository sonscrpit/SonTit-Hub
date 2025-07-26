-- 🔥 Ultimate Tower Defense | SonScript Full GUI 🔥
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "🛡️ SonHub - UTD Script", HidePremium = false, SaveConfig = true, ConfigFolder = "SonUTD"})

local MainTab = Window:MakeTab({Name = "🌟 Chức năng chính", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local RecordTab = Window:MakeTab({Name = "🎬 Ghi lại", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- 🔄 Auto Place Tower
MainTab:AddToggle({
	Name = "⚔️ Tự đặt Tower",
	Default = false,
	Callback = function(val)
		getgenv().autoPlace = val
		while getgenv().autoPlace do
			-- Gọi API đặt tower tại vị trí giả định
			local args = {"Goku", Vector3.new(10,0,10)}
			game.ReplicatedStorage.PlaceTower:FireServer(unpack(args))
			wait(3)
		end
	end
})

-- 💰 Auto Collect Reward
MainTab:AddToggle({
	Name = "💰 Tự thu phần thưởng",
	Default = false,
	Callback = function(val)
		getgenv().autoReward = val
		while getgenv().autoReward do
			game.ReplicatedStorage.Rewards:FireServer()
			wait(5)
		end
	end
})

-- ⏭️ Auto Skip Wave
MainTab:AddToggle({
	Name = "⏭️ Tự qua wave",
	Default = false,
	Callback = function(val)
		getgenv().autoWave = val
		while getgenv().autoWave do
			game.ReplicatedStorage.VoteStart:FireServer()
			wait(7)
		end
	end
})

-- 🎣 Auto Câu Cá (nếu có minigame câu cá)
MainTab:AddToggle({
	Name = "🎣 Tự động câu cá",
	Default = false,
	Callback = function(val)
		getgenv().autoFish = val
		while getgenv().autoFish do
			pcall(function()
				-- Thay bằng remote thật của mini-game câu cá nếu có
				game.ReplicatedStorage.FishingEvent:FireServer()
			end)
			wait(4)
		end
	end
})

-- 🎥 Record & Replay đặt tower
local isRecording = false
local recorded = {}

RecordTab:AddButton({
	Name = "🎬 Bật/Tắt Ghi lại",
	Callback = function()
		isRecording = not isRecording
		if isRecording then
			recorded = {}
			OrionLib:MakeNotification({
				Name = "Ghi lại",
				Content = "Đang ghi các hành động...",
				Time = 3
			})
		else
			OrionLib:MakeNotification({
				Name = "Dừng ghi",
				Content = "Đã lưu " .. #recorded .. " hành động",
				Time = 3
			})
		end
	end
})

RecordTab:AddButton({
	Name = "▶️ Phát lại hành động",
	Callback = function()
		for i, data in ipairs(recorded) do
			game.ReplicatedStorage.PlaceTower:FireServer(data.name, data.pos)
			wait(1)
		end
	end
})

-- 🔁 Hook sự kiện đặt tower
game.ReplicatedStorage.PlaceTower.OnClientEvent:Connect(function(towerName, towerPosition)
	if isRecording then
		table.insert(recorded, {name = towerName, pos = towerPosition})
	end
end)

OrionLib:Init()
