extends KinematicBody2D

enum Direction { Up, Down, Left, Right}
enum Sex { Male, Female }
enum IconType { Alert, Question, Angry }
	
export(Direction) var Facing = Direction.Down
export(Sex) var Gender = Sex.Male
export(int) var Bands = 0
export (float) var projectileSpeed: float = 500;
export (float) var BandSpawnOffset: float = 20
export(bool) var PlayPlayerSFX = false

export(Texture) var HeadDown: Texture
export(Texture) var HeadLeft: Texture
export(Texture) var HeadRight: Texture
export(Texture) var HeadUp: Texture

export(Texture) var BodyDown: Texture
export(Texture) var BodyUp: Texture
export(Texture) var BodyLeft: Texture
export(Texture) var BodyRight: Texture

export(Texture) var FaceDown: Texture
export(Texture) var FaceLeft: Texture
export(Texture) var FaceRight: Texture

export(Texture) var HairDown: Texture
export(Texture) var HairUp: Texture
export(Texture) var HairRight: Texture
export(Texture) var HairLeft: Texture

export(Texture) var Hand: Texture

export(Texture) var AlertIcon: Texture
export(Texture) var QuestionIcon: Texture
export(Texture) var AngryIcon: Texture

export (bool)var death: bool = false
export (bool)var attacking: bool = false

var handled_death: bool = false
var handled_attack: bool = false

export(float) var AlertTime: float = 0.0
export(IconType) var AlertType = IconType.Alert

onready var Body: Sprite = get_node("RigBody/Body")
onready var Head: Sprite = get_node("RigBody/Head")
onready var Hand_L: Sprite = get_node("RigBody/Hand_L")
onready var Hand_R: Sprite = get_node("RigBody/Hand_R")
onready var Hair: Sprite = get_node("RigBody/Head/Hair")
onready var Face: Sprite = get_node("RigBody/Head/Face")
onready var Anim: AnimationPlayer = get_node("Animation")

onready var band1: Sprite = get_node("RigBody/Body/band1")
onready var band2: Sprite = get_node("RigBody/Body/band2")
onready var band3: Sprite = get_node("RigBody/Body/band3")
onready var band1Side: Sprite = get_node("RigBody/Body/band1_side")
onready var band2Side: Sprite = get_node("RigBody/Body/band2_side")
onready var band3Side: Sprite = get_node("RigBody/Body/band3_side")
onready var Icon: Sprite = get_node("Icon")

onready var attackSFX = get_node("AttackSound")
onready var hitSFX = get_node("HitSound")
onready var deathSFX = get_node("DeathSound")
onready var hitSFXplayer = get_node("PlayerHitSound")
onready var deathSFXplayer = get_node("PlayerDeathSound")

signal is_hit

func band_hit():
	Bands += 1
	
	if PlayPlayerSFX:
		hitSFXplayer.play()
	else:
		hitSFX.play()
		
	emit_signal("is_hit")
	
	AlertTime = 1
	AlertType = IconType.Angry

func is_dead():
	
	if death == false:
		return false
		
	if handled_death:
		return true
		
	Body.texture = BodyDown
	Face.texture = FaceDown
	Hair.texture = HairDown
	Icon.texture = AngryIcon
	
	Icon.show()
	
	Hand_L.hide()
	Hand_R.hide()
	
	band1.show()
	band2.show()
	band3.show()
	band1Side.hide()
	band2Side.hide()
	band3Side.hide()
	
	Anim.play("dying")
	Anim.queue("dead")
	
	if PlayPlayerSFX:
		deathSFXplayer.play()
		hitSFXplayer.stop()
	else:
		deathSFX.play()
		hitSFX.stop()
	
	get_node("CollisionShape2D").queue_free()
	
	handled_death = true	
	
	return true

func is_attacking():
	if Anim.get_current_animation().begins_with("attack"):
		return true
		
	if handled_attack:
		attacking = false
		handled_attack = false
		return false
		
	if attacking == false:
		return false
		
	if Facing == Direction.Up:
		Anim.play("attack_up")
		Anim.queue("idle_up")

	elif Facing == Direction.Down:
		Anim.play("attack_down")
		Anim.queue("idle_down")

	elif Facing == Direction.Left:
		Anim.play("attack_left")
		Anim.queue("idle_left")

	elif Facing == Direction.Right:
		Anim.play("attack_right")
		Anim.queue("idle_right")

		
	handled_attack = true
	
	return true

