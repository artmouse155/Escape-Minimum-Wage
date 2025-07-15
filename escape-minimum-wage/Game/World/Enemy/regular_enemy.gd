class_name RegularEnemy extends Enemy

@export var RaiseLabel: Label
@export var ProjectileScene: PackedScene

enum States{CHASE_PLAYER, THROW_PROJECTILE_MOVE, THROW_PROJECTILE_WAIT}

const PROJECTILE_DISTANCE := 1200.0 #pixels
const PROJECTILE_MARGIN := 50.0 #pixels

const PLAYER_BOUNCE_BACK := 30000

const ATTACK_COOLDOWN := 2.0 # Seconds
var attack_timer := 0.0

var raise_amt := 0.00:
	get:
		return raise_amt
	set(value):
		RaiseLabel.text = ("$%0.2f" % value)
		raise_amt = value
var level := 1
var rarity : RegularEnemyResource.RegType = RegularEnemyResource.RegType.COMMON

var current_state = States.CHASE_PLAYER

signal regular_enemy_dead(_raise_amt: float, _title: String)

# Called when the node enters the scene tree for the first time.
func init_reg(data : RegularEnemyResource, _position: Vector2, _player: Player):
	raise_amt = data.raise_amt
	level = data.level
	Sprite.texture = data.texture
	NameLabel.text = data.get_name_label()
	init_enemy(data, regular_attack_cycle, _position, _player)

func die(rewards: bool = true):
	if rewards:
		regular_enemy_dead.emit(raise_amt, title)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Absolute direction vector
	var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
	if not touching_player:
		match current_state:
			States.CHASE_PLAYER:
				state.apply_central_force(move_force * dir_vector)
			States.THROW_PROJECTILE_MOVE:
				# Try to get 10 feet from player
				var distance_from_player = (global_position - PlayerNode.global_position).length()
				if distance_from_player < (PROJECTILE_DISTANCE):
					state.apply_central_force(move_force * -dir_vector)
				elif distance_from_player > (PROJECTILE_DISTANCE + PROJECTILE_MARGIN):
					state.apply_central_force(move_force * dir_vector)
	else:
		state.apply_central_force(PLAYER_BOUNCE_BACK * -dir_vector)
	
		
func _process(delta: float) -> void:
	attack_timer = max(0, attack_timer-delta)
	super._process(delta)

func _on_body_entered(body: Node) -> void:
	match body.get_script(): # Weird workaround
		Player:
			touching_player = true
			if (attack_timer <= 0):
				damage_player(physical_damage)
				attack_timer = ATTACK_COOLDOWN

func _on_body_exited(body: Node) -> void:
	if body is Player:
		touching_player = false

func regular_attack_cycle():
	
	var next_state : Callable = func (s: States):
		attack_cycle_tween.tween_callback(set_state.bind(s))
	
	match current_state:
		States.CHASE_PLAYER:
			attack_cycle_tween.tween_interval(randf_range(5.0, 10.0))
			if randf() < 0.5:
				next_state.call(States.THROW_PROJECTILE_MOVE)
		States.THROW_PROJECTILE_MOVE:
			attack_cycle_tween.tween_interval(3.0)
			next_state.call(States.THROW_PROJECTILE_WAIT)
		States.THROW_PROJECTILE_WAIT:
			attack_cycle_tween.tween_interval(0.5)
			attack_cycle_tween.tween_callback(attempt_throw_projectile)
			next_state.call(States.CHASE_PLAYER)


func set_state(s: States):
	current_state = s

func attempt_throw_projectile():
	var distance_from_player = (global_position - PlayerNode.global_position).length()
	if distance_from_player >= (PROJECTILE_DISTANCE):
		var projectile: Projectile = ProjectileScene.instantiate()
		var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
		projectile.init(preload("uid://dhjhvda4e5d3n"), dir_vector, 1000, 10, "Player") 
		add_child(projectile)
