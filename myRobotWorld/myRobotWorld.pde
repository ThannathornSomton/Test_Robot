World myRobotWorld;  //Set myRobotWorld as object of World

void setup() {
  size(720, 720);
  myRobotWorld = new World("SaveWorld.txt");
}

void draw() {
  background(40);  //Draw black background
  noStroke();
  myRobotWorld.drawLine();      //Draw World line
  myRobotWorld.drawWorld();     //Draw all of World
}

void keyReleased(){
  myRobotWorld.updateWorld();
}

class Robot {
  int row, column, size, direction;     //Set row, column, size as attribute
  float heightPerBlock, widthPerBlock;  //Set height,wieght per block and degree as attribute

  Robot(int row, int column, int size, float widthPerBlock, float heightPerBlock, int direction) {
    this.row = row;
    this.column = column;
    this.size = size;
    this.widthPerBlock = widthPerBlock;
    this.heightPerBlock = heightPerBlock;
    this.direction = direction;
  }

  void move() {    //move method to move depend on how it look
     if (direction == 1) {
      //print(row);
      row += 1;
    } else if (direction == 3) {
      //print(row);
      row -= 1;
    } else if (direction == 2) {
      //print(column);
      column += 1;
    } else if (direction == 4) {
      //print(column);
      column -= 1;
    }
  }

  void turnLeft() {
    if (direction == 1){
      direction = 4;
    } else {
      direction -= 1;
    }
  }
  
  void turnRight() {
    if (direction == 4) {
      direction = 1;
    } else {
      direction += 1;
    }
  }

  void drawRobot() {   //draw robot
    stroke(155, 100, 255);
    strokeWeight(2.5);
    if (direction == 1) {
      line(widthPerBlock*row, heightPerBlock*column, widthPerBlock*row + widthPerBlock, heightPerBlock*column + heightPerBlock/2);
      line(widthPerBlock*row, heightPerBlock*column + heightPerBlock, widthPerBlock*row + widthPerBlock, heightPerBlock*column + heightPerBlock/2);
      line(widthPerBlock*row, heightPerBlock*column, widthPerBlock*row, heightPerBlock*column + heightPerBlock);
    } else if (direction == 2) {
      line(widthPerBlock*row, heightPerBlock*column, widthPerBlock*row + widthPerBlock/2, heightPerBlock*column + heightPerBlock);
      line(widthPerBlock*row + widthPerBlock, heightPerBlock*column, widthPerBlock*row + widthPerBlock/2, heightPerBlock*column + heightPerBlock);
      line(widthPerBlock*row, heightPerBlock*column, widthPerBlock*row + widthPerBlock, heightPerBlock*column);
    } else if (direction == 3) {
      line(widthPerBlock*row + widthPerBlock, heightPerBlock*column, widthPerBlock*row, heightPerBlock*column + heightPerBlock/2);
      line(widthPerBlock*row + widthPerBlock, heightPerBlock*column + heightPerBlock, widthPerBlock*row, heightPerBlock*column + heightPerBlock/2);
      line(widthPerBlock*row + widthPerBlock, heightPerBlock*column, widthPerBlock*row + widthPerBlock, heightPerBlock*column + heightPerBlock);
    } else if (direction == 4) {
      line(widthPerBlock*row, heightPerBlock*column + heightPerBlock, widthPerBlock*row + widthPerBlock/2, heightPerBlock*column);
      line(widthPerBlock*row + widthPerBlock, heightPerBlock*column + heightPerBlock, widthPerBlock*row + widthPerBlock/2, heightPerBlock*column);
      line(widthPerBlock*row, heightPerBlock*column + heightPerBlock, widthPerBlock*row + widthPerBlock, heightPerBlock*column + heightPerBlock);
    }
  }

  int getRow() {
    return row;
  }

  int getColumn() {
    return column;
  }
  
  float getDirection() {
    return direction;
  }
}

class Wall {
  int row, column, size;      //Set row, column, size as attribute
  float widthPerBlock, heightPerBlock;  //Set width,height per block as attribute


  Wall(int row, int column, int size, float widthPerBlock, float heightPerBlock) {
    this.row = row;
    this.column = column;
    this.size = size;
    this.widthPerBlock = widthPerBlock;
    this.heightPerBlock = heightPerBlock;
  }

