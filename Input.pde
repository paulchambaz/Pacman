class Input {

  // code by Paul Chambaz - June 2020

  int inputNbMouses = 3, inputNbCtrls = 26, inputNbCodes = 3, inputNbKeys = 99;

  char[] inputValue = {LEFT, RIGHT, CENTER, 
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 
    17, 16, 18, 
    9, 27, 10, 8, 127, 
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 
    65, 66, 67, 69, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 
    91, 92, 93, 94, 95, 96, 
    123, 124, 125};
  boolean[] inputIsPressed = new boolean[inputNbMouses + inputNbCtrls + inputNbCodes + inputNbKeys];
  boolean[] inputWasPressed = new boolean[inputNbMouses + inputNbCtrls + inputNbCodes + inputNbKeys];

  int inputMouseWheel = 0;

  PVector inputMousePos, inputPMousePos, inputMouseVel, inputMousePosOnPress;

  void Init () {
    inputMousePos = new PVector();
    inputPMousePos = new PVector();
    inputMouseVel = new PVector();
    inputMousePosOnPress = new PVector();
  }

  int Search (String name) {
    // "mouse_lrc" // "ctrl_"+letter in min //"ctrl", "shift", "alt", "tab", "esc", "enter", back", "del" // letter and special chars
    if (name.length() == 7 && name.substring(0, 6).equals("mouse_")) {
      if (name.charAt(6) == 'l') {
        return 0;
      } else if (name.charAt(6) == 'r') {
        return 1;
      } else if (name.charAt(6) == 'c') {
        return 2;
      }
    }
    if (name.length() == 6 && name.substring(0, 5).equals("ctrl_")) { 
      for (int i=3; i<29; i++) {
        if (name.charAt(5) == char(i + 'a' - 3)) {
          return i;
        }
      }
    }
    if (name == "ctrl") {
      return 29;
    } else if (name == "shift") {
      return 30;
    } else if (name == "alt") {
      return 31;
    } else if (name == "tab") {
      return 32;
    } else if (name == "esc") {
      return 33;
    } else if (name == "enter") {
      return 34;
    } else if (name == "back") {
      return 35;
    } else if (name == "del") {
      return 36;
    }
    if (name.length() == 1) {
      for (int i=37; i<63; i++) {
        if (name.charAt(0) == char(i + 'a' - 37)) {
          return i;
        }
      }
      for (int i=63; i<89; i++) {
        if (name.charAt(0) == char(i + 'A' - 63)) {
          return i;
        }
      }
      for (int i=89; i<122; i++) {
        if (name.charAt(0) == char(i + ' ' - 89)) {
          return i;
        }
      }
      for (int i=122; i<128; i++) {
        if (name.charAt(0) == char(i + '[' - 122)) {
          return i;
        }
      }
      for (int i=128; i<131; i++) {
        if (name.charAt(0) == char(i + '{' - 128)) {
          return i;
        }
      }
    }
    return -1;
  }

  void Reset () {
    // resets the input
    for (int i=0; i<inputIsPressed.length; i++) {
      inputIsPressed[i] = false;
      inputWasPressed[i] = false;
    }
  }

  int Length () {
    // returns the total number of inputs
    return inputValue.length;
  }

  PVector Mouse () {
    return inputMousePos.copy();
  }

  PVector MouseVel () {
    return inputMouseVel.copy();
  }

  PVector MousePress () {
    return inputMousePosOnPress.copy();
  }

  int MouseWheel () {
    return inputMouseWheel;
  }


  boolean IsPressed (String name) {
    // return if an input is pressed by name
    int i = Search(name);
    if (i != -1) {
      return inputIsPressed[i];
    } else {
      println("Error : \"" + name + "\" is not a valid input.");
      return false;
    }
  }

  boolean WasPressed (String name) {
    // return if an input was pressed by name
    int i = Search(name);
    if (i != -1) {
      return inputWasPressed[i];
    } else {
      println("Error : \"" + name + "\" is not a valid input.");
      return false;
    }
  }

  boolean Pressed (String name) {
    // return if an input was just pressed by name
    int i = Search(name);
    if (i != -1) {
      return (inputIsPressed[i] && !inputWasPressed[i]);
    } else {
      println("Error : \"" + name + "\" is not a valid input.");
      return false;
    }
  }

  boolean Released (String name) {
    // return if an input was just released by name
    int i = Search(name);
    if (i != -1) {
      return (!inputIsPressed[i] && inputWasPressed[i]);
    } else {
      println("Error : \"" + name + "\" is not a valid input.");
      return false;
    }
  }

  void Reset (String name) {
    // resets an input by name
    int i = Search(name);
    if (i != -1) {
      inputIsPressed[i] = false;
      inputWasPressed[i] = false;
      return;
    }
  }

  int Index (String name) {
    // returns the index of an input by name
    return Search(name);
  }

  boolean IsPressed (int index) {
    // return if an input is pressed by index
    return inputIsPressed[index];
  }

  boolean WasPressed (int index) {
    // returns if an input was pressed by index
    return inputWasPressed[index];
  }

  boolean Pressed (int index) {
    // returns if an input was just pressed by index
    return (inputIsPressed[index] && !inputWasPressed[index]);
  }

  boolean Released (int index) {
    // returns if an input was just released by index
    return (!inputIsPressed[index] && inputWasPressed[index]);
  }

  void Reset (int index) {
    // resets an input by index
    inputIsPressed[index] = false;
    inputWasPressed[index] = false;
    return;
  }

  boolean Ctrl () {
    // returns if ctrl is pressed
    // 29 is the index of the ctrl key
    return inputIsPressed[29];
  }

  void EarlyUpdate () {
    UpdateMouse();
  }

  void UpdateMouse () {
    // update the mouse position
    inputMousePos.x = constrain(mouseX, 0, WIDTH);
    inputMousePos.y = constrain(mouseY, 0, HEIGHT);
    inputMouseVel = PVector.sub(inputMousePos, inputPMousePos);
  }

  void LateUpdate () {
    LateUpdateInput();
    LateUpdateMouse();
  }

  void LateUpdateInput () {
    // updates all input (wasPressed becomes isPressed)
    for (int i=0; i<inputWasPressed.length; i++) {
      inputWasPressed[i] = inputIsPressed[i];
    }
  }

  void LateUpdateMouse () {
    // updates the mouse
    inputPMousePos = inputMousePos.copy();
  }

  void MousePressed () {
    // updates all relevant inputs on mousePressed
    UpdateMouseOnPressed();
    UpdateMousePosOnPressed();
  }

  void MouseReleased () {
    // updates all relevant inputs on mouseRelease
    UpdateMouseOnReleased();
  }

  void KeyPressed () {
    // updates all relevant inputs on keyPressed
    UpdateKeysOnPressed();
    UpdateCodeOnPressed();
    UpdateCtrlOnPressed();
    InputNoEsc();
  }

  void KeyReleased () {
    // updates all relevant inputs on keyReleased
    UpdateKeysOnReleased();
    UpdateCodeOnReleased();
    UpdateCtrlOnReleased();
  }

  void MouseWheel (MouseEvent e) {
    // updates all relevant inputs on mouseWheel
    UpdateMouseWheel(e);
  }

  void UpdateMouseWheel(MouseEvent e) {
    // updates the mouseWheel
    inputMouseWheel = -e.getCount();
  }

  void UpdateMousePosOnPressed () {
    // updates the mousePress on press
    inputMousePosOnPress.x = constrain(mouseX, 0, WIDTH);
    inputMousePosOnPress.y = constrain(mouseY, 0, HEIGHT);
  }

  void UpdateMouseOnPressed () {
    // updates all mouse inputs on press
    int start = 0;
    for (int i=start; i<start + inputNbMouses; i++) {
      if (inputValue[i] == mouseButton) {
        inputIsPressed[i] = true;
      }
    }
  }

  void UpdateMouseOnReleased () {
    // updates all mouse inputs on release
    int start = 0;
    for (int i=start; i<start + inputNbMouses; i++) {
      if (inputValue[i] == mouseButton) {
        inputIsPressed[i] = false;
      }
    }
  }

  void UpdateCtrlOnPressed () {
    // updates all ctrl inputs on press
    int start = inputNbMouses;
    for (int i=start; i<start + inputNbCtrls; i++) {
      if (inputValue[i] == key && Ctrl()) {
        inputIsPressed[i] = true;
      }
    }
  }

  void UpdateCtrlOnReleased () {
    // updates all ctrl inputs on release
    int start = inputNbMouses;
    for (int i=start; i<start + inputNbCtrls; i++) {
      if (inputValue[i] == key && Ctrl()) {
        inputIsPressed[i] = false;
      }
    }
  }

  void UpdateCodeOnPressed () {
    // updates all code inputs on press
    if (key == CODED) {
      int start = inputNbMouses + inputNbCtrls;
      for (int i=start; i<start + inputNbCodes; i++) {
        if (inputValue[i] == keyCode) {
          inputIsPressed[i] = true;
        }
      }
    }
  }

  void UpdateCodeOnReleased () {
    // updates all code inputs on release
    if (key == CODED) {
      int start = inputNbMouses + inputNbCtrls;
      for (int i=start; i<start + inputNbCodes; i++) {
        if (inputValue[i] == keyCode) {
          inputIsPressed[i] = false;
        }
      }
    }
  }

  void UpdateKeysOnPressed () {
    // updates all key inputs on press
    if (key != CODED) {
      int start = inputNbMouses + inputNbCtrls + inputNbCodes;
      for (int i=start; i<start + inputNbKeys; i++) {
        if (inputValue[i] == key) {
          inputIsPressed[i] = true;
        }
      }
    }
  }

  void UpdateKeysOnReleased () {
    // updates all key inputs on release
    if (key != CODED) {
      int start = inputNbMouses + inputNbCtrls + inputNbCodes;
      for (int i=start; i<start + inputNbKeys; i++) {
        if (inputValue[i] == key) {
          inputIsPressed[i] = false;
        }
      }
    }
  }

  void InputNoEsc () {
    // prevents application shutton down on accidental press
    if (key == 27) {
      key = 0;
    }
  }
}
