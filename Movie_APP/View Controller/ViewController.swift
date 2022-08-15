//
//  ViewController.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 10/08/2022.
//

import UIKit

class ViewController: UIViewController {

    
 
    @IBOutlet weak var reviewTextView: UITextView!
    
    var review = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTextView.text = review
        
//        APINetworkServer().fetchData() { moviesArray, error in
//
//                    if let unwarppedData = moviesArray{
//                        print(unwarppedData)
//
//                        print("data view controller")
//                    }
//
//                    if let error = error{
//                        print(error)
//                    }
//
//                }
        
            
    }


}

