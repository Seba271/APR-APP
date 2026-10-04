import 'package:flutter/material.dart';

void main() => runApp(const AprTerrenoApp());

const navy = Color(0xFF07345D);
const blue = Color(0xFF087CAA);
const cyan = Color(0xFF12A9C2);
const paleBlue = Color(0xFFE9F5FA);
const canvas = Color(0xFFF4F8FC);
const border = Color(0xFFD8E5EE);
const muted = Color(0xFF6E849B);
const green = Color(0xFF14A47B);
const amber = Color(0xFFF2A51A);
const red = Color(0xFFE94C5B);

class AprTerrenoApp extends StatefulWidget {
  const AprTerrenoApp({super.key});

  @override
  State<AprTerrenoApp> createState() => _AprTerrenoAppState();
}

class _AprTerrenoAppState extends State<AprTerrenoApp> {
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APR Terreno',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: canvas,
        fontFamily: 'Arial',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: blue, width: 1.6),
          ),
        ),
      ),
      home: loggedIn
          ? const AppShell()
          : LoginPage(onLogin: () => setState(() => loggedIn = true)),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onLogin});
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),
                  const Center(child: AprLogo(size: 76)),
                  const SizedBox(height: 20),
                  const Text(
                    'APR Terreno',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: navy,
                      fontSize: 31,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Registra muestras de agua de forma simple y segura.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  SurfaceCard(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Ingresa a tu cuenta', style: sectionTitle),
                        const SizedBox(height: 6),
                        const Text(
                          'Usa los datos entregados por tu APR.',
                          style: TextStyle(color: muted, height: 1.4),
                        ),
                        const SizedBox(height: 22),
                        const FieldLabel('RUT o correo'),
                        const SizedBox(height: 7),
                        const TextField(
                          decoration: InputDecoration(
                            hintText: '12.345.678-9',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const FieldLabel('Contraseña'),
                        const SizedBox(height: 7),
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            suffixIcon: Icon(Icons.visibility_outlined),
                          ),
                        ),
                        const SizedBox(height: 22),
                        PrimaryButton(label: 'Iniciar sesión', onPressed: onLogin),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 18, color: muted),
                      SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          'Puedes registrar datos sin señal',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: muted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  final records = <SampleRecord>[
    const SampleRecord('Hoy, 10:15', 'Pozo El Manzano', 'Conforme', green, Icons.check_circle_rounded),
    const SampleRecord('12 sep, 09:40', 'Pozo Las Vertientes', 'Enviada', blue, Icons.cloud_done_rounded),
    const SampleRecord('10 sep, 16:20', 'Pozo Reserva Quebrada', 'Revisar cloro', amber, Icons.warning_amber_rounded),
    const SampleRecord('8 sep, 11:05', 'Pozo El Manzano', 'Conforme', green, Icons.check_circle_rounded),
  ];

  Future<void> openSample() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SampleWizard()),
    );
    if (saved == true && mounted) {
      setState(() {
        records.insert(
          0,
          const SampleRecord('Ahora', 'Pozo El Manzano', 'Pendiente de envío', amber, Icons.schedule_rounded),
        );
        tab = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Muestra guardada correctamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onNewSample: openSample),
      RecordsPage(records: records),
      const HelpPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: const Row(
          children: [
            AprLogo(size: 42),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('APR Terreno', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('El Manzano', style: TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No tienes notificaciones nuevas.')),
            ),
            icon: const Badge(child: Icon(Icons.notifications_none_rounded, color: navy)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(key: ValueKey(tab), child: pages[tab]),
      ),
      floatingActionButton: tab == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: openSample,
              backgroundColor: blue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nueva muestra', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        backgroundColor: Colors.white,
        indicatorColor: paleBlue,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Registros'),
          NavigationDestination(icon: Icon(Icons.help_outline_rounded), selectedIcon: Icon(Icons.help_rounded), label: 'Ayuda'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onNewSample});
  final VoidCallback onNewSample;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 110),
      children: [
        const Text('Hola, Juan 👋', style: pageTitle),
        const SizedBox(height: 5),
        const Text('Esto es lo que debes revisar hoy.', style: TextStyle(color: muted, fontSize: 15)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(color: const Color(0xFFE8F8F3), borderRadius: BorderRadius.circular(14)),
          child: const Row(
            children: [
              Icon(Icons.cloud_done_rounded, color: green, size: 21),
              SizedBox(width: 10),
              Expanded(child: Text('Todo sincronizado · conexión estable', style: TextStyle(color: Color(0xFF087A5B), fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF087CAA), Color(0xFF10A8C0)]),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: blue.withValues(alpha: .20), blurRadius: 20, offset: const Offset(0, 9))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.water_drop_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Muestra programada', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Pozo El Manzano', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              const Text('Hoy · antes de las 18:00', style: TextStyle(color: Color(0xFFDDF7FF), fontSize: 15)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onNewSample,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Comenzar registro', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Resumen de esta semana', style: sectionTitle),
        const SizedBox(height: 13),
        const Row(
          children: [
            Expanded(child: StatCard(value: '4', label: 'Muestras', icon: Icons.science_outlined, color: blue)),
            SizedBox(width: 12),
            Expanded(child: StatCard(value: '1', label: 'Pendiente', icon: Icons.schedule_rounded, color: amber)),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Próximas tareas', style: sectionTitle),
        const SizedBox(height: 12),
        const TaskTile(
          icon: Icons.water_drop_outlined,
          title: 'Medir cloro residual',
          subtitle: 'Pozo Las Vertientes · mañana',
          color: blue,
        ),
        const SizedBox(height: 10),
        const TaskTile(
          icon: Icons.local_shipping_outlined,
          title: 'Entregar muestras al laboratorio',
          subtitle: 'Miércoles · 09:00',
          color: green,
        ),
      ],
    );
  }
}

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key, required this.records});
  final List<SampleRecord> records;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  String filter = 'Todas';

  @override
  Widget build(BuildContext context) {
    final shown = filter == 'Todas'
        ? widget.records
        : widget.records.where((item) => filter == 'Pendientes' ? item.status.contains('Pendiente') : item.status == 'Conforme').toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 110),
      children: [
        const Text('Mis registros', style: pageTitle),
        const SizedBox(height: 5),
        const Text('Revisa las muestras que has tomado.', style: TextStyle(color: muted, fontSize: 15)),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Todas', 'Pendientes', 'Conformes'].map((label) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(label),
                  selected: filter == label,
                  onSelected: (_) => setState(() => filter = label),
                  selectedColor: paleBlue,
                  side: const BorderSide(color: border),
                  labelStyle: TextStyle(color: filter == label ? blue : navy, fontWeight: FontWeight.w700),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        ...shown.map((record) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: SurfaceCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(color: record.color.withValues(alpha: .10), borderRadius: BorderRadius.circular(14)),
                      child: Icon(record.icon, color: record.color),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.place, style: const TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(record.date, style: const TextStyle(color: muted, fontSize: 13)),
                          const SizedBox(height: 7),
                          StatusPill(record.status, record.color),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: muted),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 40),
      children: [
        const Text('Ayuda', style: pageTitle),
        const SizedBox(height: 5),
        const Text('Te acompañamos paso a paso.', style: TextStyle(color: muted, fontSize: 15)),
        const SizedBox(height: 20),
        SurfaceCard(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: const Color(0xFFFFEEF0), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.support_agent_rounded, color: red, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¿Necesitas ayuda ahora?', style: TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Llama al encargado técnico de tu APR.', style: TextStyle(color: muted, height: 1.35)),
                  ],
                ),
              ),
              IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Guías rápidas', style: sectionTitle),
        const SizedBox(height: 12),
        const HelpTile(
          icon: Icons.science_outlined,
          title: 'Cómo tomar una muestra',
          details: 'Lava tus manos, usa el frasco indicado y evita tocar su interior. Sigue el orden que muestra la aplicación.',
        ),
        const HelpTile(
          icon: Icons.water_drop_outlined,
          title: 'Cómo medir el cloro',
          details: 'Enjuaga el comparador, agrega la muestra hasta la marca y usa la tableta indicada. Compara el color de inmediato.',
        ),
        const HelpTile(
          icon: Icons.signal_wifi_off_rounded,
          title: 'Qué hacer si no hay señal',
          details: 'Completa el registro con normalidad. Quedará guardado en el teléfono y se enviará cuando recuperes conexión.',
        ),
        const HelpTile(
          icon: Icons.warning_amber_rounded,
          title: 'Qué hacer ante una alerta',
          details: 'No intentes corregir el resultado por tu cuenta. Repite la medición si la app lo solicita y contacta al encargado técnico.',
        ),
        const SizedBox(height: 18),
        const Center(child: Text('Versión de demostración 1.0', style: TextStyle(color: muted, fontSize: 12))),
      ],
    );
  }
}

