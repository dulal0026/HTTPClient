# 🌐 HTTPClient

[![Platform](https://img.shields.io/badge/Platform-iOS%2FmacOS-blue.svg)]()
[![Language](https://img.shields.io/badge/Language-Swift-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**HTTPClient** is a lightweight, clean, and efficient networking module designed to simplify making HTTP requests, handling responses, and parsing data seamlessly in your applications.

---

## ✨ Features

* **Simplified Request Handling:** Clean syntax for executing standard HTTP methods (`GET`, `POST`, `PUT`, `DELETE`).
* **Custom Headers & Parameters:** Easily attach query parameters, body data, and custom HTTP headers.
* **Error Handling:** Robust handling of network timeouts, server errors, and parsing failures.
* **Type-Safe Decoding:** Built with modern language features for clean serialization and deserialization.

---

## 📂 Project Structure

```text
HTTPClient/
├── Core/
│   ├── HTTPClient.swift       # Main client manager & request executor
│   ├── Endpoint.swift         # Endpoint configuration & routing
│   └── HTTPMethod.swift       # HTTP methods enumeration (GET, POST, etc.)
├── Models/
│   ├── NetworkError.swift     # Custom network error types
│   └── APIResponse.swift      # Wrapper for server responses
└── Extensions/
    └── Data+Extensions.swift  # Helper extensions for payload parsing
