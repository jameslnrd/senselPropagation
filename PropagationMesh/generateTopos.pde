void generatePinScreen(PhysicalModel mdl, int dimX, int dimY, String mName, String lName, double masValue, double dist, double K_osc, double Z_osc, double K, double Z) {
  // add the masses to the model: name, mass, initial pos, init speed
  String masName;
  String solName;
  Vect3D X0, V0;
  
    /* Group modules into subsets for parameter modifications */
  mdl.createMatSubset("massmod");
  mdl.createLinkSubset("OscSpr");  
  mdl.createLinkSubset("X_springs");  
  mdl.createLinkSubset("Y_springs");


  for (int i = 0; i < dimY; i++) {
    for (int j = 0; j < dimX; j++) {
      masName = mName + j +"_"+ i;
      println(masName);
      X0 = new Vect3D((float)j*dist,(float)i*dist, 0.);
      V0 = new Vect3D(0., 0., 0.);
      mdl.addMass3D(masName, masValue, X0, V0);
      mdl.addGround3D(masName+"G", X0);
      mdl.addSpringDamper3D("ospr_"+j +"_"+ i, 0, K_osc, Z_osc, masName, masName+"G");
      mdl.addLinkToSubset("ospr_"+j +"_"+ i,"OscSpr");

      //mdl.addOsc3D(masName, masValue, K_osc, Z_osc, X0, V0);
      mdl.addMatToSubset(masName,"massmod");

    }
  }


  // add the spring to the model: length, stiffness, connected mats
  String masName1, masName2;

    for (int i = 0; i < dimX; i++) {
      for (int j = 0; j < dimY-1; j++) {
        masName1 = mName + i +"_"+ j;
        masName2 = mName + i +"_"+ str(j+1);
        //println("X " +masName1+masName2);
        mdl.addSpringDamper3D(lName + "1_x" +i+j, dist, K, Z, masName1, masName2);
        mdl.addLinkToSubset((lName + "1_x" +i+j),"X_springs");

      }
    }
    
    for (int i = 0; i < dimX-1; i++) {
      for (int j = 0; j < dimY; j++) {
        masName1 = mName + i +"_"+ j;
        masName2 = mName + str(i+1) +"_"+ j;
        //println("Y " +masName1+masName2);
        mdl.addSpringDamper3D(lName + "1_y" +i+j, dist, K, Z, masName1, masName2);
        mdl.addLinkToSubset((lName + "1_y" +i+j),"Y_springs");

      }
    }
}
