//
//  ListTableViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    // MARK: - Properties
    var studentLocations: [StudentLocation]?  // var because this data can be refreshed

    // MARK: Outlets

    @IBOutlet weak var ListTableView: UITableView!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // use sharedinstance() because it's a singleton
        // Forum Mentor: "arrayOfStudentLocations is given a value in a background thread. Make sure you dispatch that on the main thread."

        self.studentLocations = arrayOfStudentLocations

        // GUARD: studentLocations is an optional, check if there is data?
        guard studentLocations != nil else {
            print("Error: No data found in studentLocations (MapViewController)")
            return
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        // put the refresh code here
        // If you need to repeat them to update the data in the view controller, viewDidAppear(_:) is more appropriate to do so.
        refreshTableView()

    }

    // Refresh Table Data
    func refreshTableView() {
        if let ListTableView = ListTableView {
            ListTableView.reloadData()
        }
    }


    // MARK: TableView delegate methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        /* Get cell type */
        let cellReuseIdentifier = "ListTableViewCell"
        let studentLocation = studentLocations![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!

        /* Set cell defaults */
        let first = studentLocation.firstName as String
        let last = studentLocation.lastName as String
        let mediaURL = studentLocation.mediaURL as String
        cell?.textLabel!.text = "\(first) \(last)"
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.detailTextLabel!.text = mediaURL
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit

        return cell!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations!.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Open mediaURL
        let app = UIApplication.shared
        let url = studentLocations![indexPath.row].mediaURL
        //app.openURL(URL(string: toOpen)!)

        app.open(URL(string:url)!, options: [:], completionHandler: { (success) in
            if !success {
                self.createAlert(title: "Invalid URL", message: "Could not open URL")
            }
        })
    }

}


