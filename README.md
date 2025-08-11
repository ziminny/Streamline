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

### For pending requests you can use

```Swift
extension UserService: APIServiceDelegate {
    
    // timeConsumingBackgroundTasksNo3GAccess
    // timeConsumingBackgroundTasks
    // averageBackgroundTasks
    // lightBackgroundTasks
    // noBackgroundTask
    // Or you can create a custom one
    /*
    public extension URLSessionConfiguration {
    /// Configuration for main tasks (e.g., login, account creation).
   var myConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [:]
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        // No specific timeout set, uses system defaults (usually shorter)
        return configuration
    }
    */
    var configurationSession: URLSessionConfiguration { .timeConsumingBackgroundTasks }
    
    func networkUnavailableAction(withURL url: URL?) {
        // Code here
    }
}
```

---

### Pagination

```Swift
.fetchAsync(
    Pagination<ResponseModel>.self,
    parameters: Parameters(
        method: .GET,
        path: ApiPath.defaultPath(.test),
        param: userId
    )
)
```

---

### Query String and Params

```Swift
.fetchAsync(
    Pagination<ProgramContentResponseModel>.self,
    parameters: Parameters(
        method: .GET,
        path: ApiPath.defaultPath(.test),
        queryString: [.sortBy: "ASC"],
        param: submatterId,
    )
)
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

### Client certificate
- I will show an implementation of the client certificate, for this scenario I assume you send an encrypted certificate from the backend.
- In the simulator there is no way to use the keychain, hence the #IF diffetive

```Swift
class MTLSClientCertificateOperation: Operation, @unchecked Sendable  {
    
    #if RELEASE
    
    @Factory
    private var certServiceService: MTLSCertificateService
    
    @UserDefaultBackend(key: .tokens(.encryptedMTLSPassword))
    private var encryptedMTLSPassword: String?
    
    private(set) var error: Error? = nil
    
    private func downloadCert() async throws   {
        
        let certExpirationDate = try await certServiceService.getExpirationCertDate()
        
        guard let certExpirationDate else {
            print("❌ Error trying to get certificate expiration date")
            throw ClientCertificateError.getCertExpirationDate
        }
        
        guard let encryptedMTLSPassword else {
            print("❌ Error trying to get encrypted password")
            throw ClientCertificateError.getEncryptedMTLSPassword
        }
        
        var keychainConfiguration = MTLSKeychainConfiguration()

        // Get the encrypted password from the server
        let encryption = Encryption(keyBase64: Constants.keyDataEncryptedClientCertificateSecretKey)
        // Secret key previously received from the client
        let password = try encryption.decrypt(encryptedMessage: encryptedMTLSPassword)
        
        guard let keychainLabel = Bundle.main.infoDictionary?["MTLSCertificateName"] as? String else {
            print("❌ Error trying to get keychainLabel from info.plist")
            throw ClientCertificateError.getKeychainLabel
        }
        
        keychainConfiguration.setProperties(keychainLabel: keychainLabel, p12Password: password)
        
        let renew = certExpirationDate.renew()
        let identityExistsInKeychain = keychainConfiguration.identityExistsInKeychain()

        if renew || !identityExistsInKeychain {
            
            let url = try await certServiceService.download()
            
            keychainConfiguration.setProperties(p12CertificateURL: url)
            
            try keychainConfiguration.renewCertificate()
            
            try? FileManager.default.removeItem(atPath: url.path())
            
        }
        
    }
    
    override func main() {
        guard !isCancelled else {
            print("❌ Operation canceled, there was an error in operation MTLSClientCertificateOperation")
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                try await downloadCert()
                semaphore.signal()
            } catch {
                print("❌ Error \(error) no permission to access the keychain or you are in the simulator")
                self.error = error
                // Notifica um erro global para interromper processos dependentes
                //NotificationCenter.default.post(name: .operationClientCertificateErrorOccurred, object: nil)
                
                
                semaphore.signal()
            }
        }
        semaphore.wait()
    }
    
    #endif

// Class that communicates with the backend
struct MTLSCertificateDownloadRequestModel: Model {
    let encryptedMTLSPassword: String
}

fileprivate enum Error: Swift.Error {
    case encryptedMTLSPasswordMissing
}

struct MTLSCertificateService: ServiceProtocol {
    
    nonisolated(unsafe) private(set) var factory: HTTPServiceFactoryProtocol
    
    @UserDefaultBackend(key: .tokens(.encryptedMTLSPassword))
    var encryptedMTLSPassword: String?
    
    init(withFactory factory: HTTPServiceFactoryProtocol) {
        self.factory = factory
    }
    
    func download() async throws -> URL {
        
        guard let encryptedMTLSPassword else {
            throw Error.encryptedMTLSPasswordMissing
        }
        
        let request = MTLSCertificateDownloadRequestModel(encryptedMTLSPassword: encryptedMTLSPassword)
        
        let result = try await factory.makeHttpService()
            .interceptor(DefaultInterceptor())
            .authorization(DefaltAuthorization())
            .downloadP12CertificateIfNeeded(nsParameters: Parameters(method: .POST, httpRequest: request, path: APIPath.default(.downloadUserCertificate)))
        
        return result
        
    }
    
    func getExpirationCertDate() async throws -> MTLSClientCertificateExpirationDateResponseModel? {
        
        let result = try await factory.makeHttpService()
            .interceptor(DefaultInterceptor())
            .authorization(DefaltAuthorization())
            .fetchAsync(
                MTLSClientCertificateExpirationDateResponseModel.self,
                parameters: Parameters(
                    method: .GET,
                    path: APIPath.default(.clientCertificateExpirationDate)
                )
            )
        
        return result
        
    }
    
}
    
}
```

---

### Bonus, custom UserDefaults

```Swift

enum UserDefaultsTokensKeys: String {
    case refreshToken = "refreshToken"
    case accessToken = "accessToken"
    case encryptedMTLSPassword = "encryptedMTLSPassword"
}

enum UserDefaultsAPIKeys {
    case tokens(UserDefaultsTokensKeys)
    case other(AnyEnumClass)
}

extension UserDefaultsAPIKeys {
    
    var rawValue: String {
        switch self {
        case .tokens(let res):
            return res.rawValue
        case .other(let res):
            return res.rawValue
        }
    }
    
}

@propertyWrapper
struct UserDefaultBackend<Value>: Sendable {
    
    let key: UserDefaultsAPIKeys
    nonisolated(unsafe) private let storage: UserDefaults
    
    private var privateQueue = DispatchQueue(label: "com.queuename.UserDefaultBackend", attributes: .concurrent)
    
    init(key: UserDefaultsAPIKeys) {
        self.key = key
        storage = UserDefaults.standard
    }
    
    var wrappedValue: Value? {
        get {
            privateQueue.sync(flags: .barrier) {
                storage.value(forKey: key.rawValue) as? Value
            }
        }
        set {
            privateQueue.sync {
                storage.setValue(newValue, forKey: key.rawValue)
            }
        }
    }
    
}

```

---

## 📜 License

This project is licensed under the MIT License.
