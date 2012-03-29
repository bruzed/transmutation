class Rebirth
{
	FFT fft;
	
	float DISTORT_SENSITIVITY_MIN_DEFAULT = 9;
	float DISTORT_SENSITIVITY_MAX_DEFAULT = 10;
	float ROTATEX_POSITIVE_SENSITIVITY_MIN_DEFAULT = 10;
	float ROTATEX_POSITIVE_SENSITIVITY_MAX_DEFAULT = 11;
	float ROTATEX_NEGATIVE_SENSITIVITY_MIN_DEFAULT = 25;
	float ROTATEX_NEGATIVE_SENSITIVITY_MAX_DEFAULT = 26;
	float ROTATEY_POSITIVE_SENSITIVITY_MIN_DEFAULT = 15;
	float ROTATEY_POSITIVE_SENSITIVITY_MAX_DEFAULT = 16;
	float ROTATEY_NEGATIVE_SENSITIVITY_MIN_DEFAULT = 30;
	float ROTATEY_NEGATIVE_SENSITIVITY_MAX_DEFAULT = 31;
	float ROTATEZ_POSITIVE_SENSITIVITY_MIN_DEFAULT = 20;
	float ROTATEZ_POSITIVE_SENSITIVITY_MAX_DEFAULT = 21;
	float ROTATEZ_NEGATIVE_SENSITIVITY_MIN_DEFAULT = 35;
	float ROTATEZ_NEGATIVE_SENSITIVITY_MAX_DEFAULT = 36;
	float ROTATEX_FAST_SENSITIVITY_MIN_DEFAULT = 45;
	float ROTATEX_FAST_SENSITIVITY_MAX_DEFAULT = 46;
	float SUBDIV_SENSITIVITY_MIN_DEFAULT = 40;
	float SUBDIV_SENSITIVITY_MAX_DEFAULT = 41;
	
	float DISTORT_SENSITIVITY_MIN = 9;
	float DISTORT_SENSITIVITY_MAX = 10;
	float ROTATEX_POSITIVE_SENSITIVITY_MIN = 10;
	float ROTATEX_POSITIVE_SENSITIVITY_MAX = 11;
	float ROTATEX_NEGATIVE_SENSITIVITY_MIN = 25;
	float ROTATEX_NEGATIVE_SENSITIVITY_MAX = 26;
	float ROTATEY_POSITIVE_SENSITIVITY_MIN = 15;
	float ROTATEY_POSITIVE_SENSITIVITY_MAX = 16;
	float ROTATEY_NEGATIVE_SENSITIVITY_MIN = 30;
	float ROTATEY_NEGATIVE_SENSITIVITY_MAX = 31;
	float ROTATEZ_POSITIVE_SENSITIVITY_MIN = 20;
	float ROTATEZ_POSITIVE_SENSITIVITY_MAX = 21;
	float ROTATEZ_NEGATIVE_SENSITIVITY_MIN = 35;
	float ROTATEZ_NEGATIVE_SENSITIVITY_MAX = 36;
	float ROTATEX_FAST_SENSITIVITY_MIN = 45;
	float ROTATEX_FAST_SENSITIVITY_MAX = 46;
	float SUBDIV_SENSITIVITY_MIN = 40;
	float SUBDIV_SENSITIVITY_MAX = 41;
	
	ToxiclibsSupport gfx;
	WETriangleMesh mesh;
	SubdivisionStrategy subdiv=new MidpointSubdivision();
	List<Vec3D> vertBackup = new ArrayList<Vec3D>();

	float currZoom = 1;
	boolean isWireframe=true;
	int randomSubdiv = 1;
	boolean isSubdivided = false;

	String vectorCoords = "";

	float rotateXValue;
	float rotateYValue;
	float rotateZValue;

	float SUBDIV_RANGE = 3.0;
	
	color c1 = color( random(0, 255), random(0, 255), random(0, 255) );
	
	String[] subdivisionTypes = { "MidpointSubdivision", "MidpointDisplacementSubdivision", "DualSubdivision", "TriSubdivision", "NormalDisplacementSubdivision" };

	Rebirth(FFT $fft, ToxiclibsSupport $gfx) 
	{
	  	fft = $fft;
		//gfx = new ToxiclibsSupport(this);
		gfx = $gfx;
	  	initMesh();
	}

	void initMesh() 
	{
	  mesh = new WETriangleMesh();
	  //mesh.addMesh(new Plane(new Vec3D(), new Vec3D(0, 1, 0)).toMesh(400));
	  mesh.addMesh(new AABB(new Vec3D(0, 0, 0), 40).toMesh());
	  backupMesh();
	}

	// keep a backup of all vertex positions for wireframe rendering
	void backupMesh() 
	{
	  vertBackup.clear();
	  for (Vec3D v : mesh.getVertices()) {
	    vertBackup.add(v.copy());
	  }
	}

	void draw() 
	{
		//fill(255, 150);
		//text("subdivision: " + subdivisionTypes[randomSubdiv], 10, 40);
		//text("subdivision: " + subdivisionTypes[randomSubdiv-1] + " " + vectorCoords, 140, 700, 300, 100);
		fill(c1, 50);
		//noFill();
		stroke(c1, 50);
		pushMatrix();
	  	translate(width / 2, height / 2, 0);
	  	//rotateX(mouseY * 0.01f);
	  	//rotateY(mouseX * 0.01f);

		rotateYValue += 0.01f;
		rotateY(rotateYValue);

		rotateX(rotateXValue);
		rotateZ(rotateZValue);

	  	scale(currZoom);
	  	drawWireMeshDelta();
		if(!isSubdivided) {
			isSubdivided = true;
			subdivide( SUBDIV_RANGE );
		}

		lights();
		gfx.mesh(mesh, true, 0);

		fft.forward(audioInput.mix);
		int w = int(width/fft.avgSize());
		//println(fft.avgSize());

		for( int i = 0; i < fft.avgSize(); i++ ) {
			//rect( i*w, height, i*w + w, height - fft.getAvg(i)*5 );
			//println(fft.getAvg(i));
			if( fft.getAvg(i) > DISTORT_SENSITIVITY_MIN && fft.getAvg(i) < DISTORT_SENSITIVITY_MAX ) {
				//if( i < 26 ) {
					Vec3D v = mesh.getVertexForID(i);
					Vec3D vbackup = vertBackup.get(i);
					//println("v.z: " + v.z + ", vbackup.z: " + vbackup.z + ", fft.getAvg(i): " + fft.getAvg(i));
					float distortion = 300;
					v.x = vbackup.x + cos( random(-fft.getAvg(i), fft.getAvg(i)) ) * distortion;
					v.y = vbackup.y + sin( random(-fft.getAvg(i), fft.getAvg(i)) ) * distortion;
					v.z = vbackup.z + sin( random(-fft.getAvg(i), fft.getAvg(i)) ) * distortion;
				//}
			}
			
			if( fft.getAvg(i) > ROTATEX_POSITIVE_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEX_POSITIVE_SENSITIVITY_MAX ) {
				rotateXValue += 0.05f;
			}

			if( fft.getAvg(i) > ROTATEY_POSITIVE_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEY_POSITIVE_SENSITIVITY_MAX ) {
				rotateYValue += 0.05f;
			}

			if( fft.getAvg(i) > ROTATEZ_POSITIVE_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEZ_POSITIVE_SENSITIVITY_MAX ) {
				rotateZValue += 0.05f;
			}

			if( fft.getAvg(i) > ROTATEX_NEGATIVE_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEX_NEGATIVE_SENSITIVITY_MAX ) {
				rotateXValue -= 0.05f;
			}

			if( fft.getAvg(i) > ROTATEY_NEGATIVE_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEY_NEGATIVE_SENSITIVITY_MAX ) {
				rotateYValue -= 0.05f;
			}

			if( fft.getAvg(i) > ROTATEZ_NEGATIVE_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEZ_NEGATIVE_SENSITIVITY_MAX ) {
				rotateZValue -= 0.05f;
			}

			if( fft.getAvg(i) > SUBDIV_SENSITIVITY_MIN && fft.getAvg(i) < SUBDIV_SENSITIVITY_MAX ) {
				//subdivide( SUBDIV_RANGE );
				change_color();
			}

			if( fft.getAvg(i) > ROTATEX_FAST_SENSITIVITY_MIN && fft.getAvg(i) < ROTATEX_FAST_SENSITIVITY_MAX ) {
				rotateXValue += 0.5f;
			}
		}
		popMatrix();
	}

	void drawWireMeshDelta() 
	{
	  beginShape(LINES);
	  for (WingedEdge e : mesh.edges.values()) {
	    int idA=((WEVertex) e.a).id;
	    int idB=((WEVertex) e.b).id;
	    float da = e.a.distanceTo(vertBackup.get(idA));
	    float db = e.b.distanceTo(vertBackup.get(idB));
	    vertex(e.a.x, e.a.y, e.a.z);
	    vertex(e.b.x, e.b.y, e.b.z);
	  }
	  endShape();
	}

	void subdivide( float range )
	{
		initMesh();
	    // subdivide all mesh edges if their length > 10
		randomSubdiv = round( random( 1, 5 ) );
		//fill( 255, 0, 0, 100);
		//c1 = color( random(0, 255), random(0, 255), random(0, 255) );
		//fill( random(0, 255), random(0, 255), random(0, 255), 100);
		//fill(c1, 150);
		//stroke(c1, 50);
		//noStroke();

		switch( randomSubdiv ) {
	      case '1':
	        // midpoint subdiv splits an edge in half
	        subdiv=new MidpointSubdivision();
	        break;
	      case '2':
	        // splits an edge in half and displaces midpoint along dir from mesh centroid
	        // in this case the point moves 22% of original edge length towards mesh centroid
	        subdiv=new MidpointDisplacementSubdivision(mesh.computeCentroid(),-0.22);
	        break;
	      case '3':
	        // splits edges at 33% and 66%, resulting in 3 shorter ones
	        subdiv=new DualSubdivision();
	        break;
	      case '4':
	        // splits edges at 25%, 50% and 75%, resulting in 4 shorter ones
	        subdiv=new TriSubdivision();
	        break;
	      case '5':
	        // similar to MidpointDisplacementSubdivision, only displacement direction is
	        // not based on relation to a fixed reference point, but uses average normal vector
	        // of faces attached to each edge
	        subdiv=new NormalDisplacementSubdivision(0.25f);
	        break;
	    }
	    mesh.subdivide(subdiv);
		mesh.subdivide(subdiv);
	    //backupMesh();
		for (Vec3D v : mesh.getVertices()) {
			//println(v);
			vectorCoords += v; 
			v.scaleSelf(random(-range, range));
		  }
		  mesh.rebuildIndex();
		  backupMesh();
	}

	void change_color()
	{
		c1 = color( random(0, 255), random(0, 255), random(0, 255) );
		fill(c1, 150);
		noStroke();
	}
	
	//getters/setters
	
	float[] getDistortSensitivity()
	{
		float[] values = new float[2];
		values[0] = DISTORT_SENSITIVITY_MIN;
		values[1] = DISTORT_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateXPositiveSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEX_POSITIVE_SENSITIVITY_MIN;
		values[1] = ROTATEX_POSITIVE_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateXNegativeSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEX_NEGATIVE_SENSITIVITY_MIN;
		values[1] = ROTATEX_NEGATIVE_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateYPositiveSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEY_POSITIVE_SENSITIVITY_MIN;
		values[1] = ROTATEY_POSITIVE_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateYNegativeSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEY_NEGATIVE_SENSITIVITY_MIN;
		values[1] = ROTATEY_NEGATIVE_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateZPositiveSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEZ_POSITIVE_SENSITIVITY_MIN;
		values[1] = ROTATEZ_POSITIVE_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateZNegativeSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEZ_NEGATIVE_SENSITIVITY_MIN;
		values[1] = ROTATEZ_NEGATIVE_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getRotateFastSensitivity()
	{
		float[] values = new float[2];
		values[0] = ROTATEX_FAST_SENSITIVITY_MIN;
		values[1] = ROTATEX_FAST_SENSITIVITY_MAX;
		return values;
	}
	
	float[] getSubdivSensitivity()
	{
		float[] values = new float[2];
		values[0] = SUBDIV_SENSITIVITY_MIN;
		values[1] = SUBDIV_SENSITIVITY_MAX;
		return values;
	}
	
	void setDistortSensitivity(float $min, float $max)
	{
		DISTORT_SENSITIVITY_MIN = $min;
		DISTORT_SENSITIVITY_MAX = $max;
	}
	
	void setRotateXPositiveSensitivity(float $min, float $max)
	{
		ROTATEX_POSITIVE_SENSITIVITY_MIN = $min;
		ROTATEX_POSITIVE_SENSITIVITY_MAX = $max;
	}
	
	void setRotateXNegativeSensitivity(float $min, float $max)
	{
		ROTATEX_NEGATIVE_SENSITIVITY_MIN = $min;
		ROTATEX_NEGATIVE_SENSITIVITY_MAX = $max;
	}
	
	void setRotateYPositiveSensitivity(float $min, float $max)
	{
		ROTATEY_POSITIVE_SENSITIVITY_MIN = $min;
		ROTATEY_POSITIVE_SENSITIVITY_MAX = $max;
	}
	
	void setRotateYNegativeSensitivity(float $min, float $max)
	{
		ROTATEY_NEGATIVE_SENSITIVITY_MIN = $min;
		ROTATEY_NEGATIVE_SENSITIVITY_MAX = $max;
	}
	
	void setRotateZPositiveSensitivity(float $min, float $max)
	{
		ROTATEZ_POSITIVE_SENSITIVITY_MIN = $min;
		ROTATEZ_POSITIVE_SENSITIVITY_MAX = $max;
	}
	
	void setRotateZNegativeSensitivity(float $min, float $max)
	{
		ROTATEZ_NEGATIVE_SENSITIVITY_MIN = $min;
		ROTATEZ_NEGATIVE_SENSITIVITY_MAX = $max;
	}
	
	void setRotateFastSensitivity(float $min, float $max)
	{
		ROTATEX_FAST_SENSITIVITY_MIN = $min;
		ROTATEX_FAST_SENSITIVITY_MAX = $max;
	}
	
	void setSubdivSensitivity(float $min, float $max)
	{
		SUBDIV_SENSITIVITY_MIN = $min;
		SUBDIV_SENSITIVITY_MAX = $max;
	}
	
	void reset()
	{
		DISTORT_SENSITIVITY_MIN = DISTORT_SENSITIVITY_MIN_DEFAULT;
		DISTORT_SENSITIVITY_MAX = DISTORT_SENSITIVITY_MAX_DEFAULT;
		ROTATEX_POSITIVE_SENSITIVITY_MIN = ROTATEX_POSITIVE_SENSITIVITY_MIN_DEFAULT;
		ROTATEX_POSITIVE_SENSITIVITY_MAX = ROTATEX_POSITIVE_SENSITIVITY_MAX_DEFAULT;
		ROTATEX_NEGATIVE_SENSITIVITY_MIN = ROTATEX_NEGATIVE_SENSITIVITY_MIN_DEFAULT;
		ROTATEX_NEGATIVE_SENSITIVITY_MAX = ROTATEX_NEGATIVE_SENSITIVITY_MAX_DEFAULT;
		ROTATEY_POSITIVE_SENSITIVITY_MIN = ROTATEY_POSITIVE_SENSITIVITY_MIN_DEFAULT;
		ROTATEY_POSITIVE_SENSITIVITY_MAX = ROTATEY_POSITIVE_SENSITIVITY_MAX_DEFAULT;
		ROTATEY_NEGATIVE_SENSITIVITY_MIN = ROTATEY_NEGATIVE_SENSITIVITY_MIN_DEFAULT;
		ROTATEY_NEGATIVE_SENSITIVITY_MAX = ROTATEY_NEGATIVE_SENSITIVITY_MAX_DEFAULT;
		ROTATEZ_POSITIVE_SENSITIVITY_MIN = ROTATEZ_POSITIVE_SENSITIVITY_MIN_DEFAULT;
		ROTATEZ_POSITIVE_SENSITIVITY_MAX = ROTATEZ_POSITIVE_SENSITIVITY_MAX_DEFAULT;
		ROTATEZ_NEGATIVE_SENSITIVITY_MIN = ROTATEZ_NEGATIVE_SENSITIVITY_MIN_DEFAULT;
		ROTATEZ_NEGATIVE_SENSITIVITY_MAX = ROTATEZ_NEGATIVE_SENSITIVITY_MAX_DEFAULT;
		ROTATEX_FAST_SENSITIVITY_MIN = ROTATEX_FAST_SENSITIVITY_MIN_DEFAULT;
		ROTATEX_FAST_SENSITIVITY_MAX = ROTATEX_FAST_SENSITIVITY_MAX_DEFAULT;
		SUBDIV_SENSITIVITY_MIN = SUBDIV_SENSITIVITY_MIN_DEFAULT;
		SUBDIV_SENSITIVITY_MAX = SUBDIV_SENSITIVITY_MAX_DEFAULT;
	}
	
}