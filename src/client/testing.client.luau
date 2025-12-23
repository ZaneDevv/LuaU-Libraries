local BetterChatService = require(game:GetService("ReplicatedStorage").Shared.Services.BetterChatService)


BetterChatService.addTagByPlayerId("#ffaa00", "プログラマー", game.Players.LocalPlayer.UserId)

task.wait(5)
BetterChatService.sendMessage("Welcome to the game yooooooooo", "#00f")