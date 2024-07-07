import SwiftUI
import NerdzInject
import NerdzUtils
import NerdzNetworking
import NerdzEvents
import IQKeyboardManagerSwift
import Nuke

final class RootCoordinator: ObservableObject {

    // MARK: - Internal types -
    
    private enum Constants {
        static let appStoreUrl = "" // TODO: set when published
    }
    
    // MARK: - Injects
    
    @ForceInject private var authRepository: AuthRepositoryType

    // MARK: - Properties

    @Published var currentView: AnyView?

    private var pendingShowSoftUpdate: Bool = false
        
    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    // MARK: - Life cycle -
    
    init(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.launchOptions = launchOptions
        configureContainerScreen()
    }
    
    // MARK: - Methods -
    
    private func configureContainerScreen() {
        configureRepositories()
        
        Task {
            await configureEnvironment()
            await configureInitialState()
        }
    }
    
    @MainActor
    private func configureInitialState() {
        showHome()
    }
    
    private func showHome() {
        let homeViewModel = HomeViewModel()
        currentView = AnyView(HomeView(viewModel: homeViewModel))
    }
    
    private func clearState() {
        currentView = nil
    }
    
    private func configureEnvironment() async {
        configureNuke()
        await configureNetworking()
        await configureKeyboardManager()
    }
    
    @MainActor
    private func configureNetworking() {
        let coder = JSONDecoder()
        coder.keyDecodingStrategy = .convertFromSnakeCase
        coder.dateDecodingStrategy = .secondsSince1970

        let endpoint = Endpoint(baseUrl: Environment.current.apiBaseURL, decoder: coder)
        
        endpoint.handleAppMoveToBackground = true

        endpoint.headers.contentType = .application(.json)
        endpoint.headers.accept = .application(.json)
        endpoint.headers.language = Locale.current.language.languageCode?.identifier
        
        endpoint.observation.register(for: .unauthorized) { [weak self] _, _ in
            self?.forceLogout()
        }
                
        endpoint.headers.authToken = authRepository.authToken.flatMap { .bearer($0) }
        
        Endpoint.default = endpoint
        NerdzInject.shared.registerObject(endpoint)
    }
    
    private func forceLogout() {
        // Implement logout logic
    }
    
    private func configureRepositories() {
        NerdzInject.shared.registerObject(AuthRepository(), for: AuthRepositoryType.self)
    }
    
    @MainActor
    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    private func configureNuke() {
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
    }
}
