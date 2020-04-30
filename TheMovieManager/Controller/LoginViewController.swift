//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        TMDBClient.getRequestToken(completionOfgetAuthToken: self.completionHandlerOfgetRequestToken(seCompleto:error:))
        //performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    @IBAction func loginViaWebsiteTapped() {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    func completionHandlerOfgetRequestToken(seCompleto: Bool, error: Error?) {
        guard seCompleto else {
            print("error es", error!)
            return
        }
        print("El request token es", TMDBClient.Auth.requestToken)
        
        DispatchQueue.main.async {
            TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionFuncHandler: self.loginCompletion(seCompleto:error:))
        }
    }
    
    func loginCompletion(seCompleto: Bool, error: Error?) {
        guard seCompleto else {
            print ("Hubo un error:", error!)
            return
        }
        print("El token del login es", TMDBClient.Auth.requestToken)
        TMDBClient.session(completionSessionHandler: self.sessionCompletion(seCompleto:error:))
    }
    
    func sessionCompletion(seCompleto: Bool, error: Error?) {
        guard seCompleto else {
            print("No se completo el session request", error!)
            return
        }
        print("Se completo session request. El session ID es", TMDBClient.Auth.sessionId)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
}
