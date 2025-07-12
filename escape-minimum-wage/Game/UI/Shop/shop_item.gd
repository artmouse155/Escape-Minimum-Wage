class_name ShopItem extends MarginContainer

@export var Icon: TextureRect
@export var UpgradeNameNode: Label
@export var CurrentNode: Label
@export var NextNode: Label
@export var CostNode: Label
@export var BuyButton: TweenButton
@export var BuyLabel: Label

var upgrade_type : Shop.UpgradeTypes

var maxed := false

signal purchased(_upgrade_name : String)

func _init(upgrade_type : Shop.UpgradeTypes, upgrade_list : UpgradeList, current : int, can_afford : bool = false) -> void:
	UpgradeNameNode.text = upgrade_list.name
	var current_upgrade = upgrade_list.upgrades[current]
	Icon.texture = current_upgrade.icon
	maxed = (current == (len(upgrade_list.upgrades) - 1))
	if maxed:
		BuyLabel.text = "MAXED"
		CostNode.text = ""
		NextNode.text = current_upgrade.name
	else:
		BuyLabel.text = "BUY"
		CostNode.text = "$%0.2f" % current_upgrade.cost
		NextNode.text = "%s → %s" % [current_upgrade.name, upgrade_list.upgrades[current + 1].name]
	set_can_afford(can_afford)
	

func get_upgrade_type() -> Shop.UpgradeTypes:
	return upgrade_type

func set_can_afford(can_afford : bool) -> void:
	BuyButton.disabled = maxed or not can_afford
	
func purchase() -> void:
	purchased.emit()
