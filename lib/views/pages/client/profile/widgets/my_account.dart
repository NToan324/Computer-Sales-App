import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:computer_sales_app/components/custom/my_text_field.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/user.model.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/services/user.service.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/otp_input.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountView();
}

class _MyAccountView extends State<MyAccountView> {
  List<Map<String, dynamic>> myAccountItems = [
    {'title': 'Personal Information', 'icon': CupertinoIcons.person},
    {'title': 'Change Password', 'icon': CupertinoIcons.lock},
    {'title': 'Address', 'icon': CupertinoIcons.location_north},
  ];

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadUserData();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        final isExistUser = value.userModel != null;
        final userInfo = value.userModel;

        // Lọc danh sách dựa trên trạng thái user
        final visibleItems = List<Map<String, dynamic>>.from(myAccountItems);
        if (!isExistUser) {
          visibleItems.removeWhere((item) =>
              item['title'] == 'Personal Information' ||
              item['title'] == 'Change Password');
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            final item = visibleItems[index];
            return listTileCustom(
              item['icon'],
              item['title'],
              onTap: () {
                switch (item['title']) {
                  case 'Personal Information':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PersonelInformation(userInfo: userInfo)),
                    );
                    break;
                  case 'Change Password':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                    break;
                  case 'Address':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressPage()),
                    );
                    break;
                }
              },
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 0,
          ),
          itemCount: visibleItems.length,
        );
      },
    );
  }
}

//Personal Information
class PersonelInformation extends StatefulWidget {
  const PersonelInformation({super.key, required this.userInfo});
  final UserModel? userInfo;

  @override
  State<PersonelInformation> createState() => _PersonelInformationState();
}

class _PersonelInformationState extends State<PersonelInformation> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  UserService userService = UserService();

  bool _isLoading = false;
  File? _selectedFile;
  Uint8List? _selectedImageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Web: đọc bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedFile = null;
        });
      } else {
        // Mobile: dùng File
        setState(() {
          _selectedFile = File(pickedFile.path);
          _selectedImageBytes = null;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedFile = null;
      _selectedImageBytes = null;
    });
  }

  Future<void> handleChangeInfomation() async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneNumberController.text.trim();
    final address = _addressController.text.trim();

    if (fullName.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserImage? uploadedAvatar;
      if (_selectedFile != null) {
        uploadedAvatar = await userService.uploadAvatar(file: _selectedFile!);
      } else if (_selectedImageBytes != null) {
        uploadedAvatar = await userService.uploadAvatar(
            bytes: _selectedImageBytes, filename: 'avatar.jpg');
      }

      debugPrint(
          'upload, ${uploadedAvatar?.public_id}, ${uploadedAvatar?.url}');

      await userService.updateUserInfo(
        fullName: fullName,
        phone: phone,
        address: address,
        avatar: uploadedAvatar,
      );

      await Provider.of<UserProvider>(context, listen: false).loadUserData();

      showCustomSnackBar(context, 'Information updated successfully',
          type: SnackBarType.success);
    } on FetchDataException catch (e) {
      debugPrint('Failed to update info: ${e.message}');
      showCustomSnackBar(context, 'Failed to update information');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userInfo != null) {
      _fullNameController.text = widget.userInfo!.fullName;
      _phoneNumberController.text = widget.userInfo!.phone ?? '';
      _addressController.text = widget.userInfo!.address ?? '';
      _emailController.text = widget.userInfo!.email;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _fullNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressFocusNode.dispose();
    _emailFocusNode.dispose();
    _selectedFile = null;
    _selectedImageBytes = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarMobile(
        title: 'Personal Information',
        isBack: true,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary, // đổi màu nếu cần
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _selectedFile != null
                              ? FileImage(_selectedFile!)
                              : (_selectedImageBytes != null
                                      ? MemoryImage(_selectedImageBytes!)
                                      : (widget.userInfo != null &&
                                              widget.userInfo!.avatar != null
                                          ? NetworkImage(
                                              widget.userInfo!.avatar.url)
                                          : const AssetImage(
                                              'assets/images/avatar.jpeg')))
                                  as ImageProvider,
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      padding: const EdgeInsets.all(8),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 73, 73, 73),
                        ),
                        shape: WidgetStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      onPressed: () {
                        if (_selectedFile != null ||
                            _selectedImageBytes != null) {
                          _removeImage();
                        } else {
                          _pickImage();
                        }
                      },
                      icon: Icon(
                        (_selectedFile != null || _selectedImageBytes != null)
                            ? CupertinoIcons.xmark
                            : CupertinoIcons.camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              // Các trường thông tin cá nhân ở đây...
              _buildLabeledTextField(
                label: 'Full Name',
                controller: _fullNameController,
                focusNode: _fullNameFocusNode,
                hint: 'Seibon',
                icon: CupertinoIcons.person,
              ),
              _buildLabeledTextField(
                label: 'Phone Number',
                controller: _phoneNumberController,
                focusNode: _phoneNumberFocusNode,
                hint: 'Phone Number',
                icon: CupertinoIcons.phone,
                fieldType: TextInputType.phone,
              ),
              _buildLabeledTextField(
                label: 'Email',
                controller: _emailController,
                focusNode: _emailFocusNode,
                hint: 'example@gmail.com',
                icon: CupertinoIcons.envelope,
              ),
              _buildLabeledTextField(
                label: 'Address',
                controller: _addressController,
                focusNode: _addressFocusNode,
                hint: 'District 1, HCM City',
                icon: CupertinoIcons.location,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 200, maxWidth: 350),
                  child: MyButton(
                    text: 'Change Information',
                    isLoading: _isLoading,
                    onTap: (_) => {handleChangeInfomation()},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    TextInputType? fieldType,
  }) {
    fieldType = fieldType ?? TextInputType.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          MyTextField(
            hintText: hint,
            prefixIcon: icon,
            controller: controller,
            focusNode: focusNode,
            obscureText: false,
            disable: label == 'Email' ? true : false,
            fieldType: fieldType,
          ),
        ],
      ),
    );
  }
}

