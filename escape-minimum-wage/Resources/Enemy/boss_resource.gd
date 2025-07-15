class_name BossResource extends EnemyResource

enum BossType {BASIC, BURGER, LIFEGUARD, MOVIE_STAR}

const LevelToBoss : Dictionary[int, BossType] = {
	4 : BossType.BASIC,
	9 : BossType.BURGER,
	14 : BossType.LIFEGUARD,
	19 : BossType.MOVIE_STAR,
}

const BossDict : Dictionary[BossType, Dictionary] = {
	BossType.BASIC : {
		name = "Big Man",
		title = "Executive",
		health = 100.0,
	},
	BossType.BURGER : {
		name = "Flip R. Burger",
		title = "Burger Flipper",
		texture = preload("uid://bb0higa8kyxho"),
		health = 150.0,
		move_force = 4000,
		offset = Vector2(0,-190),
		anchor_y = -420,
	}
}

var boss_type : BossType

func _init(_type: BossType) -> void:
	boss_type = _type
	var boss_data = BossDict[_type]
	move_force = boss_data.move_force
	super._init(Type.BOSS, boss_data.health, boss_data.title)
