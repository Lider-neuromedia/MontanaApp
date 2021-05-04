import 'package:flutter/material.dart';
import 'package:montana_mobile/models/catalogue.dart';
import 'package:montana_mobile/theme/theme.dart';

class CatalogueItem extends StatelessWidget {
  const CatalogueItem({
    Key key,
    this.catalogue,
  }) : super(key: key);

  final Catalogue catalogue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CatalogueCard(
          catalogue: catalogue,
        ),
        _TypeTag(catalogue: catalogue),
        catalogue.discount != null
            ? _DiscountTag(catalogue: catalogue)
            : Container()
      ],
    );
  }
}

class _DiscountTag extends StatelessWidget {
  const _DiscountTag({
    Key key,
    @required this.catalogue,
  }) : super(key: key);

  final Catalogue catalogue;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontWeight: FontWeight.w200,
          color: Colors.white,
        );
    return Positioned(
      top: 75.0,
      right: 4.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 20.0,
        ),
        decoration: BoxDecoration(
          color: CustomTheme.textColor1,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
        ),
        child: Text(
          "${catalogue.discount}%",
          style: textStyle,
        ),
      ),
    );
  }
}

class _TypeTag extends StatelessWidget {
  const _TypeTag({
    Key key,
    @required this.catalogue,
  }) : super(key: key);

  final Catalogue catalogue;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    String type = catalogue.type.toLowerCase().trim();
    String firstLetter = type.substring(0, 1).toUpperCase();
    String word = firstLetter + type.substring(1, type.length);

    return Positioned(
      top: 30.0,
      right: 5.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 30.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
        ),
        child: Text(
          word,
          style: textStyle,
        ),
      ),
    );
  }
}

class _CatalogueCard extends StatelessWidget {
  const _CatalogueCard({
    Key key,
    @required this.catalogue,
  }) : super(key: key);

  final Catalogue catalogue;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle1 = Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w700,
          color: CustomTheme.textColor1,
        );
    TextStyle textStyle2 = Theme.of(context).textTheme.headline6.copyWith(
          color: CustomTheme.textColor1,
        );
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: FadeInImage(
                placeholder: AssetImage("assets/images/placeholder.png"),
                image: NetworkImage(catalogue.image),
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 5.0),
            Text(catalogue.title.toUpperCase(), style: textStyle1),
            SizedBox(height: 5.0),
            catalogue.quantity == 1
                ? Text("${catalogue.quantity} producto", style: textStyle2)
                : Text("${catalogue.quantity} productos", style: textStyle2),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}