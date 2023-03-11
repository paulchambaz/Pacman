class Camera {

  PVector cameraTarget;
  float cameraSpeed;
  int cameraMode;
  PVector cameraScreen;
  PVector cameraPos;

  Camera (PVector target, float speed) {
    cameraTarget = target;
    cameraSpeed = speed;
    cameraMode = 0;
    cameraScreen = new PVector(WIDTH/2, HEIGHT/2);
    cameraPos = CameraTarget((target));
  }

  Camera (PVector target) {
    cameraTarget = target;
    cameraSpeed = .3;
    cameraMode = 0;
    cameraScreen = new PVector(WIDTH/2, HEIGHT/2);
    cameraPos = CameraTarget(target);
  }

  Camera (float speed) {
    cameraTarget = null;
    cameraSpeed = speed;
    cameraMode = 0;
    cameraScreen = new PVector(WIDTH/2, HEIGHT/2);
    cameraPos = new PVector();
  }

  Camera () {
    cameraTarget = null;
    cameraSpeed = .3;
    cameraMode = 0;
    cameraScreen = new PVector(WIDTH/2, HEIGHT/2);
    cameraPos = new PVector();
  }

  void SetTarget (PVector target) {
    cameraTarget = target;
  }

  void SetSpeed (float speed) {
    cameraSpeed = speed;
  }

  void SetDynamic () {
    cameraMode = 0;
  }

  void SetStatic () {
    cameraMode = 1;
    cameraPos = new PVector(levelSize * levelWidth / 2, levelSize * levelHeight / 2);
  }

  void SetCorner (float x, float y) {
    cameraMode = 2;
    cameraPos = cameraScreen.copy().add(-x, -y);
  }

  PVector CameraTranslate () {
    return new PVector(-cameraPos.x + cameraScreen.x, -cameraPos.y + cameraScreen.y);
  }

  void CameraMovement () {
    if (cameraMode == 0) {
      cameraPos = PVector.lerp(cameraPos, CameraTarget(cameraTarget), cameraSpeed);
    }
  }

  PVector CameraTarget (PVector in) {
    PVector out = new PVector();
    if (in.x < width/2) {
      out.x = width/2;
    } else if (in.x >= levelWidth * levelSize - width/2) {
      out.x = levelWidth * levelSize - width/2;
    } else {
      out.x = in.x;
    }
    if (in.y < height/2) {
      out.y = height/2;
    } else if (in.y >= levelHeight * levelSize - height/2) {
      out.y = levelHeight * levelSize - height/2;
    } else {
      out.y = in.y;
    }
    return out;
  }
}
