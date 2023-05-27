import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    
    let pink = Color(red: 254/255, green: 58/255, blue: 92/255)
    let blue = Color(red: 70/255, green: 159/255, blue: 196/255)
    let grey = Color(red: 70/255, green: 159/255, blue: 196/255)

    let openAIManager = OpenAIManager()
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack { //message list are dynamic
                    ForEach(viewModel.messages.dropFirst().filter({$0.role != .system}), id: \.id) { message in messageView(message: message)
                    }
                }
            }
            HStack{
                TextField("Enter a message", text: $viewModel.currentInput)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                Button{
                    viewModel.sendMessage()
                    hideKeyboard()
                }
                label: { Text("Send").foregroundColor(.white)
                        .padding()
                    .background(.black)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    func messageView(message: Message) -> some View {
        HStack{
            if message.role == .user { Spacer() }
            Text(message.content)
                .foregroundColor(message.role == .user ? .white : blue)
                .padding()
                .background(message.role == .user ? .black : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.role == .assistant{ Spacer() }
        }
    }
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
