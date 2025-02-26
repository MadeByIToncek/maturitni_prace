extends Control

@export var group : Control;
@export var cursor : Control;
@export var camera : Camera3D;
@export var timer : Timer;

var animating = false;
var dragging = false
var topleft;
var bottomright;
var midpoint;

func _ready() -> void:
	topleft = group.position;
	bottomright = topleft + group.size;
	midpoint = (bottomright + topleft)/2;
	
	update(midpoint);
	pass

func _input(event):
	if not animating:
		if event is InputEventMouseMotion and dragging:
			update(event.position);
		# While dragging, move the sprite with the mouse.
				
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if(event.position.x > topleft.x && event.position.x <  bottomright.x && event.position.y > topleft.y && event.position.y < bottomright.y):
				if not dragging and event.pressed:
					dragging = true
				
			if dragging and not event.pressed:
				dragging = false


func update(position: Vector2):
	var pos;
	if(position.x > topleft.x && position.x <  bottomright.x && position.y > topleft.y && position.y < bottomright.y):
		pos = position;
	else:
		pos = lineIntersectionOnRect(group.size - Vector2(20,20),midpoint,position);
	
	cursor.position = pos - Vector2(10,10);
	var absolutePos = linear_remap_vec(pos - midpoint + Vector2(10,10),Vector2(290,140),Vector2(-290,-140), Vector2(-180,-90),Vector2(180,90));
	camera.rotation_degrees = Vector3(absolutePos.y,absolutePos.x,0)
	#print(camera.rotation_degrees);
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

func changeToAnim1():
	anim(Tween.TRANS_LINEAR);

func changeToAnim2():
	anim(Tween.TRANS_QUAD);
	
func changeToAnim3():
	anim(Tween.TRANS_QUART);
	
func changeToAnim4():
	anim(Tween.TRANS_EXPO);

func anim(trans:Tween.TransitionType):
	if not animating:
		animating = true;
		$"../Animace 1".disabled = true;
		$"../Animace 2".disabled = true;
		$"../Animace 3".disabled = true;
		$"../Animace 4".disabled = true;
		var tween = get_tree().create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(trans);
		
		camera.rotation_degrees = Vector3(10.92857, 166.9655,0);
		
		tween.tween_property(camera,"rotation_degrees",Vector3(83.25282, -160.2069,0),10);
		tween.finished.connect(func():
			animating = false;
			$"../Animace 1".disabled = false;
			$"../Animace 2".disabled = false;
			$"../Animace 3".disabled = false;
			$"../Animace 4".disabled = false;
		);
		tween.pause();
		await get_tree().create_timer(1).timeout;
		tween.play();
	

func _process(delta: float) -> void:
	if animating:
		#var absolutePos = linear_remap_vec(pos - midpoint + Vector2(10,10),Vector2(290,140),Vector2(-290,-140), Vector2(-180,-90),Vector2(180,90));
		var relativePos = linear_remap_vec(Vector2(camera.rotation_degrees.y, camera.rotation_degrees.x),Vector2(-180,-90), Vector2(180,90), Vector2(290,140),Vector2(-290,-140));
		relativePos += midpoint + Vector2(10,10);
		cursor.position = relativePos;
		pass
