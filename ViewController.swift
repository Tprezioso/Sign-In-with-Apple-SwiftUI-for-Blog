//
//  ViewController.swift
//  SignInWithAppleBlog
//
//  Created by Thomas Prezioso on 4/16/20.
//  Copyright © 2020 Thomas Prezioso. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInWithAppleButton()
        
    }

    func configureSignInWithAppleButton() {
        
        // Create sign in button
        let signInButton = ASAuthorizationAppleIDButton()
        
        //Add to view
        self.view.addSubview(signInButton)
        
        // Function for the action of our button
        signInButton.addTarget(self, action: #selector(ViewController.signInButtonTapped), for: .touchDown)
        
        // Remove constraints so we can add them programmatically
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Added button constraints
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            signInButton.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func signInButtonTapped() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        print("AppleID Credential Authorization: userId: \(appleIDCredential.user), email: \(String(describing: appleIDCredential.email))")
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
