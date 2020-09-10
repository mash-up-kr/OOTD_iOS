//
//  LoginViewController.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/06.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import AuthenticationServices

final class LoginViewController: UIViewController, StoryboardBuildable {
    static func newViewController() -> UIViewController {
        let viewController = LoginViewController.instantiate()

        return viewController
    }

    private let appleLoginButton = ASAuthorizationAppleIDButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
}

extension LoginViewController {
    private func setLayout() {
        view.addSubview(appleLoginButton)
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
    }
}

extension LoginViewController {
    @objc private func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let fullName = appleIDCredential.fullName
            let accessToken = String(decoding: appleIDCredential.identityToken ?? Data(), as: UTF8.self)

            // 로그인 api 호출하기
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}
