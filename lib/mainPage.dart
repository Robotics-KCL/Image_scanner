import 'package:flutter/material.dart';
import 'package:image_scanner/addProfile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_scanner/ProfileInstance.dart';
import 'package:image_scanner/editProfile.dart';


class MainPageWidget extends StatefulWidget {

 @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPageWidget();
  }

}


class _MainPageWidget extends State<MainPageWidget>{

  List<ProfileInstance> data = [];

   @override
  void initState() {
    // TODO: implement initState

     DatabaseReference database_ref = FirebaseDatabase.instance.reference();
     database_ref.child("kcl_robotics_attendance_with_time").once().then((DataSnapshot snap){
       var keys = snap.value.keys;
       var data_instance = snap.value;

       for (var key in keys){

         ProfileInstance tmp = new ProfileInstance(
             data_instance[key]['name'],
             data_instance[key]['course'],
             data_instance[key]['day'],
             data_instance[key]['month'],
         );
         setState(() {
           this.data.add(tmp);
         });

       }

       print("Length"+this.data.length.toString());
       print("running here1 ");

     });



     super.initState();

  }



  @override
   Widget build(BuildContext context) {


       print("Hello there, it's running ");
       return new MaterialApp(
           theme: ThemeData(
               primaryColor: Color.fromARGB(255, 21, 140, 134),
               accentColor: Colors.white,
                ),
           title: "home_page",
           home: new Scaffold(
             backgroundColor: Color.fromARGB(255, 176, 244, 241),
             drawer: _createDrawer(),
             appBar: new AppBar(
               title: new Text("Home Page"),
               actions: <Widget>[
                 new FlatButton(onPressed: null, child: null)
               ],
             ),
             body: new Container(
               child: this.data.length == 0 ? new Text("Downloading") :
               new ListView.builder(itemBuilder: (_,index){

                 return createCard(this.data[index].name, this.data[index].course,this.data[index].day,this.data[index].month,index);


               }, itemCount: this.data.length),
             ),

           )
       );
    }


  Widget _makeList(String name, String course,String day, String month){

    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 5.0),
      title: Text(name),
      leading: Container(
        padding: EdgeInsets.only(right: 10.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0,color: Colors.black, style: BorderStyle.solid)
          ),
        ),
        child: new Column(
          children: <Widget>[
            new Text(day),
            new Text(month,style: TextStyle(
              fontWeight: FontWeight.bold
            ),)
          ],
        ),
      ),

      subtitle: Text(course),
    );
  }




    Widget createCard(String name, String course,String day, String month,int index){

         return new GestureDetector(
           child: Card(
             elevation: 5.0,
             margin: new EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
             child: new Container(
               decoration: BoxDecoration(),
               child: _makeList(name,course,day,month),
             ),

           ),
           onTap: (){
             Navigator.push(context,
             MaterialPageRoute(builder: (BuildContext context) => EditProfilePage(store: this.data[index])));
           },
         );

         

    }


    Widget _createDrawer(){

      return new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('images/Labelled_logo.png'),
              decoration: BoxDecoration(
                color: Colors.white
              ),
            ),

            ListTile(
              title: Text("Add New Profile"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddProfilePage()));
              },
            ),

            ListTile(
              title: Text("Refresh "),
              onTap: (){
                 _updateInfo();

              },
            ),

            ListTile(
              title: Text("Setting"),
              onTap: (){
                //do nothing for now


              },
            )


          ],
        )
      );



    }



    void _updateInfo(){
      DatabaseReference database_ref = FirebaseDatabase.instance.reference();
      database_ref.child("kcl_robotics_attendance_with_time").once().then((DataSnapshot snap){
        var keys = snap.value.keys;
        var data_instance = snap.value;
        List<ProfileInstance> tmp_list = [];

        for (var key in keys){

          ProfileInstance tmp = new ProfileInstance(
            data_instance[key]['name'],
            data_instance[key]['course'],
            data_instance[key]['day'],
            data_instance[key]['month'],
          );


          tmp_list.add(tmp);

        }

        setState(() {
          this.data = tmp_list;
        });


      });
    }








}









