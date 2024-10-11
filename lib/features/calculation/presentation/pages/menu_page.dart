import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:calculation_ocr/features/calculation/presentation/widgets/calculation_list.dart';
import 'package:calculation_ocr/features/calculation/presentation/widgets/data_source_option.dart';
import 'package:calculation_ocr/flavors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          sl<CalculationBloc>().add(const CalculationEventGetCalculation());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const CalculationListWidget(),
              const DataSourceOption(),
              ElevatedButton(
                onPressed: () {
                  if (F.uIFunctionality == UIFunctionality.camera) {
                    context.pushNamed("camera");
                  } else {
                    context.pushNamed('file_storage');
                  }
                },
                child: Text(F.uIFunctionality == UIFunctionality.camera
                    ? 'Camera'
                    : 'File System'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
