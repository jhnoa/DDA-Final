public class TextDelayed extends Thread
{
  String _text;
  int _mills;
  int currentMill;
  boolean runOnce=true;
  TextDelayed(String text, int mills)
  {
    _text=text;
    _mills=mills;
    currentMill=millis();
  }
  
  public void run()
  {
    
    //if(millis()-currentMill>=_mills)
    //{
      if(runOnce)
      {
        runOnce=false;
        try
        {
          text(_text,width-100,10);
        }
        catch (Exception e){}
      }
    //}
  }
  
}
