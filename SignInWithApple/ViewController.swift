//
//  ViewController.swift
//  gateapptmp
//
//  Created by JanFranco on 19.06.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController, ASAuthorizationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSignInAppleButton()
    }

    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        self.view.addSubview(authorizationButton)
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: authorizationButton,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: view, attribute: NSLayoutConstraint.Attribute.centerX,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: authorizationButton,
                           attribute: NSLayoutConstraint.Attribute.centerY,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: view, attribute: NSLayoutConstraint.Attribute.centerY,
                           multiplier: 1, constant: 0).isActive = true
    }
    	
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            checkCredentials(userID: userIdentifier, email: email)
        }
    }
    
    func checkCredentials(userID: String, email: String?) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) {  (credentialState, error) in
             switch credentialState {
                case .authorized:
                    print("valid")
                    if email != nil {
                        // send just id for check
                    } else {
                        // send both id and email for first time reg
                    }
                    break
                case .revoked:
                    print("revoked")
                    // throw alert
                    break
                case .notFound:
                    print("not found")
                    // throw alert
                    break
                default:
                    break
             }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // throw alert
    }
}
