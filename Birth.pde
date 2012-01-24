// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Basic example of falling rectangles

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
	
	// A reference to our box2d world
	PBox2D box2d;
	Box box1, box2;

	// A list we'll use to track fixed objects
	ArrayList<Boundary> boundaries;
	// A list for all of our rectangles
	ArrayList<CustomShape> polygons;
	Spring spring1, spring2;
	float xoff1 = 0;
	float yoff1 = 1280;
	float xoff2 = 0;
	float yoff2 = 1280;

	Mover mover;

	Birth(FFT $fft, PBox2D $box2d) 
	{
		fft = $fft;
		mover = new Mover(width/2, height/2);

		// Initialize box2d physics and create the world
	  	//box2d = new PBox2D(this);
		box2d = $box2d;
	  	box2d.createWorld();
	  	// We are setting a custom gravity
	  	box2d.setGravity(0, -20);

		// Add a listener to listen for collisions!
	  	box2d.world.setContactListener(new CustomListener());

	  	// Make the box
	  	box1 = new Box( (width/2)/2,height/2, 50, 50);
		box2 = new Box((width/2) + (width/2)/2,height/2, 50, 50);

		// Make the spring (it doesn't really get initialized until the mouse is clicked)
	  	spring1 = new Spring();
		spring2 = new Spring();
	  	spring1.bind((width/2)/2,height/2,box1, 1000.0);
		spring2.bind((width/2) + (width/2)/2,height/2,box2, 500.0);

	  	// Create ArrayLists	
	  	polygons = new ArrayList<CustomShape>();
	  	boundaries = new ArrayList<Boundary>();

	  	// Add a bunch of fixed boundaries
	  	//boundaries.add(new Boundary(width/4,height-5,width/2-50,10));
	  	//boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10));
	  	//boundaries.add(new Boundary(width-5,height/2,10,height));
	  	//boundaries.add(new Boundary(5,height/2,10,height));
		//boundaries.add(new Boundary( width/2, height - 20, width/4, 10));
	}

	void draw() 
	{
		fft.forward(audioInput.mix);
		int w = int(width/fft.avgSize());

	  	// We must always step through time!
	  	box2d.step();

		// Make an x,y coordinate out of perlin noise
		/*float x = noise(xoff)*width;
		  float y = noise(yoff)*height;
		  xoff += 0.01;
		  yoff += 0.01;*/

		//spring1.update(x,y);
		//spring2.update(x,y);

		box1.body.setAngularVelocity(0);
		box2.body.setAngularVelocity(0);

	  	// Display all the boundaries
	  	for (Boundary wall: boundaries) {
	    	wall.display();
	  	}

	  	// Display all the people
	  	for (CustomShape cs: polygons) {
	    	cs.display();
	  	}

	  	// people that leave the screen, we delete them
	  	// (note they have to be deleted from both the box2d world and our list
	  	for (int i = polygons.size()-1; i >= 0; i--) {
	    	CustomShape cs = polygons.get(i);
	    	if (cs.done()) {
	      		polygons.remove(i);
	    	}
	  	}

		for( int i = 0; i < fft.avgSize(); i++ ) {
			//rect( i*w, height, i*w + w, height - fft.getAvg(i)*5 );

			//generate custom shapes
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

		}

		mover.display();
		mover.borders();
		box1.display();
		box1.borders();
		box2.display();
		box2.borders();

	}

	/*void mousePressed() {
	  CustomShape cs = new CustomShape(mouseX,mouseY);
	  polygons.add(cs);
	}*/
	
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
	
	void reset()
	{
		GENERATION_SENSITIVITY = GENERATION_SENSITIVITY_DEFAULT;
		MOVER_SENSITIVITY = MOVER_SENSITIVITY_DEFAULT;
		SPRING1_SENSITIVITY = SPRING1_SENSITIVITY_DEFAULT;
		SPRING2_SENSITIVITY = SPRING2_SENSITIVITY_DEFAULT;
	}
	
}
