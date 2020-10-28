//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Chiraag Balu on 10/24/20.
//
//app randomly chooses rock/paper/scissors
//prompt user to win or lose
//user must tap the right move to win or lose
//being correct gives a point, otherwise you lose a point
//ends after 10 questions: display score

import SwiftUI
struct ContentView: View {
    //enum for alerts
    private enum ActiveAlert {
        case game, round
    }
    @State private var cheatMode = true
    //store image names
    @State private var gameChoices = ["hexagon", "doc", "scissors"]
    //store names user sees
    @State private var gameChoiceNames = ["rock", "paper", "scissors"]
    //computer's choice (index)
    @State private var computerChoice = Int.random(in: 0 ... 2)
    //users choice (index)
    @State private var userChoice: Int = 0
    //array to store possible goals for user
    @State private var userGoals = ["win", "lose", "tie"]
    //user choice of goal (index)
    @State private var userGoal: Int = 0
    //possible results
    @State private var gameResults = ["win", "lose"]
    //result (index
    @State private var gameResult = 0
    //user's score
    @State private var userScore: Int = 0
    //rounds left
    @State private var roundsToGo: Int = 10
    //if the round is over (will trigger alert when true)
    @State private var showAlert: Bool = false
    //sets the active alert defualt
    @State private var activeAlert: ActiveAlert = .round
    var body: some View {
        //nav view for sexy title
        NavigationView {
            //stacking Vstacks cuz it looks nice
            VStack(spacing: 20) {
                //first one stores the stuff for picking goal
                VStack(spacing: 20) {
                    Text("")
                    //makes title
                    Text("How do you want to play?").font(.title)
                    //makes picker
                    Picker("User Goal: ", selection: $userGoal) {
                        //for each possible user goal ...
                        ForEach (0 ..< userGoals.count) {
                            Text(userGoals[$0])
                        }
                        //segmented style so it doesnt look bad
                    }.pickerStyle(SegmentedPickerStyle())
                    Toggle("cheeto", isOn: $cheatMode).frame(width: 200, height: 50, alignment: .top)
                }
                

                //second one stores choices
                VStack (spacing: 20) {
                    //for each possible choice
                    ForEach (0 ..< gameChoices.count) { number in
                        //if you click the thing
                        Button(action: {
                            //action
                            //userChoose is where the calculation of the user's choice happens
                            self.userChoose(number)
                        }) {
                            //buttons
                            //hstacked so i can make the title and symbol spaced
                            HStack (spacing: 50) {
                                //title - made it light up for debugging purposes
                                //delete.foregroundcolor stuff if you want it to not tell the user what the computer chose
                                Text("\(gameChoiceNames[number])").font(.title).foregroundColor(number == computerChoice && cheatMode ? Color.green:Color.primary)
                                //images: this is why we have the different named choices lol cuz i was too lazy to find pictures
                                Image(systemName: "\(gameChoices[number])").renderingMode(.original).resizable().frame(width: 50, height: 50, alignment: .center)
                            }
                        }
                    }
                }
                //third one deals with score and round info
                VStack (spacing: 10) {
                    Text("")
                    Text("User Score is \(userScore)").font(.title)
                    Text("You have \(roundsToGo) rounds left to go!").font(.title2)
                    
                }
                //spacer to fill screen
                Spacer()

                //title
            }.navigationBarTitle(Text("Rock, Paper, Scissors"))
        //alerts! they pop up when we say to (showAlert)
        }.alert(isPresented: $showAlert) {
                    //switch case allows us to show the right alert
                    switch activeAlert {
                    //technically didnt need a switch case here cuz only 2 possibilities but i did one anyways in case i want to add error alerts
                    case .round:
                        return Alert(title: Text("Round Over!"), message: Text("You \(gameResult == 0 ? "win":"lose")"), dismissButton: .default(Text("continue!")) {
                            //makes a new round
                            self.newRound()
                        })
                    case .game:
                        return Alert(title: Text("Game Over!"), message: Text("Your score was \(userScore)"), dismissButton: .default(Text("play again?")) {
                            //makes a new game
                            self.newGame()
                        })
                    }
                }
    }
    //here we say if the user won or nah
    func userChoose(_ number: Int) {
        //switch case depending on if user should win lose or tie
        switch userGoal {
        case 0:
            //if the user has to win, we shift their choice to the choice that theirs beats
            userChoice = number
            userChoice -= 1
            //wrap around
            if(userChoice < 0) {
                userChoice = 2
            }
        case 1:
            //if the user has to lose, we shift their choice to the one that beats theirs
            userChoice = number
            userChoice += 1
            //wrap around
            if(userChoice > 2) {
                userChoice = 0
            }
        case 2:
            //we shifted choices so we could directly compare later
            userChoice = number
        default:
            userChoice = number
            print("userChoose got to the default case somehow")
        }
        //since we made the userchoice comparable to the computer choice we simplified this part
        if(userChoice == computerChoice) {
            userScore += 1
            gameResult = 0
        } else {
            userScore -= 1
            gameResult = 1
        }
        //checks to see if we should end round or game
        if(roundsToGo == 0) {
            self.activeAlert = .game
        } else {
            self.activeAlert = .round
        }
        //throws up the alert
        showAlert = true
    }
    //makes new round - changing rounds left, new computer choice and resetting showAlert
    func newRound() {
        roundsToGo -= 1
        computerChoice = Int.random(in: 0 ... 2)
        showAlert = false
    }
    //makes new game, resetting user score, rounds left and new computer choice
    func newGame() {
        computerChoice = Int.random(in: 0 ... 2)
        roundsToGo = 10
        userScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
