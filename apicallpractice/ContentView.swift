//
//  ContentView.swift
//  apicallpractice
//
//  Created by Atharv  on 10/07/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var weather: WeatherData?
    var body: some View {
        VStack {
            HStack{
                Text("Temperature:")
                Spacer()
                Text("\(weather?.main.temp ?? 0.0, specifier: "%.1f")°C")
            }
            HStack{
                Text("Pressure:")
                Spacer()
                Text("\(weather?.main.pressure ?? 0.0, specifier: "%.1f")")
            }
            HStack{
                Text("Feels like")
                Spacer()
                Text("\(weather?.main.feelsLike ?? 0.0, specifier: "%.1f")")
            }
            HStack{
                Text("Humidity:")
                Spacer()
                Text("\(weather?.main.humidity ?? 0.0, specifier: "%.1f")")
            }
            HStack{
                Text("Min Temperature:")
                Spacer()
                Text("\(weather?.main.tempMin ?? 0.0, specifier: "%.1f")")
            }
            HStack{
                Text("Max Temperature:")
                Spacer()
                Text("\(weather?.main.tempMax ?? 0.0, specifier: "%.1f")")
            }
        }.font(.title2)
            .fontWeight(.medium)
            .padding()
            .task {
                do {
                    weather = try await getWeatherData()
                } catch {
                    print("eroor")
                }
            }
    }
    
    func getWeatherData() async throws -> WeatherData {
        let endpoint =  "https://api.openweathermap.org/data/2.5/weather?q=Mumbai&appid=[]&units=metric"
        
        guard let url = URL(string: endpoint) else {
            throw WError.invalidURL
        }
        
let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw WError.invalidData
        }
    }
    
}

#Preview {
    ContentView()
}

struct WeatherData: Codable {
    let main: Main
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
}

enum WError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
