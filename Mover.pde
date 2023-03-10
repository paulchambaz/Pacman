class Mover {
  int type;
  float speed;
  int direction;
  PVector worldPos;
  PVector screenPos;
  int eaten;

  Mover (int t, int x, int y) {
    type = t;
    worldPos = new PVector(x, y);
    screenPos = toWorld(worldPos);
    if (t == 0) {
      direction = 0;
      speed = levelSize / 8;
    } else {
      direction = -1;
      speed = levelSize / 8;
    }
  }

  void SetSpeed (int co) {
    speed = levelSize / co;
  }

  void Eat (Mover prey) {
    if (PVector.sub(screenPos, prey.screenPos).magSq() < sq(levelSize * .5)) {
      prey.eaten = 1;
    }
  }

  void Move () {
    if (PVector.dist(screenPos, toWorld(worldPos)) == 0) {
      if (type == 0 && direction == 0 && (input.IsPressed("d") || input.Pressed("D")) || type != 0 && direction == 0) {
        if (worldPos.x + 1 < levelWidth && !levelCollision[int(worldPos.x + 1)][int(worldPos.y)]) {
          worldPos.x++;
        }
      } else if (type == 0 && direction == 1 && (input.IsPressed("w") || input.Pressed("W")) || type != 0 && direction == 1) {
        if (worldPos.y - 1 >= 0 && !levelCollision[int(worldPos.x)][int(worldPos.y - 1)]) {
          worldPos.y--;
        }
      } else if (type == 0 && direction == 2 && (input.IsPressed("a") || input.Pressed("A")) || type != 0 && direction == 2) {
        if (worldPos.x - 1 >= 0 && !levelCollision[int(worldPos.x - 1)][int(worldPos.y)]) {
          worldPos.x--;
        }
      } else if (type == 0 && direction == 3 && (input.IsPressed("s") || input.Pressed("S")) || type != 0 && direction == 3) {
        if (worldPos.y + 1 < levelHeight && !levelCollision[int(worldPos.x)][int(worldPos.y + 1)]) {
          worldPos.y++;
        }
      }
    }
    if (PVector.dist(screenPos, toWorld(worldPos)) <= speed) {
      if (worldPos.x == 0 && worldPos.y == 13) {
        worldPos.x = 19;
        screenPos = toWorld(new PVector(20, 13));
      } else if (worldPos.x == 20 && worldPos.y == 13) {
        worldPos.x = 1;
        screenPos = toWorld(new PVector(0, 13));
      }
    }
  }

  void Dead () {
    if (eaten == 1) {
      worldPos.x = 10;
      worldPos.y = 20;
      screenPos = toWorld(worldPos);
      blinky.worldPos.x = 10;
      blinky.worldPos.y = 10;
      blinky.screenPos = toWorld(blinky.worldPos);
      inky.worldPos.x = 9;
      inky.worldPos.y = 13;
      inky.screenPos = toWorld(inky.worldPos);
      pinky.worldPos.x = 10;
      pinky.worldPos.y = 13;
      pinky.screenPos = toWorld(pinky.worldPos);
      clyde.worldPos.x = 11;
      clyde.worldPos.y = 13;
      clyde.screenPos = toWorld(clyde.worldPos);
      eaten = 0;
      timerRound = millis();
    }
  }

  void Animate () {
    moveToward(screenPos, toWorld(worldPos), speed);
  }

  void Eat () {
    if (PVector.dist(screenPos, toWorld(worldPos)) <= speed) { 
      if (level[int(worldPos.x)][int(worldPos.y)] == 3) {
        ghostState = 2;
        eatClock = millis();
        blinky.ChangeDirection();
        inky.ChangeDirection();
        pinky.ChangeDirection();
        clyde.ChangeDirection();
      }
      if (level[int(worldPos.x)][int(worldPos.y)] == 2 || level[int(worldPos.x)][int(worldPos.y)] == 3) {
        level[int(worldPos.x)][int(worldPos.y)] = 0;
      }
    }
  }

  void Chase (Mover prey) {
    if (eaten == 1) {
      if (PVector.dist(screenPos, toWorld(worldPos)) == 0) {
        if (worldPos.x == 10 && worldPos.y == 10) {
          eaten = 2;
          direction = 3;
        } else {
          GoTo(new PVector(10, 10));
        }
      }
    } else {
      if (type == 1) {
        // red
        GoTo(prey.worldPos);
      } else if (type == 2) {
        // blue
        PVector preyPos = prey.worldPos;
        int preyDir = prey.direction;
        PVector target = new PVector();
        if (preyDir == 0) {
          target.x = preyPos.x + 4;
          target.y = preyPos.y;
        } else if (preyDir == 1) {
          target.x = preyPos.x;
          target.y = preyPos.y - 4;
        } else if (preyDir == 2) {
          target.x = preyPos.x - 4;
          target.y = preyPos.y;
        } else if (preyDir == 3) {
          target.x = preyPos.x;
          target.y = preyPos.y + 4;
        }
        target.x = 2 * target.x - blinky.worldPos.x;
        target.y = 2 * target.y - blinky.worldPos.y;
        GoTo(target);
      } else if (type == 3) {
        // pink
        PVector preyPos = prey.worldPos;
        int preyDir = prey.direction;
        PVector target = new PVector();
        if (preyDir == 0) {
          target.x = preyPos.x + 4;
          target.y = preyPos.y;
        } else if (preyDir == 1) {
          target.x = preyPos.x;
          target.y = preyPos.y - 4;
        } else if (preyDir == 2) {
          target.x = preyPos.x - 4;
          target.y = preyPos.y;
        } else if (preyDir == 3) {
          target.x = preyPos.x;
          target.y = preyPos.y + 4;
        }
        GoTo(target);
      } else if (type == 4) {
        // orange
        float distSq = PVector.sub(worldPos, prey.worldPos).magSq();
        if (distSq >= sq(8)) {
          GoTo(prey.worldPos);
        } else {
          GoTo(new PVector(1, levelHeight - 2));
        }
      }
    }
  }

  void Scatter () {
    if (eaten == 1) {
      if (PVector.dist(screenPos, toWorld(worldPos)) == 0) {
        if (worldPos.x == 10 && worldPos.y == 10) {
          eaten = 2;
          direction = 3;
        } else {
          GoTo(new PVector(10, 10));
        }
      }
    } else {
      if (type == 1) {
        GoTo(new PVector(levelWidth - 2, 1));
      } else if (type == 2) {
        GoTo(new PVector(levelWidth - 2, levelHeight - 2));
      } else if (type == 3) {
        GoTo(new PVector(1, 1));
      } else if (type == 4) {
        GoTo(new PVector(1, levelHeight - 2));
      }
    }
  }

  void GoTo (PVector goal) {
    if (PVector.dist(screenPos, toWorld(worldPos)) == 0) {
      if (isCage(worldPos)) {
        if (worldPos.x == 9) {
          direction = 0;
        } else if (worldPos.x == 10) {
          direction = 1;
        } else if (worldPos.x == 11) {
          direction = 2;
        }
      } else if (isTurn(worldPos)) {
        // si on vient d'arriver dans un virage
        boolean[] isNeighbour = isNeighbour(worldPos);
        float[] distSq = new float[4];
        distSq[0] = (isNeighbour[0]) ? PVector.sub(goal, new PVector(worldPos.x + 1, worldPos.y)).magSq() : -1;
        distSq[1] = (isNeighbour[1]) ? PVector.sub(goal, new PVector(worldPos.x, worldPos.y - 1)).magSq() : -1;
        distSq[2] = (isNeighbour[2]) ? PVector.sub(goal, new PVector(worldPos.x - 1, worldPos.y)).magSq() : -1;
        distSq[3] = (isNeighbour[3]) ? PVector.sub(goal, new PVector(worldPos.x, worldPos.y + 1)).magSq() : -1;
        if (isNeighbour[0] && distSq[0] == PosMin(distSq, (direction + 2) % 4) && direction != 2) {
          // on part a droite
          direction = 0;
        } else if (isNeighbour[1] && distSq[1] == PosMin(distSq, (direction + 2) % 4) && direction != 3) {
          // on part en haut
          direction = 1;
        } else if (isNeighbour[2] && distSq[2] == PosMin(distSq, (direction + 2) % 4) && direction != 0) {
          // on part a gauche
          direction = 2;
        } else if (isNeighbour[3] && distSq[3] == PosMin(distSq, (direction + 2) % 4) && direction != 1) {
          // on part en bas
          direction = 3;
        }
      }
    }
  }


  void Frightened () {
    if (eaten == 0) {
      if (PVector.dist(screenPos, toWorld(worldPos)) == 0 && isTurn(worldPos)) {
        // si on vient d'arriver dans un virage
        // on choisit une decision au hasard parmis les voisins disponibles 
        boolean[] isNeighbour = isNeighbour(worldPos);
        boolean canMove = (isNeighbour[0] || isNeighbour[1] || isNeighbour[2] || isNeighbour[3]);
        if (canMove) {
          int chosen;
          do {
            chosen = int(random(4));
          } while (!isNeighbour[chosen]); // on relance tant que l'endroit choisi n'est pas accessible
          // enfin on s'y dirige
          direction = chosen;
        }
      }
    } else if (eaten == 1) {
      if (PVector.dist(screenPos, toWorld(worldPos)) == 0) {
        if (worldPos.x == 10 && worldPos.y == 10) {
          eaten = 2;
          direction = 3;
        } else {
          GoTo(new PVector(10, 10));
        }
      }
    }
  }

  void ChangeDirection () {
    direction = (direction + 2) % 4;
  }

  void Control () {
    int playerChosenDirection;
    if (input.Pressed("d") || input.Pressed("D")) {
      playerChosenDirection = 0;
    } else if (input.Pressed("w") || input.Pressed("W")) {
      playerChosenDirection = 1;
    } else if (input.Pressed("a") || input.Pressed("A")) {
      playerChosenDirection = 2;
    } else if (input.Pressed("s") || input.Pressed("S")) {
      playerChosenDirection = 3;
    } else {
      playerChosenDirection = -1;
    }
    if (playerChosenDirection != -1) {
      direction = playerChosenDirection;
    }
  }

  void Display () {
    float radius = 1.1;
    int smoother = 2, cor = 1;
    float eyeRad = levelSize * radius * .3;
    float pupilRad = .6;
    if (type == 0) {
      noStroke();
      fill(247, 247, 0);
      float anim = abs(cos(millis() * .01)) * PI / 3;
      //anim = 0;
      if (direction == 0) {
        arc(screenPos.x, screenPos.y, levelSize * radius, levelSize * radius, anim, 2 * PI - anim, PIE);
      } else if (direction == 1) {
        arc(screenPos.x, screenPos.y, levelSize * radius, levelSize * radius, 3 * PI / 2 + anim, 2 * PI + 3 * PI / 2 - anim, PIE);
      } else if (direction == 2) {
        arc(screenPos.x, screenPos.y, levelSize * radius, levelSize * radius, PI + anim, 3 * PI - anim, PIE);
      } else if (direction == 3) {
        arc(screenPos.x, screenPos.y, levelSize * radius, levelSize * radius, PI / 2 + anim, 2 * PI + PI / 2 - anim, PIE);
      }
    } else if (type == 1) {
      fill(254, 0, 0); // red ghost : blinky
    } else if (type == 2) {
      fill(0, 161, 231); // blue ghost : inky
    } else if (type == 3) {
      fill(255, 171, 203); // pink ghost : pinky
    } else if (type == 4) {
      fill(255, 129, 0); // orange ghost : clyde
    }
    if (type == 1 || type == 2 || type == 3 || type == 4) {
      if (ghostState != 2 && eaten != 1) {
        arc(screenPos.x, screenPos.y, levelSize * radius, levelSize * radius, PI, 2 * PI);
        rect(screenPos.x - levelSize * radius / 2, screenPos.y, levelSize * radius, levelSize * radius / 2 - cor);
        fill(25);
        arc(screenPos.x + levelSize * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 - smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
        arc(screenPos.x + levelSize * 3 * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 - smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
        arc(screenPos.x - levelSize * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 - smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
        arc(screenPos.x - levelSize * 3 * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 -smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
        fill(239, 250, 245);
        ellipse(screenPos.x - eyeRad / 3, screenPos.y - eyeRad / 4, eyeRad, eyeRad * 1.3);
        ellipse(screenPos.x + eyeRad, screenPos.y - eyeRad / 4, eyeRad, eyeRad * 1.3);
        fill(20, 65, 159);
        if (direction == 0 || direction <0) {
          ellipse(screenPos.x - eyeRad / 3 + eyeRad * .3, screenPos.y - eyeRad / 4, eyeRad * pupilRad, eyeRad * pupilRad);
          ellipse(screenPos.x + eyeRad + eyeRad * .3, screenPos.y - eyeRad / 4, eyeRad * pupilRad, eyeRad * pupilRad);
        } else if (direction == 1) {
          ellipse(screenPos.x - eyeRad / 3, screenPos.y - eyeRad / 4 - eyeRad * .4, eyeRad * pupilRad, eyeRad * pupilRad);
          ellipse(screenPos.x + eyeRad, screenPos.y - eyeRad / 4 - eyeRad * .4, eyeRad * pupilRad, eyeRad * pupilRad);
        } else if (direction == 2) {
          ellipse(screenPos.x - eyeRad / 3 - eyeRad * .3, screenPos.y - eyeRad / 4, eyeRad * pupilRad, eyeRad * pupilRad);
          ellipse(screenPos.x + eyeRad - eyeRad * .3, screenPos.y - eyeRad / 4, eyeRad * pupilRad, eyeRad * pupilRad);
        } else if (direction == 3) {
          ellipse(screenPos.x - eyeRad / 3, screenPos.y - eyeRad / 4 + eyeRad * .4, eyeRad * pupilRad, eyeRad * pupilRad);
          ellipse(screenPos.x + eyeRad, screenPos.y - eyeRad / 4 + eyeRad * .4, eyeRad * pupilRad, eyeRad * pupilRad);
        }
      } else if (ghostState == 2 || eaten == 1) {
        if (eaten == 0) {
          fill(33, 31, 247);
          arc(screenPos.x, screenPos.y, levelSize * radius, levelSize * radius, PI, 2 * PI);
          rect(screenPos.x - levelSize * radius / 2, screenPos.y, levelSize * radius, levelSize * radius / 2 - cor);
          arc(screenPos.x + levelSize * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 - smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
          arc(screenPos.x + levelSize * 3 * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 - smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
          arc(screenPos.x - levelSize * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 - smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
          arc(screenPos.x - levelSize * 3 * radius / 8, screenPos.y + levelSize * radius / 2, levelSize * radius / 4 -smoother, levelSize * radius / 4 - smoother, PI, 2 * PI);
        }
        fill(255, 183, 170);
        ellipse(screenPos.x - eyeRad / 3, screenPos.y - eyeRad / 4, eyeRad, eyeRad * 1.3);
        ellipse(screenPos.x + eyeRad, screenPos.y - eyeRad / 4, eyeRad, eyeRad * 1.3);
        rect(screenPos.x - eyeRad / 6, screenPos.y + eyeRad / 2, eyeRad, 2 * eyeRad / 3, eyeRad, eyeRad, eyeRad / 8, eyeRad / 8);
      }
    }
  }
}
