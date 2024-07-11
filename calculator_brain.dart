import 'dart:math';
import 'package:imc/screens/input_page.dart';

class CalculatorBrain {
  CalculatorBrain({this.height, this.weight, this.selectedGender});

  final int height;
  final double weight;
  final Gender selectedGender;

  double _bmi;

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }


  String getResult() {
    if(selectedGender == Gender.female){
      if (_bmi >= 40) {
        return 'Obesidade III';
      } else if (_bmi >= 32.3) {
        return 'Obesidade II';
      }else if (_bmi >= 27.3) {
        return 'Obesidade I';
      } else if (_bmi >= 25.8) {
        return 'Acima do peso';
      }else if (_bmi >= 19.1) {
        return 'Peso normal';
      }else {
        return 'Abaixo do peso';
      }
    }else{
      if (_bmi >= 40) {
        return 'Obesidade III';
      } else if (_bmi >= 31.1) {
        return 'Obesidade II';
      }else if (_bmi >= 27.8) {
        return 'Obesidade I';
      } else if (_bmi >= 26.4) {
        return 'Acima do peso';
      }else if (_bmi >= 20.7) {
        return 'Peso normal';
      }else {
        return 'Abaixo do peso';
      }
    }

  }

  String getInterpretation() {
    if(selectedGender == Gender.female){
      if (_bmi >= 40) {
        return 'Procure um médico!';
      } else if (_bmi >= 32.3) {
        return 'Revise sua alimentação e faça atividades físicas.';
      }else if (_bmi >= 27.3) {
        return 'Faça atividades físicas regularmente.';
      } else if (_bmi >= 25.8) {
        return 'Faça atividades físicas regularmente.';
      }else if (_bmi >= 19.1) {
        return 'Parabéns!\n Menor risco de doenças cardíacas e vasculares.';
      }else {
        return 'Alimente-se um pouco mais.';
      }
    }else{
      if (_bmi >= 40) {
        return 'Procure um médico!';
      } else if (_bmi >= 31.1) {
        return 'Revise sua alimentação e faça atividades físicas.';
      }else if (_bmi >= 27.8) {
        return 'Faça atividades físicas regularmente.';
      } else if (_bmi >= 26.4) {
        return 'Faça atividades físicas regularmente.';
      }else if (_bmi >= 20.7) {
        return 'Parabéns!\n Menor risco de doenças cardíacas e vasculares.';
      }else {
        return 'Alimente-se um pouco mais.';
      }
    }

  }
}