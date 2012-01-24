class Mutation
{
	float ATTRACTOR_MOVE_SENSITIVITY_DEFAULT = 30;
	float VEHICLE_SCALE_SENSITIVITY_MIN_DEFAULT = 20;
	float VEHICLE_SCALE_SENSITIVITY_MAX_DEFAULT = 30;
	
	float ATTRACTOR_MOVE_SENSITIVITY = 30;
	float VEHICLE_SCALE_SENSITIVITY_MIN = 20;
	float VEHICLE_SCALE_SENSITIVITY_MAX = 30;
	
	FFT fft;
	int scaleRate = 0;

	ArrayList<Vehicle> vehicles;
	Attractor attractor;

	ArrayList bursts;
	
	Mutation(FFT $fft) 
	{
		fft = $fft;
		rectMode(CENTER);

	  	// We are now making random vehicles and storing them in an ArrayList
	  	vehicles = new ArrayList<Vehicle>();
		attractor = new Attractor(width/2, height/2);
	  	for (int i = 0; i < 30; i++) {
	    	vehicles.add(new Vehicle(random(width),random(height)));
	  	}
		bursts = new ArrayList();
	}

	void draw() 
	{
		fft.forward(audioInput.mix);
		int w = int(width/fft.avgSize());

		for( int i = 0; i < bursts.size(); i++ ) {
			Burst burst = (Burst) bursts.get(i);
			if(burst.radius > width + 200) {
				bursts.remove(i);
			} else {
				burst.update();
			}
		}

		for( int i = 0; i < fft.avgSize(); i++ ) {
			//attractor
			if( fft.getAvg(i) > ATTRACTOR_MOVE_SENSITIVITY ) {
				attractor.wander();
				attractor.run();
			}
			//scale vehicles
			if( fft.getAvg(i) > VEHICLE_SCALE_SENSITIVITY_MIN && fft.getAvg(i) < VEHICLE_SCALE_SENSITIVITY_MAX ) {
				//Vehicle vehicle = (Vehicle) vehicles.get(i);
				Vehicle vehicle = (Vehicle) vehicles.get(i);
				vehicle.scaleUp(fft.getAvg(i));
				if( bursts.size() < 10 ) {
					Burst burst = new Burst(vehicle.location.x, vehicle.location.y);
					bursts.add(burst);
					burst.draw();
				}
			} else {
				Vehicle vehicle = (Vehicle) vehicles.get(i);
				vehicle.scaleDown();
			}
		}

		attractor.display();
		attractor.borders();

	  	for (Vehicle v : vehicles) {
	    	// Path following and separation are worked on in this function
	    	v.applyBehaviors(vehicles, attractor);
			//PVector attraction = attractor.attract(v);
			//v.applyForce(attraction);
			if(mousePressed == true) {
				v.cohesion(vehicles);
			}
	    	// Call the generic run method (update, borders, display, etc.)
			v.borders();
	    	v.update();
	    	v.display();
	  	}
	}
	
	void setAttractorSensitivity(float $value)
	{
		ATTRACTOR_MOVE_SENSITIVITY = $value;
	}
	
	void setVehicleScaleSensitivity(float $min, float $max)
	{
		VEHICLE_SCALE_SENSITIVITY_MIN = $min;
		VEHICLE_SCALE_SENSITIVITY_MAX = $max;
	}
	
	void reset()
	{
		ATTRACTOR_MOVE_SENSITIVITY = ATTRACTOR_MOVE_SENSITIVITY_DEFAULT;
		VEHICLE_SCALE_SENSITIVITY_MIN = VEHICLE_SCALE_SENSITIVITY_MIN_DEFAULT;
		VEHICLE_SCALE_SENSITIVITY_MAX = VEHICLE_SCALE_SENSITIVITY_MAX_DEFAULT;
	}
	
	float getAttractorSensitivity()
	{
		return ATTRACTOR_MOVE_SENSITIVITY;
	}
	
	float getVehicleScaleSensitivityMin()
	{
		return VEHICLE_SCALE_SENSITIVITY_MIN;
	}
	
	float getVehicleScaleSensitivityMax()
	{
		return VEHICLE_SCALE_SENSITIVITY_MAX;
	}
	
}