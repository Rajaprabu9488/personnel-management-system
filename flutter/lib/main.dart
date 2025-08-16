import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

bool login_in=false;
bool server_fail=false;
List<int> id=[];
List<String> name=[];
List<int> batch=[];
List<String> skills=[];
var final_data;
var all_skills=["Bomb Disposal","Engineering",'Surveillance',"Combat",'Weapons',"Intelligence","Cyber",'Medical',
            "Tactics","Strategy","Recon","Negotiation","Sniper","total"];

Future<void> login(String user,String pass) async {
  var url = Uri.parse('http://127.0.0.1:8000/login');
  
  final payload = jsonEncode({
    "user": user,
    "passwd": hashText(pass)
  });

  try {
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: payload,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      login_in=(data['check']==1)?true:false;
      server_fail=false;
      print(login_in);
    } else {
      print("❌ Failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("⚠️ Error: $e");
    server_fail=true;
    login_in=false;
    
  }
}

Future<void> threat_prediction(String threat_type,int severity,String location,int Civilian_count,int asset) async {
  var url = Uri.parse('http://127.0.0.1:8000/add-threat');
  
  final payload = jsonEncode({
    "threat_type": threat_type,
    "severity": severity,
    "location":location,
    "civilian_count":Civilian_count,
    "military_asset":asset
  });

  try {
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: payload,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      server_fail=false;
      id = List<int>.from(data["officer_id"]); // Corrected assignment
      name = List<String>.from(data["officer_name"]);
      batch = List<int>.from(data["batch"]);
      skills= List<String>.from(data["officer_skills"]);
      final_data=data;
      print(final_data);
    } else {
      print("❌ Failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("⚠️ Error: $e");
    server_fail=true;
    login_in=false;
    
  }
}
String hashText(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
void main() {
  // String n=hashText("143");
  // print(n);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In Box',
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}
class Error_page extends StatelessWidget{
  final String wiget;
  Error_page({required this.wiget});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (server_fail) 
        Text("Server cannot be reached!!")
      else if (!login_in && wiget=="login") 
        Text("⚠️ Error: Could not find the username or password"),
    ],
  ),
)
    );
  }
  
}
class SignInPage extends StatelessWidget {

  const SignInPage({super.key});

  
  @override
  Widget build(BuildContext context) {
      final username=TextEditingController();
      final password=TextEditingController();
      return Scaffold(

        backgroundColor: Colors.black87,
        body:Center(
          child: SingleChildScrollView(
              child:Center(
                child: ConstrainedBox(
                constraints: BoxConstraints(
                maxWidth: 350,
                maxHeight: 400,
                ),
                child:Container(
                  padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                      color: Colors.blue,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    ]
                    ),
                  child: Column(
                    children: [
                      Text("SIGN IN",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                      SizedBox(height: 24),
                      TextField(
                        controller:username,
                        decoration: InputDecoration(
                          labelText: "username",
                          border:OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Colors.red
                        ),
                      ),
                      SizedBox(height: 24),
                      TextField(
                        obscureText: true,
                        controller:password,
                        decoration: InputDecoration(
                          labelText: "password",
                          border:OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                          prefixIconColor: Colors.red
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () async {
                          if((username.text)=="" || (password.text)==""){
                            showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.info, color: Colors.blue),
                                    SizedBox(width: 10),
                                    Text("ALERT"),
                                    ],
                                    ),
                                    content: Text("enter the username and password"),
                                    actions: [
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                          }
                          else{
                          await login(username.text,password.text);
                          if(login_in){
                          Navigator.push(context, MaterialPageRoute(builder:(context)=> thread_details()));
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder:(context)=> Error_page(wiget:"login")));
                          }
                          }
                          
                        }, 
                        style:ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                            
                        ),
                      child: Text("submit")),
                    ],
                  )
                ),
                ),
                ),
            ),
        ),
        );
  }
}

