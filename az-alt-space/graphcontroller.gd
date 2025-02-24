extends Control

@export var group : Control;
@export var cursor : Control;
@export var camera : Camera3D;

var dragging = false
var topleft;
var bottomright;
var midpoint;

func _ready() -> void:
	topleft = group.position;
	bottomright = topleft + group.size;
	midpoint = (bottomright + topleft)/2;
	upudate(midpoint);
	pass

func _input(event):
	if event is InputEventMouseMotion and dragging:
		upudate(event.position);
	# While dragging, move the sprite with the mouse.
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if(event.position.x > topleft.x && event.position.x <  bottomright.x && event.position.y > topleft.y && event.position.y < bottomright.y):
			if not dragging and event.pressed:
				dragging = true
			
		if dragging and not event.pressed:
			dragging = false


func upudate(position: Vector2):
	var pos;
	if(position.x > topleft.x && position.x <  bottomright.x && position.y > topleft.y && position.y < bottomright.y):
		pos = position;
	else:
		pos = lineIntersectionOnRect(group.size - Vector2(20,20),midpoint,position);
	
	cursor.position = pos - Vector2(10,10);
	var absolutePos = linear_remap_vec(pos - midpoint + Vector2(10,10),Vector2(290,140),Vector2(-290,-140), Vector2(-180,-90),Vector2(180,90));
	camera.rotation_degrees = Vector3(absolutePos.y,absolutePos.x,0)
	pass


func lineIntersectionOnRect(dim, B, A) -> Vector2:
	var w = dim.x / 2;
	var h = dim.y / 2;

	var d = A-B;

	#if A=B return B itself
	if (d == Vector2(0,0)):
		return B;

	var tan_phi = h / w;
	var tan_theta = abs(d.y / d.x);

	#tell me in which quadrant the A point is
	var qx = sign(d.x);
	var qy = sign(d.y);

	var xI;
	var yI;

	if (tan_theta > tan_phi):
		xI = B.x + (h / tan_theta) * qx;
		yI = B.y + h * qy;
	else:
		xI = B.x + w * qx;
		yI = B.y + w * tan_theta * qy;

	return Vector2(xI,yI);

func linear_remap_vec(value: Vector2, leftMin: Vector2, leftMax: Vector2, rightMin: Vector2, rightMax: Vector2):
	return Vector2(linear_remap(value.x, leftMin.x, leftMax.x, rightMin.x, rightMax.x),linear_remap(value.y, leftMin.y, leftMax.y, rightMin.y, rightMax.y))

func linear_remap(value, leftMin, leftMax, rightMin, rightMax):
	# Figure out how 'wide' each range is
	var leftSpan = leftMax - leftMin
	var rightSpan = rightMax - rightMin

	# Convert the left range into a 0-1 range (float)
	var valueScaled = float(value - leftMin) / float(leftSpan)

	# Convert the 0-1 range into a value in the right range.
	return rightMin + (valueScaled * rightSpan)
