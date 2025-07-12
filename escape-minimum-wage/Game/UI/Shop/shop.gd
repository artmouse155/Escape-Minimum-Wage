class_name Shop extends Control

@export var shop_item_container : Control

enum UpgradeTypes {RESUME_TIER}

const UpgradeLists := {
	RESUME_TIER = preload("uid://pcreq443v0eu")
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for type in UpgradeTypes:
		var shop_item = ShopItem.new(type, UpgradeLists[type], 0)
		shop_item_container.add_child(shop_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_playerdata_updated(playerdata : PlayerResource):
	for shop_item in shop_item_container.get_children():
		if shop_item is ShopItem:
			var type : UpgradeTypes = shop_item.get_upgrade_type()
			var current = playerdata.upgrades[type]
			var cost = UpgradeLists[type].upgrades[current].cost
			shop_item.set_can_afford(playerdata.money >= cost)
