class_name Game extends Control

@export var WorldNode: World
@export var background_tiles: ShaderMaterial

@export var Pause: Button
@export var Settings: Button
@export var PauseScreen: ColorRect

# XP Bar
@export var XPBar: ProgressBar
@export var Skull: TextureRect

@export_group("Labels")
@export var TitleLabel: Label
@export var SalaryLabel: RichTextLabel
@export var MoneyLabel: Label
@export var RateLabel: RichTextLabel
@export var LevelLabel: Label
@export var XPBarLabel: Label

@export var TitleNode: Title

const HOURS_PER_SECOND := .1

@onready var playerdata: PlayerResource

signal playerdata_updated(_playerdata: PlayerResource)

# For the UI
var xp_progress := 0.0

var current_level_data : Dictionary = PlayerResource.levels[PlayerResource.INITIAL_LEVEL - 1]
var next_level_data : Dictionary = PlayerResource.levels[PlayerResource.INITIAL_LEVEL]
var current_wage_threshold : float = current_level_data[PlayerResource.LevelDataTypes.WAGE]
var next_wage_threshold : float = next_level_data[PlayerResource.LevelDataTypes.WAGE]
var raise_needed : float = current_level_data[PlayerResource.LevelDataTypes.RAISE_NEEDED]
var is_boss_level : bool = false

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
	if Input.is_action_just_pressed("debug_cheat"):
		playerdata.salary += raise_needed
		update_playerdata(playerdata)

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	PauseScreen.visible = get_tree().paused
	if get_tree().paused:
		Pause.icon = preload("uid://dvv3o43uodmbs")
		Settings.icon = preload("uid://cq8ug5bepd84n")
	else:
		Pause.icon = preload("uid://cvy8hb0kkcmuv")
		Settings.icon = preload("uid://dtvw1irhowm2l")

func _process(delta: float) -> void:
	background_tiles.set_shader_parameter("offset", WorldNode.PlayerNode.position)
	background_tiles.set_shader_parameter("zoom", WorldNode.Camera.zoom)
	
	# Give our player the money they worked so hard for!
	playerdata.money += (playerdata.salary * HOURS_PER_SECOND * delta)
	update_playerdata(playerdata)

func update_playerdata(_playerdata: PlayerResource):
	playerdata = _playerdata
	TitleLabel.text = playerdata.title
	SalaryLabel.text = "$%0.2f/hr [color=gray][i]($%0.2f/sec)[/i][/color]" % [playerdata.salary, playerdata.salary * HOURS_PER_SECOND]
	MoneyLabel.text = "$%0.2f" % playerdata.money
	RateLabel.text = "[color=#34d134][i]+$%0.2f/sec[/i][/color]" % (playerdata.salary * HOURS_PER_SECOND)
	xp_progress = (playerdata.salary - current_wage_threshold) / raise_needed
	if xp_progress >= 1.0:
		if playerdata.level == PlayerResource.MAX_LEVEL:
			XPBarLabel.text = "Max Level Reached"
			XPBar.value = 1.0
			playerdata_updated.emit(playerdata)
		elif is_boss_level:
			summon_boss()
		else:
			next_level()
	else:
		XPBarLabel.text = "$%0.2f / $%0.2f" % [playerdata.salary, next_wage_threshold]
		XPBar.value = (playerdata.salary - current_wage_threshold) / raise_needed
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
	WorldNode.EnemySpawnerNode.summon_boss()
	next_level()

func on_boss_dead():
	next_level()

func on_enemy_dead(_raise_amt: float, _title: String):
	playerdata.salary += _raise_amt
	playerdata.title = _title
	update_playerdata(playerdata)
