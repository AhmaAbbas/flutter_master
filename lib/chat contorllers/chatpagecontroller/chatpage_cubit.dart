
import 'package:chat_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/messegmodel.dart';
import 'chatpage_states.dart';


class ChatCubit extends Cubit<ChatStats>{
  ChatCubit():super(InitialChatStats());
  void sendmessege({required String messege,required String reciverid})async{
    MessageModel messageModel=MessageModel(
        id: Constants.userid,content:messege,date: DateTime.now().toString() );
    await FirebaseFirestore.instance.collection("users").doc(Constants.userid)
        .collection("Chats").doc(reciverid).collection("Messeges").add(messageModel.tojson());
    await FirebaseFirestore.instance.collection("users").doc(reciverid)
        .collection("Chats").doc(Constants.userid).collection("Messeges").add(messageModel.tojson());
    emit(SuccessSendMessege());
  }
  List<MessageModel> messages = [];
  void getMessages({required String receiverID})async{
    emit(GetMessagesLoadingState());
    print("ahmed");
    try{
      await FirebaseFirestore.instance.collection('users').doc(Constants.userid).collection('Chats')
          .doc(receiverID).collection('Messeges').orderBy('date').snapshots().listen((value){
        messages.clear();
        print("ahmed");
        for( var item in value.docs )
        {
          print("ahmed");
          print("item${item.data()}");
          messages.add(MessageModel.fromjson(item.data()));
        }
        print("ahmed");
        print("messages.length ${messages.length}");

        emit(GetMessagesSuccessState(messeges: messages));
      });
    } on FirebaseException catch(e){
      print("error${e.toString()}");
    }
  }
}