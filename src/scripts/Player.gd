extends Node2D


export(float) var speed: float = 1.0
export(int) var ammo: int = 10;
export(int) var maxAmmo: int = 10;
export(bool) var hasBlueCard = false
export(bool) var hasRedCard = false
export(int) var MaxHP = 3

onready var rig = get_node("PawnRig")
onready var globalState = get_tree().get_root().find_node("GlobalState", true, false)

var useable: Node = null
var loaded_sprites = false

var isDead = false

func EnterUseRange(node: Node):
	useable = node
	
func ExitUseRange(node: Node):
	if useable == node:
		useable = null

func _ready():
	#load_correct_sprites()
	pass

func _process(delta):
	if rig == null:
		return
	
	#Hack: rig doesn't have a value on first frame so need to set this when it does.
	if !loaded_sprites:
		load_correct_sprites()
		loaded_sprites = true	
		
	if isDead:
		return
	
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
	
	if rig.Bands > MaxHP:
		rig.death = true
		isDead = true

func load_correct_sprites():
	
	var spriteSetName = globalState.player
	rig.HeadDown = load("res://sprites/charecters/" + spriteSetName + "/player/head_down.png")
	rig.HeadLeft = load("res://sprites/charecters/" + spriteSetName + "/player/head_left.png")
	rig.HeadRight = load("res://sprites/charecters/" + spriteSetName + "/player/head_right.png")
	rig.HeadUp = load("res://sprites/charecters/" + spriteSetName + "/player/head_up.png")
	
	rig.BodyDown = load("res://sprites/charecters/" + spriteSetName + "/player/body-down.png")
	rig.BodyLeft = load("res://sprites/charecters/" + spriteSetName + "/player/body-left.png")
	rig.BodyRight = load("res://sprites/charecters/" + spriteSetName + "/player/body-right.png")
	rig.BodyUp = load("res://sprites/charecters/" + spriteSetName + "/player/body-up.png")

	rig.FaceDown = load("res://sprites/charecters/" + spriteSetName + "/player/face-down.png")
	rig.FaceLeft = load("res://sprites/charecters/" + spriteSetName + "/player/face-left.png")
	rig.FaceRight = load("res://sprites/charecters/" + spriteSetName + "/player/face-right.png")
	
	rig.HairDown = load("res://sprites/charecters/" + spriteSetName + "/player/hair-down.png")
	rig.HairLeft = load("res://sprites/charecters/" + spriteSetName + "/player/hair-left.png")
	rig.HairRight = load("res://sprites/charecters/" + spriteSetName + "/player/hair-right.png")
	rig.HairUp = load("res://sprites/charecters/" + spriteSetName + "/player/hair-up.png")
	
	rig.Hand = load("res://sprites/charecters/" + spriteSetName + "/player/hand.png")
