extends Node2D


export(float) var speed: float = 1.0

onready var rig = get_node("PawnRig")

func _process(delta):
	
	var vel = Vector2(0,0)
	
	
	if Input.is_action_pressed("move_down"):
		vel.y += speed * delta
			
	if Input.is_action_pressed("move_up"):
		vel.y -= speed * delta
	
	if Input.is_action_pressed("move_left"):
		vel.x -= speed * delta
		
	if Input.is_action_pressed("move_right"):
		vel.x += speed * delta
		
	if Input.is_action_just_pressed("shoot"):
		rig.shoot()
		
	
	rig.move(vel)
