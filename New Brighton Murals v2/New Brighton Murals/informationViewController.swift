//
//  informationViewController.swift
//  UserLocation
//
//  Created by andy on 06/12/2022.
//

import UIKit



class informationViewController: UIViewController {

    @IBOutlet weak var localimage: UIImageView!
    @IBOutlet weak var idlabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var artistlabel: UILabel!
    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var lastModifiedlabel: UILabel!
    @IBOutlet weak var infotext: UITextView!
    

    
    let defaults = UserDefaults.standard
    //all the data that send from main from will be received in here as var
    var title2:String = ""
    var artist2:String = ""
    var id2:String = ""
    var info2:String = ""
    var lastModified2:String = ""
    var filename2:String = ""
    var url2:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //set and display all the information of mural that selected
        title = "Location Detail"
        titlelabel.text = "Title: " + title2
        artistlabel.text = "Artist: " + artist2
        idlabel.text = "ID: " + id2
        lastModifiedlabel.text = "LastModified: " + lastModified2
        let image = String(url2.dropFirst(60))
        infotext.text = info2
        //download image from the internet
        let imgUrl = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm_images/" + image
        localimage.downloaded(from: imgUrl, contentMode: .scaleToFill) //also set image size
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