  void drawWall() {
    fill(100, 100, 80);
    rect(widthPerBlock*row+2, heightPerBlock*column+2, widthPerBlock-2, heightPerBlock-2);    //fill the block
  }

  int getRow() {
    return row;
  }

  int getColumn() {
    return column;
  }
}

class Objective {
  int row, column, size; //Set row, column, size as attribute
  float widthPerBlock, heightPerBlock;  //Set width,height per block as attribute

  Objective(int row, int column, int size, float widthPerBlock, float heightPerBlock) {
    this.row = row;
    this.column = column;
    this.size = size;
    this.widthPerBlock = widthPerBlock;
    this.heightPerBlock = heightPerBlock;
  }


  void drawObjective() {
    fill(255, 100, 80); //fill red
    ellipse(widthPerBlock*row + widthPerBlock/2, heightPerBlock*column + heightPerBlock/2, size, size); //draw circle object
  }

  int getRow() {
    return row;
  }

  int getColumn() {
    return column;
  }
}

class World {
  int row, column; //set row, column as attribute
  float widthPerBlock;  //set height,width as attribute
  float heightPerBlock;
  boolean load = true;
  int[][] load_data = new int[24][2];
  char[] Key = new char[3];
  Robot myRobot;        //set myRobot that is Robot object as attribute
  Objective myObjective;  //set myObject that is Objective object as attribute
  Wall[] myWall;         //set myWall that is Wall[] object as attribute
  InputProcessor Input;


  World(int row, int column) {
    this.row = row;
    this.column = column;
    heightPerBlock = height/column; //calculate height,width per block
    widthPerBlock = width/row;
    myRobot = new Robot(1, 2, 40, widthPerBlock, heightPerBlock,1);    //instance myRobot at 1,2 size =40 ,and send width,heigh per block
    myObjective =  new Objective(11, 11, 40, widthPerBlock, heightPerBlock); //instance myObject at 11,11 size =40 ,and send width,heigh per block
    myWall = new Wall[20];  //Initialization Wall array
    for (int i=0; i<20; i++) {
      int x = (int)random(0, 12);
      int y = (int)random(0, 12);
      if (x != myRobot.getRow() && y != myRobot.getColumn() && x != myObjective.getRow() && y != myObjective.getColumn() ) {
        myWall[i] = new Wall(x, y, 40, widthPerBlock, heightPerBlock); //random wall position
      }
      else{
      i--;
      }
    }
    if (Key[0] == 0) {
      Input = new InputProcessor('w', 'a', 'd');
    }else {
      Input = new InputProcessor(Key[0], Key[1], Key[2]);
     }
  }
  
  World(String name){
    BufferedReader reader = createReader(name);
    String line = null;
    int count = 0;
    try {
      while ((line = reader.readLine()) != null) {
        if (count < 24) {
          String[] pieces = split(line,",");
          load_data[count][0] = int(pieces[0]);
          load_data[count][1] = int(pieces[1]);
        } else {
          String[] pieces = split(line,"=");
          Key[count-24] = pieces[1].charAt(0);
        }
        count++;
      }
      reader.close();
    }
    catch (NullPointerException e) {
      e.printStackTrace();
      load = false;
    }
    catch (IOException e) {
      e.printStackTrace();
      load = false;
    }
    if(count != 27){
      load = false;
    }
    
    this.row = load_data[0][0];
    this.column = load_data[0][1];
    heightPerBlock = height/load_data[0][1]; //calculate height,width per block
    widthPerBlock = width/load_data[0][0];
    if(load){
      myRobot = new Robot(load_data[1][0],load_data[1][1], 40, widthPerBlock, heightPerBlock,load_data[23][0]);    //instance myRobot at 1,2 size =40 ,and send width,heigh per block
      myObjective =  new Objective(load_data[2][0],load_data[2][0], 40, widthPerBlock, heightPerBlock); //instance myObject at 11,11 size =40 ,and send width,heigh per block
      myWall = new Wall[20];  //Initialization Wall array
      for (int i=3; i<23; i++) {
        myWall[i-3] = new Wall(load_data[i][0],load_data[i][1] , 40, widthPerBlock, heightPerBlock); //random wall position
      }
      Input = new InputProcessor(Key[0], Key[1], Key[2]);
      load = false;
    }
    else{
      myRobot = new Robot(1, 2, 40, widthPerBlock, heightPerBlock,1);    //instance myRobot at 1,2 size =40 ,and send width,heigh per block
      myObjective =  new Objective(11, 11, 40, widthPerBlock, heightPerBlock); //instance myObject at 11,11 size =40 ,and send width,heigh per block
      myWall = new Wall[20];  //Initialization Wall array
      for (int i=0; i<20; i++) {
        int x = (int)random(0, 12);
        int y = (int)random(0, 12);
        if (x != myRobot.getRow() && y != myRobot.getColumn() && x != myObjective.getRow() && y != myObjective.getColumn() ) {
          myWall[i] = new Wall(x, y, 40, widthPerBlock, heightPerBlock); //random wall position
        }
        else{
        i--;
        }
      }
      if (Key[0] == 0) {
        Input = new InputProcessor('w', 'a', 'd');
      } else {
        Input = new InputProcessor(Key[0], Key[1], Key[2]);
      }
    }
    
    
    
  }

