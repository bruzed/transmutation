class Light
{

	float _x;
	float _y;
	float _w;
	float _h;
	String _segment;

	color white = color(255, 255, 255);
	float OPACITY = 255;
	float reducer = 30;

	float OUTER_RADIUS = 20;
	float MIDDLE_RADIUS = 20;
	float INNER_RADIUS = 40;
	float RADIUS_BUMP = 1;

	Light(float $x, float $y, float $w, float $h, String $segment, float $radius_bump)
	{
		_x = $x;
		_y = $y;
		_w = $w;
		_h = $h;
		_segment = $segment;
		RADIUS_BUMP = $radius_bump;
	}

	void draw()
	{
		//fill(white, OPACITY);
		// stroke(255, 255, 255, 100);
		// rectMode(CORNER);
		// ellipse(_x, _y, _w, _h);

		tint(255, OPACITY);
		imageMode(CENTER);
		pushMatrix();
			translate(_x, _y);
			if( _segment == "INNER" ) {
				// image(blueOrb, 0, 0, INNER_RADIUS*2, INNER_RADIUS*2);
				// image(greenOrb, 0, 0, INNER_RADIUS*1.5, INNER_RADIUS*1.5);
				// image(redOrb, 0, 0, INNER_RADIUS, INNER_RADIUS);
				image(blueOrb, 0, 0, INNER_RADIUS * RADIUS_BUMP, INNER_RADIUS * RADIUS_BUMP);
			}

			if( _segment == "MIDDLE" ) {
				// image(redOrb, 0, 0, MIDDLE_RADIUS*2, MIDDLE_RADIUS*2);
				// image(greenOrb, 0, 0, MIDDLE_RADIUS*1.5, MIDDLE_RADIUS*1.5);
				// image(whiteOrb, 0, 0, MIDDLE_RADIUS, MIDDLE_RADIUS);
				image(greenOrb, 0, 0, MIDDLE_RADIUS * RADIUS_BUMP, MIDDLE_RADIUS * RADIUS_BUMP);
			}

			if( _segment == "OUTER" ) {
				//image(redOrb, 0, 0, OUTER_RADIUS, OUTER_RADIUS);
				//image(blueOrb, 0, 0, OUTER_RADIUS/2, OUTER_RADIUS/2);
				image(redOrb, 0, 0, OUTER_RADIUS * RADIUS_BUMP, OUTER_RADIUS * RADIUS_BUMP);
			}

		popMatrix();
	}

	void update()
	{
		OPACITY -= reducer;
		// stroke(255, 255, 255, 100);
		// rectMode(CORNER);
		// ellipse(_x, _y, _w, _h);
		
		tint(255, OPACITY);
		imageMode(CENTER);
		pushMatrix();
			translate(_x, _y);
			if( _segment == "INNER" ) {
				// image(blueOrb, 0, 0, INNER_RADIUS*2, INNER_RADIUS*2);
				// image(greenOrb, 0, 0, INNER_RADIUS*1.5, INNER_RADIUS*1.5);
				// image(redOrb, 0, 0, INNER_RADIUS, INNER_RADIUS);
				image(blueOrb, 0, 0, INNER_RADIUS * RADIUS_BUMP, INNER_RADIUS * RADIUS_BUMP);
			}

			if( _segment == "MIDDLE" ) {
				// image(redOrb, 0, 0, MIDDLE_RADIUS*2, MIDDLE_RADIUS*2);
				// image(greenOrb, 0, 0, MIDDLE_RADIUS*1.5, MIDDLE_RADIUS*1.5);
				// image(whiteOrb, 0, 0, MIDDLE_RADIUS, MIDDLE_RADIUS);
				image(greenOrb, 0, 0, MIDDLE_RADIUS * RADIUS_BUMP, MIDDLE_RADIUS * RADIUS_BUMP);
			}

			if( _segment == "OUTER" ) {
				//image(redOrb, 0, 0, OUTER_RADIUS, OUTER_RADIUS);
				//image(blueOrb, 0, 0, OUTER_RADIUS/2, OUTER_RADIUS/2);
				image(redOrb, 0, 0, OUTER_RADIUS * RADIUS_BUMP, OUTER_RADIUS * RADIUS_BUMP);
			}

		popMatrix();
	}

}