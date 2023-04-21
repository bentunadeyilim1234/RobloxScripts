--ESP v1.3 made by ItsTuna_YT

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local Outline = Instance.new("Highlight")
Outline.Name = "_esp"
Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

local Enabled = true

local ConnectionData = {}
local InstanceData = {}

ConnectionData["players"] = {}

function _addESP(character)
	if InstanceData[character] then return end
	InstanceData[character] = Outline:Clone()
	if game.Players[character.Name].Team then InstanceData[character].FillColor = game.Players[character.Name].Team.TeamColor.Color end
	InstanceData[character].Enabled = Enabled
	InstanceData[character].Parent = character
end

function _removeESP(character)
	if not InstanceData[character] then return end
	--InstanceData[character]:Destroy()
	InstanceData[character] = nil
end

function _connect(player)
	if ConnectionData.players[player] then return end
	ConnectionData.players[player] = {}
	ConnectionData.players[player][1] = player.CharacterAdded:Connect(_addESP)
	ConnectionData.players[player][2] = player.CharacterRemoving:Connect(_removeESP)
end

function _disconnect(player)
	InstanceData[player.Character]:Destroy()
	InstanceData[player.Character] = nil
	if not ConnectionData.players[player] then return end
	for _, connection in ConnectionData.players[player] do connection:Disconnect() end
	ConnectionData.players[player] = nil
	--ConnectionData.players[player]:Disconnect()
	--ConnectionData.players[player] = nil
end

function _enable()
	for _, player in Players:GetPlayers() do
		if player.Name == Player.Name then continue end
		if not InstanceData[player.Character] then continue end
		InstanceData[player.Character].Enabled = true
	end
end

function _disable()
	for _, player in Players:GetPlayers() do
		if player.Name == Player.Name then continue end
		if not InstanceData[player.Character] then continue end
		InstanceData[player.Character].Enabled = false
	end
end

function _toggle()
	Enabled = not Enabled
	if Enabled then return _enable() end
	_disable()
end

UserInputService.InputBegan:Connect(function(input, chatted)
	if chatted then return end
	if input.KeyCode ~= Enum.KeyCode.F then return end

	_toggle()
end)

for _, player in Players:GetPlayers() do
	if player.Name == Player.Name then continue end
	_addESP(player.Character)
	_connect(player)
end

ConnectionData[1] = Players.PlayerAdded:Connect(_connect)
ConnectionData[2] = Players.PlayerRemoving:Connect(_disconnect)
