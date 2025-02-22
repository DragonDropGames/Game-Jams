class_name Boid extends Node


var separation_distance: float = 25.0
var neighbor_radius: float = 75.0
var max_force: float = 2.0
var friction: float = 0.9  # Reduces movement over time to settle

# **Boids Behavior**
func process_boid(delta: float, node: Node2D, speed: float, group_name: String) -> void:
	var boids = node.get_tree().get_nodes_in_group(group_name)
	var separation_force = Vector2.ZERO
	var alignment_force = Vector2.ZERO
	var cohesion_force = Vector2.ZERO

	var neighbor_count = 0
	var center_of_mass = Vector2.ZERO

	for boid in boids:
		if boid == self or not boid.alive:
			continue

		var distance = node.position.distance_to(boid.position)
		if distance < neighbor_radius:
			# **Separation - Push away when too close**
			if distance < separation_distance:
				var push_vector = (node.position - boid.position).normalized()
				var push_strength = (separation_distance - distance) / separation_distance  # Stronger push when closer
				separation_force += push_vector * push_strength * 5.0

			# **Alignment - Match velocity with nearby units**
			alignment_force += boid.velocity

			# **Cohesion - Move toward the center of mass**
			center_of_mass += boid.position
			neighbor_count += 1

	if neighbor_count > 0:
		alignment_force = (alignment_force / neighbor_count).normalized() * speed
		cohesion_force = ((center_of_mass / neighbor_count) - node.position).normalized() * speed

	# **Apply weighted forces**
	var steer = separation_force * 1.8 + alignment_force * 0.8 + cohesion_force * 1.2
	steer = steer.limit_length(max_force)

	node.velocity += steer * delta
	node.velocity = node.velocity.lerp(Vector2.ZERO, friction * delta)  # Gradually slow down
	node.velocity = node.velocity.normalized() * speed if node.velocity.length() > 1 else Vector2.ZERO

	# **Move & Handle Collisions (Push Effect)**
	var collision = node.move_and_collide(node.velocity * delta)
	if collision:
		node.velocity = node.velocity.bounce(collision.get_normal()) * 0.5  # Slight bounce effect to prevent sticking
