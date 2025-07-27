--// UTD Macro Hub - By ChatGPT 😎
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local macroFolder = "UTD_Macros"
if not isfolder(macroFolder) then
    makefolder(macroFolder)
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "UTD_MacroHub"

local openBtn = Instance.new("TextButton", ScreenGui)
openBtn.Text = "📦"
openBtn.Position = UDim2.new(0, 10, 0.5, -50)
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.ZIndex = 5

local main = Instance.new("Frame", ScreenGui)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.Size = UDim2.new(0, 400, 0, 300)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

local tabs = Instance.new("Folder", main)
tabs.Name = "Tabs"

local function createTab(name)
    local tab = Instance.new("Frame", tabs)
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.Visible = false
    tab.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", tab)
    layout.Padding = UDim.new(0, 5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    return tab
end

local macroTab = createTab("Macro")
macroTab.Visible = true

local tabButtonsFrame = Instance.new("Frame", main)
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
tabLayout.FillDirection = Enum.FillDirection.Horizontal

local function addTabButton(name)
    local btn = Instance.new("TextButton", tabButtonsFrame)
    btn.Text = name
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(tabs:GetChildren()) do v.Visible = false end
        tabs[name].Visible = true
    end)
end

addTabButton("Macro")

-- Macro Logic
local recording = false
local macroData = {}
local recordStart = 0
local selectedSlot = 1

local function recordStep(slot, position, time)
    table.insert(macroData, {slot = slot, pos = position, t = time})
end

local function saveMacro(slot)
    local json = HttpService:JSONEncode(macroData)
    writefile(macroFolder.."/macro"..slot..".json", json)
end

local function loadMacro(slot)
    local path = macroFolder.."/macro"..slot..".json"
    if isfile(path) then
        local data = readfile(path)
        return HttpService:JSONDecode(data)
    else
        return nil
    end
end

local function playMacro(data)
    spawn(function()
        for _,step in ipairs(data) do
            wait(step.t)
            game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("SpawnUnit", step.slot, step.pos)
        end
    end)
end

-- UI for Macro Tab
local function createButton(text, callback)
    local btn = Instance.new("TextButton", macroTab)
    btn.Text = text
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

createButton("▶ Start Recording", function()
    macroData = {}
    recording = true
    recordStart = tick()
end)

createButton("⏹ Stop Recording & Save", function()
    recording = false
    saveMacro(selectedSlot)
end)

createButton("🔁 Play Macro", function()
    local data = loadMacro(selectedSlot)
    if data then
        playMacro(data)
    end
end)

createButton("❌ Delete Macro", function()
    local path = macroFolder.."/macro"..selectedSlot..".json"
    if isfile(path) then
        delfile(path)
    end
end)

local dropdown = Instance.new("TextBox", macroTab)
dropdown.PlaceholderText = "Slot 1–6"
dropdown.Size = UDim2.new(1, -10, 0, 30)
dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Text = ""

dropdown.FocusLost:Connect(function()
    local n = tonumber(dropdown.Text)
    if n and n >=1 and n <=6 then
        selectedSlot = n
    end
end)

-- Auto detect spawn unit during recording
local old
old = hookfunction(getgenv().InvokeServer or function(...) return nil end, function(self, ...)
    local args = {...}
    if typeof(args[1]) == "string" and args[1] == "SpawnUnit" and recording then
        local now = tick()
        local dt = now - recordStart
        recordStep(args[2], args[3], dt)
    end
    return old(self, ...)
end)
