library image_selector_formfield;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
export 'package:image_cropper/src/options.dart';

class ImageSelectorFormField extends StatefulWidget {
  ImageSelectorFormField(
      {Key key,
      this.initialImage,
      this.imageURL = "",
      this.cropRatioX,
      this.cropRatioY,
      this.boxConstraints = const BoxConstraints(maxHeight: 300, maxWidth: 300),
      this.borderRadius,
      this.cropMaxWidth = 720,
      this.cropMaxHeight = 1280,
      this.cropStyle = CropStyle.rectangle,
      this.compressQuality = 90,
      this.compressFormat = ImageCompressFormat.jpg,
      this.aspectRatioPresets = CropAspectRatioPreset.values,
      this.androidUiSettings,
      this.iosUiSettings,
      this.onSaved,
      this.onChanged,
      this.validator,
      this.errorTextStyle,
      this.icon,
      this.backgroundColor = Colors.black12})
      : super(key: key);

  final File initialImage;
  final String imageURL;
  final double cropRatioX;
  final double cropRatioY;
  final BoxConstraints boxConstraints;
  final double borderRadius;
  final int cropMaxWidth;
  final int cropMaxHeight;
  final CropStyle cropStyle;
  final int compressQuality;
  final List<CropAspectRatioPreset> aspectRatioPresets;
  final ImageCompressFormat compressFormat;
  final AndroidUiSettings androidUiSettings;
  final IOSUiSettings iosUiSettings;
  final TextStyle errorTextStyle;
  final Icon icon;
  final Color backgroundColor;
  final void Function(File) onSaved;
  final void Function(File) onChanged;
  final String Function(File) validator;
  @override
  _ImageSelectorFormFieldState createState() => _ImageSelectorFormFieldState();
}

class _ImageSelectorFormFieldState extends State<ImageSelectorFormField> {
  File _imageFile;
  String _imageURL;
  double _aspectRatio;
  double _borderRadius;

  void _setImage(imagen) {
    if (_imageFile != imagen && widget.onChanged != null) {
      widget.onChanged(imagen);
    }
    _imageFile = imagen;
  }

  @override
  void initState() {
    _imageFile = widget.initialImage;
    _imageURL = widget.imageURL;
    // set default aspect ratio
    if (widget.cropRatioX != null && widget.cropRatioY != null) {
      _aspectRatio = widget.cropRatioX / widget.cropRatioY;
    } else {
      _aspectRatio = 9 / 16;
    }

    if (widget.borderRadius != null) {
      _borderRadius = widget.borderRadius;
    } else {
      if (widget.cropStyle == CropStyle.circle) {
        _borderRadius = 160;
      } else {
        _borderRadius = 15;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File>(onSaved: (_) {
      if (widget.onSaved != null) return widget.onSaved(_imageFile);
      return null;
    }, validator: (_) {
      if (widget.validator != null) return widget.validator(_imageFile);
      return null;
    }, builder: (state) {
      if (widget.cropStyle == CropStyle.rectangle) {
        return Column(
          children: <Widget>[
            Container(
                constraints: widget.boxConstraints,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  child: Container(
                    color: widget.backgroundColor,
                    child: AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: _InkWidget(
                          cropStyle: widget.cropStyle,
                          imageFile: _imageFile,
                          imageURL: _imageURL,
                          androidUiSettings: widget.androidUiSettings,
                          compressFormat: widget.compressFormat,
                          aspectRatioPresets: widget.aspectRatioPresets,
                          compressQuality: widget.compressQuality,
                          cropMaxHeight: widget.cropMaxHeight,
                          cropMaxWidth: widget.cropMaxWidth,
                          cropRatioX: widget.cropRatioX,
                          cropRatioY: widget.cropRatioY,
                          iosUiSettings: widget.iosUiSettings,
                          setImage: _setImage,
                          icon: widget.icon ??
                              Icon(
                                Icons.add_a_photo,
                                size: widget.boxConstraints.biggest.width >
                                        widget.boxConstraints.biggest.height
                                    ? widget.boxConstraints.biggest.height / 2.5
                                    : widget.boxConstraints.biggest.width / 2.5,
                                color: Colors.black45,
                              ),
                        )),
                  ),
                )),
            state.hasError
                ? Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(state.errorText,
                        style: this.widget.errorTextStyle))
                : Container()
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadius),
              child: Container(
                width: _borderRadius,
                height: _borderRadius,
                decoration: BoxDecoration(color: widget.backgroundColor),
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: _InkWidget(
                      cropStyle: widget.cropStyle,
                      imageFile: _imageFile,
                      imageURL: _imageURL,
                      androidUiSettings: widget.androidUiSettings,
                      compressFormat: widget.compressFormat,
                      aspectRatioPresets: widget.aspectRatioPresets,
                      compressQuality: widget.compressQuality,
                      cropMaxHeight: widget.cropMaxHeight,
                      cropMaxWidth: widget.cropMaxWidth,
                      cropRatioX: widget.cropRatioX,
                      cropRatioY: widget.cropRatioY,
                      iosUiSettings: widget.iosUiSettings,
                      borderRadius: _borderRadius,
                      setImage: _setImage,
                      icon: widget.icon ??
                          Icon(
                            Icons.add_a_photo,
                            size: _borderRadius / 2,
                            color: Colors.black45,
                          ),
                    )),
              ),
            ),
            state.hasError
                ? Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(state.errorText,
                        style: this.widget.errorTextStyle))
                : Container()
          ],
        );
      }
    });
  }
}

