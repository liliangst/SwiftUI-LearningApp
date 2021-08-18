//
//  ContentModel.swift
//  LearningApp
//
//  Created by Lilian Grasset on 16/08/2021.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        
        getLocalData()
    }
 
    // MARK: - Data methods
    
    func getLocalData() {
        
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
       
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
            
        }catch {
            print("Couldn't parse local data")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
            
        }catch {
            print("Couldn't parse style data")
        }
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleId: Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count{
            if modules[index].id == moduleId {
                
                // Find the maching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
        
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
        
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
            
        }
        else
        {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func beginTest(_ moduleId: Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule?.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the html Data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        do {
            let attribuatedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
            resultString = attribuatedString
            
        }
        catch {
            print("Couldn't turn html into attributed string")
        }
        
        
        
        return resultString
    }
}
