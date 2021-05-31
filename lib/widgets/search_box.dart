import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    Key key,
    @required this.onChanged,
    @required this.value,
  }) : super(key: key);

  final Function(String) onChanged;
  final String value;

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyText1.color;

    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.value.isEmpty
                ? Icon(Icons.search, size: 18.0, color: textColor)
                : IconButton(
                    icon: Icon(Icons.close, size: 18.0, color: textColor),
                    onPressed: () {
                      widget.onChanged("");
                      _searchController.clear();
                    },
                  ),
            Expanded(
              child: TextField(
                onChanged: widget.onChanged,
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Buscador',
                  isCollapsed: true,
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
