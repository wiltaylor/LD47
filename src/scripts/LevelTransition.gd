extends Area2D

export(String) var ScenePath: String

func _onWalkOnto(body):
	if body.owner.name != "Player":
		return
	
	get_tree().change_scene(ScenePath)
	
