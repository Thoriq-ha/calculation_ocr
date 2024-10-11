import 'dart:io';

import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/image/image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class FileStoragePage extends StatelessWidget {
  const FileStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image FileStorage"),
      ),
      body: BlocListener<CalculationBloc, CalculationState>(
        bloc: sl<CalculationBloc>(),
        listener: (context, state) {
          if (state is CalculationStateSaved) {
            sl<CalculationBloc>().add(const CalculationEventGetCalculation());
            context.pop();
          }
        },
        child: BlocBuilder<ImageBloc, ImageState>(
          bloc: sl<ImageBloc>()..add(ImageEventPickImageFile()),
          builder: (context, state) {
            if (state is ImageStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ImageStateError) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (state.image?.path.isNotEmpty ?? false)
                        ? Image.file(File(state.image!.path))
                        : Container(),
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        sl<ImageBloc>().add(ImageEventPickImageFile());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (state is ImageStateImagePicked) {
              XFile image = state.image;
              return Column(
                children: [
                  Image.file(File(image.path)),
                  Text("Expression: ${state.expression}"),
                  Text("Result: ${state.result}"),
                  ElevatedButton(
                    onPressed: () {
                      sl<CalculationBloc>().add(CalculationEventSaveCalculation(
                        state.expression,
                        state.result,
                      ));
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("EMPTY DATA"),
              );
            }
          },
        ),
      ),
    );
  }
}
