import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/theme/theme.dart';

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    final TextStyle subtitleStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(
              color: CustomTheme.grey2Color,
            );

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Text('Comentarios', style: titleStyle),
          Text('18 comentarios', style: subtitleStyle),
          SizedBox(height: 10.0),
          _Comment(
            activeStars: 4,
            name: 'Ana Valencia',
            title: 'Excelentes zapatillas',
            comment:
                'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Corrupti commodi suscipit nisi veniam placeat fuga reprehenderit omnis quisquam dolor assumenda voluptatum tenetur, qui soluta temporibus quia sapiente, consequuntur illum. Molestias.',
          ),
          _Comment(
            activeStars: 4,
            name: 'Ana Valencia',
            title: 'Excelentes zapatillas',
            comment:
                'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Corrupti commodi suscipit nisi veniam placeat fuga reprehenderit omnis quisquam dolor assumenda voluptatum tenetur, qui soluta temporibus quia sapiente, consequuntur illum. Molestias.',
          ),
          _Comment(
            activeStars: 4,
            name: 'Ana Valencia',
            title: 'Excelentes zapatillas',
            comment:
                'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Corrupti commodi suscipit nisi veniam placeat fuga reprehenderit omnis quisquam dolor assumenda voluptatum tenetur, qui soluta temporibus quia sapiente, consequuntur illum. Molestias.',
          ),
          _Comment(
            activeStars: 4,
            name: 'Ana Valencia',
            title: 'Excelentes zapatillas',
            comment:
                'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Corrupti commodi suscipit nisi veniam placeat fuga reprehenderit omnis quisquam dolor assumenda voluptatum tenetur, qui soluta temporibus quia sapiente, consequuntur illum. Molestias.',
          ),
          _Comment(
            activeStars: 4,
            name: 'Ana Valencia',
            title: 'Excelentes zapatillas',
            comment:
                'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Corrupti commodi suscipit nisi veniam placeat fuga reprehenderit omnis quisquam dolor assumenda voluptatum tenetur, qui soluta temporibus quia sapiente, consequuntur illum. Molestias.',
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class _Comment extends StatelessWidget {
  const _Comment({
    Key key,
    @required this.activeStars,
    @required this.title,
    @required this.comment,
    @required this.name,
  }) : super(key: key);

  final int activeStars;
  final String title;
  final String comment;
  final String name;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    final TextStyle nameStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: titleStyle),
          SizedBox(height: 10.0),
          Container(
            child: Row(
              children: [
                _StarIcon(active: activeStars >= 1),
                _StarIcon(active: activeStars >= 2),
                _StarIcon(active: activeStars >= 3),
                _StarIcon(active: activeStars >= 4),
                _StarIcon(active: activeStars >= 5),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Text(comment, style: textStyle),
          SizedBox(height: 10.0),
          Text(name, style: nameStyle),
        ],
      ),
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    Key key,
    @required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      color: active ? CustomTheme.yellowColor : CustomTheme.greyColor,
    );
  }
}
