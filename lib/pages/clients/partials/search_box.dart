import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/clients_provider.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({Key key}) : super(key: key);

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
    final ClientsProvider clientsProvider =
        Provider.of<ClientsProvider>(context);
    final Color textColor = Theme.of(context).textTheme.bodyText1.color;

    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            clientsProvider.search.isEmpty
                ? Icon(Icons.search, size: 18.0, color: textColor)
                : IconButton(
                    icon: Icon(Icons.close, size: 18.0, color: textColor),
                    onPressed: () {
                      clientsProvider.search = '';
                      _searchController.clear();
                    },
                  ),
            Expanded(
              child: TextField(
                onChanged: (String value) {
                  clientsProvider.search = value;
                },
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Buscador',
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(
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
