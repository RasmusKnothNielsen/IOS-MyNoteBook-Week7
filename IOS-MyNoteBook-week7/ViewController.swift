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
        textArray.append("Hello")
        textArray.append("How are you?")
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
            textArray[rowThatIsBeingEdited] = userInput;
        }
        else
        {
            // Add the string to the textArray
            textArray.append(userInput);
        }
        
        // Saving to file
        saveStringToFile(str: userInput, fileName: file);
        
        // Reading from file
        readStringFromFile(fileName: file);

        // Reload data to refresh the Table View
        tableView.reloadData();
        
        // Set the editing mode to false, since we are done potentially editing
        editingRow = false;
        
        // Set the inputLabel to be empty, to indicate that we are done editing and ready for a new submission.
        inputTextView.text = "";
    }
    
    
    // Function that returns the number of Strings in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count;
    }
    
    // Function that displays the cells in the Table View
    // If there is two Strings in the array, the following function will be called twice.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // De-queue one of the cells from the our ReusableCells, so we can reuse cells
        // in our memory. This provides us with the ability to scroll through alot of
        // cells, without filling out the system memory unnecessary.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        // Assign string from textArray to the cell
        cell?.textLabel?.text = textArray[indexPath.row]
        // return the cell, and unwrap it with the !, since it is an Optional
        return cell!
    }
    
    // EDIT
    // Function to handle cell pressed, so we can edit it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Transfer the text from the row to the user input field
        inputTextView.text = textArray[indexPath.row];
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
        self.textArray.remove(at: indexPath.row)
        // Delete the given row from the table view
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }

    // SAVING
    func saveStringToFile(str:String, fileName:String) {
        // Read the filepath
        let filePath = getDocumentDir().appendingPathComponent(fileName)
        do {
            // Try to write the string to the provided file
            try str.write(to: filePath, atomically: true, encoding: .utf8)
            print("OK writing string: \(str)")
        } catch {
            print("error writing string: \(str)")
        }
    }
    
    // READING
    // Where we return a string
    func readStringFromFile(fileName:String) -> String {
        // Read the filepath
        let filePath = getDocumentDir().appendingPathComponent(fileName);
        do {
            // Get the content from the file and save it as string
            let string = try String(contentsOf: filePath, encoding: .utf8);
            print("Read the following from file: \(string)")
            // Return the string
            return string;
        }
        catch {
            print("Error while reading file \(fileName)")
        }
        // If there was an error in reading the file, return "empty"
        return "empty"
    }
    
    // Function used to get the correct location on the operating system
    func getDocumentDir() -> URL {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0]
    }
}

