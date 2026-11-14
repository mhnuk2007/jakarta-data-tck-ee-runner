# Testing Guide

## Overview

This repository provides a multi-provider test runner for executing the Jakarta Data 1.1 TCK against Jakarta EE application servers (including Open Liberty and GlassFish).

The project is structured as a multi-module Maven reactor:
* `runners/runner-liberty`: Open Liberty managed runner module
* `runners/runner-glassfish`: GlassFish managed runner module (Phase 2)

---

## Prerequisites

Before running the tests, verify your environment:

* **JDK 17 or 21**
* **Maven 3.9+**
* **Git**
* Pre-built target runtime:
  * Open Liberty development build image (e.g. `/d/opensource/open-liberty/dev/build.image/wlp`)
  * GlassFish 8 distribution (e.g. `/d/opensource/glassfish/glassfish8`)

Verify Java and Maven:
```bash
java -version
mvn -version
```

---

## Running TCK Tests

Use Maven's `-pl` (project list) flag to select the target runner module.

### 1. Open Liberty Runner (`runners/runner-liberty`)

#### Run an entire TCK test class:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dtest=AsyncTests"
```

#### Run a specific test method:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dtest=AsyncTests#testAsynchronousInsertExceptionalCompletion"
```

#### Run persistence unit / stateful tests:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dtest=StatefulPersistenceEntityTests#testModifyPersistedEntity"
```

### 2. GlassFish Runner (`runners/runner-glassfish` - Phase 2)

#### Run against GlassFish:
```bash
mvn test -pl runners/runner-glassfish \
  "-Dglassfish.home=/d/opensource/glassfish/glassfish8" \
  "-Dtest=AsyncTests"
```

### 3. Cross-Provider Execution

Run the same test across all configured runner modules sequentially:
```bash
mvn test \
  "-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp" \
  "-Dglassfish.home=/d/opensource/glassfish/glassfish8" \
  "-Dtest=AsyncTests"
```

---

## Runtime Verification

### Verifying Open Liberty Feature Installation
When validating tests against Open Liberty, confirm from server console output that `data-1.1` is installed:
```text
CWWKF0012I: The server installed the following features: [..., data-1.1, ...]
```
The server must not fall back to `data-1.0`.

### Database Configuration
`runner-liberty` automatically packages Apache Derby jars (`derby`, `derbytools`, `derbyshared`) into `${wlp}/usr/shared/resources/derby` and initializes `DefaultDataSource` in `server.xml`, eliminating the need for an external database daemon.

---

## Diagnosing & Reporting Failures

When a TCK test fails, determine whether the failure belongs to the runner harness or the underlying runtime implementation:

### Harness / Configuration Issue (Fix in this repo)
* Port or JNDI binding conflicts
* Arquillian adapter classpath collision
* Embedded Derby driver missing from server shared resources
* Arquillian container lifecycle timeout

### Runtime Implementation Defect (Report to server vendor)
* Internal NPE or ClassCastException during persistence-unit bootstrap (e.g. Open Liberty #35697)
* Missing implementation for Jakarta Persistence 4.0 query annotations
* Unsupported repository return types or async stage lifecycle violations

When filing an issue, provide:
1. Target runner module (`runner-liberty` or `runner-glassfish`)
2. Exact Maven command line
3. Full stack trace and server log excerpt
4. Java, Maven, and target server version/commit
