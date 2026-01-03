_G.targetName = { "Archangel", "Demon", "Angel" }
local codes = { "HAPPYNEWYEAR" } 

repeat task.wait(1) until game:IsLoaded()

local DelayBeforeStart = 5
task.wait(DelayBeforeStart)

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Reroll = Shared.Packages.Knit.Services.RaceService.RF.Reroll
local RedeemCode = Shared.Packages.Knit.Services.CodeService.RF.RedeemCode

local Knit = require(Shared.Packages.Knit)
local PlayerController = Knit.GetController("PlayerController")
local Replica = PlayerController.Replica

for _, code in pairs(codes) do
    pcall(function()
        RedeemCode:InvokeServer(code)
    end)
    task.wait(0.5)
end

task.wait(1)

while Replica.Data.Spins > 0 and task.wait(.1) do
    if table.find(_G.targetName, Replica.Data.Race) then
        break
    end
    pcall(function()
        Reroll:InvokeServer()
    end)
end

local raceEmojis = {
    ["Archangel"] = "✅",
    ["Angel"]     = "👼",
    ["Demon"]     = "👿"
}

local currentRace = Replica.Data.Race
local isMatch = table.find(_G.targetName, currentRace) ~= nil

local resultSymbol
if isMatch then
    resultSymbol = raceEmojis[currentRace] or "✅"
else
    resultSymbol = "❌"
end

local messages = resultSymbol .. 
    " Auto Reroll Complete: " .. tostring(currentRace) .. 
    " Reroll Left: " .. tostring(Replica.Data.Spins)

if _G.Horst_SetDescription then
    _G.Horst_SetDescription(messages)
end

if _G.Horst_AccountChangeDone then
    _G.Horst_AccountChangeDone()
end
