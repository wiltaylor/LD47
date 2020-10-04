extends Label

onready var player = get_tree().get_root().find_node("Player", true, false)

func _process(delta):
	if player.isDead:
		show()
		
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
			return
			
	else:
		hide()
	
