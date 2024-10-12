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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      child: (state.image?.path.isNotEmpty ?? false)
                          ? Image.file(File(state.image!.path))
                          : Container(),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Oops!! ${state.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          sl<ImageBloc>().add(ImageEventPickImageFile());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh),
                            SizedBox(width: 10),
                            Text("Retry"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ImageStateImagePicked) {
              XFile image = state.image;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[300],
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Expression ${state.expression}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Result: ${state.result}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          sl<CalculationBloc>()
                              .add(CalculationEventSaveCalculation(
                            state.expression,
                            state.result,
                          ));
                        },
                        child: const Text("Save"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          sl<ImageBloc>().add(ImageEventPickImageFile());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh),
                            SizedBox(width: 10),
                            Text("Retry"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            } else {
              return Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: () {
                        sl<ImageBloc>().add(ImageEventPickImageCamera());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 10),
                          Text("Retry"),
                        ],
                      ),
                    )),
              );
            }
          },
        ),
      ),
    );
  }
}
