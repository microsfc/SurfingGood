//
//  LoginViewController.swift
//  MXviewToGo
//
//  Created by liusean on 13/12/2016.
//  Copyright © 2016 liusean. All rights reserved.
//

import UIKit
import SwiftHTTP

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var MXviewServerIP: UITextField!
    @IBOutlet weak var Username: UITextField!
    
    let constant = Constant();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "beach")
        backgroundImage.contentMode = UIViewContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        // Do any additional setup after loading the view.
        Login.layer.cornerRadius = 5;
        
        MXviewServerIP.text = UserDefaults.standard.string(forKey: Constant.UserDefault.IPADDRESS)
        Password.text = UserDefaults.standard.string(forKey: Constant.UserDefault.PASSWORD)
        Username.text = UserDefaults.standard.string(forKey: Constant.UserDefault.USERNAME)
        
        MXviewServerIP.delegate = self;
        Password.delegate = self;
        Username.delegate = self;
        self.navigationController?.setNavigationBarHidden(true, animated: false)
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginToServer(_ sender: AnyObject) {
          NSLog("login to %@", "MXview");
        UserDefaults.standard.set(MXviewServerIP.text, forKey: Constant.UserDefault.IPADDRESS)
        UserDefaults.standard.set(Password.text, forKey: Constant.UserDefault.PASSWORD)
        UserDefaults.standard.set(Username.text, forKey: Constant.UserDefault.USERNAME)
        _ = loginToMXviewServer(serverIP: "localhost", serverPort: 8080)
        let mainTabBarCtrl = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        self.navigationController?.pushViewController(mainTabBarCtrl!, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        MXviewServerIP.endEditing(true);
        Password.endEditing(true);
        Username.endEditing(true);
        
    }
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == MXviewServerIP) {
            Username.becomeFirstResponder();
        }else if( textField == Username) {
            Password.becomeFirstResponder()
        }else if( textField == Password) {
            Password.resignFirstResponder();
        }
        return true;
    }
    
    func loginToMXviewServer(serverIP: String, serverPort: Int) -> Bool {
        
//        do {
//            let opt.start = try HTTP.GET("", parameters: nil, headers: ["authorization": "CWB-6374C03F-A414-4F8C-99C8-5919A68EA0AD"]) {
//                response in
//                if (response.error != nil) {
//            }
//        } catch let error {
//            print("get data error \(error)")
//        }
        
//        let opt = HTTP.GET("https://google.com", parameters: nil, headers: ["authorization": "CWB-6374C03F-A414-4F8C-99C8-5919A68EA0AD"])
//        { response in
//            if response.error != nil {
//                print("error: \(response.error)"
//            }
//            print("reponse: \(response.data)")
//        }
        
        
        let params = ["username":"admin","password":"moxa"]
        struct loginInfo: Codable {
            var username: String
            var password: String
            
            func toDictionary() -> [String:Any] {
                return ["username": self.username, "password": self.password]
            }
        }
        
//        let loginInformation = loginInfo(username: "admin", password: "moxa")
//        let encoder = JSONEncoder()
//        let decoder = JSONDecoder()
//        let jsonBody = try? encoder.encode(loginInformation)
//
//        let dJsonBody = try? decoder.decode(loginInfo.self, from: jsonBody!)
//
//        do {
//            let opt = try HTTP.POST("https://10.0.1.13:8080/login", parameters: params)
//            //the auth closures will continually be called until a successful auth or rejection
//            var attempted = false
//            opt.auth = { challenge in
//                if !attempted {
//                    attempted = true
//                    return URLCredential(trust: challenge.protectionSpace.serverTrust!)
//                }
//                return nil
//            }
//            opt.start { response in
//                //do stuff
//                if let err = response.error {
//                    print("error:\(err.localizedDescription)")
//                }
//
//                print("post finished:\(response.description)")
//
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//            return false;
//        }
        
        
//        do {
//            let opt = try HTTP.POST("https://10.0.1.13:8080/login", parameters: params)
//            opt.start {
//                response in if let err = response.error {
//                    print("error: \(err.localizedDescription)")
//                }
//                print("opt finished: \(response.description)")
//            }
//
//        }catch let error {
//            print("got an error creating the request\(error)")
//            return false;
//        }
//
        return true;
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }

    
    /*
    // MARK
     : - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
