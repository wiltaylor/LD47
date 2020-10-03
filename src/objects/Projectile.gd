extends Sprite

var Owner: Node

export(Vector2) var Velocity: Vector2 = Vector2.ZERO
export(float) var TimeToLive: float = 10.0

func _on_hit(body):
	if body == Owner:
		return	
		
	print("hit something")
		

func _process(delta):
	
	TimeToLive -= delta
	
	if TimeToLive <= 0:
		queue_free()
		print("timed out")
	
	self.position += Velocity * delta


func Setup(owner: Node, vel: Vector2):
	Velocity = vel
	Owner = owner
