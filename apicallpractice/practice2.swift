//
//  practice2.swift
//  apicallpractice
//
//  Created by Atharv  on 11/07/25.
//

import SwiftUI

struct practice2: View {
    
    @State private var user: UserResponse?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Text ("Name: ")
                Spacer()
                Text("\(user?.results.first.map { "\($0.name.title) \($0.name.first) \($0.name.last)" } ?? "N/A")")

            }
            HStack{
                Text ("Age:")
                Spacer()
                Text ("\(user?.results.first?.dob.age.description ?? "N/A")")
            }
            HStack{
                Text("Gender:")
                Spacer()
                Text ("\(user?.results.first?.gender.capitalized ?? "N/A")")
            }
            HStack{
                Text("Connact Number:")
                Spacer()
                Text ("\(user?.results.first?.phone ?? "N/A")")
            }
        }.font(.title2)
            .fontWeight(.medium)
            .padding()
            .task {
                do {
                    user = try await getUserData()
                } catch {
                    print("eroor")
                }
            }
    }
    func getUserData() async throws -> UserResponse {
        let endpoint = "https://randomuser.me/api/"
        
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
            return try decoder.decode(UserResponse.self, from: data)
        } catch {
            throw WError.invalidData
        }
    }
}

#Preview {
    practice2()
}

struct UserResponse: Codable {
    let results: [User]
}

struct User: Codable {
    let gender: String
    let name: Name
    let dob: DateInfo
    let phone: String
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct DateInfo: Codable {
    let age: Int
}

