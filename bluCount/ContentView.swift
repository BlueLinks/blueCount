//
//  ContentView.swift
//  bluCount
//
//  Created by Scott Brown on 01/01/2021.
//

import SwiftUI

import UIKit


fileprivate extension Color {
    typealias SystemColor = UIColor
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        

        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
        
        
        return (r, g, b, a)
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        
        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}

class counterItem: Identifiable, ObservableObject, Codable {
    var id = UUID()
    @Published var name : String
    @Published var count : Int = 0
    @Published var color : Color = .clear
    
    init(name : String = "", color : Color = .clear){
        self.name = name
        self.color = color
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func setColor(color : Color){
        self.color = color
    }
    
    func increase(){
        self.count += 1
        print(count)
    }
    
    func decrease(){
        if (count > 0){
            self.count -= 1
        }
        print(count)
    }
    
    enum CodingKeys: CodingKey {
        case name
        case count
        case color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        count = try container.decode(Int.self, forKey: .count)
        color = try container.decode(Color.self, forKey: .color)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(count, forKey: .count)
        try container.encode(color, forKey: .color)
    }
}

struct listItem: Identifiable, View{
    var id = UUID()
    @ObservedObject var counterItem : counterItem
    
    @State var showingAddView = false
    
    @State var name : String = ""
    @State var color : Color = .clear
    
    
    var body: some View{
        HStack{
            Spacer()
            Button(action:{
                // decreasing counter
                self.counterItem.decrease()
            }){
                Image(systemName: "minus.circle")
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:{
                showingAddView.toggle()
            }){
                VStack{
                    Text(self.counterItem.name)
                    Text("\(self.counterItem.count)")
                }
            }
            Spacer()
            Button(action:{
                // Increasing counter
                self.counterItem.increase()
            }){
                Image(systemName: "plus.circle")
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
        }.frame(maxWidth: .infinity)
        .onAppear(){
            self.name = self.counterItem.name
            self.color = self.counterItem.color
        }
        .sheet(isPresented: $showingAddView, content: {
            NavigationView{
                Form{
                    TextField("Enter name for your counter", text: $name)
                    ColorPicker("Select the colour you want", selection: $color)
                }
                .navigationTitle("Modify")
                .navigationBarItems(trailing: Button(action: {
                    
                    self.counterItem.setName(name: name)
                    self.counterItem.setColor(color: color)
                    
                    showingAddView.toggle()
                }) {
                    Text("Done").bold()
                })
            }
        }).padding()
        .background(self.counterItem.color)
    }
}

struct ContentView: View {
    
    @State var elements : [counterItem] = []
    
    
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                List{
                    ForEach(elements){ item in
                        listItem(counterItem: item).frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets())
                    }
                    .onMove(perform: move)
                    .onDelete(perform: self.deleteItem)
                }
            }
            .navigationBarItems(trailing: EditButton())
            .navigationTitle("bluCount")
            
        }
        Button(action:{
            elements.append(counterItem())
        }){
            Text("Add!")
        }
        .onAppear(){
            getItems()
            
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.elements.move(fromOffsets: source, toOffset: destination)
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.elements.remove(atOffsets: indexSet)
    }
    
    func getItems(){
        self.elements.append(counterItem(name: "Doritos", color: .red))
        self.elements.append(counterItem(name: "Pringles", color: .green))
        self.elements.append(counterItem(name: "Texes BBQ", color: .purple))
    }
    
    func addItem(){
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
