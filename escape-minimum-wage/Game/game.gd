class_name Game extends Control

#region exports
@export var WorldNode: World
@export var background_tiles: ShaderMaterial

# XP Bar
@export_group("XP Bar")
@export var xpbar_circle: ShaderMaterial
@export var XPBar: ProgressBar
@export var normal_xp_bar_theme: StringName = &"XPBar"
@export var boss_xp_bar_theme: StringName = &"PerformanceReviewBar"
@export var normal_xp_bar_font: Font = preload("res://Resources/Roboto/static/Roboto-Bold.ttf")
@export var boss_xp_bar_font: Font = preload("res://Resources/Alfa_Slab_One/AlfaSlabOne-Regular.ttf")
@export var normal_xp_bar_font_size: int = 16
@export var boss_xp_bar_font_size: int = 12
@export var Skull: TextureRect
@export_subgroup("Colors")
@export var xp_green: Color
@export var xp_red: Color
@export var label_white: Color
@export var label_yellow: Color
@export_subgroup("")
@export_group("")
@export var Pause: Button
@export var Settings: Button
@export var PauseScreen: ColorRect
@export var PauseScreenText: Label
@export var TitleNode: Title

@export_group("Labels")
@export var TitleLabel: Label
@export var SalaryLabel: RichTextLabel
@export var MoneyLabel: Label
@export var RateLabel: RichTextLabel

#XP Bar
@export var LevelLabel: Label
@export var XPBarLabel: Label
@export_group("")

@export var ShopNode: Shop
@export var ShopFollow: PathFollow2D

#endregion

enum PauseMode {PAUSE_BUTTON, SHOP}

const HOURS_PER_SECOND := .1

@onready var playerdata: PlayerResource

signal playerdata_updated(_playerdata: PlayerResource)

# For the UI
var xp_progress := 0.0
var visual_salary := 0.0
var VISUAL_LERP := 0.3

var current_level_data : Dictionary = PlayerResource.levels[PlayerResource.INITIAL_LEVEL - 1]
var next_level_data : Dictionary = PlayerResource.levels[PlayerResource.INITIAL_LEVEL]
var current_wage_threshold : float = current_level_data[PlayerResource.LevelDataTypes.WAGE]
var next_wage_threshold : float = next_level_data[PlayerResource.LevelDataTypes.WAGE]
var raise_needed : float = current_level_data[PlayerResource.LevelDataTypes.RAISE_NEEDED]

var is_boss_level : bool = false

# Pausing
var pause_tween : Tween
const PAUSE_ANIM : float = 0.25

# Shop
var shop_tween : Tween

func _ready() -> void:
	assert(background_tiles, "Background Tiles not connected")
	assert(WorldNode, "No world node found")
	playerdata_updated.connect(WorldNode.PlayerNode.on_playerdata_updated)
	playerdata_updated.connect(WorldNode.EnemySpawnerNode.on_playerdata_updated)
	WorldNode.EnemySpawnerNode.enemy_dead.connect(on_enemy_dead)
	WorldNode.EnemySpawnerNode.boss_dead.connect(on_boss_dead)
	update_playerdata(PlayerResource.new())
	LevelLabel.text = str(playerdata.level)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	if not get_tree().paused and Input.is_action_just_pressed("debug_cheat"):
		on_enemy_dead(raise_needed, "DEBUG CHEAT")


func toggle_pause(pause_mode : PauseMode = PauseMode.PAUSE_BUTTON, toggle: bool = true, paused: bool = true) -> void:
	match pause_mode:
		PauseMode.PAUSE_BUTTON:
			PauseScreenText.text = "PAUSED"
		PauseMode.SHOP:
			PauseScreenText.text = ""
			if shop_tween:
				shop_tween.kill()
			shop_tween = create_tween()
			shop_tween.tween_property(ShopFollow, "progress_ratio", 1.0 if get_tree().paused else 0.0, PAUSE_ANIM).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	get_tree().paused = not get_tree().paused
	if pause_tween:
		pause_tween.kill()
	pause_tween = create_tween()
	#PauseScreen.modulate.a = 0.0 if get_tree().paused else 1.0
	PauseScreen.show()
	pause_tween.tween_property(PauseScreen, "modulate:a", 1.0 if get_tree().paused else 0.0, PAUSE_ANIM)
	pause_tween.tween_callback(PauseScreen.show if get_tree().paused else PauseScreen.hide)
	if get_tree().paused:
		Pause.icon = preload("uid://dvv3o43uodmbs")
		Settings.icon = preload("uid://cq8ug5bepd84n")
	else:
		Pause.icon = preload("uid://cvy8hb0kkcmuv")
		Settings.icon = preload("uid://dtvw1irhowm2l")


