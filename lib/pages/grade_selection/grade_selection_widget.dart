import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../backend/schema/project_data.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'grade_selection_model.dart';

class GradeSelectionWidget extends StatefulWidget {
  const GradeSelectionWidget({super.key});

  static const String routeName = '/grade_selection';

  @override
  State<GradeSelectionWidget> createState() => _GradeSelectionWidgetState();
}

class _GradeSelectionWidgetState extends State<GradeSelectionWidget> {
  late GradeSelectionModel _model;

  @override
  void initState() {
    super.initState();
    _model = GradeSelectionModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onSelectGrade(int gradeNumber) {
    final appState = Provider.of<FFAppState>(context, listen: false);
    appState.selectedGrade = gradeNumber; // 1-based: 1, 2, 3, or 4
    Navigator.of(context).pushNamed('/project_selection');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryText, size: 20.0),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Grade',
          style: theme.title2.override(fontSize: 20.0),
        ),
        centerTitle: true,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.cardBorder,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Instruction header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              color: theme.secondaryBackground.withOpacity(0.5),
              child: Row(
                children: [
                  Icon(Icons.layers_outlined, size: 20.0, color: theme.primary),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      'Choose a curriculum level to explore 6 hands-on hardware projects.',
                      style: theme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20.0),
                itemCount: ProjectCatalog.grades.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final grade = ProjectCatalog.grades[index];
                  return _buildGradeCard(context, grade, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, GradeInfo grade, FlutterFlowTheme theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSelectGrade(grade.gradeNumber),
        borderRadius: BorderRadius.circular(20.0),
        splashColor: grade.accentColor.withOpacity(0.2),
        highlightColor: grade.accentColor.withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: theme.cardBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Grade Number Icon Badge
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        grade.primaryColor,
                        grade.accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: grade.primaryColor.withOpacity(0.35),
                        blurRadius: 10.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'G${grade.gradeNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 18.0),

                // Grade Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            grade.title,
                            style: theme.title2.override(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: grade.primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              '6 Projects',
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: grade.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        grade.subtitle,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        grade.level,
                        style: theme.bodyText2.override(
                          fontSize: 11.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: theme.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
