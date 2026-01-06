ArrayList<ToyPart> parts;
ArrayList<Gift> gifts = new ArrayList<Gift>();
ArrayList<Confetti> confettiList = new ArrayList<Confetti>();
int score = 0;
int misses = 0;
int spawnTimer = 0;
int spawnInterval = 180;
int giftSpawnTimer = 0;
int giftSpawnInterval = 120;
PFont font;
float armOffset1 = 0;
float armOffset2 = 0;
float armSpeed = 0.2; 
int numLights = 12;
float[] lightBrightness;

float santaX = 50;
float santaY;
float santaSpeed = 1.5;
boolean santaMovingRight = true;

int gameState = 0;

Snowflake[] snowflakes;

void setup() {
  size(800, 400);
  parts = new ArrayList<ToyPart>();
  font = createFont("Georgia", 22);
  textFont(font);

  lightBrightness = new float[numLights];
  for (int i = 0; i < numLights; i++) {
    lightBrightness[i] = random(150, 255);
  }

  santaY = height/2 + 65; 

  snowflakes = new Snowflake[100];
  for (int i = 0; i < 50; i++) {
    snowflakes[i] = new Snowflake(random(100, 240), random(60, 160));
  }
  for (int i = 50; i < 100; i++) {
    snowflakes[i] = new Snowflake(random(560, 700), random(60, 160));
  }
}

void draw() {
  if (gameState == 0) {
    drawStartScreen();
  } else if (gameState == 1) {
    runGame();
  }
}

void runGame() {
  drawWorkshopBackground();
  drawBanners();
  drawTools();
  drawCandyCanes();
  drawWindows();
  drawLanterns();
  drawFloor();
  drawConveyor();
  drawWorkshopLights();
  drawElvesWorking();
  drawSanta();

  spawnTimer++;
  if (spawnTimer > spawnInterval) {
    parts.add(new ToyPart());
    spawnTimer = 0;
    if (spawnInterval > 60) spawnInterval -= 2;
  }

  for (int i = parts.size()-1; i >= 0; i--) {
    ToyPart p = parts.get(i);
    p.update();
    p.display();
    if (p.x > width) {
      parts.remove(i);
      misses++;
    }
  }

  giftSpawnTimer++;
  if (giftSpawnTimer > giftSpawnInterval) {
    gifts.add(new Gift(0, height/2 + 5));
    giftSpawnTimer = 0;
  }

  for (int i = gifts.size()-1; i >= 0; i--) {
    Gift g = gifts.get(i);
    g.update();
    g.display();
    if (g.x > width) gifts.remove(i);
  }

  for (int i = confettiList.size()-1; i >= 0; i--) {
    Confetti c = confettiList.get(i);
    c.update();
    c.display();
    if (c.y < 0) confettiList.remove(i);
  }

  drawHUD();

  armOffset1 = 10 * sin(frameCount * armSpeed);
  armOffset2 = 10 * sin(frameCount * armSpeed + PI);

  updateSanta();
  drawSparkles();
}

void keyPressed() {
  if (gameState == 0) {
    gameState = 1;
    return;
  }
  
  if (parts.size() > 0) {
    ToyPart p = parts.get(0);
    if (Character.toUpperCase(key) == p.sequence[p.progress]) {
      p.progress++;
      if (p.progress >= p.sequence.length) {
        score++;
        for (int i = 0; i < 15; i++) {
          confettiList.add(new Confetti(p.x + 22, p.y + 17));
        }
        parts.remove(0);
      }
    } else {
      misses++;
      parts.remove(0);
    }
  }
}

void drawStartScreen() {
  background(30, 20, 50);
  fill(255, 220, 0);
  textAlign(CENTER);
  textSize(48);
  text("🎄 Festive Workshop Tycoon 🎄", width/2, height/2 - 60);
  
  textSize(22);
  fill(255);
  text("Help the elves build toys!\nPress the keys shown on the toys to complete them.\nPress any key to start!", width/2, height/2 + 20);
  
  drawBanners();
  drawCandyCanes();
  drawLanterns();
}