func shoot(dir = null):
	var scene = load("res://objects/Projectile.tscn")
	var inst = scene.instance()
	
	var vel = Vector2(0, 0)
	
	inst.position = self.global_position
	attacking = true
	
	if dir != null:
		vel = dir * projectileSpeed
	
	elif Facing == Direction.Down:
		vel.y = projectileSpeed
		inst.position.y += BandSpawnOffset
		
	elif Facing == Direction.Up:
		vel.y = -projectileSpeed
		inst.position.y -= BandSpawnOffset * 2 # We don't want it showing over the top when facing up but still do when facing down
		
	elif Facing == Direction.Left:
		vel.x = -projectileSpeed
		inst.position.x -= BandSpawnOffset
		
	elif Facing == Direction.Right:
		vel.x = projectileSpeed
		inst.position.x += BandSpawnOffset
	
	inst.Setup(self, vel)
	
	var game = get_tree().get_root().get_node("Game")
	game.add_child(inst)
	
	attackSFX.play()

	
func move(vel: Vector2):
	move_and_collide(vel)
	
	if vel.x < 0:
		Facing = Direction.Left
	
	if vel.x > 0:
		Facing = Direction.Right
		
	if vel.y > 0:
		Facing = Direction.Down
		
	if vel.y < 0:
		Facing = Direction.Up
		

func _process(delta):

	if is_dead():
		return
		
	if is_attacking():
		return
	
	band1.hide()
	band2.hide()
	band3.hide()
	band1Side.hide()
	band2Side.hide()
	band3Side.hide()
		
	if AlertType == IconType.Alert:
		Icon.texture = AlertIcon
	elif AlertType == IconType.Question:
		Icon.texture = QuestionIcon
	elif AlertType == IconType.Angry:
		Icon.texture = AngryIcon
	
	if AlertTime > 0:
		AlertTime -= delta
		Icon.show()
	else:
		AlertTime = 0.0
		Icon.hide()	
	
	if Facing == Direction.Down:
		Body.texture = BodyDown
		Hair.texture = HairDown
		Face.texture = FaceDown
		Face.show()
		Hand_L.show();
		Hand_R.show();
		Head.texture = HeadDown
		
		if Bands > 0:
			band1.show()
		if Bands > 1:
			band2.show()
		if Bands > 2:
			band3.show()
			
		if Anim.get_current_animation() != "idle_down": 
			Anim.play("idle_down")
	elif Facing == Direction.Up:
		Body.texture = BodyUp
		Hair.texture = HairUp
		Face.hide()
		Hand_L.hide();
		Hand_R.hide();
		Head.texture = HeadUp
		
		if Bands > 0:
			band1.show()
		if Bands > 1:
			band2.show()
		if Bands > 2:
			band3.show()
		
		if Anim.get_current_animation() != "idle_up": 		
			Anim.play("idle_up")
	elif Facing == Direction.Left:
		Body.texture = BodyLeft
		Hair.texture = HairLeft
		Face.texture = FaceLeft
		Face.show()
		Hand_L.show();
		Hand_R.hide();
		Head.texture = HeadLeft
		
		if Bands > 0:
			band1Side.show()
		if Bands > 1:
			band2Side.show()
		if Bands > 2:
			band3Side.show()
		
		if Anim.get_current_animation() != "idle_left": 
			Anim.play("idle_left")
		
	elif Facing == Direction.Right:
		Body.texture = BodyRight
		Hair.texture = HairRight
		Face.texture = FaceRight
		Face.show()
		Hand_L.hide();
		Hand_R.show();
		Head.texture = HeadRight
		
		if Bands > 0:
			band1Side.show()
		if Bands > 1:
			band2Side.show()
		if Bands > 2:
			band3Side.show()
			
		if Anim.get_current_animation() != "idle_right": 
			Anim.play("idle_right")

func _ready():
	Hand_L.texture = Hand
	Hand_R.texture = Hand
