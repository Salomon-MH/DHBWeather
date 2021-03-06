//
//  ViewController.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 13.10.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import UIKit


class ViewController: UIViewController , WeatherDataConsumer {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherAreaLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var chooseCityButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var weatherDataProvider : WeatherDataProvider?
    
    var savedlocation: String = ""
    var updateintervall: Int = 30
    var updatetimer: Timer? = nil
    var networkerrorshown: Bool = false
    
    required init?( coder dc : NSCoder ) {
        super.init( coder: dc )
        weatherDataProvider = WeatherViewModel()
        weatherDataProvider?.weatherDataConsumer = self
    }

    @objc func lightHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    /**func initAlertBlur() {
        // Create blur effect
        let blurEffect = UIBlurEffect(style: .light)
        // Add effect to view
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
    }
    func endAlertBlur() {
        //Remove the blur
        visualEffectView.removeFromSuperview() //Remove blur effect from background
    }**/
    
    @IBAction func chooseCityButtonClick(_ sender: Any) {
        NSLog("INFO: City selection button clicked.")
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let alert = UIAlertController(title: "Stadtnamen eingeben...", message: "Bitte gib den Namen der Stadt ein, dessen Wetter du wissen möchtest. ☀️", preferredStyle: .alert)
        var locationTextField: UITextField!
        alert.addTextField {
            textField in
            locationTextField = textField
            textField.placeholder = "Stadtname"
            textField.addTarget(self, action: #selector(self.lightHapticFeedback), for: UIControlEvents.editingChanged)
        }
        alert.addAction(UIAlertAction(title: "Bestätigen", style: .default, handler: {_ in
            if let text = locationTextField.text {
                if text != "" {
                    self.loadWeatherToUI(city: text)
                    self.savedlocation = text
                    UserDefaults.standard.set(text, forKey: "lastlocation")
                    NSLog("INFO: City \(text) entered and saved.")
                } else {
                    NSLog("WARNING: Empty String entered as city, using previous city \(self.savedlocation) again.")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        NSLog("INFO: City selection popup shown.")
    }
    
    @IBAction func updateButtonClick(_ sender: Any) {
        NSLog("INFO: Update time button clicked.")
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let alert = UIAlertController(title: "Updateintervall eingeben...", message: "Wie oft soll sich das Wetter automatisch für dich aktualisieren? ☺️ (In Sekunden)", preferredStyle: .alert)
        var updateTextField: UITextField!
        alert.addTextField {
            textField in
            updateTextField = textField
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "Updateintervall"
            textField.addTarget(self, action: #selector(self.lightHapticFeedback), for: UIControlEvents.editingChanged)
        }
        alert.addAction(UIAlertAction(title: "Bestätigen", style: .default, handler: {_ in
            if let text = updateTextField.text {
                if text != "" {
                    self.updateintervall = Int(text) ?? 30
                    UserDefaults.standard.set(text, forKey: "updateintervall")
                    NSLog("INFO: Update time \(text) entered and saved.")
                    self.updatetimer?.invalidate()
                    self.updatetimer = nil
                    self.updatetimer = Timer.scheduledTimer(timeInterval: Double(self.updateintervall), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    NSLog("INFO: Update timer set.")
                } else {
                    NSLog("WARNING: Empty String entered as update time, using previous update time \(self.updateintervall) again.")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        NSLog("INFO: Update time popup shown.")
    }
    
    @IBAction func infoButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Informationen 📚", message: "Programmiert von Daniel Salomon, 29.10.2017\n\nErstellt für das Wahlmodul \n'Mobile Appentwicklung'\nan der DHBW Mannheim,\nKurs TINF16AIBC\n\nVerwendete Libraries:\n- Alamofire\n- AlamofireNetworkActivityIndicator\n- SwiftyJSON\n\nWettericons von Laura Reen, lizensiert unter CC BY-NC 3.0\n\nAppicon von Steven Kuiper, um den Appnamen erweitert", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Jetzt bin ich schlauer! 🤓", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherAreaLabel.text = "Verbinde..."
        self.weatherConditionLabel.text = "..."
        self.temperatureLabel.text = "...°C"
        
        NSLog("INFO: App started.")
        
        savedlocation = UserDefaults.standard.string(forKey: "lastlocation") ?? "Mülheim an der Ruhr"
        updateintervall = Int(UserDefaults.standard.string(forKey: "updateintervall") ?? "30") ?? 30
        NSLog("INFO: Saved values loaded, City \(savedlocation) and update time \(updateintervall).")

        loadWeatherToUI(city: savedlocation)
        
        
        updatetimer = Timer.scheduledTimer(timeInterval: Double(updateintervall), target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        NSLog("INFO: Timer set with saved values.")
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        networkerrorshown = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("WARNING: Low memory!")
    }
    

    func loadWeatherToUI(city: String) {
        NSLog("INFO: Loading weather data...")
        self.weatherDataProvider?.fetchWeatherDataForCity( city : city )
    }
    
    @objc func update() {
        NSLog("INFO: Update called by timer!")
        loadWeatherToUI(city: savedlocation)
    }
    
    func showNetworkUnreachable() {
        let alert = UIAlertController(title: "Keine Verbindung! 😭", message: "Es ist leider keine Internetverbindung vorhanden! DHBWeather benötigt eine aktive Internetverbindung um das Wetter anzuzeigen.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ups, meine Schuld...", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func receiveWeatherData( model : WeatherData ) {
        self.weatherAreaLabel.text = model.cityname
        self.weatherConditionLabel.text = model.weather
        self.temperatureLabel.text = model.temperature
        self.weatherImageView.image = UIImage(named: model.weatherimage)
        NSLog("INFO: Weather data updated!")
        if model.weatherimage.characters.last == "d" {
            self.view.backgroundColor = UIColor.init(red: 93/255.0, green: 192/255.0, blue: 255/255.0, alpha: 1.0)
            NSLog("INFO: Changing background to day!")
        } else if model.weatherimage == "meatballs" {
            self.view.backgroundColor = UIColor.init(red: 255/255.0, green: 70/255.0, blue: 227/255.0, alpha: 1.0)
            NSLog("INFO: Changing background to meatball-pink!")
        } else {
            self.view.backgroundColor = UIColor.init(red: 93/1020.0, green: 192/1020.0, blue: 255/1020.0, alpha: 1.0)
            NSLog("INFO: Changing background to night!")
        }
        if model.temperature == "--°C" && !self.networkerrorshown {
            self.showNetworkUnreachable()
            self.networkerrorshown = true
            NSLog("WARNING: No network available, showing alert!")
        } else if model.temperature != "--°C" && self.networkerrorshown {
            self.networkerrorshown = false
            NSLog("INFO: Resetting network error.")
        }
        if self.weatherAreaLabel.text == "null" {
            self.weatherAreaLabel.text = "Ungültige Stadt."
            self.weatherConditionLabel.text = "Anderen Begriff eingeben."
            self.temperatureLabel.text = "--°C"
        }
    }
    
}

