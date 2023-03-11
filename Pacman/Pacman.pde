
int WIDTH, HEIGHT;
Input input = new Input();


void setup () {
  size(672, 912);
  WIDTH = width;
  HEIGHT = height;
  input.Init();
  Set();
}

void draw () {
  input.EarlyUpdate();
  Update();
  Display();
  input.LateUpdate();
}

void mousePressed () {
  input.MousePressed();
}

void mouseReleased () {
  input.MouseReleased();
}

void keyPressed () {
  input.KeyPressed();
}

void keyReleased () {
  input.KeyReleased();
}

void mouseWheel (MouseEvent e) {
  input.MouseWheel(e);
}
