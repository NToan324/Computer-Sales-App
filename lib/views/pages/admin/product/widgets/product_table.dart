import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({Key? key}) : super(key: key);

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "name": "Laptop A",
      "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
      "stock": 20,
      "originalPrice": 1600,
      "sellingPrice": 1500,
      "status": "Active",
    },
    {
      "id": 2,
      "name": "PC B",
      "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
      "stock": 5,
      "originalPrice": 2100,
      "sellingPrice": 2000,
      "status": "Disabled",
    },
    {
      "id": 3,
      "name": "Mouse X",
      "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
      "stock": 100,
      "originalPrice": 30,
      "sellingPrice": 25,
      "status": "Active",
    },
  ];


  List<Map<String, dynamic>> get filteredProducts {
    if (_searchController.text.isEmpty) {
      return products;
    } else {
      return products.where((product) {
        return product['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Disabled":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  TableRow buildHeaderRow(List<String> headers, List<double> colWidths) {
    return TableRow(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
      children: List.generate(headers.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          width: colWidths[index],
          child: Text(
            headers[index],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  TableRow buildProductRow(Map<String, dynamic> product, List<double> colWidths) {
  final isMobile = Responsive.isMobile(context);
  return TableRow(
    children: isMobile
        ? [
            cellText(product['id'].toString(), colWidths[0]),
            productCell(product, colWidths[1]),
            cellText("\$${product['sellingPrice']}", colWidths[2]),
          ]
        : [
            cellText(product['id'].toString(), colWidths[0]),
            productCell(product, colWidths[1]),
            cellText(product['stock'].toString(), colWidths[2]),
            cellText("\$${product['originalPrice']}", colWidths[3]),
            cellText("\$${product['sellingPrice']}", colWidths[4]),
            Container(
              width: colWidths[5],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Chip(
                label: Text(
                  product['status'],
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _getStatusColor(product['status']),
              ),
            ),
          ],
      );
    }


  Widget cellText(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(text),
    );
  }
  Widget productCell(Map<String, dynamic> product, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          // Ảnh sản phẩm
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product['imageUrl'],
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          // Tên + ID
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "ID: ${product['id']}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final tableWidth = constraints.maxWidth;

        /// Tùy vào isMobile mà chia cột
        final List<double> colWidths = isMobile
            ? [tableWidth * 0.08, tableWidth * 0.45, tableWidth * 0.3]
            : [
                tableWidth * 0.06, // #
                tableWidth * 0.3,  // Product
                tableWidth * 0.12, // Stock
                tableWidth * 0.15, // Original Price
                tableWidth * 0.15, // Selling Price
                tableWidth * 0.15, // Status
              ];

        final headers = isMobile
            ? ["#", "Product", "Price"]
            : ["#", "Product", "Stock", "Original Price", "Selling Price", "Status"];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
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
                    "Product List",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                child: SizedBox(
                  width: tableWidth-40,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (int i = 0; i < colWidths.length; i++)
                        i: FixedColumnWidth(colWidths[i]),
                    },
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      /// Header row
                      buildHeaderRow(headers, colWidths),
                  
                      /// Data rows
                      ...filteredProducts.map((product) =>
                          buildProductRow(product, colWidths)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
