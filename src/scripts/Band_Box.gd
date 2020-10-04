extends Area2D

export(int) var Qty: int = 10

onready var pickupSFX = get_node("PickupSfx")
onready var sprite = get_node("Sprite")
onready var shape = get_node("CollisionShape2D")

func _onPickup(body):
	if body.owner.name != "Player":
		return
		
	body.owner.ammo += Qty
	
	pickupSFX.play()
	
	if body.owner.ammo > body.owner.maxAmmo:
		body.owner.ammo = body.owner.maxAmmo
		
	sprite.queue_free()
	shape.queue_free()
	


func _on_PickupSfx_finished():
	queue_free()
