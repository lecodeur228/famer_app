import 'package:famer_map/widgets/input_widget.dart';
import 'package:famer_map/widgets/map_picker_map.dart';
import 'package:flutter/material.dart';

class AddFamer extends StatefulWidget {
  const AddFamer({super.key});

  @override
  State<AddFamer> createState() => _AddFamerState();
}

class _AddFamerState extends State<AddFamer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name_controller = TextEditingController();
  TextEditingController desc_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Ajouter une  ferme",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                InputWidget(
                  error: "le nom est obligatoire",
                  placeholder: "Nom de la ferme",
                  lines: 1,
                  controller: name_controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputWidget(
                  error: "Description obligatoire",
                  placeholder: "description de la ferme",
                  lines: 4,
                  controller: desc_controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    print("ok!");
                    if (_formKey.currentState?.validate() ?? false) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MapPickerDialog();
                        },
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Ajouter la localisation",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
