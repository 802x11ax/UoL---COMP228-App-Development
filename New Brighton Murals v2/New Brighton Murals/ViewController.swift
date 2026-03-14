//
//  ViewController.swift
//  UserLocation
//
//  Created by Andy on 06/11/2022.

import UIKit
import MapKit


class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    // MARK: Map & Location related stuff
    
    @IBOutlet weak var myMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    //---------------------------------------
    var locationinfo:newbrighton? = nil //array to store murals data

    var addlikearray = [0] //the array to store user's favourite place
    var latarray: [String] = [] // the array to store lat data
    var lonarray: [String] = [] // the array to store lon data
    var mapdetail:[String] = [] // the array to store title data
    
    
    var indexnum = 0 //index count
    var count = 0 //for while loop
    let defaults = UserDefaults.standard //create user default
    var indexnum1 = 0
    
    var firstRun = true
    var startTrackingTheUser = false
    //---------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0] //this method returns an array of locations
        //generally we always want the first one (usually there's only 1 anyway)
        
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        //get the users location (latitude & longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            //a span defines how large an area is depicted on the map.
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            //a region defines a centre and a size of area covered.
            let region = MKCoordinateRegion(center: location, span: span)
            
            //make the map show that region we just defined.
            self.myMap.setRegion(region, animated: true)
            
            //the following code is to prevent a bug which affects the zooming of the map to the user's location.
            //We have to leave a little time after our initial setting of the map's location and span,
            //before we can start centering on the user's location, otherwise the map never zooms in because the
            //intial zoom level and span are applied to the setCenter( ) method call, rather than our "requested" ones,
            //once they have taken effect on the map.
            
            //we setup a timer to set our boolean to true in 5 seconds.
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
        }
    }
    
    //this method sets the startTrackingTheUser boolean class property to true. Once it's true, subsequent calls
    //to didUpdateLocations will cause the map to center on the user's location.
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }
    
    
    
    //MARK: Table related stuff
    
    
    @IBOutlet weak var theTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  locationinfo?.newbrighton_murals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! listTableViewCell
        let iconurl = locationinfo?.newbrighton_murals[indexPath.row].thumbnail //get the icon url
        let enabledcheck = locationinfo?.newbrighton_murals[indexPath.row].enabled //check if enabled is = 1.
        
        //load data from user default
        addlikearray = defaults.array(forKey: "likeplace")  as? [Int] ?? [Int]()
        
        cell.myfavorite.tag = indexPath.row
        cell.myfavorite.addTarget(self, action: #selector(addtobutton), for: .touchUpInside) //create action for favourite star button
        let indexnum1:Int = indexPath.row //get curret indexpath number
        
        
        
        if enabledcheck == "1" { //if mural is valid and enabled
            cell.tabletitle.text = locationinfo?.newbrighton_murals[indexPath.row].title ?? "no title"
            cell.tableartist.text = locationinfo?.newbrighton_murals[indexPath.row].artist ?? "no artist"
            cell.iconimage.downloaded(from: iconurl!, contentMode: .scaleToFill)
         //set and display title, artist name and icon image for this data on table
      
            
            //this is the function to load favourite or not favourite place from the array
            if (addlikearray[indexnum1] == 1 ){ //match and check the array data
                cell.myfavorite.setImage(UIImage(named: "favouritestar.png"), for: .normal) //this is a favourite place
            }
            else if (addlikearray[indexnum1] == 0 ){//match and check the array data
                cell.myfavorite.setImage(UIImage(named: "favourite.png"), for: .normal)//this is not a favourite place
            }

            
            
        }
        if enabledcheck == "0" { //if mural is not valid and disabled
            cell.tabletitle.text = "Removed Mural" //dispaly no data info
            cell.tableartist.text = ""
            cell.iconimage.image = UIImage(named: "noimage")
            //cell.iconimage.image = nil
            //cell.favouriteplace.image = nil
            cell.myfavorite.setImage(nil, for: .normal)
            //cell.myfavorite.isHidden = true
        }
        return cell
    }
    
    @objc func addtobutton(sender:UIButton) { //addition function if user clicks the favourite star button
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        addlikearray = defaults.array(forKey: "likeplace")  as? [Int] ?? [Int]() //load array from user default
        let indexnumber = indexpath1[1] //get the current index path num
        
            if addlikearray[indexnumber] == 1 { //remove from favourite
                addlikearray[indexnumber] = 0
            }
            else if addlikearray[indexnumber] == 0 {//add to favourite
                addlikearray[indexnumber] = 1
            }
        
        print(addlikearray) //for testing
        
        defaults.set(addlikearray, forKey: "likeplace") //save data to user default
        updateTheTable() //reload table
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 //set table cell to a fixed size
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is informationViewController {
            let vc = segue.destination as? informationViewController
           //pass all the data to informationViewController
            vc?.title2 = locationinfo?.newbrighton_murals[indexnum].title ?? "no title"
            vc?.artist2 = locationinfo?.newbrighton_murals[indexnum].artist ?? "no artist"
            vc?.info2 = locationinfo?.newbrighton_murals[indexnum].info ?? "no info"
            vc?.id2 = locationinfo?.newbrighton_murals[indexnum].id ?? "no id"
            vc?.lastModified2 = locationinfo?.newbrighton_murals[indexnum].lastModified ?? "no lastModified"
            vc?.url2 = locationinfo?.newbrighton_murals[indexnum].thumbnail ?? "no image"

        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexnum = indexPath.row
        let enabledcheck = locationinfo?.newbrighton_murals[indexPath.row].enabled
        if enabledcheck == "1"{ //only open informationViewController if the mural is valid
            performSegue(withIdentifier: "todetail", sender: nil)
        }
    }
    

    
    // MARK: View related Stuff
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make this view controller a delegate of the Location Managaer, so that it
        //is able to call functions provided in this view controller.
        locationManager.delegate = self as CLLocationManagerDelegate
        
        //set the level of accuracy for the user's location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Ask the location manager to request authorisation from the user. Note that this
        //only happens once if the user selects the "when in use" option. If the user
        //denies access, then your app will not be provided with details of the user's
        //location.
        locationManager.requestWhenInUseAuthorization()
        
        //Once the user's location is being provided then ask for udpates when the user
        //moves around.
        locationManager.startUpdatingLocation()
        
        //configure the map to show the user's location (with a blue dot).
        myMap.showsUserLocation = true
        
        //array to store map detail info
        var latarray1: [String] = []
        var lonarray1: [String] = []
        var mapdetail1:[String] = []
        
        //get data from api
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals&lastModified=2022-09-15") {
            let session = URLSession.shared
               session.dataTask(with: url) { (data, response, err) in
                   guard let jsonData = data else {
                       return
                   }
                   do {
                       let decoder = JSONDecoder() //decode api
                       let detailList = try decoder.decode(newbrighton.self, from: jsonData)
                       self.locationinfo = detailList //save the api data
                       
                       var i = 0 //save the map detail info to array
                       while i < (self.locationinfo?.newbrighton_murals.count ?? 0) {
                           lonarray1.append(self.locationinfo?.newbrighton_murals[i].lon ?? "0")
                           latarray1.append(self.locationinfo?.newbrighton_murals[i].lat ?? "0")
                           mapdetail1.append(self.locationinfo?.newbrighton_murals[i].title ?? "no title")
                           i += 1
                       }
                       self.mapdetail = mapdetail1
                       self.latarray = latarray1
                       self.lonarray = lonarray1
       
                       
                       DispatchQueue.main.async {
                       self.updateTheTable()
                       }
                   } catch let jsonErr {
                       print("Error decoding JSON", jsonErr)
                   }
               }.resume()
            print("Yeah! I got the data")
            
           }
        
     
        let favouritelistvalues = [Int](repeating: 0, count: 100) //create array with 0
        if defaults.object(forKey: "likeplace") == nil { //if user default is nil then save it
            defaults.set(favouritelistvalues, forKey: "likeplace")
        }
        while locationinfo == nil{}// only continue when app to get corrrect data. if not, wait till data is received
        
        let annotation = MKPointAnnotation() //set the center map location when app opened
        annotation.coordinate = CLLocationCoordinate2D(latitude: 53.43810754767153 , longitude: -3.0416380502113984)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500) //set map zooming size
        myMap.setRegion(region, animated: true)
        addpin(locationinfo!.newbrighton_murals) //function to display pin on map
     
    }
    
    func addpin(_ locationinfo2: [details]){
        
        for num in locationinfo2 { //loop display all data as pin on map
            if num.enabled == "1" { //if mural is valid and enabled
                let annotation = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: Double(num.lat!)!, longitude: Double(num.lon!)!)
                annotation.coordinate = location
                annotation.title = num.title //set title
                self.myMap.addAnnotation(annotation) //add pin
            }
        }
    }

    
    
    
    

    
    func updateTheTable() { //reload table
     theTable.reloadData()
    }
    
}




extension UIImageView { //download image from network function
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image //set image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return } //the url
        downloaded(from: url, contentMode: mode)
    }
}
