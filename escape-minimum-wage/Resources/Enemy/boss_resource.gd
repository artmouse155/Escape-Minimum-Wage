class_name BossResource extends EnemyResource

enum BossType {BASIC, BURGER, LIFEGUARD, MOVIE_STAR}

var BossDict : Dictionary[BossType, Dictionary] = {
	BossType.BASIC : {
		title = "Big Man",
		health = 100.0,
		attack_cycle = basic_attack_cycle
	},
	BossType.BURGER : {
		title = "Flip R. Burger",
		health = 150.0,
		attack_cycle = burger_attack_cylce
	}
}

var attack_cycle_tween : Tween

func _init(_type: BossType) -> void:
	var boss_data = BossDict[_type]
	attack_cycle = boss_data.attack_cycle
	super._init(0, Type.BOSS, 0.0, boss_data.health, boss_data.title)
	
func basic_attack_cycle():
	print("This is the basic attack cycle. Rawr")

func burger_attack_cylce():
	pass