class SampleWizard extends StatefulWidget {
  const SampleWizard({super.key});

  @override
  State<SampleWizard> createState() => _SampleWizardState();
}

class _SampleWizardState extends State<SampleWizard> {
  int step = 0;
  String apr = 'APR El Manzano';
  String well = 'Pozo El Manzano';
  String sampleType = 'Control rutinario';
  final ph = TextEditingController(text: '7.2');
  final chlorine = TextEditingController(text: '0.6');
  final notes = TextEditingController();
  bool photoAdded = false;

  @override
  void dispose() {
    ph.dispose();
    chlorine.dispose();
    notes.dispose();
    super.dispose();
  }

  void next() {
    if (step < 3) {
      setState(() => step++);
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          icon: const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFE8F8F3),
            child: Icon(Icons.check_rounded, color: green, size: 34),
          ),
          title: const Text('¡Registro completado!', textAlign: TextAlign.center, style: TextStyle(color: navy, fontWeight: FontWeight.w800)),
          content: const Text(
            'La muestra quedó guardada y será enviada al sistema APR.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, height: 1.4),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Volver a mis registros'),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Lugar de la muestra', 'Mediciones', 'Evidencia', 'Revisar y enviar'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Nueva muestra', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Paso ${step + 1} de 4', style: const TextStyle(color: blue, fontWeight: FontWeight.w700)),
                      Text('${((step + 1) * 25)}%', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: (step + 1) / 4, minHeight: 7, backgroundColor: paleBlue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                children: [
                  Text(titles[step], style: pageTitle),
                  const SizedBox(height: 6),
                  Text(_subtitle(step), style: const TextStyle(color: muted, fontSize: 15, height: 1.4)),
                  const SizedBox(height: 22),
                  if (step == 0) _locationStep(),
                  if (step == 1) _measurementStep(),
                  if (step == 2) _evidenceStep(),
                  if (step == 3) _reviewStep(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: border))),
              child: Row(
                children: [
                  if (step > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => step--),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: border)),
                        child: const Text('Atrás'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: step > 0 ? 2 : 1,
                    child: PrimaryButton(
                      label: step == 3 ? 'Guardar y enviar' : 'Continuar',
                      icon: step == 3 ? Icons.cloud_upload_outlined : Icons.arrow_forward_rounded,
                      onPressed: next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(int current) => [
        'Confirma dónde estás tomando esta muestra.',
        'Ingresa los valores que muestran tus instrumentos.',
        'Agrega una foto y cualquier situación que debamos conocer.',
        'Comprueba que la información esté correcta antes de enviarla.',
      ][current];

  Widget _locationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel('Sistema de agua potable rural'),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: apr,
          items: ['APR El Manzano', 'APR Las Palmeras'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
          onChanged: (value) => setState(() => apr = value!),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Pozo o punto de muestra'),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: well,
          items: ['Pozo El Manzano', 'Pozo Reserva Quebrada', 'Pozo Las Vertientes']
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (value) => setState(() => well = value!),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Motivo de la muestra'),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: sampleType,
          items: ['Control rutinario', 'Re-muestreo', 'Incidente informado']
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (value) => setState(() => sampleType = value!),
        ),
        const SizedBox(height: 18),
        const Row(
          children: [
            Expanded(child: InfoBox(icon: Icons.calendar_today_outlined, label: 'Fecha', value: 'Hoy, 4 oct.')),
            SizedBox(width: 10),
            Expanded(child: InfoBox(icon: Icons.schedule_outlined, label: 'Hora', value: '10:15')),
          ],
        ),
        const SizedBox(height: 14),
        const InlineMessage(
          icon: Icons.location_on_outlined,
          text: 'Ubicación registrada automáticamente.',
          color: blue,
        ),
      ],
    );
  }

  Widget _measurementStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const InstructionCard(
          number: '1',
          title: 'Deja correr el agua',
          description: 'Espera entre 2 y 3 minutos antes de llenar el recipiente.',
          icon: Icons.timer_outlined,
        ),
        const SizedBox(height: 14),
        MeasurementField(
          label: 'pH',
          unit: '',
          controller: ph,
          helper: 'Rango esperado: 6,5 a 8,5',
          status: 'Dentro del rango esperado',
          color: green,
        ),
        const SizedBox(height: 16),
        MeasurementField(
          label: 'Cloro libre residual',
          unit: 'mg/L',
          controller: chlorine,
          helper: 'Rango recomendado: 0,2 a 2,0 mg/L',
          status: 'Dentro del rango recomendado',
          color: green,
        ),
        const SizedBox(height: 14),
        const InlineMessage(
          icon: Icons.info_outline_rounded,
          text: 'Copia exactamente el número que aparece en el instrumento. La app avisará si debes repetir la medición.',
          color: blue,
        ),
      ],
    );
  }

  Widget _evidenceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => photoAdded = !photoAdded),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: photoAdded ? const Color(0xFFE8F8F3) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: photoAdded ? green : border, width: photoAdded ? 1.5 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(photoAdded ? Icons.check_circle_rounded : Icons.add_a_photo_outlined, color: photoAdded ? green : blue, size: 42),
                const SizedBox(height: 12),
                Text(photoAdded ? 'Foto agregada' : 'Tomar foto del punto', style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 5),
                Text(photoAdded ? 'Toca para cambiarla' : 'Incluye el grifo y su entorno', style: const TextStyle(color: muted)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('¿Ocurrió algo fuera de lo normal?'),
        const SizedBox(height: 7),
        TextField(
          controller: notes,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Ej.: agua turbia, fuga, mal olor…'),
        ),
        const SizedBox(height: 12),
        const Text('La observación es opcional. Escríbela con tus propias palabras.', style: TextStyle(color: muted, fontSize: 13)),
      ],
    );
  }

  Widget _reviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              ReviewRow(icon: Icons.location_on_outlined, label: 'Lugar', value: well),
              const Divider(height: 28, color: border),
              ReviewRow(icon: Icons.science_outlined, label: 'Motivo', value: sampleType),
              const Divider(height: 28, color: border),
              ReviewRow(icon: Icons.water_drop_outlined, label: 'pH', value: ph.text),
              const Divider(height: 28, color: border),
              ReviewRow(icon: Icons.opacity_rounded, label: 'Cloro residual', value: '${chlorine.text} mg/L'),
              const Divider(height: 28, color: border),
              ReviewRow(icon: Icons.photo_camera_outlined, label: 'Fotografía', value: photoAdded ? 'Agregada' : 'Sin fotografía'),
              if (notes.text.trim().isNotEmpty) ...[
                const Divider(height: 28, color: border),
                ReviewRow(icon: Icons.notes_rounded, label: 'Observación', value: notes.text.trim()),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        const InlineMessage(
          icon: Icons.verified_user_outlined,
          text: 'Los valores están dentro de los rangos esperados. Puedes enviar el registro.',
          color: green,
        ),
        const SizedBox(height: 14),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_done_outlined, color: muted, size: 18),
            SizedBox(width: 7),
            Text('Se enviará ahora porque tienes conexión', style: TextStyle(color: muted, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

const pageTitle = TextStyle(color: navy, fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -.4);
const sectionTitle = TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800);

class AprLogo extends StatelessWidget {
  const AprLogo({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [blue, cyan]),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: blue.withValues(alpha: .16), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Icon(Icons.water_drop_outlined, color: Colors.white, size: size * .55),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [BoxShadow(color: navy.withValues(alpha: .035), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon = Icons.arrow_forward_rounded});
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      iconAlignment: IconAlignment.end,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 14));
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.value, required this.label, required this.icon, required this.color});
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: navy, fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.icon, required this.title, required this.subtitle, required this.color});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: muted, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: muted),
        ],
      ),
    );
  }
}

