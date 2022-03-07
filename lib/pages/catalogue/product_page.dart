import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:montana_mobile/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/catalogue/partials/rating_form.dart';
import 'package:montana_mobile/pages/catalogue/partials/ratings.dart';
import 'package:montana_mobile/pages/catalogue/partials/section_card.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:montana_mobile/providers/rating_provider.dart';
import 'package:montana_mobile/theme/theme.dart';
import 'package:montana_mobile/utils/utils.dart';
import 'package:montana_mobile/widgets/cart_icon.dart';
import 'package:montana_mobile/widgets/image_ink_widget.dart';
import 'package:montana_mobile/widgets/image_widget.dart';

class ProductPage extends StatefulWidget {
  static final String route = "product";

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
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    _productArgs = ModalRoute.of(context).settings.arguments as ProductPageArgs;
    productProvider.loadProduct(
      _productArgs.productId,
      local: connectionProvider.isNotConnected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Scaffold(
      backgroundColor: CustomTheme.grey3Color,
      appBar: AppBar(
        title: Text("Detalle de Producto"),
        actions: [
          const CartIcon(),
        ],
      ),
      body: productProvider.isLoading
          ? const LoadingContainer()
          : productProvider.product == null
              ? EmptyMessage(
                  message: "No hay información.",
                  onPressed: () => productProvider.loadProduct(
                    _productArgs.productId,
                    local: connectionProvider.isNotConnected,
                  ),
                )
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  child: _ProductContent(product: productProvider.product),
                  onRefresh: () => productProvider.loadProduct(
                    _productArgs.productId,
                    local: connectionProvider.isNotConnected,
                  ),
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
    final htmlStyle = {
      "body": Style(
        margin: const EdgeInsets.all(0.0),
        fontSize: FontSize(16),
      ),
      "*": Style(
        fontFamily: CustomTheme.primaryFont,
        color: CustomTheme.textColor1,
      ),
    };

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            product.image.isNotEmpty
                ? _GalleryProduct(product: product)
                : Container(),
            Container(
              height: 1.0,
              color: Colors.grey,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
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
                    style: htmlStyle,
                  ),
                  _minSeparator,
                ],
              ),
            ),
            // Ocultar valoraciones
            // _bigSeparator,
            // _RatingsContent(product: product),
            const SizedBox(height: 120.0),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: ElevatedButton(
              child: Text("Añadir al pedido"),
              onPressed: () => openStartOrderModal(
                context,
                onContinue: () => openAddProductModal(context, product),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                primary: CustomTheme.green2Color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingsContent extends StatefulWidget {
  const _RatingsContent({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Producto product;

  @override
  __RatingsContentState createState() => __RatingsContentState();
}

class __RatingsContentState extends State<_RatingsContent> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final ratingProvider =
          Provider.of<RatingProvider>(context, listen: false);
      final connectionProvider =
          Provider.of<ConnectionProvider>(context, listen: false);

      ratingProvider.loadData(
        widget.product.catalogoId,
        widget.product.id,
        local: connectionProvider.isNotConnected,
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);

    return Container(
      child: ratingProvider.isLoading
          ? const LoadingContainer()
          : ratingProvider.valoracion == null
              ? EmptyMessage(
                  message: "No hay información para valorar.",
                  onPressed: () => ratingProvider.loadData(
                    widget.product.catalogoId,
                    widget.product.id,
                    local: connectionProvider.isNotConnected,
                  ),
                )
              : Column(
                  children: [
                    const Ratings(),
                    const SizedBox(height: 20.0),
                    ratingProvider.isRatingCompleted
                        ? Container()
                        : RatingForm(
                            onCompleted: () => ratingProvider.loadData(
                              widget.product.catalogoId,
                              widget.product.id,
                              local: connectionProvider.isNotConnected,
                            ),
                          ),
                  ],
                ),
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
    final titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.w700,
        );
    final totalStyle = Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w900,
        );
    final priceStyle = Theme.of(context).textTheme.subtitle1;

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
        const SizedBox(width: 20.0),
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
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: ImageWidget(imageUrl: selectedImage),
          ),
          const SizedBox(height: 10.0),
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
                          onTap: () => setState(() => selectedImage = image),
                          child: ImageInkWidget(imageUrl: image),
                        ),
                      );

                      if (index == 0) {
                        return Row(
                          children: [
                            const SizedBox(width: 10.0),
                            imageWidget,
                          ],
                        );
                      }

                      return imageWidget;
                    },
                    separatorBuilder: (_, int index) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
