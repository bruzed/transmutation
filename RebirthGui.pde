class RebirthGui
{
	
	ControlP5 ui;
	ControlWindow controlWindow;
	Button play_rebirth_button;
	Range distort_sensitivity_range_slider;
	Range rotatex_positive_sensitivity_range_slider;
	Range rotatex_negative_sensitivity_range_slider;
	Range rotatey_positive_sensitivity_range_slider;
	Range rotatey_negative_sensitivity_range_slider;
	Range rotatez_positive_sensitivity_range_slider;
	Range rotatez_negative_sensitivity_range_slider;
	Range rotatex_fast_sensitivity_range_slider;
	Range subdiv_sensitivity_range_slider;
	
	RebirthGui(ControlP5 $ui, ControlWindow $controlWindow)
	{
		ui = $ui;
		controlWindow = $controlWindow;
	}
	
	void draw()
	{
		//name, x, y, width
		ControlGroup scene_rebirth = ui.addGroup("Rebirth", group_xpos, 330, group_width);
		scene_rebirth.moveTo(controlWindow);

		//name, value, x, y, width, height
		play_rebirth_button = ui.addButton("play_rebirth", 0, play_button_xpos, play_button_ypos, button_width, button_height);
		play_rebirth_button.setId(3);
		play_rebirth_button.setGroup(scene_rebirth);
		
		Button reset_rebirth = ui.addButton("reset_rebirth", 0, reset_button_xpos, reset_button_ypos, reset_button_width, button_height);
		reset_rebirth.setGroup(scene_rebirth);

		//name, min, max, default min, default max, x, y, width, height
		distort_sensitivity_range_slider = ui.addRange(
			"distort_sensitivity_range", 
			0, 100, 
			rebirth.getDistortSensitivity()[0], rebirth.getDistortSensitivity()[1], 
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + padding,
			slider_width, slider_height
		);
		distort_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatex_positive_sensitivity_range_slider = ui.addRange(
			"rotatex_positive_sensitivity_range", 
			0, 100, 
			rebirth.getRotateXPositiveSensitivity()[0], rebirth.getRotateXPositiveSensitivity()[1], 
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + (padding * 2), 
			slider_width, slider_height
		);
		rotatex_positive_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatex_negative_sensitivity_range_slider = ui.addRange(
			"rotatex_negative_sensitivity_range", 
			0, 100, 
			rebirth.getRotateXNegativeSensitivity()[0], rebirth.getRotateXNegativeSensitivity()[1], 
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + (padding * 3), 
			slider_width, slider_height
		);
		rotatex_negative_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatey_positive_sensitivity_range_slider = ui.addRange(
			"rotatey_positive_sensitivity_range", 
			0, 100, 
			rebirth.getRotateYPositiveSensitivity()[0], rebirth.getRotateYPositiveSensitivity()[1],
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + rotatex_negative_sensitivity_range_slider.getHeight() + (padding * 4), 
			slider_width, slider_height
		);
		rotatey_positive_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatey_negative_sensitivity_range_slider = ui.addRange(
			"rotatey_negative_sensitivity_range", 
			0, 100, 
			rebirth.getRotateYNegativeSensitivity()[0], rebirth.getRotateYNegativeSensitivity()[1],
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + rotatex_negative_sensitivity_range_slider.getHeight() + rotatey_positive_sensitivity_range_slider.getHeight() + (padding * 5), 
			slider_width, slider_height
		);
		rotatey_negative_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatez_positive_sensitivity_range_slider = ui.addRange(
			"rotatez_positive_sensitivity_range", 
			0, 100, 
			rebirth.getRotateZPositiveSensitivity()[0], rebirth.getRotateZPositiveSensitivity()[1],
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + rotatex_negative_sensitivity_range_slider.getHeight() + rotatey_positive_sensitivity_range_slider.getHeight() + rotatey_negative_sensitivity_range_slider.getHeight() + (padding * 6), 
			slider_width, slider_height
		);
		rotatez_positive_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatez_negative_sensitivity_range_slider = ui.addRange(
			"rotatez_negative_sensitivity_range", 
			0, 100, 
			rebirth.getRotateZNegativeSensitivity()[0], rebirth.getRotateZNegativeSensitivity()[1],
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + rotatex_negative_sensitivity_range_slider.getHeight() + rotatey_positive_sensitivity_range_slider.getHeight() + rotatey_negative_sensitivity_range_slider.getHeight() + rotatez_positive_sensitivity_range_slider.getHeight() + (padding * 7), 
			slider_width, slider_height
		);
		rotatez_negative_sensitivity_range_slider.setGroup(scene_rebirth);
		
		rotatex_fast_sensitivity_range_slider = ui.addRange(
			"rotatex_fast_sensitivity_range", 
			0, 100, 
			rebirth.getRotateFastSensitivity()[0], rebirth.getRotateFastSensitivity()[1],
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + rotatex_negative_sensitivity_range_slider.getHeight() + rotatey_positive_sensitivity_range_slider.getHeight() + rotatey_negative_sensitivity_range_slider.getHeight() + rotatez_positive_sensitivity_range_slider.getHeight() + rotatez_negative_sensitivity_range_slider.getHeight() + (padding * 8), 
			slider_width, slider_height
		);
		rotatex_fast_sensitivity_range_slider.setGroup(scene_rebirth);
		
		subdiv_sensitivity_range_slider = ui.addRange(
			"subdiv_sensitivity_range", 
			0, 100, 
			rebirth.getSubdivSensitivity()[0], rebirth.getSubdivSensitivity()[1],
			0, scene_rebirth.getHeight() + play_rebirth_button.getHeight() + distort_sensitivity_range_slider.getHeight() + rotatex_positive_sensitivity_range_slider.getHeight() + rotatex_negative_sensitivity_range_slider.getHeight() + rotatey_positive_sensitivity_range_slider.getHeight() + rotatey_negative_sensitivity_range_slider.getHeight() + rotatez_positive_sensitivity_range_slider.getHeight() + rotatez_negative_sensitivity_range_slider.getHeight() + rotatex_fast_sensitivity_range_slider.getHeight() + (padding * 9), 
			slider_width, slider_height
		);
		subdiv_sensitivity_range_slider.setGroup(scene_rebirth);

	}
	
}