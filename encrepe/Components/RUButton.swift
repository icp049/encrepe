import SwiftUI

struct RUButton: View {
    
    let title: String
    let background: Color
    let action: () -> Void
    
    
    
    var body: some View {
        
        
        Button{
            action()
            
        } label: {
            Text(title)
                .foregroundColor(.white)
            .bold()
            .frame(width: 200, height: 40) // Adjust the width and height as needed
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(background))        }
    }
        
    }


struct RUButton_Previews: PreviewProvider {
    static var previews: some View {
        RUButton(title: "Login", background:.black){
        }
    }
}

