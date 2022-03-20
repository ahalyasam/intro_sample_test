//
//  ViewController.swift
//  Test_WebView
//
//  Created by Ahalya Samanth on 20/03/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
    @IBOutlet weak var webVw: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = Bundle.main.url(forResource: "webForm", withExtension: "html") {
            webVw.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            let contentController = webVw.configuration.userContentController
            contentController.add(self, name: "textDataHandler")
        }
    }
    //Closure var to concat the string
    var fullName:(String,String)->String = { $0 + " " + $1}
    var fullNameS = String()
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let userDict = message.body as? [String: Any] {
            // Add Default name as FIRST_NAME and LAST_NAME in case if the text input is empty
            if let firstName = userDict["firstName"] as? String {
                
                if let lastName = userDict["lastName"] as? String {
                    fullNameS = fullName(firstName,lastName)
                } else {
                    fullNameS = fullName(firstName,"LAST_NAME")
                }
                updateUI()

            } else if let lastName = userDict["lastName"] as? String {
                fullNameS = fullName("FIRST_NAME",lastName)
            }
            if let dob = userDict["dob"] as? String {
                calculateAge(dob: dob)
            }
            print(fullNameS)
           
       }
    }
    func calculateAge(dob:String) {
        let index = dob.index(dob.startIndex, offsetBy: 4)

        let year:String = String(dob.prefix(upTo: index))
        //Am hardcoding the current year due to time constraints
        if 2022-Int(year)! >= 0 {
            let age = 2022-Int(year)!
            let js = """
                    var _selector = document.querySelector('input[name=age]');
                   _selector.value = '\(age)'
                """
                   
            let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            let contentController = webVw.configuration.userContentController
            contentController.addUserScript(script)
        }
    }
    func updateUI() {
    let js = """
            var _selector = document.querySelector('input[name=fullName]');
           _selector.value = '\(fullNameS)'
        """
           
    let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    let contentController = webVw.configuration.userContentController
    contentController.addUserScript(script)
    }
}

//extension ViewController: WKScriptMessageHandler {
//
//
//}
