extends Area2D


func onPickup(body):
	if body.owner.name != "Player":
		return
		
	body.Bands -= 1
	
	if body.Bands < 0:
		body.Bands = 0
		
	queue_free()
	
