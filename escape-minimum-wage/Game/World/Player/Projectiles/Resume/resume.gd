class_name Projectile extends Area2D

var velocity = Vector2.ZERO
var damage = 0

const ROT_VEL := 20

const DESPAWN_TIME := 5.0 # seconds

var target_group: String

var despawn_tween : Tween

func init(direction: Vector2, speed: float, _damage: float, _target_group : String) -> void:
	target_group = _target_group
	velocity = direction * speed
	damage = _damage
	if despawn_tween:
		despawn_tween.kill()
	despawn_tween = create_tween()
	despawn_tween.tween_interval(DESPAWN_TIME)
	despawn_tween.tween_callback(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += (velocity * delta)
	rotation += (ROT_VEL * delta)

	for body in get_overlapping_bodies():
		if body.is_in_group(target_group):
			body.take_damage_from_player(damage)
			impact()
		else:
			print("Can't damage. is groups %s" % str(body.get_groups()))
		
func impact() -> void:
	queue_free()
