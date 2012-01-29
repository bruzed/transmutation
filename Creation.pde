class Creation
{
	//float speed = 0.0;
	//int RADIUS_MAX = 10;
	//int RADIUS_MIN = 5;
	FFT fft;
	
	int MIN_DIVISIONS_DEFAULT = 10;
	int MAX_DIVISIONS_DEFAULT = 35;
	int MIN_XPOS_DEFAULT = 400;
	int MAX_XPOS_DEFAULT = 880;
	float TENTACLE_MOVE_SENSITIVITY_DEFAULT = 15;
	float TENTACLE_POSITION_SENSITIVITY_DEFAULT = 30;
	float BURST_SENSIVITY_DEFAULT = 60;
	
	int MIN_DIVISIONS = 10;
	int MAX_DIVISIONS = 35;
	int MIN_XPOS = 400;
	int MAX_XPOS = 880;
	float TENTACLE_MOVE_SENSITIVITY = 15;
	float TENTACLE_POSITION_SENSITIVITY = 30;
	float BURST_SENSIVITY = 60;
	
	int MIN_POSSIBLE_DIVISIONS = 10;
	int MAX_POSSIBLE_DIVISIONS = 70;
	
	int NUM_TENTACLES = 15;
	int NUM_BURSTS = 5;

	Tentacle[] tentacles = new Tentacle[NUM_TENTACLES];
	float[] positions = new float[NUM_TENTACLES];
	int[] divisions = new int[NUM_TENTACLES];

	ArrayList bursts;

	Creation(FFT $fft) 
	{	
		for(int i = 0; i < positions.length; i++) {
			positions[i] = random(MIN_XPOS, MAX_XPOS);
		}
		
		for(int i = 0; i < divisions.length; i++) {
			divisions[i] = (int) random(MIN_DIVISIONS, MAX_DIVISIONS);
		}
					
		fft = $fft;
		for( int i = 0; i < positions.length; i++ ) {
			tentacles[i] = new Tentacle( positions[i], divisions[i], MIN_XPOS, MAX_XPOS );
			tentacles[i].draw();
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

		for( int i = 0; i < fft.avgSize() / 2; i++ ) {
			//rect( i*w, height, i*w + w, height - fft.getAvg(i)*5 );
			//speed += fft.getAvg(i);
			//float angle = sin(speed)/random(50, 100) + sin(speed*1.2)/random(20.0, 50.0);
			//println(fft.getAvg(i));
			if( fft.getAvg(i) > TENTACLE_MOVE_SENSITIVITY ) {
				tentacles[i].move();
			} else {
				tentacles[i].stop();
			}

			/*if( fft.getAvg(i) > 50 ) {
				scale(fft.getAvg(i));
			}*/

			if( fft.getAvg(i) > TENTACLE_POSITION_SENSITIVITY ) {
				tentacles[i].changePosition();
			}
			
			if( fft.getAvg(i) > TENTACLE_MOVE_SENSITIVITY ) {
				//setDivisions(10, 70);
			}

			if( fft.getAvg(i) > BURST_SENSIVITY ) {
				if( bursts.size() < NUM_BURSTS ) {
					Burst burst = new Burst();
					bursts.add(burst);
					burst.draw();
				}
			}
		}
	}
	
	//getters/setters
	void setDivisions(float $min, float $max)
	{
		MIN_DIVISIONS = int($min);
		MAX_DIVISIONS = int($max);
		for(int i = 0; i < divisions.length; i++) {
			divisions[i] = (int) random(MIN_DIVISIONS, MAX_DIVISIONS);
		}
		for( int i = 0; i < tentacles.length; i++ ) {
			tentacles[i].divisions = divisions[i];
		}
	}
	
	void setXpos(float $min, float $max)
	{
		MIN_XPOS = int($min);
		MAX_XPOS = int($max);
		//println("setXpos: " + MIN_XPOS + ", " + MAX_XPOS);
		for(int i = 0; i < positions.length; i++) {
			positions[i] = (int) random(MIN_XPOS, MAX_XPOS);
		}
		for( int i = 0; i < tentacles.length; i++ ) {
			tentacles[i].xpos = positions[i];
			tentacles[i].MIN_XPOS = MIN_XPOS;
			tentacles[i].MAX_XPOS = MAX_XPOS;
		}
	}
	
	void setTentacleMoveSensitivity(float $value)
	{
		TENTACLE_MOVE_SENSITIVITY = $value;
	}
	
	void setTentaclePositionSensitivity(float $value)
	{
		TENTACLE_POSITION_SENSITIVITY = $value;
	}
	
	void setBurstSensitivity(float $value)
	{
		BURST_SENSIVITY = $value;
	}
	
	float getMinPossibleDivisions()
	{
		return float(MIN_POSSIBLE_DIVISIONS);
	}
	
	float getMaxPossibleDivisions()
	{
		return float(MAX_POSSIBLE_DIVISIONS);
	}
	
	float getMinDivisions()
	{
		return MIN_DIVISIONS;
	}
	
	float getMaxDivisions()
	{
		return MAX_DIVISIONS;
	}
	
	float getMinXPos()
	{
		return MIN_XPOS;
	}
	
	float getMaxXPos()
	{
		return MAX_XPOS;
	}
	
	float getTentacleMoveSensitivity()
	{
		return TENTACLE_MOVE_SENSITIVITY;
	}
	
	float getTentaclePositionSensitivity()
	{
		return TENTACLE_POSITION_SENSITIVITY;
	}
	
	float getBurstSensitivity()
	{
		return BURST_SENSIVITY;
	}
	
	void reset()
	{
		MIN_DIVISIONS = MIN_DIVISIONS_DEFAULT;
		MAX_DIVISIONS = MAX_DIVISIONS_DEFAULT;
		MIN_XPOS = MIN_XPOS_DEFAULT;
		MAX_XPOS = MAX_XPOS_DEFAULT;
		TENTACLE_MOVE_SENSITIVITY = TENTACLE_MOVE_SENSITIVITY_DEFAULT;
		TENTACLE_POSITION_SENSITIVITY = TENTACLE_POSITION_SENSITIVITY_DEFAULT;
		BURST_SENSIVITY = BURST_SENSIVITY_DEFAULT;
		for(int i = 0; i < divisions.length; i++) {
			divisions[i] = (int) random(MIN_DIVISIONS, MAX_DIVISIONS);
		}
		for( int i = 0; i < tentacles.length; i++ ) {
			tentacles[i].divisions = divisions[i];
		}
		for(int i = 0; i < positions.length; i++) {
			positions[i] = (int) random(MIN_XPOS, MAX_XPOS);
		}
		for( int i = 0; i < tentacles.length; i++ ) {
			tentacles[i].xpos = positions[i];
			tentacles[i].MIN_XPOS = MIN_XPOS;
			tentacles[i].MAX_XPOS = MAX_XPOS;
		}
	}
	
}