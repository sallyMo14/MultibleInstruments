import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:piano/piano.dart';

final Uri _url = Uri.parse('https://flutter.dev');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterMidi flutterMidi = FlutterMidi();
  String instrument = "Guitar";
  String? choice;
  Uri? link;

  @override
  void initState() {
    load('assets/Guitars.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(
      sf2: _byte,
      name: 'assets/Guitars.sf2'.replaceAll('assets/', ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        centerTitle: true,
        leading: DropdownButton<String?>(
          padding: const EdgeInsetsDirectional.only(start: 10),
          value: choice ?? 'Guitars',
          onChanged: (value) {
            setState(() {
              choice = value!;
            });
            // flutterMidi.mute();

            load('assets/$choice.sf2');
          },
          items: const [
            DropdownMenuItem(
              child: Text("Guitar"),
              value: 'Guitars',
            ),
            DropdownMenuItem(
              child: Text("Flute"),
              value: 'Flute',
            ),
            DropdownMenuItem(
              child: Text("Strings"),
              value: 'Strings',
            ),
            DropdownMenuItem(
              child: Text("Yamaha"),
              value: 'Yamaha',
            ),
          ],
        ),
        title: Text("instrument"),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              link = Uri.parse('tel:0599999999');
              launchUrl(link!);
            },
          ),
          IconButton(
            icon: Icon(Icons.sms),
            onPressed: () {
              link = Uri.parse('sms:059999999');
              launchUrl(link!);
            },
          ),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () {
              link = Uri.parse('mailto:sallyabdalatti@gmail.com');
              launchUrl(link!);
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              link = Uri.parse('https://google.ps');
              launchUrl(link!, mode: LaunchMode.externalApplication);
            },
          )
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          onNotePositionTapped: (position) {
            // Use an audio library like flutter_midi to play the sound
            flutterMidi.playMidiNote(midi: position.pitch);
          },
        ),
      ),
    );
  }
}
