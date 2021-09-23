//
//  UserService.swift
//  LearningApp
//
//  Created by Lilian Grasset on 23/09/2021.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    private init() {
        
    }
}
