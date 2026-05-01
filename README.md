# Timely

[![License: AGPL v3](https://img.shields.io/badge/license-AGPL--3.0-purple.svg)](https://opensource.org/licenses/AGPL-3.0)
[![Flutter](https://img.shields.io/badge/Flutter-3.32-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-desktop%20%7C%20mobile-lightgrey)]()
[![Status](https://img.shields.io/badge/status-active-brightgreen)]()

> A time management app built around how your brain actually works — not how productivity culture thinks it should.

---

## 1. What Is Timely?

Timely is a focus and daily planning tool built on a simple but underappreciated idea from neuroscience: the mental burden of a task doesn't come from doing the task — it comes from the unresolved question of *when* you're going to do it.

When your brain doesn't know when something is happening, it keeps the loop open. It interrupts you. It second-guesses you. It drains energy that should be going toward the work itself.

Timely closes those loops. You assign tasks to time chunks in your day, commit to one thing per chunk, and then — crucially — you just do that thing. No switching, no renegotiating, no background anxiety about what comes next. The structure holds that for you.

The result is that focus becomes easier, not because you're more disciplined, but because you've removed the decision fatigue that was getting in the way.

---

## 2. Why I Built This

I built Timely alongside Cerebrum, my RAG-based learning assistant. Both projects come from the same place: my own experience of how hard it is to learn and work consistently when your brain is under strain.

What I found was that knowing *what* to study wasn't enough. I also needed to know *when*, and to have that commitment feel real — not just a note in a to-do list, but an actual slot in the day with a defined end. Once the chunk was set, I could stop thinking about it and just start.

Timely is that system made into an app. It's for anyone who finds that the planning overhead of their day is eating into the actual doing.

---

## 3. Core Features

### Time Chunking
Structure your day into focused time blocks. Each chunk is assigned to a single task or area of focus — no multitasking, no ambiguity about what you're supposed to be doing right now.

### Task Focus
Within each chunk, the app keeps you oriented on the one thing you committed to. The interface is intentionally simple: your task, your time, nothing else competing for attention.

### Daily Planning
See your full day laid out in chunks before it begins. Adjust, reorder, and commit to your structure — then let the app hold it so you don't have to carry it in your head.

---

## 4. The Neuroscience Behind It

The design is grounded in research on how attention and cognitive load actually work:

**Time-blocking reduces open loops.** The brain treats unscheduled tasks as open loops — items that require ongoing monitoring. Assigning a task to a specific time chunk signals to the brain that it's handled, reducing background cognitive load.

**Single-tasking protects focus depth.** Switching between tasks isn't free — there's a measurable cost in re-orienting attention each time. Committing to one thing per chunk minimises that cost.

**Defined endpoints reduce resistance.** Knowing a chunk has a clear end makes it easier to start. Open-ended work feels heavier than bounded work, even if the total effort is the same.

Timely is built to operationalise these principles in day-to-day use — not as a rigid system, but as a flexible structure you actually want to use.

---

## 5. Tech Stack

| | |
|---|---|
| Framework | Flutter |
| Language | Dart |
| Platform | Cross-platform (desktop, tablet, mobile) |

Flutter was chosen specifically for cross-platform reach. The goal is for Timely to work wherever you plan your day — desktop in the morning, phone on the go — without compromising the experience.

---

## 6. How to Run

**Requirements**
- Flutter 3.32+

**Setup**

```bash
git clone https://github.com/haephestus/timely.git
cd timely/timely
flutter pub get
flutter run
```

---

## 7. Project Status

Timely is in active development. Core time chunking and daily planning are functional. The interface is intentionally minimal — the goal is to do one thing well before adding more.

Planned features include session tracking, end-of-day review, and eventually integration with Cerebrum so your study chunks feed directly into your learning system.

---

## 8. Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

This project has a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you're expected to uphold it.

---

## 9. Related

- [Cerebrum](https://github.com/haephestus/Cerebrum) — The RAG-powered learning assistant this project is designed to complement
- [Cerebrum-Daemon](https://github.com/haephestus/Cerebrum-Daemon) — The backend that powers Cerebrum

---

## 10. License

MIT — see [LICENSE](LICENSE) for details.
