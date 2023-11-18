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
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var botonGoogle: UIButton!
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,password: passwordTextField.text!){ (user,error) in print("Intentado Iniciar sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!,completion: {(user,error) in 
                    print("Intentando crear un usuario")
                    if error != nil{
                        print("Se presento el siguiente error al crear un usuario: \(error)")
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender:nil)
                    }else{
                        print("El usuario fue creado exitosamente.")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender:nil)
                    }
                })
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender:nil)
            }
        }
    }
    @IBAction func iniciarSesionGoogleTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
            } else if let user = result?.user,
                      let idToken = user.idToken?.tokenString {
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { _, firebaseError in
                    if let firebaseError = firebaseError {
                        print("Error al iniciar sesión en Firebase: \(firebaseError.localizedDescription)")
                    } else {
                        print("Inicio de sesión en Firebase exitoso")
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

