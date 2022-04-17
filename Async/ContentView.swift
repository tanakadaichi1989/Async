//
//  ContentView.swift
//  Async
//
//  Created by 田中大地 on 2022/04/18.
//

import SwiftUI
import Dispatch

struct ContentView: View {
    @State var progress = 0
    
    var title: String {
        switch progress {
        case 0: return ""
        case 0..<100: return "Downloading ..."
        case 100: return "Done"
        default: return ""
        }
    }
    
    var canTap: Bool {
        switch progress {
        case 0: return true
        case 1..<100: return false
        case 100: return true
        default: return true
        }
    }
    
    var body: some View {
        VStack {
            Text("\(progress) %")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            ProgressView(title,value: Float(progress), total: 100)
                .padding()
            
            Button {
                method { result in
                    progress = result
                }
            } label: {
                Text("PUSH")
                    .fontWeight(.heavy)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canTap)
        }
    }
    
    private func method(completion: @escaping (Int) -> Void){
        var result = 0
        let global = DispatchQueue.global()
        let main = DispatchQueue.main
        
        global.asyncAfter(deadline: .now() + 1) {
            while(result < 100){
                sleep(1)
                main.async {
                    completion(result)
                }
                if result > 90 {
                    result += 1
                } else {
                    result += Int.random(in: Range(1...10))
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
