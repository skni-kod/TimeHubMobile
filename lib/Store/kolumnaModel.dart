import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/Store/userModel.dart';
import 'package:timehubmobile/widokTablicy.dart';
import 'package:http/http.dart' as http;

String kolumnaToJson(List<Kolumna> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
