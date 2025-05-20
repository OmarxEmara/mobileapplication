import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/feature_slider.dart';

class IrisPredictorScreen extends StatefulWidget {
  const IrisPredictorScreen({Key? key}) : super(key: key);

  @override
  State<IrisPredictorScreen> createState() => _IrisPredictorScreenState();
}

class _IrisPredictorScreenState extends State<IrisPredictorScreen> {
  final List<double> featureValues = [5.0, 3.6, 1.4, 0.2];
  final List<String> featureNames = [
    "Sepal Length (cm)",
    "Sepal Width (cm)",
    "Petal Length (cm)",
    "Petal Width (cm)",
  ];
  final List<String> irisClasses = ["Setosa", "Versicolor", "Virginica"];
  
  int? prediction;
  bool isLoading = false;
  String? error;

  Future<void> handlePredict() async {
    setState(() {
      isLoading = true;
      error = null;
      prediction = null;
    });
    
    try {
      final result = await ApiService.predict(featureValues);
      setState(() {
        prediction = result['prediction'][0];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prediction: ${irisClasses[prediction!]}'),
        ),
      );
    } catch (err) {
      setState(() {
        error = 'Failed to get prediction. Make sure the API server is running.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Failed to get prediction'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iris Flower Classifier'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Adjust sliders to input flower measurements',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: featureNames.length,
                itemBuilder: (context, index) {
                  return FeatureSlider(
                    label: featureNames[index],
                    value: featureValues[index],
                    onChanged: (value) {
                      setState(() {
                        featureValues[index] = value;
                      });
                    },
                  );
                },
              ),
            ),
            if (error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            if (prediction != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prediction Result:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      irisClasses[prediction!],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: isLoading ? null : handlePredict,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Processing...'),
                      ],
                    )
                  : const Text('Predict Iris Type'),
            ),
          ],
        ),
      ),
    );
  }
}
