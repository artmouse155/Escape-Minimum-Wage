class_name Enemy extends RigidBody2D

var PlayerNode: Player

@export var HealthBar: ProgressBar
@export var RaiseLabel: Label
@export var NameLabel: Label

@export var TopAnchor: Node2D

const ACCEL := 2000.0 # Pixels per second squared
const PLAYER_BOUNCE_BACK := 10000
const VISUAL_LERP := 0.5

var touching_player = false

var init_health := 1.0
var health := 0.0:
	get:
		return health
	set(value):
		health = value
		if (health <= 0):
			die()
var visual_health := 0.0

var raise_amt := 0.00:
	get:
		return raise_amt
	set(value):
		RaiseLabel.text = ("$%0.2f" % value) if value > 0 else ""
		raise_amt = value

var title := "Enemy"

var level := 1
var rarity : EnemyResource.Type = EnemyResource.Type.COMMON

signal dead(_raise_amt: float, _title: String)

func init(data: EnemyResource, _position: Vector2, _player: Player) -> void:
	init_health = data.health
	health = data.health
	visual_health = data.health
	raise_amt = data.raise_amt
	level = data.level
	title = data.title
	NameLabel.text = data.get_name_label()
	global_position = _position
	PlayerNode = _player
	if data is BossResource:
		add_to_group("Boss")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Absolute direction vector
	var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
	if not touching_player:
		state.apply_central_force(ACCEL * dir_vector)
	else:
		state.apply_central_force(PLAYER_BOUNCE_BACK * -dir_vector)

func _process(_delta: float) -> void:
	visual_health = lerp(visual_health, health, VISUAL_LERP)
	updateHealthBar(visual_health / init_health)

func take_damage_from_player(dmg: int) -> void:
	health -= dmg

func updateHealthBar(progress: float):
	assert(HealthBar, "No Healthbar Found.")
	HealthBar.value = progress

func die(rewards: bool = true):
	if rewards:
		dead.emit(raise_amt, title)
	queue_free()


func _on_body_entered(body: Node) -> void:
	match body.get_script(): # Weird workaround
		Player:
			touching_player = true
			take_damage_from_player(20)


func _on_body_exited(body: Node) -> void:
	if body is Player:
		touching_player = false
