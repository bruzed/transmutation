class Burst
{
	float m;
	float radius = 10;
	//float radius2 = MAX_XPOS-MIN_XPOS;
	float radius2 = 10;
	color burstColor;
	float increment = 5;
	float alpha;
	float xpos = width/2;
	float ypos = height;
	
	Burst()
	{
		burstColor = colors[ (int) random(colors.length)  ];
		alpha = random(5, 10);
		increment = random(5, 10);
	}
	
	Burst(float x, float y)
	{
		burstColor = colors[ (int) random(colors.length)  ];
		alpha = random(1, 5);
		increment = random(5, 10);
		xpos = x;
		ypos = y;
	}
	
	void draw()
	{
		imageMode(CENTER);
		image(redOrb, xpos, ypos, radius, radius2);
		image(blueOrb, xpos, ypos, radius/2, radius2/2);
		//ellipse(xpos, ypos, radius, radius2);
	}
	
	void update()
	{
		radius *= increment;
		radius2 *= increment;
		fill( burstColor, alpha );
		noStroke();
		imageMode(CENTER);
		image(redOrb, xpos, ypos, radius, radius2);
		image(blueOrb, xpos, ypos, radius/2, radius2/2);
		//ellipse(xpos, ypos, radius, radius2);
	}
	
}