planet[] celestial = new planet[101];//single array needed for the assignment
//I moved the classes to the top, hopefully it helps you?
class planet { //base class
  float cx, cy, cvelx, cvely, caccelx, caccely, csiz, crot;
  int ccol1, ccol2;
  planet() {
    cx = (float)(Math.random()*1000);
    cy = (float)(Math.random()*1000);
    while (distance(cx, cy, 500, 500) < 150 || distance(cx, cy, 500, 500) > 450) {
      cx = (float)(Math.random()*1000);
      cy = (float)(Math.random()*1000);
    }
    if (Math.random()<0.5) {
      cvelx = -(float)((500-cy)/distance(cx, cy, 500, 500)*distance(cx, cy, 500, 500)/50);
      cvely = (float)((500-cx)/distance(cx, cy, 500, 500)*distance(cx, cy, 500, 500)/50);
    } else {
      cvelx = (float)((500-cy)/distance(cx, cy, 500, 500)*distance(cx, cy, 500, 500)/50);
      cvely = -(float)((500-cx)/distance(cx, cy, 500, 500)*distance(cx, cy, 500, 500)/50);
    }
    caccelx = 0;
    caccely = 0;
    csiz = (float)(Math.random()*15+15);
    crot = (float)(Math.random()*TWO_PI);
    ccol1 = color((int)(255), (int)(255), (int)(Math.random()*100+155));
    ccol2 = color((int)(Math.random()*150+105), (int)(Math.random()*150+105), (int)(Math.random()*150+105));
  }
  void move() {
    cx += cvelx/2;
    cy += cvely/2;
    cvelx += caccelx;
    cvely += caccely;
    crot += 0.02;
  }
  void gravity() {
    caccelx = 0.1*(celestial[0].cx-cx)/(Math.abs(celestial[0].cx-cx));
    caccely = 0.1*(celestial[0].cy-cy)/(Math.abs(celestial[0].cy-cy));
    if (distance(cx, cy, 500, 500)>500) {
      cx += (celestial[0].cx-cx)/(Math.abs(celestial[0].cx-cx));
      cy += (celestial[0].cy-cy)/(Math.abs(celestial[0].cy-cy));
    }
  }
  void collide() {
    for (int i = 1; i < celestial.length; i++) {
      if (distance(cx, cy, celestial[i].cx, celestial[i].cy) < (csiz + celestial[i].csiz)/2+10 && distance(cx, cy, celestial[i].cx, celestial[i].cy) != 0) {
        while (distance(cx, cy, celestial[i].cx, celestial[i].cy) < (csiz + celestial[i].csiz)/2+10) {
          cx -= (celestial[i].cx - cx)/(Math.abs(celestial[i].cx - cx));
          cy -= (celestial[i].cy - cy)/(Math.abs(celestial[i].cy - cy));
        }
        caccelx = 0;
        caccely = 0;
        cvelx *= 0.95;
        cvely *= 0.95;
      }
    }
  }
  void count() {
    count++;
  }
  void show() {
    translate(cx, cy);
    rotate(crot);
    noStroke();
    fill(ccol2);
    arc(0, 0, csiz*1.5, csiz*0.75, PI-0.05, TWO_PI+0.05);
    fill(ccol1);
    ellipse(0, 0, csiz, csiz);
    fill(ccol2);
    arc(0, 0, csiz*1.5, csiz*0.75, -0.05, PI+0.05);
    fill(ccol1);
    arc(0, -(csiz*+0.1), csiz, csiz*0.5, -0.05, PI+0.05);
    rotate(-crot);
    translate(-cx, -cy);
  }
}
class sun extends planet { //oddball class
  float cdir, cvel;
  int t;
  sun() {
    cx = 500;
    cy = 500;
    csiz = 45;
    crot = (float)(Math.random()*TWO_PI);
    ccol1 = color(255, 255, 0);
    ccol2 = color(255, 127, 0);
    cdir = (float)(Math.random()*TWO_PI);
    caccelx = 0;
    caccely = 0;
    t = 0;
  }
  void move() {
    cx += Math.cos(cdir)*cvel;
    cy += Math.sin(cdir)*cvel;
    cdir += 0.01;
    crot += 0.01;
    if (cvel < 0.5) {
      cvel += 0.005;
    }
  }
  void gravity() {
    caccelx = 0.05*(500-cx)/(Math.abs(500-cx));
    caccely = 0.05*(500-cy)/(Math.abs(500-cy));
  }
  void collide() {
    for (int i = 1; i < celestial.length; i++) {
      if (distance(cx, cy, celestial[i].cx, celestial[i].cy) < (csiz + celestial[i].csiz)/2) {
        csiz += celestial[i].csiz/50.0;
        celestial[i] = new destroyed();
      }
    }
  }
  void count() {
  }
  void show() {
    t++;
    translate(cx, cy);
    rotate(crot);
    noStroke();
    fill(ccol2);
    for (int i = 0; i < 8; i++) {
      rotate(TWO_PI/8);
      beginShape();
      curveVertex(0, 0);
      curveVertex(0, 0);
      curveVertex(-0.25*csiz, -0.5*csiz);
      curveVertex((float)(Math.sin(t/10.0)*10), -csiz);
      curveVertex((float)(Math.sin(t/10.0)*10), -csiz);
      curveVertex(0.25*csiz, -0.5*csiz);
      curveVertex(0, 0);
      curveVertex(0, 0);
      endShape();
    }
    fill(ccol1);
    ellipse(0, 0, csiz, csiz);
    rotate(-crot);
    translate(-cx, -cy);
  }
}
class destroyed extends planet { //technically an extended class, just used to remove
  destroyed() {
    cx = 99999;
    cy = 99999;
  }
  void show() {
  }
  void move() {
  }
  void collide() {
  }
  void gravity() {
  }
  void count() {
  }
}
/*
---------------------------------------------------------------------------------------------------
 code below:
 - global variables
 - setup/draw
 - text function (and related variables/functions)
 - collision toggle
 */
