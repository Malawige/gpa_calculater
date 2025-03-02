import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'degree_data.dart';
import 'colors.dart'; 

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String? selectedUniversity;
  String? selectedBatch;
  String? selectedDegreeProgram;
  late List<Map<String, dynamic>> coreCourses;
  late List<Map<String, dynamic>> electiveCourses;
  final List<String> grades = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F'];
  final List<TextEditingController> coreGradeControllers = [];
  final List<TextEditingController> electiveGradeControllers = [];
  final List<bool> electiveSelected = [];
  
  // Custom modules
  final List<Map<String, dynamic>> customModules = [];
  final List<TextEditingController> customModuleControllers = [];
  final List<int?> customCredits = []; // Store selected credits
  final List<TextEditingController> customGradeControllers = [];

  @override
  void initState() {
    super.initState();
    coreCourses = [];
    electiveCourses = [];
  }

  void updateCourses() {
    if (selectedDegreeProgram != null) {
      coreCourses = degreePrograms[selectedDegreeProgram]!['coreModules']!;
      electiveCourses = degreePrograms[selectedDegreeProgram]!['electiveModules']!;
      
      coreGradeControllers.clear();
      for (int i = 0; i < coreCourses.length; i++) {
        coreGradeControllers.add(TextEditingController());
      }

      electiveGradeControllers.clear();
      electiveSelected.clear();
      for (int i = 0; i < electiveCourses.length; i++) {
        electiveGradeControllers.add(TextEditingController());
        electiveSelected.add(false);
      }

      setState(() {});
    }
  }

  void calculateGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    // Calculate for core courses
    for (int i = 0; i < coreCourses.length; i++) {
      int credit = coreCourses[i]['credits'];
      String grade = coreGradeControllers[i].text;
      double gradePoint = getGradePoint(grade);
      totalPoints += credit * gradePoint;
      totalCredits += credit;
    }

    // Calculate for selected elective courses
    for (int i = 0; i < electiveCourses.length; i++) {
      if (electiveSelected[i]) {
        int credit = electiveCourses[i]['credits'];
        String grade = electiveGradeControllers[i].text;
        double gradePoint = getGradePoint(grade);
        totalPoints += credit * gradePoint;
        totalCredits += credit;
      }
    }

    // Calculate for custom modules
    for (int i = 0; i < customModules.length; i++) {
      int credit = customCredits[i] ?? 0; // Use selected credit
      String grade = customGradeControllers[i].text;
      double gradePoint = getGradePoint(grade);
      totalPoints += credit * gradePoint;
      totalCredits += credit;
    }

    double gpa = totalCredits > 0 ? totalPoints / totalCredits : 0;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(gpa: gpa)),
    );
  }

  double getGradePoint(String grade) {
    switch (grade) {
      case 'A+': return 4.0;
      case 'A': return 4.0;
      case 'A-': return 3.7;
      case 'B+': return 3.3;
      case 'B': return 3.0;
      case 'B-': return 2.7;
      case 'C+': return 2.3;
      case 'C': return 2.0;
      case 'C-': return 1.7;
      case 'D+': return 1.3;
      case 'D': return 1.0;
      case 'D-': return 0.7;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }

  void addCustomModule() {
    setState(() {
      customModules.add({'name': '', 'credits': 0});
      customModuleControllers.add(TextEditingController());
      customCredits.add(null); // Default to null (no selection)
      customGradeControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Input Grades')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background1.png'), 
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05, vertical: screenSize.height * 0.05),
        child: ListView(
          children: [
            // Header spacing based on platform
            SizedBox(height: screenSize.width < 600 ? 120 : 70), // 120 for mobile, 70 for web

            // Header for the Input Screen
            Text(
              'GPA CALCULATOR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20), // Add some space below the header

            // University Selection
            DropdownButton<String>(
              hint: Text('Select University', style: TextStyle(color: AppColors.navyBlue)),
              value: selectedUniversity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedUniversity = newValue;
                  selectedBatch = null; // Reset batch and degree when university changes
                  selectedDegreeProgram = null; // Reset degree program
                  coreCourses.clear();
                  electiveCourses.clear();
                  coreGradeControllers.clear();
                  electiveGradeControllers.clear();
                  electiveSelected.clear();
                  customModules.clear();
                  customModuleControllers.clear();
                  customCredits.clear();
                  customGradeControllers.clear();
                });
              },
              items: ['SLTC', 'Other'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: AppColors.navyBlue)),
                );
              }).toList(),
            ),

            SizedBox(height: 10), // Space between dropdowns

            // Batch Selection (only for SLTC)
            if (selectedUniversity == 'SLTC') ...[
              DropdownButton<String>(
                hint: Text('Select Batch', style: TextStyle(color: AppColors.navyBlue)),
                value: selectedBatch,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBatch = newValue;
                    selectedDegreeProgram = null; // Reset degree program when batch changes
                    coreCourses.clear(); // Clear core courses
                    electiveCourses.clear(); // Clear elective courses
                    coreGradeControllers.clear(); // Clear core grade controllers
                    electiveGradeControllers.clear(); // Clear elective grade controllers
                    electiveSelected.clear(); // Clear elective selections
                  });
                },
                items: batches.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: AppColors.navyBlue)),
                  );
                }).toList(),
              ),

              SizedBox(height: 10), // Space between dropdowns

              // Degree Program Selection
              Container(
                width: screenSize.width * 0.8, // Adjust the width as needed
                child: DropdownButton<String>(
                  hint: Text('Select Degree Program', style: TextStyle(color: AppColors.navyBlue)),
                  value: selectedDegreeProgram,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDegreeProgram = newValue;
                      updateCourses(); // Update courses when degree program changes
                    });
                  },
                  isExpanded: true, // This makes the dropdown take the full width of the container
                  items: degreePrograms.keys
                      .where((key) => key.endsWith(selectedBatch?.split(' ')[1] ?? ''))
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: AppColors.navyBlue)),
                    );
                  }).toList(),
                ),
              ),
            ] else if (selectedUniversity == 'Other') ...[
              SizedBox(height: 20), // Space before "Add Your Modules"

              // Custom Modules Section
              Text('Add Your Modules', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navyBlue)),
              ...List.generate(customModules.length, (index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 6, // space for Course column
                      child: TextField(
                        controller: customModuleControllers[index],
                        decoration: InputDecoration(labelText: 'Module'),
                        onChanged: (value) {
                          customModules[index]['name'] = value;
                        },
                      ),
                    ),
                    SizedBox(width: 10), // Space between columns
                    Expanded(
                      flex: 2, // space for Credits column
                      child: DropdownButton<int?>(
                        hint: Text('Credit', style: TextStyle(color: AppColors.navyBlue)),
                        value: customCredits[index],
                        onChanged: (int? newValue) {
                          setState(() {
                            customCredits[index] = newValue;
                          });
                        },
                        items: [2, 3, 4].map<DropdownMenuItem<int?>>((int value) {
                          return DropdownMenuItem<int?>(
                            value: value,
                            child: Text(value.toString(), style: TextStyle(color: AppColors.navyBlue)),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 10), // Space between columns
                    Expanded(
                      flex: 2, // space for Grade column
                      child: DropdownButton<String>(
                        hint: Text('Grade', style: TextStyle(color: AppColors.navyBlue)),
                        value: customGradeControllers[index].text.isEmpty ? null : customGradeControllers[index].text,
                        onChanged: (String? newValue) {
                          setState(() {
                            customGradeControllers[index].text = newValue!;
                          });
                        },
                        items: grades.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: AppColors.navyBlue)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 20), // Space after the Add Module button
              Center( // Center the button
                child: ElevatedButton(
                  onPressed: addCustomModule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan4, // Button color
                  ),
                  child: Text('Add Module', style: TextStyle(color: AppColors.white)),
                ),
              ),
              SizedBox(height: 20), // Add space before the Calculate GPA button
            ],

            SizedBox(height: 30), // Space before Core Courses

            // Only show Core Courses and Elective Courses if SLTC is selected and a degree program is chosen
            if (selectedUniversity == 'SLTC' && selectedDegreeProgram != null) ...[
              // Core Courses
              Text('Core Modules', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navyBlue)),
              ...List.generate(coreCourses.length, (index) {
                return ListTile(
                  title: Text('${coreCourses[index]['name']} (${coreCourses[index]['credits']} credits)', style: TextStyle(color: AppColors.navyBlue)),
                  trailing: DropdownButton<String>(
                    hint: Text('Grade', style: TextStyle(color: AppColors.navyBlue)),
                    value: coreGradeControllers[index].text.isEmpty ? null : coreGradeControllers[index].text,
                    onChanged: (String? newValue) {
                      setState(() {
                        coreGradeControllers[index].text = newValue!;
                      });
                    },
                    items: grades.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: AppColors.navyBlue)),
                      );
                    }).toList(),
                  ),
                );
              }),

              SizedBox(height: 30), // Space before Elective Courses

              // Elective Courses
              Text('Elective Modules', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navyBlue)),
              ...List.generate(electiveCourses.length, (index) {
                return ListTile(
                  title: Text('${electiveCourses[index]['name']} (${electiveCourses[index]['credits']} credits)', style: TextStyle(color: AppColors.navyBlue)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: electiveSelected[index],
                        onChanged: (bool? value) {
                          setState(() {
                            electiveSelected[index] = value!;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        hint: Text('Grade', style: TextStyle(color: AppColors.navyBlue)),
                        value: electiveGradeControllers[index].text.isEmpty ? null : electiveGradeControllers[index].text,
                        onChanged: electiveSelected[index] ? (String? newValue) {
                          setState(() {
                            electiveGradeControllers[index].text = newValue!;
                          });
                        } : null, // Disable if not selected
                        items: grades.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: AppColors.navyBlue)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
            ],

            // Calculate GPA Button - Only show if there are modules added
            if (coreCourses.isNotEmpty || electiveCourses.any((e) => electiveSelected[electiveCourses.indexOf(e)]) || customModules.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: calculateGPA,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan5, // Button color
                  ),
                  child: Text('Calculate GPA', style: TextStyle(color: AppColors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}