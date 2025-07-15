class_name Boss extends Enemy

@export var ProjectileScene : PackedScene
@export var AnimPlayer : AnimationPlayer
@export var AreaEffectShader : ShaderMaterial

enum States{STRAFE, BASIC_ATTACK, BURGER_ATTACK, MOVIE_STAR_ATTACK}

var strafe_distance := 750.0
var strafe_margin := 50.0

var current_state: States = States.STRAFE
var strafe_direction = 1

var type: BossResource.BossType
var attack_damage: float

var attack_cycles : Dictionary[BossResource.BossType, Callable] = {
	BossResource.BossType.BASIC : basic_attack_cycle,
	BossResource.BossType.BURGER : burger_attack_cycle,
	BossResource.BossType.MOVIE_STAR : movie_star_attack_cycle
}

# Basic
var ground_pound_tween : Tween
var GROUND_POUND_TIME := 0.6
signal do_ground_pound

func set_state(s: States):
	if s == States.STRAFE:
		strafe_direction = [-1,1][randi_range(0,1)]
	current_state = s
	print("state is now", s)

func next_state(s: States):
	attack_cycle_tween.tween_callback(set_state.bind(s))

# Called when the node enters the scene tree for the first time.
func init_boss(data : BossResource, _position: Vector2, _player: Player) -> void:
	type = data.boss_type
	Sprite.offset = BossResource.BossDict[type].offset
	TopAnchor.position.y = BossResource.BossDict[type].anchor_y
	Sprite.texture = BossResource.BossDict[type].texture
	HitboxArea.Rect.size = BossResource.BossDict[type].rect_size
	HitboxArea.position.y = -0.5 * HitboxArea.Rect.size.y
	attack_damage = BossResource.BossDict[type].attack_damage
	add_to_group("Boss")
	NameLabel.text = BossResource.BossDict[type].name
	init_enemy(data, attack_cycles[data.boss_type], _position, _player)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if current_state == States.STRAFE:
		var distance_from_player = (global_position - PlayerNode.global_position).length()
		var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
		if distance_from_player < (strafe_distance):
			state.apply_central_force(move_force * -dir_vector)
		elif distance_from_player > (strafe_distance + strafe_margin):
			state.apply_central_force(move_force * dir_vector)
		else:
			state.apply_central_force(move_force * dir_vector.rotated(deg_to_rad(90) * strafe_direction))
	else:
		pass

func play(anim: String):
	AnimPlayer.play(anim)
	
func die(rewards: bool = true):
	if rewards:
		enemy_dead.emit(title)
	queue_free()

func basic_attack_cycle():
	match current_state:
		States.STRAFE:
			attack_cycle_tween.tween_interval(randf_range(1.0,2.0))
			if randf() < 0.5:
				next_state(States.BASIC_ATTACK)
		States.BASIC_ATTACK:
			attack_cycle_tween.tween_interval(1.9)
			attack_cycle_tween.tween_callback(ground_pound)
			attack_cycle_tween.tween_interval(0.8)
			next_state(States.STRAFE)
			play("BASIC")

func ground_pound() -> void:
	do_ground_pound.emit()
	var distance_from_player = (global_position - PlayerNode.global_position).length()
	if distance_from_player <= 850:
		damage_player(attack_damage)
	if ground_pound_tween:
		ground_pound_tween.kill()
	ground_pound_tween = create_tween()
	ground_pound_tween.tween_callback(AreaEffectShader.set_shader_parameter.bind("opacity", 0.0))
	ground_pound_tween.tween_method((func (x) : AreaEffectShader.set_shader_parameter("radius", x)), -0.1, 0.8, GROUND_POUND_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	ground_pound_tween.parallel().tween_method((func (x) : AreaEffectShader.set_shader_parameter("opacity", x)), 1.0, 0.0, GROUND_POUND_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

func burger_attack_cycle():
	match current_state:
		States.STRAFE:
			attack_cycle_tween.tween_interval(randf_range(1.0,3.0))
			if randf() < 0.5:
				next_state(States.BURGER_ATTACK)
		States.BURGER_ATTACK:
			attack_cycle_tween.tween_interval(0.9)
			attack_cycle_tween.tween_callback(burger_attack)
			attack_cycle_tween.tween_interval(0.3)
			next_state(States.STRAFE)
			play("BURGER")
			
func burger_attack() -> void:
	var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
	var diff = .1
	for i in range(3):
		dir_vector = dir_vector.rotated(diff)
		var projectile: Projectile = ProjectileScene.instantiate()
		projectile.init(preload("uid://jekwwaa2mjek"), dir_vector, 2000, attack_damage, "Player") 
		HitboxArea.add_child(projectile)

func movie_star_attack_cycle():
	match current_state:
		States.STRAFE:
			attack_cycle_tween.tween_interval(randf_range(1.0,3.0))
			if randf() < 0.5:
				next_state(States.MOVIE_STAR_ATTACK)
		States.MOVIE_STAR_ATTACK:
			attack_cycle_tween.tween_interval(1.05)
			attack_cycle_tween.tween_callback(movie_star_attack)
			attack_cycle_tween.tween_interval(0.45)
			next_state(States.STRAFE)
			play("MOVIE_STAR")

func movie_star_attack():
	var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
	var diff = (2 * PI) / 10.0
	for i in range(10):
		dir_vector = dir_vector.rotated(diff)
		var projectile: Projectile = ProjectileScene.instantiate()
		projectile.init(preload("uid://x1fvd6yb6f7r"), dir_vector, 1500, attack_damage, "Player") 
		HitboxArea.add_child(projectile)
