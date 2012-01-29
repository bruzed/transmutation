class MutationGui
{
	
	ControlP5 ui;
	ControlWindow controlWindow;
	Button play_mutation_button;
	Slider attractor_sensitivity_slider, burst_sensitivity_slider;
	Range vehicle_scale_range_slider;
	
	MutationGui(ControlP5 $ui, ControlWindow $controlWindow)
	{
		ui = $ui;
		controlWindow = $controlWindow;
	}
	
	void draw()
	{
		//name, x, y, width
		ControlGroup scene_mutation = ui.addGroup("Mutation", group_xpos + group_width + padding, group_ypos, group_width);
		scene_mutation.moveTo(controlWindow);

		//name, value, x, y, width, height
		play_mutation_button = ui.addButton("play_mutation", 0, play_button_xpos, play_button_ypos, button_width, button_height);
		play_mutation_button.setId(1);
		play_mutation_button.setGroup(scene_mutation);
		
		Button reset_mutation = ui.addButton("reset_mutation", 0, reset_button_xpos, reset_button_ypos, reset_button_width, button_height);
		reset_mutation.setGroup(scene_mutation);
		
		attractor_sensitivity_slider = ui.addSlider(
			"attractor_sensitivity", 
			0, 100, mutation.getAttractorSensitivity(),
			0, play_mutation_button.getHeight() + padding + 10, 
			slider_width, slider_height
		);
		attractor_sensitivity_slider.setGroup(scene_mutation);

		//name, min, max, default min, default max, x, y, width, height
		vehicle_scale_range_slider = ui.addRange(
			"vehicle_scale_range", 
			0, 100, 
			mutation.getVehicleScaleSensitivityMin(), mutation.getVehicleScaleSensitivityMax(), 
			0, scene_mutation.getHeight() + play_mutation_button.getHeight() + attractor_sensitivity_slider.getHeight() + (padding * 2), 
			slider_width, slider_height
		);
		vehicle_scale_range_slider.setGroup(scene_mutation);
		
		burst_sensitivity_slider = ui.addSlider(
			"mutation_burst_sensitivity", 
			0, 100, mutation.getBurstSensitivity(),
			0, play_mutation_button.getHeight() + vehicle_scale_range_slider.getHeight() + attractor_sensitivity_slider.getHeight() + (padding * 4), 
			slider_width, slider_height
		);
		burst_sensitivity_slider.setGroup(scene_mutation);

	}
	
}