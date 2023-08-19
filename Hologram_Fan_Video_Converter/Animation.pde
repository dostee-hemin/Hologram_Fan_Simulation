PVector[] balls = new PVector[10];

void setupAnimation() {
    for(int i=0; i<balls.length; i++) {
        balls[i] = new PVector(random((width-maxDiameter)/2, (width+maxDiameter)/2), -random(100,height));
    }
}

void playAnimation() {
    for(int i=0; i<balls.length; i++) {
        PVector b = balls[i];

        b.y += 6;

        if(b.y > height+30) {
            balls[i] = new PVector(random((width-maxDiameter)/2, (width+maxDiameter)/2), 0);
        }


        stroke(0);
        strokeWeight(map(i, 0, balls.length, 30, 100));
        point(b.x, b.y);
    }
    
}