# Streamline

**Streamline** is a modular Swift networking framework designed for flexibility, speed, and ease of integration.  
It provides built-in support for HTTP requests, WebSockets, JWT authentication, request interceptors, MTLS certificates, and more.

> **Note:** This package is currently under active development.

---

## 🚀 Getting Started

### 1. Configure the Base URL

When starting your application, configure the base URL:

```swift
APIConfiguration.shared.application(
    urlConfigs.baseURL,
    urlConfigs.port,
    "iOS",
    .ptBR
)
```

💡 You can change the base URL later for requests to other domains.

---

### 2. Configure Your API Paths

```swift
enum ApiPath {
    case defaultPath(Paths)
}

enum Paths: String, Sendable {
    case tasks = "Tasks"
}

extension ApiPath: RawValue {
    public var rawValue: String {
        switch self {
        case .defaultPath(let subcase):
            return subcase.rawValue
        }
    }
}
```

---

### 3. Define Request and Response Models

```swift
struct RequestModel: Model {
    let id: Int
    let name: String
}

struct ResponseModel: Model {
    let id: String
    let author: String
    let title: String
    let description: String
}
```

---

### 4. Create a Request

```swift
final class TestRequest: ServiceProtocol {
    
    nonisolated(unsafe) private(set) var factory: HTTPServiceFactoryProtocol
    
    required init(withFactory factory: HTTPServiceFactoryProtocol) {
        self.factory = factory
    }
    
    func testRequest() async throws -> [ResponseModel] {
        return try await factory
            .makeHttpService()
            .fetchAsync(
                [ResponseModel].self,
                parameters: Parameters(
                    method: .GET,
                    path: ApiPath.defaultPath(.tasks)
                )
            ) ?? []
    }
}
```

---

### 5. Using Arrays as Models

```swift
extension Array: @retroactive Model where Element: Model {}
```

---

### 6. SwiftUI Integration

If you are using SwiftUI, you can inject services directly:

```swift
class ViewModel: ObservableObject {
    
    @Factory var service: TestRequest
    
    func test() {
        Task {
            do {
                let result = try await service.testRequest()
                print(result)
            } catch {
                print(error)
            }
        }
    }
}
```

Closures are also supported.

---

## 🔒 Advanced Features

### Request Interceptors

```swift
final class DefaultInterceptor: RequestInterceptor, @unchecked Sendable {
    
    @UserDefaultBackend(key: .tokens(.accessToken))
    var accessToken: String?
    
    func intercept(with urlRequest: inout URLRequest) {
        urlRequest.setValue("Bearer \(String(describing: accessToken ?? ""))", forHTTPHeaderField: "Authorization")
    }
}
```

### Authorization

```swift
final class DefaultAuthorization: Authorization, @unchecked Sendable {
    
    @UserDefaultBackend(key: .tokens(.accessToken))
    private var accessToken: String?
    
    @UserDefaultBackend(key: .tokens(.refreshToken))
    private var refreshToken: String?
    
    @UserDefaultBackend(key: .tokens(.encryptedMTLSPassword))
    private var encryptedMTLSPassword: String?
    
    func refreshToken<T>(
        completion: @escaping (Model.Type, Parameters) async throws -> Model
    ) async throws -> T where T: Model {
        
        let request = RefreshTokenRequestModel(refreshToken: String(describing: refreshToken ?? ""))
        
        let parameters = Parameters(
            method: .POST,
            httpRequest: request,
            path: ApiPath.defaultPath(.refreshToken)
        )
        
        return try await completion(RefreshTokenRequestModel.self, parameters) as! T
    }
    
    func save(withData data: Data) {
        let decoder = JSONDecoder()
        let response = try? decoder.decode(AuthResponseModel.self, from: data)
        refreshToken = response?.refreshToken
        accessToken = response?.accessToken
        encryptedMTLSPassword = response?.encryptedMTLSPassword
    }
}
```

---

### MTLS Certificate Support

To enable MTLS, simply chain `.certificate()`:

```swift
func testRequest() async throws -> [ResponseModel]? {
    return try await factory
        .makeHttpService()
        .certificate()
        .fetchAsync(
            [ResponseModel].self,
            parameters: Parameters(
                method: .GET,
                path: ApiPath.defaultPath(.test)
            )
        )
}
```

---

### Full Example with Authentication, Interceptor, and MTLS

```swift
func testRequest() async throws -> [ResponseModel]? {
    return try await factory
        .makeHttpService()
        .interceptor(DefaultInterceptor())
        .authorization(DefaultAuthorization())
        .certificate()
        .fetchAsync(
            [ResponseModel].self,
            parameters: Parameters(
                method: .GET,
                path: ApiPath.defaultPath(.test)
            )
        )
}
```

---

### Socket

```Swift
let instance = LCSocketManager.shared
instance.disconnect()
        
if let token = accessToken {
    instance.setConfiguration(
        SocketConfiguration(
            token: token,
            url: urlConfigs.baseURL,
            port: urlConfigs.port)
    )?
        .connect()
        .receivedPublisher(eventsName: [
            Notification.Name("name")
        ])
    
}
```

---

## 📦 Installation

Add **Streamline** to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ziminny/Streamline.git", from: "1.0.0")
]
```

Add **Streamline** to your project using Cocoapods:

```rubi
pod 'Streamline', :git => 'https://github.com/ziminny/Streamline.git'
```

---

## 📜 License

This project is licensed under the MIT License.
