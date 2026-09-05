# Testing Guide

## Overview

This repository provides a reusable runner for executing the Jakarta Data 1.1 TCK against a Jakarta EE runtime.

The runner is intentionally kept generic. Runtime-specific bugs should be reproduced and diagnosed separately from the runner itself.

## Prerequisites

Before running the tests, make sure you have:

* JDK 17 or later
* Maven 3.9 or later
* Git
* A Jakarta EE runtime supporting Jakarta Data 1.1
* A locally built or installed Open Liberty runtime when testing Open Liberty

Verify Java and Maven:

```bash
java -version
mvn -version
```

## Open Liberty Runtime

The runner can use an existing Open Liberty installation.

For a local Open Liberty development build, pass the installation directory explicitly:

```bash
-Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp
```

The runtime must contain the Jakarta Data 1.1 feature.

For Open Liberty, verify that the runtime contains:

```text
lib/features/io.openliberty.data-1.1.mf
lib/features/io.openliberty.jakarta.data-1.1.mf
```

## Running the Async TCK

The Phase 1 test can be executed with:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

A successful run should report:

```text
Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
```

and Maven should finish with:

```text
BUILD SUCCESS
```

## Running a Specific Test Method

A specific TCK test method can be selected with Maven Surefire:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests#testMethodName
```

Replace `testMethodName` with the actual test method.

This is useful when investigating a particular TCK scenario.

## Running Other TCK Tests

The runner uses the Jakarta Data TCK as a Maven test dependency and configures Surefire to scan the TCK dependency.

A specific TCK test class can be selected with:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=<TCK-test-class>
```

When adding or investigating a new test area, first verify that the requested test is present in the TCK version resolved by Maven.

## Verifying Jakarta Data 1.1

The runner must execute against Jakarta Data 1.1.

The Liberty configuration should contain:

```xml
<feature>data-1.1</feature>
```

It must not accidentally use:

```xml
<feature>data-1.0</feature>
```

When the server starts, check the Liberty console output or server log for the installed features.

A successful configuration should include:

```text
data-1.1
```

For example:

```text
CWWKF0012I: The server installed the following features: [..., data-1.1, ...]
```

## Test Database

The runner uses an embedded Derby database so that tests do not require an externally managed database.

The database configuration is defined in:

```text
src/main/liberty/config/server.xml
```

The default datasource is:

```text
DefaultDataSource
```

This provides the default datasource used by Jakarta Data repositories that do not specify another datastore.

## Understanding Test Failures

When a test fails, first determine which layer is responsible.

### Runner or Configuration Failure

Examples include:

* Incorrect Liberty installation directory
* Incorrect Liberty feature configuration
* Arquillian cannot start the server
* TCK deployment fails
* TCK test discovery fails
* Datasource configuration is invalid
* The wrong Jakarta Data feature is installed

These problems should normally be fixed in this repository.

### Runtime Implementation Failure

Examples include:

* An exception inside the Jakarta Data implementation
* Persistence initialization failure
* A Jakarta Data implementation defect
* An unsupported Jakarta EE API required by the test
* A failure occurring inside the application server before the test body executes

These problems should normally be reproduced independently and reported against the runtime implementation.

The generic runner should not accumulate workarounds for individual runtime defects.

## Clean Test Run

For a clean test run:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

The `clean` phase removes previous Maven build and test artifacts before execution.

## Reproducing an Issue

When using this repository to reproduce a Jakarta Data TCK issue:

1. Identify the exact TCK test class or method.
2. Confirm that the test exists in the resolved TCK version.
3. Confirm the runtime installation being tested.
4. Confirm that `data-1.1` is installed.
5. Run the smallest possible test.
6. Capture the Maven output.
7. Capture the relevant Liberty server log.
8. Record the Java and runtime versions.
9. Determine whether the failure occurs in the runner or runtime implementation.

Example:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

## Reporting a Failure

When reporting a failure, include:

* Operating system
* Java version
* Maven version
* Jakarta Data TCK version
* Jakarta Data API version
* Jakarta EE runtime and version
* Runtime feature configuration
* Exact Maven command
* Test class or method
* Complete relevant exception and stack trace
* Relevant Liberty server log
* Whether the failure occurs during deployment, initialization, or test execution

This information makes it easier to distinguish a runner problem from a runtime implementation problem.

## Runtime Warnings

Not every message printed by the runtime represents a TCK failure.

For example, Liberty may print configuration or datasource-related warnings while the selected TCK test still completes successfully.

A warning should not automatically be treated as a test failure.

The authoritative result is the TCK/Maven test result together with the runtime logs.

## Debugging

When additional diagnostics are required, increase the Liberty logging or Maven output as appropriate.

Avoid permanently adding issue-specific debugging configuration to the generic runner unless it is generally useful for future TCK investigations.

## CI

The same Maven commands used for local testing should remain usable in CI wherever the required Jakarta EE runtime is available.

CI configuration can be added independently from the generic test runner.

## Test Philosophy

This project follows a minimal-runner principle:

> The runner should provide the infrastructure required to execute the Jakarta Data TCK, not encode fixes for individual implementation bugs.

When a TCK test exposes a runtime problem, keep the runner generic and track the runtime problem in the appropriate implementation project.

## Before Committing Changes

Before committing changes to the runner or its test configuration, run:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

Then check for whitespace errors:

```bash
git diff --check
```

Review the changes before committing:

```bash
git diff
```
