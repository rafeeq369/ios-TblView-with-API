//
//  ViewController.swift
//  jsonNewsApi
//
//  Created by intelmac on 06/01/21.
//

import UIKit
import Foundation;

struct NewsFeed: Codable {
    var status:String? = ""
    var totalResults:Int = 0
    var articles:[Article]?
}

struct Article: Codable {
    var author:String?
    var title:String?
    var discription:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
    var content:String?
}

var finalArray = [Article]()

class ViewController: UIViewController{
    
   @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        tableView.rowHeight = 250
        tableView.estimatedRowHeight = UITableView.automaticDimension
        

        let urlString = "http://newsapi.org/v2/everything?q=bitcoin&from=2020-12-06&sortBy=publishedAt&apiKey=04a965d278584c2b830e1e266e558dca"
        let url = URL(string: urlString)

            guard url != nil else {
                return
            }

        _ = URLSession.shared


        let dataTask = URLSession.shared.dataTask(with: url!) { [self](data, response, error) in
            if error == nil && data != nil {
                do {
                    let newsFeed = try JSONDecoder().decode(NewsFeed.self, from: data!)
                    finalArray = newsFeed.articles!
                    if finalArray.count > 0 {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }

                    }
                    
                }
                catch{
                    print("error in JSON String")
                }
            }
        }
        dataTask.resume()
    }
}


extension ViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TableViewCell
        let value = finalArray[indexPath.row]
        cell.cellAuthor?.text = value.author
        cell.cellTitle?.text = value.title
        cell.cellDiscription?.text = value.discription
        cell.cellContent?.text = value.content
        //................
        
        //...............
        return cell
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
        
  }
}




