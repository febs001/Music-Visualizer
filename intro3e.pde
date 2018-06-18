/**
  * Shows how to play a file with Minim using an AudioPlayer. <br />
  * It's also a good example of how to draw the waveform of the audio along with creating a 3-D looping of a parametric figure. Full documentation 
  * for AudioPlayer can be found at http://code.compartmental.net/minim/audioplayer_class_audioplayer.html
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.*;

Minim minim;
AudioPlayer player;
static final int NUM_LINES = 100;
float t;//starts at 0 by default
void setup()
{
  size(1200, 700, P3D); //1200 length, 700 width (in pixels) - 3D shape of parametric shape 
  
  //load files from the data directory
  minim = new Minim(this);
  
  // load mp3 file for audio track
  player = minim.loadFile("that.mp3");
  
}

void draw()
{
  background(20);//gray
  stroke(225); //white
  strokeWeight(1);
  translate(width/5, height/2);//image is at the center of the screen
  
    for(int i =0; i <NUM_LINES; i++) // layering effect for shape 
    {
    line(x3(i+ t),y3(i+t), x4(i+t),y4(i+t));
    }
    t+=0.3; //delay time 
  
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is M ONO, left.get() and right.get() will return the same value
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
   
    float x1 = map( i, 0, player.bufferSize(), 0, width ); //line 1
    float x2 = map( i+1, 0, player.bufferSize(), 10  , width ); //line 2 
    float x5 = map( i+2, 0, player.bufferSize(), 30  , width ); //line 3
    float x6 = map( i+3, 0, player.bufferSize(), 60  , width ); //line 4
    float x7 = map( i+4, 0, player.bufferSize(), 90  , width ); //line 5
 
    line( x1, 50 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );//line 1
    line( x1, 20 + player.right.get(i)*50, x2, 20 + player.right.get(i+1)*50 ); //line 2
    line( x1, 80 + player.right.get(i)*50, x2, 70 + player.right.get(i+1)*50 ); //line 3
    line( x1, 110 + player.right.get(i)*50, x2, 70 + player.right.get(i+1)*50 ); //line 4
    line( x1, 150 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 ); //line 5
  }
  
  // draw a line to show where in the song playback is currently located
  float posx = map(player.  position(), 0, player.length(), 0, width);
  stroke(255,0,0); //red line
  line(posx, 0, posx, height);
  
  if ( player.isPlaying() )
  {
    text(" y o u   w i l l   n e v e r  b e  h a p p y  i f   y o u  c o n t i n u e   t o   s e a r c h   f o r   w h a t  h a p p i n e s s   c o n s i s t s   o f  ", 10, 20 );
  }
  else
  {
    text(" y o u   w i l l   n e v e r   l i v e   i f   y o u   a r e   l o o k i n g   f o r  t h e   m e a n i n g   o f   l i f e  ", 10, 20 );
  }
}
 float x3(float t) //change value of t over time
  {
    return sin(t / 10) * 100 + sin(t / 5) * 20; //moves to the right, coefficient outside of sin waves changes the amplitude
  }

  float y3(float t) //precise float integer 
  {
    return cos(-t / 10) * 100 + sin(t/5) * 50; //moves to the left, coefficient within parameter is the frequency 
  }

  float x4(float t) //change value of t over time
  {
    return sin(t / 10) * 200 + sin(t) * 2 * cos(t)* 10; //moves to the right, coefficient outside of sin waves changes the amplitude
  }

  float y4(float t) //precise float integer 
  {
    return -cos(t / 20) * 200 + cos(t / 12) * 20; //moves to the left, coefficient within parameter is the frequency 
  }

void keyPressed() //if key is pressed
{
  if ( player.isPlaying() )
  {
    player.pause(); //pause
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  }
  else
  {
    player.play();
  }
}
