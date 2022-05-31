import 'package:flutter/material.dart';
import 'package:musicplay/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: musicplay(),
  ));
}

class musicplay extends StatefulWidget {
  const musicplay({Key? key}) : super(key: key);

  @override
  State<musicplay> createState() => _musicplayState();
}

class _musicplayState extends State<musicplay> {
  OnAudioQuery _audioQuery = OnAudioQuery();
  bool getdata = false;
  List<SongModel> songlist = [];

  someName() async {
    // DEFAULT:
    // SongSortType.TITLE,
    // OrderType.ASC_OR_SMALLER,
    // UriType.EXTERNAL,
    songlist = await _audioQuery.querySongs();
    setState(() {
      getdata = true;
    });
  }

  permission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);

    var status = await Permission.camera.status;
    if (status.isDenied) {
      permission();
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
  }

  @override
  void initState() {
    super.initState();
    permission();
    someName();

  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Musicplay"),
        ),
        body: getdata
            ? ListView.builder(
                itemCount: songlist.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${songlist[index].title}",
                        style: TextStyle(color: Colors.blueGrey)),
                    subtitle: Text("${songlist[index].displayName}"),
                    trailing: Text(printDuration(
                        Duration(milliseconds: songlist[index].duration!))),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return playpage(songlist, index);
                        },
                      ));
                    },
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
