//
//  Filters.swift
//  Yelp
//
//  Created by Sara Hender on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

struct Search {
    var term: String
    var sort: YelpSortMode
    var categories: [String]
    var deals: Bool
    var radius: Int
    
    init(){
        term = "Restaurants"
        sort = YelpSortMode.bestMatched
        categories = []
        deals = false
        radius = 40000
    }
}

class Filters {
    var categories:[[String:AnyObject]] = []
    var distance:[[String:AnyObject]] = []
    var sort:[[String:AnyObject]] = []

    var switchStatesDeal: [Bool]?
    var switchStatesDistance: [Bool]?
    var switchStatesSort:[Bool]?
    var switchStatesCategory: [Bool]?
    
    init() {
        categories = yelpCategories() as [[String : AnyObject]]
        distance = yelpDistance() as [[String : AnyObject]]
        sort = yelpSort() as [[String : AnyObject]]
        
        switchStatesDeal = Array(repeating: false, count: 1)
        switchStatesDistance = Array(repeating: false, count: distance.count)
        switchStatesSort = Array(repeating: false, count: sort.count)
        switchStatesCategory = Array(repeating: false, count: categories.count)
    }
    
    func update(_ filters: Filters) {
        switchStatesDeal?[0] = filters.switchStatesDeal![0]
        
        for i in 0..<switchStatesDistance!.count {
            switchStatesDistance?[i] = filters.switchStatesDistance![i]
        }
        
        for i in 0..<switchStatesSort!.count {
            switchStatesDistance?[i] = filters.switchStatesDistance![i]
        }
        
        for i in 0..<switchStatesCategory!.count {
            switchStatesCategory?[i] = filters.switchStatesCategory![i]
        }
        
    }
    
    func toSearch() -> Search {
        print(#function)
        
        var search:Search = Search()
         
        if switchStatesDeal?[0] == true {
            search.deals = true
        }
        else {
            search.deals = false
        }
         
        for i in 0..<switchStatesDistance!.count {
            if switchStatesDistance![i] == true {
                search.radius = distance[i]["code"] as! Int
            }
        }
         
        for i in 0..<switchStatesSort!.count {
            if switchStatesSort![i] == true {
                search.sort = sort[i]["code"] as! YelpSortMode
            }
        }
         
        for i in 0..<switchStatesCategory!.count {
            if switchStatesCategory![i] == true {
                search.categories.append(categories[i]["code"] as! String)
            }
        }
        print("Done")
        return search
    }
    
    func count() -> Int {
        return 4
    }

    func subfilterCount(_ subfilter: Int) -> Int {
        switch(subfilter) {
        case 0:
            return yelpDeals().count
        case 1:
            return yelpDistance().count
        case 2:
            return yelpSort().count
        default:
            return yelpCategories().count
        }
    }
    
    func filter(_ subfilter: Int) -> String {
        switch(subfilter) {
        case 0:
            return "Deals"
        case 1:
            return "Distance"
        case 2:
            return "Sort"
        default:
            return "Category"
        }
    }
    
    func subfilter(_ subfilter: Int, index: Int) -> String {
        switch(subfilter) {
        case 0:
            return yelpDeals()[index]["name"]!
        case 1:
            return yelpDistance()[index]["name"]! as! String
        case 2:
            return yelpSort()[index]["name"]! as! String
        default:
            return yelpCategories()[index]["name"]!
        }
    }

    func getState(_ subfilter: Int, index: Int) -> Bool {
        switch(subfilter) {
        case 0:
            return switchStatesDeal![index]
        case 1:
            return switchStatesDistance![index]
        case 2:
            return switchStatesSort![index]
        default:
            return switchStatesCategory![index]
        }
    }

    func setState(_ subfilter: Int, index: Int, state: Bool) {
        switch(subfilter) {
        case 0:
            switchStatesDeal![index] = state
        case 1:
            switchStatesDistance![index] = state
        case 2:
            switchStatesSort![index] = state
        default:
            switchStatesCategory![index] = state
        }
    }
    
    //deals_filter=true or false
    func yelpDeals() -> [[String:String]] {
        return [["name": "Deals", "code":"false"]]
    }
    //sort=0 or 1 or 2
    func yelpSort() -> [[String:AnyObject]] {
        return [["name": "Best Match" as AnyObject, "code": YelpSortMode.bestMatched as AnyObject],
                ["name": "Distance" as AnyObject, "code": YelpSortMode.distance as AnyObject],
                ["name": "Highest Rated" as AnyObject, "code": YelpSortMode.highestRated as AnyObject]]
    }
    //radius_filter= meters, max is 40,000m (25miles)
    // 1 meter ~= .00062miles
    func yelpDistance() -> [[String:AnyObject]] {
        return [["name": "0.5 miles" as AnyObject, "code": 402 as AnyObject],
                ["name": "1 mile" as AnyObject, "code": 1609 as AnyObject],
                ["name": "2.5 miles" as AnyObject, "code": 4023 as AnyObject],
                ["name": "5 miles" as AnyObject, "code": 8046 as AnyObject],
                ["name": "10 miles" as AnyObject, "code": 16093 as AnyObject]]
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }
}
