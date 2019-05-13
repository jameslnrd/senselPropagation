
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  String msg_string = theOscMessage.toString();
  String [] msg_list = msg_string.split(" ");
  
  println(msg_string);  
  println(msg_list[2]);
 
    if ((msg_list[2].equals("/contact/")) && (theOscMessage.checkTypetag("iiff"))) {
      println("test");
      int firstValue = theOscMessage.get(0).intValue();  
      int secondValue = theOscMessage.get(1).intValue();
      float thirdValue = theOscMessage.get(2).floatValue();  
      float fourthValue = theOscMessage.get(3).floatValue();
      
      engrave(firstValue, secondValue, -fourthValue/100.);

      println("Detected contact :\t " + firstValue + " " + secondValue + ", " + thirdValue + " " + fourthValue/10000.);
    }
    
    else if ((msg_list[2].equals("/phyParam/z")) && (theOscMessage.checkTypetag("f"))) {
      float val = theOscMessage.get(0).floatValue();
      mdl.changeDampingParamOfSubset(val,"X_springs");
      mdl.changeDampingParamOfSubset(val,"Y_springs");
      println("new Zosc :\t " + val);
    }
    
    else if ((msg_list[2].equals("/phyParam/zosc")) && (theOscMessage.checkTypetag("f"))) {
      float val = theOscMessage.get(0).floatValue();
      mdl.setFriction(val);
      println("new Zosc :\t " + val);
    }
    
    else if ((msg_list[2].equals("/phyParam/k")) && (theOscMessage.checkTypetag("f"))) {
      float val = theOscMessage.get(0).floatValue();
      mdl.changeStiffnessParamOfSubset(val,"X_springs");
      mdl.changeStiffnessParamOfSubset(val,"Y_springs");
      println("new K :\t " + val);
    }
    else if ((msg_list[2].equals("/phyParam/kosc")) && (theOscMessage.checkTypetag("f"))) {
      float val = theOscMessage.get(0).floatValue();
      mdl.changeStiffnessParamOfSubset(val,"OscSpr");
      println("new Kosc :\t " + val);
    }
    
    else if ((msg_list[2].equals("/phyParam/visG")) && (theOscMessage.checkTypetag("f"))) {
      float val = theOscMessage.get(0).floatValue();
      zZoom = -val*90;
      println("new Kosc :\t " + val);
    }
    else if ((msg_list[2].equals("/phyParam/grad")) && (theOscMessage.checkTypetag("f"))) {
      float val = theOscMessage.get(0).floatValue();
      gradient = val;
      println("new Kosc :\t " + val);
    }


}
