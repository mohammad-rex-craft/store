import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

void router(BuildContext ctx,String name) {
  Navigator.of(ctx).pushNamed(
    name,
  );
}

void dynamicRouter(BuildContext ctx,String name,Object arguments) {
  Navigator.of(ctx).pushNamed(
    name,
    arguments: arguments
  );
}

void replaceRouter(BuildContext ctx,String name){
  Navigator.of(ctx).pushReplacementNamed(name);
}
