import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum TimerStaus{
  running, resting, paused, stopped
}
class timerscreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return timerstate();
  }
}
class timerstate extends State<timerscreen>
{
  static const WORK_TIME = 25;
  static const REST_TIME = 5;

  late int timer_time; // 시간 상태
  late int count; // 뽀모도로 개수 상태
  late TimerStaus t_state; // 타이터 상태 상태

  String secondsToString(int seconds)
  {
    return sprintf("%02d:%02d",[seconds ~/60, seconds%60]);
  }

  @override
  void initState() {
    super.initState();
    timer_time = WORK_TIME;
    count=0;
    t_state = TimerStaus.stopped;
  }
  void runTimer() async {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
     switch(t_state)
     {
       case TimerStaus.running :
         if(timer_time <=0)
           {
             rest();
           }else{
           setState(
               (){
                 timer_time -= 1;
               }
           );
         }
         break;
       case TimerStaus.resting :
         if(timer_time <=0)
           {
             setState(
                 (){
                   count +=1;
                 }
             );
             t.cancel();
             stop();
           }else{
           setState(
                   (){
                 timer_time -= 1;
               });
         }
         break;
       case TimerStaus.stopped :
         t.cancel();
         break;
       case TimerStaus.paused :
         t.cancel();
         break;
       default :
         break;
     }
    });

  }
  void run()
  {
    setState(
        (){
          t_state =TimerStaus.running;
          runTimer();
          // runTimer -> 시간 진행 메소드
        }
    );
  }

  void rest(){
    setState(
        (){
          t_state = TimerStaus.resting;
          timer_time = REST_TIME;
        }
    );
  }

  void resume(){
    run();
  }
  void pause(){
    setState(
        (){
          t_state = TimerStaus.paused;
        }
    );
  }
  void stop(){
    setState((){
      timer_time = WORK_TIME;
      t_state = TimerStaus.stopped;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> r_button =[
      ElevatedButton(onPressed: (){
        t_state != TimerStaus.paused ? pause() : resume();
      }, child:
          Text(t_state != TimerStaus.paused ? '일시정지': '계속하기',
          style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.grey),
      ),
      Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(onPressed: (){
        stop();
      }, child:
        Text('포기하기', style: TextStyle(
          fontSize: 16, color: Colors.white
        ),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
      )
    ];

    final List<Widget> s_button =[
      ElevatedButton(onPressed: (){
        run();
      }, child:
        Text('시작하기',style: TextStyle(fontSize: 16,
          color: Colors.white
        ),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
      ),
      Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(onPressed: (){
        Fluttertoast.showToast(
            msg: 'total count : $count',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16,
            backgroundColor: Colors.grey,
        );
      }, child:
        Text("결과확인", style: TextStyle(
          fontSize: 16, color: Colors.white
        ),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('뽀모도로 타이머')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.6,
            height: MediaQuery.of(context).size.height*0.5,
            child: Center(
              child: Text(
              secondsToString(timer_time),
              style: TextStyle(fontSize: 48,color: Colors.white, fontWeight: FontWeight.normal),
            ),
            ),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                t_state == TimerStaus.resting ?
                    const[] :
              t_state != TimerStaus.stopped ? r_button : s_button
          ),
        ],
      ),
    );
  }

}