extends Node2D


export(float) var speed: float = 1.0
export(int) var ammo: int = 10;
export(int) var maxAmmor: int = 10;

onready var rig = get_node("PawnRig")

var useable: Node = null

func EnterUseRange(node: Node):
	useable = node
	
func ExitUseRange(node: Node):
	if useable == node:
		useable = null

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
		
	if Input.is_action_just_pressed("shoot") && ammo > 0:
		ammo -= 1		
		rig.shoot()
		
	if Input.is_action_just_pressed("use"):
		if useable != null:
			useable.use()
	
	rig.move(vel)
