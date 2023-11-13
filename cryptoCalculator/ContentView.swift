import AppKit
import SwiftUI

//--------------------------------------------------------------------------------//
struct VenturaSlider: View {
    @Binding var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Capsule()
                    .fill(ContentView.greyColor)
                    .frame(width: 230, height: 4)
                    .offset(x: 1)
                    .padding(.top)
                    .overlay(
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 230, height: 40)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let sliderX = value.location.x / 230
                                            let newValue = min(max(Double(sliderX) * 100, 1), 100)
                                            self.value = newValue
                                        }
                                )
                                
                            Circle()
                                .fill(ContentView.calculateBtnColor)
                                .frame(width: 18, height: 18)
                                .offset(x: CGFloat(value) / 100 * 230 - 115)
                                .padding(.top)

                        }
                            )
                        
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let sliderX = value.location.x / 230
                                let newValue = min(max(Double(sliderX) * 100, 1), 100)
                                self.value = newValue
                            }
                    )
            }
        }
    }
}




//--------------------------------------------------------------------------------//


struct ContentView: View {
    @State private var inputText = ""
    @State private var stopLossText = ""
    @State private var takeProfitText = ""
    @State private var TPresult = 0.0
    @State private var SLresult = 0.0
    @State private var accountSize = 0.0
    @State private var sliderValue: Double = 1.0
    static let sliderRange: ClosedRange<Double> = 1...100
    static let greyColor = Color(red: 95/255, green: 97/255, blue: 105/255)
    static let calculateBtnColor = Color(red: 25/255, green: 120/255, blue: 243/255)
    static let calculateTextColor = Color(red: 221/255, green: 245/255, blue: 203/255)
    static let firstColor = Color(red: 0/255, green: 131/255, blue: 176/255)
    static let secondColor = Color(red: 0/255, green: 180/255, blue: 219/255)
    
    
    struct TextFieldStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ContentView.greyColor, lineWidth: 0.5)
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    
    struct RegularSquareButtonStyle: ButtonStyle {
          func makeBody(configuration: Configuration) -> some View {
              configuration.label
                  .padding(10)
                  .background(
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(ContentView.greyColor, lineWidth: 0.3)
                        .background(ContentView.calculateBtnColor)
                          .cornerRadius(10).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                          .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
                          .listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
                  )
                  .buttonStyle(PlainButtonStyle())
          }
      }
    
    struct DeleteRegularSquareButtonStyle: ButtonStyle {
          func makeBody(configuration: Configuration) -> some View {
              configuration.label
                  .padding(10)
                  .background(
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 0.8)
                        .background(Color.clear)
                          .cornerRadius(10).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                          .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
                          .listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
                  )
                  .buttonStyle(PlainButtonStyle())
          }
      }
    
    
    
    
    func linearGradientView(configuration: ButtonStyle.Configuration) -> some View {
            return LinearGradient(
                gradient: Gradient(colors: [ContentView.firstColor, ContentView.secondColor]),
                startPoint: .leading,
                endPoint: .trailing
            )
    }
    
    
    
    
    
    func resetFields() {
        inputText = ""
        stopLossText = ""
        takeProfitText = ""
        accountSize = 0.0
        sliderValue = 0
        TPresult = 0.0
        SLresult = 0.0
       }
    
    
    var body: some View {
        VStack {
            //MAIN TITLE
            Text("Binance Futures PNL")
                .font(.title)
                .fontWeight(.medium)
                .padding()
                
            
            //AMOUNT INPUT TYPE
            TextField("Enter USDT Amount", text: $inputText)
                .modifier(TextFieldStyle())
                .frame(height: 40)
                .frame(maxWidth: .infinity)

            
            //LEVERAGE SLIDER
            VStack {
                VenturaSlider(value: $sliderValue)
                Text("Leverage: ")
                .foregroundColor(ContentView.greyColor)
                     + Text("\(sliderValue, specifier: "%.0f")x")
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
            }
                .frame(maxWidth: .infinity)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            //TP INPUT TYPE
            TextField("Enter TP Percent", text: $takeProfitText)
                .modifier(TextFieldStyle())
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            
            //SL INPUT TYPE
            TextField("Enter SL Percent", text: $stopLossText)
                .modifier(TextFieldStyle())
                .frame(maxWidth: .infinity)

            
            //CALCULATE BUTTON
            Button(action: {
                self.calculateResults()
            }) {
                Text("Calculate")
                    .foregroundColor(ContentView.calculateTextColor)
                    .fontWeight(.bold)
                    .padding(.leading, 90)
                    .padding(.trailing, 90)
                    .frame(maxWidth: .infinity)
                    
            }
            .padding(.top, 30)
            .buttonStyle(RegularSquareButtonStyle())
          
            
            //CALCULATE BUTTON
            Button(action: {
                self.resetFields()
            }) {
                Text("Delete")
                    .foregroundColor(Color.red)
                    .fontWeight(.bold)
                    .padding(.leading, 90)
                    .padding(.trailing, 90)
                    .frame(maxWidth: .infinity)
                    
            }
            .padding(.bottom, 30)
            .buttonStyle(DeleteRegularSquareButtonStyle())
            
            //FINAL RESULT
            Text("Estimated TP will be: ")
            + Text("\(TPresult, specifier: "%.2f")")
                .foregroundColor(Color.green)
                .fontWeight(.bold)
            + Text(" USDT")
            
            Text("Estimated SL will be: ")
            + Text("-\(SLresult, specifier: "%.2f")")
                .foregroundColor(Color.red)
                .fontWeight(.bold)
            + Text(" USDT")
            
            Divider()
                .padding()
            Text("Account Size: \(accountSize, specifier: "%.0f") USDT")
                .font(.headline)
        }
        
        .frame(width: 275, height: 500)
        .padding()
    }
    
    
    func calculateResults() {
        if let takeProfitNumber = Double(takeProfitText),
           let stopLossNumber = Double(stopLossText),
           let amount = Double(inputText) {
            TPresult = amount * sliderValue * ((takeProfitNumber / 100))
            SLresult = amount * sliderValue * ((stopLossNumber / 100))
            accountSize = amount * 10
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover()
    var statusBarItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()

        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSHostingController(rootView: contentView)

        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusBarButton = statusBarItem?.button {
            if let bitcoinImage = NSImage(systemSymbolName: "bitcoinsign.circle.fill", accessibilityDescription: nil) {
                statusBarButton.image = bitcoinImage

                let config = NSImage.SymbolConfiguration(scale: .large)
                statusBarButton.image = bitcoinImage.withSymbolConfiguration(config)
            }

            statusBarButton.target = self
            statusBarButton.action = #selector(togglePopover(_:))
        }
    }

    @objc func togglePopover(_ sender: AnyObject) {
        if let statusBarButton = statusBarItem?.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                if let buttonView = statusBarItem?.button {
                    let buttonRect = buttonView.bounds
                    popover.show(relativeTo: buttonRect, of: buttonView, preferredEdge: .minY)
                }
            }
        }
    }
}
