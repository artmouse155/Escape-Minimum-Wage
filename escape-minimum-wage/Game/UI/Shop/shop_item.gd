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
var current := 0

signal purchased(_upgrade_type : Shop.UpgradeTypes)
signal open_tooltip(_upgrade_type : Shop.UpgradeTypes, _current : int)
signal close_tooltip


func init(_upgrade_type : Shop.UpgradeTypes, upgrade_list : UpgradeList, _current : int, can_afford : bool = false) -> void:
	upgrade_type = _upgrade_type
	current = _current
	UpgradeNameNode.text = upgrade_list.name
	var current_upgrade = upgrade_list.upgrades[current]
	Icon.texture = current_upgrade.icon
	maxed = (current == (len(upgrade_list.upgrades) - 1))
	CurrentNode.text = current_upgrade.name
	if maxed:
		BuyLabel.text = "MAXED"
		CostNode.text = ""
		NextNode.text = current_upgrade.name
		BuyButton._on_mouse_exited()
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
	purchased.emit(upgrade_type)


func _on_mouse_entered() -> void:
	open_tooltip.emit(upgrade_type, current)


func _on_mouse_exited() -> void:
	close_tooltip.emit()
