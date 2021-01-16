//
//  ContentView.swift
//  bluCount
//
//  Created by Scott Brown on 01/01/2021.
//

import SwiftUI

struct listItem: Identifiable, View{
    var id = UUID()
    @State public var name : String
    @State var count : Int =  0
    @State public var color : Color
    
    @State var showingAddView = false
    
    var body: some View{
        HStack{
            Spacer()
            Button(action:{
                if (count > 0) {
                    count-=1
                }
                print(count)
            }){
                Image(systemName: "minus.circle")
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:{
                showingAddView.toggle()
            }){
                VStack{
                    Text(self.name)
                    Text("\(self.count)")
                }
            }
            Spacer()
            Button(action:{
                self.count += 1
                print(count)
            }){
                Image(systemName: "plus.circle")
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
        }.frame(maxWidth: .infinity)
        .sheet(isPresented: $showingAddView, content: {
            NavigationView{
                Form{
                    TextField("Enter name for your counter", text: $name)
                    ColorPicker("Select the colour you want", selection: $color)
                }
                .navigationTitle("Modify")
                .navigationBarItems(trailing: Button(action: {
                    
                    showingAddView.toggle()
                }) {
                    Text("Done").bold()
                })
            }
        }).padding()
        .background(color)
    }
}

struct ContentView: View {
    
    @State var elements : [listItem] = []
    
    
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                List{
                    ForEach(elements){ item in
                        item.frame(maxWidth: .infinity)
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
            elements.append(listItem(name: "New Item", color: .clear))
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
        self.elements.append(listItem(name: "Doritos", color: .red))
        self.elements.append(listItem(name: "Pringles", color: .green))
        self.elements.append(listItem(name: "Texes BBQ", color: .purple))
    }
    
    func addItem(){
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
