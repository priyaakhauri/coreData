//
//  LoginDetails.swift
//  CoreDataSample
//
//  Created by Ankur Akhauri on 13/07/18.
//  Copyright © 2018 DemoApp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginDetails : UIViewController
{
    @IBOutlet weak var firstnameVar: UITextField!
    @IBOutlet weak var lastnameVar: UITextField!
    @IBOutlet weak var dobVar: UITextField!
    var appDel : AppDelegate? = nil
    
    @IBAction func submitBtnFunc(_ sender: UIButton) {
        appDel = UIApplication.shared.delegate as? AppDelegate
        guard let _context = appDel?.managedObjectContext else { return }
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "PersonDetails", into:_context) as! PersonDetails
        
        object.firstname = firstnameVar.text
        object.secondname = lastnameVar.text
        object.dob = dobVar.text
//        object.completed = false
        appDel?.saveContext()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Details")
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
