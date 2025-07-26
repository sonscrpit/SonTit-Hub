-- 📦 Macro Menu Controller - Full UI + Auto Fish
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MacroController"

-- 👁️‍🗨️ Toggle Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 150, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "👁️ Hiện Menu Macro"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

-- 🧱 Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 420)
frame.Position = UDim2.new(0.5, -170, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "👁️ Ẩn Menu Macro" or "👁️ Hiện Menu Macro"
end)

-- 📋 Macro Data
local macroActions = {}
local macroLibrary = {}
local isRecording = false

-- 🎬 Record Button
local recordBtn = Instance.new("TextButton", frame)
recordBtn.Size = UDim2.new(0, 320, 0, 40)
recordBtn.Position = UDim2.new(0, 10, 0, 10)
recordBtn.Text = "🎬 Bắt đầu ghi Macro"
recordBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)

-- ▶️ Play Button
local playBtn = Instance.new("TextButton", frame)
playBtn.Size = UDim2.new(0, 320, 0, 40)
playBtn.Position = UDim2.new(0, 10, 0, 60)
playBtn.Text = "▶️ Chạy lại Macro"
playBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)

-- 🗑️ Delete Button
local deleteBtn = Instance.new("TextButton", frame)
deleteBtn.Size = UDim2.new(0, 320, 0, 40)
deleteBtn.Position = UDim2.new(0, 10, 0, 110)
deleteBtn.Text = "🗑️ Xoá Macro"
deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

-- 💾 Name Box
local nameBox = Instance.new("TextBox", frame)
nameBox.Size = UDim2.new(0, 320, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 160)
nameBox.PlaceholderText = "Tên Macro (ví dụ: GokuFarm)"
nameBox.Text = ""

-- 📥 Export Button
local exportBtn = Instance.new("TextButton", frame)
exportBtn.Size = UDim2.new(0, 320, 0, 40)
exportBtn.Position = UDim2.new(0, 10, 0, 200)
exportBtn.Text = "📥 Xuất nội dung Macro"
exportBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 50)

-- 📜 Dropdown chọn macro
local macroDropdown = Instance.new("TextButton", frame)
macroDropdown.Size = UDim2.new(0, 320, 0, 30)
macroDropdown.Position = UDim2.new(0, 10, 0, 250)
macroDropdown.Text = "🔽 Chọn macro để chạy"
macroDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- 📋 Action Counter
local actionLabel = Instance.new("TextLabel", frame)
actionLabel.Size = UDim2.new(0, 320, 0, 20)
actionLabel.Position = UDim2.new(0, 10, 0, 290)
actionLabel.Text = "📋 Số hành động đã ghi: 0"
actionLabel.TextColor3 = Color3.new(1, 1, 1)
actionLabel.BackgroundTransparency = 1

-- ⏬ Exported Text
local exportedTextLabel = Instance.new("TextLabel", frame)
exportedTextLabel.Size = UDim2.new(0, 320, 0, 100)
exportedTextLabel.Position = UDim2.new(0, 10, 0, 320)
exportedTextLabel.TextWrapped = true
exportedTextLabel.TextColor3 = Color3.new(1, 1, 1)
exportedTextLabel.BackgroundTransparency = 1
exportedTextLabel.Text = "⏬ Đoạn xuất sẽ hiện ở đây..."

-- 🎣 Auto Fish Toggle
spawn(function()
    while true do
        wait(12)
        pcall(function()
            local stuff = getrenv()._G.FireNetwork
            local id = player.UserId
            stuff("PlayerCatchFish", id)
            print("🎣 Đã câu cá tự động")
        end)
    end
end)

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

-- 🔘 Record Logic
recordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then
        macroActions = {}
        recordBtn.Text = "⏹️ Dừng ghi Macro"
        print("📽️ Đang ghi...")
    else
        recordBtn.Text = "🎬 Bắt đầu ghi Macro"
        local macroName = nameBox.Text ~= "" and nameBox.Text or "Macro_" .. tostring(os.time())
        macroLibrary[macroName] = table.clone(macroActions)
        macroDropdown.Text = "🔽 Chọn: " .. macroName
        print("✅ Đã lưu macro: " .. macroName)
    end
end)

-- ▶️ Play Logic
playBtn.MouseButton1Click:Connect(function()
    local selected = macroDropdown.Text:match("Chọn: (.+)")
    if not selected or not macroLibrary[selected] then return end
    local macroToPlay = macroLibrary[selected]
    local start = macroToPlay[1].time
    for _, act in ipairs(macroToPlay) do
        wait(act.time - start)
        print("▶️ Thực hiện: " .. act.type .. " | " .. act.unit)
        -- Ví dụ: placeTower:FireServer(act.unit, act.pos)
    end
end)

-- 🗑️ Delete Logic
deleteBtn.MouseButton1Click:Connect(function()
    macroActions = {}
    actionLabel.Text = "📋 Số hành động đã ghi: 0"
    print("🧹 Đã xoá sạch macro đã ghi!")
end)

-- 📥 Export Logic
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
