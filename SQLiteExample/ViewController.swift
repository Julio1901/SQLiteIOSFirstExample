//
//  ViewController.swift
//  SQLiteExample
//
//  Created by Julio Cesar  on 18/07/22.
//

import UIKit
import SQLite3



class ViewController: UIViewController {

    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var textViewOne: UITextField!
    
    
    
    
    @IBAction func newAddData(_ sender: Any) {
    
        //Insert query
        let insertStatementString = "INSERT INTO TEMP(TEMPCOLUM1, TEMPCOLUM2) VALUES(?, ?);"
        
        var insertStatementQuery: OpaquePointer?
        
        
        if(sqlite3_prepare_v2(dbQueue, insertStatementString, -1, &insertStatementQuery, nil)) == SQLITE_OK {
            sqlite3_bind_text(insertStatementQuery, 1, textFieldOne.text ?? "", -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatementQuery, 2, textFieldTwo.text ?? "", -1, SQLITE_TRANSIENT)
            
            
            if (sqlite3_step(insertStatementQuery)) == SQLITE_DONE {
                
                
                textFieldOne.text = ""
                textFieldTwo.text = ""
                
                textFieldOne.becomeFirstResponder()
                print("Successfully inserted the record")
            }else {
                print("Error inserted")
            }
            
            sqlite3_finalize(insertStatementQuery)
        }
        
        //Select query
        
        let selectStatmentString = "SELECT TEMPCOLUM1, TEMPCOLUM2 FROM TEMP"
        
        var selectStatementQuery : OpaquePointer?
        
        var sShowData : String!
        sShowData = ""
        
        
        if sqlite3_prepare_v2(dbQueue, selectStatmentString, -1, &selectStatementQuery, nil) == SQLITE_OK {
            
            while sqlite3_step(selectStatementQuery) == SQLITE_ROW{
                sShowData += String(cString: sqlite3_column_text(selectStatementQuery, 0)) + "\t\t" +
                String(cString: sqlite3_column_text(selectStatementQuery, 1)) + "\n"
            }
            
            sqlite3_finalize(selectStatementQuery)
            
        }
    
        textViewOne.text = sShowData ?? ""
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


}

