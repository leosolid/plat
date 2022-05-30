extends Area2D

onready var anim_player : AnimationPlayer = get_node("AnimationPlayer") 

func _on_body_entered(body:Node):
	anim_player.play("fade_out")
