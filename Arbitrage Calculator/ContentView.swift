//
//  ContentView.swift
//  Arbitrage Calculator
//
//  Created by Alexandros Ntagkonikos on 25/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var firstOdd: String = "";
    @FocusState private var focusedFirstOdd: Bool;
    @State private var firstStake: String = "";
    @FocusState private var focusedFirstStake: Bool;
    
    @State private var secondOdd: String = "";
    @FocusState private var focusedSecondOdd: Bool;
    @State private var secondStake: String = "";
    @FocusState private var focusedSecondStake: Bool;
    @State private var totalStake: String = "100";
    @FocusState private var focusedTotalStake: Bool;
    
    @State private var firstProfit: String = "";
    @State private var secondProfit: String = "";
    @State private var totalProfit: String = "";
    
    var body: some View {
        VStack {
            HStack {
                Text("Arbitrage Calculator")
                    .font(.title2)
                Spacer()
            }
            HStack {
                Text("by ntagks")
                    .font(.callout)
                    .foregroundColor(.gray)
                Spacer()
            }
        
            
            HStack {
                VStack {
                    Text("Odds")
                    
                    TextField(
                           "Booker Odd",
                           text: $firstOdd
                    )
                    .focused($focusedFirstOdd)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: firstOdd) { newValue in
                        recalculate()
                    }
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    
                    
                    TextField(
                           "Booker Odd",
                           text: $secondOdd
                    )
                    .focused($focusedSecondOdd)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: secondOdd) { newValue in
                        recalculate()
                    }
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    Spacer()
                }
                
                VStack {
                    Text("Bets")
                    
                    TextField(
                           "Stake",
                           text: $firstStake
                    )
                    .focused($focusedFirstStake)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: firstStake, perform: { newValue in
                        betRecalculator(newValue: newValue, idx: 0)
                    })
                    .keyboardType(.decimalPad)
                    
                    TextField(
                           "Stake",
                           text: $secondStake
                    )
                    .focused($focusedSecondStake)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: secondStake, perform: { newValue in
                        betRecalculator(newValue: newValue, idx: 1)
                    })
                    .keyboardType(.decimalPad)
                    
                    TextField(
                           "Stake",
                           text: $totalStake
                    )
                    .focused($focusedTotalStake)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: totalStake) { newValue in
                        recalculate()
                    }
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    Spacer()
                }
                
                VStack {
                    Text("Profit")
                    
                    TextField(
                           "Returns",
                           text: $firstProfit
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                    .foregroundColor(getFirstProfitColor)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    
                    TextField(
                           "Returns",
                           text: $secondProfit
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                    .foregroundColor(getSecondProfitColor)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    
                    HStack() {
                        Spacer()
                        Text($totalProfit.wrappedValue)
                            .padding(.top, 8.0)
                        .foregroundColor(getColor)
                        
                        Text("%")
                            .padding(.top, 8.0)
                        .foregroundColor(getColor)
                        .opacity($totalProfit.wrappedValue != "" ? 1 : 0)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
            
            }
            .padding(10)
            
            Spacer()
            Link(destination: URL(string: "https://play.google.com/store/apps/developer?id=ntagks")!) {
                Text("ntagks")
                    .italic()
                    .foregroundColor(Color.cyan)
            }
            
        }
        .padding()
    }
    
    func recalculate() {
        if (focusedFirstOdd || focusedSecondOdd || focusedTotalStake) {
            if (!firstOdd.isEmpty && !secondOdd.isEmpty && !totalStake.isEmpty){
                print("Manipulating Odds & Bank fields.")
                
                // Retrive State values
                var sfo: String = firstOdd;
                var sso: String = secondOdd;
                var sbank: String = totalStake;
                
                // Convert them to decimal/format state
                sfo = sfo.replacingOccurrences(of: ",", with: ".")
                sso = sso.replacingOccurrences(of: ",", with: ".")
                sbank = sbank.replacingOccurrences(of: ",", with: ".")
                
                let fo: Float! = Float(sfo)
                let so: Float! = Float(sso)
                let bank: Float! = Float(sbank)
                if (fo >= 1 && so >= 1 && bank > 0) {
                    print("Field Requirements done.");
                    let winRatio: Float = 1 / fo + 1 / so;
                    let betFirst: Float = (1 / fo * (bank / winRatio / bank)) * bank;
                    let betSecond: Float = (1 / so * (bank / winRatio / bank)) * bank;
                    
                    totalProfit = String(rounder(number: fo * (1 / fo * (100 / winRatio / 100)) * 100 - 100));
                    firstStake = String(rounder(number: betFirst))
                    secondStake = String(rounder(number: betSecond))
                    firstProfit = String(rounder(number: fo * betFirst - bank));
                    secondProfit = String(rounder(number: so * betSecond - bank));
                }
            } else {
                print("Not all field are none null.")
                totalProfit = ""
                firstStake = ""
                secondStake = ""
                firstProfit = ""
                secondProfit = ""
            }
        }
    }
    
    func betRecalculator(newValue: String, idx: Int) {
        if (focusedFirstStake || focusedSecondStake) {
            if (!firstOdd.isEmpty && !secondOdd.isEmpty && !totalStake.isEmpty){
                
                print("Manipulating Stake fields")
                
                print("NewValue= \(newValue.isEmpty ? "0" : newValue)")
                
                // Retrive State values
                var sfo: String = firstOdd;
                var sso: String = secondOdd;
                var sfs: String;
                if (idx == 0) {
                    firstStake = newValue.isEmpty ? "" : newValue.description
                    sfs = newValue.isEmpty ? "0" : newValue.description
                } else {
                    sfs = firstStake;
                }
                var sss: String;
                if (idx == 1) {
                    secondStake = newValue.isEmpty ? "" : newValue.description
                    sss = newValue.isEmpty ? "0" : newValue.description
                } else {
                    sss = secondStake;
                }
                print("SFS \(sfs) | SSS \(sss)")
                totalStake = String((Float(sfs) ?? 0) + (Float(sss) ?? 0))
                var sbank: String = totalStake;
                
                // Convert them to decimal/format state
                sfo = sfo.replacingOccurrences(of: ",", with: ".")
                sso = sso.replacingOccurrences(of: ",", with: ".")
                sfs = sfs.replacingOccurrences(of: ",", with: ".")
                sss = sss.replacingOccurrences(of: ",", with: ".")
                sbank = sbank.replacingOccurrences(of: ",", with: ".")
                
                let fo: Float! = Float(sfo)
                let so: Float! = Float(sso)
                var fs: Float! = Float(sfs)
                var ss: Float! = Float(sss)
                var bank: Float! = Float(sbank)
                totalStake = String(rounder(number: fs + ss))
                
                if (firstStake.isEmpty) {
                    fs = 0
                    totalStake = secondStake
                    bank = ss
                }
                if (secondStake.isEmpty){
                    ss = 0
                    totalStake = firstStake
                    bank = fs
                }
                
                print("fs \(firstStake) - sf \(secondStake)")
                print("fs \(String(fs)) - sf \(String(ss))")
                print("bank \(String(bank)) - totalstake \(totalStake)")
                firstProfit = String(rounder(number: fo * fs - bank));
                secondProfit = String(rounder(number: so * ss - bank));
            } else {
                print("One or more views are empty.")
            }
        } else {
            print("Stake fields are not focused yet.")
        }
    }

    
    func rounder(number: Float) -> Float {
        return round(number * 100) / 100.0
    }
    
    var getColor: Color {
        if (!totalProfit.isEmpty) {
            print($totalProfit.wrappedValue)
            if ($totalProfit.wrappedValue > "0" ) {
                return .green
            } else {
                return .red
            }
        }
        return .black
    }
    
    var getFirstProfitColor: Color {
        if (!firstProfit.isEmpty) {
            if ($firstProfit.wrappedValue > "0" ) {
                return .green
            } else {
                return .red
            }
        }
        return .black
    }
    
    var getSecondProfitColor: Color {
        if (!secondProfit.isEmpty) {
            if ($secondProfit.wrappedValue > "0" ) {
                return .green
            } else {
                return .red
            }
        }
        return .black
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