class thread_details extends StatelessWidget{
  var threat_type="";
  final severity=TextEditingController();
  final location=TextEditingController();
  final military_asset=TextEditingController();
  final civilan_count=TextEditingController();

  thread_details({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        body:Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 450,
              maxWidth: 400,
            ),
            child: Column(
               children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color:Colors.blue,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  // TextField(
                  //   controller: threat_type,
                  //   decoration: InputDecoration(
                  //   border: OutlineInputBorder(),
                  //   label: Text("threat_type")
                  //   ),
                  // ),
                  DropdownButtonFormField<String>(
                    key: Key('threatTypeDropdown'),
                    decoration: InputDecoration(
                        labelText: 'threat_type',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    items:  ["riots", "cyber attack", "terrorist attack","bomb threat","natural disaster","military invasion","hijack"].map((String value) {
                            return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                            );
                    }).toList(), 
                    onChanged: (threads){
                      threat_type=threads.toString();
                    }),
                  SizedBox(height: 20),
                  TextField(
                    key: Key('severityField'),
                    controller: severity,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("severity")
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    key: Key('locationField'),
                    controller: location,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("location/area/place")
                    ),
                  ),SizedBox(height: 20),
                  TextField(
                    key: Key('civilianCountField'),
                    controller: civilan_count,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(" Civilian_count")
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    key: Key('militaryAssetField'),
                    controller: military_asset,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(" military_asset")
                    ),
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                      key: Key('submitButton'),
                      onPressed: () async {
                        if(int.tryParse(severity.text) == null || int.tryParse(military_asset.text) == null || (threat_type) == "" || (location.text)=="" || int.tryParse(civilan_count.text) == null){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.info, color: Colors.blue),
                                    SizedBox(width: 10),
                                    Text("ALERT"),
                                    ],
                                    ),
                                    content: Text("invalid input"),
                                    actions: [
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                        }
                        else{
                            showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                ),
                                title: Row(
                                  children: [
                                    SizedBox(),
                                    Icon(Icons.sync),
                                    SizedBox(width: 20),
                                    Text("LOADING....")
                                    ],
                                    ),
                                    
                                    );
                                  },
                                );
                            await threat_prediction(threat_type.toLowerCase(),int.parse(severity.text), location.text.toLowerCase(),int.parse(civilan_count.text), int.parse(military_asset.text));
                            if(server_fail){
                              Navigator.push(context, MaterialPageRoute(builder:(context)=> Error_page(wiget: "")));
                            }
                            else{
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>final_output()));
                            }
                        }
                      },
                      child: Text("submit")),
                  )
                ],
              ),
            )
          ],
            ),
            ),
        ),

      ),
    );

  }
}

class final_output extends StatelessWidget{
  const final_output({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text("LIST OF SQUARE"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            widthFactor: 70,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                height: 300,
                width: MediaQuery.of(context).size.width/1.1,
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                child: ListView.builder(
                  itemCount: all_skills.length,
                  itemBuilder: (context,index){
                    if(final_data[all_skills[index]].toString() != 'null'){
                    return Text(all_skills[index]+"  -  "+final_data[all_skills[index]].toString(),style: TextStyle(fontWeight: FontWeight.bold));
                    }
                    else{
                      return SizedBox();
                    };
                  }
                  ),
              ),
              SizedBox(height: 10),  
              DataTable(
                border: TableBorder.all(color: Colors.white24),
                columns: [
                  DataColumn(label: Text("officer_id",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("officer_name",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("batch",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("skills",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ],
                
                rows: List.generate(id.length, (index) => DataRow(
                cells: [
                    DataCell(Text(id[index].toString(), style: const TextStyle(color: Colors.white))),
                    DataCell(Text(name[index], style: const TextStyle(color: Colors.white))),
                    DataCell(Text(batch[index].toString(), style: const TextStyle(color: Colors.white))),
                    DataCell(Text(skills[index].toString(), style: const TextStyle(color: Colors.white))),
                ],
                )
                ),
                ),]
            ),
          )
        ),
      ),
    );
  }
}