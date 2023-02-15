import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/models/my_models.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  var _chosenGender = Gender.Female;
  var _chosenColors = <String>[];
  var _student = false;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saveReader();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SharedPreferences"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
          ),
          for (var item in Gender.values)
            _buildRadioListTiles(describeEnum(item), item),
          for (var item in myColors.values) _builCheckBoxListTiles(item),
          SwitchListTile(
            title: Text("Are you student ?"),
            value: _student,
            onChanged: (bool student) {
              setState(() {
                _student = student;
              });
            },
          ),
          TextButton(onPressed: _saveData, child: Text("Save"))
        ],
      ),
    );
  }

  void _saveData() async {
    final _name = _nameController.text;
    final preferences = await SharedPreferences.getInstance();

    preferences.setString("name", _name);
    preferences.setBool("student", _student);
    preferences.setInt("gender", _chosenGender.index);
    preferences.setStringList("colors", _chosenColors);
    debugPrint(_chosenGender.index.toString() +
        "student" +
        _student.toString() + 
        "colors" + 
        _chosenColors.toString() +"name" + _name);
  }

void _saveReader()async{
  final preferences = await SharedPreferences.getInstance();
  _nameController.text = preferences.getString("name")??"";
  _student = preferences.getBool("student")?? false;
  _chosenGender = Gender.values[preferences.getInt("gender")?? 0];
  _chosenColors = preferences.getStringList("colors")??<String>[];

  setState(() {
    
  });
}

  Widget _buildRadioListTiles(String title, Gender gender) {
    return RadioListTile(
        title: Text(title),
        value: gender,
        groupValue: _chosenGender,
        onChanged: (Gender? selectedGender) {
          setState(() {
            _chosenGender = selectedGender!;
          });
        });
  }

  Widget _builCheckBoxListTiles(color) {
    return CheckboxListTile(
        title: Text(describeEnum(color)),
        value: _chosenColors.contains(describeEnum(color)),
        onChanged: (bool? value) {
          if (value == false) {
            _chosenColors.remove(describeEnum(color));
          } else {
            _chosenColors.add(describeEnum(color));
          }
          setState(() {
            debugPrint(_chosenColors.toString());
          });
        });
  }
}