class _InkWidget extends StatefulWidget {
  _InkWidget(
      {Key key,
      this.imageFile,
      this.imageURL,
      this.cropStyle = CropStyle.rectangle,
      this.cropRatioX,
      this.cropRatioY,
      this.borderRadius,
      this.cropMaxWidth,
      this.cropMaxHeight,
      this.compressQuality,
      this.aspectRatioPresets,
      this.compressFormat,
      this.androidUiSettings,
      this.iosUiSettings,
      this.icon,
      this.setImage})
      : super(key: key);

  final File imageFile;
  final String imageURL;
  final CropStyle cropStyle;
  final double borderRadius;
  final double cropRatioX;
  final double cropRatioY;
  final int cropMaxWidth;
  final int cropMaxHeight;
  final int compressQuality;
  final List<CropAspectRatioPreset> aspectRatioPresets;
  final ImageCompressFormat compressFormat;
  final AndroidUiSettings androidUiSettings;
  final IOSUiSettings iosUiSettings;
  final Icon icon;
  final Function(File) setImage;

  @override
  __InkWidgetState createState() => __InkWidgetState();
}

class __InkWidgetState extends State<_InkWidget> {
  File _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.imageFile != null) {
      _imageFile = widget.imageFile;
    }
  }

  Future<File> getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
        aspectRatio: widget.cropStyle == CropStyle.circle
            ? CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
            : widget.cropRatioX != null && widget.cropRatioY != null
                ? CropAspectRatio(
                    ratioX: widget.cropRatioX, ratioY: widget.cropRatioY)
                : null,
        sourcePath: image.path,
        maxWidth: widget.cropMaxWidth,
        maxHeight: widget.cropMaxHeight,
        cropStyle: widget.cropStyle,
        compressQuality: widget.compressQuality,
        compressFormat: widget.compressFormat,
        aspectRatioPresets: widget.aspectRatioPresets,
        androidUiSettings: widget.androidUiSettings,
        iosUiSettings: widget.iosUiSettings,
      );
      return croppedFile;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _imageFile == null
          ? (widget.imageURL == null || widget.imageURL == "")
              ? widget.cropStyle == CropStyle.circle
                  ? // Icon to show when there isn't image - cropstyle circle
                  Container(
                      // size is necessary for Gesture area
                      width: this.widget.borderRadius,
                      height: this.widget.borderRadius,
                      child: this.widget.icon,
                    )
                  : // Icon to show when there isn't image - cropstyle rectangle
                  this.widget.icon
              : (widget.imageURL != "" && widget.imageURL != null)
                  ? CachedNetworkImage(
                      alignment: Alignment.center,
                      imageUrl: widget.imageURL,
                      fit: BoxFit.cover,
                    )
                  : Container()
          : Image.file(_imageFile),
      onTap: () async {
        await getImage().then((imagen) {
          _imageFile = imagen;
          widget.setImage(imagen);
        });
        setState(() {});
      },
    );
  }
}
