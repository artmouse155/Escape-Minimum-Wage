class_name BossResource extends EnemyResource

enum BossType {BASIC, BURGER, MOVIE_STAR}

const LevelToBoss : Dictionary[int, BossType] = {
	9 : BossType.BASIC,
	19 : BossType.BURGER,
	29 : BossType.MOVIE_STAR,
}

const BossDict : Dictionary[BossType, Dictionary] = {
	BossType.BASIC : {
		name = "Big Frank",
		title = "Assembly Line Manager",
		texture = preload("uid://bqe7lmxhwts6n"),
		health = 5000.0,
		move_force = 5000,
		offset = Vector2(0,-240),
		rect_size = Vector2(320,460),
		anchor_y = -550,
		attack_damage = 45
	},
	BossType.BURGER : {
		name = "Flip R. Burger",
		title = "Burger Flipper",
		texture = preload("uid://bb0higa8kyxho"),
		health = 32000.0,
		move_force = 4000,
		offset = Vector2(0,-190),
		rect_size = Vector2(200,300),
		anchor_y = -420,
		attack_damage = 20
	},
	BossType.MOVIE_STAR : {
		name = "Ricky Smooth",
		title = "Director",
		texture = preload("uid://bclxbqe2b17tg"),
		health = 500000.0,
		move_force = 5000,
		offset = Vector2(0,-270),
		rect_size = Vector2(280,520),
		anchor_y = -570,
		attack_damage = 49
	},
}

var boss_type : BossType

func _init(_type: BossType) -> void:
	boss_type = _type
	var boss_data = BossDict[_type]
	move_force = boss_data.move_force
	super._init(Type.BOSS, boss_data.health, boss_data.title)
