//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Lilian Grasset on 17/08/2021.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            // Only show the video if we get a valid url
            if url != nil {
                VideoPlayer (player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description
            CodeTextView()
            
            
            // Show next lesson button, only if there is a next lesson
            if model.hasNextLesson() {
                Button(action: {
                    // Advance the lesson
                    model.nextLesson()
                }, label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                   
                })
            }
            else {
                
                // Show the complete button instead
                Button(action: {
                    
                    // Take the user back to the homeview
                    model.currentContentSelected = nil
                    
                }, label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                   
                })
            }
        }
        .padding()
        .navigationBarTitle(lesson?.title ?? "")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
            .environmentObject(ContentModel())
    }
}
