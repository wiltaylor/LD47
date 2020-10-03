extends Area2D

export(int) var Qty: int = 10

func _onPickup(body):
	if body.owner.name != "Player":
		return
		
	body.owner.ammo += Qty
	
	if body.owner.ammo > body.owner.maxAmmo:
		body.owner.ammo = body.owner.maxAmmo
		
	queue_free()
	
