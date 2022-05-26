import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(MaterialApp(home: musicplay(),));
}
class musicplay extends StatefulWidget {
  const musicplay({Key? key}) : super(key: key);

  @override
  State<musicplay> createState() => _musicplayState();
}

class _musicplayState extends State<musicplay> {
  OnAudioQuery _audioQuery = OnAudioQuery();
  bool getdata=false;
  List<SongModel> songlist=[];
  someName() async {
    // DEFAULT:
    // SongSortType.TITLE,
    // OrderType.ASC_OR_SMALLER,
    // UriType.EXTERNAL,
    songlist = await _audioQuery.querySongs();
    getdata=true;
  }


  @override
  void initState() {
    super.initState();
    someName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Musicplay"),),
    body: getdata?ListView.builder(itemCount: songlist.length,itemBuilder: (context, index) {
      return ListTile(
        title: Text("${songlist[index].title}",style: TextStyle(color: Colors.blueGrey)),
        subtitle: Text("${songlist[index].displayName}"),

      );
    },):Center(child: CircularProgressIndicator(),)
    );
  }
}

