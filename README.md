# Full-stack Julia Web Application Example

`TLDR;`

This repository is a an example to be used as a tutorial for building a full-stack web application using the Julia programming language. It covers the entire process of deployment, using a very simple sample application to demonstrate the steps involved.

## Overview

In this tutorial we cover the steps to containerize a Julia application using Docker and GitHub Actions. The workflow is configured to automate the build, test, and upload processes, utilizing GitHub Container Registry (ghcr.io) for hosting the packaged application. The application simply adds a record to a MySQL database.