# Security Policy

## Overview

Security issues should be handled responsibly so that they can be investigated and addressed before details are publicly disclosed.

This repository is primarily a test runner and development tool. Nevertheless, security issues affecting the runner, its build configuration, dependencies, or test infrastructure should be reported privately.

## Reporting a Security Issue

Please do not disclose an unpatched security vulnerability through a public issue.

Report security concerns privately to the project maintainer.

Include as much of the following information as possible:

* Description of the vulnerability
* Affected component or file
* Steps to reproduce
* Affected version or commit
* Potential impact
* Relevant logs or stack traces
* A proposed mitigation, if known

Do not include passwords, access tokens, private keys, personal information, or other sensitive credentials in a report.

## Dependency Vulnerabilities

If a vulnerability originates from a third-party dependency, include:

* Dependency name
* Dependency version
* Relevant Maven coordinates
* Vulnerability identifier, if known
* Evidence showing how the dependency affects this project

Dependency issues should be evaluated separately from defects in the runner itself.

## Public Disclosure

After a vulnerability has been investigated and an appropriate fix or mitigation is available, disclosure can be coordinated with the project maintainers and affected parties.

Please avoid publishing exploit details before a reasonable opportunity has been provided to address the issue.

## Security Best Practices

When running the TCK runner:

* Do not commit credentials to the repository.
* Do not commit private keys or access tokens.
* Do not place production credentials in test configuration.
* Use isolated test databases and runtime installations.
* Keep Maven and runtime dependencies reasonably current.
* Review dependency updates for compatibility and security implications.

## Scope

This policy covers security vulnerabilities affecting this repository and its build or test infrastructure.

It does not replace the security reporting processes of the Jakarta EE specifications, TCKs, or application server projects used by the runner.
