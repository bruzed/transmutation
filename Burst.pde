class Burst
{
	float m;
	float radius = 10;
	//float radius2 = MAX_XPOS-MIN_XPOS;
	float radius2 = 10;
	color burstColor;
	float increment = 0.01;
	float alpha;
	float xpos = width/2;
	float ypos = height;
	
	Burst()
	{
		burstColor = colors[ (int) random(colors.length)  ];
		alpha = random(5, 10);
		increment = random(0.01, 10.0);
	}
	
	Burst(float x, float y)
	{
		burstColor = colors[ (int) random(colors.length)  ];
		alpha = random(5, 10);
		increment = random(0.01, 10.0);
		xpos = x;
		ypos = y;
	}
	
	void draw()
	{
		ellipse(xpos, ypos, radius, radius2);
	}
	
	void update()
	{
		radius += increment;
		radius2 += increment;
		fill( burstColor, alpha );
		noStroke();
		ellipse(xpos, ypos, radius, radius2);
	}
	
}