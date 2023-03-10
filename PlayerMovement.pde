 //<>// //<>// //<>//
int levelWidth = 21, levelHeight = 27;
int levelSize = 32;
int[][] level;
boolean[][] levelCollision;

Mover pacman;

Mover blinky;
Mover inky;
Mover pinky;
Mover clyde;

int timerRound;

Camera camera;

int ghostState;
int clock;
int eatClock;

void Set () {
  level = createLevel();
  levelCollision = createLevelCollision(level);
  pacman = new Mover(0, 10, 20);
  
  blinky = new Mover(1, 10, 10);
  inky = new Mover(2, 9, 13);
  pinky = new Mover(3, 10, 13);
  clyde = new Mover(4, 11, 13);
  
  camera = new Camera();
  camera.SetCorner(0, levelSize * 1.5);
  ghostState = 0;
  clock = millis();
  timerRound = millis();
}

void Update () {
  if (!hasWon(level)) {
    camera.CameraMovement();
    GhostMovement();
    PlayerMovement();
  } else {
  }
}

void Display () {
  if (!hasWon(level)) {
    background(25);
    pushMatrix();
    PVector cameraTranslate = camera.CameraTranslate();
    translate(cameraTranslate.x, cameraTranslate.y);

    float frustum = 2;
    int xOffset = int(WIDTH / (2 * levelSize)), yOffset = int(HEIGHT / (2 * levelSize));
    noStroke();
    for (int i = int(max(0, pacman.worldPos.x - xOffset * frustum)); i < int(min(levelWidth, pacman.worldPos.x + 2 + xOffset * frustum)); i++) {
      for (int j = int(max(0, pacman.worldPos.y - yOffset * frustum)); j < int(min(levelHeight, pacman.worldPos.y + 2 + yOffset * frustum)); j++) {
        if (level[i][j] == 1) {
          fill(10, 77, 149);
          DrawMap(i, j);
        } else if (level[i][j] == 2) {
          fill(231, 145, 66);
          ellipse(i * levelSize + levelSize/2, j * levelSize + levelSize/2, levelSize * .2, levelSize * .2);
        } else if (level[i][j] == 3) {
          fill(231, 145, 66);
          ellipse(i * levelSize + levelSize/2, j * levelSize + levelSize/2, levelSize * .5, levelSize * .5);
        }
      }
    }
    blinky.Display();
    inky.Display();
    pinky.Display();
    clyde.Display();
    pacman.Display();
    popMatrix();
  } else {
    background(25);
  }
}

void DrawMap (int x, int y) {
  // levelSize
  float border = .3;
  if (y - 1 >= 0 && level[x][y - 1] == 1) {
    rect(x * levelSize + border * levelSize, y * levelSize, (1 - 2 * border) * levelSize, border * levelSize + 1);
  }
  if (x - 1 >= 0 && level[x - 1][y] == 1) {
    rect(x * levelSize, y * levelSize + border * levelSize, border * levelSize + 1, (1 - 2 * border) * levelSize);
  }
  if (y + 1 < levelHeight && level[x][y + 1] == 1) {
    rect(x * levelSize + border * levelSize, y * levelSize + (1 - border) * levelSize - 1, (1 - 2 * border) * levelSize, border * levelSize + 1);
  }
  if (x + 1 < levelWidth && level[x + 1][y] == 1) {
    rect(x * levelSize + (1 - border) * levelSize - 1, y * levelSize + border * levelSize, border * levelSize + 1, (1 - 2 * border) * levelSize);
  }
  boolean ul, ur, br, bl;
  ul = ((x - 1 < 0 || level[max(x - 1, 0)][y] != 1) && (y - 1 < 0 || level[x][max(y - 1, 0)] != 1) && (x - 1 < 0 || y - 1 < 0 || level[max(x - 1, 0)][max(y - 1, 0)] != 1));
  ur = ((x + 1 >= levelWidth || level[min(x + 1, levelWidth - 1)][y] != 1) && (y - 1 < 0 || level[x][max(y - 1, 0)] != 1) && (x + 1 >= levelWidth || y - 1 < 0 || level[min(x + 1, levelWidth - 1)][max(y - 1, 0)] != 1));
  br = ((x + 1 >= levelWidth || level[min(x + 1, levelWidth - 1)][y] != 1) && (y + 1 >= levelHeight || level[x][min(y + 1, levelHeight - 1)] != 1) && (x + 1 >= levelWidth || y + 1 >= levelHeight || level[min(x + 1, levelWidth - 1)][min(y + 1, levelHeight - 1)] != 1));
  bl = ((x - 1 < 0 || level[max(x - 1, 0)][y] != 1) && (y + 1 >= levelHeight || level[x][min(y + 1, levelHeight - 1)] != 1) && (x - 1 < 0 || y + 1 >= levelHeight || level[max(x - 1, 0)][min(y + 1, levelHeight - 1)] != 1));
  rect(x * levelSize + border * levelSize, y * levelSize + border * levelSize, (1 - 2 * border) * levelSize, (1 - 2 * border) * levelSize, (ul) ? (1 - 2 * border) * levelSize : 0, (ur) ? (1 - 2 * border) * levelSize : 0, (br) ? (1 - 2 * border) * levelSize : 0, (bl) ? (1 - 2 * border) * levelSize : 0);
}

