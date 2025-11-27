// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'MatLog';

  @override
  String get weeklyGoal => 'Meta Semanal';

  @override
  String get sessions => 'sessões';

  @override
  String get recentActivity => 'Atividade Recente';

  @override
  String get profileTitle => 'Meu Perfil';

  @override
  String get currentBelt => 'Faixa Atual';

  @override
  String get degree => 'grau';

  @override
  String get degrees => 'graus';

  @override
  String get editProgress => 'Editar Progresso';

  @override
  String get belt => 'Faixa';

  @override
  String get stripes => 'Graus';

  @override
  String get saveChanges => 'Salvar Alterações';

  @override
  String get notificationsSchedule => 'Notificações e Horários';

  @override
  String get trainingDays => 'Dias de Treino';

  @override
  String get usualTime => 'Horário Habitual';

  @override
  String get linkEmail => 'Vincular Email';

  @override
  String get secureAccount => 'Proteger Conta';

  @override
  String get saveProgress => 'Salve seu progresso';

  @override
  String get linkAccountDesc =>
      'Vincule sua conta a um email para não perder seus dados se trocar de dispositivo.';

  @override
  String get rivalsTitle => 'Parceiros de Treino';

  @override
  String get noRivals => 'Nenhum parceiro salvo ainda.';

  @override
  String get addRival => 'Adicionar';

  @override
  String get newRivalTitle => 'Novo Parceiro';

  @override
  String get nameLabel => 'Nome';

  @override
  String get saveLabel => 'Salvar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get matchVs => 'Luta vs';

  @override
  String get winLabel => 'Vitória';

  @override
  String get lossLabel => 'Derrota';

  @override
  String get drawLabel => 'Empate';

  @override
  String get techniqueLibraryTitle => 'Biblioteca Técnica';

  @override
  String get noTechniques => 'Nenhuma técnica aprendida ainda.';

  @override
  String get repetitionsLabel => 'Repetições';

  @override
  String get levelLabel => 'Nível';

  @override
  String get techniqueDetailTitle => 'Detalhes da Técnica';

  @override
  String get notesLabel => 'Notas';

  @override
  String get saveNotes => 'Salvar Notas';

  @override
  String get historyLabel => 'Histórico';

  @override
  String get checkInTitle => 'Check-in';

  @override
  String get sessionType => 'Tipo de Sessão';

  @override
  String get durationLabel => 'Duração';

  @override
  String get trainingNotes => 'Notas de Treino';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get accountSection => 'Conta';

  @override
  String get manageSubscription => 'Gerenciar Assinatura';

  @override
  String get signOut => 'Sair';

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get aboutSection => 'Sobre';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get versionLabel => 'Versão';

  @override
  String get pleaseLogin => 'Por favor faça login';

  @override
  String errorLabel(String error) {
    return 'Erro: $error';
  }

  @override
  String get matchResultQuestion => 'Qual foi o resultado do treino?';

  @override
  String addedRivalMessage(String name) {
    return '$name adicionado aos seus rivais';
  }

  @override
  String imageSelectionError(String error) {
    return 'Erro ao selecionar imagem: $error';
  }

  @override
  String get scheduleUpdated => 'Horário atualizado';

  @override
  String get profileUpdated => 'Perfil atualizado com sucesso';

  @override
  String updateError(String error) {
    return 'Erro ao atualizar: $error';
  }

  @override
  String get accountSecured => 'Conta protegida com sucesso!';

  @override
  String get linkButton => 'Vincular';

  @override
  String get trainingLogged => 'Treino registrado com sucesso!';

  @override
  String get rpeLabel => 'RPE (Intensidade)';

  @override
  String get beltWhite => 'Faixa Branca';

  @override
  String get beltBlue => 'Faixa Azul';

  @override
  String get beltPurple => 'Faixa Roxa';

  @override
  String get beltBrown => 'Faixa Marrom';

  @override
  String get beltBlack => 'Faixa Preta';

  @override
  String get analyticsTitle => 'Analytics & Progresso';

  @override
  String get gameStyleTitle => 'Estilo de Jogo';

  @override
  String get gameStyleExplanation =>
      'Este gráfico mostra seu perfil técnico baseado nas técnicas que você pratica. Quanto maior a área em cada categoria, mais técnicas você domina naquele estilo.';

  @override
  String get trainingDistributionTitle => 'Distribuição de Treino';

  @override
  String get trainingDistributionExplanation =>
      'Mostra que porcentagem do seu treino é com Kimono (Gi) vs Sem Kimono (NoGi). Ajuda você a ver se está equilibrado ou se foca mais em uma modalidade.';

  @override
  String get matTimeTitle => 'Tempo no Tatame';

  @override
  String get matTimeExplanation =>
      'Este gráfico mostra suas horas acumuladas de treinamento ao longo do tempo. A linha sempre sobe, representando seu esforço total no tatame.';

  @override
  String get intensityTitle => 'Intensidade (RPE)';

  @override
  String get intensityExplanation =>
      'Cada ponto representa a intensidade de uma sessão de treino (RPE de 1 a 10). Verde = sessão leve, Laranja = moderada, Vermelho = muito intensa. Ajuda você a evitar o overtraining.';

  @override
  String get topPositionsTitle => 'Categorias de Técnicas';

  @override
  String get topPositionsExplanation =>
      'Mostra as categorias onde você tem mais técnicas registradas (Guarda, Passagem, Finalização, Defesa, Quedas). Define em quais áreas você foca mais.';

  @override
  String get weeklyConsistencyTitle => 'Consistência Semanal';

  @override
  String get weeklyConsistencyExplanation =>
      'Mostra quais dias da semana você treina com mais frequência. Ajuda você a identificar sua rotina de treino.';
}
