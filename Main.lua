--// Blox Fruits Banana Tab GUI VVIP - By ChatGPT 😎
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabsFrame = Instance.new("Frame")
local FarmLevelTab = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")

--// Toggle Flags
local autoFarmLevel = false
local autoFastAttack = false
local autoSkill = false
local autoQuest = false
local autoTP = false

--// Parent
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "BananaTabGUI"

--// Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
UICorner.Parent = MainFrame

--// Tabs Holder
TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabsFrame.Size = UDim2.new(0, 360, 0, 300)
UICorner:Clone().Parent = TabsFrame

--// Farm Level Tab
FarmLevelTab.Name = "FarmLevelTab"
FarmLevelTab.Parent = TabsFrame
FarmLevelTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FarmLevelTab.Position = UDim2.new(0, 0, 0, 0)
FarmLevelTab.Size = UDim2.new(1, 0, 1, 0)

UIListLayout.Parent = FarmLevelTab
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = "[ OFF ] " .. name
    btn.Parent = FarmLevelTab
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = (state and "[ ON  ] " or "[ OFF ] ") .. name
    end)
end

-- Auto Farm Level
CreateToggle("Auto Farm Level", function()
    autoFarmLevel = not autoFarmLevel
    if autoFarmLevel then
        spawn(function()
            while autoFarmLevel do
                print("[Auto Farm] Working")
                -- Add farm logic here
                wait(2)
            end
        end)
    end
    return autoFarmLevel
end)

-- Fast Attack
CreateToggle("Fast Attack", function()
    autoFastAttack = not autoFastAttack
    if autoFastAttack then
        spawn(function()
            while autoFastAttack do
                print("[Fast Attack] Enabled")
                -- Fast attack logic
                wait(0.1)
            end
        end)
    end
    return autoFastAttack
end)

-- Auto Skill
CreateToggle("Auto Skill", function()
    autoSkill = not autoSkill
    if autoSkill then
        spawn(function()
            while autoSkill do
                print("[Auto Skill] Using Z, X, C, V")
                -- Skill usage logic here
                wait(5)
            end
        end)
    end
    return autoSkill
end)

-- Auto Quest
CreateToggle("Auto Quest", function()
    autoQuest = not autoQuest
    if autoQuest then
        spawn(function()
            while autoQuest do
                print("[Auto Quest] Active")
                -- Auto quest logic here
                wait(3)
            end
        end)
    end
    return autoQuest
end)

-- Teleport to Enemy
CreateToggle("Teleport To Enemy", function()
    autoTP = not autoTP
    if autoTP then
        spawn(function()
            while autoTP do
                print("[Teleport] Moving to enemy")
                -- TP logic here
                wait(1)
            end
        end)
    end
    return autoTP
end)
