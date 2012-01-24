class CreationGui
{
	
	ControlP5 ui;
	ControlWindow controlWindow;
	Button play_creation_button; 
	Range division_range;
	Range xpos_range_slider;
	Slider tentacle_move_sensitivity;
	Slider tentacle_position_sensitivity;
	Slider burst_sensitivity_slider;
	
	CreationGui(ControlP5 $ui, ControlWindow $controlWindow)
	{
		ui = $ui;
		controlWindow = $controlWindow;
	}
	
	void draw()
	{
		//creation
		//name, x, y, width
		ControlGroup scene_creation = ui.addGroup("Creation", group_xpos, group_ypos, group_width);
		scene_creation.moveTo(controlWindow);

		//name, value, x, y, width, height
		play_creation_button = ui.addButton("play_creation", 0, play_button_xpos, play_button_ypos, button_width, button_height);
		play_creation_button.setId(0);
		play_creation_button.setGroup(scene_creation);
		Button reset_creation = ui.addButton("reset_creation", 0, reset_button_xpos, reset_button_ypos, reset_button_width, button_height);
		reset_creation.setGroup(scene_creation);

		//name, min, max, default min, default max, x, y, width, height
		division_range = ui.addRange(
			"divisions_range", 
			creation.getMinPossibleDivisions(), creation.getMaxPossibleDivisions(), 
			creation.getMinDivisions(), creation.getMaxDivisions(), 
			0, scene_creation.getHeight() + play_creation_button.getHeight() + padding, 
			slider_width, slider_height
		);
		division_range.setGroup(scene_creation);

		xpos_range_slider = ui.addRange(
			"xposition_range", 
			0, float(screenWidth), 
			creation.getMinXPos(), creation.getMaxXPos(), 
			0, scene_creation.getHeight() + play_creation_button.getHeight() + division_range.getHeight() + (padding * 2), 
			slider_width, slider_height
		);
		xpos_range_slider.setGroup(scene_creation);

		//name, min, max, x, y, width, height
		tentacle_move_sensitivity = ui.addSlider(
			"tentacle_curl_sensitivity", 
			0, 100, creation.getTentacleMoveSensitivity(),
			0, scene_creation.getHeight() + play_creation_button.getHeight() + division_range.getHeight() + xpos_range_slider.getHeight() + (padding * 3), 
			slider_width, slider_height
		);
		tentacle_move_sensitivity.setGroup(scene_creation);

		tentacle_position_sensitivity = ui.addSlider(
			"tentacle_xposition_sensitivity", 
			0, 100, creation.getTentaclePositionSensitivity(),
			0, scene_creation.getHeight() + play_creation_button.getHeight() + division_range.getHeight() + xpos_range_slider.getHeight() + tentacle_move_sensitivity.getHeight() + (padding * 4), 
			slider_width, slider_height
		);
		tentacle_position_sensitivity.setGroup(scene_creation);

		burst_sensitivity_slider = ui.addSlider(
			"burst_sensitivity", 
			0, 100, creation.getBurstSensitivity(),
			0, scene_creation.getHeight() + play_creation_button.getHeight() + division_range.getHeight() + xpos_range_slider.getHeight() + tentacle_move_sensitivity.getHeight() + tentacle_position_sensitivity.getHeight() + (padding * 5), 
			slider_width, slider_height
		);
		burst_sensitivity_slider.setGroup(scene_creation);

	}
	
}