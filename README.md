# 🌐 HTTPClient

### A Lightweight HTTP Networking Layer for Swift and SwiftUI

A lightweight, reusable HTTP networking layer built with **Swift, Foundation, URLSession, and Swift Concurrency**. This project demonstrates how to build a generic API client, execute asynchronous HTTP requests, decode JSON responses into strongly typed Swift models, and display remote product data in a SwiftUI application.

The project uses [Fake Store API](https://fakestoreapi.com/) to fetch product information and demonstrates a clean separation between networking, data models, observable state, and UI components.

[![Swift](https://img.shields.io/badge/Swift-Native-orange?logo=swift)](https://swift.org/)
[![Framework](https://img.shields.io/badge/Framework-SwiftUI-blue)](https://developer.apple.com/xcode/swiftui/)
[![Networking](https://img.shields.io/badge/Networking-URLSession-green)](https://developer.apple.com/documentation/foundation/urlsession)
[![Concurrency](https://img.shields.io/badge/Concurrency-async%2Fawait-purple)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Technologies](#-technologies)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [How It Works](#-how-it-works)
- [Using HTTPClient](#-using-httpclient)
- [Supported HTTP Methods](#-supported-http-methods)
- [Error Handling](#-error-handling)
- [Product Model](#-product-model)
- [ProductStore](#-productstore)
- [SwiftUI Integration](#-swiftui-integration)
- [API Reference](#-api-reference)
- [Current Limitations](#-current-limitations)
- [Future Improvements](#-future-improvements)
- [Contributing](#-contributing)
- [Author](#-author)
- [License](#-license)

## 🎯 Overview

Networking is an essential part of modern iOS development. Applications frequently communicate with REST APIs to retrieve data, submit requests, and process server responses.

HTTPClient demonstrates a reusable approach to API communication using Apple's native networking APIs.

Instead of coupling network requests directly to SwiftUI views, the project introduces a generic `HTTPClient` that accepts a `Resource<T>` and returns a decoded model of type `T`.

This approach helps demonstrate:

- Generic programming with Swift.
- Asynchronous networking using `async/await`.
- JSON serialization and deserialization with `Codable`.
- HTTP status-code validation.
- Custom error types using `Error` and `LocalizedError`.
- Observable application state using Swift's Observation framework.
- Separation of networking logic from SwiftUI presentation.

The included product example fetches data from Fake Store API and presents product titles, categories, and prices.

## ✨ Features

### Networking

- Reusable HTTP client built on `URLSession`.
- Asynchronous requests using Swift concurrency.
- Generic response decoding with `Decodable`.
- Support for GET, POST, PUT, and DELETE request methods.
- Configurable default HTTP headers.
- Optional request-body data for POST requests.

### Data Handling

- Type-safe JSON decoding using `JSONDecoder`.
- Generic resource definitions through `Resource<T>`.
- Structured product models conforming to `Codable` and `Identifiable`.
- Custom error types for invalid responses, client errors, and decoding failures.

### SwiftUI Integration

- Observable product state using `@Observable`.
- Asynchronous product loading.
- Reusable SwiftUI product-row component.
- Separation of networking, data models, state management, and presentation.

## 🛠 Technologies

| Technology | Purpose |
|---|---|
| Swift | Primary programming language |
| SwiftUI | Native declarative user interface |
| Foundation | Networking, URLs, HTTP requests, and JSON decoding |
| URLSession | Asynchronous HTTP communication |
| Swift Concurrency | Nonblocking asynchronous request handling |
| Codable / Decodable | Type-safe JSON decoding |
| Observation | Observable product state |
| Fake Store API | Sample product data source |

## 📂 Project Structure

The repository currently contains the following main files and Xcode project:

```text
HTTPClient/
├── HTTPClient.xcodeproj/
├── HTTPClient/
├── HTTPClient.swift
├── Product.swift
├── ProductRowView.swift
├── ProductStore.swift
└── README.md
```

### Key Components

**`HTTPClient.swift`**

Contains the core networking implementation, including:

- `HTTPMethod`: Defines supported HTTP methods and POST body data.
- `Resource<T>`: Describes a URL, HTTP method, and expected response type.
- `ErrorResponse`: Represents a server error containing a message.
- `NetworkError`: Defines custom networking-related errors.
- `HTTPClient`: Executes asynchronous requests and decodes successful responses.

**`Product.swift`**

Defines the `Product` model, which conforms to `Codable` and `Identifiable` and represents product data returned by the API.

**`ProductStore.swift`**

Uses Swift's Observation framework to maintain product state and retrieve products through `HTTPClient`.

**`ProductRowView.swift`**

Provides a reusable SwiftUI view that displays a product's title, category, and formatted price.

## 🚀 Getting Started

### Prerequisites

- A Mac running macOS compatible with your installed Xcode version.
- Xcode with Swift and SwiftUI support.
- An internet connection to access Fake Store API.

The exact minimum iOS deployment target depends on the Xcode project's current configuration.

### 1. Clone the Repository

Open Terminal and run:

```bash
git clone https://github.com/dulal0026/HTTPClient.git
```

Navigate to the project directory:

```bash
cd HTTPClient
```

### 2. Open the Xcode Project

```bash
open HTTPClient.xcodeproj
```

### 3. Configure the Project

In Xcode:

1. Select the `HTTPClient` project.
2. Select the application target.
3. Review the deployment target and signing settings.
4. Select an available iOS Simulator or connected device.

### 4. Build and Run

Press **⌘ + R** to build and run the application.

The application can retrieve product information from:

```text
https://fakestoreapi.com/products/
```

Make sure the selected simulator or device has internet access.

## ⚙️ How It Works

The networking flow follows these steps:

1. `ProductStore` creates a `Resource<[Product]>` describing the API endpoint and expected response.
2. `ProductStore` calls `HTTPClient.fetch(_:)` using `async/await`.
3. `HTTPClient` builds a `URLRequest` and applies the configured HTTP method and default headers.
4. `URLSession` sends the request and returns the response data.
5. The HTTP response is validated using its status code.
6. Successful responses are decoded into the requested Swift type using `JSONDecoder`.
7. The decoded products are assigned to the observable `products` property.
8. SwiftUI views can display the updated product data.

This design keeps HTTP communication separate from the code responsible for presenting products.

## 💻 Using HTTPClient

### 1. Create an HTTP Client

The client uses `URLSession.shared` and JSON content-type headers by default.

```swift
import Foundation

let httpClient = HTTPClient()
```

You can also provide a custom session or default headers:

```swift
let client = HTTPClient(
    session: .shared,
    defaultHeaders: [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
)
```

### 2. Define a Resource

A resource describes the endpoint and the type expected from the response.

For example, to retrieve a list of products:

```swift
let url = URL(
    string: "https://fakestoreapi.com/products/"
)!

let resource = Resource(
    url: url,
    responseType: [Product].self
)
```

The generic response type tells the client to decode the JSON response into an array of `Product` values.

### 3. Execute the Request

Call `fetch(_:)` from an asynchronous context:

```swift
do {
    let products = try await httpClient.fetch(resource)

    for product in products {
        print(product.title)
        print(product.price)
    }
} catch {
    print("Request failed: \(error.localizedDescription)")
}
```

The method returns the decoded model when the request succeeds and throws an error when the request or response processing fails.

### 4. Decode a Different Response Type

Because the client is generic, it can decode any response model that conforms to `Decodable`.

For example:

```swift
struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}
```

Create a corresponding resource:

```swift
let url = URL(
    string: "https://jsonplaceholder.typicode.com/users/1"
)!

let resource = Resource(
    url: url,
    responseType: User.self
)
```

Fetch the user:

```swift
do {
    let user = try await httpClient.fetch(resource)

    print(user.name)
    print(user.email)
} catch {
    print(error.localizedDescription)
}
```

This example illustrates how the generic client can be reused for different API response types. It uses JSONPlaceholder as an additional example endpoint; it is not part of the current application's product-fetching flow.

## 🔄 Supported HTTP Methods

The `HTTPMethod` enum currently defines four methods:

| Method | Purpose | Request body |
|---|---|---|
| `GET` | Retrieve data | Not provided |
| `POST` | Submit data | Supported through `Data` |
| `PUT` | Update or replace data | Not currently provided |
| `DELETE` | Delete a resource | Not currently provided |

### GET Request

```swift
let resource = Resource(
    url: URL(string: "https://fakestoreapi.com/products/")!,
    responseType: [Product].self
)
```

### POST Request

The POST method accepts a `Data` payload.

```swift
let payload = try JSONSerialization.data(
    withJSONObject: [
        "title": "Sample Product",
        "price": 29.99
    ]
)

let resource = Resource(
    url: URL(string: "https://example.com/products")!,
    method: .post(payload),
    responseType: Product.self
)
```

Replace the example URL with a real endpoint that accepts the supplied JSON and returns a response matching the `Product` model.

### PUT and DELETE Requests

The methods are available through the enum:

```swift
let updateMethod = HTTPMethod.put
let deleteMethod = HTTPMethod.delete
```

**Implementation note:** The current `HTTPMethod` implementation only associates body data with `.post(Data)`. PUT request bodies, query parameters, and per-request custom headers are not yet supported by the resource model.

## ⚠️ Error Handling

The client defines custom networking errors to make response failures easier to identify.

### Available Error Types

```swift
enum NetworkError: Error {
    case badRequest(ErrorResponse)
    case invalidResponse
    case decodingFailed(Error)
}
```

The `NetworkError` type also conforms to `LocalizedError`, providing user-readable descriptions.

| Error | Meaning |
|---|---|
| `badRequest(ErrorResponse)` | The server returned a 4xx status and its body could be decoded as an error message. |
| `invalidResponse` | The response was not an HTTP response, or the status code was not handled as a success or 4xx response. |
| `decodingFailed(Error)` | A successful HTTP response could not be decoded into the expected model. |

### Handle Errors in SwiftUI

```swift
do {
    try await productStore.getProducts()
} catch {
    print(error.localizedDescription)
}
```

For a production application, display an appropriate error state in the UI rather than relying only on console output.

**Current behavior:** Network errors thrown by `URLSession` propagate from `fetch(_:)`. HTTP 4xx responses are decoded as `ErrorResponse`, which expects a JSON `message` field. Other HTTP status codes, including 5xx responses, currently produce `invalidResponse`.

## 📦 Product Model

The `Product` model represents the JSON structure returned by Fake Store API.

```swift
struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String

    var formattedPrice: String {
        return String(price)
    }
}
```

### Model Properties

| Property | Type | Description |
|---|---|---|
| `id` | `Int` | Unique product identifier |
| `title` | `String` | Product title |
| `price` | `Double` | Product price |
| `description` | `String` | Product description |
| `category` | `String` | Product category |
| `image` | `String` | Product image URL |

Conforming to `Codable` enables automatic decoding and encoding, while `Identifiable` makes the model convenient to use in SwiftUI collections.

## 📱 ProductStore

`ProductStore` uses the Observation framework to maintain product data and delegates networking to `HTTPClient`.

```swift
import SwiftUI
import Observation

@Observable
class ProductStore {
    private(set) var products: [Product] = []

    let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func getProducts() async throws {
        let url = URL(
            string: "https://fakestoreapi.com/products/"
        )!

        let resource = Resource(
            url: url,
            responseType: [Product].self
        )

        products = try await httpClient.fetch(resource)
    }
}
```

### Responsibilities

- Maintains the product collection.
- Receives an injected `HTTPClient` instance.
- Creates the product API resource.
- Loads products asynchronously.
- Updates observable state after a successful response.

Injecting the client makes the store less dependent on the networking implementation and provides a starting point for testing with alternative client configurations.

## 🎨 SwiftUI Integration

The `ProductRowView` component displays the product title, category, and price.

A basic example of how an observable store can be used from a SwiftUI view is shown below:

```swift
import SwiftUI

struct ProductListView: View {
    @State private var store = ProductStore(
        httpClient: HTTPClient()
    )

    var body: some View {
        List(store.products) { product in
            ProductRowView(product: product)
        }
        .task {
            do {
                try await store.getProducts()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
```

This is an illustrative integration example. Your existing application may use a different root view or store-initialization pattern.

The `.task` modifier provides a convenient way to start asynchronous work associated with a SwiftUI view's lifecycle.

## 📚 API Reference

### `HTTPClient`

| API | Description |
|---|---|
| `init(session:defaultHeaders:)` | Creates a client with a URL session and default headers. |
| `fetch(_:)` | Executes a request and decodes the response into the resource's generic type. |

### `Resource<T>`

| Property | Description |
|---|---|
| `url` | Endpoint URL |
| `method` | HTTP method, defaulting to GET |
| `responseType` | Expected decoded response type |

### `HTTPMethod`

| API | Description |
|---|---|
| `.get` | GET request |
| `.post(Data)` | POST request with a body |
| `.put` | PUT request without a body |
| `.delete` | DELETE request without a body |
| `rawValue` | HTTP method string |
| `body` | Optional request body data |

### `ProductStore`

| API | Description |
|---|---|
| `products` | Read-only product collection |
| `httpClient` | Injected HTTP client |
| `getProducts()` | Asynchronously fetches the product list |

## 🔍 Current Limitations

This project is a focused networking example rather than a fully featured production networking framework.

The current implementation does not include:

- Automatic retry policies or request cancellation APIs.
- Configurable request timeouts at the resource level.
- Query-parameter handling or per-request headers.
- PUT request bodies or DELETE request bodies.
- Dedicated handling for 5xx server errors.
- A comprehensive API error-response parser.
- Built-in authentication or token refresh.
- Unit tests or automated integration tests.
- Pagination, response caching, or request logging.

These are potential areas for future development, not features that are already implemented.

## 🚧 Future Improvements

Possible enhancements include:

- [ ] Support request-specific headers and query parameters.
- [ ] Add request-body support for PUT and other applicable HTTP methods.
- [ ] Introduce a dedicated server-error case for 5xx responses.
- [ ] Improve error decoding for different backend response formats.
- [ ] Add request timeout configuration and cancellation support.
- [ ] Add unit tests using a custom `URLSession` configuration.
- [ ] Introduce protocol-based dependency injection for easier mocking.
- [ ] Add loading, empty, and error states to the SwiftUI interface.
- [ ] Add pagination and reusable endpoint configuration.
- [ ] Explore authentication and token-refresh support.

## 🤝 Contributing

Suggestions, bug reports, and improvements are welcome.

To contribute:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Build the project and verify your changes.
5. Submit a pull request with a clear description.

For larger changes, consider opening an issue first to discuss the proposed implementation.

## 👨‍💻 Author

**Dulal Hossain**  
Senior / Lead iOS Developer

Experienced in native iOS development with Swift, SwiftUI, Objective-C, UIKit, API integration, and mobile application architecture.

- **GitHub:** [@dulal0026](https://github.com/dulal0026)
- **Repository:** [HTTPClient](https://github.com/dulal0026/HTTPClient)
- **GitHub Profile README:** [View profile](https://github.com/dulal0026)

## 📄 License

No license file was confirmed during this review. Before publishing this project for reuse by others, consider adding an appropriate open-source license, such as the MIT License, if that matches your intentions.

---

*Built with Swift and Apple's native frameworks by Dulal Hossain.*
