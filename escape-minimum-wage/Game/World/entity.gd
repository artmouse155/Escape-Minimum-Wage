class_name Entity extends RigidBody2D

@export var TopAnchor: Node2D
@export var HealthBar: ProgressBar
@export var Sprite: Sprite2D
@export var HitboxArea: Hitbox

const SQUASH_STRETCH_SPEED := 0.4 # Time for one loop
const SQUASH_STRETCH_AMOUNT := 0.05

const VISUAL_LERP := 0.2

var move_force = 0.0

var init_health := 0.0:
	get:
		return init_health
	set(value):
		if (init_health == 0.0):
			health = value
			visual_health = value
		init_health = value
var health := 0.0:
	get:
		return health
	set(value):
		health = value
		if (health <= 0):
			visual_health = health
			die()
var visual_health := 0.0

signal dead

var squash_stretch_tween : Tween

func _ready():
	start_squash_stretch()
	HitboxArea.Parent = self

func init(_init_health: float, _move_force: float):
	init_health = _init_health
	move_force = _move_force

func _process(_delta: float) -> void:
	visual_health = lerp(visual_health, health, VISUAL_LERP)
	updateHealthBar(visual_health / init_health)

func updateHealthBar(progress: float):
	assert(HealthBar, "No Healthbar Found.")
	HealthBar.value = progress

func die():
	dead.emit()
	queue_free()

func take_damage(dmg: float) -> void:
	health -= dmg

func start_squash_stretch():
	if squash_stretch_tween:
		squash_stretch_tween.kill()
	squash_stretch_tween = create_tween()
	Sprite.scale = Vector2(1 + SQUASH_STRETCH_AMOUNT, 1 - SQUASH_STRETCH_AMOUNT)
	squash_stretch_tween.tween_property(Sprite, "scale", Vector2(1 - SQUASH_STRETCH_AMOUNT, 1 + SQUASH_STRETCH_AMOUNT), SQUASH_STRETCH_SPEED).set_trans(Tween.TRANS_SINE)
	squash_stretch_tween.tween_property(Sprite, "scale", Vector2(1 + SQUASH_STRETCH_AMOUNT, 1 - SQUASH_STRETCH_AMOUNT), SQUASH_STRETCH_SPEED).set_trans(Tween.TRANS_SINE)
	squash_stretch_tween.set_loops()

func stop_squash_stretch():
	squash_stretch_tween.kill()
	Sprite.scale = Vector2.ONE
