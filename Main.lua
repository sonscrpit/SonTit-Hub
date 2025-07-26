-- ⚔️ SonHub UTD Full Script - Rayfield UI (No Orion)
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "🛡️ SonHub - UTD Script (Rayfield UI)",
    LoadingTitle = "Đang khởi động...",
    LoadingSubtitle = "Ultimate Tower Defense",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "SonUTDConfig",
       FileName = "UTDSave"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

-- 🌟 Tabs
local MainTab = Window:CreateTab("📜 Chức năng chính", 4483345998)
local RecordTab = Window:CreateTab("🎬 Ghi hành động", 4483345998)

-- 🌟 Biến toàn cục
getgenv().autoPlace = false
getgenv().autoReward = false
getgenv().autoWave = false
getgenv().autoFish = false
local isRecording = false
local recorded = {}

-- ⚔️ Auto Place Tower
MainTab:CreateToggle({
    Name = "⚔️ Tự đặt Tower",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().autoPlace = Value
        while getgenv().autoPlace do
            pcall(function()
                local args = {"Goku", Vector3.new(10,0,10)} -- Thay tower & vị trí nếu cần
                game.ReplicatedStorage.PlaceTower:FireServer(unpack(args))
            end)
            wait(3)
        end
    end,
})

-- 💰 Auto Collect Reward
MainTab:CreateToggle({
    Name = "💰 Tự thu phần thưởng",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().autoReward = Value
        while getgenv().autoReward do
            pcall(function()
                game.ReplicatedStorage.Rewards:FireServer()
            end)
            wait(5)
        end
    end,
})

-- ⏭️ Auto Skip Wave
MainTab:CreateToggle({
    Name = "⏭️ Tự qua wave",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().autoWave = Value
        while getgenv().autoWave do
            pcall(function()
                game.ReplicatedStorage.VoteStart:FireServer()
            end)
            wait(6)
        end
    end,
})

-- 🎣 Auto Fishing (nếu có)
MainTab:CreateToggle({
    Name = "🎣 Tự động câu cá",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().autoFish = Value
        while getgenv().autoFish do
            pcall(function()
                game.ReplicatedStorage.FishingEvent:FireServer()
            end)
            wait(4)
        end
    end,
})

-- 🎬 Record
RecordTab:CreateButton({
    Name = "🎬 Bật/Tắt Ghi lại hành động",
    Callback = function()
        isRecording = not isRecording
        if isRecording then
            recorded = {}
            Rayfield:Notify({
                Title = "Ghi lại",
                Content = "Bắt đầu ghi hành động...",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Hoàn tất",
                Content = "Đã lưu " .. tostring(#recorded) .. " hành động.",
                Duration = 4
            })
        end
    end,
})

RecordTab:CreateButton({
    Name = "▶️ Phát lại hành động",
    Callback = function()
        for i, data in ipairs(recorded) do
            game.ReplicatedStorage.PlaceTower:FireServer(data.name, data.pos)
            wait(1)
        end
    end,
})

-- 📌 Hook đặt tower (tùy game, có thể cần sửa)
game.ReplicatedStorage.PlaceTower.OnClientEvent:Connect(function(towerName, towerPosition)
    if isRecording then
        table.insert(recorded, {
            name = towerName,
            pos = towerPosition
        })
    end
end)
