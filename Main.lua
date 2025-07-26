-- ✅ Ultimate Tower Defense Script by Son (KRNL Mobile Compatible)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UTD_AutoGui"

local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(callback)
end

-- 🧠 Biến toàn cục
local autoPlace = false
local autoUpgrade = false
local autoSkip = false
local autoFish = false
local isRecording = false
local recordedActions = {}

local RS = game:GetService("ReplicatedStorage")
local towerName = "Minato"  -- 🔁 Bạn có thể thay bằng tower bạn có
local towerPos = Vector3.new(10, 2, 15)

-- 🟢 Bật/Tắt Auto đặt tower
createButton("📍 Auto Đặt Tower", 0.05, function()
    autoPlace = not autoPlace
    if autoPlace then
        print("✅ Auto Place ON")
        spawn(function()
            while autoPlace do
                RS.PlaceTower:InvokeServer(towerName, towerPos)
                wait(10)
            end
        end)
    else
        print("⛔ Auto Place OFF")
    end
end)

-- 🆙 Auto Nâng cấp tower
createButton("⏫ Auto Upgrade", 0.15, function()
    autoUpgrade = not autoUpgrade
    if autoUpgrade then
        print("✅ Auto Upgrade ON")
        spawn(function()
            while autoUpgrade do
                for _, tower in pairs(workspace.Towers:GetChildren()) do
                    if tower.Owner.Value == game.Players.LocalPlayer then
                        RS.UpgradeTower:InvokeServer(tower)
                    end
                end
                wait(5)
            end
        end)
    else
        print("⛔ Auto Upgrade OFF")
    end
end)

-- ⏭️ Auto Skip Wave
createButton("⏭️ Auto Skip Wave", 0.25, function()
    autoSkip = not autoSkip
    if autoSkip then
        print("✅ Auto Skip ON")
        spawn(function()
            while autoSkip do
                RS.SkipWave:FireServer()
                wait(5)
            end
        end)
    else
        print("⛔ Auto Skip OFF")
    end
end)

-- 🎣 Auto Câu Cá (nếu game có hệ thống)
createButton("🎣 Auto Câu Cá", 0.35, function()
    autoFish = not autoFish
    if autoFish then
        print("✅ Auto Fish ON")
        spawn(function()
            while autoFish do
                -- Đây là ví dụ, cần sửa theo đúng Remote của game nếu có
                RS.FishEvent:FireServer("Cast")
                wait(3)
                RS.FishEvent:FireServer("Reel")
                wait(2)
            end
        end)
    else
        print("⛔ Auto Fish OFF")
    end
end)

-- 🎬 Bật/Tắt Ghi hành động
createButton("🎬 Ghi Hành Động", 0.45, function()
    isRecording = not isRecording
    if isRecording then
        recordedActions = {}
        print("📹 Bắt đầu ghi lại hành động...")
    else
        print("📝 Dừng ghi. Đã lưu:", #recordedActions, "hành động.")
    end
end)

-- ▶️ Phát lại
createButton("▶️ Phát Lại", 0.55, function()
    for _, action in ipairs(recordedActions) do
        RS.PlaceTower:InvokeServer(action.name, action.pos)
        wait(1)
    end
end)

-- Ghi lại khi bạn đặt tower (giả định bạn gắn đúng vị trí code này nếu hook được)
function recordTower(name, pos)
    if isRecording then
        table.insert(recordedActions, {
            name = name,
            pos = pos
        })
        print("📌 Ghi:", name, pos)
    end
end

print("✅ UTD Script đã load thành công!")
