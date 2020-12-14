
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/network_ex.dart';
import '../widgets/consts.dart';
import '../database/database.dart';
import './meme.dart';

class Memes with ChangeNotifier{

  List<Meme> _memes = [];

  List<Meme> get memes => [..._memes];

  final consts = Consts();
  final database = Database();

  Future<void> addMeme(Meme meme,BuildContext context) async {
    try{
      showDialog(context: context,builder: (context) => consts.getLoadingDialog(context, 'Sharing...'));
      await database.addMeme(meme);
      _memes.add(meme);
      notifyListeners();
      Navigator.of(context).pop();
    }catch(e){
      Navigator.of(context).pop();
      throw NetworkEx(e);
    }
  }

  Future <void> fetchMemes() async{
    try{
      Response response = await database.fetchMemes();
      final data = json.decode(response.body) as Map<String, dynamic>;
      _memes.clear();
      data.forEach((memeId, memeData) => _memes.add(Meme().fromMap(memeData)));
      notifyListeners();
    }catch(e){
      throw e;
    }
  }


}