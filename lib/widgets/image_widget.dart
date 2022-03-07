import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/database_provider.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    @required this.imageUrl,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return connectionProvider.isNotConnected
        ? FutureBuilder<MemoryImage>(
            future: DatabaseProvider.db.getImage(imageUrl),
            builder: (_, AsyncSnapshot<MemoryImage> snapshot) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  placeholder:
                      const AssetImage("assets/images/placeholder.png"),
                  image: !snapshot.hasData
                      ? const AssetImage("assets/images/placeholder.png")
                      : snapshot.data,
                  width: double.infinity,
                  fit: fit,
                ),
              );
            },
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: const AssetImage("assets/images/placeholder.png"),
              image: NetworkImage(imageUrl),
              width: double.infinity,
              fit: fit,
            ),
          );
  }
}
