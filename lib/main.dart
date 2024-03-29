import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internative_blog/local_storage/storage.dart';
import 'package:provider/provider.dart';
import 'state/auth_controller.dart';
import 'state/user_controller.dart';
import 'screens/register.dart';
import 'screens/login.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage/storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_screen.dart';
import 'state/nav_bar_controller.dart';
import 'state/account_controller.dart';
import 'splash_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool reDirectToMainPage = false;

Future<void> main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  WidgetsFlutterBinding.ensureInitialized();

  // storage service
  await Hive.initFlutter();
  Hive.registerAdapter(CredentialsAdapter());

  var credsBox = await Hive.openBox<Credentials>('credentials');
  try {
    Credentials? creds = credsBox.get(0);
    if (creds?.token != null) {
      reDirectToMainPage = true;
    }
  } catch (e) {
    print(e);
  }

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  ).then((_) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => UserController(),
            ),
            ChangeNotifierProxyProvider<UserController, AuthController>(
              update: (context, userController, authController) =>
                  authController!..updateUserController(userController),
              create: (context) => AuthController(
                  userController: context.read<UserController>()),
            ),
            ChangeNotifierProvider(create: (context) => NavBarController()),
            ChangeNotifierProxyProvider<AuthController, AccountController>(
              update: (context, authController, accountController) =>
                  accountController!..updateAuthController(authController),
              create: (context) => AccountController(
                authController: context.read<AuthController>(),
              ),
            ),
            // StreamProvider(
            //     create: ((context) =>
            //         context.read<AccountController>().imageUploadStream),
            //     initialData: null),
          ],
          child: const MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xffffffff),
            centerTitle: true,
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: const Color(0xff292F3B)),
            shadowColor: const Color(0xff000000).withOpacity(0.3),
          ),
          bottomSheetTheme: BottomSheetThemeData(
              modalBackgroundColor: const Color(0xff000000).withOpacity(0.4)),
          // scaffoldBackgroundColor: Colors.white,
          scaffoldBackgroundColor: const Color(0xffFAFAFA),
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context)
                .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          ),
          // inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff292F3B),
            primary: const Color(0xff292F3B),
            secondary: const Color(0xffC4C9D2),
            // secondary:
          )),
      initialRoute: SplashScreen.id,
      //  reDirectToMainPage ? MainScreen.id : Register.id,
      routes: {
        Register.id: (_) => const Register(),
        Login.id: (_) => const Login(),
        MainScreen.id: (_) => const MainScreen(),
        SplashScreen.id: (_) => const SplashScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
