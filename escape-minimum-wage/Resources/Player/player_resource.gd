class_name PlayerResource extends Resource

const INITIAL_LEVEL : int = 1
const MAX_LEVEL : int = 30

const INITIAL_HEALTH : float = 100.0

@export var regen_rate := 2.0 # Regen per second
@export var regen_cooldown := 5.0 # After x seconds of not being hit, start regenning

var level : int = INITIAL_LEVEL
@export var title : String = "Game Developer"
@export var salary : float = levels[INITIAL_LEVEL - 1][LevelDataTypes.WAGE]
@export var money : float = 0.00

var is_fighting_boss = false

var work_history : Dictionary[String,int] = {}

@export var speed : int = 50000
@export var dash_force: int = 30 * speed
@export var dash_cooldown: float = 0.4
@export var dash_invincible_length: float = 0.3

# Resumes
@export var resume_spawn_rate : float = 0.2 # per second
@export var resume_speed : float = 2000.0

@export var upgrades : Dictionary[Shop.UpgradeTypes, int] = {}

func increment_upgrade(type: Shop.UpgradeTypes) -> void:
	if not upgrades.has(type):
		upgrades[type] = 0
	upgrades[type] += 1

func get_upgrade(type: Shop.UpgradeTypes) -> Upgrade:
	return Shop.UpgradeLists[type].upgrades[get_upgrade_index(type)]

func get_upgrade_index(type: Shop.UpgradeTypes) -> int:
	if not upgrades.has(type):
		upgrades[type] = 0
	return upgrades[type]

const LevelDataTypes := {
		LEVEL = "level",
		WAGE = "wage",
		NUM_RAISES = "num_raises",
		RAISE_NEEDED = "raise_needed",
		AMT_PER_RAISE = "amt_per_raise",
		MIN_PAY = "min_pay",
		MAX_PAY = "max_pay",
		BOSS_LEVEL = "boss_level"
	}

