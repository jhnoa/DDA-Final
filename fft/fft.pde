import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
Minim minim;
AudioPlayer jingle, jingle1;
AudioOutput out;
BeatDetect beat;
FFT fft;
boolean runOnce=true;
float m;
SineInstrument sineInstrument;
float lastFreq=0;
String[] n={"A","Bb","B","C","C#","D","D#","E","F","F#","G","Ab"} ;
  float note;
  int index;
int [] pixelsOld;
void setup()
{
  size(512,512,P3D);
  
  minim = new Minim ( this);
  String fname="17 Kiss The Rain_[plixid.com].mp3";
  jingle = minim.loadFile(fname,4096);
  jingle1 = minim.loadFile(fname,4096);
  out = minim.getLineOut();
  jingle.loop();
  jingle.mute();
  m = millis();
  //jingle.mute();
  fft=new FFT(jingle.bufferSize(),jingle.sampleRate());
  fft.window(FFT.NONE);
  fft.logAverages(100,96);
  
  beat = new BeatDetect();  
  background(0);
  pixelsOld=new int[width*height];
}
void draw()
{
  if(millis()-m > 900)
  {
    if(runOnce)
    {
      runOnce=false;
      jingle1.loop();
    }
  }
  //rect(0,0,width,height);
  //fft.window(fft.HAMMING);
  fft.forward(jingle.mix);
  beat.detect(jingle.mix);
  beat.setSensitivity(2);
  noStroke();
  //stroke(0,255,0);
  
  double max=0;
  /*
  for (int i=10;i<40;i++)
  {
    max=max<fft.getBand(i+20)?fft.getBand(i+20):max;
    //stroke(fft.getBand(i+20)*20);
    //line(i*4,width,i*4,width-(log(fft.getBand(i+20)*20)*10));
  }
  */
  
  
  int high=int(map(6000,0,jingle.sampleRate(),0,fft.specSize()));
  int low=int(map(40,0,jingle.sampleRate(),0,fft.specSize()));
  
  ///if ( beat.isOnset() )
  //{
    int imax=0;
    boolean found=false;
    int req;
    req=4; //notes to show
    float lastFreq=0;
    
    
    //Atur Sensitivity
    int threshold=2;
    int notesFound=0;
    do
    {
      notesFound=0;
      for (int i=fft.avgSize()-1;i>=0;i--)
      {
        if(fft.getAvg(i)>threshold)
        {
          notesFound++;
        }
      }
      threshold++;
      println(threshold);
    }while(notesFound>req+ceil(random(20.0/100.0*req)));
    
    for (int i=fft.avgSize()-1;i>=0;i--)
    {
        //if(fft.getAverageCenterFrequency(i)<500) continue;
      //if(fft.getBand(i+20)==max)
      //{
        //stroke(fft.getBand(i+20)*20);
        //strokeWeight(1);
        //line(width,map(i,0,fft.avgSize(),0,width),width-2*fft.getAvg(i),map(i,0,fft.avgSize(),0,width));
        
        if(fft.getAvg(i)>threshold)
        {
          
          imax=i;
          
          
          //stroke(255);
          fill(255);
          
          //text(fft.getAverageCenterFrequency(imax),10.0,10.0);
          
          //out.playNote( 0.0, 0.5, new SineInstrument( fft.getAverageCenterFrequency(imax) ) );
          note = log(fft.getAverageCenterFrequency(imax)/440)/log(2)*12;
          
          if(abs(fft.getAverageCenterFrequency(imax)-lastFreq)>lastFreq*20.0/100.0 || fft.getAverageCenterFrequency(imax)==lastFreq)
          {
              //println(abs(fft.getAverageCenterFrequency(imax)-lastFreq));
                //out.playNote( 0.0, 0.4, new SineInstrument( pow(2, note/12) *440 ) );
                //lastFreq=pow(2, note/12) *440;
              index = (int(note))%12;
              
              
              while (index < 0) {index = index + 12;}
              /*
              if (6 <= index && index <= 9) {index = index + 1;}
              while (index == 5 && round(note)%12 == 6) {index = index + 1;}
              */
              
              /*
              if ( round(log(fft.getAverageCenterFrequency(imax)/440)/log(2)*12) == round(log(fft.getAverageCenterFrequency(imax-1)/440)/log(2)*12) )
              {
                imax = imax + 1;
              }
              */
              noStroke();
              
              /*
              if(
              index==1||
              index==4||
              index==6||
              index==9||
              index==11
              )
              {
                fill(0,200,100);
              }else
              {
                fill(0,100,200);
              }
              */
              colorMode(HSB);
              fill(map(index,0,12,0,270),map(fft.getAvg(imax),0,20,50,200),255);
              //println(fft.getAverageCenterFrequency(imax),note,index,n[index]);
              //text(n[index],40+(imax%12)*10,map(imax,0,fft.avgSize(),0,height));
              ellipseMode(CENTER);
              ellipse(width-60,round((map(imax,0,fft.avgSize(),height,-height/2)/5.0))*5.0,10,10);
              lastFreq=fft.getAverageCenterFrequency(imax);
              colorMode(RGB);
          }
          
        }
      
    }
    //println(iA);    
    
  //}
  
  
  /*
  fill(0,fft.getBand(30)*70,150);
  rectMode(CENTER);
  rect(width/2,height/2,100,fft.getBand(10)*80);
  fill(fft.getBand(30)*70,0,150);
  rect(width/2,height/2,fft.getBand(10)*100,50);
  */
  
  
  
  loadPixels(); //Prepare the pixels array


  for(int z=0;z<10;z++) //move canvas Z times
  {
    for(int i = 0; i < pixels.length; i ++) { //Loop through all of the pixels, position 0 is the top left corner going right and then down
      if(i%width > width-50) continue;
      if(i % width > 30 && i < pixels.length - 1) pixels[i] = pixels[i + 1]; //Assign each pixel to be the pixel to its right...
      //else pixels[i] = color(0); //...unless it is at the end of a line or is the last one, in which case we make it the background color
    }
    updatePixels(); //Update the pixels array to the screen
  }
  

  
  fill(240,50);
  rect(1,0, 30,height);
  String lastString="";
  for(int i=0;i<height;i+=10)
  {
    if(brightness(pixels[30+1+i*height])>0)
    {
      imax=int(map(i,0,height,0,fft.avgSize()));
      note = log(fft.getAverageCenterFrequency(imax)/440)/log(2)*12;
      index = (int(note))%12;
      while (index < 0) {index = index + 12;}
      
      fill(220,20,20);
      rect(i/width+5,i%width-(5/2),30-2*5,5);
      /*
      RIP Text
      fill(255);
      
      if(lastString!=n[11-index])
      {
        //println(n[11-index],lastString);
        if(lastString!="")
        {
          text(n[11-index],width-30,map(imax,0,fft.avgSize(),0,height));
        }
        lastString=n[11-index];
      }
      */
      //text("lol",i/width+20,imax);
      //println(pixels[30+1+i*height]);
    }
  }
  noStroke();
  fill(0,50);
  rect(width-50,0,width,height);
  
  
  
  
    

}
