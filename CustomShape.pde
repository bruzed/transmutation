class CustomShape 
{
  	Body body;
	color col;
	float x1, y1, x2, y2, x3, y3, x4, y4, x5, y5;
	int imageWidth = 30;

  	CustomShape(float x, float y) 
	{
    	makeBody(new Vec2(x,y));
		body.setUserData(this);
		col = color(255, 0, 0);
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
	
  	boolean done() 
	{
    	Vec2 pos = box2d.getBodyPixelCoord(body);
    	if (pos.y > height) {
      		killBody();
      		return true;
    	}
    	return false;
  	}

	// Change color when hit
  	void change() {
    	//col = color(255,0,0);
		//col = color(255, 255, 255, 255);
  	}

  	// Drawing the box
  	void display() 
	{
    	// We look at each body and get its screen position
    	Vec2 pos = box2d.getBodyPixelCoord(body);
    	// Get its angle of rotation
    	float a = body.getAngle();
   
    	// Ask for the shape
    	PolygonShape ps = (PolygonShape) body.getShapeList();
    	// Get the array of vertices
    	Vec2[] vertices = ps.m_vertices;

    	rectMode(CENTER);
    	pushMatrix();
    		translate(pos.x,pos.y);
    		rotate(-a);
			imageMode(CENTER);
			image(redTriangle, 0, 0, imageWidth*1.5, imageWidth*1.5);
			image(greenTriangle, 0, 0, imageWidth*1.25, imageWidth*1.25);
			image(whiteTriangle, 0, 0, imageWidth, imageWidth);
    	popMatrix();
  	}

  	// This function adds the rectangle to the box2d world
  	void makeBody(Vec2 center) 
	{
    	// Define a polygon (this is what we use for a rectangle)
    	PolygonDef sd = new PolygonDef();
		Vec2 vert1 = new Vec2( 0, -10 );
		Vec2 vert2 = new Vec2( -10, 10 );
		Vec2 vert3 = new Vec2( 10, 10 );
		sd.addVertex(box2d.vectorPixelsToWorld(vert1));
    	sd.addVertex(box2d.vectorPixelsToWorld(vert2));
    	sd.addVertex(box2d.vectorPixelsToWorld(vert3));

    	// Parameters that affect physics
    	sd.density = 1.0f;
    	sd.friction = 0.3f;
    	sd.restitution = 0.5f;

    	// Define the body and make it from the shape
    	BodyDef bd = new BodyDef();
    	bd.position.set(box2d.coordPixelsToWorld(center));

    	body = box2d.createBody(bd);
		body.createShape(sd);
    	body.setMassFromShapes();

    	// Give it some initial random velocity
    	body.setLinearVelocity(new Vec2(random(-5,5),random(2,5)));
    	body.setAngularVelocity(random(-5,5));
  	}
}

