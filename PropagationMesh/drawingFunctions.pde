float zZoom = 2;
float gradient = 200;

void drawLine(Vect3D pos1, Vect3D pos2){
line((float)pos1.x, (float)pos1.y, zZoom *(float)pos1.z, (float)pos2.x, (float)pos2.y, zZoom * (float)pos2.z);
}


void renderLinks(PhysicalModel mdl){
   stroke(255, 255, 0);
   strokeWeight(1);
  for( int i = 0; i < mdl.getNumberOfLinks(); i++){
    switch (mdl.getLinkTypeAt(i)){
      case Spring3D:
        stroke(0, 255, 0);
        drawLine(mdl.getLinkPos1At(i), mdl.getLinkPos2At(i));
        break;
      case Damper3D:
        stroke(125, 125, 125);
        drawLine(mdl.getLinkPos1At(i), mdl.getLinkPos2At(i));
        break; 
      case SpringDamper3D:
        
        float grad = (float)(mdl.getLinkPos1At(i).dist(mdl.getLinkPos2At(i)) - gridSpacing);
        
        stroke(100+1*zZoom*(float)mdl.getLinkPos1At(i).z,0, 255, grad* 100 + gradient);

        
        //double gradient = mdl.getOsc3DDeltaPos(i);
        drawLine(mdl.getLinkPos1At(i), mdl.getLinkPos2At(i));
        break;
      case Rope3D:
        stroke(210, 235, 110);
        drawLine(mdl.getLinkPos1At(i), mdl.getLinkPos2At(i));
        break;
      case Contact3D:
        break; 
      case PlaneContact3D:
        break;
      case UNDEFINED:
        break;
    }
  }
}
