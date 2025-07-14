class_name Player extends Entity

@export var ResumeSpawnerNode: ResumeSpawner

var regen_rate := 0.0 # Regen per second
var regen_cooldown := 0.0 # After x seconds of not being hit, start regenning
var regen_timer := 0.0

var dash_force = 0.0
var dash_cooldown = 0.0
var dash_timer = 0.0
var dash_invincible_length = 0.0
var dash_invincibility = false
var dash_i_frames_tween : Tween

var do_reset_position := false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if do_reset_position:
		do_reset_position = false
		position = Vector2.ZERO
		linear_velocity = Vector2.ZERO
		return
	var move_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if Input.is_action_just_pressed("dash") and (move_dir != Vector2.ZERO) and (dash_timer == 0):
		dash_timer = dash_cooldown
		if dash_i_frames_tween:
			dash_i_frames_tween.kill()
		dash_i_frames_tween = create_tween()
		dash_i_frames_tween.tween_callback(set_invincible.bind(true))
		dash_i_frames_tween.tween_interval(dash_invincible_length)
		dash_i_frames_tween.tween_callback(set_invincible.bind(false))
		state.apply_central_force(dash_force * move_dir)
		
	else:
		state.apply_central_force(move_force * move_dir)

func on_playerdata_updated(playerdata : PlayerResource):
	dash_force = playerdata.dash_force
	dash_cooldown = playerdata.dash_cooldown
	dash_invincible_length = playerdata.dash_invincible_length
	regen_cooldown = playerdata.regen_cooldown
	regen_rate = playerdata.regen_rate
	init(playerdata.INITIAL_HEALTH, playerdata.speed)
	ResumeSpawnerNode.on_playerdata_updated(playerdata)

func reset_position_and_health_and_projectiles():
	do_reset_position = true
	health = init_health
	visual_health = init_health
	ResumeSpawnerNode.destroy_projectiles()

func set_invincible(b: bool):
	dash_invincibility = b

func _process(delta: float) -> void:
	dash_timer = max(0, dash_timer-delta)
	if (regen_timer <= 0):
		health = min(init_health, health+(regen_rate*delta))
	regen_timer = max(0, regen_timer-delta)
	super._process(delta)

func take_damage(dmg: float) -> void:
	if dash_invincibility:
		return
	regen_timer = regen_cooldown
	health -= dmg

func die():
	dead.emit()