void PlayerMovement () {
  pacman.Eat();
  pacman.Animate();
  pacman.Move();
  pacman.Control();
}

void Timer () {  
  float time = (millis() - clock) / 1000.;
  if (ghostState != 2) {
    if (time > 84) {
      ghostState = 1;
    } else if (time > 79) {
      ghostState = 0;
    } else if (time > 59) {
      ghostState = 1;
    } else if (time > 54) {
      ghostState = 0;
    } else if (time > 34) {
      ghostState = 1;
    } else if (time > 27) {
      ghostState = 0;
    } else if (time > 7) {
      ghostState = 1;
    }
  }
}

void GhostMovement () {
  float timeRound = (millis() - timerRound) / 1000.;

  blinky.Animate();
  pinky.Animate();
  inky.Animate();
  clyde.Animate();

  if (ghostState == 0) {
    blinky.Scatter();
    pinky.Scatter();
    inky.Scatter();
    clyde.Scatter();

    blinky.Eat(pacman);
    pinky.Eat(pacman);
    inky.Eat(pacman);
    clyde.Eat(pacman);
  } else if (ghostState == 1) {
    blinky.Chase(pacman);
    pinky.Chase(pacman);
    inky.Chase(pacman);
    clyde.Chase(pacman);

    blinky.Eat(pacman);
    pinky.Eat(pacman);
    inky.Eat(pacman);
    clyde.Eat(pacman);
  } else if (ghostState == 2) {
    pacman.Eat(blinky);
    pacman.Eat(pinky);
    pacman.Eat(inky);
    pacman.Eat(clyde);

    blinky.Frightened();
    pinky.Frightened();
    inky.Frightened();
    clyde.Frightened();
  }

  pacman.Dead();

  if (millis() - eatClock > 7000) {
    ghostState = 0;
    if (blinky.eaten == 2) blinky.eaten = 0;
    if (inky.eaten == 2) inky.eaten = 0;
    if (pinky.eaten == 2) pinky.eaten = 0;
    if (clyde.eaten == 2) clyde.eaten = 0;
  }

  if (ghostState != 2) {
    Timer();
  }

  blinky.Move();
  pinky.Move();
  if (timeRound > 2) {
    inky.Move();
  }
  if (timeRound > 5) {
    clyde.Move();
  }
}

int[][] createLevel () {
  int[][] tmp = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
    {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1}, 
    {1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1}, 
    {1, 3, 1, 0, 1, 2, 1, 0, 1, 2, 1, 2, 1, 0, 1, 2, 1, 0, 1, 3, 1}, 
    {1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1}, 
    {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1}, 
    {1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1}, 
    {1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1}, 
    {1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 1}, 
    {1, 1, 1, 1, 1, 2, 1, 1, 1, 0, 1, 0, 1, 1, 1, 2, 1, 1, 1, 1, 1}, 
    {0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 1, 2, 1, 0, 1, 1, 0, 1, 1, 0, 1, 2, 1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1, 2, 1, 0, 1, 0, 0, 0, 1, 0, 1, 2, 1, 1, 1, 1, 1}, 
    {0, 0, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1, 2, 1, 0, 1, 1, 1, 1, 1, 0, 1, 2, 1, 1, 1, 1, 1}, 
    {0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 1, 2, 1, 0, 1, 1, 1, 1, 1, 0, 1, 2, 1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1, 2, 1, 0, 1, 1, 1, 1, 1, 0, 1, 2, 1, 1, 1, 1, 1}, 
    {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1}, 
    {1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1}, 
    {1, 3, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 3, 1}, 
    {1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1}, 
    {1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1}, 
    {1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 1}, 
    {1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1}, 
    {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1}, 
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  };
  int[][] out = new int[tmp[0].length][tmp.length];
  for (int i=0; i<out.length; i++) {
    for (int j=0; j<out[i].length; j++) {
      out[i][j] = tmp[j][i];
    }
  }
  return out;
}

