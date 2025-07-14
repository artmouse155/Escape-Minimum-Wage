class_name UpgradeList extends Resource

@export var name : String = "Upgrade Name"
@export_multiline var fake_desc: String = "Fake"
@export_multiline var real_desc: String = "Real"
@export var upgrades : Array[Upgrade] = []

func _init(_name : String = "Upgrade Name", _fake_desc: String = "Fake", _real_desc: String = "Real", _upgrades : Array[Upgrade] = []) -> void:
	name = _name
	fake_desc = _fake_desc
	real_desc = _real_desc
	upgrades = _upgrades
