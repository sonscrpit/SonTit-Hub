-- Auto Record Script for UTD by Son
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({Name = "Auto Tower Recorder 🏰", HidePremium = false, SaveConfig = true, ConfigFolder = "SonConfig"})

local isRecording = false
local recordedActions = {}

-- Tạo tab và nút
local MainTab = Window:MakeTab({
    Name = "Chính",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddButton({
    Name = "🎬 Bật/Tắt Ghi lại",
    Callback = function()
        isRecording = not isRecording
        if isRecording then
            recordedActions = {}
            OrionLib:MakeNotification({
                Name = "🎥 Recording",
                Content = "Đang ghi lại hành động...",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "✅ Xong!",
                Content = "Đã lưu " .. #recordedActions .. " hành động",
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

-- Hàm giả định để đặt tower (cần chỉnh lại đúng với UTD)
function placeTower(name, pos)
    -- Thay bằng API đặt tower của game
    print("Đặt tower:", name, "vị trí:", pos)
end

-- Hook vào sự kiện đặt tower
-- Cần tìm sự kiện đặt tower của game để gắn vào (giả định dưới đây)
local function onPlaceTower(towerName, towerPosition)
    if isRecording then
        table.insert(recordedActions, {
            name = towerName,
            pos = towerPosition
        })
    end
end

-- Gợi ý: Hook vào remote event đặt tower (nếu tìm được)
-- Ví dụ: game.ReplicatedStorage.PlaceTower.OnClientEvent:Connect(onPlaceTower)

OrionLib:Init()
