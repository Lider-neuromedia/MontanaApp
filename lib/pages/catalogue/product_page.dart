import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/add_product_modal.dart';
import 'package:montana_mobile/pages/catalogue/partials/comments.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/rating_form.dart';
import 'package:montana_mobile/pages/catalogue/partials/ratings.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/pages/catalogue/start_order_modal.dart';
import 'package:montana_mobile/providers/products_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  static final String route = 'product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductPageArgs _productArgs;

  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);
      _loadData(context);
    }();
  }

  void _loadData(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );

    _productArgs = ModalRoute.of(context).settings.arguments as ProductPageArgs;
    productsProvider.loadProduct(_productArgs.productId);
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text('Detalle de Producto'),
        actions: [
          CartIcon(),
        ],
      ),
      body: productsProvider.isLoadingProduct
          ? const LoadingContainer()
          : productsProvider.product == null
              ? EmptyMessage(
                  message: 'No hay información.',
                  onPressed: () =>
                      productsProvider.loadProduct(_productArgs.productId),
                )
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  child: _ProductContent(product: productsProvider.product),
                  onRefresh: () =>
                      productsProvider.loadProduct(_productArgs.productId),
                ),
    );
  }
}

class ProductPageArgs {
  final int productId;
  final int catalogId;

  ProductPageArgs(
    this.productId,
    this.catalogId,
  );
}

class _ProductContent extends StatelessWidget {
  const _ProductContent({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  final _bigSeparator = const SizedBox(height: 20.0);
  final _minSeparator = const SizedBox(height: 10.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            product.image == null
                ? Container()
                : _GalleryProduct(product: product),
            Container(
              height: 1.0,
              color: Colors.grey,
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
            ),
            _ProductTitle(product: product),
            _bigSeparator,
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _minSeparator,
                  Html(
                    data: product.descripcion,
                    style: {
                      'body': Style(
                        margin: EdgeInsets.all(0.0),
                        fontSize: FontSize(16),
                      ),
                      '*': Style(
                        fontFamily: CustomTheme.primaryFont,
                        color: CustomTheme.textColor1,
                      ),
                    },
                  ),
                  _minSeparator,
                ],
              ),
            ),
            _bigSeparator,
            RatingForm(product: product),
            _bigSeparator,
            Ratings(),
            _bigSeparator,
            Comments(),
            const SizedBox(height: 120.0),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: ElevatedButton(
              child: Text('Añadir al pedido'),
              onPressed: () => _openStartOrder(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: CustomTheme.green2Color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openStartOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (_) {
        return StartOrderModal(
          showCatalogue: false,
          onPressed: () {
            Navigator.pop(context);
            _openAddProduct(context);
          },
        );
      },
    );
  }

  void _openAddProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (_) => AddProductModal(product: product),
    );
  }
}

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.w700,
        );
    final TextStyle totalStyle = Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w900,
        );
    final TextStyle priceStyle = Theme.of(context).textTheme.subtitle1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            product.nombre,
            style: titleStyle,
            softWrap: true,
          ),
        ),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatMoney(product.total), style: totalStyle),
            Text(formatMoney(product.precio), style: priceStyle),
          ],
        ),
      ],
    );
  }
}

class _GalleryProduct extends StatefulWidget {
  const _GalleryProduct({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  @override
  __GalleryProductState createState() => __GalleryProductState();
}

class __GalleryProductState extends State<_GalleryProduct> {
  String selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: FadeInImage(
                placeholder: AssetImage("assets/images/placeholder.png"),
                image: NetworkImage(selectedImage),
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          widget.product.imagenes.length == 0
              ? Container()
              : Container(
                  height: 50.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.imagenes.length,
                    itemBuilder: (_, int index) {
                      final image = widget.product.imagenes[index].image;
                      final imageWidget = Material(
                        child: InkWell(
                          onTap: () {
                            setState(() => selectedImage = image);
                          },
                          child: Ink.image(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                            width: 100.0,
                          ),
                        ),
                      );

                      if (index == 0) {
                        return Row(
                          children: [
                            SizedBox(width: 10.0),
                            imageWidget,
                          ],
                        );
                      }

                      return imageWidget;
                    },
                    separatorBuilder: (_, int index) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          color: CustomTheme.greyColor,
                          height: 25.0,
                          width: 1.0,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
