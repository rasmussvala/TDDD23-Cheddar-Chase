class_name BTNode extends Node

enum Status {RUNNING, SUCCESS, FAILURE}

## Executes this node and returns a status code.
## This method must be overwritten.
func tick(_delta: float) -> int:
	return Status.SUCCESS