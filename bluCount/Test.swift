//
//  ContentView.swift
//  bluCount
//
//  Created by Scott Brown on 01/01/2021.
//

import SwiftUI

struct TestView: View{
    
    
    
    @State var count : Int =  0

    
    var body: some View{
        HStack{
            Spacer()
            Button(action:{
                self.count += 1
                print(count)
            }){
                Text("+")
            }
            Spacer()
            VStack{
            Text("Name")
                Text("\(self.count)")
            }
            Spacer()
            Button(action:{
                if (self.count > 0){
                    self.count -= 1
                }
            }){
                Text("-")
            }
            Spacer()
        }
        .navigationTitle("Edit Item")
    }
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
