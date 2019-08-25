//
//  API Service.swift
//  Code Challenge-LDS Church
//
//  Created by Christian R Monson on 8/21/19.
//  Copyright © 2019 christianrmonson. All rights reserved.
//

import Foundation

public class APIService {
    
    static let shared = APIService()
    
    let url = "https://edge.ldscdn.org/mobile/interview/directory"
    
    func sendRequest(onSuccess: @escaping(IndividualsData) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request (GET https://edge.ldscdn.org/mobile/interview/directory)
         */
        
        guard let URL = URL(string: url) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                let result = try! JSONDecoder().decode(IndividualsData.self, from: data!)
                onSuccess(result)

            }
            else {
                // Failure
                onFailure(error!)
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
}

