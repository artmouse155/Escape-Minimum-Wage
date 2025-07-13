class_name Shop extends Control

@export var shop_item_container : Control

@export var PackedShopItem : PackedScene

@export var PathFollow: PathFollow2D

@export var TooltipNode: Tooltip

enum UpgradeTypes {RESUME_TIER, NETWORKING}

const UpgradeLists : Dictionary = {
	UpgradeTypes.RESUME_TIER : preload("uid://pcreq443v0eu"),
	UpgradeTypes.NETWORKING : preload("uid://ch6p1mtjx3tyx")
}

enum {SHOP_TOP, SHOP_BOTTOM}

var location: int = SHOP_TOP
var scroll_tween: Tween

const SCROLL_DURATION = 0.2 # Seconds

signal shop_purchase(type : UpgradeTypes)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for type in range(len(UpgradeTypes)):
		var shop_item = PackedShopItem.instantiate()
		print(shop_item.get_class())
		if shop_item is ShopItem:
			var upgradeList : UpgradeList = UpgradeLists[type]
			shop_item.init(type, upgradeList, 0)
			shop_item.purchased.connect(on_purchase)
			shop_item.open_tooltip.connect(on_open_tooltip)
			shop_item.close_tooltip.connect(on_close_tooltip)
			shop_item_container.add_child(shop_item)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("scroll_down"):
		scroll_down()
	if Input.is_action_just_pressed("scroll_up"):
		scroll_up()

func force_shop_top():
	location = SHOP_TOP
	PathFollow.progress_ratio = 0.0

func on_playerdata_updated(playerdata : PlayerResource):
	for shop_item in shop_item_container.get_children():
		if shop_item is ShopItem:
			var type : UpgradeTypes = shop_item.get_upgrade_type()

			var current_index := playerdata.get_upgrade_index(type)
			var current_upgrade := playerdata.get_upgrade(type)
			var cost = current_upgrade.cost
			shop_item.init(type, UpgradeLists[type], current_index, playerdata.money >= cost)

func scroll_down():
	if location == SHOP_BOTTOM:
		return
	location = SHOP_BOTTOM
	if scroll_tween:
		scroll_tween.kill()
	scroll_tween = create_tween()
	scroll_tween.tween_property(PathFollow, "progress_ratio", 1.0, SCROLL_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func scroll_up():
	if location == SHOP_TOP:
		return
	location = SHOP_TOP
	if scroll_tween:
		scroll_tween.kill()
	scroll_tween = create_tween()
	scroll_tween.tween_property(PathFollow, "progress_ratio", 0.0, SCROLL_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func on_purchase(type: UpgradeTypes):
	shop_purchase.emit(type)

func on_open_tooltip(type: UpgradeTypes, current: int):
	var current_upgrade = null
	if (len(UpgradeLists[type].upgrades) - 1) >= current:
		current_upgrade = UpgradeLists[type].upgrades[current]
	var next_upgrade = null
	if (len(UpgradeLists[type].upgrades) - 1) >= current + 1:
		next_upgrade = UpgradeLists[type].upgrades[current  + 1]
	TooltipNode.init(current_upgrade, next_upgrade)
	TooltipNode.show()
	
	
func on_close_tooltip():
	TooltipNode.hide()
