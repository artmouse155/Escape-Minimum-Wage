class_name Tooltip extends PanelContainer

@export var CurrentNode: Control
@export var CurrentLabel: Label
@export var CurrentValuesLabel: Label
@export var CurrentIcon: TextureRect

@export var NextNode: Control
@export var NextLabel: Label
@export var NextValuesLabel: Label
@export var NextIcon: TextureRect

func init(current : Upgrade, next : Upgrade) -> void:
	CurrentNode.visible = (current != null)
	if current:
		CurrentLabel.text = current.name
		var out : String = ""
		for key in current.values.keys():
			out += key.capitalize() + ": " + current.values[key] + "\n"
		CurrentValuesLabel.text = out
		CurrentIcon.texture = current.icon
	NextNode.visible = (next != null)
	if next:
		NextLabel.text = next.name
		var out : String = ""
		for key in next.values.keys():
			out += key.capitalize() + ": " + next.values[key] + "\n"
		NextValuesLabel.text = out
		NextIcon.texture = next.icon

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
