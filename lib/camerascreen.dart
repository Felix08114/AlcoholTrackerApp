import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:camera/camera.dart';
import 'package:myalcoholtrackerapp/imagepreviewscreen.dart';

class camerascreen extends StatefulWidget {
  const camerascreen({super.key});

  @override
  State<camerascreen> createState() => _camerascreenState();
}

class _camerascreenState extends State<camerascreen> {
 late List<CameraDescription> cameras; // all cameras on device
 late CameraController _controller;
 late Future<bool> _task;

 @override
  void initState() {
   _task = cameraSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _task,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Stack(
              children: [
                Container(
                  height: double.infinity,
                  child: CameraPreview(_controller),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white.withOpacity(.3),
                    width: double.infinity,
                    height: 100,
                    child: IconButton(
                        onPressed: () async {
                          if(!_controller.value.isInitialized){
                            return;
                          }
                          if(!_controller.value.isInitialized){
                            return;
                          }
                          try{
                            await _controller.setFocusMode(FocusMode.locked);
                            XFile picture = await _controller.takePicture();
                            await _controller.setFocusMode(FocusMode.locked);
                            await Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => imagepreviewscreen(picture: picture)),);
                          } on CameraException catch (e) {
                            print(e);
                            return;
                          }
                        },
                        icon: Icon(
                            Icons.camera_alt,
                        ),
                      iconSize: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }
          else {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  value: 40,
                  strokeWidth: 10,
                )
            );
          }
        },
      ),
      bottomNavigationBar: bottomnav(selectedIndex: 2,),
    );
  }

 Future<bool> cameraSetup() async{
   cameras = await availableCameras();
       _controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

   _controller.initialize().then((value) {
     if(!mounted){return true;}
     setState(() {

     });
   }).catchError(
       (Object e) {
         if (e is CameraException) {
           switch (e.code) {
             case "CameraAccessDenied":
               print("Camera access denied");
               break;
             default:
               print(e.description);
               break;
           }
         }
         return false;
       });
   return false;
 }
}