func _process(delta: float) -> void:
	background_tiles.set_shader_parameter("offset", WorldNode.PlayerNode.position)
	background_tiles.set_shader_parameter("zoom", WorldNode.Camera.zoom)
	
	if not get_tree().paused:
		# Give our player the money they worked so hard for!
		playerdata.money += (playerdata.salary * HOURS_PER_SECOND * delta)
		update_playerdata(playerdata)
		
		#update the XPBar visuals
		
		visual_salary = lerp(visual_salary, playerdata.salary, VISUAL_LERP)
		XPBar.value = (visual_salary - current_wage_threshold) / raise_needed
		SalaryLabel.text = "$%0.2f/hr [color=gray][i]($%0.2f/sec)[/i][/color]" % [visual_salary, visual_salary * HOURS_PER_SECOND]
		RateLabel.text = "[color=#34d134][i]+$%0.2f/sec[/i][/color]" % (visual_salary * HOURS_PER_SECOND)


func update_playerdata(_playerdata: PlayerResource):
	playerdata = _playerdata
	TitleLabel.text = playerdata.title
	MoneyLabel.text = "$%0.2f" % playerdata.money
	xp_progress = (playerdata.salary - current_wage_threshold) / raise_needed
	if xp_progress >= 1.0:
		if playerdata.level == PlayerResource.MAX_LEVEL:
			XPBarLabel.text = "Max Level Reached"
			XPBar.value = 1.0
			playerdata_updated.emit(playerdata)
		elif is_boss_level:
			if not playerdata.is_fighting_boss:
				summon_boss()
			playerdata_updated.emit(playerdata)
		else:
			next_level()
	else:
		XPBarLabel.text = "$%0.2f / $%0.2f" % [visual_salary, next_wage_threshold]
		playerdata_updated.emit(playerdata)


func next_level():
	TitleNode.show_title("LEVEL UP")
	playerdata.level += 1
	LevelLabel.text = str(playerdata.level)
	if (playerdata.level == PlayerResource.MAX_LEVEL):
		pass
	else:
		current_level_data = PlayerResource.levels[playerdata.level - 1]
		next_level_data = PlayerResource.levels[playerdata.level]
		current_wage_threshold = current_level_data[PlayerResource.LevelDataTypes.WAGE]
		next_wage_threshold = next_level_data[PlayerResource.LevelDataTypes.WAGE]
		raise_needed = current_level_data[PlayerResource.LevelDataTypes.RAISE_NEEDED]
		is_boss_level = current_level_data[PlayerResource.LevelDataTypes.BOSS_LEVEL]
		Skull.visible = is_boss_level
	update_playerdata(playerdata)


func summon_boss():
	TitleNode.show_title("PERFORMANCE\nREVIEW")
	playerdata.is_fighting_boss = true
	playerdata.salary = next_wage_threshold
	XPBarLabel.label_settings.font_color = label_yellow
	XPBarLabel.label_settings.font = boss_xp_bar_font
	XPBarLabel.label_settings.font_size = boss_xp_bar_font_size
	xpbar_circle.set_shader_parameter("color", xp_red)
	XPBar.theme_type_variation = boss_xp_bar_theme
	XPBar.value = 1.0                               
	XPBarLabel.text = "PERFORMANCE REVIEW"
	WorldNode.EnemySpawnerNode.summon_boss()
	

func on_boss_dead():
	playerdata.is_fighting_boss = false
	XPBarLabel.label_settings.font_color = label_white
	XPBarLabel.label_settings.font = normal_xp_bar_font
	XPBarLabel.label_settings.font_size = normal_xp_bar_font_size
	xpbar_circle.set_shader_parameter("color", xp_green)
	XPBar.theme_type_variation = normal_xp_bar_theme
	next_level()


func on_enemy_dead(_raise_amt: float, _title: String):
	if not playerdata.is_fighting_boss:
		playerdata.salary += _raise_amt
		playerdata.title = _title
		update_playerdata(playerdata)
