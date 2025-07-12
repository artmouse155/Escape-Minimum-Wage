@tool
class_name UpgradeList extends Resource

@export var name : String = "Upgrade Name"
@export var upgrades : Array[Upgrade] = []

func _init(_name : String, _upgrades : Array[Upgrade]) -> void:
	name = _name
	upgrades = _upgrades