void drawWorkshopBackground() {
  background(80, 45, 20);
  for (int y = 0; y < height; y += 40) {
    fill(100, 60, 30);
    rect(0, y, width, 40);
    fill(120, 75, 40);
    rect(0, y + 38, width, 2);
  }
  fill(70, 40, 20);
  for (int x = 0; x < width; x += 80) rect(x, 0, 20, height);
}

void drawBanners() {
  stroke(0);
  strokeWeight(2);
  for (int i = 0; i < width; i += 60) {
    line(i, 10, i + 30, 40);
    fill(i % 120 == 0 ? color(255,0,0) : color(0,255,0));
    triangle(i + 25, 40, i + 35, 40, i + 30, 25);
  }
  noStroke();
}

void drawTools() {
  fill(150);
  rect(50, 100, 5, 25); 
  fill(100);
  rect(45, 95, 15, 10); 

  fill(180);
  rect(700, 110, 5, 25); 
  ellipse(702, 110, 15, 10); 

  fill(255, 0, 0);
  ellipse(400, 80, 20, 10);
  fill(0, 255, 0);
  ellipse(430, 80, 20, 10);
}

void drawCandyCanes() {
  stroke(255,0,0);
  strokeWeight(6);
  line(20, height/2 + 50, 20, height/2 + 100);
  noStroke();
  fill(255);
  arc(20, height/2 + 50, 20, 20, PI, TWO_PI);

  stroke(255,0,0);
  strokeWeight(6);
  line(width-40, height/2 + 50, width-40, height/2 + 100);
  noStroke();
  fill(255);
  arc(width-40, height/2 + 50, 20, 20, PI, TWO_PI);
}

void drawWindows() {
  fill(30, 60, 120);
  rect(100, 60, 140, 100, 10);
  rect(560, 60, 140, 100, 10);

  for (int i = 0; i < snowflakes.length; i++) {
    snowflakes[i].update();
    snowflakes[i].display();
  }
}

void drawLanterns() {
  fill(160, 120, 60);
  ellipse(200, 40, 40, 40);
  ellipse(600, 40, 40, 40);
  fill(255, 240, 180);
  ellipse(200, 40, 25, 25);
  ellipse(600, 40, 25, 25);
}

void drawFloor() {
  fill(90, 50, 20);
  rect(0, height/2 + 30, width, height/2 - 30);
}

void drawConveyor() {
  for (int i = 0; i < width; i += 40) {
    if (i % 80 == 0) fill(255, 0, 0);
    else fill(255);
    rect(i, height/2, 40, 30);
  }
}

void drawWorkshopLights() {
  for (int i = 0; i < numLights; i++) {
    float x = i * (width / numLights) + 20;
    float y = 20;
    
    if (frameCount % 5 == 0) {  // slower flicker
      lightBrightness[i] += random(-1, 1);
      lightBrightness[i] = constrain(lightBrightness[i], 150, 255);
    }
    
    fill(255, random(200, 255), 0, lightBrightness[i]);
    ellipse(x, y, 20, 20);
  }
}

void drawElvesWorking() {
  drawElf(130, height/2 + 25, armOffset1);
  drawElf(230, height/2 + 25, -armOffset1);
  drawElf(580, height/2 + 25, armOffset2);
  drawElf(680, height/2 + 25, -armOffset2);
}

void drawElf(float x, float y, float armOffset) {
  fill(0, 150, 0);
  rect(x, y - 20, 20, 35);
  fill(255, 220, 180);
  ellipse(x + 10, y - 30, 22, 22);
  fill(255, 0, 0);
  triangle(x, y - 40, x + 20, y - 40, x + 10, y - 55);

  fill(0);
  float eyeHeight = frameCount % 60 < 5 ? 1 : 3;
  ellipse(x + 7, y - 33, 3, eyeHeight);
  ellipse(x + 13, y - 33, 3, eyeHeight);

  fill(255, 180, 180);
  ellipse(x + 10, y - 27, 6, 3);

  stroke(0);
  strokeWeight(3);
  line(x - 5 + armOffset, y - 10, x - 15 + armOffset, y + 10);
  line(x + 15 + armOffset, y - 10, x + 25 + armOffset, y + 10);
  noStroke();
}

