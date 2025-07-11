class_name Enemy extends RigidBody2D

var player: Player

@export var HealthBar: ProgressBar

const ROT_SPEED := 100.0
const MAX_SPEED := 200.0 # Pixels per Second
const ACCEL := 200.0 # Pixels per second squared

const PLAYER_BOUNCE_BACK := 500

var init_health := 300.0

var health := init_health:
	get:
		return health
	set(value):
		health = value
		if (health > 0):
			updateHealthBar()
		else:
			die()

func init(_position: Vector2, _player: Player) -> void:
	global_position = _position
	player = _player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Absolute direction vector
	var dir_vector: Vector2 = global_position.direction_to(player.global_position)
	state.apply_central_force(ACCEL * dir_vector)
	#if (new_velocity.length() < MAX_SPEED and linear_velocity.length() < MAX_SPEED):
		#linear_velocity = new_velocity
	health -= 1

func take_damage_from_player(dmg: int = 10) -> void:
	var dir_vector: Vector2 = global_position.direction_to(player.global_position)
	apply_impulse(-dir_vector * PLAYER_BOUNCE_BACK, Vector2.ZERO)

func updateHealthBar():
	assert(HealthBar, "No Healthbar Found.")
	HealthBar.value = (health / init_health)

func die():
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is Player:
		print("Collided with", body)
		take_damage_from_player()
