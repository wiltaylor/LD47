extends Area2D

func _onPickup(body):
	if body.owner.name != "Player":
		return
		
	body.owner.hasRedCard = true
		
	queue_free()
	
