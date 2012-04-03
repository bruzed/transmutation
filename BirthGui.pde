class BirthGui
{
	
	ControlP5 ui;
	ControlWindow controlWindow;
	Button play_birth_button;
	Slider generation_sensitivity_slider;
	Slider mover_sensitivity_slider;
	Slider spring1_sensitivity_slider;
	Slider spring2_sensitivity_slider;
	Slider burst_sensitivity_slider;
	
	BirthGui(ControlP5 $ui, ControlWindow $controlWindow)
	{
		ui = $ui;
		controlWindow = $controlWindow;
	}
	
	void draw()
	{
		//name, x, y, width
		ControlGroup scene_birth = ui.addGroup("Birth", group_xpos + (group_width + padding)*2, group_ypos, group_width);
		scene_birth.moveTo(controlWindow);

		//name, value, x, y, width, height
		play_birth_button = ui.addButton("play_birth", 0, play_button_xpos, play_button_ypos, button_width, button_height);
		play_birth_button.setId(2);
		play_birth_button.setGroup(scene_birth);
		
		Button reset_birth = ui.addButton("reset_birth", 0, reset_button_xpos, reset_button_ypos, reset_button_width, button_height);
		reset_birth.setGroup(scene_birth);
		
		generation_sensitivity_slider = ui.addSlider(
			"generation_sensitivity", 
			0, 100, birth.getGeneratorSensitivity(),
			0, play_birth_button.getHeight() + padding + 10, 
			slider_width, slider_height
		);
		generation_sensitivity_slider.setGroup(scene_birth);
		
		mover_sensitivity_slider = ui.addSlider(
			"mover_sensitivity", 
			0, 100, birth.getMoverSensitivity(),
			0, play_birth_button.getHeight() + generation_sensitivity_slider.getHeight() + (padding*3), 
			slider_width, slider_height
		);
		mover_sensitivity_slider.setGroup(scene_birth);
		
		spring1_sensitivity_slider = ui.addSlider(
			"spring1_sensitivity", 
			0, 100, birth.getSpring1Sensitivity(),
			0, play_birth_button.getHeight() + generation_sensitivity_slider.getHeight() + mover_sensitivity_slider.getHeight() + (padding*4), 
			slider_width, slider_height
		);
		spring1_sensitivity_slider.setGroup(scene_birth);
		
		spring2_sensitivity_slider = ui.addSlider(
			"spring2_sensitivity", 
			0, 100, birth.getSpring2Sensitivity(),
			0, play_birth_button.getHeight() + generation_sensitivity_slider.getHeight() + mover_sensitivity_slider.getHeight() + spring1_sensitivity_slider.getHeight() + (padding*5), 
			slider_width, slider_height
		);
		spring2_sensitivity_slider.setGroup(scene_birth);

		burst_sensitivity_slider = ui.addSlider(
			"birth_burst_sensitivity", 
			0, 100, birth.getBurstSensitivity(),
			0, play_birth_button.getHeight() + generation_sensitivity_slider.getHeight() + mover_sensitivity_slider.getHeight() + spring1_sensitivity_slider.getHeight() + (padding*6) + spring2_sensitivity_slider.getHeight(),
			slider_width, slider_height
		);
		burst_sensitivity_slider.setGroup(scene_birth);

	}
	
}