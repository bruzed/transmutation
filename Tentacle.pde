class Tentacle
{
	float xpos;
	int divisions;
	int RADIUS_MAX = (int) random(10, 20);
	int RADIUS_MIN = RADIUS_MAX/2;
	float speed = 0.0;
	float speedInc = random(0.01, 0.1);
	float angle = 0;
	int MIN_XPOS;
	int MAX_XPOS;
	
	PImage orb;
	
	Tentacle(float $xpos, int $divisions, int $MIN_XPOS, int $MAX_XPOS)
	{
		xpos = $xpos;
		MIN_XPOS = $MIN_XPOS;
		MAX_XPOS = $MAX_XPOS;
		divisions = $divisions;
		orb = loadImage("orb.png");
	}
	
	void draw()
	{	
		//angle = sin(speed)/random(10.0, 50.0) + sin(speed*1.2)/random(5.0, 20.0);
		pushMatrix();
		translate(xpos, height);
		for (int i = divisions; i > 0; i--) {
			//stroke(130, 126, 0, 150);
			stroke(255, 255, 255, 80);
			line(0, 0, 0, -i);
			//strokeWeight(i);
			//noStroke();
			//fill(255, 255, 255, 50);
			fill(0, 50);
			//stroke(255, 50);
			noStroke();
			imageMode(CENTER);
			image(redOrb, 0, RADIUS_MAX, i*2, i*2);
			image(greenOrb, 0, RADIUS_MAX, i*1.5, i*1.5);
			image(whiteOrb, 0, RADIUS_MAX, i, i);
			//image(blueOrb, 0, RADIUS_MAX, i, i);
			//image(orb, 0, RADIUS_MAX, i, i);
			ellipse(0, RADIUS_MAX, i, i);
			fill(255, 255, 255, 50);
			ellipse(0, RADIUS_MAX, i/2, i/2);
			translate(0, - i );
			rotate(angle);
		}
		popMatrix();
	}
	
	void move()
	{
		speed += speedInc;
		angle = sin(speed)/random(20.0, 50.0) + sin(speed*1.2)/random(5.0, 20.0);
		draw();
	}
	
	void stop()
	{
		speed += 0.01;
		angle = sin(speed)/50.0 + sin(speed*1.2)/20.0;
		draw();
	}
	
	void changePosition()
	{
		xpos = random(MIN_XPOS, MAX_XPOS);
	}
	
}