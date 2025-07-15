class_name RegularEnemyResource extends EnemyResource

enum RegType {COMMON, UNCOMMON, LEGENDARY}

@export var raise_amt: float = 0.00
@export var level: int = 1
@export var texture: Texture2D = preload("uid://b1kxnnhkq7jdm")

const variations : Dictionary[int, Array] = {
	9 : [preload("uid://cgn66w3g72geg"), preload("uid://dcf355skb3q1i"), preload("uid://bstfr2svjsa3r")],
	19 : [preload("uid://j2ss7far86vf"), preload("uid://d0akdr0q5twp5"), preload("uid://dfwc7wcoiae1x")],
	999 : [preload("uid://dc8tsrngv1l06"), preload("uid://w6vpajsgpeor"), preload("uid://duwvc7eaasn7a")],
}

const job_variations : Dictionary[int, Array] = {
	9 : ["Assembly Line Manager", "Store Clerk", "Customer Support", "Coffee Maker", "Secretary", "Stock Broker"],
	19 : ["Slushee Maker", "Janitor", "Food Server", "Ice Cream Scooper", "Fry Maker", "Sign Twirler"],
	999 : ["Fashion Model", "Hit Actor", "Videographer", "Lighting Technician", "Script Writer", "Stunt Double"],
}

const gender_atlas : Array[AtlasTexture] = [preload("uid://b1kxnnhkq7jdm"), preload("uid://r0tp8g118dg4")]

func get_name_label():
	return "Lv %d %s" % [level, title]

func _init(_level: int):
	level = _level
	var data = PlayerResource.levels[level - 1]
	var gender_index = randi_range(0,1)
	var variation_index = randi_range(0,2)
	var min_pay = data[PlayerResource.LevelDataTypes.MIN_PAY]
	var max_pay = data[PlayerResource.LevelDataTypes.MAX_PAY]
	var _health = data[PlayerResource.LevelDataTypes.HEALTH]
	raise_amt = randf_range(min_pay, max_pay)
	var _title = "UNKNOWN"
	for key in variations.keys():
		if level < key:
			_title = job_variations[key].pick_random()
			texture = gender_atlas[gender_index].duplicate()
			if texture is AtlasTexture:
				texture.atlas = variations[key][variation_index]
			break
	
	super._init(Type.REGULAR, _health, _title)
