import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';

class KeicyFireStoreDataProvider {
  static KeicyFireStoreDataProvider _instance = KeicyFireStoreDataProvider();
  static KeicyFireStoreDataProvider get instance => _instance;

  final RegExp regExp = RegExp(r'(FirebaseException\()|(FirebaseError)|([(:,.)])');

  Future<Map<String, dynamic>> addDocument({@required String? path, @required Map<String, dynamic>? data}) async {
    try {
      data!["ts"] = FieldValue.serverTimestamp();
      data["createAt"] = FieldValue.serverTimestamp();
      data["updateAt"] = FieldValue.serverTimestamp();
      var ref = await FirebaseFirestore.instance.collection(path!).add(data);
      data['id'] = ref.id;
      var res = await updateDocument(
        path: path,
        id: ref.id,
        data: {'id': ref.id},
        changeUpdateAt: false,
      );
      if (res["success"]) {
        return {"success": true, "data": res["data"]};
      } else {
        return {"success": false, "errorCode": "404", "message": "Firestore Error"};
      }
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      List<String> list = e.toString().split(regExp);
      String message = list[2];
      String errorCode;
      if (e.toString().contains("FirebaseError")) {
        errorCode = list[4];
      } else {
        errorCode = list[2];
      }
      return {"success": false, "errorCode": errorCode, "message": message};
    }
  }

