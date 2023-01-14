//
//  ViewController.swift
//  SentimentApp
//
//  Created by Trung Nguyen on 12/1/2023.
//

import UIKit



class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var textLabel: UITextField!
    
    @IBOutlet weak var sentimentLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    func generateSentiment() {
        let params = ["text": textLabel.text!]
        
        guard let url = URL(string: "http://127.0.0.1:8000/sentiment_analysis/") else{
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/Json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            if let error = error {
                print(error)
            }else {
                let jsonRes = try? JSONDecoder().decode(Response.self, from: data!)
                print(jsonRes?.sentiment)
                DispatchQueue.main.async {
                    self.sentimentLabel.text = jsonRes?.sentiment
                    self.scoreLabel.text = jsonRes?.probability.description
                }
                
            }
        }.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }

    @IBAction func buttonAction(_ sender: UIButton) {
       let data = generateSentiment()
    
    }
    
}

struct Response: Codable{
    let sentiment: String
    let probability: Float
}

