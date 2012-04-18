/**
 *	<p>Transmutation: Custom audio visualization software created for Speak Onion's <http://www.speakonion.com/> live performances.</p>
 *	
 *	Thanks to Daniel Shiffman's - The Nature of Code <http://www.shiffman.net/teaching/nature>
 *	
 *  Copyright (C) 2012  bruzed
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import controlP5.*;
import processing.opengl.*;
import javax.media.opengl.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import org.jbox2d.util.nonconvex.*;
import org.jbox2d.testbed.*;
import org.jbox2d.p5.*;

import toxi.color.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.math.*;
import toxi.util.*;
import toxi.processing.*;

import deadpixel.keystone.*;
import codeanticode.glgraphics.*;

Minim minim;
AudioInput audioInput;
FFT fft;
PBox2D box2d;
ToxiclibsSupport gfx;
PGraphicsOpenGL pgl;
GL gl;

ControlP5 ui;
ControlWindow controlWindow;

//controls
int current_scene = -1;

//scenes
Creation creation;
Mutation mutation;
Birth birth;
Rebirth rebirth;

//super new
Lights lights;


//guis
CreationGui creationGui;
MutationGui mutationGui;
BirthGui birthGui;
RebirthGui rebirthGui;
LightsGui lightsGui;

//gui
int group_xpos = 20;
int group_ypos = 80;
int group_width = 380;
int padding = 10;
int play_button_xpos = 0;
int play_button_ypos = 10;
int button_width = 200;
int button_height = 50;
int reset_button_xpos = 210;
int reset_button_ypos = 10;
int reset_button_width = 90;
int slider_width = 200;
int slider_height = 30;

Toggle splitScreen;

//colors
color greenColor = color(130, 126, 0);
color redColor = color(114, 5, 2);
color lightYellow = color(255, 220, 128);
color lightBlue = color(112, 210, 238);
int[] colors = { greenColor, redColor };

color mutation_green = color(36, 53, 27);

//defaults
int screenWidth = 1280;
int screenHeight = 800; //hd
//int screenHeight = 768;

PImage bg;
PImage whiteOrb, redOrb, greenOrb, blueOrb, blackOrb, redTriangle, greenTriangle, whiteTriangle;

PFont myfont;
TextBlock textblock;

GLGraphicsOffScreen offscreen;
Keystone ks;
CornerPinSurface surface;

//shaders
GLTexture mutation_texture, dest;
GLTexture[] sources;
GLTextureFilter[] filters;
int sel = -1;

Button button_fly, button_tunnel, button_rtunnel, button_shaders_off, button_text;

Button keystone_calibrate, keystone_load, keystone_save;

//float t = 1.0;

void setup()
{
	//size(screenWidth, screenHeight, OPENGL);
	size(screenWidth, screenHeight, GLConstants.GLGRAPHICS);
	offscreen = new GLGraphicsOffScreen(this, width, height);
	ks = new Keystone(this);
	surface = ks.createCornerPinSurface(width, height, 10);

	hint(DISABLE_OPENGL_2X_SMOOTH);
	smooth();
	frameRate(30);

	//PFont font = loadFont("Tahoma-18.vlw");
  	//textFont(font, 18);
	
	//load images
	//bg = loadImage("mutation.png");
	blackOrb = loadImage("black_orb.png");
	whiteOrb = loadImage("white_orb.png");
	redOrb = loadImage("red_orb.png");
	greenOrb = loadImage("green_orb.png");
	blueOrb = loadImage("blue_orb.png");
	redTriangle = loadImage("red_triangle.png");
	greenTriangle = loadImage("green_triangle.png");
	whiteTriangle = loadImage("white_triangle.png");
	
	//setup minim
	minim = new Minim(this);
	audioInput = minim.getLineIn(Minim.STEREO, 512);
	fft = new FFT( audioInput.bufferSize(), audioInput.sampleRate() );
	fft.logAverages(22, 3);
	
	//setup box2d
	box2d = new PBox2D(this);
	
	//setup toxiclibs support
	gfx = new ToxiclibsSupport(this);
	
	//scenes
	creation = new Creation(fft);
	mutation = new Mutation(fft);
	birth = new Birth(fft, box2d);
	rebirth = new Rebirth(fft, gfx);

	//new scenes
	lights = new Lights(fft);
	
	ui = new ControlP5(this);
	ui.setAutoDraw(false);
	controlWindow = ui.addControlWindow("controls", 0, 0, 1600, 600);
	controlWindow.setBackground(color(0));
	
	//guis
	creationGui = new CreationGui(ui, controlWindow);
	mutationGui = new MutationGui(ui, controlWindow);
	birthGui = new BirthGui(ui, controlWindow);
	rebirthGui = new RebirthGui(ui, controlWindow);
	lightsGui = new LightsGui(ui, controlWindow);
	drawGUI();
	
	myfont = loadFont("MechanicalFun-48.vlw");
	textFont(myfont, 48);
	textblock = new TextBlock();

	//shaders
	GLTextureParameters params = new GLTextureParameters();
	params.wrappingU = REPEAT;
	params.wrappingV = REPEAT;
	mutation_texture = new GLTexture(this, "mutation.png", params);   
	dest = new GLTexture(this, width, height);
	  
	filters = new GLTextureFilter[3];
	sources = new GLTexture[3];

	filters[0] = new GLTextureFilter(this, "Fly.xml");
	sources[0] = mutation_texture;

	filters[1] = new GLTextureFilter(this, "Tunnel.xml");
	sources[1] = mutation_texture;

	filters[2] = new GLTextureFilter(this, "ReliefTunnel.xml");
	sources[2] = mutation_texture;
	  
	float[] res = new float[] {width, height};  
	for (int i = 0; i < filters.length; i++) {
		filters[i].setParameterValue("resolution", res);
	}
}

void drawGUI()
{
	creationGui.draw();
	mutationGui.draw();
	birthGui.draw();
	rebirthGui.draw();
	lightsGui.draw();

	//speak onion
	button_text = ui.addButton("speak_onion", 0, 20, 20, button_width/2, 20);
	button_text.setId(5);
	button_text.moveTo(controlWindow);
	
	//splitscreen
	splitScreen = ui.addToggle("splitscreen", false, button_text.getWidth() + (padding*3), 20, 20, 20);
	splitScreen.moveTo(controlWindow);

	//keystone
	ControlGroup keystone_controls = ui.addGroup("Keystone", 1250, 20, 320);
	keystone_controls.moveTo(controlWindow);

	keystone_calibrate = ui.addButton("calibrate", 0, 0, 10, button_width/2, 20);
	keystone_calibrate.setGroup(keystone_controls);

	keystone_save = ui.addButton("save", 0, keystone_calibrate.getWidth() + padding, 10, button_width/2, 20);
	keystone_save.setGroup(keystone_controls);

	keystone_load = ui.addButton("load", 0, keystone_calibrate.getWidth() + keystone_save.getWidth() + (padding*2), 10, button_width/2, 20);
	keystone_load.setGroup(keystone_controls);

	//buttons to switch shaders
	ControlGroup shader_controls = ui.addGroup("Shaders", 10, 400, 320);
	shader_controls.moveTo(controlWindow);

	button_fly = ui.addButton("fly", 0, 0, 10, button_width/2, button_height);
	button_fly.setGroup(shader_controls);

	button_tunnel = ui.addButton("tunnel", 0, button_width/2 + 10, 10, button_width/2, button_height);
	button_tunnel.setGroup(shader_controls);

	button_rtunnel = ui.addButton("relief_tunnel", 0, button_width/2 * 2 + 20, 10, button_width/2, button_height);
	button_rtunnel.setGroup(shader_controls);

	button_shaders_off = ui.addButton("shaders_off", 0, 0, button_fly.getHeight() + (padding*2), button_width/2, button_height);
	button_shaders_off.setGroup(shader_controls);

}

void draw()
{
	// convert 
  	PVector mouse1 = surface.getTransformedMouse();

  	offscreen.beginDraw();
		
		background(0, 0, 0);

		float t = millis() / 2000.0;
   		
   		if( sel > -1 ) {
   			filters[sel].setParameterValue("time", t);

	  		if (0 < filters[sel].getNumInputTextures()) {
	    		filters[sel].apply(sources[sel], dest);
	  		} else {
	    		filters[sel].apply(dest);
	  		}
   		}
  		
  		tint(255, 255);
  		imageMode(CORNER);

		//imageMode(CORNER);
		//image(bg, 0, 0, screenWidth, screenHeight);
		
		pgl = (PGraphicsOpenGL) g;
		gl = pgl.gl;
		pgl.beginGL();
			gl.glDisable(GL.GL_DEPTH_TEST);
			gl.glEnable(GL.GL_BLEND);
			gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
		pgl.endGL();
		
		ui.draw();
		
		if(sel > -1) {
			image(dest, 0, 0);
		}

		//draw the selected scene
		switch(current_scene) {
			case 0:
				creation.draw();
				break;
			case 1:
				mutation.draw();
				break;
			case 2:
				birth.draw();
				break;
			case 3:
				rebirth.draw();
				break;
			case 4:
				lights.draw();
				break;
			case 5:
				textblock = new TextBlock();
				textblock.draw();
				break;
			default:
				textblock = new TextBlock();
				textblock.draw();
				break;
		}

		//text(filters[sel].getName() + " - fps: " + nfc(frameRate, 2) + " - time: " + nfc(t, 2), 0, 20);

	offscreen.endDraw();

	background(0, 0, 0);
	surface.render(offscreen.getTexture());
	
}

void keyPressed() 
{

	if(key=='1') {
    	frame.setLocation( -1280, 0);
	} else if(key=='2') {
    	frame.setLocation(0, 0);
  	}

  	switch(key) {
	  	case 'c':
	    	// enter/leave calibration mode, where surfaces can be warped 
	    	// & moved
	    	ks.toggleCalibration();
	    	break;

	  	case 'l':
	    	// loads the saved layout
	    	ks.load();
	    	break;

	  	case 's':
	    	// saves the layout
	    	ks.save();
	    	break;
	}
}

void stop()
{
	audioInput.close();
	minim.stop();
	super.stop();
}

// overrides the init() method so we can undecorate the
// main window first, then we have to call init() for the super class
// to init the sketch
public void init() 
{
	frame.removeNotify();
  	frame.setUndecorated(true);
  	frame.addNotify();
  	super.init();
}

void controlEvent(ControlEvent $e)
{
	//id's 0,1,2,3,4 used to set scenes
	//println($e.controller().name());
	//current_scene = $e.controller().id();
	//play
	if($e.controller().name() == "play_creation") { current_scene = $e.controller().id(); }
	if($e.controller().name() == "play_mutation") { current_scene = $e.controller().id(); }
	if($e.controller().name() == "play_birth") { current_scene = $e.controller().id(); }
	if($e.controller().name() == "play_rebirth") { current_scene = $e.controller().id(); }
	if($e.controller().name() == "play_lights") { current_scene = $e.controller().id(); }
	if($e.controller().name() == "speak_onion") { current_scene = $e.controller().id(); }
	//reset
	if($e.controller().name() == "reset_creation") { creation.reset(); }
	if($e.controller().name() == "reset_mutation") { mutation.reset(); }
	if($e.controller().name() == "reset_birth") { birth.reset(); }
	if($e.controller().name() == "reset_rebirth") { rebirth.reset(); }
	if($e.controller().name() == "reset_lights") { lights.reset(); }
	//switch shaders
	if($e.controller().name() == "fly") { sel = 0; }
	if($e.controller().name() == "tunnel") { sel = 1; }
	if($e.controller().name() == "relief_tunnel") { sel = 2; }
	if($e.controller().name() == "shaders_off") { sel = -1; }
	//keystone controls
	if($e.controller().name() == "calibrate") { ks.toggleCalibration(); }
	if($e.controller().name() == "save") { ks.save(); }
	if($e.controller().name() == "load") { ks.load(); }
}

//splitscreen
void splitscreen(boolean theFlag) {
	if(theFlag==true) {
    	frame.setLocation( -1280, 0);
  	} else {
    	frame.setLocation( 0, 0);
  	}
}

//creation
void divisions_range(float $value)
{
	float[] values = creationGui.division_range.arrayValue();
	creation.setDivisions(values[0], values[1]);
}

void xposition_range(float $value)
{
	float[] values = creationGui.xpos_range_slider.arrayValue();
	creation.setXpos(values[0], values[1]);
}

void tentacle_curl_sensitivity(float $value)
{
	creation.setTentacleMoveSensitivity($value);
}

void tentacle_xposition_sensitivity(float $value)
{
	creation.setTentaclePositionSensitivity($value);
}

void burst_sensitivity(float $value)
{
	creation.setBurstSensitivity($value);
}

//mutation
void attractor_sensitivity(float $value)
{
	mutation.setAttractorSensitivity($value);
}

void vehicle_scale_range(float $value)
{
	float[] values = mutationGui.vehicle_scale_range_slider.arrayValue();
	mutation.setVehicleScaleSensitivity(values[0], values[1]);
}

void mutation_burst_sensitivity(float $value)
{
	mutation.setBurstSensitivity($value);
}

//birth
void generation_sensitivity(float $value)
{
	birth.setGenerationSensitivity($value);
}

void mover_sensitivity(float $value)
{
	birth.setMoverSensitivity($value);
}

void spring1_sensitivity(float $value)
{
	birth.setSpring1Sensitivity($value);
}

void spring2_sensitivity(float $value)
{
	birth.setSpring2Sensitivity($value);
}

void birth_burst_sensitivity(float $value)
{
	birth.setBurstSensitivity($value);
}

//rebirth
void distort_sensitivity_range(float $value)
{
	float[] values = rebirthGui.distort_sensitivity_range_slider.arrayValue();
	rebirth.setDistortSensitivity(values[0], values[1]);
}

void rotatex_positive_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatex_positive_sensitivity_range_slider.arrayValue();
	rebirth.setRotateXPositiveSensitivity(values[0], values[1]);
}

void rotatex_negative_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatex_negative_sensitivity_range_slider.arrayValue();
	rebirth.setRotateXNegativeSensitivity(values[0], values[1]);
}

void rotatey_positive_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatey_positive_sensitivity_range_slider.arrayValue();
	rebirth.setRotateYPositiveSensitivity(values[0], values[1]);
}

void rotatey_negative_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatey_negative_sensitivity_range_slider.arrayValue();
	rebirth.setRotateYNegativeSensitivity(values[0], values[1]);
}

void rotatez_positive_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatez_positive_sensitivity_range_slider.arrayValue();
	rebirth.setRotateZPositiveSensitivity(values[0], values[1]);
}

void rotatez_negative_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatez_negative_sensitivity_range_slider.arrayValue();
	rebirth.setRotateZNegativeSensitivity(values[0], values[1]);
}

void rotatex_fast_sensitivity_range(float $value)
{
	float[] values = rebirthGui.rotatex_fast_sensitivity_range_slider.arrayValue();
	rebirth.setRotateFastSensitivity(values[0], values[1]);
}

void subdiv_sensitivity_range(float $value)
{
	float[] values = rebirthGui.subdiv_sensitivity_range_slider.arrayValue();
	rebirth.setSubdivSensitivity(values[0], values[1]);
}

void rebirth_burst_sensitivity(float $value)
{
	rebirth.setBurstSensitivity($value);
}

//lights
void outer_sensitivity(float $value)
{
	lights.setOuterSensitivity($value);
}

void middle_sensitivity(float $value)
{
	float[] values = lightsGui.middle_sensitivity_range.arrayValue();
	lights.setMiddleSensitivity(values[0], values[1]);
}

void inner_sensitivity(float value)
{
	float[] values = lightsGui.inner_sensitivity_range.arrayValue();
	lights.setInnerSensitivity(values[0], values[1]);
}

void rotate_positive(float $value)
{
	lights.setRotateZPositiveSensitivity($value);
}

void rotate_negative(float $value)
{
	lights.setRotateZNegativeSensitivity($value);
}