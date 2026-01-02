import 'package:flutter/material.dart';
import 'package:phonebook_application/Contacts/ContactAccess.dart';
import 'package:phonebook_application/Contacts/Contacts.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {

  late final ContactAccess contactAccess;

  @override
  void initState() {
    super.initState();
    contactAccess = ContactAccess(); // 🔥 Firestore listener starts here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Row(
            children: const [
              Icon(Icons.contact_page, color: Colors.black, size: 30.0),
              SizedBox(width: 10.0),
              Text(
                'Phone Book',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: Column(
            children: [
              // 🔍 SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  cursorColor: Colors.black87,
                  onChanged: (value) {
                    contactAccess.searchContacts(value);
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black87),
                    ),
                    hintText: 'Search Contacts',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

              // 🔤 SORT LABEL
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    'Sort By:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              // 🔤 SORT BUTTONS
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    // ASCENDING
                    InkWell(
                      onTap: () {
                        contactAccess.sortAscending();
                      },
                      child: _sortButton(
                        icon: Icons.sort_by_alpha,
                        label: "Ascending",
                      ),
                    ),

                    const SizedBox(width: 10.0),

                    // DESCENDING
                    InkWell(
                      onTap: () {
                        contactAccess.sortDescending();
                      },
                      child: _sortButton(
                        icon: Icons.sort,
                        label: "Descending",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 📋 CONTACT LIST
      body: Contacts(contactAccess: contactAccess),
    );
  }

  // 🔹 Reusable sort button UI
  Widget _sortButton({required IconData icon, required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon, size: 16.0),
          const SizedBox(width: 4.0),
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
