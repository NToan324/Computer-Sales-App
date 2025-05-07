import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class CustomerTable extends StatefulWidget {
  const CustomerTable({super.key});

  @override
  State<CustomerTable> createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> customers = [
    {
      "id": 1,
      "name": "Customer 1",
      "phone": "0123456780",
      "dateJoined": "1/1/2022",
      "transaction": 5,
      "point": 100,
      "rank": "Bronze",
    },
    {
      "id": 2,
      "name": "Customer 2",
      "phone": "0123456781",
      "dateJoined": "2/1/2022",
      "transaction": 6,
      "point": 110,
      "rank": "Silver",
    },
    {
      "id": 3,
      "name": "Alice",
      "phone": "0123456782",
      "dateJoined": "3/1/2022",
      "transaction": 3,
      "point": 80,
      "rank": "Bronze",
    },
  ];

  List<Map<String, dynamic>> get filteredCustomers {
    if (_searchController.text.isEmpty) {
      return customers;
    } else {
      return customers.where((customer) {
        return customer['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

 Color _getRankColor(String rank) {
    switch (rank) {
      case "Bronze":
        return Colors.brown;
      case "Silver":
        return Colors.grey;
      case "Gold":
        return Colors.yellow[700]!;
      default:
        return Colors.blueGrey;
    }
  }

    List<DataColumn> getColumns(bool isMobile, double spacing) {
    if (isMobile) {
      return [
        DataColumn(label: SizedBox(width: spacing, child: const Text("#"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Name"))),
        DataColumn(label: SizedBox(width: spacing*2, child: const Text("Date Joined"))),
      ];
    } else {
      return [
        DataColumn(label: SizedBox(width: spacing, child: const Text("#"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Name"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Phone"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Date Joined"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Transaction"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Point"))),
        DataColumn(label: SizedBox(width: spacing, child: const Text("Rank"))),
      ];
    }
  }


  List<DataCell> getCells(
      Map<String, dynamic> customer, bool isMobile, double width) {
    double w(double percent) => width * percent;

    if (isMobile) {
      return [
        DataCell(SizedBox(width: w(0.1), child: Text(customer['id'].toString()))),
        DataCell(SizedBox(width: w(0.3), child: Text(customer['name']))),
        DataCell(SizedBox(width: w(0.3), child: Text(customer['dateJoined']))),
      ];
    } else {
      return [
        DataCell(SizedBox(width: w(0.05), child: Text(customer['id'].toString()))),
        DataCell(SizedBox(width: w(0.1), child: Text(customer['name']))),
        DataCell(SizedBox(width: w(0.1), child: Text(customer['phone']))),
        DataCell(SizedBox(width: w(0.1), child: Text(customer['dateJoined']))),
        DataCell(SizedBox(width: w(0.1), child: Text(customer['transaction'].toString()))),
        DataCell(SizedBox(width: w(0.1), child: Text(customer['point'].toString()))),
        DataCell(SizedBox(
          width: w(0.08),
          child: Chip(
            label: Text(
              customer['rank'],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: _getRankColor(customer['rank']),
          ),
        )),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final tableWidth = constraints.maxWidth;
        final columnCount = isMobile ? 4 : 7;

        final spacing = (tableWidth - 150) / columnCount;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightGrey,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header + Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Customer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: "Search by name",
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                  columnSpacing: 16, // spacing giữa các cột
                  columns: getColumns(isMobile, spacing),
                  rows: filteredCustomers.map((customer) {
                    return DataRow(
                      cells: getCells(customer, isMobile, tableWidth),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
