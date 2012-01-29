class Boundary 
{
	float x;
  	float y;
  	float w;
  	float h;
  	Body b;
	float rotation;

  	Boundary(float x_,float y_, float w_, float h_) 
	{
    	x = x_;
    	y = y_;
    	w = w_;
    	h = h_;

    	float box2dW = box2d.scalarPixelsToWorld(w/2);
    	float box2dH = box2d.scalarPixelsToWorld(h/2);
    	Vec2 center = new Vec2(x,y);

    	PolygonDef sd = new PolygonDef();
    	sd.setAsBox(box2dW, box2dH);
    	sd.density = 0;
    	sd.friction = 0.3f;

    	BodyDef bd = new BodyDef();
    	bd.position.set(box2d.coordPixelsToWorld(center));
    	b = box2d.createBody(bd);
    	b.createShape(sd);
  	}

  	void display() 
	{
    	fill(255, 50);
    	stroke(0);
    	rectMode(CENTER);
    	rect(x,y,w,h);
  	}

}

