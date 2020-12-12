import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../others/save_meme.dart';
import '../models/photo.dart';
import '../models/meme.dart';
import '../widgets/choose_photo_sheet.dart';
import '../providers/photos.dart';
import '../models/meme_text.dart';
import '../widgets/consts.dart';

class AddMemeScreen extends StatefulWidget {
  @override
  _AddMemeScreenState createState() => _AddMemeScreenState();
}

class _AddMemeScreenState extends State<AddMemeScreen> {

  final Meme meme = Meme(id: "xd",bottomText: MemeText(),topText: MemeText(),photo: null);
  GlobalKey _globalKey = GlobalKey();
  int _chosenWeightButton = 1;
  Color _pickerColor = Color(0xff98FF54);
  final consts = Consts();
  final _saveMeme = SaveMeme();

  @override
  void initState() {
    Photos().getPhotosFromWeb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Meme",
                style: theme.textTheme.headline2,
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => ChoosePhotoSheet(changePhoto),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),backgroundColor: Theme.of(context).accentColor),
                child: Container(
                  decoration: meme.photo == null ? BoxDecoration(border: Border.all(color: Colors.white,width: 3.0), borderRadius: BorderRadius.circular(10.0)):null,
                  width: double.infinity,
                  height: deviceHeight / 3,
                  child:meme.photo == null ? Center(child: ColorizeAnimatedTextKit(
                    text: [
                      "Click to choose photo",
                    ],
                    textStyle: Theme.of(context).textTheme.headline3,
                    colors: [
                      Colors.white,
                      Colors.white54,
                      Colors.white30,
                      Colors.white10,
                    ],
                    textAlign: TextAlign.start,
                  speed: Duration(milliseconds: 200),repeatForever: true,)
                  ) : RepaintBoundary(
                    key: _globalKey,
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: Image.network(
                            meme.photo.url,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            height: double.infinity,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                meme.topText.text,
                                textAlign:  meme.topText.align,
                                maxLines: 3,
                                softWrap: true,
                                style: TextStyle(
                                    color:  meme.topText.color,
                                    fontSize:  meme.topText.maxFontSize,
                                    fontWeight:  meme.topText.weight,
                                    fontFamily:  meme.topText.fontFamily),
                              ),
                            ),
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                meme.bottomText.text,
                                textAlign: meme.bottomText.align,
                                maxLines: 3,
                                softWrap: true,
                                style: TextStyle(
                                    color: meme.bottomText.color,
                                    fontSize: meme.bottomText.maxFontSize,
                                    fontWeight: meme.bottomText.weight,
                                    fontFamily: meme.bottomText.fontFamily),
                              ),
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    hintText: 'Enter Top Text',
                    hintStyle:
                        theme.textTheme.headline6.copyWith(color: Colors.grey),
                    focusedBorder: consts.border,
                    enabledBorder: consts.border.copyWith(
                        borderSide: BorderSide(color: Colors.grey[600]))),
                style: theme.textTheme.headline6,
                onChanged: (val) => setState(() =>  meme.topText.text = val),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    hintText: 'Enter Bottom Text',
                    hintStyle:
                        theme.textTheme.headline6.copyWith(color: Colors.grey),
                    focusedBorder: consts.border,
                    enabledBorder: consts.border.copyWith(
                        borderSide: BorderSide(color: Colors.grey[600]))),
                style: theme.textTheme.headline6,
                onChanged: (val) => setState(() => meme.bottomText.text = val),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Text Color\n(click to change)",
                textAlign: TextAlign.center,
                style: theme.textTheme.headline3,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Container(
                  width: 70,
                  height: 70,
                  color:  meme.topText.color,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      titleTextStyle:
                          theme.textTheme.headline3.copyWith(fontSize: 16.0),
                      backgroundColor: theme.primaryColor,
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor:  meme.topText.color,
                          onColorChanged: changeColor,
                          showLabel: false,
                          pickerAreaHeightPercent: 1,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Choose',
                            style: theme.textTheme.headline3
                                .copyWith(fontSize: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              meme.topText.color = _pickerColor;
                              meme.bottomText.color = _pickerColor;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Max Text Size",
                style: theme.textTheme.headline3,
              ),
              SizedBox(
                height: 10,
              ),
              Slider(
                value:  meme.topText.maxFontSize,
                max: 100,
                min: 10,
                onChanged: (val) => _setMaxTextSize(val),
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Text Style",
                style: theme.textTheme.headline3,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  _getFontWeightButton("Bold", () {
                    _setWeight(FontWeight.w900, 0);
                  }, 0),
                  SizedBox(
                    width: 20,
                  ),
                  _getFontWeightButton("Normal", () {
                    _setWeight(FontWeight.w500, 1);
                  }, 1),
                  SizedBox(
                    width: 20,
                  ),
                  _getFontWeightButton("Light", () {
                    _setWeight(FontWeight.w300, 2);
                  }, 2),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Font Family",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline3,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      "Text Align",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline3,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  _getDropdown(
                      'Lato', 'Poppins', 'Coda', _setFamily,  meme.topText.fontFamily),
                  SizedBox(
                    width: 20,
                  ),
                  _getDropdown(
                      'left', 'center', 'right', _setTextAlign, _textAlignName),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Create Meme",
                    style: theme.textTheme.headline3
                        .copyWith(color: theme.primaryColor),
                  ),
                  onPressed: () async{
                      await _saveMeme.requestPermission(context);
                      _saveMeme.saveImage(_globalKey).catchError((e)=>print(e));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //----------------- set weight of text -----------------
  void _setWeight(FontWeight weight, int chosen) {
    setState(() {
      meme.topText.weight = weight;
      meme.bottomText.weight = weight;
      _chosenWeightButton = chosen;
    });
  }

  //----------------- set font family of text -----------------
  void _setFamily(String fontFamily) {
    setState(() {
      meme.topText.fontFamily = fontFamily;
      meme.bottomText.fontFamily = fontFamily;
    });
  }

  //----------------- set text align from string -----------------
  void _setTextAlign(String textAlign) {
    setState(() {
      switch (textAlign) {
        case 'left':
          _setAlignOnText(TextAlign.left);
          break;
        case 'right':
          _setAlignOnText(TextAlign.right);
          break;
        case 'center':
          _setAlignOnText(TextAlign.center);
          break;
        default:
          _setAlignOnText(TextAlign.center);
      }
    });
  }

  void _setAlignOnText(TextAlign align) {
    setState(() {
      meme.topText.align = align;
      meme.bottomText.align = align;
    });
  }

  //----------------- set max text size -----------------
  void _setMaxTextSize(double size) {
    setState(() {
      meme.topText.maxFontSize = size;
      meme.bottomText.maxFontSize = size;
    });
  }

  //----------------- get align name -----------------
  String get _textAlignName {
    switch ( meme.topText.align) {
      case TextAlign.center:
        return "center";
      case TextAlign.left:
        return "left";
      case TextAlign.right:
        return "right";
      default:
        return "center";
    }
  }

  //handle color change in picker
  void changeColor(Color color) => setState(() => _pickerColor = color);

  void changePhoto(Photo photo) => setState(()=>meme.photo = photo);

  //----------------- get font weight button widget -----------------
  Widget _getFontWeightButton(String title, Function handler, int actual) =>
      Expanded(
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: AutoSizeText(
            title,
            maxLines: 1,
            maxFontSize: 18,
            style: Theme.of(context).textTheme.headline3.copyWith(
                color: actual == _chosenWeightButton
                    ? Theme.of(context).primaryColor
                    : Colors.white),
          ),
          onPressed: handler,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: actual == _chosenWeightButton
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
      );

  //----------------- get dropdown widget -----------------
  Widget _getDropdown(String value1, String value2, String value3,
          Function handler, String actualValue) =>
      Expanded(
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DropdownButton<String>(
              items: [
                DropdownMenuItem(
                  child: Text(value1),
                  value: value1,
                ),
                DropdownMenuItem(
                  child: Text(value2),
                  value: value2,
                ),
                DropdownMenuItem(
                  child: Text(value3),
                  value: value3,
                )
              ],
              onChanged: (value) => handler(value),
              value: actualValue,
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 18),
              dropdownColor: Theme.of(context).primaryColor,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
            ),
          ),
        ),
      );


}
