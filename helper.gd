extends Node

#Helper functions

func is_positive(num):
	if num > 0:
		return 1
	elif num < 0:
		return -1
	else:
		return 0