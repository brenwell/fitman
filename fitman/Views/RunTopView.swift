
import SwiftUI

// shows in the top part of the screen while running an exercise session
struct RunTopView: View {
    var sessionName: String
    var body: some View {
        return  HStack(alignment: .center) {
            Text("Playing Session: ")
                .font(.custom("Futura", size: 30))
                .foregroundColor(Color.black)

            Text(sessionName)
                .font(.custom("Futura", size: 25))
                .foregroundColor(Color.gray)
        }.padding()
    }
}
