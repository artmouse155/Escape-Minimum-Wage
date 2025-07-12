class_name Game extends Control

@export var WorldNode: World
@export var background_tiles: ShaderMaterial

@export var Pause: Button
@export var Settings: Button
@export var PauseScreen: ColorRect

const LevelDataTypes := {
		LEVEL = "level",
		WAGE = "wage",
		NUM_RAISES = "num_raises",
		RAISE_NEEDED = "raise_needed",
		AMT_PER_RAISE = "amt_per_raise",
		MIN_PAY = "min_pay",
		MAX_PAY = "max_pay"
	}

@onready var playerdata: PlayerResource

signal playerdata_updated(_playerdata: PlayerResource)

func _ready() -> void:
	assert(background_tiles, "Background Tiles not connected")
	assert(WorldNode, "No world node found")
	playerdata_updated.connect(WorldNode.PlayerNode.on_playerdata_updated)
	playerdata_updated.connect(WorldNode.EnemySpawnerNode.on_playerdata_updated)
	update_playerdata(PlayerResource.new())

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	PauseScreen.visible = get_tree().paused
	if get_tree().paused:
		Pause.icon = preload("uid://dvv3o43uodmbs")
		Settings.icon = preload("uid://cq8ug5bepd84n")
	else:
		Pause.icon = preload("uid://cvy8hb0kkcmuv")
		Settings.icon = preload("uid://dtvw1irhowm2l")

func _process(_delta: float) -> void:
	background_tiles.set_shader_parameter("offset", WorldNode.PlayerNode.position)
	background_tiles.set_shader_parameter("zoom", WorldNode.Camera.zoom)

func update_playerdata(_playerdata: PlayerResource):
	playerdata = _playerdata
	playerdata_updated.emit(playerdata)
