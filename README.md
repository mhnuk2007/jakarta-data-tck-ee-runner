# Jakarta Data TCK Runner

A reusable Maven/Arquillian test runner for executing the **Jakarta Data 1.1 TCK** against **Open Liberty**.

The project is intended to provide a simple and repeatable environment for validating Jakarta Data 1.1 TCK scenarios, reproducing TCK issues, and testing Open Liberty Jakarta Data implementations.

## Purpose

This repository provides a **generic TCK runner**, rather than a test-specific reproducer.

It is designed to make it easy to:

* Run individual Jakarta Data 1.1 TCK tests.
* Run groups of TCK tests.
* Run Jakarta Data TCK scenarios against a local Open Liberty build.
* Reproduce Jakarta Data 1.1 TCK issues.
* Validate fixes before submitting or reviewing upstream changes.
* Reuse the same runner for future Jakarta Data 1.1 TCK scenarios.

## Current Status

**Phase 1 — Initial TCK Runner: Complete**

The runner has successfully executed the complete asynchronous TCK test class:

```text
ee.jakarta.tck.data.web.async.AsyncTests
```

Test result:

```text
Tests run: 3, Failures: 0, Errors: 0, Skipped: 0
```

The validated test class includes asynchronous repository tests covering:

* Asynchronous find.
* Asynchronous insert.
* Exceptional completion of an asynchronous insert.

The exceptional-completion test verifies that when an asynchronous repository operation fails because an entity with the same identifier already exists, the returned `CompletionStage` completes exceptionally with `EntityExistsException` as the underlying cause.

The individual exceptional-completion test was also executed successfully:

```text
ee.jakarta.tck.data.web.async.AsyncTests#testAsynchronousInsertExceptionalCompletion
```

Result:

```text
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
```

The tests were executed against a locally built Open Liberty runtime with:

```text
data-1.1
```

installed and:

```text
data-1.0
```

removed.

The validated environment included:

* Open Liberty 26.0.0.10
* Jakarta Data 1.1 TCK `1.1.0-SNAPSHOT`
* Java 21
* Maven
* Apache Derby
* Arquillian

This validates that the generic runner consumes the locally built Jakarta Data 1.1 TCK and executes the tests end-to-end against the Open Liberty Jakarta Data 1.1 runtime.

## Requirements

The runner requires:

* JDK 17 or later
* Maven 3.9 or later
* Git
* Jakarta Data 1.1 TCK
* Open Liberty with Jakarta Data 1.1 support
* Apache Derby

A local Open Liberty development build can be used directly.

For example:

```text
/d/opensource/open-liberty/dev/build.image/wlp
```

## Running a TCK Test

Run the currently validated asynchronous TCK tests:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

The Open Liberty installation can be overridden with:

```bash
-Dliberty.installDirectory=/path/to/wlp
```

For example:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/open-liberty/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

## Runtime Configuration

The runner configures Open Liberty with the Jakarta Data 1.1 feature:

```xml
<feature>data-1.1</feature>
```

The server configuration also enables the required Jakarta EE features for the current TCK environment.

The runner uses an embedded Apache Derby database so that a separate database server is not required.

The default database is provided through:

```xml
<dataSource id="DefaultDataSource">
```

This supports Jakarta Data repositories that use the default data store.

## Project Structure

```text
jakarta-data-tck-ee-runner/
├── .gitignore
├── LICENSE
├── README.md
├── TESTING.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── pom.xml
└── src/
    ├── main/
    │   └── liberty/
    │       └── config/
    │           └── server.xml
    └── test/
        └── resources/
            └── arquillian.xml
```

## Design Goals

The runner is intended to remain:

* **Generic**
* **Reusable**
* **Minimal**
* **Easy to understand**
* **Easy to execute locally**
* **Suitable for future Jakarta Data 1.1 TCK issues**
* **Independent of any single TCK issue**

Issue-specific reproducer code should only be added when it is genuinely required by a TCK scenario.

## Selecting Tests

Individual TCK classes can be selected through Maven Surefire.

Example:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

A specific test method can also be selected when supported:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests#testMethodName
```

See [TESTING.md](TESTING.md) for more testing guidance.

## Verifying Jakarta Data 1.1

When validating a Jakarta Data 1.1 test, verify that the Open Liberty startup log reports:

```text
data-1.1
```

For example:

```text
CWWKF0012I: The server installed the following features:
[... data-1.1 ...]
```

The runtime must not silently fall back to:

```text
data-1.0
```

The selected TCK result should also report zero failures and errors.

Example:

```text
Tests run: 3, Failures: 0, Errors: 0, Skipped: 0
```

followed by:

```text
BUILD SUCCESS
```

## Reproducing Jakarta Data Issues

This runner can be used as a common environment for future Jakarta Data 1.1 TCK issues.

A typical workflow is:

```text
Jakarta Data TCK
       │
       ▼
Generic TCK Runner
       │
       ▼
Open Liberty
       │
       ▼
Jakarta Data 1.1
       │
       ▼
PASS / FAIL / ERROR
```

For an issue-specific test:

1. Identify the relevant TCK test class.
2. Identify the relevant test method.
3. Confirm the Jakarta Data TCK version.
4. Confirm the Open Liberty version or local build.
5. Run the smallest possible test.
6. Capture the Maven test result.
7. Capture relevant Open Liberty server messages.
8. Determine whether the problem is related to:

   * TCK behavior
   * Deployment
   * Runtime configuration
   * Jakarta Data implementation
   * Jakarta Persistence
   * Test environment
   * Tooling

## Known Runtime Limitations

A successful TCK test does not necessarily mean that every Jakarta Data 1.1 scenario is supported by the current Open Liberty build.

Some Jakarta Data 1.1 scenarios may depend on functionality that is still under development or may expose implementation issues in the runtime.

Such failures should be distinguished from problems in the generic runner itself.

The goal of this project is to provide a reliable test harness so that these failures can be isolated and reported accurately.

## Development

Clone the repository:

```bash
git clone https://github.com/mhnuk2007/jakarta-data-tck-ee-runner.git
cd jakarta-data-tck-ee-runner
```

Run the validated test:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

Before committing changes:

```bash
git diff --check
```

and:

```bash
git status
```

## Contributing

Contributions are welcome.

Please read:

* [CONTRIBUTING.md](CONTRIBUTING.md)
* [TESTING.md](TESTING.md)
* [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
* [SECURITY.md](SECURITY.md)

before contributing.

## License

This project is licensed under the **Eclipse Public License 2.0**.

See [LICENSE](LICENSE) for details.

## Related Projects

This runner works with the Jakarta Data TCK and Open Liberty ecosystem, including:

* Jakarta Data
* Jakarta Data TCK
* Open Liberty
* Arquillian
* Jakarta EE

## Maintainer

**Mohan Lal**

GitHub: [@mhnuk2007](https://github.com/mhnuk2007)

## Repository

https://github.com/mhnuk2007/jakarta-data-tck-ee-runner
