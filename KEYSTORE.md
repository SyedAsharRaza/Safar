# Release signing

## ⚠️ Read this first

`android/safar-upload.jks` is the **only** key that can sign updates to this
app. Google Play ties a listing to its signing certificate permanently.

**If you lose this file, you can never update the app on Play.** Not "call
support" — there is no recovery. You would have to publish a brand new listing
and every existing user would have to reinstall.

Both files are gitignored and must stay that way:

| File | Contains |
|---|---|
| `android/safar-upload.jks` | The private signing key |
| `android/key.properties` | The passwords for it |

**Back both up today**, somewhere that is not this laptop and not the repo — a
password manager, or an encrypted archive in your own cloud drive. Share them
with teammates directly, never through git or a public channel.

---

## What was created

| | |
|---|---|
| Keystore | `android/safar-upload.jks` |
| Alias | `safar-upload` |
| Algorithm | RSA 2048 |
| Valid until | **12 February 2054** |
| Password | in `android/key.properties` (28-char random, same for store and key) |

Certificate fingerprints:

```
SHA-1    52:2A:F2:B3:E0:C2:0E:4A:30:FC:AA:CC:4D:50:10:EF:7E:56:8A:31
SHA-256  69:1F:80:9D:FE:57:90:D1:E8:F9:D5:17:AE:F7:27:B6:6E:C5:7F:28:8D:76:58:13:5F:67:D5:22:AD:16:66:12
```

Your **debug** key, for local development builds:

```
SHA-1    2E:97:7A:55:A9:82:B2:24:35:DE:54:D0:C0:2E:7B:32:03:D8:5F:82
```

---

## Register both fingerprints

**Google Cloud → Credentials → your Maps API key → Application restrictions →
Android apps.** Add two entries, both with package
`pk.bahawalpursafar.bahawalpur_safar`:

- the **release** SHA-1, so distributed builds can load maps
- the **debug** SHA-1, so your own `flutter run` still works

Miss the release one and maps go blank in the APK you hand out — with no error
message, just grey tiles.

**Firebase → Project settings → Your apps → Android → Add fingerprint.** Same
two. Not required for FCM, but needed if you later add Firebase Auth or
Dynamic Links.

---

## Building

Signing is automatic — `android/app/build.gradle.kts` reads `key.properties`:

```bash
flutter build apk --release              # 56 MB, signed, minified
flutter build appbundle --release        # for Play Store
```

On a fresh clone without `key.properties` the release build falls back to the
debug key rather than failing, so a teammate can still produce a testable
build. It just cannot be published.

Check which key signed an APK:

```bash
$ANDROID_HOME/build-tools/36.0.0/apksigner verify --print-certs \
  build/app/outputs/flutter-apk/app-release.apk
```

Correct output shows `CN=Safar`. If it says `CN=Android Debug`, the keystore
was not picked up.

---

## Release build settings

`isMinifyEnabled` and `isShrinkResources` are on, which is what takes the APK
from 169 MB to 56 MB. Shrinking can strip classes that are only reached by
reflection, so `android/app/proguard-rules.pro` protects Google Maps, Firebase
Messaging, local notifications and TTS.

**Always smoke-test the release build**, not just debug. A minified build that
crashes will do so only in the version you hand out. This one was installed and
exercised on a physical device — maps, live data and markers all verified.

---

## Rotating the password

```bash
keytool -storepasswd -keystore android/safar-upload.jks
keytool -keypasswd  -keystore android/safar-upload.jks -alias safar-upload
```

Then update `android/key.properties`. The certificate is unchanged, so
fingerprints stay valid.
