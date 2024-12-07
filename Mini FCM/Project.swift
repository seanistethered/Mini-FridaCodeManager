//
//  Project.swift
//  Mini FCM
//
//  Created by fridakitten on 04.12.24.
//

import SwiftUI
import Foundation

struct Project: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let type: String
    let path: String
}

func MakeMiniProject(Name: String, type: Int) -> Int {
    let v2uuid: UUID = UUID()
    let ProjectPath: String = "\(NSHomeDirectory())/Documents/\(v2uuid)"

    do {
        try FileManager.default.createDirectory(atPath: ProjectPath, withIntermediateDirectories: true)

        let dontTouchMePlistData: [String: Any] = [
            "NAME": Name,
            "TYPE": type
        ]

        let dontTouchMePlistPath = "\(ProjectPath)/DontTouchMe.plist"
        let dontTouchMePlistDataSerialized = try PropertyListSerialization.data(fromPropertyList: dontTouchMePlistData, format: .xml, options: 0)
        FileManager.default.createFile(atPath: dontTouchMePlistPath, contents: dontTouchMePlistDataSerialized, attributes: nil)

        switch(type) {
        case 1: // C Project
            FileManager.default.createFile(atPath: "\(ProjectPath)/main.c", contents: Data("\(authorgen(file: "main.c"))#include <stdio.h>\n \nint main(void) {\n    printf(\"Hello, World!\\n\");\n    return 0;\n}".utf8))
            break
        case 2: // LUA
            FileManager.default.createFile(atPath: "\(ProjectPath)/main.lua", contents: Data("print(\"Hello, World!\")".utf8))
            break
        default:
            return 2
        }
    } catch {
        print(error)
        return 1
    }

    return 0
}

//TODO: add author settings
func authorgen(file: String) -> String {
    let author = UserDefaults.standard.string(forKey: "Author")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yy"
    let currentDate = Date()
    return "//\n// \(file)\n//\n// Created by \(author ?? "Anonym") on \(dateFormatter.string(from: currentDate))\n//\n \n"
}

func GetProjectsBind(Projects: Binding<[Project]>) -> Void {
    DispatchQueue.global(qos: .background).async {
        do {
            let currentProjects = Projects.wrappedValue
            var foundProjectNames = Set<String>()

            for Item in try FileManager.default.contentsOfDirectory(atPath: "\(NSHomeDirectory())/Documents") {
                if Item == "Inbox" || Item == "savedLayouts.json" || Item == ".sdk" || Item == ".cache" || Item == "virtualFS.dat" {
                    continue
                }

                foundProjectNames.insert(Item)

                do {
                    let dontTouchMePlistPath = "\(NSHomeDirectory())/Documents/\(Item)/DontTouchMe.plist"

                    var NAME = "Unknown"
                    var TYPE = "Unknown"

                    if let Info2 = NSDictionary(contentsOfFile: dontTouchMePlistPath) {
                        if let extractedName = Info2["NAME"] as? String {
                            NAME = extractedName
                        }
                        if let extractedType  = Info2["TYPE"] as? Int {
                            TYPE = "\(extractedType)"
                        }
                    }

                    let newProject = Project(name: NAME, type: TYPE, path: Item)

                    if let existingIndex = currentProjects.firstIndex(where: { $0.path == Item }) {
                        let existingProject = currentProjects[existingIndex]
                        if existingProject != newProject {
                            usleep(500)
                            DispatchQueue.main.async {
                                withAnimation {
                                    Projects.wrappedValue[existingIndex] = newProject
                                }
                            }
                        }
                    } else {
                        usleep(500)
                        DispatchQueue.main.async {
                            withAnimation {
                                Projects.wrappedValue.append(newProject)
                            }
                        }
                    }
                }
            }

            usleep(500)
            DispatchQueue.main.async {
                withAnimation {
                    Projects.wrappedValue.removeAll { project in
                        !foundProjectNames.contains(project.path)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
