import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    let alertPresenter = AlertPresenter()
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            // Show Auth Screen
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
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
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
     
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.show()
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                // TODO [Sprint 11]
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile {[weak self] result in
            UIBlockingProgressHUD.show()
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                profileImageService.fetchProfileImageURL(username:profileService.profile!.username) { imageResult in
                    switch imageResult {
                    case .success:
                        print("Фотка тут \(self.profileImageService.avatarURL)")
                    case .failure:
                        self.showAlert()
                    }
                }
                self.switchToTabBarController()
                    
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
        alertPresenter.show(in: self, model: AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: { [weak self] in
                self?.retryFetchingProfile()
            }
        ))
    }
    
    private func retryFetchingProfile() {
        UIBlockingProgressHUD.show()
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}
