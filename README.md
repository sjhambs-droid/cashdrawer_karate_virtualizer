# 💳 Cash Drawer Virtualizer for POS Testing (Karate + WireMock)

## 📘 Overview
This project virtualizes a **cash drawer device** using **WireMock** and integrates seamlessly with **Karate** test automation.  
It allows you to simulate drawer open/close operations, status queries, hardware failures, and delays without physical hardware.

---

## 🧱 Project Structure

```
cashdrawer-karate/
├── docker/
│   └── cashdrawer-virtual/
│       ├── docker-compose.yml           # Starts WireMock container
│       ├── mappings/                    # Stub definitions
│       │   ├── 000-open-drawer.json
│       │   ├── 001-status-open.json
│       │   ├── 002-close.json
│       │   ├── 003-status-closed.json
│       │   ├── 004-open-failure.json
│       │   ├── 005-open-delayed.json
│       │   └── 006-reset-state.json
│       └── __files/
│           └── readme.txt
├── src/test/java/cashdrawer/
│   ├── open_close.feature               # Karate test suite
│   └── karate-config.js                 # Global Karate config
└── cashdrawer_karate_virtualizer.zip    # Packaged version
```

---

## 🚀 Getting Started

### 1️⃣ Prerequisites
- **Docker** and **Docker Compose** installed
- **Java 8+** and **Maven**
- **Karate** dependency in your Maven project

```xml
<dependency>
  <groupId>com.intuit.karate</groupId>
  <artifactId>karate-junit5</artifactId>
  <version>1.5.0</version>
  <scope>test</scope>
</dependency>
```

---

### 2️⃣ Start the WireMock Cash Drawer
```bash
cd docker/cashdrawer-virtual
docker-compose up -d
```

WireMock runs at `http://localhost:8080`.

---

### 3️⃣ Run the Karate Tests
```bash
mvn test -Dtest=cashdrawer/open_close.feature
```

Expected results:
- Drawer opens and status returns **open**
- Drawer closes and status returns **closed**
- Failure and delay scenarios simulate negative paths
- Reset restores the scenario to initial state

---

## 🧩 Endpoints Exposed by Mock

| Method | Endpoint | Description | Example |
|--------|-----------|-------------|----------|
| POST | `/drawer/open` | Opens drawer | ✅ Successful open |
| GET | `/drawer/status` | Current drawer status | `{status: "open"}` |
| POST | `/drawer/close` | Closes drawer | ✅ Successful close |
| POST | `/drawer/open?fail=true` | Simulates jam/failure | ❌ 500 response |
| POST | `/drawer/open?mode=slow` | Delayed response | ⏱ Timeout tests |
| POST | `/drawer/reset` | Resets scenario to initial state | 🔁 Ready for next run |

---

## 🧠 Integration Tips

- Map this mock container (`cashdrawer-mock:8080`) to the POS service that controls the drawer.
- Use `karate.callSingle()` to reset state before suites.
- Record requests with `GET /__admin/requests` to verify drawer API calls.
- Add additional mappings for “drawer forced open” or “unauthorized access” events if needed.

---

## 🧪 CI/CD Example (GitHub Actions)

```yaml
name: POS Virtual Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Start Cash Drawer Virtualizer
        run: docker-compose -f docker/cashdrawer-virtual/docker-compose.yml up -d
      - name: Run Karate Tests
        run: mvn test -Dtest=cashdrawer/open_close.feature
      - name: Stop Virtualizer
        run: docker-compose -f docker/cashdrawer-virtual/docker-compose.yml down
```

---

## 🧰 Customization

You can add new mappings to simulate:
- Drawer timeout after open command
- Security PIN validation
- Random hardware disconnection
- Event callbacks via `__files/` templates

---

## 🏁 Summary

| Component | Purpose |
|------------|----------|
| **WireMock** | Virtualizes cash drawer API |
| **Karate** | Executes and validates test flows |
| **Docker Compose** | Container orchestration for mocks |
| **Reset Endpoint** | Ensures repeatable deterministic tests |

---

### Author
POS Virtualization Framework Extension for **Test Architect / QE Automation**.

