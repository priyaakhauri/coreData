//
//  ShowDetails.swift
//  CoreDataSample
//
//  Created by Ankur Akhauri on 13/07/18.
//  Copyright © 2018 DemoApp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShowDetails: UIViewController
{
    var firstName : UILabel? = nil
    var lastName : UILabel? = nil
    var dob : UILabel? = nil
    
    
    @IBOutlet weak var tableViewVar: UITableView!
    var _fetchedResultsController: NSFetchedResultsController<PersonDetails>? = nil
    
    // The proxy variable to serve as a lazy getter to our
    // fetched results controller.
    var fetchedResultsController: NSFetchedResultsController<PersonDetails>
    {
        
        var  appDel = UIApplication.shared.delegate as? AppDelegate
        // If the variable is already initialized we return that instance.
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If not lets build the required elements for the fetched
        // results controller.
        
        // First we need to create a fetch request with the pretended type.
        let fetchRequest: NSFetchRequest<PersonDetails> = PersonDetails.fetchRequest()
        
        // Set the batch size to a suitable number (optional).
        fetchRequest.fetchBatchSize = 20
        
        // Create at least one sort order attribute and type (ascending\descending)
        let sortDescriptor = NSSortDescriptor(key: "dob", ascending: true)
        
        // Set the sort objects to the fetch request.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Optionally, let's create a filter\predicate.
        // The goal of this predicate is to fetch Tasks that are not yet completed.
        let predicate = NSPredicate(format: "firstname != nil")
        
        // Set the created predicate to our fetch request.
        fetchRequest.predicate = predicate
        
        // Create the fetched results controller instance with the defined attributes.
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (appDel?.managedObjectContext)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set the delegate of the fetched results controller to the view controller.
        // with this we will get notified whenever occours changes on the data.
        aFetchedResultsController.delegate = self
        
        // Setting the created instance to the view controller instance.
        _fetchedResultsController = aFetchedResultsController
        
        do {
            // Perform the initial fetch to Core Data.
            // After this step, the fetched results controller
            // will only retrieve more records if necessary.
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    
    
}

extension ShowDetails : NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Whenever a change occours on our data, we refresh the table view.
        self.tableViewVar.reloadData()
    }
}

extension ShowDetails : UITableViewDelegate, UITableViewDataSource
{
    /* public func numberOfSections(in tableView: UITableView) -> Int
     {
     // We will use the proxy variable to our fetched results
     // controller and from that we try to get the sections
     // from it. If not available we will ignore and return none (0).
     return self.fetchedResultsController.sections?.count ?? 0
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // We will use the proxy variable to our fetcehed results
        // controller and from that we try to get from that section
        // index access to the number of objects available.
        // If not possible, we will ignore and return 0 objects.
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "")

        if(cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.backgroundColor = UIColor(red: 0.3686, green: 0.502, blue: 0.7216, alpha: 1.0)
            
            firstName  = UILabel(frame: CGRect(x: 0, y: 0, width:tableView.frame.width, height: 50.0))
            firstName?.tag = 1
            firstName!.textAlignment = NSTextAlignment.center
            firstName!.textColor = UIColor.white
            firstName!.font = UIFont.systemFont(ofSize: 17)

            lastName =  UILabel(frame: CGRect(x: 0, y: 50, width:tableView.frame.width, height: 50.0))
            lastName?.tag = 2
            lastName!.textAlignment = NSTextAlignment.center
            lastName!.textColor = UIColor.white
            lastName!.font = UIFont.systemFont(ofSize: 17)
            
           
            dob =  UILabel(frame: CGRect(x: 0, y: 100, width:tableView.frame.width, height: 50.0))
            dob?.tag = 3
            dob!.textAlignment = NSTextAlignment.center
            dob!.textColor = UIColor.white
            dob!.font = UIFont.systemFont(ofSize: 17)
            
            cell?.contentView.addSubview(firstName!)
            cell?.contentView.addSubview(lastName!)
            cell?.contentView.addSubview(dob!)
            
        }
        //cell.viewWithTag(1)
            let task = self.fetchedResultsController.object(at: indexPath)

        (cell?.viewWithTag(1) as! UILabel).text = task.firstname
        (cell?.viewWithTag(2) as! UILabel).text = task.secondname
        (cell?.viewWithTag(3) as! UILabel).text = task.dob


        
        
        // Finally we return the updated cell
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            self.tableViewVar.remove(at: indexPath.row)
            //tableViewVar.deleteRows(at: [indexPath], with: .fade)
            let appDel = UIApplication.shared.delegate as? AppDelegate
            
            guard let _context = appDel?.managedObjectContext else { return }
            let managedObject = self.fetchedResultsController.object(at: indexPath)
            _context.delete(managedObject)
            
            appDel?.saveContext()
            
        }
    }
}

