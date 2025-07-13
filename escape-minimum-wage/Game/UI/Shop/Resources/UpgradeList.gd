class_name UpgradeList extends Resource

@export var name : String = "Upgrade Name"
@export var upgrades : Array[Upgrade] = []

func _init(_name : String = "Upgrade Name", _upgrades : Array[Upgrade] = []) -> void:
	name = _name
	upgrades = _upgrades
