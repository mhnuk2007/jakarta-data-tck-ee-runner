# Contributing

Thank you for contributing to the Jakarta Data TCK EE Runner.

This project is intended to provide a small, reusable runner for executing Jakarta Data TCK tests against Jakarta EE runtimes.

## Project Goals

Contributions should preserve the following principles:

* Keep the runner generic and reusable.
* Keep the Maven and Liberty configuration minimal.
* Support future Jakarta Data TCK scenarios without issue-specific hacks.
* Make test execution reproducible.
* Keep runtime-specific defects separate from runner infrastructure.
* Prefer configuration and documentation improvements over unnecessary custom code.

## Before Making Changes

Create a branch for your change:

```bash
git checkout -b <branch-name>
```

Update your local branch before starting work:

```bash
git checkout main
git pull --ff-only
```

Then create your feature or fix branch:

```bash
git checkout -b <branch-name>
```

## Making Changes

When changing the runner:

1. Keep the change focused.
2. Avoid unrelated formatting changes.
3. Avoid adding runtime-specific workarounds.
4. Update documentation when behavior or configuration changes.
5. Keep existing TCK execution working.
6. Verify that the Jakarta Data 1.1 feature is still being used.

## Testing Changes

At minimum, run the Phase 1 Async TCK:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/path/to/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

For the local Open Liberty development build:

```bash
mvn clean verify \
  -Dliberty.installDirectory=/d/opensource/open-liberty/dev/build.image/wlp \
  -Dtest=ee.jakarta.tck.data.web.async.AsyncTests
```

Also check for whitespace errors:

```bash
git diff --check
```

Review the final changes:

```bash
git diff
```

## Adding TCK Coverage

When adding support for another TCK test or test area:

1. Confirm that the test exists in the resolved TCK version.
2. Identify the smallest useful test class or method.
3. Run the test against the configured Jakarta EE runtime.
4. Confirm that `data-1.1` is installed.
5. Determine whether failures originate from the runner or the runtime.
6. Do not add a workaround solely to make an implementation-specific failure pass.

## Runtime-Specific Problems

This repository should not contain workarounds for individual runtime implementation defects.

For example, if a TCK test fails because of an exception inside a Jakarta Data implementation, the preferred approach is to:

1. Reproduce the failure using this runner.
2. Capture the relevant TCK and runtime output.
3. Create or update the appropriate runtime issue.
4. Keep the generic runner unchanged unless the runner itself is defective.

## Documentation

Update the appropriate documentation when changing project behavior.

Relevant files include:

* `README.md` — project overview and quick start
* `TESTING.md` — testing and troubleshooting
* `CONTRIBUTING.md` — contribution workflow
* `CODE_OF_CONDUCT.md` — community expectations
* `SECURITY.md` — security reporting

## Commit Messages

Use concise commit messages that describe the change.

Examples:

```text
Add testing guide
Fix Liberty Data 1.1 configuration
Add TCK test selection documentation
Update contribution guidelines
```

Prefer imperative wording such as:

```text
Add ...
Fix ...
Update ...
Remove ...
```

## Pull Requests

A pull request should:

* Clearly describe the change.
* Explain why the change is needed.
* Include relevant test results.
* Keep unrelated changes out of the pull request.
* Update documentation when appropriate.
* Identify any known runtime-specific limitations.

Before opening a pull request, verify:

```bash
git status
git diff --check
```

and run the relevant tests.

## Issue Reproduction

When contributing an issue reproducer, provide:

* TCK test class or method
* Jakarta Data TCK version
* Jakarta Data API version
* Java version
* Jakarta EE runtime and version
* Runtime feature configuration
* Maven command
* Relevant exception
* Relevant server log

A reproducer should be as small and generic as practical.

## Code and Configuration Style

### Java

Follow normal Java conventions and keep changes simple.

### XML

Keep Liberty and Arquillian configuration readable and consistently formatted.

### Maven

Avoid unnecessary dependencies and plugins.

Changes to the Maven build should have a clear purpose related to TCK execution, reproducibility, or maintainability.

## Review Principle

The primary review question for changes to this repository is:

> Does this make the runner more reusable for current and future Jakarta Data TCK scenarios?

If a change only makes one particular runtime defect pass while making the runner less generic, it should generally not be added.

## License

By contributing to this repository, you agree that your contributions are provided under the project's applicable license.
