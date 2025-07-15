class_name Boss extends Enemy

@export var ProjectileScene : PackedScene
@export var AnimPlayer : AnimationPlayer

enum States{STRAFE, BURGER_ATTACK}

var strafe_distance := 850.0
var strafe_margin := 50.0

var current_state: States = States.STRAFE

var strafe_direction = 1

var type: BossResource.BossType

var attack_cycles : Dictionary[BossResource.BossType, Callable] = {
	BossResource.BossType.BASIC : basic_attack_cycle,
	BossResource.BossType.BURGER : burger_attack_cycle,
	BossResource.BossType.LIFEGUARD : lifeguard_attack_cycle,
	BossResource.BossType.MOVIE_STAR : movie_star_attack_cycle
}

func set_state(s: States):
	if s == States.STRAFE:
		strafe_direction = [-1,1][randi_range(0,1)]
	current_state = s

# Called when the node enters the scene tree for the first time.
func init_boss(data : BossResource, _position: Vector2, _player: Player) -> void:
	type = data.boss_type
	Sprite.offset = BossResource.BossDict[type].offset
	TopAnchor.position.y = BossResource.BossDict[type].anchor_y
	Sprite.texture = BossResource.BossDict[type].texture
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
		match type:
			BossResource.BossType.BASIC:
				basic_forces(state)
			BossResource.BossType.BURGER:
				burger_forces(state)
			BossResource.BossType.LIFEGUARD:
				lifeguard_forces(state)
			BossResource.BossType.MOVIE_STAR:
				movie_star_forces(state)

func play(anim: String):
	AnimPlayer.play(anim)
	
func die(rewards: bool = true):
	if rewards:
		enemy_dead.emit(title)
	queue_free()

func basic_attack_cycle():
	pass

func basic_forces(state: PhysicsDirectBodyState2D) -> void:
	pass
	
func burger_attack_cycle():
	pass
	#if attack_cycle_tween:
		#attack_cycle_tween.kill()
	#attack_cycle_tween = create_tween()
	#attack_cycle_tween.finished.connect(attack)
	#
	var next_state : Callable = func (s: States):
		attack_cycle_tween.tween_callback(set_state.bind(s))
	
	match current_state:
		States.STRAFE:
			attack_cycle_tween.tween_interval(randf_range(1.0,3.0))
			if randf() < 0.5:
				next_state.call(States.BURGER_ATTACK)
		States.BURGER_ATTACK:
			play("BURGER")
			attack_cycle_tween.tween_interval(0.9)
			attack_cycle_tween.tween_callback(burger_attack)
			attack_cycle_tween.tween_interval(0.3)
			next_state.call(States.STRAFE)

func burger_forces(state: PhysicsDirectBodyState2D) -> void:
	match current_state:
		States.BURGER_ATTACK:
			pass
			
func burger_attack() -> void:
	var dir_vector: Vector2 = global_position.direction_to(PlayerNode.global_position)
	var diff = .1
	for i in range(3):
		dir_vector = dir_vector.rotated(diff)
		var projectile: Projectile = ProjectileScene.instantiate()
		projectile.init(preload("uid://jekwwaa2mjek"), dir_vector, 2000, 15, "Player") 
		HitboxArea.add_child(projectile)
			
	
func lifeguard_attack_cycle():
	pass
	
func lifeguard_forces(state: PhysicsDirectBodyState2D) -> void:
	pass
	
func movie_star_attack_cycle():
	pass

func movie_star_forces(state: PhysicsDirectBodyState2D) -> void:
	pass
