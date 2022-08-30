class AppConfig {
  static const appName = "Fastwhistle Driver";
  static const enableLog = true;
  static const debugBanner = false;

  //API CONFIG
  static const apiUrl = "http://admin.fastwhistle.com:3100/v3/driver/";
  static const baseUrl = "http://admin.fastwhistle.com:3100/";
  static List noAuthApis = ["login", "appVersion"];
  static const googleApiKey = "AIzaSyD-9eHhlSOtkrv_hJ1yXohCmtrJ8mNEG2c";

  //APP SESSION CONSTANTS
  static const userData = "userData";
  static const appIntro = "appIntro";
  static const currentIndex = "currentIndex";
}
