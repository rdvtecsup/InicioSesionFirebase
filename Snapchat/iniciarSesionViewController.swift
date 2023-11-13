//
//  ViewController.swift
//  Snapchat
//
//  Created by Luigui Lupacca on 7/11/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var botonGoogle: UIButton!
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,password: passwordTextField.text!){ (user,error) in print("Intentado Iniciar sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    @IBAction func iniciarSesionGoogleTapped(_ sender: Any) {
        // Configura Google Sign-In
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config

                // Inicia el flujo de inicio de sesión con Google
                GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                    if let error = error {
                        print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                    } else if let user = result?.user,
                              let idToken = user.idToken?.tokenString {
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

                        // Inicia sesión en Firebase con las credenciales de Google
                        Auth.auth().signIn(with: credential) { _, firebaseError in
                            if let firebaseError = firebaseError {
                                print("Error al iniciar sesión en Firebase: \(firebaseError.localizedDescription)")
                            } else {
                                print("Inicio de sesión en Firebase exitoso")
                                // Realiza cualquier acción adicional que necesites después del inicio de sesión.
                            }
                        }
                    }
                }
        
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    


}

