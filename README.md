# trapp
# start date: 2021-11-29

A new Flutter project.

## Commands

1. Prod build cmd `flutter build appbundle --target lib/main_prod.dart --release --flavor prod`
2. Qa build cmd `flutter build appbundle --target lib/main_qa.dart --release --flavor qa`
3. Checking release in local `flutter run --target lib/main_prod.dart --flavor prod`.
4. Checking the GTM open app with `adb shell am start -a "android.intent.action.VIEW" -d "tagmanager.c.com.tradilligence.TradeMantri://preview/p?id=GTM-T8K34MQ\&gtm_auth=yA9NmGEJ1TlAKsm0w8W3Qw\&gtm_preview=1"` (Not using anyway)
5. for FA-svc: `adb shell setprop log.tag.FA-SVC VERBOSE` and `adb shell setprop log.tag.FA VERBOSE`
6. Generate freezed entities: `flutter pub run build_runner build`.
7. Start CI/CD pipelines `aws codepipeline start-pipeline-execution --name tmusersapp-qa`

## Tasks

1. Disable UPI payment is toPay is greater than 1,00,000.