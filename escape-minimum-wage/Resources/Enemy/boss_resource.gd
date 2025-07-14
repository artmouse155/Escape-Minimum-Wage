class_name BossResource extends EnemyResource

enum BossType {BASIC, BURGER, LIFEGUARD, MOVIE_STAR}

var BossDict : Dictionary[BossType, Dictionary] = {
	BossType.BASIC : {
		name = "Big Man",
		title = "Executive",
		health = 100.0,
	},
	BossType.BURGER : {
		name = "Flip R. Burger",
		title = "Burger Flipper",
		health = 150.0,
	}
}

var boss_type : BossType

func _init(_type: BossType) -> void:
	boss_type = _type
	var boss_data = BossDict[_type]
	super._init(Type.BOSS, boss_data.health, boss_data.title)
