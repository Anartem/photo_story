import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';

class NotePageArg {
  final ImageModel image;

  NotePageArg(this.image);
}

class NotePage extends StatefulWidget {
  static const route = "/note";

  final NotePageArg arg;

  const NotePage({required this.arg, Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    _noteController.text = widget.arg.image.note ?? "";
    _titleController.text = widget.arg.image.title ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              actions: [
                IconButton(
                  onPressed: () => _onResult(null, null),
                  icon: const Icon(Icons.delete),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Hero(
                  tag: widget.arg.image.path,
                  child: ImageWidget(
                    image: widget.arg.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _titleController,
                  maxLines: 1,
                  maxLength: 30,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "Short title for the image",
                    label: Text("Title"),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _noteController,
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 350,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "Interesting note about it",
                    label: Text("Note"),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () => Modular.to.pop(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => _onResult(_titleController.text, _noteController.text),
                      child: const Text("Attach note"),
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

  void _onResult(String? title, String? note) {
    Modular.to.pop(
      NotePageArg(
        widget.arg.image
          ..title = title
          ..note = note,
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
