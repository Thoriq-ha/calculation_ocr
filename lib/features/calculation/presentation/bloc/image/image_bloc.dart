import 'package:bloc/bloc.dart';
import 'package:calculation_ocr/core/utils/get_image_permission.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_expressions/math_expressions.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImagePicker imagePicker;

  ImageBloc({required this.imagePicker}) : super(ImageStateEmpty()) {
    on<ImageEventPickImageCamera>((event, emit) async {
      emit(ImageStateLoading());

      try {
        if (!await getPermission()) {
          emit(ImageStateError("Permission denied"));
          return;
        }

        final imageFromCamera =
            await imagePicker.pickImage(source: ImageSource.camera);
        if (imageFromCamera == null) {
          emit(ImageStateEmpty());
          return;
        }

        String text = await _recognizedText(imageFromCamera.path);
        if (text == "") {
          emit(ImageStateError("Invalid recognized Text",
              image: imageFromCamera));
          return;
        }

        String expression = _preprocessInput(text);
        if (expression == "") {
          emit(ImageStateError("Text Value Invalid when Preprocessing",
              image: imageFromCamera));
          return;
        }

        String result = _calculateExpression(expression);
        if (result == "") {
          emit(ImageStateError("Invalid calculate", image: imageFromCamera));
          return;
        }

        emit(ImageStateImagePicked(imageFromCamera, expression, result));
      } catch (e) {
        emit(ImageStateError(e.toString()));
      }
    });
    on<ImageEventPickImageFile>((event, emit) async {
      emit(ImageStateLoading());

      try {
        if (!await getPermission()) {
          emit(ImageStateError("Permission denied"));
          return;
        }

        final imageFromGallery =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (imageFromGallery == null) {
          emit(ImageStateEmpty());
          return;
        }

        String text = await _recognizedText(imageFromGallery.path);
        if (text == "") {
          emit(ImageStateError("Invalid recognized", image: imageFromGallery));
          return;
        }

        String expression = _preprocessInput(text);
        if (expression == "") {
          emit(ImageStateError("Invalid preprocess", image: imageFromGallery));
          return;
        }

        String result = _calculateExpression(expression);
        if (result == "") {
          emit(ImageStateError("Invalid calculate", image: imageFromGallery));
          return;
        }
        emit(ImageStateImagePicked(imageFromGallery, expression, result));
      } catch (e) {
        emit(ImageStateError(e.toString()));
      }
    });
  }

  Future<String> _recognizedText(String path) async {
    try {
      final InputImage inputImage = InputImage.fromFilePath(path);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception("Invalid recognized");
    }
  }

  String _preprocessInput(String input) {
    String result = '';

    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      if (RegExp(r'[0-9]').hasMatch(char)) {
        result += char;
      } else if (RegExp(r'[+\-*/]').hasMatch(result)) {
        if (result.isNotEmpty &&
            RegExp(r'[+\-*/]').hasMatch(result[result.length - 1])) {
          return "";
        }
        return result;
      } else if (RegExp(r'[+\-*/]').hasMatch(char)) {
        result += char;
      }
    }

    return result;
  }

  String _calculateExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      return eval.toString();
    } catch (e) {
      return "";
    }
  }
}
