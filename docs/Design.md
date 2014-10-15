# App Design Document

## Table of Contents
  * [Description](#description)
    * [Purpose](#purpose)
  * [Architecture](#architecture)
    * [Design](#design)
    * [Approach](#approach)
    * [Classes](#classes)
  * Graphic Design (#graphic-design)
  * [Milestones](#milestones)
    * [Milestone 1](#milestone-1)
    * [Milestone 2](#milestone-2)
    * [Milestone 3](#milestone-3)
    * [Milestone 4](#milestone-4)
    * [Milestone 5](#milestone-5)
    * [Milestone 6](#milestone-6)

---

### Description

#### Purpose

The Refuge Restrooms app is a complement to the Refuge Restrooms web application - a resource that allows transgender, intersex, and gender non-conforming individuals to find and tag safe and accessible restrooms. While the web application is functional, a mobile application could serve as a more natural experience to tag and find restrooms on-the-go.


[Back to top ^](#)

---

### Architecture

#### Design

* Attached is the first mockup for the app screens: [Mockup V1] (https://github.com/mgwu-students/harlan-kellaway/raw/master/Images/app-mockup-v1.tiff)
* The mockup was run by the creator of refugerestrooms.org - she indicated she'd like the Details scene (when a bathroom is selected) to look more like the screen on this thread: https://github.com/RefugeRestrooms/refugerestrooms/issues/20 [(Image)] (https://github.com/mgwu-students/harlan-kellaway/raw/master/Images/app-details-scene1.jpeg)

#### Approach

The app will be bundled with current Restroom data (as JSON or Restroom objects in Core Data) at the time of release. Upon first opening the application, Restroom objects will be created and/or used to create MapLocation objects. A flag will be set in NSUserDefaults to record that the initial set had been created. Each time the user then opens the application, an API call can be made (if the user is online) to fetch records that have since been created and translate them accordingly - a data should also be set in NSUserDefaults to determine records to be fetched after the last date.

#### Classes

Navigation will be handled through a *Tab Bar Controller* with these options options: *Map*, *Search*, *Settings*

- ```RRMapViewController``` - displays a map with pins around your location or the last location you search if Location Services are disabled
    - *MapKit  View*
    - *Tab Bar Button (+)*
- ```RRAddViewController``` - displays a simple form for adding a new restroom to the map
    - *Labels*
    - *Text Fields*
    - *Checkboxes*
    - *Yes/No* toggle for Safety Rating
    - etc.
- ```RRSearchViewController``` - provides a search box and table view of results
    - *Search Bar*
    - *Table View* for results
- ```RRDetailsViewController``` - displays the details of any pin pop-over that is tapped or a search result tapped [(Image)] (https://github.com/mgwu-students/harlan-kellaway/raw/master/Images/app-details-scene1.jpeg)
    - *Labels*
    - *Images*
    - etc.
- ```RRSettingsViewController``` - displays the settings a user has the option to change (e.g. Location Services being enabled)
    - *Labels*
    - *Toggles*
    - etc.


[Back to top ^](#)

---

### Graphic Design

[Color Palette](https://color.adobe.com/Refuge-Restrooms-color-theme-4191730/)
[Assets](https://github.com/RefugeRestrooms/refuge_assets)

[Back to top ^](#)

---

### Milestones

Minimum Viable Product: The most bare bones form of this app would simply allow you to to search a location and display the closest results in a table. If a search record is selected, details for that restroom will be displayed in a separate view.

The next step up is displaying results on a map. The next step is to integrate Location Services - and prompting the user to allow/disallow/never ask again as well as marking this in their Settings for the app. The next step up is being able to allow users to enter their own records. The next level would be to allow users to make comments on listings already made (the web application uses Disqus for this).

#### Milestone 1 

- Figure out strategy for fetching (and perhaps retaining) any data from the Refuge Restrooms API http://www.refugerestrooms.org/api/docs/
- Create a Search view with a search bar that populates a Table View accordingly
- Understand how to incorporate some automated testing!

#### Milestone 2

- Change the landing screen to be a map (it can be centered on an arbitrary location for now such as 1 Embarcadero Center) with pins display location records
- Allow users to click on pins to get a pop-over of the name and address
- A click on a pop-over should bring the user to the record for that restroom
- Automated testing..

#### Milestone 3

- Leverage location services! When the user first open their app, prompt to use location services. Mark this setting on their Settings page.
- For users who indicate that Location Services can be used - have the app open centered on their current location and display them on the map

#### Milestone 4

- Allow users to create new records and verify these are POSTed to the Refugre Restrooms server

#### Milestone 5

*Nice to haves*

- Add an option to the settings page to automatically filter pins displayed and search by accessibility
- Add the ability for users to add comments to existing records (need to talk to Refuge creator about how this would would work with existing Disqus comments)


### Milestone 6

- Integrate users saving their favorites
- Have favorites be available without a Wifi connection! (CoreData)

[Back to top ^](#)
