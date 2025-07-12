class_name Title extends Path2D

@export var Follower : PathFollow2D
@export var TitleLabel : RichTextLabel

const ENTER_EXIT_TIME := 0.5 # seconds
const WAIT_TIME := 0.5 #seconds

var tween : Tween

func show_title(title: String):
	if tween:
		tween.kill()
	tween = create_tween()
	TitleLabel.text = title
	Follower.progress_ratio = 0.0
	tween.tween_property(Follower, "progress_ratio", 0.5, ENTER_EXIT_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(WAIT_TIME)
	tween.tween_property(Follower, "progress_ratio", 1.0, ENTER_EXIT_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
