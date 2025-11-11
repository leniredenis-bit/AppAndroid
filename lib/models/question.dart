class Question {
  final int numero;
  final String enunciado;
  final List<String> alternativas;
  final int respostaCorreta;
  final String dificuldade;
  final List<String> tags;
  final String? versiculo;
  final String? explicacao;

  Question({
    required this.numero,
    required this.enunciado,
    required this.alternativas,
    required this.respostaCorreta,
    required this.dificuldade,
    required this.tags,
    this.versiculo,
    this.explicacao,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      numero: json['numero'] ?? 0,
      enunciado: json['enunciado'] ?? '',
      alternativas: List<String>.from(json['alternativas'] ?? []),
      respostaCorreta: json['respostaCorreta'] ?? 0,
      dificuldade: json['dificuldade'] ?? 'Médio',
      tags: List<String>.from(json['tags'] ?? []),
      versiculo: json['versiculo'],
      explicacao: json['explicacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'enunciado': enunciado,
      'alternativas': alternativas,
      'respostaCorreta': respostaCorreta,
      'dificuldade': dificuldade,
      'tags': tags,
      'versiculo': versiculo,
      'explicacao': explicacao,
    };
  }
}
