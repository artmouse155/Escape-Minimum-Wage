class_name Resume extends Area2D

var velocity = Vector2.ZERO
var damage = 0

const ROT_VEL := 20

func init(direction: Vector2, speed: float, _damage: float) -> void:
	velocity = direction * speed
	damage = _damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += (velocity * delta)
	rotation += (ROT_VEL * delta)

	for body in get_overlapping_bodies():
		if body is Enemy:
			body.take_damage_from_player(damage)
			impact()
		print("Bam!")
		
func impact() -> void:
	queue_free()
