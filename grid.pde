boolean saveOne = false;
color c1 = color(250, 150, 150);
color c2 = color(50, 25, 25);

int noSquares = 25;
int wide = window.innerWidth;
int high = window.innerHeight;

int[] gravities = [2, 4, wide/noSquares];
int clicked = 500;
int count = 0;
int dialX = wide*0.1;
int dialY = high*0.9;
int dialW = wide - 2*dialX;
int dx = dialX + 0.05*dialW;
int sx = 1 - 2*dx/wide;
int ex = dx;
int ey = high*0.05 + dialY;
int uncrumpleX = 20;
int uncrumpleY = 20;
int[] coords = [random(0, wide/2), random(0, high/2), random(wide/2, wide), random(0, high/2), random(0, wide/2), random(high/2, high), random(wide/2, wide), random(high/2, high)];

PVector[][] vertices = new PVector[noSquares + 1][noSquares + 1];

PVector[][] velocities = new PVector[noSquares + 1][noSquares + 1];

PVector[][] uncrumple = new PVector[noSquares + 1][noSquares + 1];

void setup()
{
    size( wide, high, P3D );

    int p = 0;
    int q = 0;
    
    for (int j = 0; j < noSquares + 1; j++) {
        for (int i = 0; i < noSquares + 1; i++) {
            vertices[i][j] = new PVector( i*gravities[2] + p, j*gravities[2] + q, 0 );
            uncrumple[i][j] = new PVector( i*gravities[2], j*gravities[2], 0 );
            velocities[i][j] = new PVector(0, 0, 0);
        }
    }
    
}

void attractTo(int cox, int coy, int coz, int factor){
    for (int j = 0; j < noSquares + 1; j++) {
        for (int i = 0; i < noSquares + 1; i++) {
            int a = (cox - vertices[i][j].x);
            int b = (coy - vertices[i][j].y);
            int d = (coz - vertices[i][j].z);
            float c = sqrt(pow(a, 2) + pow(b, 2) + pow(d, 2));
            float sinthet = 0.005*a/c;
            float costhet = 0.005*b/c;
            float zthet = 0.005*d/c;
    
            velocities[i][j] = new PVector(velocities[i][j].x + factor*sinthet, velocities[i][j].y + factor*costhet, velocities[i][j].z + factor*zthet);
        }
    }
}

void draw()
{
    gravities = [0.0005*pow(2.5, (clicked - wide/2)/100), 0.0001*clicked*clicked, high/noSquares];

    background(c1);
    lights();
    fill(250, 50, 50, 100);
    hint(DISABLE_DEPTH_TEST);
    stroke(c2, 0);
    strokeWeight(2);
    smooth();
    
    int factor = random(gravities[0]/2, gravities[0]);
    attractTo(wide/2, high/2, 0, factor);
    
    int factor = random(gravities[1]/2, gravities[1]);
    attractTo(coords[2], coords[3], 3, factor);
    
    int factor = random(gravities[1]/2, gravities[1]);
    attractTo(coords[4], coords[5], 3, factor);
    
    int factor = random(gravities[1]/2, gravities[1]);
    attractTo(coords[6], coords[7], 3, factor);
    
    int factor = random(gravities[1]/2, gravities[1]);
    attractTo(coords[0], coords[1], 3, factor);
    
    for (int j = 0; j < noSquares + 1; j++) {
        for (int i = 0; i < noSquares + 1; i++) {
            vertices[i][j] = new PVector(vertices[i][j].x + velocities[i][j].x, vertices[i][j].y + velocities[i][j].y, vertices[i][j].z + velocities[i][j].z );
            
            uncrumpleX = vertices[0][0].x + uncrumple[i][j].x - vertices[i][j].x;
            uncrumpleY = vertices[0][0].y + uncrumple[i][j].y - vertices[i][j].y;
            
            vertices[i][j] = new PVector(vertices[i][j].x + uncrumpleX*0.0005, vertices[i][j].y + uncrumpleY*0.0005, vertices[i][j].z);
        }
    }
    
    for (int j = 0; j < noSquares; j ++) {
        beginShape(TRIANGLE_STRIP);
        for (int i = 0; i < noSquares + 1; i++) {
            vertex( vertices[i][j].x, vertices[i][j].y  , vertices[i][j].z );
            vertex( vertices[i][j+1].x, vertices[i][j+1].y, vertices[i][j+1].z );
        }
        endShape();
    }

    popMatrix();

    if (saveOne) {
        saveFrame("images/"+getClass().getSimpleName()+"-####.png");
        saveOne = false;
    }
    dial();
}

void mousePressed() {
    if (mouseX <= dx || mouseX >= wide - dx || mouseY <= ey - 0.01*wide || mouseY >= ey + 0.01*wide){
    ex = sx*mouseX + dx;
    clicked = mouseX + 500;
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX + 500;
    clicked = clicked*sx;
    if(mouseX <= dx){
      ex = dx;
    } else if(mouseX >= wide - dx){
      ex = wide - dx;
    }
  }
}

void mouseDragged() {
  if (mouseX <= dx || mouseX >= wide - dx || mouseY <= ey - 0.01*wide || mouseY >= ey + 0.01*wide){
    ex = sx*mouseX + dx;
    clicked = mouseX + 500;
  }
  if(mouseY >= ey - 0.01*wide && mouseY <= ey + 0.01*wide){
    ex = mouseX;
    clicked = mouseX + 500;
    clicked = clicked*sx;
    if(mouseX <= dx){
      ex = dx;
    } else if(mouseX >= wide - dx){
      ex = wide - dx;
    }
  }
}

void dial(){
  noFill();
  stroke(0);
  strokeWeight(1);
  rect(dialX, dialY + high*0.03, wide - 2*dialX, high*0.04);
  noStroke();
  fill(c2);
  ellipse(ex, ey, 0.01*wide, 0.01*wide);
}

void keyPressed()
{
    if (key == 's') {
        saveOne = true;
    }
}