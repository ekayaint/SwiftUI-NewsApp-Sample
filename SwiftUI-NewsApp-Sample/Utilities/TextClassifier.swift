//
//  TextClassifier.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 28.10.2023.
//

import Foundation
import CoreML

func predictSentiment(text: String) -> String? {
    do {
        let config = MLModelConfiguration()
        let sentimentClassifier = try MyTextClassifier(configuration: config)
        let prediction = try sentimentClassifier.prediction(text: text)
        return prediction.label
    } catch {
        print("Failed to make prediction: \(error.localizedDescription)")
        return nil
    } //: do
        
}
