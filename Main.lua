--// SonTít UTD Macro Hub - Full Tab Version 😎 local CoreGui = game:GetService("CoreGui") local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local HttpService = game:GetService("HttpService")

--// GUI Setup local ScreenGui = Instance.new("ScreenGui", CoreGui) ScreenGui.Name = "UTDMacroHub"

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Size = UDim2.new(0, 400, 0, 350) MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) MainFrame.Draggable = true MainFrame.Active = true MainFrame.Name = "MainFrame"

local TabHolder = Instance.new("Frame", MainFrame) TabHolder.Size = UDim2.new(1, 0, 0, 30) TabHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local ContentHolder = Instance.new("Frame", MainFrame) ContentHolder.Position = UDim2.new(0, 0, 0, 30) ContentHolder.Size = UDim2.new(1, 0, 1, -30) ContentHolder.BackgroundTransparency = 1

--// Tabs local tabs = {} local function CreateTab(name) local button = Instance.new("TextButton", TabHolder) button.Size = UDim2.new(0, 80, 1, 0) button.Text = name button.TextColor3 = Color3.fromRGB(255, 255, 255) button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local frame = Instance.new("Frame", ContentHolder)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1
frame.Visible = false

button.MouseButton1Click:Connect(function()
	for _, tab in pairs(tabs) do
		tab.Frame.Visible = false
	end
	frame.Visible = true
end)

tabs[name] = {Button = button, Frame = frame}
return frame

end

--// Tab: Auto local autoTab = CreateTab("Auto") local autoLayout = Instance.new("UIListLayout", autoTab) autoLayout.Padding = UDim.new(0, 5) autoLayout.FillDirection = Enum.FillDirection.Vertical

autoTab.ChildAdded:Connect(function(child) if child:IsA("TextButton") then child.Size = UDim2.new(1, -10, 0, 30) child.BackgroundColor3 = Color3.fromRGB(35, 35, 35) child.TextColor3 = Color3.fromRGB(255, 255, 255) child.Font = Enum.Font.Gotham child.TextSize = 14 end end)

-- Sample Feature (Auto Farm) local autofarm = false local autoFarmBtn = Instance.new("TextButton", autoTab) autoFarmBtn.Text = "✅ Toggle Auto Farm" autoFarmBtn.MouseButton1Click:Connect(function() autofarm = not autofarm if autofarm then spawn(function() while autofarm do pcall(function() local chr = LocalPlayer.Character local mob = workspace.Enemies:FindFirstChildWhichIsA("Model") if chr and mob and mob:FindFirstChild("HumanoidRootPart") then chr:FindFirstChild("HumanoidRootPart").CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 2) end end) wait(1) end end) end end)

--// Tab: Macro local macroTab = CreateTab("Macro") local macroLayout = Instance.new("UIListLayout", macroTab) macroLayout.Padding = UDim.new(0, 5)

local macroData = {} local currentSlot = 1 local macroPath = "UTD_Macro_"

local dropdown = Instance.new("TextButton", macroTab) dropdown.Text = "🎯 Select Macro: 1" dropdown.Size = UDim2.new(1, -10, 0, 30) dropdown.MouseButton1Click:Connect(function() currentSlot = (currentSlot % 5) + 1 dropdown.Text = "🎯 Select Macro: "..currentSlot end)

local recordBtn = Instance.new("TextButton", macroTab) recordBtn.Text = "🔴 Record Macro" recordBtn.MouseButton1Click:Connect(function() table.clear(macroData) -- Hook unit placement here (not implemented in this template) end)

local stopBtn = Instance.new("TextButton", macroTab) stopBtn.Text = "⏹️ Stop" stopBtn.MouseButton1Click:Connect(function() -- Stop recording logic here end)

local saveBtn = Instance.new("TextButton", macroTab) saveBtn.Text = "💾 Save Macro" saveBtn.MouseButton1Click:Connect(function() writefile(macroPath..currentSlot..".json", HttpService:JSONEncode(macroData)) end)

local loadBtn = Instance.new("TextButton", macroTab) loadBtn.Text = "📥 Load Macro" loadBtn.MouseButton1Click:Connect(function() if isfile(macroPath..currentSlot..".json") then macroData = HttpService:JSONDecode(readfile(macroPath..currentSlot..".json")) end end)

local delBtn = Instance.new("TextButton", macroTab) delBtn.Text = "🗑️ Delete Macro" delBtn.MouseButton1Click:Connect(function() if isfile(macroPath..currentSlot..".json") then delfile(macroPath..currentSlot..".json") end end)

--// Toggle Button local toggleBtn = Instance.new("TextButton", CoreGui) toggleBtn.Size = UDim2.new(0, 40, 0, 40) toggleBtn.Position = UDim2.new(0, 10, 0.5, -20) toggleBtn.Text = "📂" toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255) toggleBtn.TextSize = 20 toggleBtn.Font = Enum.Font.GothamBold toggleBtn.Draggable = true

toggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

--// Auto Save On Leave game:BindToClose(function() if #macroData > 0 then writefile(macroPath..currentSlot..".json", HttpService:JSONEncode(macroData)) end end)

--// Default Show First Tab tabs["Auto"].Frame.Visible = true

            
