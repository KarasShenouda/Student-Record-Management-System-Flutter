import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Record Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> studentRecord = [];

  void addStudent(Student student) {
    setState(() {
      studentRecord.add(student);
    });
    Navigator.pop(context);
  }

  void updateStudent(String name, double newGrade, String newContactDetails) {
    setState(() {
      for (Student student in studentRecord) {
        if (student.name == name) {
          student.updateInformation(newGrade, newContactDetails);
        }
      }
    });
    Navigator.pop(context);
  }

  void deleteStudent(String name) {
    setState(() {
      studentRecord.removeWhere((student) => student.name == name);
    });
  }

  void searchStudent(BuildContext context, String name) {
    for (Student student in studentRecord) {
      if (student.name == name) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Student Found"),
            content: student.display(),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return;
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("Student not found!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Record Management System"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddStudentPage(addStudent: addStudent)),
                );
              },
              child: Text("Add Student"),
            ),
            SizedBox(height: 16.0), // إضافة مسافة بين الأزرار
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UpdateStudentPage(updateStudent: updateStudent)),
                );
              },
              child: Text("Update Student"),
            ),
            SizedBox(height: 16.0), // إضافة مسافة بين الأزرار
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchStudentPage(searchStudent: searchStudent)),
                );
              },
              child: Text("Search Student"),
            ),
            SizedBox(height: 16.0), // إضافة مسافة بين الأزرار
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayAllStudentsPage(
                          studentRecord: studentRecord,
                          deleteStudent: deleteStudent)),
                );
              },
              child: Text("Display All Students"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentPage extends StatefulWidget {
  final Function(Student) addStudent;

  AddStudentPage({required this.addStudent});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 0;
  double grade = 0.0;
  String contactDetails = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Grade"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => grade = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Contact Details"),
                onSaved: (value) => contactDetails = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.addStudent(Student(
                      name: name,
                      age: age,
                      grade: grade,
                      contactDetails: contactDetails,
                    ));
                  }
                },
                child: Text("Add Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateStudentPage extends StatefulWidget {
  final Function(String, double, String) updateStudent;

  UpdateStudentPage({required this.updateStudent});

  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double grade = 0.0;
  String contactDetails = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "New Grade"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => grade = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "New Contact Details"),
                onSaved: (value) => contactDetails = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.updateStudent(name, grade, contactDetails);
                  }
                },
                child: Text("Update Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchStudentPage extends StatefulWidget {
  final Function(BuildContext, String) searchStudent;

  SearchStudentPage({required this.searchStudent});

  @override
  _SearchStudentPageState createState() => _SearchStudentPageState();
}

class _SearchStudentPageState extends State<SearchStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                onSaved: (value) => name = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.searchStudent(context, name);
                  }
                },
                child: Text("Search Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayAllStudentsPage extends StatelessWidget {
  final List<Student> studentRecord;
  final Function(String) deleteStudent;

  DisplayAllStudentsPage(
      {required this.studentRecord, required this.deleteStudent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Students"),
      ),
      body: ListView.builder(
        itemCount: studentRecord.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: studentRecord[index].display(),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteStudent(studentRecord[index].name),
            ),
          );
        },
      ),
    );
  }
}

class Student {
  String name;
  int age;
  double grade;
  String contactDetails;

  Student({
    required this.name,
    required this.age,
    required this.grade,
    required this.contactDetails,
  });

  void updateInformation(double newGrade, String newContactDetails) {
    grade = newGrade;
    contactDetails = newContactDetails;
  }

  Widget display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: $name"),
        Text("Age: $age"),
        Text("Grade: $grade"),
        Text("Contact: $contactDetails"),
      ],
    );
  }
}
