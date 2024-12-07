//
//  ContentView.swift
//  Mini FCM
//
//  Created by fridakitten on 04.12.24.
//

import SwiftUI

struct ContentView: View {
    @State private var project: [Project] = []
    @State private var create_project_popup: Bool = false
    @State private var settings_project_popup: Bool = false
    @State private var name: String = ""
    @State private var type: Int = 1
    
    @State private var actpath: String = ""
    @State private var action: Int = 0
    
    @State private var buildv: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach($project) { $item in
                    NavigationLink(destination: CodeSpace(ProjectInfo: item, pathstate: $actpath, action: $action)) {
                        HStack {
                            if item.type == "1" {
                                CodeBubble(title: "C", titleColor: Color.white, bubbleColor: Color(UIColor.darkGray))
                            } else if item.type == "2" {
                                CodeBubble(title: "Lua", titleColor: Color.white, bubbleColor: Color.blue)
                            }
                            Spacer().frame(width: 20)
                            Text(item.name)
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive,  action: {
                            rm("\(NSHomeDirectory())/Documents/\(item.path)")
                            GetProjectsBind(Projects: $project)
                        }) {
                            Label("Remove", systemImage: "trash.fill")
                        }
                    }
                }
            }
            .navigationTitle("Mini FridaCodeManager")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Button( action: {
                                create_project_popup = true
                            }) {
                                Label("Create", systemImage: "plus")
                            }
                        }
                        Section {
                            Button( action: {
                                settings_project_popup = true
                            }) {
                                Label("Settings", systemImage: "gear")
                            }
                        }
                    } label: {
                        Label("", systemImage: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                GetProjectsBind(Projects: $project)
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        .sheet(isPresented: $create_project_popup) {
            BottomPopupView {
                POHeader(title: "Create Project")
                POTextField(title: "Name", content: $name)
                POPicker(function: create_project, title: "Schemes", arrays: [PickerArrays(title: "Scripting", items: [PickerItems(id: 1, name: "C"), PickerItems(id: 2, name: "Lua")])], type: $type)
            }
            .background(BackgroundClearView())
            .edgesIgnoringSafeArea([.bottom])
        }
        .sheet(isPresented: $settings_project_popup) {
            NavigationView {
                NeoEditorSettings()
            }
        }
    }
    
    private func create_project() -> Void {
        _ = MakeMiniProject(Name: name, type: type)
        GetProjectsBind(Projects: $project)
    }
    
    private func dissmiss_popup() -> Void {
        create_project_popup = false
    }
}

struct CodeSpace: View {
    @State var ProjectInfo: Project
    @State var buildv: Bool = false
    @Binding var pathstate: String
    @Binding var action: Int
    var body: some View {
        FileList(title: ProjectInfo.name, directoryPath: URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/\(ProjectInfo.path)"), buildv: $buildv,  actpath: $pathstate, action: $action, project: $ProjectInfo)
        .fullScreenCover(isPresented: $buildv) {
            if ProjectInfo.type == "1" {
                NeoLog(buildv: $buildv) {
                    DispatchQueue.global(qos: .utility).async {
                        let c_files: [String] = FindFilesStack("\(NSHomeDirectory())/Documents/\(ProjectInfo.path)", [".c"], [])
                        c_interpret(c_files.joined(separator: " "), "\(NSHomeDirectory())/Documents/\(ProjectInfo.path)")
                    }
                }
            } else {
                NeoLog(buildv: $buildv) {
                    DispatchQueue.global(qos: .utility).async {
                        o_lua("\(NSHomeDirectory())/Documents/\(ProjectInfo.path)/main.lua")
                    }
                }
            }
        }
    }
}

func FindFilesStack(_ projectPath: String, _ fileExtensions: [String], _ ignore: [String]) -> [String] {
    do {
        let (fileExtensionsSet, ignoreSet, allFiles) = (Set(fileExtensions), Set(ignore), try FileManager.default.subpathsOfDirectory(atPath: projectPath))

        var objCFiles: [String] = []

        for file in allFiles {
            if fileExtensionsSet.contains(where: { file.hasSuffix($0) }) &&
               !ignoreSet.contains(where: { file.hasPrefix($0) }) {
                objCFiles.append("\(projectPath)/\(file)")
            }
        }
        return objCFiles
    } catch {
        return []
    }
}
