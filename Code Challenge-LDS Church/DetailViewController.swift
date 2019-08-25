//
//  DetailViewController.swift
//  Code Challenge-LDS Church
//
//  Created by Christian R Monson on 8/21/19.
//  Copyright © 2019 christianrmonson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    
    var individual: IndividualsData.Individual?
    let fileManager = FileManager.default
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
    }
    
    // MARK: - Configuration Methods
    
    func setupViews() {
        if let person = individual {
            nameLabel.text = "\(person.firstName) \(person.lastName)"
            affiliationLabel.text = "Affiliation: \(reformatAllignmentString(allignment: person.affiliation))"
            birthdayLabel.text = "Birthday: \(reformatDate(dateString: person.birthdate))"

            if person.forceSensitive {
                forceSensitiveLabel.text = "The force is strong with this one"
            } else {
                forceSensitiveLabel.text = "This person is not force sensitive"
            }
            
            let url = URL(string: person.profilePicture)
            let withoutExt = url!.deletingPathExtension()
            let name = withoutExt.lastPathComponent
            
            imageView.image = getImage(imageName: "\(name).png")
        }
        
        
    }
    
    func reformatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        dateFormatter.dateStyle = .long
        let result = dateFormatter.string(from: date)
        return result
        
        
    }
    
    func reformatAllignmentString(allignment:String) -> String {
        switch allignment {
        case "RESISTANCE":
            return "Resistance"
        case "FIRST_ORDER":
            return "First Order"
        case "JEDI":
            return "Jedi"
        case "SITH":
            return "Sith"
        default:
            return ""
        }
        
        
    }
    
    // MARK: - FileManager
    
    func getImage(imageName: String)-> UIImage{
        // Here using getDirectoryPath method to get the Directory path
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        } else {
            return UIImage(named: "placeholder")!
        }
        
        
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