class HelpTile extends StatelessWidget {
  const HelpTile({super.key, required this.icon, required this.title, required this.details});
  final IconData icon;
  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: paleBlue, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: blue),
          ),
          title: Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w700)),
          children: [Text(details, style: const TextStyle(color: muted, height: 1.5))],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, this.color, {super.key});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class InstructionCard extends StatelessWidget {
  const InstructionCard({super.key, required this.number, required this.title, required this.description, required this.icon});
  final String number;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: paleBlue, borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: blue, size: 27),
              ),
              Positioned(
                right: -5,
                top: -7,
                child: CircleAvatar(radius: 11, backgroundColor: blue, child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: muted, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MeasurementField extends StatelessWidget {
  const MeasurementField({
    super.key,
    required this.label,
    required this.unit,
    required this.controller,
    required this.helper,
    required this.status,
    required this.color,
  });
  final String label;
  final String unit;
  final TextEditingController controller;
  final String helper;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 5),
          Text(helper, style: const TextStyle(color: muted, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 20),
            decoration: InputDecoration(suffixText: unit, suffixStyle: const TextStyle(color: navy, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: color, size: 18),
              const SizedBox(width: 7),
              Expanded(child: Text(status, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
            ],
          ),
        ],
      ),
    );
  }
}

class InlineMessage extends StatelessWidget {
  const InlineMessage({super.key, required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: .08), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 13, height: 1.4, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 21),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: muted, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewRow extends StatelessWidget {
  const ReviewRow({super.key, required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: blue, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: muted))),
        const SizedBox(width: 10),
        Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: navy, fontWeight: FontWeight.w700))),
      ],
    );
  }
}

class SampleRecord {
  const SampleRecord(this.date, this.place, this.status, this.color, this.icon);
  final String date;
  final String place;
  final String status;
  final Color color;
  final IconData icon;
}
