
int Ball_stu;//玉の状態
int Ball_num=3;//残りの玉
float Ball_X[]=new float[3],Ball_Y[]=new float[3];//ボールのxとy座標
float Ball_XS,Ball_YS;//ボールのxとy方向の速度

float Bar_X;//バーの位置

/////////////////////////////////
int time=0;
int time2=0;
float Ball_x[]=new float[250];
float Ball_y[]=new float[250];
///////////////////////////////////

int blockBound=0;//ブロックに当たる回数
int block[][]={{0,0,0,0,0,0,0,0,0,0},
               {0,0,0,0,0,0,0,0,0,0},
               {0,2,2,2,2,2,2,2,2,0},
               {0,2,2,2,2,2,2,2,2,0},
               {0,2,2,2,2,2,2,2,2,0},
               {0,2,2,2,2,2,2,2,2,0},
               {0,0,0,0,0,0,0,0,0,0}};
               
void setup(){
  size(360,480);
 for(int i=0;i<block.length;i++){
    for(int j=0;j<block[i].length;j++){
      blockBound+=block[i][j];
    }
 }
  
}

void draw(){
  background(0);
  
  //メニュー表示
  fill(255); 
  text("BALL " + Ball_num, 40, 20);
  //text("SPEED " + abs(Ball_YS), 40, 30);
  
  
  //ブロックの表示////////////////////////////////////
  rectMode(CORNER);
  for(int i=0;i<block.length;i++){
    for(int j=0;j<block[i].length;j++){
      if(block[i][j]==1)fill(255,255,255);
      if(block[i][j]==2)fill(255,200,200);
      if(block[i][j]==3)fill(255,100,100);
      if(block[i][j]==4)fill(255,0,0);
      if(block[i][j]!=0){
        rect(36*j+1,20*i+1,34,18);
      }
      
    }
  }
  fill(255);
  
  
  
  
  //バーの表示////////////////////////////////////
  Bar_X=mouseX;
  if(Bar_X-40<0)Bar_X=40;
  if(width<Bar_X+40)Bar_X=width-40;
  rectMode(CENTER);
  rect(Bar_X,400,80,10);
  
  
  
  //ボールの動き////////////////////////////////////////
  //ボールの状態
  switch(Ball_stu){
    case 0://バーにくっついている状態
      Ball_X[0]=Bar_X;
      Ball_Y[0]=390;
      break;
      
    case 1://バーから離れている状態
      for(int i=Ball_X.length-1;i>=1;i--){
        Ball_X[i]=Ball_X[i-1];
      }
      //ボールを動かす
      Ball_X[0]+=Ball_XS;
      Ball_Y[0]+=Ball_YS;
      
      if(Ball_X[0]<=0||width<=Ball_X[0]){//画面横端に当たった時
        Ball_XS*=-1;
      }
      if(Ball_Y[0]<=0){//画面上に当たった時
        Ball_YS*=-1;
      }
      
      //ブロックに当たった時
      //跳ね返る方向にブロックがないか
      //次進む方向がブロックに当たらないかどうか
      for(int i=0;i<block.length;i++){
        for(int j=0;j<block[i].length;j++){
          if(block[i][j]!=0){
            if(36*j<=Ball_X[0]&&Ball_X[0]<=36*j+36
              &&20*i<=Ball_Y[0]&&Ball_Y[0]<=20*i+20){
              //下からブロックに当たった時
              if(Ball_YS<0&&(i==block.length-1||block[i+1][j]==0)&&(
              Ball_X[0]+Ball_XS<36*j||36*j+36<Ball_X[0]+Ball_XS||
              Ball_Y[0]-Ball_YS<20*i||20*i+20<Ball_Y[0]-Ball_YS)){
                Ball_YS*=-1;
                block[i][j]-=1;
                println("bottom "+time+"["+(time-time2)+"] "+i+" "+j);
                time2=time;
              }
              //上からブロックに当たった時
              else if(Ball_YS>0&&(i==0||block[i-1][j]==0)&&(
              Ball_X[0]+Ball_XS<36*j||36*j+36<Ball_X[0]+Ball_XS||
              Ball_Y[0]-Ball_YS<20*i||20*i+20<Ball_Y[0]-Ball_YS)){
                Ball_YS*=-1;
                block[i][j]-=1;
                println("top "+time+"["+(time-time2)+"] "+i+" "+j);
                time2=time;
              }
              //右からブロックに当たった時
              else if(Ball_XS<0&&j!=block[i].length-1&&block[i][j+1]==0&&(
              Ball_X[0]-Ball_XS<36*j||36*j+36<Ball_X[0]-Ball_XS||
              Ball_Y[0]+Ball_YS<20*i||20*i+20<Ball_Y[0]+Ball_YS)){
                Ball_XS*=-1;
                block[i][j]-=1;
                println("right "+time+"["+(time-time2)+"] "+i+" "+j);
                time2=time;
              }
              //左からブロックに当たった時
              else if(Ball_XS>0&&j!=0&&block[i][j-1]==0&&(
              Ball_X[0]-Ball_XS<36*j||36*j+36<Ball_X[0]-Ball_XS||
              Ball_Y[0]+Ball_YS<20*i||20*i+20<Ball_Y[0]+Ball_YS)){
                Ball_XS*=-1;
                block[i][j]-=1;
                println("left "+time+"["+(time-time2)+"] "+i+" "+j);
                time2=time;
              }else{
                println("failure "+time+"["+(time-time2)+"] "+i+" "+j);
                println(Ball_X[0]+" "+Ball_Y[0]);
                time2=time;
                Ball_X[0]=Ball_X[1]+(Ball_X[0]-Ball_X[1])*0.5;
                Ball_Y[0]=Ball_Y[1]+(Ball_Y[0]-Ball_Y[1])*0.5;
                println(Ball_X[0]+" "+Ball_Y[0]);
                i=-1;
                break;
              }
             
              if(Ball_YS>0){
                Ball_YS+=16.0/blockBound;
              }else{
                Ball_YS-=16.0/blockBound;
              }
            }
          }
        }
      }
      //バーに当たった時
      if(Bar_X-40<=Ball_X[0]+5&&Ball_X[0]-5<=Bar_X+40
         &&395<=Ball_Y[0]+5&&Ball_Y[0]-5<=405){
           Ball_YS*=-1;
           Ball_XS+=(Ball_X[0]-Bar_X)*0.06;
      }
      
      
      //画面下にいった場合
      if(height<=Ball_Y[0]){
        Ball_num-=1;
        Ball_stu=0;
      }
      break;
  }
  
  //ボールの表示////////////////////////////////////////
  
  ellipse(Ball_X[0],Ball_Y[0],10,10);
  
  
  //////
  /*
  fill(255,50);
  for(int i=249;i>=1;i--){
    Ball_x[i]=Ball_x[i-1];
    Ball_y[i]=Ball_y[i-1];
  }
  Ball_x[0]=Ball_X[0];
  Ball_y[0]=Ball_Y[0];
  
  for(int i=0;i<250;i++){
    ellipse(Ball_x[i],Ball_y[i],10,10);
  }
  //*/
  time++;
}

void mousePressed(){
  if(Ball_stu==0){
    Ball_XS=0;
    Ball_YS=-4;
    Ball_stu=1;
  }
}