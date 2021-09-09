//
//  ContentView.swift
//  LearningApp
//
//  Created by Lilian Grasset on 16/08/2021.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading){
                Text("What do you want to do today ?")
                    .padding(.leading, 20)
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                           
                            VStack (spacing: 20){
                                
                                NavigationLink (
                                    destination:
                                        ContentView()
                                        .onAppear(perform: {
                                            model.beginModule(module.id)
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected) {
                                    
                                        // Learning card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    }
                                
                                NavigationLink(
                                    destination: TestView()
                                        .onAppear(perform: {
                                            model.beginTest(module.id)
                                    }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected){
                                    
                                        // Test card
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                                    }
                                NavigationLink(destination: EmptyView()) {
                                    EmptyView()
                                }
                              
                            }
                            //.padding(.bottom, 10)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Started")
            .onChange(of: model.currentContentSelected, perform: { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            })
            .onChange(of: model.currentTestSelected, perform: { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            })
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
