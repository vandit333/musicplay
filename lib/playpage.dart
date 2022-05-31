import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playpage extends StatefulWidget {
  List? currentsong;
  int? nextsong;

  playpage(this.currentsong,this.nextsong);

  @override
  State<playpage> createState() => _playpageState();
}

class _playpageState extends State<playpage> {

  String? localpath;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.stop().then((value) {

    });
  }
  AudioPlayer audioPlayer = AudioPlayer();
  bool play=false;
  PageController? controller;
  int slval=0;
  double position=0;
  double duration=0;
  bool get=false;

  getsong() async {
    localpath =widget.currentsong![widget.nextsong!].data;
    await audioPlayer.play(localpath!,isLocal: true);
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() {
        slval=d.inMilliseconds;
        get=true;

      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration  p)  {
    print('Current position: $p');
        setState(() {
          position=p.inMilliseconds.toDouble();
    });
  });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        widget.nextsong=widget.nextsong! + 1;
      });
      getsong();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ListTile(title: Text(widget.currentsong![widget.nextsong!].title),),
            Slider( onChanged: (value) async {
              await audioPlayer.seek(Duration(milliseconds: value.toInt()));

            },value: position.toDouble(),
              min: 0,
              max: slval.toDouble(),
              activeColor: Colors.blueGrey,
              inactiveColor: Colors.grey,
              thumbColor: Colors.brown,
            ),
            // ListTile(title: Text(widget.currentsong![widget.nextsong!].displayName),),
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                child: Row(
                  children: [
                    Center(
                      child: IconButton(onPressed: () async {
                        if(widget.nextsong!>0)
                          {
                            await audioPlayer.stop();
                            widget.nextsong=widget.nextsong!-1;
                            localpath=widget.currentsong![widget.nextsong!].data;
                            await audioPlayer.play(localpath!,isLocal:true);
                          }
                        setState(() {
                        });


                      }, icon: Icon(Icons.fast_rewind)),
                    ),
                    Center(
                      child: IconButton(onPressed: () async {
                        setState((){
                          play=!play;
                        });
                        if(play)
                          {
                            await audioPlayer.pause();
                          }
                        else
                          {
                            await audioPlayer.resume();
                          }
                      }, icon: play? Icon(Icons.play_arrow):Icon(Icons.pause)),
                    ),
                    Center(
                      child: IconButton(onPressed: () async {
                        if(widget.nextsong!<widget.currentsong!.length+1)
                          {
                            await audioPlayer.stop();
                            widget.nextsong=widget.nextsong!+1;
                            localpath=widget.currentsong![widget.nextsong!].data;
                            await audioPlayer.play(localpath!,isLocal: true);
                          }
                        setState(() {
                        });

                      }, icon: Icon(Icons.fast_forward_sharp)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}