World myRobotWorld;  //Set myRobotWorld as object of World
boolean load = true;
int[][] data = new int[23][2];
float[][] data1 = new float[1][2];
void setup() {
  size(720, 720);
  BufferedReader reader = createReader("SaveWorld.txt");
  String line = null;
  int i = 0;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line,",");
      if(i < 22){
      data[i][0] = int(pieces[0]);
      data[i][1] = int(pieces[1]);}
      else{
      data1[0][0] = float(pieces[0]);
      data1[0][1] = float(pieces[1]);}
      i++;
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
  if(i != 24){
    load = false;
  }
  if(load){
    myRobotWorld = new World(data[0][0],data[0][1]);
  }
  else{
    myRobotWorld = new World(12,12);
  }
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
  int row, column, size;     //Set row, column, size as attribute
  float heightPerBlock, widthPerBlock, radian;  //Set height,wieght per block and degree as attribute

  Robot(int row, int column, int size, float widthPerBlock, float heightPerBlock,float radian) {
    this.radian = radian;                //set start degree is 0 radian
    this.row = row;
    this.column = column;
    this.size = size;
    this.widthPerBlock = widthPerBlock;
    this.heightPerBlock = heightPerBlock;
  }

  void move(int args) {    //move method to move row with args
     if (cos(radian) == 1) {
       //print(row);
       row += args;
     } else if (cos(radian) == -1) {
       //print(row);
       row -= args;
     } else if (sin(radian) == 1) {
       //print(column);
       column += args;
     } else if (sin(radian) == -1) {
       //print(column);
       column -= args;
     }
   }

   void turn(int args) {   //turn method to turn column with args
     radian += asin(args);  //calculate new degree
   }

  void drawRobot() {   //draw robot
    fill(255);
    ellipse(widthPerBlock*row + widthPerBlock/2, heightPerBlock*column + heightPerBlock/2, size, size);
    stroke(245);
    strokeWeight(10);
    line(widthPerBlock*row + widthPerBlock/2+cos(radian-PI/3)*size/2, heightPerBlock*column + heightPerBlock/2+sin(radian-PI/3)*size/2,
      widthPerBlock*row + widthPerBlock/2+cos(radian-PI/4)*(size), heightPerBlock*column + heightPerBlock/2+sin(radian-PI/4)*size);
    line(widthPerBlock*row + widthPerBlock/2+cos(radian+PI/3)*size/2, heightPerBlock*column + heightPerBlock/2+sin(radian+PI/3)*size/2,
      widthPerBlock*row + widthPerBlock/2+cos(radian+PI/4)*(size), heightPerBlock*column + heightPerBlock/2+sin(radian+PI/4)*size);
    noStroke();
    fill(0);
    ellipse(widthPerBlock*row + widthPerBlock/2+cos(radian-PI/3)*size/4, heightPerBlock*column + heightPerBlock/2+sin(radian-PI/3)*size/4, size/4, size/4);
    ellipse(widthPerBlock*row + widthPerBlock/2+cos(radian+PI/3)*size/4, heightPerBlock*column + heightPerBlock/2+sin(radian+PI/3)*size/4, size/4, size/4);
  }

  int getRow() {
    return row;
  }

  int getColumn() {
    return column;
  }
  
  float getRadian() {
    return radian;
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
  Robot myRobot;        //set myRobot that is Robot object as attribute
  Objective myObjective;  //set myObject that is Objective object as attribute
  Wall[] myWall;         //set myWall that is Wall[] object as attribute

  World(int row, int column) {
    this.row = row;
    this.column = column;
    heightPerBlock = height/column; //calculate height,width per block
    widthPerBlock = width/row;

    if(load){
      myRobot = new Robot(data[1][0],data[1][1], 40, widthPerBlock, heightPerBlock,data1[0][0]);    //instance myRobot at 1,2 size =40 ,and send width,heigh per block
      myObjective =  new Objective(data[2][0],data[2][0], 40, widthPerBlock, heightPerBlock); //instance myObject at 11,11 size =40 ,and send width,heigh per block
      myWall = new Wall[20];  //Initialization Wall array
      for (int i=3; i<23; i++) {
        myWall[i-3] = new Wall(data[i][0],data[i][1] , 40, widthPerBlock, heightPerBlock); //random wall position
      }
      load = false;
    }
    else{
      myRobot = new Robot(1, 2, 40, widthPerBlock, heightPerBlock,0);    //instance myRobot at 1,2 size =40 ,and send width,heigh per block
      myObjective =  new Objective(11, 11, 40, widthPerBlock, heightPerBlock); //instance myObject at 11,11 size =40 ,and send width,heigh per block
      myWall = new Wall[20];  //Initialization Wall array
    for (int i=0; i<20; i++) {
      myWall[i] = new Wall((int)random(0, 12), (int)(random(0, 11)), 40, widthPerBlock, heightPerBlock); //random wall position
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
    if (key == 'w' || key == 'W') {
      for (int i = 0; i<20; i++) {
        if (cos(myRobot.radian) == 1 && myRobot.getRow()+1 == myWall[i].getRow() && myRobot.getColumn() == myWall[i].getColumn()) {
          break;
        } else if (cos(myRobot.radian) == -1 && myRobot.getRow()-1 == myWall[i].getRow() && myRobot.getColumn() == myWall[i].getColumn()) {
          break;
        } else if (sin(myRobot.radian) == 1 && myRobot.getRow() == myWall[i].getRow() && myRobot.getColumn()+1 == myWall[i].getColumn()) {
          break;
        } else if (sin(myRobot.radian) == -1 && myRobot.getRow() == myWall[i].getRow() && myRobot.getColumn()-1 == myWall[i].getColumn()) {
          break;
        } else if (cos(myRobot.radian) == 1 && myRobot.getRow()+1 == row) {
          break;
        } else if (cos(myRobot.radian) == -1 && myRobot.getRow()-1 < 0) {
          break;
        } else if (sin(myRobot.radian) == 1 && myRobot.getColumn()+1 == column) {
          break;
        } else if (sin(myRobot.radian) == -1 && myRobot.getColumn()-1 < 0) {
          break;
        } else if (i == 19) {
          myRobot.move(1);
        }
      }
    } else if (key == 's' || key == 'S') {
      for (int i = 0; i<20; i++) {
        if (cos(myRobot.radian) == 1 && myRobot.getRow()-1 == myWall[i].getRow() && myRobot.getColumn() == myWall[i].getColumn()) {
          break;
        } else if (cos(myRobot.radian) == -1 && myRobot.getRow()+1 == myWall[i].getRow() && myRobot.getColumn() == myWall[i].getColumn()) {
          break;
        } else if (sin(myRobot.radian) == 1 && myRobot.getRow() == myWall[i].getRow() && myRobot.getColumn()-1 == myWall[i].getColumn()) {
          break;
        } else if (sin(myRobot.radian) == -1 && myRobot.getRow() == myWall[i].getRow() && myRobot.getColumn()+1 == myWall[i].getColumn()) {
          break;
        } else if (cos(myRobot.radian) == 1 && myRobot.getRow()-1 < 0) {
          break;
        } else if (cos(myRobot.radian) == -1 && myRobot.getRow()+1 == row) {
          break;
        } else if (sin(myRobot.radian) == 1 && myRobot.getColumn()-1 < 0) {
          break;
        } else if (sin(myRobot.radian) == -1 && myRobot.getColumn()+1 == column) {
          break;
        } else if (i == 19) {
          myRobot.move(-1);
        }
      }
    } else if (key == 'a' || key == 'A') {
      myRobot.turn(-1);
    } else if (key == 'd' || key == 'D') {
      myRobot.turn(1);
    }
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
    println(myRobot.radian);
    output.println(myRobot.radian+","+0);
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
