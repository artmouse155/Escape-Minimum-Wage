class_name Resume extends RigidBody2D

var velocity = Vector2.ZERO
var damage = 0

const ROT_VEL := 20

func init(direction: Vector2, speed: float, _damage: float) -> void:
	linear_velocity = direction * speed
	damage = _damage
	angular_velocity = ROT_VEL

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#position += (velocity * delta)
	#rotation += (ROT_VEL * delta)


#func _on_body_entered(body: Node2D) -> void:
	#if body is Enemy:
		#body.take_damage_from_player(damage)
		#impact()
		
func impact() -> void:
	queue_free()
