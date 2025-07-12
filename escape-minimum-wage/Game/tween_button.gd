class_name TweenButton extends Button

@export var Parent: CanvasItem = self

const TWEEN_TIME := 0.1 # seconds
const MAX_SCALE := 1.1

var tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(Parent, "scale", MAX_SCALE * Vector2.ONE, TWEEN_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(Parent, "scale", 1.0 * Vector2.ONE, TWEEN_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
