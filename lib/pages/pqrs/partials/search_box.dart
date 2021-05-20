import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatefulWidget {
  SearchBox({Key key}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pqrsProvider = Provider.of<PqrsProvider>(context);
    final textColor = Theme.of(context).textTheme.bodyText1.color;

    final iconSearch = Icon(Icons.search, size: 18.0, color: textColor);
    final iconClose = Icon(Icons.close, size: 18.0, color: textColor);

    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pqrsProvider.search.isEmpty
                ? iconSearch
                : IconButton(
                    icon: iconClose,
                    onPressed: () {
                      pqrsProvider.search = '';
                      _searchController.clear();
                    },
                  ),
            Expanded(
              child: TextField(
                onChanged: (String value) {
                  pqrsProvider.search = value;
                },
                controller: _searchController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: 'Buscador',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
