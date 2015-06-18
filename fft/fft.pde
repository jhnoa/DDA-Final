import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
Minim minim;
AudioPlayer jingle;
AudioOutput out;
BeatDetect beat;
FFT fft;
SineInstrument sineInstrument;
float lastFreq=0;
void setup()
{
  size(512,200,P3D);
  
  minim = new Minim ( this);
  jingle = minim.loadFile("17 Kiss The Rain_[plixid.com].mp3",2048);
  out = minim.getLineOut();
  jingle.loop();
  jingle.mute();
  fft=new FFT(jingle.bufferSize(),jingle.sampleRate());
  fft.window(FFT.NONE);
  fft.logAverages(4,48);
  
  beat = new BeatDetect();  
}
void draw()
{
  background(0);
  //fft.window(fft.HAMMING);
  fft.forward(jingle.mix);
  beat.detect(jingle.mix);
  beat.setSensitivity(2);
  stroke(0,255,0);
  
  double max=0;
  /*
  for (int i=10;i<40;i++)
  {
    max=max<fft.getBand(i+20)?fft.getBand(i+20):max;
    //stroke(fft.getBand(i+20)*20);
    //line(i*4,200,i*4,200-(log(fft.getBand(i+20)*20)*10));
  }
  */
  
  
  int high=int(map(6000,0,jingle.sampleRate(),0,fft.specSize()));
  int low=int(map(40,0,jingle.sampleRate(),0,fft.specSize()));
  
  ///if ( beat.isOnset() )
  //{
    int imax=0;
    int iA=20;
    boolean found=false;
    for (int i=0;i<fft.avgSize();i++)
    {
      
        if(fft.getAverageCenterFrequency(i)<200) continue;
      //if(fft.getBand(i+20)==max)
      //{
        //stroke(fft.getBand(i+20)*20);
        strokeWeight(1);
        line(map(i,0,fft.avgSize(),0,width),200,map(i,0,fft.avgSize(),0,width),200-2*fft.getAvg(i));
        if(iA<fft.getAvg(i))
        {
          imax=i;
          iA=int(fft.getAvg(i));
          found=true;
        }
      
    }
    //println(iA);    
    if (found)
    {
      stroke(255);
      fill(255);
      String[] n={"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"} ;
      //text(fft.getAverageCenterFrequency(imax),10.0,10.0);
      text(n[abs((round(log(fft.getAverageCenterFrequency(imax)/440)/log(2)*12)+3)%12)],10,10);
      //out.playNote( 0.0, 0.5, new SineInstrument( fft.getAverageCenterFrequency(imax) ) );
      float note = round(log(fft.getAverageCenterFrequency(imax)/440)/log(2)*12);
      if(pow(2, note/12) *440!=lastFreq)
      {
        out.playNote( 0.0, 1, new SineInstrument( pow(2, note/12) *440 ) );
        lastFreq=pow(2, note/12) *440;
      }
      
      ellipseMode(CENTER);
      ellipse(map(imax,0,fft.avgSize(),0,width),200-2*fft.getAvg(imax),20,20);
    }
  //}
  
  
  /*
  fill(0,fft.getBand(30)*70,150);
  rectMode(CENTER);
  rect(width/2,height/2,100,fft.getBand(10)*80);
  fill(fft.getBand(30)*70,0,150);
  rect(width/2,height/2,fft.getBand(10)*100,50);
  */
}

void keyReleased()
{
  WindowFunction newWindow = FFT.NONE;
  
  if ( key == '1' ) 
  {
    newWindow = FFT.BARTLETT;
  }
  else if ( key == '2' )
  {
    newWindow = FFT.BARTLETTHANN;
  }
  else if ( key == '3' )
  {
    newWindow = FFT.BLACKMAN;
  }
  else if ( key == '4' )
  {
    newWindow = FFT.COSINE;
  }
  else if ( key == '5' )
  {
    newWindow = FFT.GAUSS;
  }
  else if ( key == '6' )
  {
    newWindow = FFT.HAMMING;
  }
  else if ( key == '7' )
  {
    newWindow = FFT.HANN;
  }
  else if ( key == '8' )
  {
    newWindow = FFT.LANCZOS;
  }
  else if ( key == '9' )
  {
    newWindow = FFT.TRIANGULAR;
  }

  fft.window( newWindow );
  //windowName = newWindow.toString();
}
