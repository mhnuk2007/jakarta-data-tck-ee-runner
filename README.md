# Jakarta Data TCK Multi-Provider Runner

A standalone, multi-provider Maven/Arquillian test runner for executing the **Jakarta Data 1.1 TCK** against **Jakarta EE application servers** (including **Open Liberty** and **GlassFish**).

This project provides a fast, repeatable, and vendor-neutral environment for validating Jakarta Data 1.1 TCK scenarios, isolating runtime bugs, and conducting cross-server behavior comparisons without invoking slow monolithic server builds.

---

## Purpose & Architecture

In-tree TCK runners within application server repositories are tightly bound to large CI reactors and locked TCK release tags. This runner provides an independent test harness organized as a **multi-module Maven reactor**:

* **Root Aggregator (`pom.xml`)**: Manages the Jakarta Data 1.1 TCK dependency contract, Arquillian BOMs, JUnit 5 platform, and shared test properties.
* **Open Liberty Runner (`runners/runner-liberty`)**: Configures the Open Liberty managed Arquillian container adapter, server features, and embedded Derby data source.
* **GlassFish Runner (`runners/runner-glassfish`)**: Configures the GlassFish managed Arquillian container adapter and JDBC resources.

```text
jakarta-data-tck-ee-runner/                       <-- Root aggregator & TCK BOM parent
├── pom.xml                                       <-- Root POM: shared dependencies & TCK properties
├── README.md                                     <-- Project overview, architecture & quickstart
├── CONTRIBUTING.md                               <-- Contribution standards & PR workflows
├── TESTING.md                                    <-- Matrix of tested scenarios, flags & troubleshooting
├── runners/
│   ├── runner-liberty/                           <-- Open Liberty runner module
│   │   ├── pom.xml                               <-- Liberty Arquillian adapter & WLP lifecycle
│   │   └── src/
│   │       ├── main/liberty/config/server.xml    <-- Liberty server config (DefaultDataSource, features)
│   │       └── test/resources/arquillian.xml     <-- Liberty managed container configuration
│   └── runner-glassfish/                         <-- GlassFish runner module
│       ├── pom.xml                               <-- GlassFish Arquillian adapter & lifecycle
│       └── src/test/resources/arquillian.xml     <-- GlassFish managed container configuration
```

---

## Current Status

* **Open Liberty Module (`runners/runner-liberty`)**: **Complete & Verified**
  * Asynchronous TCK tests: `ee.jakarta.tck.data.web.async.AsyncTests` (All 3 tests passed including exceptional completion).
  * Stateful persistence tests: `ee.jakarta.tck.data.standalone.persistence.stateful.StatefulPersistenceEntityTests` (Verified persistence context & Derby data source).
  * Runtime verified: Open Liberty with `data-1.1` and embedded Apache Derby `DefaultDataSource`.
* **GlassFish Module (`runners/runner-glassfish`)**: **In Progress (Phase 2)**

---

## Requirements

* **JDK 17 or 21**
* **Maven 3.9+**
* **Git**
* Pre-built target runtime:
  * Open Liberty development build image (e.g. `/d/opensource/open-liberty/dev/build.image/wlp`)
  * GlassFish 8 distribution (e.g. `/d/opensource/glassfish/glassfish8`)

---

## Quickstart: Running TCK Tests

Select the target server runner using Maven's standard project selector (`-pl`):

### 1. Running Against Open Liberty

Run an entire TCK test class:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dtest=AsyncTests"
```

Run an individual test method:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dtest=AsyncTests#testAsynchronousInsertExceptionalCompletion"
```

Run persistence unit / stateful database tests:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dtest=StatefulPersistenceEntityTests#testModifyPersistedEntity"
```

### 2. Running Against GlassFish (Phase 2)

```bash
mvn test -pl runners/runner-glassfish \
  "-Dglassfish.home=/d/opensource/glassfish/glassfish8" \
  "-Dtest=AsyncTests"
```

### 3. Running Across All Providers

```bash
mvn test \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dglassfish.home=/d/opensource/glassfish/glassfish8" \
  "-Dtest=AsyncTests"
```

---

## Runtime Configuration

### Open Liberty (`runners/runner-liberty`)
Configured in `runners/runner-liberty/src/main/liberty/config/server.xml`:
* **Features**: `data-1.1`, `servlet-6.1`, `cdi-4.1`, `persistence-3.2` / `persistenceContainer-3.2`.
* **Default Database**: Embedded Apache Derby initialized as `DefaultDataSource` in `usr/shared/resources/derby`.

---

## Known Runtime Limitations

### Open Liberty Persistence 4.0 Query API Limitation
Some Jakarta Data 1.1 TCK tests use Jakarta Persistence 4.0 annotations (`jakarta.persistence.query.JakartaQuery`, `jakarta.persistence.query.NativeQuery`, `jakarta.persistence.query.QueryOptions`).

Open Liberty currently supports a beta of Jakarta Data 1.1 alongside Jakarta Persistence 3.2. Until Open Liberty provides the Jakarta Persistence 4.0 feature, tests requiring Persistence 4.0 query annotations may encounter bootstrap limitations. These should be treated as Open Liberty runtime capability limitations rather than runner failures.

---

## Contributing

Contributions are welcome. Please read:
* [CONTRIBUTING.md](CONTRIBUTING.md)
* [TESTING.md](TESTING.md)
* [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
* [SECURITY.md](SECURITY.md)

---

## License

This project is licensed under the **Eclipse Public License 2.0**. See [LICENSE](LICENSE) for details.

## Maintainer

**Mohan Lal** &mdash; [@mhnuk2007](https://github.com/mhnuk2007)
