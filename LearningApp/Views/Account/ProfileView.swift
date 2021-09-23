//
//  ProfileView.swift
//  LearningApp
//
//  Created by Lilian Grasset on 20/09/2021.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        Button {
            // Sign out the user
            try! Auth.auth().signOut()
            
            // Change to logged out view
            model.checkLogin()
            
        } label: {
            Text("Sign Out")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
