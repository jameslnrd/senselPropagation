/**************************************************************************
 * Copyright 2015 Sensel, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **************************************************************************/

/**
 * Read Contacts
 * by Aaron Zarraga - Sensel, Inc
 * 
 * This opens a Sensel sensor, reads contact data, and prints the data to the console.
 */

boolean sensel_sensor_opened = false;

int WINDOW_WIDTH_PX = 1150;
//We will scale the height such that we get the same aspect ratio as the sensor
int WINDOW_HEIGHT_PX;
SenselDevice sensel;

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() 
{
  
  DisposeHandler dh = new DisposeHandler(this);
  sensel = new SenselDevice(this);
  
  sensel_sensor_opened = sensel.openConnection();
  
  if(!sensel_sensor_opened)
  {
    println("Unable to open Sensel sensor!");
    exit();
    return; 
  }
  
  //Init window height so that display window aspect ratio matches sensor.
  //NOTE: This must be done AFTER senselInit() is called, because senselInit() initializes
  //  the sensor height/width fields. This dependency needs to be fixed in later revisions 
  WINDOW_HEIGHT_PX = (int) (sensel.getSensorHeightMM() / sensel.getSensorWidthMM() * WINDOW_WIDTH_PX);
  
  size(1150, 800);
  
    /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12001);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  //Enable contact sending
  sensel.setFrameContentControl(SenselDevice.SENSEL_FRAME_CONTACTS_FLAG);
  
  frameRate(200);
  
  //Enable scanning
  sensel.startScanning();
}

void draw() 
{
  if(!sensel_sensor_opened)
    return;
    
  background(0);
 
  SenselContact[] c = sensel.readContacts();
  
  if(c == null)
  {
    println("NULL CONTACTS");
    return;
  }
   
  for(int i = 0; i < c.length; i++)
  {
    float force = c[i].total_force;
    
    float area = c[i].area_mm_sq;
    
    float sensor_x_mm = c[i].x_pos_mm;
    float sensor_y_mm = c[i].y_pos_mm;
    
    int screen_x = (int) ((sensor_x_mm / sensel.getSensorWidthMM())  * WINDOW_WIDTH_PX);
    int screen_y = (int) ((sensor_y_mm / sensel.getSensorHeightMM()) * WINDOW_HEIGHT_PX);
    
    
      /* in the following different ways of creating osc messages are shown by example */
    OscMessage myMessage = new OscMessage("/contact/");
  
    myMessage.add(screen_x); /* add an int to the osc message */
    myMessage.add(screen_y);

    myMessage.add(force);
    myMessage.add(area);

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation); 
    
    float orientation = c[i].orientation_degrees;
    float major = c[i].major_axis_mm;
    float minor = c[i].minor_axis_mm;
    
    // NOTE: This assumes window is scaled similar to sensor:
    int screen_major = (int) ((major / sensel.getSensorWidthMM())  * WINDOW_WIDTH_PX);
    int screen_minor = (int) ((minor / sensel.getSensorWidthMM())  * WINDOW_WIDTH_PX);
   
    int id = c[i].id;
    int event_type = c[i].type;
        
    String event;
    switch (event_type)
    {
      case SenselDevice.SENSEL_EVENT_CONTACT_INVALID:
        event = "invalid"; 
        break;
      case SenselDevice.SENSEL_EVENT_CONTACT_START:
        sensel.setLEDBrightness(id, (byte)100); //turn on LED
        event = "start";   
        break;
      case SenselDevice.SENSEL_EVENT_CONTACT_MOVE:
        event = "move";
        break;
      case SenselDevice.SENSEL_EVENT_CONTACT_END:
        sensel.setLEDBrightness(id, (byte)0);
        event = "end";
        break;
      default:
        event = "error";
    }
    
    //println("Contact ID " + id + ", event=" + event + ", mm coord: (" + sensor_x_mm + ", " + sensor_y_mm + "), shape: (" + orientation + ", " + major + ", " + minor + "), area=" + area + ", force=" + force); 

    if(true) // Set to false to just draw circles
    {
      float scale = (float)force / 10000.0f;
      if(scale > 1.0f) scale = 1.0f;

      color from = color(0, 102, 153);
      color to = color(204, 102, 0);
      color clr = lerpColor(from, to, scale);

      pushMatrix();
      translate( screen_x, screen_y );
      rotate( radians(orientation) );

      stroke(255);
      fill(clr);
      ellipse( 0, 0, screen_minor, screen_major);
      popMatrix();
    }
    else
    {
      float size = force / 100.0f;
      if(size < 10) size = 10;      
      
      ellipse(screen_x, screen_y, size, size);
    }
  }
}

public class DisposeHandler 
{   
  DisposeHandler(PApplet pa)
  {
    pa.registerMethod("dispose", this);
  }  
  public void dispose()
  {      
    println("Closing sketch");
    if(sensel_sensor_opened)
    {
      sensel.stopScanning();
      sensel.closeConnection();
    }
  }
}
