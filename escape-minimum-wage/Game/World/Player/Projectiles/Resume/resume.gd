class_name Projectile extends Area2D

var velocity = Vector2.ZERO
var damage = 0

const ROT_VEL := 20

var target_group: String

func init(direction: Vector2, speed: float, _damage: float, _target_group : String) -> void:
	target_group = _target_group
	velocity = direction * speed
	damage = _damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += (velocity * delta)
	rotation += (ROT_VEL * delta)

	for body in get_overlapping_bodies():
		if body.is_in_group(target_group):
			body.take_damage_from_player(damage)
			impact()
		else:
			"Can't damage. is groups %s" % str(body.get_groups())
		
func impact() -> void:
	queue_free()
