class_name Enemy extends RigidBody2D

var PlayerNode: Player

@export var HealthBar: ProgressBar

const ACCEL := 2000.0 # Pixels per second squared

const PLAYER_BOUNCE_BACK := 10000

var init_health := 300.0

var touching_player = false

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
	PlayerNode = _player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Absolute direction vector
	var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
	if not touching_player:
		state.apply_central_force(ACCEL * dir_vector)
	else:
		state.apply_central_force(PLAYER_BOUNCE_BACK * -dir_vector)
	health -= 1

func take_damage_from_player(dmg: int) -> void:
	health -= dmg

func updateHealthBar():
	assert(HealthBar, "No Healthbar Found.")
	HealthBar.value = (health / init_health)

func die():
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is Player:
		touching_player = true
		take_damage_from_player(50)


func _on_body_exited(body: Node) -> void:
	if body is Player:
		touching_player = false
