
---

# `todo_week_1.md`

**Goal:** A usable daily planner with chunk-based time, activity planning, and *working* app blocking via Accessibility.

---

## DAY 0 – Setup & Guardrails (½ day)

**Objective:** Eliminate environment and scope risk before building features.

* [x] Verify devshell works

  * [x] `flutter doctor -v` clean
  * [x] `cd android && ./gradlew tasks`
* [ ] Confirm AccessibilityService can be compiled
* [ ] Decide default chunk template (write it down)
* [ ] Write README with *non-negotiables*:

  * No minute scheduling
  * No ads
  * No cloud
  * Mode-based rules only

**Exit condition:**
You can run Flutter (Linux) + Android build without errors.

---

## DAY 1 – Core Models + Calendar (Flutter)

**Objective:** Lock in the data model and day navigation.

### Models

* [x] `DayChunk`

  * [x] startHour
  * [x] endHour
  * [x] name
* [x] `ChunkActivity`

  * [x] title
  * [x] done
* [x] Barrel file `models.dart`

### Calendar

* [x] Week-only `TableCalendar`
* [x] Select day → update state
* [ ] Reset selected chunk on day change
* [ ] Default chunk template loads for every day

**Exit condition:**
You can switch days and see the same chunk structure without crashes.

---

## DAY 2 – 24h Horizontal Timeline (Flutter)

**Objective:** Build the *correct* mental model: time first, chunks second.

### Timeline

* [x] Fixed 24-hour rail (00 → 23)
* [x] Constant `hourWidth`
* [x] Absolute-positioned chunk overlays
* [x] Tap chunk → select

### Desktop UX (Linux)

* [x] Click + drag horizontal scrolling
* [x] Timeline scrolls smoothly
* [x] No ListView-based chunk scrolling

**Exit condition:**
You can scroll through the entire day and visually understand “where you are in time”.

---

## DAY 3 – Chunk Activities + Admin Planning (Flutter)

**Objective:** Make planning possible *without* over-precision.

### Activities

* [x] Activity list per chunk
* [ ] Add activity (text only)
* [ ] Toggle done / not done
* [ ] Delete activity

### Rules

* [ ] Activities belong to chunks, not hours
* [ ] No start/end times
* [ ] Admin chunk allows editing
* [ ] Other chunks are read-only

**Exit condition:**
You can plan tomorrow in Admin and see tasks appear under the right chunks.

---

## DAY 4 – Accessibility Service Skeleton (Kotlin)

**Objective:** Get Android system hooks alive.

### Permissions & Config

* [ ] AccessibilityService declared in manifest
* [ ] `accessibility_config.xml`
* [ ] Service appears in system accessibility settings

### Service Logic

* [ ] Listen for `TYPE_WINDOW_STATE_CHANGED`
* [ ] Detect foreground package name
* [ ] Log detected apps (for now)

**Exit condition:**
You can see log output when switching apps.

---

## DAY 5 – App Blocking Enforcement (Kotlin)

**Objective:** Enforce focus modes *for real*.

### Blocking

* [ ] Hardcoded blocked apps list (temporary)
* [ ] Kick to home on blocked app
* [ ] Ignore whitelisted apps (WhatsApp, phone, etc.)
* [ ] Debounce repeated triggers

### UX

* [ ] Optional basic overlay (“Blocked during Deep Work”)
* [ ] Clear explanation text

**Exit condition:**
Opening Instagram during Deep Work immediately fails.

---

## DAY 6 – Flutter ↔ Kotlin Bridge

**Objective:** Make the system respond to *your chunks*, not hardcoded rules.

### MethodChannel

* [ ] Channel: `timely/blocker`
* [ ] Flutter → Kotlin:

  * [ ] Current mode
  * [ ] Blocked app list
  * [ ] Whitelist
* [ ] Kotlin caches rules in memory

### Integration

* [ ] On chunk change → update Kotlin
* [ ] On app resume → resend state

**Exit condition:**
Changing chunks in Flutter changes what gets blocked.

---

## DAY 7 – Polish, Fail-safes, Reflection

**Objective:** Make it livable, not perfect.

### UX

* [ ] Selected chunk clearly highlighted
* [ ] Calm colors (no red panic UI)
* [ ] Clear “why am I blocked?” copy

### Safety

* [ ] Emergency unlock (5–10 min allow)
* [ ] Accessibility disabled → app degrades gracefully
* [ ] No crashes on restart

### Reflection

* [ ] Use the app for a full day
* [ ] Write down:

  * What felt good
  * What felt annoying
  * What you *didn’t* need

**Exit condition:**
You actually want to keep using it tomorrow.

---

