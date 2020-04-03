import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/controllers/page_controller_app.dart';
import 'package:wallet/pages/painel.dart';
import 'package:wallet/pages/statistic.dart';

class HomePage extends StatelessWidget {
  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
              child: Row(
                children: <Widget>[
                  Consumer<PageControllerApp>(
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          if (_pageController.page == 1) {
                            _pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                            value.setIndex(0.0);
                          }
                        },
                        child: Opacity(
                          opacity: value.index == 0.0 ? 1 : 0.2,
                          child: Text(
                            "Carteira",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Consumer<PageControllerApp>(
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          if (_pageController.page == 0) {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                            value.setIndex(1.0);
                          }
                        },
                        child: Opacity(
                          opacity: value.index == 1.0 ? 1 : 0.2,
                          child: Text(
                            "Estatisticas",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Consumer<PageControllerApp>(
              builder: (context, value, child) {
                return Expanded(
                  child: PageView(
                    onPageChanged: (pageCurrent) {
                      value.setIndex(double.parse(pageCurrent.toString()));
                    },
                    controller: _pageController,
                    children: <Widget>[Painel(), Statistic()],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
