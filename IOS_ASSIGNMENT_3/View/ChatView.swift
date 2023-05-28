import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    
    let openAIManager = OpenAIManager()
    
    let lightBlue = Color(red: 70/255, green: 159/255, blue: 196/255)
    
    var body: some View {
        ZStack {
            Color("lightDarkColor").ignoresSafeArea()
            VStack {
                ScrollView(.vertical) {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(viewModel.messages.dropFirst(), id: \.id) { message in
                                if message.role != .system || message.id == viewModel.typingMessageId {
                                    messageView(message: message)
                                        .id(message.id)
                                }
                            }
                        }
                        .padding()
                        .background(Color("navColor").cornerRadius(8))
                        .onChange(of: viewModel.messages) { messages in
                            scrollView.scrollTo(messages.last?.id)
                        }
                    }
                }
                .padding()
                .background(Color("navColor").cornerRadius(8))
                
                HStack {
                    TextField("Enter a message", text: $viewModel.currentInput)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(12)
                    
                    Button(action: {
                        viewModel.sendMessage()
                        hideKeyboard()
                    }) {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding()
                            .background(viewModel.isSendButtonDisabled ? Color.gray.opacity(0.3) : .pink)
                            .cornerRadius(12)
                            .opacity(viewModel.isSendButtonDisabled ? 0.3 : 1.0)
                    }
                    .disabled(viewModel.currentInput.isEmpty)
                }
            }
            .padding()
        }
        .onTapGesture {
            hideKeyboard() // Dismiss keyboard when tapped anywhere on the screen
        }
    }
    
    func messageView(message: Message) -> some View {
        VStack {
            HStack {
                if message.role == .user { Spacer() }
                Text(message.content)
                    .foregroundColor(message.role == .assistant ? Color(UIColor.label) : .white)
                    .padding()
                    .background(message.role == .user ? lightBlue : .gray.opacity(0.2))
                    .cornerRadius(16)
                if message.role == .assistant { Spacer() }
            }
            if viewModel.isTyping && message.id == viewModel.typingMessageId {
                TypingIndicatorView()
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TypingIndicatorView: View {
    @State var dotsCount = 0
    
    let animation = Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: false)
    
    var body: some View {
        HStack {
            Text("Typing" + String(repeating: ".", count: dotsCount))
                .foregroundColor(Color(UIColor.label))
                .padding(.top, 4)
            
            Spacer()
        }
        .padding(.leading)
        .onAppear {
            withAnimation(animation) {
                dotsCount = 3
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

