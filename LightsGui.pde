class LightsGui
{
	
	ControlP5 ui;
	ControlWindow controlWindow;
	Button play_lights_button;
	Slider outer_sensitivity;
	Range middle_sensitivity_range;
	Range inner_sensitivity_range;
	Slider rotate_positive;
	Slider rotate_negative;

	LightsGui(ControlP5 $ui, ControlWindow $controlWindow)
	{
		ui = $ui;
		controlWindow = $controlWindow;
	}

	void draw()
	{
		ControlGroup scene_lights = ui.addGroup("Lights", group_xpos + group_width + padding, 300, group_width);
		scene_lights.moveTo(controlWindow);

		play_lights_button = ui.addButton("play_lights", 0, play_button_xpos, play_button_ypos, button_width, button_height);
		play_lights_button.setId(4);
		play_lights_button.setGroup(scene_lights);

		Button reset_lights = ui.addButton("reset_lights", 0, reset_button_xpos, reset_button_ypos, reset_button_width, button_height);
		reset_lights.setGroup(scene_lights);

		outer_sensitivity = ui.addSlider(
			"outer_sensitivity",
			0, 100, lights.getOuterSensitivity(),
			0, scene_lights.getHeight() + play_lights_button.getHeight() + padding,
			slider_width, slider_height
		);
		outer_sensitivity.setGroup(scene_lights);

		middle_sensitivity_range = ui.addRange(
			"middle_sensitivity_range",
			0, 100,
			lights.getMiddleSensitivityMin(), lights.getMiddleSensitivityMax(),
			0, scene_lights.getHeight() + play_lights_button.getHeight() + outer_sensitivity.getHeight() + (padding*2),
			slider_width, slider_height
		);
		middle_sensitivity_range.setGroup(scene_lights);

		inner_sensitivity_range = ui.addRange(
			"inner_sensitivity",
			0, 100,
			lights.getInnerSensitivityMin(), lights.getInnerSensitivityMax(),
			0, scene_lights.getHeight() + play_lights_button.getHeight() + outer_sensitivity.getHeight() + middle_sensitivity_range.getHeight() + (padding*3), 
			slider_width, slider_height
		);
		inner_sensitivity_range.setGroup(scene_lights);

		rotate_positive = ui.addSlider(
			"rotate_positive",
			0, 100, lights.getRotateZPositiveSensitivty(),
			0, scene_lights.getHeight() + play_lights_button.getHeight() + outer_sensitivity.getHeight() + middle_sensitivity_range.getHeight() + inner_sensitivity_range.getHeight() + (padding*4),
			slider_width, slider_height
		);
		rotate_positive.setGroup(scene_lights);

		rotate_negative = ui.addSlider(
			"rotate_negative",
			0, 100, lights.getRotateZNegativeSensitivity(),
			0, scene_lights.getHeight() + play_lights_button.getHeight() + outer_sensitivity.getHeight() + middle_sensitivity_range.getHeight() + inner_sensitivity_range.getHeight() + rotate_positive.getHeight() + (padding*5),
			slider_width, slider_height
		);
		rotate_negative.setGroup(scene_lights);

	}

}