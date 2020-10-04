extends Node2D

enum DoorLockType {None, Red, Blue, Always}

export(DoorLockType) var LockType = DoorLockType.None
export(Texture) var ClosedTexture
export(Texture) var ClosedRedTexture
export(Texture) var ClosedBlueTexture
export(Texture) var OpenTexture
export(Texture) var BlockedTexture

onready var player = get_tree().get_root().find_node("Player", true, false)
onready var staticBody = get_node("StaticBody2D")
onready var sprite = get_node("Sprite")
onready var useArea = get_node("UseArea")

func _ready():
	if LockType == DoorLockType.Red:
		sprite.texture = ClosedRedTexture
		
	if LockType == DoorLockType.Blue:
		sprite.texture = ClosedBlueTexture
		
	if LockType == DoorLockType.Always:
		sprite.texture = BlockedTexture

func use():
	
	if LockType == DoorLockType.Always:
		return
		
	if LockType == DoorLockType.Blue:
		if player.hasBlueCard != true:
			print("no blue key card")
			return
		
	if LockType == DoorLockType.Red:
		if player.hasRedCard != true:
			print("no red key card")
			return
		
	if LockType == DoorLockType.None:
		pass # Always can open	
	
	staticBody.queue_free()
	useArea.queue_free()
	
	sprite.texture = OpenTexture
	
	player.ExitUseRange(self)

func _enter_use_range(body):
	if body.owner == null:
		return
		
	if body.owner.name == "Player":
		body.owner.EnterUseRange(self)

func _leave_use_range(body):
	if body.owner == null:
		return
		
	if body.owner.name == "Player":
		body.owner.ExitUseRange(self)
