extends Node2D

var player = "kungfu"
var enemy = "business"


func promote_player_to_boss():
	enemy = player
	
	if player == "kungfu":
		player = "army"
	elif player == "army":
		player = "business"
	else:
		player = "kungfu"
	
