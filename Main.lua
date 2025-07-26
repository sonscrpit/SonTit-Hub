-- 📦 Macro Menu Controller for Roblox
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MacroController"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 340)
frame.Position = UDim2.new(0.5, -160, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

-- 📋 Macro data
local macroActions = {}
local isRecording = false

-- 🎬 RECORD button
local recordBtn = Instance.new("TextButton", frame)
recordBtn.Size = UDim2.new(0, 300, 0, 40)
recordBtn.Position = UDim2.new(0, 10, 0, 10)
recordBtn.Text = "🎬 Bắt đầu ghi Macro"
recordBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)

recordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then
        macroActions = {}
        recordBtn.Text = "⏹️ Dừng ghi Macro"
        print("🔴 Đang ghi...")
    else
        recordBtn.Text = "🎬 Bắt đầu ghi Macro"
        print("✅ Ghi xong " .. #macroActions .. " hành động")
    end
end)

-- ▶️ PLAY button
local playBtn = Instance.new("TextButton", frame)
playBtn.Size = UDim2.new(0, 300, 0, 40)
playBtn.Position = UDim2.new(0, 10, 0, 60)
playBtn.Text = "▶️ Chạy lại Macro"
playBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)

playBtn.MouseButton1Click:Connect(function()
    if #macroActions == 0 then return end
    local start = macroActions[1].time
    for _, act in ipairs(macroActions) do
        wait(act.time - start)
        print("🔄 Chạy lại: " .. act.type .. " | " .. act.unit)
        -- Tuỳ chỉnh tuỳ vào act.type: place / upgrade / wait...
        -- Ví dụ: placeTower:FireServer(act.unit, act.pos)
    end
end)

-- 🗑️ DELETE button
local deleteBtn = Instance.new("TextButton", frame)
deleteBtn.Size = UDim2.new(0, 300, 0, 40)
deleteBtn.Position = UDim2.new(0, 10, 0, 110)
deleteBtn.Text = "🗑️ Xoá Macro"
deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

deleteBtn.MouseButton1Click:Connect(function()
    macroActions = {}
    print("🧹 Đã xoá sạch macro đã ghi!")
end)

-- 💾 INPUT tên file
local nameBox = Instance.new("TextBox", frame)
nameBox.Size = UDim2.new(0, 300, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 160)
nameBox.PlaceholderText = "Nhập tên file: macro_goku.lua"
nameBox.Text = ""

-- 📥 EXPORT button
local exportBtn = Instance.new("TextButton", frame)
exportBtn.Size = UDim2.new(0, 300, 0, 40)
exportBtn.Position = UDim2.new(0, 10, 0, 200)
exportBtn.Text = "📥 Xuất nội dung Macro"
exportBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 50)

local exportedTextLabel = Instance.new("TextLabel", frame)
exportedTextLabel.Size = UDim2.new(0, 300, 0, 60)
exportedTextLabel.Position = UDim2.new(0, 10, 0, 250)
exportedTextLabel.TextWrapped = true
exportedTextLabel.TextColor3 = Color3.new(1, 1, 1)
exportedTextLabel.BackgroundTransparency = 1
exportedTextLabel.Text = "⏬ Đoạn xuất sẽ hiện ở đây..."

exportBtn.MouseButton1Click:Connect(function()
    local exportText = "return {\n"
    for _, act in ipairs(macroActions) do
        exportText = exportText .. string.format("  {time=%.3f, type=\"%s\", unit=\"%s\", pos=Vector3.new(%.1f, %.1f, %.1f)},\n",
            act.time, act.type, act.unit, act.pos.X, act.pos.Y, act.pos.Z)
    end
    exportText = exportText .. "}"
    exportedTextLabel.Text = exportText
    print("📤 Copy đoạn trên vào file GitHub: " .. nameBox.Text)
end)

-- 🧮 Hiển thị số lượng hành động
local actionLabel = Instance.new("TextLabel", frame)
actionLabel.Size = UDim2.new(0, 300, 0, 20)
actionLabel.Position = UDim2.new(0, 10, 0, 320)
actionLabel.Text = "📋 Số hành động đã ghi: 0"
actionLabel.TextColor3 = Color3.new(1, 1, 1)
actionLabel.BackgroundTransparency = 1

-- 🎯 Ghi hành động demo mỗi 4s
spawn(function()
    while true do
        wait(4)
        if isRecording then
            table.insert(macroActions, {
                time = tick(),
                type = "place",
                unit = "Goku",
                pos = Vector3.new(10, 0, 10)
            })
            actionLabel.Text = "📋 Số hành động đã ghi: " .. #macroActions
        end
    end
end)
