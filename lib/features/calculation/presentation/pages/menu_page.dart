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
      appBar: AppBar(
        title: Text(F.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          sl<CalculationBloc>().add(const CalculationEventGetCalculation());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CalculationListCard(),
                const SizedBox(height: 34),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      if (F.uIFunctionality == UIFunctionality.camera) {
                        context.pushNamed("camera");
                      } else {
                        context.pushNamed('file_storage');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(F.uIFunctionality == UIFunctionality.camera
                            ? Icons.camera
                            : Icons.file_copy),
                        Text(F.uIFunctionality == UIFunctionality.camera
                            ? 'Take Image from Camera'
                            : 'Take Image from File System'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const DataSourceOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
