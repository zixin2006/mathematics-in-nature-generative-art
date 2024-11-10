int image_sizex;
int image_sizey;
float rmin=2,rmax=4;
int nbins;
int[] count;
float[] xvals,last_xvals;
Waver waver;
PGraphics pg;

void setup(){
  size(950,600,P2D);
  image_sizex = width-150;
  image_sizey = height;
  nbins = image_sizey;
  count = new int[nbins];
  textFont(createFont("Consolas", 14));
  pg = createGraphics(image_sizex, image_sizey,P2D);
  pg.beginDraw();
  pg.stroke(254,32);
  pg.background(0);
  int i, j;
  int iteration_num = 400;
  float step_size = 0.001;
  float initial_value = 0.1;
  float r = 0;
  float x;
  
  for(j = 0; j < (4.0 / step_size); j++){
    r += step_size;
    x = initial_value;
    for(i = 0; i < iteration_num; i++){
      x = logistic(r, x);
      if(i > 100 && r > rmin){
          pg.point((r-rmin)*image_sizex/(rmax-rmin),image_sizey*(1-(x)));
      }
    } 
  }
  pg.endDraw();
  image(pg,0,0);
  waver = new Waver(100);
}

void draw(){}

void mouseMoved(){
  int i;
  for (i=0;i<nbins;i++) count[i]=0;
  float r=map(mouseX,0,image_sizex,rmin,rmax);
  fill(0); noStroke();
  rect(image_sizex+1,0,image_sizex+150,image_sizey);
  if (mouseX > image_sizex) return;
  stroke(255);
  int iteration_num=400;
  float x=0.1;
  for( i = 0; i < iteration_num; i++){
    x = logistic(r, x);
    if(i > 100 && r > rmin){
      count[floor(x*nbins)]++;
    }
  }
  for (i=0;i<image_sizey;i++){
    if(count[i]>0)
      line(image_sizex+75-min(count[i]/2,74),image_sizey-i,image_sizex+75+min(count[i]/2,74),image_sizey-i);
  }
  int nmax=0;
  for (i=1; i<nbins-1;i++){
    if(count[i]>=count[i-1] && count[i]>count[i+1])
      nmax++;
  } 
  last_xvals=xvals;
  xvals=new float[nmax];
  int[] xcount=new int[nmax];
  
  for(i=0;i<nmax;i++){
      xvals[i]=x;
      x = logistic(r, x);
      xcount[i]=count[floor(x*nbins)];  
  }
  stroke(0);fill(0);
  rect(0,0,220,30);
  stroke(255); fill(255);
  text("r = " + r,2,12);
  text("Nmax : " + nmax,2,24);
  waver.update(xvals,xcount);
}

void keyTyped(){
  if(key==' '){}
}

float logistic(float r, float x){
  return r * x * (1 - x);
}

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

class Waver{
  int nOscils = 20;
  Summer sum;
  Oscil[] oscils;
  IntList freeOscils;
  float[] xvals;
  int[] xosc;
  float fmin=0,fmax=5000;
  
  Waver(int nOscils){
    this.nOscils = nOscils;
    oscils = new Oscil[nOscils];
    freeOscils=new IntList();
    xvals= new float[0];
    minim = new Minim(this);
    out = minim.getLineOut();   
    sum = new Summer();
    sum.patch( out );
    for(int i=0;i<nOscils;i++){
      oscils[i]=new Oscil(440,1,Waves.SINE);
      freeOscils.append(i);
    }
  }
  
  void update(float[] vals, int[] count){
    int i,j;
    if (vals.length>nOscils){
      int[] ocount = reverse(sort(count));
      int thr = ocount[nOscils];
      float[] vals_=new float[nOscils];
      int[] count_ = new int[nOscils];
      for(i = 0,j=0; i<vals.length; i++){
        if(count[i]>thr){
          vals_[j]=vals[i]; count_[j]=count[i]; j++;
        }
      }
      vals=subset(vals_,0,j);
      count=subset(count_,0,j);
    }
    float csum=0.0; for(i=0;i<count.length;i++) csum+=count[i];
    float[] xvols=new float[count.length];
    for(i=0;i<count.length;i++) xvols[i]=float(count[i])/csum;
    int[] xmatch= match(vals,xvals);
    int freev=vals.length-xvals.length;
    int[] special = new int[abs(freev)];
    int[] nxosc = new int[vals.length];
    if(freev==0){
      for(i=0;i<vals.length;i++){
        nxosc[i]=xosc[xmatch[i]];
      }
    } else if(freev>0){
      for(i=0;i<special.length;i++){
        special[i]=freeOscils.remove(0);
      }
      for(i=0,j=0;i<vals.length;i++){
        if(xmatch[i]>=0) nxosc[i]=xosc[xmatch[i]];
        else nxosc[i]=special[j++];
      }
    }else if (freev<0) {
      for(i=0;i<vals.length;i++){
        nxosc[i]=xosc[xmatch[i]];
        xosc[xmatch[i]]=-1;
      }
      for(i=0,j=0;i<xosc.length;i++)
        if(xosc[i]>=0){ 
          special[j++]=xosc[i];
          freeOscils.append(xosc[i]);
        }
    }
    float freq;
    for(i=0;i<vals.length;i++){
      freq=map(vals[i],0,1,0,fmax);
      oscils[nxosc[i]].setFrequency(freq);
      oscils[nxosc[i]].setAmplitude(xvols[i]);
    }
    if(freev>0){
      for(i=0;i<special.length;i++){
        oscils[special[i]].reset();
        oscils[special[i]].patch(sum);
      }
    } else if(freev<0){
      for(i=0;i<special.length;i++){
        oscils[special[i]].unpatch(sum);
      }
    }    
    xosc=nxosc;
    xvals=vals;
  };
  
  int[] match(float[] val1, float[] val2){ 
    int i,j;
    int[] matching=new int[val1.length];
    int[] invmatch=new int[val2.length];
    if(val1.length==0) return new int[0];
    else if(val2.length==0){
      for(i=0;i<val1.length;i++) matching[i]=-1;
      return matching;
    }
    for(i=0;i<val2.length;i++) invmatch[i]=-1;
    float mindiff=1e20,diff;
    for(i=0;i<val1.length;i++){
      mindiff=1e20;
      for(j=0;j<val2.length;j++){
        diff = abs(val1[i]-val2[j]);
        if (diff<mindiff){
          matching[i]=j; mindiff=diff;
        }
      }
      invmatch[matching[i]]=i;
    }
    for (i=0;i<val1.length-1;i++){
      if(matching[i]<0) continue;
      for (j=i+1;j<val1.length;j++){
        if(matching[j]<0) continue;
        if(matching[i]==matching[j]){
          if(abs(val1[i]-val2[matching[i]])<=
            abs(val1[j]-val2[matching[j]])){
              matching[j]=-1;
              invmatch[matching[i]]=i;
          } else {
            matching[i]=-1;
            invmatch[matching[j]]=j;
          }
        }
      }
    }
    int freev1=0,freev2=0,freev;
    for(i=0;i<val1.length;i++) if(matching[i]<0) freev1++;
    for(i=0;i<val2.length;i++) if(invmatch[i]<0) freev2++;
    j=0;
    if(freev1<freev2){
      for(i=0;i<val1.length;i++){
        if(matching[i]>=0) continue;
        while(invmatch[j]>=0) j++;
        matching[i]=j;
        invmatch[j]=i;  
      }
    } else {
       for(i=0;i<val2.length;i++){
        if(invmatch[i]>=0) continue;
        while(matching[j]>=0) j++;
        invmatch[i]=j;
        matching[j]=i;  
      }   
    }
   
