--✅ UTD Auto Script UI by sonscrpit
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "UTD Auto Script 🎮",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UTDConfig"
})

local MainTab = Window:MakeTab({
    Name = "Chức năng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local isRecording = false
local recordedActions = {}

MainTab:AddButton({
    Name = "🎬 Ghi lại hành động",
    Callback = function()
        isRecording = not isRecording
        if isRecording then
            recordedActions = {}
            OrionLib:MakeNotification({
                Name = "🎥 Đang ghi...",
                Content = "Đặt tower để lưu",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "✅ Hoàn tất",
                Content = "Ghi xong " .. #recordedActions .. " hành động",
                Time = 3
            })
        end
    end
})

MainTab:AddButton({
    Name = "▶️ Phát lại hành động",
    Callback = function()
        for i, action in ipairs(recordedActions) do
            placeTower(action.name, action.pos)
            wait(1)
        end
    end
})

function placeTower(name, pos)
    print("Đặt tower:", name, "vị trí:", pos)
    -- Chỗ này cần thay bằng Remote đặt tower thật của game
end

function onPlaceTower(towerName, towerPos)
    if isRecording then
        table.insert(recordedActions, {name = towerName, pos = towerPos})
    end
end

-- Gợi ý: Tìm đúng RemoteEvent của game để kết nối vào
-- Ví dụ:
-- game.ReplicatedStorage.PlaceTower.OnClientEvent:Connect(onPlaceTower)

OrionLib:Init()
