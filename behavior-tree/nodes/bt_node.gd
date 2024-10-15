class_name BTNode extends Node

enum { SUCCESS, FAILURE, RUNNING }

## Executes this node and returns a status code.
## This method must be overwritten.
func tick(_blackboard: Dictionary) -> int:
	return SUCCESS
