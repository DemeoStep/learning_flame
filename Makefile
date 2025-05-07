clean:
	fvm flutter clean && fvm flutter pub get && fvm dart pub global run dependency_validator

build_runner:
	fvm dart run build_runner build --delete-conflicting-outputs