const levels : Array[Dictionary] = [
  {
	"level": 1,
	"wage": 7.25,
	"num_raises": 5,
	"raise_needed": 0.75,
	"amt_per_raise": 0.15,
	"min_pay": 0.105,
	"max_pay": 0.195,
	"boss_level": false
  },
  {
	"level": 2,
	"wage": 8,
	"num_raises": 6,
	"raise_needed": 1,
	"amt_per_raise": 0.1666666667,
	"min_pay": 0.1166666667,
	"max_pay": 0.2166666667,
	"boss_level": false
  },
  {
	"level": 3,
	"wage": 9,
	"num_raises": 6,
	"raise_needed": 1.5,
	"amt_per_raise": 0.25,
	"min_pay": 0.175,
	"max_pay": 0.325,
	"boss_level": false
  },
  {
	"level": 4,
	"wage": 10.5,
	"num_raises": 7,
	"raise_needed": 2.5,
	"amt_per_raise": 0.3571428571,
	"min_pay": 0.25,
	"max_pay": 0.4642857143,
	"boss_level": true
  },
  {
	"level": 5,
	"wage": 13,
	"num_raises": 7,
	"raise_needed": 4,
	"amt_per_raise": 0.5714285714,
	"min_pay": 0.4,
	"max_pay": 0.7428571429,
	"boss_level": false
  },
  {
	"level": 6,
	"wage": 17,
	"num_raises": 8,
	"raise_needed": 8,
	"amt_per_raise": 1,
	"min_pay": 0.7,
	"max_pay": 1.3,
	"boss_level": false
  },
  {
	"level": 7,
	"wage": 25,
	"num_raises": 9,
	"raise_needed": 10,
	"amt_per_raise": 1.111111111,
	"min_pay": 0.7777777778,
	"max_pay": 1.444444444,
	"boss_level": false
  },
  {
	"level": 8,
	"wage": 35,
	"num_raises": 10,
	"raise_needed": 15,
	"amt_per_raise": 1.5,
	"min_pay": 1.05,
	"max_pay": 1.95,
	"boss_level": false
  },
  {
	"level": 9,
	"wage": 50,
	"num_raises": 11,
	"raise_needed": 30,
	"amt_per_raise": 2.727272727,
	"min_pay": 1.909090909,
	"max_pay": 3.545454545,
	"boss_level": true
  },
  {
	"level": 10,
	"wage": 80,
	"num_raises": 13,
	"raise_needed": 40,
	"amt_per_raise": 3.076923077,
	"min_pay": 2.153846154,
	"max_pay": 4,
	"boss_level": false
  },
  {
	"level": 11,
	"wage": 120,
	"num_raises": 15,
	"raise_needed": 80,
	"amt_per_raise": 5.333333333,
	"min_pay": 3.733333333,
	"max_pay": 6.933333333,
	"boss_level": false
  },
  {
	"level": 12,
	"wage": 200,
	"num_raises": 18,
	"raise_needed": 125,
	"amt_per_raise": 6.944444444,
	"min_pay": 4.861111111,
	"max_pay": 9.027777778,
	"boss_level": false
  },
  {
	"level": 13,
	"wage": 325,
	"num_raises": 22,
	"raise_needed": 175,
	"amt_per_raise": 7.954545455,
	"min_pay": 5.568181818,
	"max_pay": 10.34090909,
	"boss_level": false
  },
  {
	"level": 14,
	"wage": 500,
	"num_raises": 27,
	"raise_needed": 300,
	"amt_per_raise": 11.11111111,
	"min_pay": 7.777777778,
	"max_pay": 14.44444444,
	"boss_level": true
  },
  {
	"level": 15,
	"wage": 800,
	"num_raises": 33,
	"raise_needed": 400,
	"amt_per_raise": 12.12121212,
	"min_pay": 8.484848485,
	"max_pay": 15.75757576,
	"boss_level": false
  },
  {
	"level": 16,
	"wage": 1200,
	"num_raises": 40,
	"raise_needed": 800,
	"amt_per_raise": 20,
	"min_pay": 14,
	"max_pay": 26,
	"boss_level": false
  },
  {
	"level": 17,
	"wage": 2000,
	"num_raises": 50,
	"raise_needed": 1200,
	"amt_per_raise": 24,
	"min_pay": 16.8,
	"max_pay": 31.2,
	"boss_level": false
  },
  {
	"level": 18,
	"wage": 3200,
	"num_raises": 62,
	"raise_needed": 2000,
	"amt_per_raise": 32.25806452,
	"min_pay": 22.58064516,
	"max_pay": 41.93548387,
	"boss_level": false
  },
  {
	"level": 19,
	"wage": 5200,
	"num_raises": 77,
	"raise_needed": 3300,
	"amt_per_raise": 42.85714286,
	"min_pay": 30,
	"max_pay": 55.71428571,
	"boss_level": true
  },
  {
	"level": 20,
	"wage": 8500,
	"num_raises": 97,
	"raise_needed": 5500,
	"amt_per_raise": 56.70103093,
	"min_pay": 39.69072165,
	"max_pay": 73.71134021,
	"boss_level": false
  },
  {
	"level": 21,
	"wage": 14000,
	"num_raises": 121,
	"raise_needed": 8000,
	"amt_per_raise": 66.11570248,
	"min_pay": 46.28099174,
	"max_pay": 85.95041322,
	"boss_level": false
  },
  {
	"level": 22,
	"wage": 22000,
	"num_raises": 153,
	"raise_needed": 13000,
	"amt_per_raise": 84.96732026,
	"min_pay": 59.47712418,
	"max_pay": 110.4575163,
	"boss_level": false
  },
  {
	"level": 23,
	"wage": 35000,
	"num_raises": 193,
	"raise_needed": 23000,
	"amt_per_raise": 119.1709845,
	"min_pay": 83.41968912,
	"max_pay": 154.9222798,
	"boss_level": false
  },
  {
	"level": 24,
	"wage": 58000,
	"num_raises": 243,
	"raise_needed": 42000,
	"amt_per_raise": 172.8395062,
	"min_pay": 120.9876543,
	"max_pay": 224.691358,
	"boss_level": true
  },
  {
	"level": 25,
	"wage": 100000,
	"num_raises": 307,
	"raise_needed": 50000,
	"amt_per_raise": 162.8664495,
	"min_pay": 114.0065147,
	"max_pay": 211.7263844,
	"boss_level": false
  },
  {
	"level": 26,
	"wage": 150000,
	"num_raises": 389,
	"raise_needed": 90000,
	"amt_per_raise": 231.3624679,
	"min_pay": 161.9537275,
	"max_pay": 300.7712082,
	"boss_level": false
  },
  {
	"level": 27,
	"wage": 240000,
	"num_raises": 492,
	"raise_needed": 140000,
	"amt_per_raise": 284.5528455,
	"min_pay": 199.1869919,
	"max_pay": 369.9186992,
	"boss_level": false
  },
  {
	"level": 28,
	"wage": 380000,
	"num_raises": 623,
	"raise_needed": 240000,
	"amt_per_raise": 385.2327448,
	"min_pay": 269.6629213,
	"max_pay": 500.8025682,
	"boss_level": false
  },
  {
	"level": 29,
	"wage": 620000,
	"num_raises": 790,
	"raise_needed": 380000,
	"amt_per_raise": 481.0126582,
	"min_pay": 336.7088608,
	"max_pay": 625.3164557,
	"boss_level": true
  },
  {
	"level": 30,
	"wage": 1000000,
	"num_raises": 1000,
	"raise_needed": 0,
	"amt_per_raise": 0,
	"min_pay": 0,
	"max_pay": 0,
	"boss_level": false
  }
]
