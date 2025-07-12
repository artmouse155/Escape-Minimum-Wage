class_name Game extends Control

@export var WorldNode: World
@export var background_tiles: ShaderMaterial

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

func _process(_delta: float) -> void:
	background_tiles.set_shader_parameter("offset", WorldNode.PlayerNode.position)
	background_tiles.set_shader_parameter("zoom", WorldNode.Camera.zoom)

func update_playerdata(_playerdata: PlayerResource):
	playerdata = _playerdata
	playerdata_updated.emit(playerdata)
