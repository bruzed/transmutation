// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A rectangular box

class Box {

  	// We need to keep track of a Body and a width and height
  	Body body;
  	float w;
  	float h;
	PImage orb;

  // Constructor
  Box(float x_, float y_, float w_, float h_) {
    float x = x_;
    float y = y_;
    //w = 50;
    //h = 50;
	w = w_;
	h = h_;
		
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
    body.setUserData(this);
	orb = loadImage("orb.png");
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Shape s = body.getShapeList();
    boolean inside = s.testPoint(body.getMemberXForm(),worldPoint);
    return inside;
  }

// Drawing the box
  void display() {
	
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    //fill(175);
	fill(0, 50);
    //stroke(0);
	//stroke(255, 50);
	//strokeWeight(2);
	noStroke();
    //rect(0,0,w,h);
	imageMode(CENTER);
	//image(orb, 0, 0, w, h);
	//image(orb, 0, 0, w, h);
	image(blueOrb, 0, 0, w*2, h*2);
	image(greenOrb, 0, 0, w*1.5, h*1.5);
	image(redOrb, 0, 0, w, h);
	//ellipse(0,0,w,h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    //bd.position.set(box2d.coordPixelsToWorld(center));
	
	bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Define the shape -- a polygon (this is what we use for a rectangle)
    PolygonDef sd = new PolygonDef();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);
    // Parameters that affect physics
    sd.density = 1.0f;
    sd.friction = 0.3f;
    sd.restitution = 0.5f;

    // Attach that shape to our body!
    body.createShape(sd);
    body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5,5),random(2,5)));
    body.setAngularVelocity(random(-5,5));
  }

// Wraparound
	  void borders() {
		Vec2 pos = box2d.getBodyPixelCoord(body);
	    if (pos.x < -width) pos.x = width + width;
	    if (pos.y < -height) pos.y = height + height;
	    if (pos.x > width+width) pos.x = - width;
	    if (pos.y > height+height) pos.y = - width;
	  }

}


