class Lights
{
	FFT fft;

	float ROTATEZ_POSITIVE_SENSITIVITY_DEFAULT = 40;
	float ROTATEZ_NEGATIVE_SENSITIVITY_DEFAULT = 50;
	float OUTER_SENSITIVITY_DEFAULT = 50;
	float MIDDLE_SENSITIVITY_MIN_DEFAULT = 30;
	float MIDDLE_SENSITIVITY_MAX_DEFAULT = 40;
	float INNER_SENSITIVITY_MIN_DEFAULT = 15;
	float INNER_SENSITIVITY_MAX_DEFAULT = 20;

	float ROTATEZ_POSITIVE_SENSITIVITY = 40;
	float ROTATEZ_NEGATIVE_SENSITIVITY = 50;
	float OUTER_SENSITIVITY = 50;
	float MIDDLE_SENSITIVITY_MIN = 30;
	float MIDDLE_SENSITIVITY_MAX = 40;
	float INNER_SENSITIVITY_MIN = 15;
	float INNER_SENSITIVITY_MAX = 20;

	ArrayList lights;

	int cols = 25;
	int rows = 15;

	int cell_width = 50;
	int cell_height = 50;

	ArrayList positions;

	float rotateZValue;

	Lights(FFT $fft)
	{
		fft = $fft;
		lights = new ArrayList();
		positions = new ArrayList();

		for(int i = 0; i < rows; i++) {
			for(int j = 0; j < cols; j++) {
				PVector position = new PVector(j*cell_width, i*cell_height);
				positions.add(position);
			}
		}
	}

	void draw()
	{
		fft.forward(audioInput.mix);
		int w = int(width/fft.avgSize());

		float average = 1;
		float sum = 0;

		// noFill();
		// stroke(255,255,255,200);
		// rectMode(CORNER);
		// rect(0,0,width,height);

		pushMatrix();
			translate(width/2, height/2);

			//scale(average);

			rotateZValue += 0.01f;
			rotateZ(rotateZValue);

			pushMatrix();
				translate(-width/2, -height/2);
				
				// for(int i = 0; i < positions.size(); i++) {
				// 	noFill();
				// 	stroke(255, 0, 0, 50);
				// 	PVector position = (PVector) positions.get(i);
				// 	rectMode(CENTER);
				// 	rect(position.x, position.y, cell_width, cell_height);
				// 	textFont(myfont, 10);
				// 	text(i, position.x, position.y);
				// }

				for(int i = 0; i < lights.size(); i++) {
					Light light = (Light) lights.get(i);
					if(light.OPACITY < 1) {
						lights.remove(i);
					} else {
						light.update();
					}
				}

				for(int i = 0; i < fft.avgSize(); i++) {

					sum += fft.getAvg(i);

					// outer
					if( fft.getAvg(i) > OUTER_SENSITIVITY ) {
						int random_number1 = int(random(0, 50));
						int random_number2 = int(random(325, 375));
						
						PVector random_position1 = (PVector) positions.get(random_number1);
						Light light1 = new Light( random_position1.x, random_position1.y, cell_width, cell_height, "OUTER", fft.getAvg(i) );
						lights.add(light1);
						light1.draw();

						PVector random_position2 = (PVector) positions.get(random_number2);
						Light light2 = new Light( random_position2.x, random_position2.y, cell_width, cell_height, "OUTER", fft.getAvg(i) );
						lights.add(light2);
						light2.draw();
					}

					// middle
					if( fft.getAvg(i) > MIDDLE_SENSITIVITY_MIN && fft.getAvg(i) < MIDDLE_SENSITIVITY_MAX ) {
						int random_number3 = int(random(50, 125));
						int random_number4 = int(random(250, 325));
						
						PVector random_position3 = (PVector) positions.get(random_number3);
						Light light3 = new Light( random_position3.x, random_position3.y, cell_width, cell_height, "MIDDLE", fft.getAvg(i) );
						lights.add(light3);
						light3.draw();

						PVector random_position4 = (PVector) positions.get(random_number4);
						Light light4 = new Light( random_position4.x, random_position4.y, cell_width, cell_height, "MIDDLE", fft.getAvg(i) );
						lights.add(light4);
						light4.draw();
					}

					// inner
					if( fft.getAvg(i) > INNER_SENSITIVITY_MIN && fft.getAvg(i) < INNER_SENSITIVITY_MAX ) {
						int random_number5 = int(random(125, 250));
						
						PVector random_position5 = (PVector) positions.get(random_number5);
						Light light5 = new Light( random_position5.x, random_position5.y, cell_width, cell_height, "INNER", fft.getAvg(i) );
						lights.add(light5);
						light5.draw();
					}

					if( fft.getAvg(i) > ROTATEZ_POSITIVE_SENSITIVITY ) {
						rotateZValue += 3.0f;
					}

					if( fft.getAvg(i) > ROTATEZ_NEGATIVE_SENSITIVITY ) {
						rotateZValue -= 3.0f;
					}
				}

				average = sum / fft.avgSize();

			popMatrix();
		popMatrix();

	}

	float getOuterSensitivity()
	{
		return OUTER_SENSITIVITY;
	}

	float getMiddleSensitivityMax()
	{
		return MIDDLE_SENSITIVITY_MAX;
	}

	float getMiddleSensitivityMin()
	{
		return MIDDLE_SENSITIVITY_MIN;
	}

	float getInnerSensitivityMin()
	{
		return INNER_SENSITIVITY_MIN;
	}

	float getInnerSensitivityMax()
	{
		return INNER_SENSITIVITY_MAX;
	}

	float getRotateZPositiveSensitivty()
	{
		return ROTATEZ_POSITIVE_SENSITIVITY;
	}

	float getRotateZNegativeSensitivity()
	{
		return ROTATEZ_NEGATIVE_SENSITIVITY;
	}

	void setOuterSensitivity(float $value)
	{
		OUTER_SENSITIVITY = $value;
	}

	void setMiddleSensitivity(float $min, float $max)
	{
		MIDDLE_SENSITIVITY_MIN = $min;
		MIDDLE_SENSITIVITY_MAX = $max;
	}

	void setInnerSensitivity(float $min, float $max)
	{
		INNER_SENSITIVITY_MIN = $min;
		INNER_SENSITIVITY_MAX = $max;
	}

	void setRotateZPositiveSensitivity(float $value)
	{
		ROTATEZ_POSITIVE_SENSITIVITY = $value;
	}

	void setRotateZNegativeSensitivity(float $value)
	{
		ROTATEZ_NEGATIVE_SENSITIVITY = $value;
	}

	void reset()
	{
		ROTATEZ_NEGATIVE_SENSITIVITY = ROTATEZ_NEGATIVE_SENSITIVITY_DEFAULT;
		ROTATEZ_POSITIVE_SENSITIVITY = ROTATEZ_POSITIVE_SENSITIVITY_DEFAULT;
		OUTER_SENSITIVITY = OUTER_SENSITIVITY_DEFAULT;
		MIDDLE_SENSITIVITY_MAX = MIDDLE_SENSITIVITY_MAX_DEFAULT;
		MIDDLE_SENSITIVITY_MIN = MIDDLE_SENSITIVITY_MIN_DEFAULT;
		INNER_SENSITIVITY_MAX = INNER_SENSITIVITY_MAX_DEFAULT;
		INNER_SENSITIVITY_MIN = INNER_SENSITIVITY_MIN_DEFAULT;
	}

}