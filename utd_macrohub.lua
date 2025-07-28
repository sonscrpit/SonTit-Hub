-- ✅ Full Macro Record + Replay hệ thống cho Ultimate Tower Defense
-- 🔧 UI tùy chỉnh không dùng Rayfield + Tự động lưu khi tắt Record

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Macro dữ liệu
local MacroList = {}
local currentMacro = nil
local isRecording = false
local isReplaying = false
local startTime = 0

-- File lưu macro (chỉ dùng nếu chạy qua executor hỗ trợ writefile)
local function saveMacros()
    if isfile and writefile then
        local data = HttpService:JSONEncode(MacroList)
        writefile("utd_macros.json", data)
        print("✅ Đã lưu macro vào utd_macros.json")
    end
end

local function loadMacros()
    if isfile and readfile and isfile("utd_macros.json") then
        local content = readfile("utd_macros.json")
        local ok, data = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if ok and type(data) == "table" then
            MacroList = data
            print("✅ Đã tải macro từ file")
        end
    end
end

loadMacros()

-- UI khởi tạo
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "MacroUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "UTD Macro System"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local dropdown = Instance.new("TextButton", mainFrame)
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.Text = "Chọn Macro"
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 55)

local nameBox = Instance.new("TextBox", mainFrame)
nameBox.PlaceholderText = "Tên Macro mới"
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 80)
nameBox.Text = ""
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local createBtn = Instance.new("TextButton", mainFrame)
createBtn.Size = UDim2.new(1, -20, 0, 30)
createBtn.Position = UDim2.new(0, 10, 0, 120)
createBtn.Text = "Tạo Macro"
createBtn.TextColor3 = Color3.new(1, 1, 1)
createBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)

local recordBtn = Instance.new("TextButton", mainFrame)
recordBtn.Size = UDim2.new(1, -20, 0, 30)
recordBtn.Position = UDim2.new(0, 10, 0, 160)
recordBtn.Text = "Bắt đầu Ghi"
recordBtn.TextColor3 = Color3.new(1, 1, 1)
recordBtn.BackgroundColor3 = Color3.fromRGB(90, 45, 45)

local replayBtn = Instance.new("TextButton", mainFrame)
replayBtn.Size = UDim2.new(1, -20, 0, 30)
replayBtn.Position = UDim2.new(0, 10, 0, 200)
replayBtn.Text = "Phát lại Macro"
replayBtn.TextColor3 = Color3.new(1, 1, 1)
replayBtn.BackgroundColor3 = Color3.fromRGB(45, 90, 45)

local stopBtn = Instance.new("TextButton", mainFrame)
stopBtn.Size = UDim2.new(1, -20, 0, 30)
stopBtn.Position = UDim2.new(0, 10, 0, 240)
stopBtn.Text = "Dừng Replay"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.BackgroundColor3 = Color3.fromRGB(90, 45, 45)

local function updateDropdown()
    dropdown.Text = currentMacro or "Chọn Macro"
end

createBtn.MouseButton1Click:Connect(function()
    local name = nameBox.Text
    if name ~= "" and not MacroList[name] then
        MacroList[name] = {}
        currentMacro = name
        updateDropdown()
        saveMacros()
    end
end)

dropdown.MouseButton1Click:Connect(function()
    print("Dropdown clicked: chưa có menu lựa chọn")
end)

recordBtn.MouseButton1Click:Connect(function()
    if not currentMacro then return end
    isRecording = not isRecording
    if isRecording then
        MacroList[currentMacro] = {}
        startTime = os.clock()
        recordBtn.Text = "Đang Ghi..."
    else
        recordBtn.Text = "Bắt đầu Ghi"
        saveMacros()
    end
end)

replayBtn.MouseButton1Click:Connect(function()
    if not currentMacro or #MacroList[currentMacro] == 0 then return end
    isReplaying = true
    local replayStart = os.clock()
    for _, action in ipairs(MacroList[currentMacro]) do
        if not isReplaying then break end
        local now = os.clock() - replayStart
        local waitTime = action.delay - now
        if waitTime > 0 then task.wait(waitTime) end
        pcall(function()
            ReplicatedStorage:WaitForChild("GenericModules")
                :WaitForChild("Service")
                :WaitForChild("Network")
                :WaitForChild("PlayerPlaceTower")
                :FireServer(action.id, action.pos, action.rot)
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isReplaying = false
end)

local oldNamecall;
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if isRecording and tostring(self) == "PlayerPlaceTower" and method == "FireServer" then
        table.insert(MacroList[currentMacro], {
            id = args[1],
            pos = args[2],
            rot = args[3],
            delay = os.clock() - startTime
        })
    end
    return oldNamecall(self, ...)
end)
