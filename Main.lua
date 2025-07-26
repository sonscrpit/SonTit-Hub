-- 🔥 SonHub Full Script for UTD (KRNL Mobile Compatible)
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("SonUI") then
    CoreGui.SonUI:Destroy()
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "SonUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 410)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "🛠️ SonHub - UTD Full Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local y = 50
local function createButton(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 40
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- ✅ Logic chức năng
local autoPlace, autoWave, autoReward, autoFish = false, false, false, false
local isRecording = false
local recorded = {}

createButton("⚔️ Auto Place Tower", function()
    autoPlace = not autoPlace
    spawn(function()
        while autoPlace do
            local args = {"Goku", Vector3.new(10, 0, 10)} -- sửa lại tên và tọa độ tower nếu cần
            game.ReplicatedStorage.PlaceTower:FireServer(unpack(args))
            wait(3)
        end
    end)
end)

createButton("💰 Auto Collect Reward", function()
    autoReward = not autoReward
    spawn(function()
        while autoReward do
            if game.ReplicatedStorage:FindFirstChild("Rewards") then
                game.ReplicatedStorage.Rewards:FireServer()
            end
            wait(6)
        end
    end)
end)

createButton("⏭️ Auto Skip Wave", function()
    autoWave = not autoWave
    spawn(function()
        while autoWave do
            game.ReplicatedStorage.VoteStart:FireServer()
            wait(8)
        end
    end)
end)

createButton("🎣 Auto Câu Cá", function()
    autoFish = not autoFish
    spawn(function()
        while autoFish do
            local remote = game.ReplicatedStorage:FindFirstChild("Fishing")
            if remote then
                remote:FireServer("StartFishing")
                wait(2)
                remote:FireServer("CatchFish")
                wait(4)
            else
                print("❌ Không tìm thấy remote Fishing")
                wait(5)
            end
        end
    end)
end)

createButton("🎬 Bật/Tắt Ghi lại", function()
    isRecording = not isRecording
    if isRecording then
        recorded = {}
        print("🎥 Bắt đầu ghi...")
    else
        print("✅ Dừng ghi. Số hành động:", #recorded)
    end
end)

createButton("▶️ Phát lại hành động", function()
    for _, data in ipairs(recorded) do
        game.ReplicatedStorage.PlaceTower:FireServer(data.name, data.pos)
        wait(1)
    end
end)

-- 🔁 Hook sự kiện giả lập để ghi lại đặt tower (nếu có)
game.ReplicatedStorage.PlaceTower.OnClientEvent:Connect(function(name, pos)
    if isRecording then
        table.insert(recorded, {name = name, pos = pos})
    end
end)
