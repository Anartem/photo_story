import 'package:photo_story/models/image_model.dart';

class PageModel {
  List<ImageModel> images;
  String tag;

  PageModel({required this.images, required this.tag});
}