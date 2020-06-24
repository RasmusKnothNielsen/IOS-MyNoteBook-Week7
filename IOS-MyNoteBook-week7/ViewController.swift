//
//  ViewController.swift
//  IOS-MyNoteBook-week7
//
//  Created by Rasmus Knoth Nielsen on 24/06/2020.
//  Copyright © 2020 Rasmus Knoth Nielsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // UITableViewDelegate is used when you need to do something to a table
    

    @IBOutlet weak var welcomeTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    let storage = Storage()
    
    // Initialize empty String array
    var textArray = [String]();
    
    // Initializing variable to hold the user input in-memory
    var userInput: String = "";
    
    // Initialize variable to hold a string that has to be displayed on the screen
    var stringDisplayed = "Welcome to MyNoteBook!";
    
    // Initializing boolean to tell if we are in editing mode
    var editingRow: Bool = false;
    var rowThatIsBeingEdited: Int = -1;
    
    // Variables to hold the file
    let file = "MyNoteBook.txt";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Storage.read()
        
        // Set these two to self, so the tableview references the app itself
        tableView.dataSource = self
        tableView.delegate = self
        
        // Display the following text at the start of the app
        welcomeTextView.text = stringDisplayed;
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // Saving the userInput here, so we can reference it later
        userInput = inputTextView.text!
        
        // Check if we are in editing mode
        if editingRow
        {
            //textArray[rowThatIsBeingEdited] = userInput;
            Storage.update(str: userInput, index: rowThatIsBeingEdited)
        }
        else
        {
            // Add the string to the textArray
            //textArray.append(userInput);
            Storage.addItem(str: userInput)
        }
        
        // Saving to file
        //storage.saveStringToFile(str: userInput, fileName: file);
        //Storage.addItem(str: userInput)
        
        // Reading from file
        //storage.readStringFromFile(fileName: file);
        textArray = Storage.read()

        // Reload data to refresh the Table View
        tableView.reloadData();
        
        // Set the editing mode to false, since we are done potentially editing
        editingRow = false;
        
        // Set the inputLabel to be empty, to indicate that we are done editing and ready for a new submission.
        inputTextView.text = "";
    }
    
    
    // Function that returns the number of Strings in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.count();
    }
    
    // Function that displays the cells in the Table View
    // If there is two Strings in the array, the following function will be called twice.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // De-queue one of the cells from the our ReusableCells, so we can reuse cells
        // in our memory. This provides us with the ability to scroll through alot of
        // cells, without filling out the system memory unnecessary.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        // Assign string from textArray to the cell
        cell?.textLabel?.text = Storage.getItem(index: indexPath.row)
        // return the cell, and unwrap it with the !, since it is an Optional
        return cell!
    }
    
    // EDIT
    // Function to handle cell pressed, so we can edit it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Transfer the text from the row to the user input field
        inputTextView.text = Storage.getItem(index: indexPath.row)
        // Set editing to true
        editingRow = true;
        rowThatIsBeingEdited = indexPath.row;
    }
    
    // DELETE
    // Function to handle the deletion of a row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete
      {
        // Remove the String at the given index
        //self.textArray.remove(at: indexPath.row)
        Storage.remove(index: indexPath.row)
        // Delete the given row from the table view
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}

