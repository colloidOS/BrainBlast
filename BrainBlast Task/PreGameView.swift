//
//  PreGameView.swift
//  BrainBlast Task
//
//  Created by Macintosh HD on 15/03/2025.
//

import SwiftUI

struct PreGameView: View {
    var onGameStart: () -> Void
    @State private var player1Confirmed = false
    @State private var player2Confirmed = false
    @State private var player1Offset: CGFloat = -UIScreen.main.bounds.width
    @State private var player2Offset: CGFloat = UIScreen.main.bounds.width

    var body: some View {
        VStack(spacing: 40) {
            if !player1Confirmed {
                VStack(spacing: 20) {
                    Text("Is Player 1 ready?")
                        .font(.largeTitle)
                        .offset(x: player1Offset)
                    
                    Button{
                        player1Confirmed = true
                        withAnimation(.linear(duration: 0.65)) {
                            player2Offset = 0
                        }
                        } label: {
                  Text("Yes")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Color.black
                                .cornerRadius(10)
                        )
                        .padding()
                    
                }
                .offset(x: player1Offset)
                }
            }  else if player1Confirmed && !player2Confirmed {
                VStack(spacing: 20) {
                    Text("Is Player 2 ready?")
                        .font(.largeTitle)
                        .offset(x: player2Offset)
                    Button{
                        player2Confirmed = true
                        
                    } label: {
                        Text("Yes")
                              .bold()
                              .font(.title3)
                              .foregroundColor(.white)
                              .padding()
                              .background(
                                  Color.black
                                      .cornerRadius(10)
                              )
                              .padding()
                          
                      }
                      .offset(x: player2Offset)
                    
                }
            } else {
                Color.clear.onAppear {
                       onGameStart()
                   }
            }
        }
        .padding()
        .onAppear{
            withAnimation(.linear(duration: 0.65)) {
                player1Offset = 0
            }
        }
    }
}