float[] stars = new float [3000];//just background details, unrelated to the celestial objects
boolean coltrue = false;
int time = 0;
int counter = 0;
float distance(float x1, float y1, float x2, float y2) {
  return(float)(Math.sqrt(Math.pow(x1-x2, 2)+ Math.pow(y1-y2, 2)));
}

void setup() {
  size(1000, 1000);
  for (int i = 0; i < celestial.length; i++) {
    celestial[i] = new planet();
  }
  celestial[0] = new sun();
  for (int i = 0; i < stars.length-3; i+=3) {
    stars[i] = (float)(Math.random()*1000);
    stars[i+1] = (float)(Math.random()*1000);
    stars[i+2] = (float)(Math.random()*TWO_PI*10);
  }
}

void draw() {
  background(0, 0, 0);
  noStroke();
  for (int i = 0; i < stars.length-3; i+=3) {
    fill(255, 255, 0, (float)(Math.sin(stars[i+2]/10.0)*50+50));
    ellipse(stars[i], stars[i+1], 5, 5);
    stars[i+2] += 0.5;
  }
  counter = 0;
  for (int i = 0; i < celestial.length; i++) {
    celestial[i].move();
    celestial[i].gravity();
    if (coltrue == true) {
      celestial[i].collide();
    }
    celestial[i].show();
    celestial[i].count();
  }
  fontText("click to toggle", 500, 800+15*sin(time/20.0), 20, 30, color(255, 0, 0), "CENTER", "digital");
  fontText("collisions", 500, 850+15*sin(time/20.0), 20, 30, color(255, 0, 0), "CENTER", "digital");
  time++;
  fontText("planets " + counter, 10, 20, 10, 20, color(255, 0, 0), "LEFT", "digital");
  fontText("collisions " + coltrue, 990, 20, 10, 20, color(255, 0, 0), "RIGHT", "digital");
}
//text function(s) start:
public char[] a0z25 = {' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
public int[] digiFont = {0, 14240, 14256, 12432, 11376, 12944, 12928, 12720, 6048, 2112, 1072, 4741, 4240, 15520, 5289, 13488, 14208, 13489, 14209, 13104, 10304, 5296, 4230, 5360, 15, 14, 8214, 1060, 10128, 9520, 5920, 13104, 13232, 8198, 14256, 14128, 13494};
public int nthFromTheEndNum(int n, int num) {
  return (int)(num/Math.pow(10, n-1))%10;
}
public int[] nToBinary(int num) {
  int[] ans;
  int tempI = 0;
  int tempNum = num;
  while (Math.pow(2, tempI) <= num) {
    tempI++;
  }
  ans = new int[tempI];
  for (int i = 0; i < ans.length; i++) {
    if (tempNum >= Math.pow(2, ans.length-1-i)) {
      ans[i] = 1;
      tempNum -= Math.pow(2, ans.length-1-i);
    } else {
      ans[i] = 0;
    }
  }
  return ans;
}
public void fontText(String s, float x, float y, float w, float h, int c, String a, String f) {
  float tempX = x;
  if (a == "LEFT") {
    tempX = x+w/2;
  } else if (a == "CENTER") {
    tempX = x - ((s.length()-1)*w*1.5)/2;
  } else if (a == "RIGHT") {
    tempX = x - ((s.length())*w*1.5-w);
  }
  stroke(c);
  if (w > h) {
    strokeWeight(h/5);
  } else {
    strokeWeight(w/5);
  }
  for (int i = 0; i < s.length(); i++) {
    letter(s.charAt(i), tempX, y, w, h, f);
    tempX += w*1.5;
  }
}
public void letter(char c, float x, float  y, float w, float h, String f) {
  int tempN = 0;
  for (int k = 0; k < a0z25.length; k++) {
    if (c == a0z25[k]) {
      tempN = k;
    }
  }
  if (f == "digital") {
    for (int j = 0; j < nToBinary(digiFont[tempN]).length; j++) {
      if (nToBinary(digiFont[tempN])[nToBinary(digiFont[tempN]).length-1-j] == 1) {
        if (j == 0) {
          line(x+w/2, y+h/2, x, y);
        }
        if (j == 1) {
          line(x-w/2, y+h/2, x, y);
        }
        if (j == 2) {
          line(x+w/2, y-h/2, x, y);
        }
        if (j == 3) {
          line(x-w/2, y-h/2, x, y);
        }
        if (j == 4) {
          line(x-w/2, y+h/2, x+w/2, y+h/2);
        }
        if (j == 5) {
          line(x+w/2, y, x+w/2, y+h/2);
        }
        if (j == 6) {
          line(x, y, x, y+h/2);
        }
        if (j == 7) {
          line(x-w/2, y, x-w/2, y+h/2);
        }
        if (j == 8) {
          line(x, y, x+w/2, y);
        }
        if (j == 9) {
          line(x-w/2, y, x, y);
        }
        if (j == 10) {
          line(x+w/2, y-h/2, x+w/2, y);
        }
        if (j == 11) {
          line(x, y-h/2, x, y);
        }
        if (j == 12) {
          line(x-w/2, y-h/2, x-w/2, y);
        }
        if (j == 13) {
          line(x-w/2, y-h/2, x+w/2, y-h/2);
        }
      }
    }
  }
}
//text function(s) end
void mousePressed() {
  coltrue = !coltrue;
}
