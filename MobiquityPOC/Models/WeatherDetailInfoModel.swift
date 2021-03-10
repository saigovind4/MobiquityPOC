
import Foundation

class WeatherDetailInfoModel : Codable {
   var cod: String?
   var message, cnt: Int?
   var list: [List]?
    var city: City?
    
    enum CodingKeys: String, CodingKey {
        case cod, message, cnt, city
        case list = "list"
    }
    
    init() {
    }
}

// MARK: - City
class City: Codable {
    var id: Int
    var name: String
    var coord: Coord
    var country: String
    var population, timezone, sunrise, sunset: Int
}

// MARK: - List
class List: Codable {
    var main: MainClass
    var weather: [Weather]
    var wind: Wind
    var dtTxt: String
    var clouds: Clouds

    enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case dtTxt = "dt_txt"
        case clouds
    }
    
}

// MARK: - MainClass
class MainClass: Codable {
    var temp, feelsLike, tempMin, tempMax: Double
    var pressure, seaLevel, grndLevel, humidity: Int
    var tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
class Rain: Codable {
    var the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}
