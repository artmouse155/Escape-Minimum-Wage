class_name Projectile extends Area2D

@export var SpriteNode: Sprite2D

var velocity = Vector2.ZERO
var damage = 0

var rot_vel := 20.0

const DESPAWN_TIME := 5.0 # seconds

var target_group: String

var despawn_tween : Tween

func init(texture: Texture2D, direction: Vector2, speed: float, _damage: float, _target_group : String,  _rot_vel: float = 20.0,) -> void:
	SpriteNode.texture = texture
	rot_vel = _rot_vel
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
	rotation += (rot_vel * delta)

	for body in get_overlapping_bodies():
		if body is Entity and body.is_in_group(target_group):
				body.take_damage(damage)
				impact()
				break
	
	for area in get_overlapping_areas():
		if area is Hitbox and area.Parent.is_in_group(target_group):
				area.parent_take_damage(damage)
				impact()
				break
		#else:
			#push_error("Can't damage. is groups %s" % str(body.get_groups()))
		
func impact() -> void:
	queue_free()
