--[[
Ultimate Tower Defense - Full Macro System Script
Author: SonScript
Compatible: KRNL Mobile / Synapse X
Features: Record & Play Macro | Auto Save/Load | Slot System | Full GUI Tabs
--]]

-- INIT SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- FOLDER & FILE MANAGEMENT
local folder = "UTD_Macros"
if not isfolder(folder) then makefolder(folder) end

-- GLOBALS
local Recording = false
local MacroData = {}
local CurrentSlot = "Slot1"
local Playing = false

-- UI LIBRARY (Assume Rayfield or custom GUI)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({Name = "UTD Script | Macro Hub", ConfigurationSaving = {Enabled = false}})

local Tab = Window:CreateTab("📁 Macro", 4483362458)

-- RECORD MACRO
local RecordButton = Tab:CreateButton({
    Name = "📹 Start Recording",
    Callback = function()
        Recording = true
        MacroData = {}
        local startTime = tick()

        Rayfield:Notify({Title = "Macro", Content = "Recording started", Duration = 3})

        -- Hook to mouse click or tower placement detection
        local conn
        conn = Mouse.Button1Down:Connect(function()
            local now = tick()
            local relTime = now - startTime

            -- You may need to improve this for exact tower/position detection
            table.insert(MacroData, {time = relTime, slot = getSelectedSlot(), position = Mouse.Hit.Position})
        end)

        -- Stop recording after delay or manual
        task.delay(60, function()
            if Recording then
                Recording = false
                conn:Disconnect()
                saveMacro(CurrentSlot, MacroData)
                Rayfield:Notify({Title = "Macro", Content = "Recording stopped & saved", Duration = 3})
            end
        end)
    end
})

-- PLAY MACRO
local PlayButton = Tab:CreateButton({
    Name = "▶️ Play Macro",
    Callback = function()
        if Playing then return end
        Playing = true

        local data = loadMacro(CurrentSlot)
        if not data then
            Rayfield:Notify({Title = "Error", Content = "No macro found!", Duration = 3})
            return
        end

        local start = tick()
        for _, action in ipairs(data) do
            task.delay(action.time, function()
                placeTower(action.slot, action.position)
            end)
        end

        task.delay(data[#data].time + 1, function()
            Playing = false
            Rayfield:Notify({Title = "Macro", Content = "Playback finished", Duration = 3})
        end)
    end
})

-- SLOT SELECT
Tab:CreateDropdown({
    Name = "🎯 Select Macro Slot",
    Options = {"Slot1", "Slot2", "Slot3", "Slot4", "Slot5", "Slot6"},
    CurrentOption = "Slot1",
    Callback = function(Option)
        CurrentSlot = Option
    end
})

-- DELETE MACRO
Tab:CreateButton({
    Name = "🗑️ Delete Current Macro",
    Callback = function()
        if isfile(folder.."/"..CurrentSlot..".txt") then
            delfile(folder.."/"..CurrentSlot..".txt")
            Rayfield:Notify({Title = "Macro", Content = "Deleted "..CurrentSlot, Duration = 2})
        else
            Rayfield:Notify({Title = "Macro", Content = "No file found", Duration = 2})
        end
    end
})

-- HELPER FUNCTIONS
function getSelectedSlot()
    -- Placeholder: You can hook into UI to detect which slot is selected
    return 1 -- always returns first slot for now
end

function placeTower(slot, position)
    -- You need to fire the same remote UTD uses for unit placement
    -- E.g: game:GetService("ReplicatedStorage").Remotes.PlaceUnit:FireServer(slot, position)
    print("Placing from slot", slot, "at", position)
end

function saveMacro(slot, data)
    local path = folder.."/"..slot..".txt"
    writefile(path, HttpService:JSONEncode(data))
end

function loadMacro(slot)
    local path = folder.."/"..slot..".txt"
    if isfile(path) then
        local content = readfile(path)
        return HttpService:JSONDecode(content)
    else
        return nil
    end
end


