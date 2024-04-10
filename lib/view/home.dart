import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final List<(XFile file, Uint8List bytes)> _list = [];

  bool isHovering = false;

  Future<void> setFiles(List<XFile> files) async {
    for (final xFile in files) {
      final bytes = await xFile.readAsBytes();
      setState(() {
        _list.add((xFile, bytes));
      });
    }
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      await setFiles(result.xFiles);
    }
  }

  Future<void> dragFiles(DropDoneDetails details) async {
    await setFiles(details.files);
  }

  Future<void> deleteFiles(XFile fileToDelete) async {
    setState(() {
      _list.removeWhere((pair) {
        final (file, _) = pair;

        return file == fileToDelete;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(widget.title, style: const TextStyle(fontSize: 14),),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,

        // Drag and Drop
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropTarget(
              onDragDone: dragFiles,
              onDragEntered: (_) => setState(() => isHovering = true),
              onDragExited: (_) => setState(() => isHovering = false),
              onDragUpdated: (_) {},
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: isHovering
                      ? Colors.grey
                      : Colors.white,
                  border: Border.all(
                    color: isHovering
                        ? Colors.green
                        :  Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 300,
                height: 400,
                duration: const Duration(milliseconds: 300),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file,
                      color: Colors.red,
                      size: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text('Arraste os seus arquivos em pdf para a area',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final (file, _) in _list)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(file.name),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteFiles(file),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
