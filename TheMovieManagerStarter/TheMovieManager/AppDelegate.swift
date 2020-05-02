//
//  AppDelegate.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Esta función solo se llama cuando recibimos el redirect URL por TMDB, cuando el request token fue autorizado por el usuario.
        
        // Necesitamos revisar que el parametro url es el URL correcto. Una forma de hacerlo es verificando sus componentes.
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true) // No entiendo al parámetro resolvingAgainstBaseURL, pero más o menos veo que al poner true, nos aseguramos de que se analice el URL por completo.
        
        // Tranqui. Aún no explico de donde sale el scheme del URL "themoviemanager". Ya lo haré. Qué hay con respecto con el path "authenticate"? Lo defino en algún momento? Pues lo definí en el Endpoint. Y acaso no definí también allí al scheme "themoviemanager"? Sucede que el scheme necesita de un paso más que explicaré en unos pasos más adelante. Anyway, con la siguiente línea podremos saber si el URL tiene la forma correcta
        if components?.scheme == "themoviemanager" && components?.path == "authenticate" {
            // De ser correcto, el incoming URL se trata de la redirección desde TMDB, en otras palabras, el usuario autorizó el request token desde TMDB, por lo que podemos continuar con el proceso del login: crear un session id. Para esto, necesitaremos llamar a la función TMDBClient.session, cuyo completion handler está en LoginViewController, por lo que también tendremos que definir una constante que haga referencia al VC para poder referirnos al completionhandler.
            
            // Entonces, creemos una referencia al Login VC de nuestra app, el cual es el rootViewController
            let loginVC = window?.rootViewController as! LoginViewController
            
            // Luego, llamamos a la función que se encarga de crear una session id y como completion handler damos sessionCompletion(seCompleto:error:) de loginVC
            TMDBClient.session(completionSessionHandler: loginVC.sessionCompletion(seCompleto:error:))
        }
        // Finalmente, devolvemos true para decir que logramos abrir el URL exitosamente.
        return true
    }
}

