final PVector GRAVITY = new PVector(0, -.9802655);
final int fps = 24;
final int width = 1000, height = 800;
final float timeScale = 1;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(width, height);
  background(0);
  frameRate(fps);   

  spray();
}

void spray() {
  for (int i=0; i < 10; i++) {
    float xvel = random(30)-20;    
    color c = color(random(255), random(255), random(255));
    float yvel = random(10)+25;
    
    Particle p = new Particle(width/2, 0, xvel, yvel, c);
    particles.add(p);
  } 
}

void shatter(Particle p) {
  // Shatter a particle up some number of smaller pieces,
  // assigning random velocity to the shards, but conserving momentum.
  int shardLimit = 2;
  float lossFactor = 0.90;
  PVector totalMomentum = new PVector(p.mass*p.velocity.x*lossFactor,
        p.mass*p.velocity.y*lossFactor);
  int shards = 0;
  float massRemaining = p.mass;
  while (totalMomentum.x > 0 && totalMomentum.y > 0 && shards < shardLimit) {
    float shardMass = random(massRemaining/2.0) + massRemaining/2.0;
    float shardMomentumY = totalMomentum.x * (shardMass/p.mass);
    float shardMomentumX = totalMomentum.y * (shardMass/p.mass);
    
    //print(moment, shardMomentumX, shardMomentumY);
    //print("\n");
    Particle shard = new Particle(p.position.x, p.position.y, 
       shardMomentumX/shardMass, shardMomentumY/shardMass, p.c);
    shard.mass = shardMass;
    shard.generation = p.generation + 1;
    particles.add(shard);
    totalMomentum.x -= shardMomentumX;
    totalMomentum.y -= shardMomentumY;
    shards++;
    massRemaining -= shardMass;
  }
  
  if (shards < shardLimit - 1) {
    float shardMass = massRemaining;
    Particle shard = new Particle(p.position.x, p.position.y,
      totalMomentum.x/shardMass, totalMomentum.y/shardMass, p.c);
    shard.mass = shardMass; 
    shard.generation = p.generation + 1;
    particles.add(shard);
  }
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
    
    // Sometimes a particle will explode.
    if (p.generation <= 3 && p.position.y >= 150 && random(1) <= 0.1) {
      shatter(p);
    }
    
    stroke(p.c);
    fill(p.c);
    float x,y;
    for(int t=0; t<timeScale*fps; t++) {
      x = p.position.x;
      y = p.position.y;
      p.tick(GRAVITY, (float)1/(fps*timeScale));
      line(x, height-y, p.position.x, height-p.position.y);
    }
    
    float radius = p.mass * 8.0;
    ellipse(p.position.x, height-p.position.y, radius, radius);
  }
  
  if (frameCount % 100 == 0) {
    spray();
  }
}
