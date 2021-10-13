import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';

class TodaysDealProducts extends StatefulWidget {
  Map<String,bool>argument;
  bool from_notification;
  TodaysDealProducts({this.from_notification = false,this.argument});
  @override
  _TodaysDealProductsState createState() => _TodaysDealProductsState();
}

class _TodaysDealProductsState extends State<TodaysDealProducts> {
  ScrollController _scrollController;

  @override void initState() {
    if(widget.argument!=null){
      widget.from_notification = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(widget.from_notification){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
          return false;
        }else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () {
            if(widget.from_notification){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Main();
              }));
            }
            else
              Navigator.of(context).pop();},
        ),
      ),
      title: Text(
        "Today's Deal",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getTodaysDealProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            /*print("product error");
            print(snapshot.error.toString());*/
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            return SingleChildScrollView(
              child: GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: productResponse.products.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.618),
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    id: productResponse.products[index].id,
                    image: productResponse.products[index].thumbnail_image,
                    name: productResponse.products[index].name,
                    main_price: productResponse.products[index].main_price,
                    stroked_price:
                        productResponse.products[index].stroked_price,
                    has_discount: productResponse.products[index].has_discount,
                  );
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
