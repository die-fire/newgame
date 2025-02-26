extends PickupResource
class_name Gem
@export var XP : float
@export var gold : float
func activate():
	super.activate()
	if player_reference and XP!=0:
		player_reference.gain_XP(XP)
		prints("+"+str(XP))