boolean[][] createLevelCollision (int[][] in) {
  if (in == null || in.length == 0) return null;
  boolean[][] out = new boolean[in.length][in[0].length];
  for (int i=0; i < out.length; i++) {
    for (int j=0; j < out[i].length; j++) {
      if (in[i][j] == 1) {
        out[i][j] = true;
      }
    }
  }
  return out;
}

boolean hasWon (int[][] in) {
  boolean out = true; 
  for (int i=0; i<in.length; i++) {
    for (int j=0; j<in[i].length; j++) {
      if (in[i][j] == 2 || in[i][j] == 3) {
        out = false;
      }
    }
  }
  return out;
}

boolean isFree (PVector in) {
  return (in.x >= 0 && in.x < levelWidth && in.y >= 0 && in.y < levelHeight && !levelCollision[int(in.x)][int(in.y)]);
}

boolean isFree (float x, float y) {
  return (x >= 0 && x < levelWidth && y >= 0 && y < levelHeight && !levelCollision[int(x)][int(y)]);
}

boolean isCage (PVector in) {
  return (in.x == 10 && in.y == 11 || in.x == 9 && in.y == 12 || in.x == 10 && in.y == 12 || in.x == 11 && in.y == 12 || in.x == 9 && in.y == 13 || in.x == 10 && in.y == 13 || in.x == 11 && in.y == 13);
}

boolean isCage (float x, float y) {
  return (x == 10 && y == 11 || x == 9 && y == 12 || x == 10 && y == 12 || x == 11 && y == 12 || x == 9 && y == 13 || x == 10 && y == 13 || x == 11 && y == 13);
}

boolean isTurn (PVector in) {
  boolean lb = (isFree(in.x - 1, in.y) && isFree(in.x, in.y + 1));
  boolean lu = (isFree(in.x - 1, in.y) && isFree(in.x, in.y - 1));
  boolean rb = (isFree(in.x + 1, in.y) && isFree(in.x, in.y + 1));
  boolean ru = (isFree(in.x + 1, in.y) && isFree(in.x, in.y - 1));
  return (lb || lu || rb || ru);
}

boolean[] isNeighbour (PVector in) {
  boolean[] out = new boolean[4];
  out[0] = (!isCage(in.x + 1, in.y) && isFree(in.x + 1, in.y));
  out[1] = (!isCage(in.x, in.y - 1) && isFree(in.x, in.y - 1));
  out[2] = (!isCage(in.x - 1, in.y) && isFree(in.x - 1, in.y));
  out[3] = (!isCage(in.x, in.y + 1) && isFree(in.x, in.y + 1));
  return out;
}

float PosMin (float[] in) {
  if (in == null || in.length == 0) return -1;
  float out = 100000000;
  for (int i=0; i<in.length; i++) {
    if (in[i] != -1 && in[i] < out) {
      out = in[i];
    }
  }
  return out;
}

float PosMin (float[] in, float ex) {
  if (ex == 0) {
    return PosMin(in[1], in[2], in[3]);
  } else if (ex == 1) {
    return PosMin(in[0], in[2], in[3]);
  } else if (ex == 2) {
    return PosMin(in[0], in[1], in[3]);
  } else if (ex == 3) {
    return PosMin(in[0], in[1], in[2]);
  } else {
    return PosMin(in);
  }
}

float PosMin (float a, float b, float c) {
  float[] tmp = {a, b, c};
  return PosMin(tmp);
}

PVector toWorld (PVector in) {
  return in.copy().add(.5, .5).mult(levelSize);
}

void moveToward (PVector pos, PVector goal, float speed) {
  PVector dir = PVector.sub(goal, pos);
  float mag = dir.mag();
  if (mag < speed) {
    // on est suffisement proche du point
    pos.x = goal.x;
    pos.y = goal.y;
  } else {
    pos.x += speed * dir.x / mag;
    pos.y += speed * dir.y / mag;
  }
}
