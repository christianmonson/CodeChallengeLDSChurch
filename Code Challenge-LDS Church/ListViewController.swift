//
//  ViewController.swift
//  Code Challenge-LDS Church
//
//  Created by Christian R Monson on 8/21/19.
//  Copyright © 2019 christianrmonson. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    
    var individualsData: [IndividualsData.Individual] = []
    let userDefaultsKey = "IndividualsData"
    let fileManager = FileManager.default

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        super.viewDidLoad()
        //create a directory to save images
        createDirectory()
        if UserDefaults.standard.object(forKey: userDefaultsKey) != nil {
            requestDataFromUserDefaults()
            print("requested from UserDefaults")
        } else {
            requestDataFromAPI()
            print("requested from API")
        }
    }

    // MARK: - RequestData
    
    func requestDataFromAPI() {
        let apiService = APIService.shared
        apiService.sendRequest(onSuccess: {json in
            DispatchQueue.main.async {
                self.individualsData = json.individuals
                self.saveData(data: self.individualsData)
                self.tableView.reloadData()
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
        

    }

    func requestDataFromUserDefaults(){
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([IndividualsData.Individual].self, from: data)
                individualsData = decodedData
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
        
        
    }
    
    // MARK: - FileManager Methods
    
    func saveData(data:[IndividualsData.Individual]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(individualsData)
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: userDefaultsKey)
        } catch {
            print(error)
        }
        
        
    }
    
    func createDirectory(){
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("images")
        if !fileManager.fileExists(atPath: paths){
            do {
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory")
            }
        } else {
            print("Directory already created")
        }
        
        
    }
    
    func saveImageToDocumentDirectory(image: UIImage, imageName: String) {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let imageData = image.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    
    
    }
    
    
    func getImage(imageName: String)-> UIImage{
        // Here using getDirectoryPath method to get the Directory path
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        } else {
            print("No Image available")
            return UIImage(named: "placeholder")!
        }
        
        
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
        
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.individualsData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? individualsTableViewCell else {
            return UITableViewCell()
        }
        let individual = individualsData[indexPath.row]
        cell.nameLabel.text = "\(individual.firstName) \(individual.lastName)"
        
        
        
        switch individual.affiliation {
        case "RESISTANCE":
            cell.affiliationImageView.image = UIImage(named: "rebel-alliance")
            cell.affiliationLabel.text = "Resistance"
        case "FIRST_ORDER":
            cell.affiliationImageView.image = UIImage(named: "first-order")
            cell.affiliationLabel.text = "First Order"
        case "JEDI":
            cell.affiliationImageView.image = UIImage(named: "jedi")
            cell.affiliationLabel.text = "Jedi"
        case "SITH":
            cell.affiliationImageView.image = UIImage(named: "sith")
            cell.affiliationLabel.text = "Sith"
        default:
            cell.affiliationImageView.image = nil
            cell.affiliationLabel.text = ""
        }
        
        
        //convert URL into resonable image name
        let url = URL(string: individual.profilePicture)
        let withoutExt = url!.deletingPathExtension()
        let name = withoutExt.lastPathComponent
        cell.individualImageView.image = getImage(imageName: "\(name).png")
        
        //if the cell image is set to placeholder, then we dont have it saved and need to pull a new one
        if cell.individualImageView.image == UIImage(named: "placeholder") {
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: individual.profilePicture) {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data, let image: UIImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            print("downloaded new image")
                            cell.individualImageView.image = image
                            self.saveImageToDocumentDirectory(image: image, imageName: "\(name).png")
                            
                        }
                    }
                }
            }
        }
        return cell

        
    }
    
    // MARK: - TableViewDelegate
    
    //deselect the cell so that if we return to the tableView, it isn't highlighted anymore
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
        if let vc = segue.destination as? DetailViewController {
            //pass the individual to the destination
            vc.individual = self.individualsData[selectedRow]
            
        }
    }
    
    
}








    

