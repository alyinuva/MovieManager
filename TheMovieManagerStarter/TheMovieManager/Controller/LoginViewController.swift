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
        // Si hacemos click dentro del login via web, entonces llamaremos a la misma función que llamamos cuando hicimos log in mediante correo, ya que en ambos casos necesitamos pedir un Token. La diferencia está en el handler: en vez de ahora llamar la función TMDB.login enviando un usuario y password, abriremos el web browser (revisa completionHandlerOfGetRequestTokenByBrowser)
        TMDBClient.getRequestToken(completionOfgetAuthToken: self.completionHandlerOfGetRequestTokenByBrowser(seCompleto:error:))
        }
    
    func completionHandlerOfGetRequestTokenByBrowser(seCompleto: Bool, error: Error?) {
        // El request token se llama tanto sea entrado por correo o por la web. Si es por la web, lo que procede es a abrir el URL de web authentication para que TMDB sea quien se encarge de la autenticación.
        if seCompleto {
            DispatchQueue.main.async {
                // Usando open abriremos el web browser con la página de TMDB para que se haga la autentificación.
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
                // Si esta autentificación sale exitosa, la página debería devolvernos a la app. Para seguir, revisa  func application(_ app: UIApplication, open url: ... En AppDelegate.swift.
            }
        }
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
