-- Script: Auto Farm từ Level 1 đến 2650
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local currentQuest = ""
local questData = {
    ["Bandit"]         = {level = 1, questName = "BanditQuest1", enemyName = "Bandit"},
    ["Monkey"]         = {level = 15, questName = "JungleQuest", enemyName = "Monkey"},
    ["Gorilla"]        = {level = 20, questName = "JungleQuest", enemyName = "Gorilla"},
    ["Pirate"]         = {level = 30, questName = "BuggyQuest1", enemyName = "Pirate"},
    ["Brute"]          = {level = 60, questName = "BuggyQuest1", enemyName = "Brute"},
    ["Desert Bandit"]  = {level = 75, questName = "DesertQuest", enemyName = "Desert Bandit"},
    ["Snow Bandit"]    = {level = 90, questName = "SnowQuest", enemyName = "Snow Bandit"},
    ["Chief Petty"]    = {level = 120, questName = "MarineQuest3", enemyName = "Chief Petty Officer"},
    ["Sky Bandit"]     = {level = 150, questName = "SkyQuest", enemyName = "Sky Bandit"},
    ["Shanda"]         = {level = 175, questName = "SkyQuest2", enemyName = "Shanda"},
    ["Dark Master"]    = {level = 200, questName = "SkyQuest3", enemyName = "Dark Master"},
    ["Prisoner"]       = {level = 220, questName = "PrisonerQuest", enemyName = "Prisoner"},
    ["Danger Prisoner"]= {level = 250, questName = "PrisonerQuest", enemyName = "Danger Prisoner"},
    ["Toga Warrior"]   = {level = 275, questName = "ColosseumQuest", enemyName = "Toga Warrior"},
    -- ... (thêm logic cho các island tiếp theo đến Lv. 2650 nếu cần)
}

-- Tìm nhiệm vụ phù hợp theo level hiện tại
local function getCurrentQuest()
    local plvl = Player.Data.Level.Value
    local chosen = nil
    for name, data in pairs(questData) do
        if plvl >= data.level then
            chosen = data
        end
    end
    return chosen
end

-- Bắt đầu nhiệm vụ
local function startQuest(data)
    local remote = ReplicatedStorage.Remotes:FindFirstChild("CommF_")
    if remote then
        remote:InvokeServer("StartQuest", data.questName, 1)
        currentQuest = data.enemyName
    end
end

-- Tìm NPC theo tên
local function getEnemy()
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == currentQuest and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            return mob
        end
    end
end

-- Di chuyển & đánh
local function attackEnemy(enemy)
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and enemy:FindFirstChild("HumanoidRootPart") then
        local tween = TweenService:Create(hrp, TweenInfo.new(0.3), {CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,3,0)})
        tween:Play()
        tween.Completed:Wait()

        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Player.Character
                break
            end
        end
    end
end

-- Vòng lặp farm
while wait(0.5) do
    pcall(function()
        local questFrame = Player.PlayerGui:FindFirstChild("QuestInfo")
        if not (questFrame and questFrame.Visible) then
            local questData = getCurrentQuest()
            if questData then
                startQuest(questData)
            end
        else
            local target = getEnemy()
            if target then
                attackEnemy(target)
            end
        end
    end)
end