  void drawLine() { //draw line
    fill(255);
    for (int i = 0; i<=row; i++) {
      rect(widthPerBlock*i, 0, 2, height);  //draw horizontal line
    }
    for (int j = 0; j<=column; j++) {
      rect(0, heightPerBlock*j, width, 2);  //draw vertical line
    }
  }

  void drawWorld() {
    for (Wall eachWall : myWall) {
      eachWall.drawWall();        //draw each wall
    }
    myObjective.drawObjective();    //draw objective
    myRobot.drawRobot();     //draw robot
  }

  void updateWorld(){
    Input.checkMove(key, row, column, myRobot, myWall, 20);
    if(targetCheck()){restartGame();}
    saveGame();
  }
  
  void saveGame(){
    PrintWriter output;
    output = createWriter("SaveWorld.txt"); 
    output.println(this.row+","+this.column);
    output.println(myRobot.row+","+myRobot.column);
    output.println(myObjective.row+","+myObjective.column);
    for (Wall eachWall : myWall) {
      output.println(eachWall.row+","+eachWall.column);      
    }
    output.println(myRobot.getDirection()+","+0);
    output.println("Move="+Input.getMoveKey());
    output.println("Turn Left="+Input.getLeftKey());
    output.println("Turn Right="+Input.getRightKey());
    output.flush();
    output.close();
  }
  
  boolean targetCheck(){
    if (myRobot.row == myObjective.row && myRobot.column == myObjective.column){
      return true;
    }
    return false;
  }

  void restartGame(){
    myRobotWorld = new World(12,12);
  }
}

class InputProcessor {
  char moveKey, turnLeftKey, turnRightKey;
  InputProcessor(char move, char turnLeft, char turnRight){
    this.moveKey = move;
    this.turnLeftKey = turnLeft;
    this.turnRightKey = turnRight;
  }
  
  void checkMove(char inputKey, int worldRow, int worldColumn, Robot robot, Wall[] wall, int maxWall){
    if (inputKey == moveKey) {
      for (int i = 0; i<maxWall; i++) {
        if (robot.getDirection() == 1 && robot.getRow()+1 == wall[i].getRow() && robot.getColumn() == wall[i].getColumn()) {
          break;
        } else if (robot.getDirection() == 3 && robot.getRow()-1 == wall[i].getRow() && robot.getColumn() == wall[i].getColumn()) {
          break;
        } else if (robot.getDirection() == 2 && robot.getRow() == wall[i].getRow() && robot.getColumn()+1 == wall[i].getColumn()) {
          break;
        } else if (robot.getDirection() == 4 && robot.getRow() == wall[i].getRow() && robot.getColumn()-1 == wall[i].getColumn()) {
          break;
        } else if (robot.getDirection() == 1 && robot.getRow()+1 == worldRow) {
          break;
        } else if (robot.getDirection() == 3 && robot.getRow()-1 < 0) {
          break;
        } else if (robot.getDirection() == 2 && robot.getColumn()+1 == worldColumn) {
          break;
        } else if (robot.getDirection() == 4 && robot.getColumn()-1 < 0) {
          break;
        } else if (i == 19) {
          robot.move();
        }
      }
    } else if (inputKey == turnLeftKey) {
      robot.turnLeft();
    } else if (inputKey == turnRightKey) {
      robot.turnRight();
    }
  }
  
  char getMoveKey(){
    return moveKey;
  }
  
  char getLeftKey(){
    return turnLeftKey;
  }
  
  char getRightKey(){
    return turnRightKey;
  }
}
