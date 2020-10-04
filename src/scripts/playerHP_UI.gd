extends Label

onready var player = get_tree().get_root().find_node("Player", true, false)

func _process(delta):
	text = "X " + str(player.ammo)
