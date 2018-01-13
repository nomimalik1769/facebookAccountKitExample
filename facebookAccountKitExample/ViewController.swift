//
//  ViewController.swift
//  facebookAccountKitExample
//
//  Created by NomiMalik on 13/01/2018.
//  Copyright © 2018 Globia Technologies. All rights reserved.
//

import UIKit
import AccountKit

class ViewController: UIViewController,AKFViewControllerDelegate {

     var accountKit = AKFAccountKit(responseType: .accessToken)
     var pendingLoginViewController: AKFViewController? = nil
     var showAccountOnAppear = false
    
    // MARK: - view management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        showAccountOnAppear = accountKit.currentAccessToken != nil
        pendingLoginViewController = accountKit.viewControllerForLoginResume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showAccountOnAppear {
            showAccountOnAppear = false
            presentWithSegueIdentifier("showAccount", animated: animated)
        } else if let viewController = pendingLoginViewController {
            prepareLoginViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: animated, completion: nil)
                pendingLoginViewController = nil
            }
        }
    }
    
    // MARK: - actions
    @IBAction func loginWithPhone(_ sender: AnyObject) {
        if let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: nil) as? AKFViewController {
            
            prepareLoginViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginWithEmail(_ sender: AnyObject) {
        if let viewController = accountKit.viewControllerForEmailLogin(withEmail: nil, state: nil) as? AKFViewController {
            
            
            prepareLoginViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - helpers
    
     func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
    }
    
     func presentWithSegueIdentifier(_ segueIdentifier: String, animated: Bool) {
        if animated {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        } else {
            UIView.performWithoutAnimation {
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        print(accessToken.accountID)
        presentWithSegueIdentifier("showAccount", animated: false)
    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
         print("did complete login with AuthCode \(code) state \(state)")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
           print("\(viewController) did fail with error: \(error)")
    }
    
}

// MARK: - AKFViewControllerDelegate extension


