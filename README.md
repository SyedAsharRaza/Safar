# 🛣️ Bahawalpur Safar

**Know the road before you take it.**

Bahawalpur Safar is a community-powered route-awareness app that helps people choose better-informed routes by combining navigation with live, community-submitted reports about poor lighting, road damage, seepage, blocked streets, traffic hazards, and local safety concerns.

> A normal map app answers *"What's the fastest way?"*
> Bahawalpur Safar answers *"What should I know about this route before I travel?"*

---

## 📖 Problem Statement

Residents travelling through Bahawalpur often make route decisions without timely information about road damage, seepage, blockages, lighting, traffic hazards, and local safety concerns. Bahawalpur Safar turns community observations into structured route-awareness signals so travellers can compare routes and make better-informed decisions.

This app **does not** predict crime or guarantee safety. It surfaces recent, unverified community signals so people can make their own informed choice.

---

## ✨ Core Features

- 📍 **Route comparison** — Fastest / Better-lit / Fewer-hazards route options
- 📝 **Community reporting** — Submit issues in English, Urdu, or Roman Urdu (e.g. *"Aagay gali band hai"*, *"Yahan seepage hai"*)
- 🤖 **AI classification** — Gemini converts informal, mixed-language reports into structured JSON signals
- 🗺️ **Live map markers** — Reports plotted on affected road segments
- 🔊 **Voice warnings** — Flutter TTS announces hazards in English/Urdu/Roman Urdu
- ✅ **Safety check-in** — Timer-based "I arrived safely" flow
- 🛡️ **Privacy-first** — Anonymous reports, no names/faces/plates, time-decayed signals, confidence labels

---

## 🧩 Report Categories

| Category | Examples |
|---|---|
| **Safety concerns** | Mobile/vehicle snatching, suspicious activity, harassment |
| **Lighting & visibility** | Broken streetlight, dark road, broken traffic signal |
| **Road condition** | Damage, pothole, seepage, standing water, flooding, debris |
| **Access & traffic** | Blocked street, road closed, construction, accident, heavy traffic |

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter |
| Database | Firebase Firestore |
| Auth | Anonymous Firebase Auth (or no login for demo) |
| AI | Gemini Flash |
| Backend | Firebase Cloud Functions / small secure backend |
| Maps | Google Maps Flutter plugin (static map fallback) |
| Voice | flutter_tts |
| State management | Provider or Riverpod |
| HTTP | http / dio |

> ⚠️ Verify current Firestore and Gemini free-tier quotas in official docs before relying on them for the demo.

---

## 📂 Project Structure

```
lib/
 ├── main.dart
 ├── core/
 │   ├── constants/
 │   ├── theme/
 │   └── utils/
 ├── models/
 │   ├── safety_report.dart
 │   ├── road_segment.dart
 │   ├── route_option.dart
 │   ├── ai_report_result.dart
 │   ├── risk_signal.dart
 │   └── safety_checkin.dart
 ├── screens/
 │   ├── home/
 │   ├── route_results/
 │   ├── route_details/
 │   ├── report/
 │   ├── report_review/
 │   ├── checkin/
 │   └── settings/
 ├── widgets/
 │   ├── map_view.dart
 │   ├── route_card.dart
 │   ├── report_marker.dart
 │   ├── risk_badge.dart
 │   ├── confidence_indicator.dart
 │   ├── voice_warning_button.dart
 │   └── disclaimer_banner.dart
 ├── services/
 │   ├── route_service.dart
 │   ├── report_service.dart
 │   ├── gemini_service.dart
 │   ├── risk_engine.dart
 │   ├── speech_service.dart
 │   ├── checkin_service.dart
 │   └── firebase_service.dart
 ├── repositories/
 │   ├── route_repository.dart
 │   └── report_repository.dart
 └── providers/
     ├── route_provider.dart
     ├── report_provider.dart
     └── checkin_provider.dart
```

---

## 🔥 Firestore Collections

- **`reports`** — individual community reports (category, location, confidence, severity, status)
- **`road_segments`** — aggregated scores per road segment (lighting, condition, active report count)
- **`routes`** — seeded/precomputed route options with segment IDs and polylines
- **`checkins`** — active safety check-in sessions

Sample document shapes are in the [full blueprint](#) (see `docs/` or original spec).

---

## 🤖 Gemini Integration

Gemini classifies free-text reports (English / Urdu / Roman Urdu) into strict JSON:

```json
{
  "category": "water_or_drainage",
  "specificType": "standing_water",
  "summary": "Standing water may make the road difficult for motorcycles.",
  "language": "roman_urdu",
  "severity": "medium",
  "urgency": "medium",
  "confidence": 0.92,
  "safePublicText": "Community report: standing water may affect motorcycle travel.",
  "needsConfirmation": true,
  "doNotPublish": false
}
```

**Gemini does:** classification, translation, neutral summaries, vagueness/PII detection.
**Gemini does NOT:** route scoring, crime prediction, declaring roads "safe" or "dangerous", identifying alleged criminals.

If Gemini fails or hits quota limits, the app falls back to **manual category selection** and continues normal route scoring — Gemini is never a single point of failure.

---

## 📐 Route-Awareness Algorithm

Deterministic, explainable scoring — no fake "safety percentages":

```
R_s = 0.35·C_s + 0.25·L_s + 0.20·D_s + 0.10·B_s + 0.10·U_s
```
- `C_s` = recent caution/safety reports
- `L_s` = lighting score
- `D_s` = road damage/seepage/flooding score
- `B_s` = blockage/traffic-hazard score
- `U_s` = uncertainty

Reports decay over time: `W = W0 * e^(-ageHours/decayHours)`

Route score = length-weighted average of its segment scores.

Labels shown to users: *"Low reported caution"*, *"Moderate reported caution"*, *"Elevated caution"*, *"Limited data available"* — never a fake percentage.

---

## 🔒 Privacy & Abuse Prevention

- Anonymous by default, no names/faces/phone numbers/plates
- No public accusations against identifiable people
- Approximate location for sensitive safety reports
- Time decay + report expiry
- User correction & dispute of AI-assigned categories
- Rate limiting & duplicate detection
- Confidence labels shown on every report
- Gemini API key never shipped inside the Flutter app

---

## 🚀 Getting Started

```bash
git clone <repo-url>
cd bahawalpur_safar
flutter pub get
flutter run
```

### Environment setup
1. Create a Firebase project → enable Firestore + Anonymous Auth
2. Add `google-services.json` / `GoogleService-Info.plist`
3. Set up a Cloud Function (or small backend) to proxy Gemini API calls — **never** embed the Gemini key client-side
4. Add your Google Maps API key, or use the seeded static-map fallback if unavailable

---

## 🎬 Demo Flow

1. Open app → enter destination
2. See 3 route options (Fastest / Better-lit / Fewer-hazards)
3. Select "Fewer hazards" → view explanation
4. Hear a Roman Urdu voice warning
5. Submit report: *"Aagay gali band hai"*
6. Gemini classifies it as `road_blockage`
7. User confirms → report saved to Firestore
8. Map & route card update live
9. Start a safety check-in

---

## ⚠️ Disclaimer

> Community reports may be incomplete or unverified. This app does not guarantee safety or road availability. It is not a police replacement, emergency dispatch system, or crime-prediction tool.

---

## 👥 Team (3-person split)

| Role | Responsibility |
|---|---|
| Dev 1 | Flutter screens, map, route cards |
| Dev 2 | Firebase, reports, risk engine, seeded data |
| Dev 3 | Gemini integration, voice warnings, testing, pitch |

---

## 📄 License

Hackathon prototype — add your preferred license here.
