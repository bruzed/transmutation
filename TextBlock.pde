class TextBlock
{
	
	String target;
	int popmax;
	float mutationRate;
	Population population;
	
	float xpos = screenWidth/4;
	float ypos = screenHeight/3;
	float width = 500;
	float height = 200;
	
	float MIN_WIDTH = 100;
	float MAX_WIDTH = 200;
	float MIN_HEIGHT = 20;
	float MAX_HEIGHT = 100;
	
	int PADDING = 50;

	TextBlock()
	{
		target = "Speak Onion ";
		popmax = 150;
		mutationRate = 0.01;
		population = new Population(target, mutationRate, popmax);
	}
	
	TextBlock(String $target, float $xpos, float $ypos)
	{
		target = $target;
		xpos = $xpos;
		ypos = $ypos;
		popmax = 150;
		mutationRate = 0.01;
		population = new Population(target, mutationRate, popmax);
	}

	void show()
	{
		textAlign(LEFT);
		fill(255);
	  	text(target, xpos, ypos);
	}
	
	void draw()
	{
		// Generate mating pool
		  population.naturalSelection();
		  //Create next generation
		  population.generate();
		  // Calculate fitness
		  population.calcFitness();
		  displayInfo();

		  // If we found the target phrase, stop
		  if (population.finished()) {
		    //println(millis()/1000.0);
		  }
	}
	
	void displayInfo() {
	  // Display current status of populationation
	  String answer = population.getBest();
	  textAlign(LEFT);
	  fill(255);
	  text(answer, xpos, ypos);
	}
	
}