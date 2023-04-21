import 'dart:io';

import 'package:flutter/material.dart';
import 'package:futsta/data/repositories/opponents.dart';

import '../data/models/opponent.dart';
import '../data/repositories/matches.dart';
import '../utils/helpers.dart';

class AddMatchScreen extends StatefulWidget {
  final MatchRepository matchRepository = MatchRepository();

  AddMatchScreen({super.key});

  @override
  AddMatchScreenState createState() => AddMatchScreenState();
}

class AddMatchScreenState extends State<AddMatchScreen> {
  List<Opponent> _opponents = [];
  dynamic _selectedOpponent;
  DateTime _selectedDate = DateTime.now();
  bool _isHomeTeam = true;
  @override
  void initState() {
    super.initState();
    _loadOpponents();
  }

  Future<void> _loadOpponents() async {
    try {
      devPrint('Starting to load opponents...');
      OpponentRepository repo = OpponentRepository();
      List<Opponent> opponents = await repo.get();
      setState(() {
        _opponents = opponents;
      });
      devPrint('Loaded ${opponents.length} opponents.');
    } catch (error) {
      setState(() {
        _opponents = [];
      });
      devPrint('Failed to load opponents: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Match'),
      ),
      body: Column(
        children: <Widget>[
          selectOpponentButton(),
          const SizedBox(height: 20),
          selectDateButton(context),
          const SizedBox(height: 20),
          selectHomeAwaySwitch(),
          submitButton(context),

          // Add other form fields and a submit button here, as needed.
        ],
      ),
    );
  }

  Padding selectOpponentButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField(
        value: _selectedOpponent,
        items: _opponents.map((opponent) {
          return DropdownMenuItem(
            value: opponent,
            child: Text(opponent.name, textAlign: TextAlign.center),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedOpponent = value;
          });
        },
        hint: const Text('Select Opponent'),
      ),
    );
  }

  ElevatedButton selectDateButton(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          // ignore: unnecessary_null_comparison
          _selectedDate == null
              ? 'Select Date'
              : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
        );
        if (pickedDate != null && pickedDate != _selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }

  Widget selectHomeAwaySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Home', // Display 'Home' on the left side
          style: TextStyle(fontSize: 16.0),
        ),
        Switch(
          value: !_isHomeTeam, // Use !_isHomeTeam instead of _isHomeTeam
          onChanged: (value) {
            setState(() {
              _isHomeTeam = !value; // Use !value instead of value
            });
          },
          activeTrackColor: Colors.orangeAccent,
          activeColor: Colors.orange,
          inactiveTrackColor: Colors.lightGreenAccent,
          inactiveThumbColor: Colors.green,
        ),
        const Text(
          'Away', // Display 'Away' on the right side
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Expanded submitButton(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SizedBox(
            width: 250,
            height: 38,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(30),
              ),
              child: const Text('Submit'),
              onPressed: () async {
                try {
                  await widget.matchRepository.add(
                      opponent: _selectedOpponent,
                      date: _selectedDate,
                      isHome: _isHomeTeam,
                      context: context);
                } on HttpException catch (error) {
                  showError(error, context);
                } on TypeError {
                  showError(Exception('Please select an opponent'), context);
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true);
              },
            ),
          ),
        ),
      ),
    );
  }
}
