import 'package:flutter/material.dart';

void main() {
  runApp(const MarketCalculatorApp());
}

class MarketCalculatorApp extends StatelessWidget {
  const MarketCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حاسبەیا مارکێتێ',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const MarketHomePage(),
    );
  }
}

class MarketHomePage extends StatefulWidget {
  const MarketHomePage({super.key});

  @override
  State<MarketHomePage> createState() => _MarketHomePageState();
}

class ItemData {
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController(text: '1');
}

class _MarketHomePageState extends State<MarketHomePage> {
  // لیستا ڤالا و بەرهەمان
  List<ItemData> items = [ItemData()];

  @override
  void dispose() {
    for (var item in items) {
      item.priceController.dispose();
      item.qtyController.dispose();
    }
    super.dispose();
  }

  // زێدەکرنا دوو ڤالایێن نوو (بهای و عدد)
  void _addItem() {
    setState(() {
      items.add(ItemData());
    });
  }

  // ژێبرنا ڕێزەکێ
  void _removeItem(int index) {
    setState(() {
      items[index].priceController.dispose();
      items[index].qtyController.dispose();
      items.removeAt(index);
      if (items.isEmpty) {
        items.add(ItemData());
      }
    });
  }

  // پاقژکرنا هەمی لیستی
  void _clearAll() {
    setState(() {
      for (var item in items) {
        item.priceController.dispose();
        item.qtyController.dispose();
      }
      items = [ItemData()];
    });
  }

  // هەژمارتنا کۆی گشتی
  double _calculateTotal() {
    double total = 0;
    for (var item in items) {
      double price = double.tryParse(item.priceController.text) ?? 0;
      double qty = double.tryParse(item.qtyController.text) ?? 1;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double grandTotal = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبەیا بارێ مارکێتێ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4F46E5),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // بانه را کۆی گشتی ل سەرێ شاشەی
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('کۆی گشتی:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3730A3))),
                Text('${grandTotal.toStringAsFixed(0)} د.ع', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
              ],
            ),
          ),
          
          // لیستا ڤالا و ڕێزان
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // ڤاڵا (TextField) بۆ بایی
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: items[index].priceController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'بهایێ بەرهەمی (د.ع)',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // ڤاڵا (TextField) بۆ عدد / چەنداتی
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: items[index].qtyController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'عدد',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // دوگمەیا ژێبرنا ڤی بەرهەمی
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // دوگمەیێن خوارێ (پاقژکرن و اضافه)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _clearAll,
                    child: const Text('پاقژکرن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _addItem,
                    child: const Text('+ اضافه', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
