class_name Hitbox extends Area2D

@export var Parent: Entity

func parent_take_damage(dmg: float):
	if Parent:
		Parent.take_damage(dmg)
