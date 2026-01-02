import 'package:flutter/material.dart';
import 'package:phonebook_application/Contacts/ContactAccess.dart';
import 'package:phonebook_application/Contacts/ContactStructure/ContactStructure.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Contacts extends StatefulWidget {
  final ContactAccess contactAccess;

  const Contacts({super.key, required this.contactAccess});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, {Color backgroundColor = Colors.black87}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        // ELEVATION
        elevation: 2,

        //  FLOATING STYLE
        behavior: SnackBarBehavior.floating,

        //  POSITION (slightly above bottom)
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        // 🔥 ROUNDED CORNERS (optional but nice)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),  
      ),
    );
  }


  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              // HEADER
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                    const Text(
                      'Add New Contact',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: _saveContact,
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ),

              // NAME
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.black87,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black87),
                    ),
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // PHONE
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.black87,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black87),
                    ),
                    labelText: 'Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void showUpdateBottomSheet(ContactStructure contact) {
    nameController.text = contact.name;
    phoneController.text = contact.phone;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                "Update Contact",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  widget.contactAccess.updateContact(
                    ContactStructure(
                      id: contact.id,
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                    ),
                  );
                  showSnackBar("Contact Updated Successfully!", backgroundColor: Colors.blue);

                  nameController.clear();
                  phoneController.clear();
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
                    child: Text('Update', style: const TextStyle(color: Colors.white),),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }


  void _saveContact() {
    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) return;

    widget.contactAccess.addContact(
      ContactStructure(
        id: '', // 🔥 Firestore will generate real ID
        name: name,
        phone: phone,
      ),
    );

    nameController.clear();
    phoneController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<ContactStructure>>(
        valueListenable: widget.contactAccess.contactsNotifier,
        builder: (context, contacts, _) {
          if (contacts.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.black,));
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: ListView.builder(
              key: ValueKey(contacts.hashCode),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
            
                return Slidable(
                  key: ValueKey(contact.id),

                  // 👉 LEFT → RIGHT (DELETE)
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          widget.contactAccess.deleteContact(contact.id);
                          showSnackBar("Contact Deleted Successfully!", backgroundColor: Colors.red);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),

                  // 👈 RIGHT → LEFT (UPDATE)
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showUpdateBottomSheet(contact);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),

                  child: ListTile(
                    title: Text(
                      contact.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(contact.phone),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showBottomSheet,
        backgroundColor: Colors.black87,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
