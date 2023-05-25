import SwiftUI

struct ChatView: View { //Controller
    @ObservedObject var viewModel = ViewModel()
    
    let openAIManager = OpenAIManager()
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack { //list can be dynamically
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
                .foregroundColor(message.role == .user ? .white : .black)
                .padding()
                .background(message.role == .user ? .black : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.role == .assistant{ Spacer() }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
