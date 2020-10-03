extends Node2D

enum AIState { Waiting, LookingForPlayer, AttackingPlayer, Dead }

onready var rig = get_node("PawnRig")
onready var player = get_tree().get_root().find_node("Player", true, false)
onready var playerRig = player.get_node("PawnRig")
onready var visionCone = get_node("VisionCone")
onready var navMesh = get_tree().get_root().find_node("Navigation2D", true, false)

export(AIState) var State = AIState.Waiting
export(float) var WaitingTurnRate = 5
export(float) var LookingDuration = 1
export(float) var IdealDistance: float = 30
export(float) var ShootCooldown: float = 3
export(float) var MoveSpeed = 50

var currentWait = 0
var rng = RandomNumberGenerator.new()
var currentSearchTime = 0
var lastKnownPoint: Vector2
var coolDown = 0
var currentPath = PoolVector2Array()

func _ready():
	rng.randomize()	

func doWait(delta):	
	if currentWait <= 0:
		currentWait = WaitingTurnRate
		var new_dir = rng.randi_range(0, 3)
		rig.Facing = new_dir
	else:
		currentWait -= delta
		
func moveAlongPath(delta):
	if currentPath == null:
		return
	
	var distance_to_travel = MoveSpeed * delta
	
	while distance_to_travel > 0 and currentPath.size() > 0:
		var distance_to_point = rig.global_position.distance_to(currentPath[0])
		
		if distance_to_travel <= distance_to_point:
			rig.global_position += rig.global_position.direction_to(currentPath[0]) * distance_to_travel
		else:
			rig.global_position = currentPath[0]
			currentPath.remove(0)
		distance_to_travel -= distance_to_point	

func player_dist():
	return playerRig.global_position.distance_to(rig.global_position)
	
func create_path(point: Vector2):
	currentPath = navMesh.get_simple_path(point, rig.global_position)
		
func doAttack(delta):

	#if(player_dist() > IdealDistance):
	#	move_to(playerRig.global_position, delta)

	if coolDown > 0:
		coolDown -= delta;
		return
	
	coolDown = ShootCooldown
	rig.shoot()

func doLook(delta):
	if currentSearchTime <= 0:
		State = AIState.Waiting
		return
		
	currentSearchTime -= delta
	
	var dist = lastKnownPoint.distance_to(rig.global_position)
	
	if(dist < 1):
		State = AIState.Waiting
		return
		
	#move_to(lastKnownPoint, delta)
	moveAlongPath(delta)
		
	

func correctVisionConeDirection():
	if rig.Facing == rig.Direction.Down:
		visionCone.rotation_degrees = 0
	elif rig.Facing == rig.Direction.Up:
		visionCone.rotation_degrees = 180
	elif rig.Facing == rig.Direction.Left:
		visionCone.rotation_degrees = 90
	elif rig.Facing == rig.Direction.Right:
		visionCone.rotation_degrees = -90

	

func _process(delta):
	
	if State == AIState.Dead:
		return
		
	correctVisionConeDirection()
		
	if rig.Bands > 3:
		rig.death = true
		State = AIState.Dead
		return
		
	if State == AIState.Waiting:
		doWait(delta)
		
	if State == AIState.AttackingPlayer:
		doAttack(delta)
		
	if State == AIState.LookingForPlayer:
		doLook(delta)


func _on_object_seen(body):	
	if State == AIState.Dead:
		return 
		
	if body.owner.name == "Player":		
		State = AIState.AttackingPlayer
		print("on guard!")


func _on_object_leave_vision(body):
	if State == AIState.Dead:
		return
		
	if body.owner == null:
		return
		
	if body.owner.name == "Player":
		State = AIState.LookingForPlayer
		currentSearchTime = LookingDuration
		lastKnownPoint = playerRig.global_position
		create_path(lastKnownPoint)
		print("I will find you!")
