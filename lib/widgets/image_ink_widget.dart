import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/database_provider.dart';

class ImageInkWidget extends StatelessWidget {
  const ImageInkWidget({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return connectionProvider.isNotConnected
        ? FutureBuilder<MemoryImage>(
            future: DatabaseProvider.db.getImage(imageUrl),
            builder: (_, AsyncSnapshot<MemoryImage> snapshot) {
              return Ink.image(
                image: !snapshot.hasData
                    ? const AssetImage("assets/images/placeholder.png")
                    : snapshot.data,
                fit: BoxFit.cover,
                width: 100.0,
              );
            },
          )
        : Ink.image(
            image: connectionProvider.isNotConnected
                ? const AssetImage("assets/images/placeholder.png")
                : NetworkImage(imageUrl),
            fit: BoxFit.cover,
            width: 100.0,
          );
  }
}
