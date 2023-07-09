import UIKit

final class SplashViewController: UIViewController {
    let alertPresenter = AlertPresenter()
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIBlockingProgressHUD.show()
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            UIBlockingProgressHUD.dismiss()
            showAuthViewController()
        }
    }
    
    
    private func showAuthViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else {
            assertionFailure("Что-то пошло не так")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func initLayout(view: UIView){
        view.backgroundColor = UIColor(named: "YP Black")
        let screenImage = UIImage(named: "launchscreenLogo") ?? UIImage(named: "launchscreenLogo")
        let screenImageView = UIImageView(image: screenImage)
        view.addSubview(screenImageView)
        screenImageView.translatesAutoresizingMaskIntoConstraints = false
        screenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        screenImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout(view: view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}



extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        self.fetchOAuthToken(code)
        //        dismiss(animated: true) { [weak self] in
        //            guard let self = self else { return }
        //            UIBlockingProgressHUD.show()
        //            self.fetchOAuthToken(code)
        //        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.dismiss(animated: true, completion: nil)
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile {result in
            switch result {
            case .success:
                
                self.profileImageService.fetchProfileImageURL(username:self.profileService.profile!.username) { imageResult in
                    switch imageResult {
                    case .success:
                        print("Фотография тут \(String(describing: self.profileImageService.avatarURL))")
                    case .failure:
                        print("Не удалось завершить получение фотографии")
//                        self.showAlert()
                    }
                }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
                
            case .failure(let error):
                        print("Ошибка при загрузке профиля: \(error.localizedDescription)")
                        self.showAlert()
            }
        }
    }
    
    func showAlert() {
        UIBlockingProgressHUD.dismiss()
        alertPresenter.show(in: self, model: AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            primaryButtonText: "Ок",
            primaryButtonCompletion: { [weak self] in
                self?.retryFetchingProfile()
            }
        ))
    }
    
    private func retryFetchingProfile() {
        UIBlockingProgressHUD.show()
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
            
        } else {
            UIBlockingProgressHUD.dismiss()
            showAuthViewController()
        }
        
    }
}
