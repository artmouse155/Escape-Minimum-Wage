class_name Shop extends Control

@export var shop_item_container : Control

@export var PackedShopItem : PackedScene

enum UpgradeTypes {RESUME_TIER, NETWORKING}

const UpgradeLists : Dictionary = {
	UpgradeTypes.RESUME_TIER : preload("uid://pcreq443v0eu"),
	UpgradeTypes.NETWORKING : preload("uid://ch6p1mtjx3tyx")
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for type in range(len(UpgradeTypes)):
		var shop_item = PackedShopItem.instantiate()
		print(shop_item.get_class())
		if shop_item is ShopItem:
			var upgradeList : UpgradeList = UpgradeLists[type]
			shop_item.init(type, upgradeList, 0)
			shop_item_container.add_child(shop_item)

func on_playerdata_updated(playerdata : PlayerResource):
	for shop_item in shop_item_container.get_children():
		if shop_item is ShopItem:
			var type : UpgradeTypes = shop_item.get_upgrade_type()
			var current = playerdata.upgrades[type]
			var cost = UpgradeLists[type].upgrades[current].cost
			shop_item.set_can_afford(playerdata.money >= cost)
