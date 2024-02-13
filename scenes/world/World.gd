extends Node

# DAY TIME
var time_hours: int = 0
var time_minutes: int = 0
var time_days: int = 1

var isTimeOfWork: bool = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#region SERVERS
func _on_timer_daycycle_timeout():
	time_minutes += 1
	if time_minutes > 59:
		time_minutes = 0
		time_hours += 1
		if time_hours > 23: 
			time_hours = 0
			time_days += 1

# РАБОЧАЯ СМЕНА. ПРОВЕРКА. С 9-18.
func checkIsItTimeOfWork():
	return time_hours >= 9 and time_hours < 18
#endregion
