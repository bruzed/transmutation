class Vehicle
{
	PVector location;
	PVector velocity;
	PVector acceleration;
	float r;
	float maxforce;
	float maxspeed;
	float mass;
	Attractor attractor;
	
	int scaleRate = 30;
	Boolean isScaled = false;
	
	int INITIAL_SIZE = 20;
	float scaleTo = 0;
	
	PImage orb;
	color randomColor;
	
	Vehicle(float x, float y)
	{
		location = new PVector(x, y);
		r = INITIAL_SIZE;
		maxspeed = 18;
		maxforce = 2.5;
		acceleration = new PVector(0, 0);
		velocity = new PVector(0, 0);
		mass = 1;
		orb = loadImage("orb.png");
		randomColor = color( int(random(0,255)), int(random(0,255)), int(random(0,255)), int(random(0,255)));
	}
	
	void applyForce(PVector force)
	{
		//to add mass : acceleration = force / mass
		acceleration.add(force);
	}
	
	void applyBehaviors(ArrayList<Vehicle> vehicles, Attractor a) {
	    PVector separate = separate(vehicles);
	     //PVector seek = seek(new PVector(mouseX,mouseY));
		PVector seek = seek(a.location);
		//stroke(255,0,0, 50);
		stroke(lightYellow, 50);
		strokeWeight(2);
		//line(location.x, location.y, a.location.x, a.location.y);
	    separate.mult(2);
	    seek.mult(1);
	    applyForce(separate);
	    applyForce(seek); 
	  }

	    // A method that calculates a steering force towards a target
	  // STEER = DESIRED MINUS VELOCITY
	  PVector seek(PVector target) {
	    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target

	    // Normalize desired and scale to maximum speed
	    desired.normalize();
	    desired.mult(maxspeed);
	    // Steering = Desired minus velocity
	    PVector steer = PVector.sub(desired,velocity);
	    steer.limit(maxforce);  // Limit to maximum steering force

	    return steer;
	  }

	  // Separation
	  // Method checks for nearby vehicles and steers away
	  PVector separate (ArrayList<Vehicle> vehicles) {
	    float desiredseparation = r*2;
	    PVector sum = new PVector();
	    int count = 0;
	    // For every boid in the system, check if it's too close
	    for (Vehicle other : vehicles) {
	      float d = PVector.dist(location, other.location);
	      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
	      if ((d > 0) && (d < desiredseparation)) {
	        // Calculate vector pointing away from neighbor
			//stroke(255, 255, 255, 50);
			stroke(lightYellow, 100);
			strokeWeight(1);
			line(location.x, location.y, other.location.x, other.location.y);
	        PVector diff = PVector.sub(location, other.location);
	        diff.normalize();
	        diff.div(d);        // Weight by distance
	        sum.add(diff);
	        count++;            // Keep track of how many
	      }
	    }
	    // Average -- divide by how many
	    if (count > 0) {
	      sum.div(count);
	      // Our desired vector is the average scaled to maximum speed
	      sum.normalize();
	      sum.mult(maxspeed);
	      // Implement Reynolds: Steering = Desired - Velocity
	      sum.sub(velocity);
	      sum.limit(maxforce);
	    }
	    return sum;
	  }
	
	//cohesion
	// Separation
	  // Method checks for nearby vehicles and steers away
	  void cohesion (ArrayList<Vehicle> vehicles) {
	    float desiredseparation = r*2;
	    PVector sum = new PVector();
	    int count = 0;
	    // For every boid in the system, check if it's too close
	    for (Vehicle other : vehicles) {
	      float d = PVector.dist(location, other.location);
	      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
	      if (d > desiredseparation) {
	        // Calculate vector pointing away from neighbor
	        PVector diff = PVector.sub(location, other.location);
	        diff.normalize();
	        diff.mult(-d);      // Weight by distance
	        sum.add(diff);
	        count++;            // Keep track of how many
	      }
	    }
	    // Average -- divide by how many
	    if (count > 0) {
	      sum.div(count);
	      // Our desired vector is the average scaled to maximum speed
	      sum.normalize();
	      sum.mult(maxspeed);
	      // Implement Reynolds: Steering = Desired - Velocity
	      PVector steer = PVector.sub(sum, velocity);
	      steer.limit(maxforce);
	      applyForce(steer);
	    }
	  }
	
	// Method to update location
	  void update() {
	    // Update velocity
	    velocity.add(acceleration);
	    // Limit speed
	    velocity.limit(maxspeed);
	    location.add(velocity);
	    // Reset accelertion to 0 each cycle
	    acceleration.mult(0);
		if(isScaleUp) {
			scaleUpFunction();
		} 
		if(isScaleDown) {
			scaleDownFunction();
		}
		
	  }

	  void display() {
	    //fill(255, 100);
		//fill(0, 50);
	    noStroke();
		//stroke(255, 50);
	    pushMatrix();
	    translate(location.x, location.y);
	    //ellipse(0, 0, r, r);
		imageMode(CENTER);
		image(redOrb, 0, 0, r*2, r*2);
		image(greenOrb, 0, 0, r*1.5, r*1.5);
		image(whiteOrb, 0, 0, r, r);
	    popMatrix();
	  }

	  // Wraparound
	  void borders() {
	    if (location.x < -r) location.x = width+r;
	    if (location.y < -r) location.y = height+r;
	    if (location.x > width+r) location.x = -r;
	    if (location.y > height+r) location.y = -r;
	  }
	
	void scaleUp(float amount)
	{
		//r += amount;
		scaleTo = amount * 5;
		if(amount < r) {
			isScaleDown = true;
		} else {
			isScaleUp = true;
		}
	}
	
	void scaleDown()
	{
		r = INITIAL_SIZE;
	}
	
	void scaleUpFunction()
	{
		if(r < scaleTo){
			r += 10;
		}
	}
	
	void scaleDownFunction()
	{
		if(r > scaleTo) {
			r -= 10;
		}
	}
	
	Boolean isScaleUp = false;
	Boolean isScaleDown = false;
	
}