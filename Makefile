clean:
	fvm flutter clean && fvm flutter pub get && fvm dart pub global run dependency_validator

build_runner:
	fvm flutter pub run build_runner build --delete-conflicting-outputs