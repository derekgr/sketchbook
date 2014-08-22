final PVector GRAVITY = new PVector(0, -9.802655);
final int fps = 24;
final int width = 1024, height = 768;
final float timeScale = 150.0;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(width, height);
  background(0);
  frameRate(fps);   

  particles.add(new Particle(50, 0, 20, 50, #ff0000));
  particles.add(new Particle(600, 0, -10, 82, #00ff00));
}

void draw() {
  background(0);
  
  for(int i=0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    if (!p.inside(width, height)) {
      particles.remove(i);
      i--;
      
      continue;
    }
    
    stroke(p.c);
    float x,y;
    for(int t=0; t<timeScale*fps; t++) {
      x = p.position.x;
      y = p.position.y;
      p.tick(GRAVITY, (float)1/(fps*timeScale));
      line(x, height-y, p.position.x, height-p.position.y);
    }
  }
}
