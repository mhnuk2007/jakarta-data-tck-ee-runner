# Contributing

Thank you for contributing to the Jakarta Data TCK Multi-Provider Runner.

This project is intended to provide a modular, reusable runner for executing Jakarta Data 1.1 TCK tests against Jakarta EE runtimes (including Open Liberty and GlassFish).

## Project Architecture & Principles

Contributions should preserve the following principles:

* **Keep the Runner Generic & Modular**: Use the multi-module Maven reactor (`runners/runner-liberty`, `runners/runner-glassfish`). Server-specific logic stays inside the server's child runner module.
* **Centralize Specifications**: Specification versions, TCK dependencies, Arquillian BOMs, and shared test properties belong in the root `pom.xml` (`<dependencyManagement>` / `<pluginManagement>`).
* **Clean Separation of Concerns**: Keep runtime-specific defects separate from runner infrastructure. Do not add hacks to the generic runner to mask server bugs.
* **Make Test Execution Reproducible**: Use standard Maven module commands (`-pl runners/runner-<server>`) with explicit server home parameters (`-Dliberty.installDirectory=...`, `-Dglassfish.home=...`).

---

## Workflow: Making Changes

### 1. Create a Branch

Update your local `main` branch before starting:

```bash
git checkout main
git pull --ff-only
```

Create your feature or fix branch:

```bash
git checkout -b <branch-name>
```

### 2. Testing Changes

Verify that existing test executions still pass across the modules:

#### Open Liberty:
```bash
mvn test -pl runners/runner-liberty \
  "-Dliberty.installDirectory=/path/to/wlp" \
  "-Dtest=AsyncTests#testAsynchronousInsertExceptionalCompletion"
```

#### GlassFish:
```bash
mvn test -pl runners/runner-glassfish \
  "-Dglassfish.home=/path/to/glassfish8" \
  "-Dtest=AsyncTests"
```

Check for whitespace errors:
```bash
git diff --check
```

Review your diff before staging:
```bash
git diff
```

---

## Adding Support for a New Application Server

When adding a new runner module (e.g. `runners/runner-wildfly`):

1. **Create the module directory**: `runners/runner-<server>/src/test/resources`.
2. **Create the child POM (`runners/runner-<server>/pom.xml`)**:
   - Inherits from parent `jakarta.data:data-tck-ee-runner`.
   - Wires the server-specific Arquillian managed container adapter.
   - Configures the server's data source and port properties.
   - Configures Surefire `<dependenciesToScan>` pointing to `jakarta.data:jakarta.data-tck`.
3. **Add `arquillian.xml`**:
   - Places container configuration in `src/test/resources/arquillian.xml`.
4. **Register the module**:
   - Add `<module>runners/runner-<server></module>` to the root `pom.xml`.
5. **Update Documentation**:
   - Document the new module in `README.md` and `TESTING.md`.

---

## Runtime-Specific Defects vs. Runner Issues

This repository provides an execution harness; it should not contain workarounds for individual runtime implementation bugs.

If a TCK test fails because of an internal server defect (e.g. persistence bootstrap NPE, missing query options support, or classloading issues):

1. Reproduce and verify the failure using this runner.
2. Capture the exact Maven output and server log excerpt.
3. Report the issue to the appropriate server repository (e.g., Open Liberty or GlassFish issue tracker).
4. Keep the runner clean and conformant to the Jakarta Data specification.

---

## Documentation

Always update documentation when modifying configuration or adding new modules:

* `README.md` — project overview, module status, and quickstart commands
* `TESTING.md` — testing matrix, commands, and diagnostic guidelines
* `CONTRIBUTING.md` — contribution workflow and module development guide
* `CODE_OF_CONDUCT.md` — community expectations
* `SECURITY.md` — security reporting

---

## Commit Messages & Pull Requests

Use clear, imperative commit messages:

```text
Add runner-glassfish module
Update TESTING.md for multi-provider reactor
Fix Derby datasource configuration in runner-liberty
```

A pull request should:
* Describe what change was made and why.
* Include actual test commands and execution output.
* Confirm that working-tree checks (`git diff --check`) are clean.

---

## License

By contributing to this repository, you agree that your contributions are provided under the **Eclipse Public License 2.0**.
