import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:phonebook_application/Contacts/ContactStructure/ContactStructure.dart';

class ContactAccess {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 UI listens to this
  final ValueNotifier<List<ContactStructure>> contactsNotifier =
      ValueNotifier<List<ContactStructure>>([]);

  /// 🔹 Local cache (used for search)
  final List<ContactStructure> _allContacts = [];

  ContactAccess() {
    _listenToContacts();
  }

  // =========================================================
  // 📥 READ (REAL-TIME LISTENER)
  // =========================================================

  void _listenToContacts() {
    _firestore
        .collection('contacts')
        .orderBy('name')
        .snapshots()
        .listen((snapshot) {
      _allContacts.clear();

      for (var doc in snapshot.docs) {
        _allContacts.add(
          ContactStructure.fromFirestore(doc.id, doc.data()),
        );
      }

      _updateUI(_allContacts);
    });
  }

  // =========================================================
  // 🔄 UPDATE UI (SORT + NOTIFY)
  // =========================================================

  void _updateUI(List<ContactStructure> list) {
    final updatedList = List<ContactStructure>.from(list);

    updatedList.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    contactsNotifier.value = updatedList;
  }

  // =========================================================
  // ➕ CREATE
  // =========================================================

  Future<void> addContact(ContactStructure contact) async {
    await _firestore.collection('contacts').add({
      'name': contact.name,
      'phone_no': contact.phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // ✏ UPDATE
  // =========================================================

  Future<void> updateContact(ContactStructure contact) async {
    await _firestore.collection('contacts').doc(contact.id).update({
      'name': contact.name,
      'phone_no': contact.phone,
    });
  }

  // =========================================================
  // 🗑 DELETE
  // =========================================================

  Future<void> deleteContact(String id) async {
    await _firestore.collection('contacts').doc(id).delete();
  }

  // =========================================================
  // 🔍 SEARCH (LOCAL – DSA)
  // =========================================================

  void searchContacts(String query) {
    if (query.trim().isEmpty) {
      _updateUI(_allContacts);
      return;
    }

    final filtered = _allContacts.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase()) ||
          contact.phone.contains(query);
    }).toList();

    _updateUI(filtered);
  }

  // =========================================================
  // 🔤 SORTING
  // =========================================================

  void sortAscending() {
    _updateUI(_allContacts);
  }

  void sortDescending() {
    final descList = List<ContactStructure>.from(_allContacts);
    descList.sort(
      (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
    );
    contactsNotifier.value = descList;
  }
}
