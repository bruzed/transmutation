class CustomListener implements ContactListener 
{
	CustomListener(){}

  	void add(ContactPoint cp) 
	{
    	Shape s1 = cp.shape1;
    	Shape s2 = cp.shape2;
    	Body b1 = s1.getBody();
    	Body b2 = s2.getBody();
    	Object o1 = b1.getUserData();
    	Object o2 = b2.getUserData();
    
		if( o1 != null && o2 != null ) {
			if (o1.getClass() == Box.class) {
				try{
					CustomShape p = (CustomShape) o2;
					p.change();
				} catch(ClassCastException e) {}
	    	} else if (o2.getClass() == Box.class) {
				try 
				{
					CustomShape p = (CustomShape) o1;
					p.change();
				} catch(ClassCastException e) {}
			}
		}
	}

	void persist(ContactPoint cp) {}

	void remove(ContactPoint cp) {}

  	void result(ContactResult cr) {}
}





