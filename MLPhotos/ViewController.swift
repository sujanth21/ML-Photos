//
//  ViewController.swift
//  MLPhotos
//
//  Created by Sujanth on 21/7/17.
//  Copyright © 2017 Sujanth. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "cat2.jpg", ofType: "jpg")
        let imageURL = NSURL.fileURL(withPath: path!)
        
        let modelFile = GoogLeNetPlaces()
        let model = try! VNCoreMLModel(for: modelFile.model)
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
        
        try! handler.perform([ request ])
        
    }
    
    func myResultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation]
            else {
               fatalError("Could not find results in ML Vision request!")
            }
        
        var bestPrediction = ""
        var bestConfidence: VNConfidence = 0
        
        for classification in results {
            if classification.confidence > bestConfidence {
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

