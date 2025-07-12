@tool
class_name Upgrade extends Resource

@export var icon: Texture2D = preload("uid://fi2d3dc08g5e")
@export var name : String = "Upgrade":
	get:
		return name
	set(value):
		resource_name = value
		name = value
@export var cost : float
@export var values: Dictionary[String, String] = {}

func _init(_icon : Texture2D, _name : String, _cost : float, _values : Dictionary[String, String]):
	icon = _icon
	name = _name
	cost = _cost
	values = _values
