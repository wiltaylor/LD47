extends TextureRect


onready var player = get_tree().get_root().find_node("Player", true, false)

func _process(delta):
	if player.hasRedCard:
		show()
	else:
		hide()
	
