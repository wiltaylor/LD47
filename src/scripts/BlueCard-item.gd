extends Area2D

func _onPickup(body):
	if body.owner.name != "Player":
		return
		
	body.owner.hasBlueCard = true
		
	queue_free()
	
