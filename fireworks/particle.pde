class Particle {
  PVector position;
  PVector velocity;
  final color c;

  Particle(PVector initPosition, PVector vel, color c) {
    this.position = initPosition;
    this.velocity = vel;
    this.c = c;
  }
  
  Particle(float x, float y, float vx, float vy, color c) {
    this.position = new PVector(x,y);
    this.velocity = new PVector(vx, vy);
    this.c = c;
  }

  void tick(PVector accel, float tickFraction) {
    position.x += velocity.x*tickFraction;
    position.y += velocity.y*tickFraction;

    velocity.x += accel.x*tickFraction;
    velocity.y += accel.y*tickFraction;
  }
  
  boolean inside(int width, int height) {
    return position.x >= 0 && position.x <= width &&
     position.y >= 0 && position.y <= height; 
  }
}
