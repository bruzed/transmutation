class Mutation
{
	float ATTRACTOR_MOVE_SENSITIVITY_DEFAULT = 10;
	float VEHICLE_SCALE_SENSITIVITY_MIN_DEFAULT = 0;
	float VEHICLE_SCALE_SENSITIVITY_MAX_DEFAULT = 100;
	float BURST_SENSIVITY_DEFAULT = 50;
	
	float ATTRACTOR_MOVE_SENSITIVITY = 10;
	float VEHICLE_SCALE_SENSITIVITY_MIN = 0;
	float VEHICLE_SCALE_SENSITIVITY_MAX = 100;
	float BURST_SENSIVITY = 50;
	
	FFT fft;
	int scaleRate = 0;

	ArrayList<Vehicle> vehicles;
	Attractor attractor;
	
	int NUM_BURSTS = 2;
	int NUM_VEHICLES = 15;
	ArrayList bursts;
	
	Mutation(FFT $fft) 
	{
		fft = $fft;
		rectMode(CENTER);

	  	// We are now making random vehicles and storing them in an ArrayList
	  	vehicles = new ArrayList<Vehicle>();
		attractor = new Attractor(width/2, height/2);
	  	for (int i = 0; i < NUM_VEHICLES; i++) {
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

		for( int i = 0; i < fft.avgSize()/2; i++ ) {
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
				if( fft.getAvg(i) > BURST_SENSIVITY ) {
					if( bursts.size() < NUM_BURSTS ) {
						Burst burst = new Burst(vehicle.location.x, vehicle.location.y);
						bursts.add(burst);
						burst.draw();
					}
				}
			} else {
				//Vehicle vehicle = (Vehicle) vehicles.get(i);
				//vehicle.scaleDown();
			}
			/*if( fft.getAvg(i) > BURST_SENSIVITY ) {
				if( bursts.size() < NUM_BURSTS ) {
					Burst burst = new Burst();
					bursts.add(burst);
					burst.draw();
				}
			}*/
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
	
	void setBurstSensitivity(float $value)
	{
		BURST_SENSIVITY = $value;
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
	
	float getBurstSensitivity()
	{
		return BURST_SENSIVITY;
	}
	
}