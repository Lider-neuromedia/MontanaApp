import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montana_mobile/theme/theme.dart';

class FileButton extends StatelessWidget {
  const FileButton({
    Key key,
    @required this.value,
    @required this.onSelected,
  }) : super(key: key);

  final Function(File) onSelected;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomTheme.greyColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(10.0),
              child: Text(
                value == null ? "" : "$value",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          value != null
              ? _FileIcon(
                  icon: Icons.close,
                  onTap: () => onSelected(null),
                )
              : Container(),
          value == null
              ? _FileIcon(
                  icon: Icons.attach_file,
                  onTap: () => _processPhoto(ImageSource.gallery),
                )
              : Container(),
          value == null
              ? _FileIcon(
                  icon: FontAwesome5.camera,
                  onTap: () => _processPhoto(ImageSource.camera),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> _processPhoto(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: source);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    onSelected(file);
  }
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({
    Key key,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          height: 50.0,
          child: Icon(icon, color: Colors.white),
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
