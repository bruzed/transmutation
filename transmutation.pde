/**
 *	<p>Transmutation: Custom audio visualization software created for Speak Onion's <http://www.speakonion.com/> live performance on 01/27/2012 @ The Charleston, NYC.</p>
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

//guis
CreationGui creationGui;
MutationGui mutationGui;
BirthGui birthGui;
RebirthGui rebirthGui;

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

void setup()
{
	size(screenWidth, screenHeight, OPENGL);
	hint(DISABLE_OPENGL_2X_SMOOTH);
	smooth();
	frameRate(30);
	
	//load images
	bg = loadImage("mutation.png");
	blackOrb = loadImage("black_orb.png");
	whiteOrb = loadImage("white_orb_tex.png");
	redOrb = loadImage("red_orb_tex.png");
	greenOrb = loadImage("green_orb_tex.png");
	blueOrb = loadImage("blue_orb_tex.png");
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
	
	ui = new ControlP5(this);
	ui.setAutoDraw(false);
	controlWindow = ui.addControlWindow("controls", 0, 0, 1600, 600);
	controlWindow.setBackground(color(0));
	
	//guis
	creationGui = new CreationGui(ui, controlWindow);
	mutationGui = new MutationGui(ui, controlWindow);
	birthGui = new BirthGui(ui, controlWindow);
	rebirthGui = new RebirthGui(ui, controlWindow);
	drawGUI();
	
	myfont = loadFont("MechanicalFun.vlw");
	textFont(myfont, 18);
	textblock = new TextBlock();
}

void drawGUI()
{
	creationGui.draw();
	mutationGui.draw();
	birthGui.draw();
	rebirthGui.draw();
	
	//splitscreen
	splitScreen = ui.addToggle("splitscreen", false, 20, 20, 20, 20);
	splitScreen.moveTo(controlWindow);
}

void draw()
{
	background(0, 0, 0);
	imageMode(CORNER);
	image(bg, 0, 0, screenWidth, screenHeight);
	
	pgl = (PGraphicsOpenGL) g;
	gl = pgl.gl;
	pgl.beginGL();
		gl.glDisable(GL.GL_DEPTH_TEST);
		gl.glEnable(GL.GL_BLEND);
		gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
	pgl.endGL();
	
	ui.draw();
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
		default:
			textblock.draw();
			break;
	}
	
}

void keyPressed() 
{
	if(key=='1') {
    	frame.setLocation( -1280, 0);
	} else if(key=='2') {
    	frame.setLocation(0, 0);
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
	//reset
	if($e.controller().name() == "reset_creation") { creation.reset(); }
	if($e.controller().name() == "reset_mutation") { mutation.reset(); }
	if($e.controller().name() == "reset_birth") { birth.reset(); }
	if($e.controller().name() == "reset_rebirth") { rebirth.reset(); }
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