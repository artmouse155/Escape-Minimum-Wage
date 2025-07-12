extends Control

@export var WorldNode: World

@export var background_tiles: ShaderMaterial

func _process(_delta: float) -> void:
	assert(background_tiles, "Background Tiles not connected")
	assert(WorldNode, "No world node found")
	background_tiles.set_shader_parameter("offset", WorldNode.PlayerNode.position)
	background_tiles.set_shader_parameter("zoom", WorldNode.Camera.zoom)
