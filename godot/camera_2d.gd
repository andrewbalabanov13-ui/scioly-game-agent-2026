extends Camera2D
## Drag the Player node here, or leave empty: uses parent → CollisionShape2D → this, so Player is two levels up.
@export var player: Player

func _ready() -> void:
	pass
	var death = get_parent().get_parent().death

## Same value as `player.death` (read-only from the camera script).
func _process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	if Player.death == true:
		_teleport_away_on_spike()


func _teleport_away_on_spike() -> void:
	# Detach from the player transform so we stay at world (1000, 1000) instead of following them.
	top_level = true
	position_smoothing_enabled = false
	position.x = -500
	position.y = -500


func reset_follow_player() -> void:
	top_level = false
	position_smoothing_enabled = true
	position = Vector2.ZERO