//Change Password
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarMobile(
        title: 'Change Password',
        isBack: true,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Container(
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.only(top: 16, left: 64, right: 64)
              : EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      Text(
                        'Enter your verification code!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Please enter the code sent to your email address.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double boxWidth = (constraints.maxWidth - 60) /
                        4; // 4 ô, mỗi ô cách nhau 20
                    boxWidth = boxWidth.clamp(60, 100); // min 60, max 100

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        SizedBox(
                          width: boxWidth,
                          child: OtpInput(
                              controller: otp1Controller, autoFocus: true),
                        ),
                        SizedBox(
                          width: boxWidth,
                          child: OtpInput(controller: otp2Controller),
                        ),
                        SizedBox(
                          width: boxWidth,
                          child: OtpInput(controller: otp3Controller),
                        ),
                        SizedBox(
                          width: boxWidth,
                          child: OtpInput(controller: otp4Controller),
                        ),
                      ],
                    );
                  },
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
                  child: MyButton(
                    text: 'Get code',
                    isLoading: false,
                    onTap: (_) => {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Address
class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];
  String? selectedProvinceCode;
  String? selectedDistrictCode;
  String? selectedWardCode;
  String currentAddress = '';
  String _addressOption = 'current';
  bool _addNewAddress = false;
  List<String> savedAddresses = [];

  @override
  void initState() {
    super.initState();
    loadSavedLocation();
    fetchProvinces();
    getSavedAddresses();
  }

  Future<void> loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentAddress = prefs.getString('location_current') ?? 'No address set';
    });
  }

  Future<void> getSavedAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> checkSavedAddresses =
        prefs.getStringList('manual_location') ?? [];
    if (!checkSavedAddresses.contains(currentAddress)) {
      checkSavedAddresses.add(currentAddress);
      await prefs.setStringList('manual_location', checkSavedAddresses);
    }
    setState(() {
      savedAddresses = checkSavedAddresses;
    });
  }

  Future<void> fetchProvinces() async {
    try {
      final res = await http
          .get(Uri.parse('https://provinces.open-api.vn/api/?depth=1'));
      if (res.statusCode == 200) {
        setState(() {
          provinces = jsonDecode(utf8.decode(res.bodyBytes));
        });
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      debugPrint('Error loading provinces: $e');
    }
  }

  Future<void> fetchDistricts(String provinceCode) async {
    try {
      final res = await http.get(Uri.parse(
          'https://provinces.open-api.vn/api/p/$provinceCode?depth=2'));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          districts = data['districts'];
        });
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      debugPrint('Error loading districts: $e');
    }
  }

  Future<void> fetchWards(String districtCode) async {
    try {
      final res = await http.get(Uri.parse(
          'https://provinces.open-api.vn/api/d/$districtCode?depth=2'));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          wards = data['wards'];
        });
      } else {
        throw Exception('Failed to load wards');
      }
    } catch (e) {
      debugPrint('Error loading wards: $e');
    }
  }

  Future<void> saveLocationToPreferences(String newAddress) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedAddresses = prefs.getStringList('manual_location') ?? [];
    prefs.setStringList('manual_location', savedAddresses);
    if (!savedAddresses.contains(newAddress)) {
      savedAddresses.add(newAddress);
      await prefs.setStringList('manual_location', savedAddresses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarMobile(
        title: 'Address',
        isBack: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Display current location
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withAlpha(50),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    title: Text('Current Location'),
                    subtitle: Text(currentAddress),
                  ),
                ),
                if (savedAddresses.isNotEmpty)
                  const SizedBox(
                    height: 16,
                  ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Select your address',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
                ),
                ...savedAddresses.map((address) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Location'),
                      subtitle: Text(address),
                      trailing: Radio<String>(
                        value: address,
                        groupValue: currentAddress,
                        onChanged: (value) async {
                          // Thực hiện công việc async bên ngoài setState
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('location_current', value!);

                          // Sau khi xong, cập nhật trạng thái trong setState (đồng bộ)
                          setState(() {
                            currentAddress = value;
                            _addressOption = 'saved';
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                  );
                }),
                // New address button
                ListTile(
                  title: Text(
                    'Add An Address',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    _addNewAddress
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.add,
                  ),
                  onTap: () {
                    setState(() {
                      _addNewAddress = !_addNewAddress;
                    });
                  },
                ),

                if (_addNewAddress)
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        decoration: const InputDecoration(
                          labelText: 'Province',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        value: selectedProvinceCode,
                        items: provinces.map<DropdownMenuItem<String>>((prov) {
                          return DropdownMenuItem<String>(
                            value: prov['code'].toString(),
                            child: Text(prov['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProvinceCode = value;
                            selectedDistrictCode = null;
                            selectedWardCode = null;
                            districts = [];
                            wards = [];
                          });
                          if (value != null) fetchDistricts(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Dropdown for District selection
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        decoration: const InputDecoration(
                          labelText: 'District',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        value: selectedDistrictCode,
                        items: districts.map<DropdownMenuItem<String>>((dist) {
                          return DropdownMenuItem<String>(
                            value: dist['code'].toString(),
                            child: Text(dist['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDistrictCode = value;
                            selectedWardCode = null;
                            wards = [];
                          });
                          if (value != null) fetchWards(value);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Dropdown for Ward selection
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        decoration: const InputDecoration(
                          labelText: 'Ward',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        value: selectedWardCode,
                        items: wards.map<DropdownMenuItem<String>>((ward) {
                          return DropdownMenuItem<String>(
                            value: ward['code'].toString(),
                            child: Text(ward['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWardCode = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),
                      // Save address button
                      MyButton(
                        text: 'Add location',
                        onTap: (_) async {
                          String getNameByCode(
                              List<dynamic> list, String? code) {
                            return list.firstWhere(
                              (item) => item['code'].toString() == code,
                              orElse: () => {'name': 'Unknown'},
                            )['name'];
                          }

                          String newAddress =
                              '${getNameByCode(wards, selectedWardCode)}, ${getNameByCode(districts, selectedDistrictCode)}, ${getNameByCode(provinces, selectedProvinceCode)}';

                          saveLocationToPreferences(newAddress);
                          await getSavedAddresses();
                          setState(() {
                            _addNewAddress = false;
                            selectedProvinceCode = null;
                            selectedDistrictCode = null;
                            selectedWardCode = null;
                            districts = [];
                            wards = [];
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
