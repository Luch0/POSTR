# POSTR

When you're looking for an easy way to stay connected with the ones that matter, open up POSTR.

## Getting Started

### Prequisites
* Xcode and CocoaPods is needed to run this project. Make sure you have Xcode and CocoaPods installed on your local machine.
* Clone/ download the zipfile of this app project.

### Installing
* Open Terminal.
* CD to the folder of where the project has been cloned/ downloaded.
* All necessary cocoapods needed for this project are included (AlamoFire, Chameleon Framework, Firebase, Kingfisher, SnapKit, and Toucan).

Install the cocoapods needed by entering the below after cding into the project folder
```
pod install
```

## Run Project on Mac's iPhone Simulator
* Open the POSTR project and open the file that says "POSTR.xcworkspace."
* Xcode will load the project for you. Click on "POSTR" in the left sidebar.
* On the upper left hand side of Xcode is play button, click to run project, an iPhone simulator will popup and take a few minutes to load.
* Enter a valid email address into the email textfield.
* Enter a password (minimum six characters) into the password textfield.
* Click on the "Create Account" button.
* Check your email inbox for a verification email (in case it doesn't appear, check the SPAM folder).
* Verify your email address and start making posts on POSTR.

## Deployment to iOS Device
It is possible to sideload this project app into your iOS device by following these instructions :

* Open the POSTR project and open the file that says "POSTR.xcworkspace."
* Xcode will load the project for you. Click on "POSTR" in the left sidebar.
* You’ll need to change a couple of settings in order to install the app on your iPhone. First, go to “Xcode -> Preferences“, and click on the “Accounts” tab. You’ll have to add your Apple ID here. You can simply click on the plus icon in the bottom of the screen and add your Apple ID. It doesn’t need to be a developer ID, you can use your free Apple ID, as well.
* Once you have done that, you will need to change a couple of settings for the Xcode project. Firstly, change the value next to “Bundle Identifier“, and make it anything that is unique, and looks like xyz.POSTR. In my case, I’ve replaced “xyz” with my name.
* You’re all set to install POSTR on your iPhone. Simply connect your iPhone to your Mac. Then, go to “Product -> Destination“, and select your iPhone from the list.
* Now, click on the “Run” button in Xcode. Xcode will then begin compiling the app for your iPhone. If you get warnings (yellow triangle signs), don’t worry about them.
* Xcode will prompt you with an error saying that you need to trust the developer on the iPhone. On your iPhone, go to “Settings -> General -> Profiles and Device Management."
* Tap on the entry under “Developer App”, and tap on “Trust."
* You can now go to your homescreen, and look for POSTR. Tap on the app to launch it.  Allow location services. POSTR is ready to use!

## Built With
* [AlamoFire](https://github.com/Alamofire/Alamofire)
* [Chameleon Framework](https://github.com/ViccAlexander/Chameleon)
* [Firebase](https://firebase.google.com/)
* [KingFisher](https://github.com/onevcat/Kingfisher)
* [SnapKit](https://github.com/SnapKit/SnapKit)
* [Toucan](https://github.com/gavinbunney/Toucan)

## Authors 
 * **Luis Calle** - [Github](https://github.com/Luch0)
 * **Vikash Hart** - [Github](https://github.com/VikashHart)
 * **Lisa Jiang** - [Github](https://github.com/NYCgirlLearnsToCode)
 * **Winston Maragh** - [Github](https://github.com/wsmaragh)
 * **Maryann Yin** - [Github](https://github.com/myin125)