void drawSanta() {
  fill(255, 0, 0);
  rect(santaX, santaY - 35, 25, 35); 
  fill(255, 220, 180);
  ellipse(santaX + 12.5, santaY - 45, 22, 22); 
  fill(255);
  rect(santaX, santaY - 50, 25, 10); 
  fill(255, 0, 0);
  triangle(santaX, santaY - 50, santaX + 25, santaY - 50, santaX + 12.5, santaY - 65); 
  fill(0);
  ellipse(santaX + 8, santaY - 47, 3, 3); 
  ellipse(santaX + 17, santaY - 47, 3, 3);
}

void updateSanta() {
  if (santaMovingRight) {
    santaX += santaSpeed;
    if (santaX > width - 25) santaMovingRight = false;
  } else {
    santaX -= santaSpeed;
    if (santaX < 0) santaMovingRight = true;
  }
}

void drawHUD() {
  fill(255, 230, 200);
  textAlign(CENTER);
  textSize(22);
  String hudText = "🎁 Toys Built: " + score + "   ❌ Misses: " + misses;
  text(hudText, width / 2, height - 20);
}

void drawSparkles() {
  for (int i = 0; i < 15; i++) {
    float x = random(width);
    float y = random(height/2 - 20, height/2 + 50);
    fill(255, 255, 200, random(100, 255));
    ellipse(x, y, 3, 3);
  }
}

class ToyPart {
  float x;
  float y;
  float speed;
  char[] sequence;
  int progress;
  color wrapColor;

  ToyPart() {
    x = 0;
    y = height/2 - 15;
    speed = random(2, 4);
    int len = int(random(2, 5));
    sequence = new char[len];
    char[] possible = {'A','S','D','F'};
    for (int i = 0; i < len; i++) {
      sequence[i] = possible[int(random(possible.length))];
    }
    progress = 0;
    wrapColor = color(random(100,255), random(50,200), random(50,200));
  }

  void update() {
    x += speed;
  }

  void display() {
    fill(wrapColor);
    rect(x, y, 45, 35, 6);
    
    fill(255, 255, 0);
    rect(x + 18, y, 8, 35);
    rect(x, y + 14, 45, 8);
    
    fill(255);
    textSize(18);
    textAlign(CENTER);
    text(joinSequence(), x + 22, y - 10);
  }

  String joinSequence() {
    String s = "";
    for (int i = 0; i < sequence.length; i++) {
      if (i == progress) s += "[" + sequence[i] + "] ";
      else s += sequence[i] + " ";
    }
    return s;
  }
}

class Gift {
  float x, y;
  float speed;
  color giftColor;
  
  Gift(float startX, float startY) {
    x = startX;
    y = startY;
    speed = random(1.5, 3);
    giftColor = color(random(100,255), random(50,200), random(50,200));
  }
  
  void update() {
    x += speed;
  }
  
  void display() {
    fill(giftColor);
    rect(x, y, 20, 20, 4);
    fill(255, 0, 0);
    rect(x+8, y, 4, 20);
    rect(x, y+8, 20, 4);
  }
}

class Confetti {
  float x, y;
  float speedY;
  color col;
  
  Confetti(float startX, float startY) {
    x = startX;
    y = startY;
    speedY = random(-3, -1);
    col = color(random(255), random(255), random(255));
  }
  
  void update() {
    y += speedY;
  }
  
  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, 5, 5);
  }
}

class Snowflake {
  float x, y;
  float speed;
  
  Snowflake(float startX, float startY) {
    x = startX;
    y = startY;
    speed = random(0.1, 0.3);
  }
  
  void update() {
    y += speed;
    if (y > 160) y = 60;
  }
  
  void display() {
    fill(255);
    noStroke();
    ellipse(x, y, 3, 3);
  }
}