  Future<Map<String, dynamic>> updateDocument({
    @required String? path,
    @required String? id,
    @required Map<String, dynamic>? data,
    @required bool? changeUpdateAt,
  }) async {
    try {
      data!["ts"] = FieldValue.serverTimestamp();
      if (changeUpdateAt!) data["updateAt"] = FieldValue.serverTimestamp();
      await FirebaseFirestore.instance.collection(path!).doc(id).update(data);
      var result = await getDocumentByID(path: path, id: id!);
      return {"success": true, "data": result["data"]};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> setDocument({
    @required String? path,
    @required String? id,
    @required Map<String, dynamic>? data,
    @required bool? changeUpdateAt,
    bool merge = true,
    List<Object>? mergeFields = const [],
  }) async {
    SetOptions setOptions = SetOptions(merge: merge, mergeFields: mergeFields);
    data!["ts"] = FieldValue.serverTimestamp();
    if (changeUpdateAt!) data["updateAt"] = FieldValue.serverTimestamp();
    try {
      await FirebaseFirestore.instance.collection(path!).doc(id).set(data, setOptions);
      return {"success": true};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteDocument({@required String? path, @required String? id}) async {
    try {
      await FirebaseFirestore.instance.collection(path!).doc(id).delete();
      return {"success": true};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> isDocExist({@required String? path, @required String? id}) async {
    try {
      final DocumentSnapshot docSnapShot = await FirebaseFirestore.instance.collection(path!).doc(id).get();
      return {"success": docSnapShot.exists};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getDocumentByID({@required String? path, @required String? id}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection(path!).doc(id).get();
      Map<String, dynamic> data = documentSnapshot.data()!;
      data["id"] = documentSnapshot.id;
      return {"success": true, "data": data};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Stream<Map<String, dynamic>>? getDocumentStreamByID({@required String? path, @required String? id}) {
    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>> stream = FirebaseFirestore.instance.collection(path!).doc(id).snapshots();
      return stream.map((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data()!;
        data["id"] = documentSnapshot.id;
        return data;
      });
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getDocumentsData({
    @required String? path,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) async {
    CollectionReference<Map<String, dynamic>> ref;
    Query<Map<String, dynamic>> query;
    try {
      ref = FirebaseFirestore.instance.collection(path!);
      query = ref;
      if (wheres != null) query = _getQuery(query, wheres);
      if (orderby != null) query = _getOrderby(query, orderby);
      if (limit != null) query = query.limit(limit);
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      List<Map<String, dynamic>> data = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        var tmp = snapshot.docs.elementAt(i).data();
        tmp["id"] = snapshot.docs.elementAt(i).id;
        data.add(tmp);
      }
      return {"success": true, "data": data};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Stream<List<Map<String, dynamic>>>? getDocumentsStream({
    @required String? path,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) {
    try {
      CollectionReference<Map<String, dynamic>> ref;
      Query<Map<String, dynamic>> query;
      ref = FirebaseFirestore.instance.collection(path!);
      query = ref;
      if (wheres != null) query = _getQuery(query, wheres);
      if (orderby != null) query = _getOrderby(query, orderby);
      if (limit != null) query = query.limit(limit);
      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((document) {
          Map<String, dynamic> data = document.data();
          data["id"] = document.id;
          return data;
        }).toList();
      });
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_firestore_data_provider",
        level: LogLevel.ERROR,
        subTag: "getDocumentsStream",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<Map<String, dynamic>> getDocumentsLength({
    @required String? path,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) async {
    CollectionReference<Map<String, dynamic>> ref;
    Query<Map<String, dynamic>> query;

    try {
      ref = FirebaseFirestore.instance.collection(path!);
      query = ref;
      if (wheres != null) query = _getQuery(query, wheres);
      if (orderby != null) query = _getOrderby(query, orderby);
      if (limit != null) query = query.limit(limit);
      QuerySnapshot snapshot = await query.get();
      return {"success": true, "data": snapshot.docs.length};
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Stream<int>? getDocumentsLengthStream({
    @required String? path,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orderby,
    int? limit,
  }) {
    try {
      CollectionReference<Map<String, dynamic>> ref;
      Query<Map<String, dynamic>> query;
      ref = FirebaseFirestore.instance.collection(path!);
      query = ref;
      if (wheres != null) query = _getQuery(query, wheres);
      if (orderby != null) query = _getOrderby(query, orderby);
      if (limit != null) query = query.limit(limit);
      return query.snapshots().map((snapshot) {
        return snapshot.docs.length;
      });
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_firestore_data_provider",
        level: LogLevel.ERROR,
        subTag: "getDocumentsLengthStream",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return null;
    }
  }

  Future getDocumentsDataWithChilCollection({
    @required String? parentCollectionName,
    @required String? childCollectionName,
    List<Map<String, dynamic>>? parentWheres,
    List<Map<String, dynamic>>? parentOrderby,
    int? parentLimit,
    List<Map<String, dynamic>>? childWheres,
    List<Map<String, dynamic>>? childOrderby,
    int? childLimit,
  }) async {
    CollectionReference<Map<String, dynamic>> parentRef;
    Query<Map<String, dynamic>> parentQuery;
    QuerySnapshot<Map<String, dynamic>> parentSnapshot;
    CollectionReference<Map<String, dynamic>> childRef;
    Query<Map<String, dynamic>> childQuery;
    QuerySnapshot<Map<String, dynamic>> childSnapshot;
    List<Map<String, dynamic>> data = [];
    try {
      parentRef = FirebaseFirestore.instance.collection(parentCollectionName!);
      parentQuery = parentRef;
      if (parentWheres != null) parentQuery = _getQuery(parentQuery, parentWheres);
      if (parentOrderby != null) parentQuery = _getOrderby(parentQuery, parentOrderby);
      if (parentLimit != null) parentQuery = parentQuery.limit(parentLimit);
      parentQuery.snapshots().map((snapshot) async {
        return Future.wait(snapshot.docs.map((document) async {
          Map<String, dynamic> parentData = document.data();
          parentData["id"] = document.id;
          childRef = document.reference.collection(childCollectionName!);
          childQuery = childRef;
          if (childWheres != null) childQuery = _getQuery(childQuery, childWheres);
          if (childOrderby != null) childQuery = _getOrderby(childQuery, childOrderby);
          if (childLimit != null) childQuery = childQuery.limit(childLimit);
          try {
            childSnapshot = await childQuery.get();
            for (var j = 0; j < childSnapshot.docs.length; j++) {
              Map<String, dynamic> childData = childSnapshot.docs.elementAt(j).data();
              childData["id"] = childSnapshot.docs.elementAt(j).id;
              data.add({"parent": parentData, "child": childData});
            }
          } catch (e) {
            FlutterLogs.logThis(
              tag: "keicy_firestore_data_provider",
              level: LogLevel.ERROR,
              subTag: "getDocumentsDataWithChillCollection",
              exception: e is Exception ? e : null,
              error: e is Error ? e : null,
              errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
            );
          }
          return {"success": true, "data": data};
        }));
      });

      parentSnapshot = await parentQuery.get();
      for (var i = 0; i < parentSnapshot.docs.length; i++) {}
    } on FirebaseException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } on PlatformException catch (e) {
      return {"success": false, "errorCode": e.code, "message": e.message};
    } catch (e) {
      return {"success": false, "errorCode": 500, "message": e.toString()};
    }
  }

  Stream<List<Stream<List<Map<String, dynamic>>>>>? getDocumentsStreamWithChildCollection({
    @required String? parentCollectionName,
    @required String? childCollectionName,
    List<Map<String, dynamic>>? parentWheres,
    List<Map<String, dynamic>>? parentOrderby,
    int? parentLimit,
    List<Map<String, dynamic>>? childWheres,
    List<Map<String, dynamic>>? childOrderby,
    int? childLimit,
  }) {
    CollectionReference<Map<String, dynamic>> parentRef;
    Query<Map<String, dynamic>> parentQuery;
    CollectionReference<Map<String, dynamic>> childRef;
    Query<Map<String, dynamic>> childQuery;
    try {
      parentRef = FirebaseFirestore.instance.collection(parentCollectionName!);
      parentQuery = parentRef;
      if (parentWheres != null) parentQuery = _getQuery(parentQuery, parentWheres);
      if (parentOrderby != null) parentQuery = _getOrderby(parentQuery, parentOrderby);
      if (parentLimit != null) parentQuery = parentQuery.limit(parentLimit);
      return parentQuery.snapshots().map((parentSnapshot) {
        return parentSnapshot.docs.map((parentDocument) {
          Map<String, dynamic> parentData = parentDocument.data();
          parentData["id"] = parentDocument.id;
          childRef = parentDocument.reference.collection(childCollectionName!);
          childQuery = childRef;
          if (childWheres != null) childQuery = _getQuery(childQuery, childWheres);
          if (childOrderby != null) childQuery = _getOrderby(childQuery, childOrderby);
          if (childLimit != null) childQuery = childQuery.limit(childLimit);
          return childQuery.snapshots().map((snapshot) {
            return snapshot.docs.map((document) {
              Map<String, dynamic> childData = document.data();
              childData["id"] = document.id;
              return {
                "parent": parentData,
                "child": childData,
              };
            }).toList();
          });
        }).toList();
      });
    } catch (e) {
      FlutterLogs.logThis(
        tag: "keicy_firestore_data_provider",
        level: LogLevel.ERROR,
        subTag: "getDocumentsStreamWithChildCollection",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      return null;
    }
  }
}

Query<Map<String, dynamic>> _getQuery(Query<Map<String, dynamic>>? query, List<Map<String, dynamic>>? wheres) {
  for (var i = 0; i < wheres!.length; i++) {
    var key = wheres[i]["key"];
    var cond = wheres[i]["cond"] ?? "=";
    var val = wheres[i]["val"];

    switch (cond.toString()) {
      case "":
        query = query!.where(key, isEqualTo: val);
        break;
      case "null":
        query = query!.where(key, isNull: val);
        break;
      case "=":
        query = query!.where(key, isEqualTo: val);
        break;
      case "!=":
        query = query!.where(key, isNotEqualTo: val);
        break;
      case "<":
        query = query!.where(key, isLessThan: val);
        break;
      case "<=":
        query = query!.where(key, isLessThanOrEqualTo: val);
        break;
      case ">":
        query = query!.where(key, isGreaterThan: val);
        break;
      case ">=":
        query = query!.where(key, isGreaterThanOrEqualTo: val);
        break;
      case "arrayContains":
        query = query!.where(key, arrayContains: val);
        break;
      case "arrayContainsAny":
        query = query!.where(key, arrayContainsAny: val);
        break;
      case "whereIn":
        query = query!.where(key, whereIn: val);
        break;
      case "whereNotIn":
        query = query!.where(key, whereNotIn: val);
        break;
      case "like":
        dynamic start = [val];
        dynamic end = [val + '\uf8ff'];
        query = query!.orderBy(key).startAt(start).endAt(end);
        break;
      default:
        query = query!.where(key, isEqualTo: val);
        break;
    }
  }
  return query!;
}

Query<Map<String, dynamic>> _getOrderby(Query<Map<String, dynamic>>? query, List<Map<String, dynamic>>? orderby) {
  for (var i = 0; i < orderby!.length; i++) {
    query = query!.orderBy(orderby[i]["key"], descending: (orderby[i]["desc"] == null) ? false : orderby[i]["desc"]);
  }
  return query!;
}
