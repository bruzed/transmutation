class Box 
{

  	Body body;
  	float w;
  	float h;
	PImage orb;

  	Box(float x_, float y_, float w_, float h_) 
	{
    	float x = x_;
    	float y = y_;
		w = w_;
		h = h_;
		
    	makeBody(new Vec2(x,y),w,h);
    	body.setUserData(this);
		orb = loadImage("orb.png");
  	}

  	void killBody() 
	{
    	box2d.destroyBody(body);
  	}

  	boolean contains(float x, float y) 
	{
    	Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    	Shape s = body.getShapeList();
    	boolean inside = s.testPoint(body.getMemberXForm(),worldPoint);
    	return inside;
  	}

  	void display() 
	{
    	Vec2 pos = box2d.getBodyPixelCoord(body);
    	float a = body.getAngle();
    	rectMode(PConstants.CENTER);
    	pushMatrix();
    	translate(pos.x,pos.y);
    	rotate(-a);
		fill(0, 50);
		noStroke();
		imageMode(CENTER);
		image(blueOrb, 0, 0, w*2, h*2);
		image(greenOrb, 0, 0, w*1.5, h*1.5);
		image(redOrb, 0, 0, w, h);
    	popMatrix();
  	}

  	void makeBody(Vec2 center, float w_, float h_) 
	{
    	BodyDef bd = new BodyDef();
		bd.position.set(box2d.coordPixelsToWorld(center));
    	body = box2d.createBody(bd);
    	PolygonDef sd = new PolygonDef();
    	float box2dW = box2d.scalarPixelsToWorld(w_/2);
    	float box2dH = box2d.scalarPixelsToWorld(h_/2);
    	sd.setAsBox(box2dW, box2dH);
    	sd.density = 1.0f;
    	sd.friction = 0.3f;
    	sd.restitution = 0.5f;
    	body.createShape(sd);
    	body.setMassFromShapes();
    	body.setLinearVelocity(new Vec2(random(-5,5),random(2,5)));
    	body.setAngularVelocity(random(-5,5));
  	}

	// Wraparound
	void borders() 
	{
		Vec2 pos = box2d.getBodyPixelCoord(body);
	    if (pos.x < -width) pos.x = width + width;
	    if (pos.y < -height) pos.y = height + height;
	    if (pos.x > width+width) pos.x = - width;
	    if (pos.y > height+height) pos.y = - width;
	}

}


