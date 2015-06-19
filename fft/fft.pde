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
  jingle = minim.loadFile("17 Kiss The Rain_[plixid.com].mp3",4096);
  out = minim.getLineOut();
  jingle.loop();
  //jingle.mute();
  fft=new FFT(jingle.bufferSize(),jingle.sampleRate());
  fft.window(FFT.NONE);
  fft.logAverages(100,12);
  
  beat = new BeatDetect();  
  background(0);
}
void draw()
{
  fill(0,20);
  rect(0,0,width,height);
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
    int iA=14;
    boolean found=false;
    int req;
    req=5; //notes to show
    for (int i=fft.avgSize()-1;i>=0;i--)
    {
      if(req==0)
      {
        break;
      }
        //if(fft.getAverageCenterFrequency(i)<500) continue;
      //if(fft.getBand(i+20)==max)
      //{
        //stroke(fft.getBand(i+20)*20);
        strokeWeight(1);
        line(map(i,0,fft.avgSize(),0,width),200,map(i,0,fft.avgSize(),0,width),200-2*fft.getAvg(i));
        if(fft.getAvg(i)>12)
        {
          imax=i;
          iA=int(fft.getAvg(i));
          
          
          stroke(255);
          fill(255);
          String[] n={"A","Bb","B","C","C#","D","D#","E","F","F#","G","Ab"} ;
          //text(fft.getAverageCenterFrequency(imax),10.0,10.0);
          
          //out.playNote( 0.0, 0.5, new SineInstrument( fft.getAverageCenterFrequency(imax) ) );
          float note = round(log(fft.getAverageCenterFrequency(imax)/440)/log(2)*12);
          
          if(abs(pow(2, note/12) *440)-lastFreq>70)
          {
            //out.playNote( 0.0, 0.4, new SineInstrument( pow(2, note/12) *440 ) );
            //lastFreq=pow(2, note/12) *440;
          int index = int(note)%12;
          while (index < 0) {index = index +12;}
          println(fft.getAverageCenterFrequency(imax),n[index]);
          text(n[index],map(imax,0,fft.avgSize(),0,width),40+(imax%12)*10);
          ellipseMode(CENTER);
          ellipse(map(imax,0,fft.avgSize(),0,width),200-2*fft.getAvg(imax),20,20);
          req--;
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
}
