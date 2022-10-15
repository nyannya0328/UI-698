//
//  Home.swift
//  UI-698
//
//  Created by nyannyan0328 on 2022/10/15.
//

import SwiftUI

struct Home: View {
    @State var cards : [Card] = []
    @State var enalbleBlur : Bool = false
    @State var turnonRotation  : Bool = true
    var body: some View {
        VStack(spacing: 13) {
            
            
            Toggle("Enabl", isOn: $enalbleBlur)
            
            Toggle("Trun on rotation", isOn: $turnonRotation)
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
    
            
            BoomerangCard(enalbleBlur: enalbleBlur,turnonRotation: turnonRotation, cards: $cards)
            
             .frame(height: 270)
            
            
        }
        .padding(15)
        .background{
         
            Color("BG").ignoresSafeArea()
        }
        .onAppear{setupCards()}
        
    }
    func setupCards(){
        
        for index in 1...8{
            
            cards.append(Card(imageName: "Card \(index)"))
        }
        
        if var first = cards.first{
            
            first.id = UUID().uuidString
            cards.append(first)
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BoomerangCard : View{
    
    var enalbleBlur : Bool = false
    var turnonRotation  : Bool = true
    
    @Binding var cards : [Card]
    
    @State var offset : CGFloat = 0
    @State var currentIndex : Int = 0
    var body: some View{
        
        GeometryReader{
            
            let size = $0.size
            
            
            ZStack{
                
                ForEach(cards.reversed()){card in
                    
                    CardView(card: card, size: size)
                        .offset(y:currentIndex == indexOF(card: card) ? offset : 0)
                    
                    
                    
                }
                
            }
            .animation(.easeOut(duration: 0.3), value: offset == .zero)
            .frame(width: size.width,height: size.height)
            .contentShape(Rectangle())
            .gesture(
            
                DragGesture().onChanged({ value in
                    
                    onChanged(value: value)
                    
                })
                .onEnded({ value in
                    
                    onEnded(value: value)
                })
            
            )
          
            
            
        }
    }
    func onChanged(value : DragGesture.Value){
        
        offset = currentIndex == (cards.count - 1) ? 0 :value.translation.height
        
        
    }
    func onEnded(value : DragGesture.Value){
        
        
        var translation = value.translation.height
        
        translation = (translation < 0 ? -translation : 0)
        translation = (currentIndex == (cards.count - 1) ? 0 : translation)
        
        if translation > 110{
            
            withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                
                cards[currentIndex].isRotated = true
                cards[currentIndex].scale = 0.7
                cards[currentIndex].extractOffset = -350
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                
                withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                    
                    cards[currentIndex].zIndex = -100
                    for index in cards.indices{
                        
                        cards[index].extractOffset = 0
                    }
                    
                    if currentIndex != (cards.count - 1){
                        
                        currentIndex += 1
                    }
                
                    offset = .zero
                    
                    
                }
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                for index in cards.indices{
                    
                    if index == currentIndex{
                        
                        
                        if cards.indices.contains(cards.count - 1){
                            
                            cards[currentIndex - 1].zIndex = ZIndexOf(card: cards[currentIndex - 1])
                        }
                    }
                    
                    else{
                     
                        cards[index].isRotated = false
                        
                        withAnimation(.linear){
                            
                            cards[index].scale = 1
                        }
                        
                    }
                }
                
                if currentIndex == (cards.count - 1){
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        
                        for index in cards.indices{
                            
                            cards[index].zIndex = 0
                        }
                        
                        currentIndex = 0
                        
                    }
                }
                
            }
            
            
        }
     
        
        
    }
    @ViewBuilder
    func CardView(card : Card,size : CGSize)->some View{
        
        
        let index = indexOF(card: card)
        
        
        Image(card.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width,height: size.height)
            .blur(radius: enalbleBlur && card.isRotated ? 7 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(card.scale,anchor: card.isRotated ? .center : .top)
            .rotation3DEffect(.init(degrees:turnonRotation && card.isRotated ? 360 : 0 ), axis: (x: 0, y: 0, z: 1))
            .offset(y:-offsetFor(index: index))
            .scaleEffect(scaleFor(index: index),anchor: .top)
            .zIndex(card.zIndex)
    }
    
    func ZIndexOf(card : Card)->Double{
        let index = indexOF(card: card)
        
        let totalCount = cards.count
        
        return currentIndex > index ? Double(index - totalCount) : cards[index].zIndex
        
    }
    
    func scaleFor(index value : Int)->Double{
        
        let index = Double(value - currentIndex)
        
        if index >= 0{
            
            if index > 3{
                
                return 0.8
            }
            return 1 - (index / 15)
            
        }
        else{
            
            if -index > 3{
                
                return 0.8
            }
            return 1 + (index / 15)
            
        }
        
        
    }
    
    func offsetFor(index value : Int) -> Double{
        
        let index = Double(value - currentIndex)
            
        if index >= 0{
            
            if index > 3{
                return 30
                
            }
            return (index * 10)
        }
        
        else{
            
            if -index > 3{
                
                return 30
            }
            return (-index * 10)
            
            
        }
            
    }
  
    func indexOF(card : Card) -> Int{
        
        if let index = cards.firstIndex(where: { CCAD in
            
            card.id == CCAD.id
        }){
            
            return index
        }
        return 0
    }
}
