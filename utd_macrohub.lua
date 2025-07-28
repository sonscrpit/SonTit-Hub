--// Auto Macro Hub (Rayfield UI) by sonscrpit
--// Requires Rayfield: https://github.com/shlexware/Rayfield

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local macros = {}
local selectedMacro = nil
local recording = false
local startTime = 0
local currentRecording = {}
local fileName = "utd_macros.json"

-- Load existing macros
pcall(function()
    local data = readfile(fileName)
    macros = game:GetService("HttpService"):JSONDecode(data)
end)

-- Save macros to file
local function saveMacros()
    pcall(function()
        writefile(fileName, game:GetService("HttpService"):JSONEncode(macros))
    end)
end

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "UTD Auto Macro Hub",
    LoadingTitle = "SonScrpit Loader",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "utd_macro_config"
    },
})

local MainTab = Window:CreateTab("🎮 Macro", 4483362458)

-- Create Macro Section
MainTab:CreateInput({
    Name = "Create Macro",
    PlaceholderText = "Enter macro name",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text and text ~= "" and not macros[text] then
            macros[text] = {}
            saveMacros()
            Rayfield:Notify({Title = "Macro Created", Content = text, Duration = 3})
        end
    end,
})

-- Dropdown to select macro
MainTab:CreateDropdown({
    Name = "Select Macro",
    Options = table.getn(macros) > 0 and table.keys(macros) or {"No Macros"},
    CurrentOption = selectedMacro or "None",
    Callback = function(option)
        selectedMacro = option
    end
})

-- Record Macro
MainTab:CreateToggle({
    Name = "🔴 Record Macro",
    CurrentValue = false,
    Callback = function(value)
        if value then
            if selectedMacro then
                currentRecording = {}
                recording = true
                startTime = tick()
                Rayfield:Notify({Title = "Recording Started", Content = selectedMacro, Duration = 3})
            else
                Rayfield:Notify({Title = "Select Macro First", Content = "You need to select a macro!", Duration = 3})
            end
        else
            recording = false
            if selectedMacro and currentRecording then
                macros[selectedMacro] = currentRecording
                saveMacros()
                Rayfield:Notify({Title = "Recording Saved", Content = selectedMacro, Duration = 3})
            end
        end
    end
})

-- Replay Macro
MainTab:CreateButton({
    Name = "▶️ Replay Macro",
    Callback = function()
        if selectedMacro and macros[selectedMacro] then
            local data = macros[selectedMacro]
            task.spawn(function()
                for _, step in ipairs(data) do
                    task.wait(step.time)
                    game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service")
                        :WaitForChild("Network"):WaitForChild("PlayerPlaceTower"):FireServer(unpack(step.args))
                end
            end)
        else
            Rayfield:Notify({Title = "No Macro", Content = "Please select a valid macro.", Duration = 3})
        end
    end
})

-- Listen for tower placement (during recording)
game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service")
    :WaitForChild("Network"):WaitForChild("PlayerPlaceTower").OnClientEvent:Connect(function(...)
    if recording and selectedMacro then
        table.insert(currentRecording, {
            time = tick() - startTime,
            args = {...}
        })
    end
end)
