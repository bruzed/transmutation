// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// A rectangular box
class CustomShape {

  	// We need to keep track of a Body and a width and height
  	Body body;
	color col;
	float x1, y1, x2, y2, x3, y3, x4, y4, x5, y5;
	//PImage triangle;
	int imageWidth = 30;

  // Constructor
  CustomShape(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x,y));
	body.setUserData(this);
	//col = color(255, 150);
	col = color(255, 0, 0);
	//triangle = loadImage("triangle.png");
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
	
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
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
  void display() {
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
    //fill(col, 10);
	//stroke(255, 50);
	//strokeWeight(2);
	imageMode(CENTER);
	//image(triangle, 0, 0, triangle.width*0.6, triangle.height*0.6);
	image(redTriangle, 0, 0, imageWidth*1.5, imageWidth*1.5);
	image(greenTriangle, 0, 0, imageWidth*1.25, imageWidth*1.25);
	image(whiteTriangle, 0, 0, imageWidth, imageWidth);
    //beginShape();
    // For every vertex, convert to pixel vector
    //for (int i = 0; i < vertices.length; i++) {
      //Vec2 v = box2d.vectorWorldToPixels(vertices[i]);
      //vertex(v.x,v.y);
    //}
    //endShape(CLOSE);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonDef sd = new PolygonDef();
    /*sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(-15,25)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(10,5)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(15,0)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(20,-15)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(-10,-10)));*/

	//x1 = -15;
	/*x1 = int(random(-15, -11));
	//y1 = 25;
	y1 = int(random(21, 25));
	//x2 = 10;
	x2 = int(random(1, 10));
	//y2 = 5;
	y2 = int(random(5, 8));
	//x3 = 15;
	x3 = int(random(15, 19));
	y3 = 0;
	//x4 = 20;
	x4 = int(random(20, 25));
	y4 = -15;
	//x5 = -10;
	x5 = int(random(-10, -7));
	y5 = -10;
	
	println("x1: " + x1 + ", x2: " + x2 + ", x3: " + x3 + ", x4: " + x4 + ", x5: " + x5 + ", y1: " + y1 + ", y2: " + y2);
	
	sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(x1, y1)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(x2, y2)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(x3, y3)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(x4, y4)));
    sd.addVertex(box2d.vectorPixelsToWorld(new Vec2(x5, y5)));*/
	
	/*int n = 5;
	float startAngle = 0.0;
	float angle = TWO_PI/ n;
	//int cx = 50 * int(random(0, 6));
	//int cy = 50 * int(random(0, 6));
	int cx = 0;
	int cy = 0;
	float w = random(10, 200);
	float h = random(10, 200);
	int i = 0;
	Vec2 vert1 = box2d.coordPixelsToWorld( cx + w * cos(startAngle + angle * i), cy + h * sin(startAngle + angle * i) );
	i++;
	Vec2 vert2 = box2d.coordPixelsToWorld( cx + w * cos(startAngle + angle * i), cy + h * sin(startAngle + angle * i) );
	i++;
	Vec2 vert3 = box2d.coordPixelsToWorld( cx + w * cos(startAngle + angle * i), cy + h * sin(startAngle + angle * i) );
	i++;
	Vec2 vert4 = box2d.coordPixelsToWorld( cx + w * cos(startAngle + angle * i), cy + h * sin(startAngle + angle * i) );
	i++;
	Vec2 vert5 = box2d.coordPixelsToWorld( cx + w * cos(startAngle + angle * i), cy + h * sin(startAngle + angle * i) );

	sd.addVertex(box2d.vectorPixelsToWorld(vert1));
    sd.addVertex(box2d.vectorPixelsToWorld(vert2));
    sd.addVertex(box2d.vectorPixelsToWorld(vert3));
    sd.addVertex(box2d.vectorPixelsToWorld(vert4));
    sd.addVertex(box2d.vectorPixelsToWorld(vert5));*/
	
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

