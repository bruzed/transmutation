class Birth 
{
	FFT fft;
	
	float GENERATION_SENSITIVITY_DEFAULT = 30;
	float MOVER_SENSITIVITY_DEFAULT = 20;
	float SPRING1_SENSITIVITY_DEFAULT = 20;
	float SPRING2_SENSITIVITY_DEFAULT = 30;
	
	float GENERATION_SENSITIVITY = 30;
	float MOVER_SENSITIVITY = 20;
	float SPRING1_SENSITIVITY = 20;
	float SPRING2_SENSITIVITY = 30;

	float BURST_SENSIVITY_DEFAULT = 60;
	float BURST_SENSIVITY = 60;
	int NUM_BURSTS = 5;
	
	PBox2D box2d;
	Box box1, box2;

	ArrayList<Boundary> boundaries;
	ArrayList<CustomShape> polygons;
	Spring spring1, spring2;
	float xoff1 = 0;
	float yoff1 = 1280;
	float xoff2 = 0;
	float yoff2 = 1280;

	Mover mover;

	ArrayList bursts;

	Birth(FFT $fft, PBox2D $box2d) 
	{
		fft = $fft;
		mover = new Mover(width/2, height/2);

		box2d = $box2d;
	  	box2d.createWorld();
	  	box2d.setGravity(0, -20);

	  	box2d.world.setContactListener(new CustomListener());

	  	box1 = new Box( (width/2)/2,height/2, 50, 50);
		box2 = new Box((width/2) + (width/2)/2,height/2, 50, 50);

	  	spring1 = new Spring();
		spring2 = new Spring();
	  	spring1.bind((width/2)/2,height/2,box1, 1000.0);
		spring2.bind((width/2) + (width/2)/2,height/2,box2, 500.0);

	  	polygons = new ArrayList<CustomShape>();
	  	boundaries = new ArrayList<Boundary>();

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

	  	box2d.step();
		box1.body.setAngularVelocity(0);
		box2.body.setAngularVelocity(0);

	  	for (Boundary wall: boundaries) {
	    	wall.display();
	  	}

	  	for (CustomShape cs: polygons) {
	    	cs.display();
	  	}

	  	for (int i = polygons.size()-1; i >= 0; i--) {
	    	CustomShape cs = polygons.get(i);
	    	if (cs.done()) {
	      		polygons.remove(i);
	    	}
	  	}

		for( int i = 0; i < fft.avgSize(); i++ ) {
			if( fft.getAvg(i) > GENERATION_SENSITIVITY ) {
				CustomShape cs = new CustomShape(mover.location.x, mover.location.y);
				polygons.add(cs);
			}
			
			//mover
			if( fft.getAvg(i) > MOVER_SENSITIVITY ) {
				mover.wander();
				mover.run();
			}

			//box1
			if( fft.getAvg(i) > SPRING1_SENSITIVITY ) {
				float x = noise(xoff1)*width;
				  float y = noise(yoff1)*height;
				  xoff1 += 0.01;
				  yoff1 += 0.01;
				spring1.update(x,y);
				box1.w = box1.h = fft.getAvg(i) * 2;
			}

			//box2
			if( fft.getAvg(i) > SPRING2_SENSITIVITY ) {
				float x = noise(xoff2)*width;
				  float y = noise(yoff2)*height;
				  xoff2 += 0.01;
				  yoff2 += 0.01;
				spring2.update(x,y);
				box2.w = box2.h = fft.getAvg(i) * 2;
			}

			//bursts
			if( fft.getAvg(i) > BURST_SENSIVITY ) {
				if( bursts.size() < NUM_BURSTS ) {
					Burst burst = new Burst(width/2, height/2);
					bursts.add(burst);
					burst.draw();
				}
			}

		}

		mover.display();
		mover.borders();
		box1.display();
		box1.borders();
		box2.display();
		box2.borders();

	}
	
	float getGeneratorSensitivity()
	{
		return GENERATION_SENSITIVITY;
	}
	
	float getMoverSensitivity()
	{
		return MOVER_SENSITIVITY;
	}
	
	float getSpring1Sensitivity()
	{
		return SPRING1_SENSITIVITY;
	}
	
	float getSpring2Sensitivity()
	{
		return SPRING2_SENSITIVITY;
	}

	float getBurstSensitivity()
	{
		return BURST_SENSIVITY;
	}
	
	void setGenerationSensitivity(float $value)
	{
		GENERATION_SENSITIVITY = $value;
	}
	
	void setMoverSensitivity(float $value)
	{
		MOVER_SENSITIVITY = $value;
	}
	
	void setSpring1Sensitivity(float $value)
	{
		SPRING1_SENSITIVITY = $value;
	}
	
	void setSpring2Sensitivity(float $value)
	{
		SPRING2_SENSITIVITY = $value;
	}

	void setBurstSensitivity(float $value)
	{
		BURST_SENSIVITY = $value;
	}
	
	void reset()
	{
		GENERATION_SENSITIVITY = GENERATION_SENSITIVITY_DEFAULT;
		MOVER_SENSITIVITY = MOVER_SENSITIVITY_DEFAULT;
		SPRING1_SENSITIVITY = SPRING1_SENSITIVITY_DEFAULT;
		SPRING2_SENSITIVITY = SPRING2_SENSITIVITY_DEFAULT;
		BURST_SENSIVITY = BURST_SENSIVITY_DEFAULT;
	}
	
}
