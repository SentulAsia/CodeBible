//
//  Copyright © 2019 Zaid M. Said. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import SwiftUI

struct ViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(red: 219/255, green: 242/255, blue: 252/255))
            .cornerRadius(6)
    }
}

extension View {
    func customButton() -> some View {
        Modified(content: self, modifier: ViewStyle())
    }
}

struct FirstView : View {
    let model: String = "A Random Data"

    var body: some View {
        NavigationView {
            NavigationButton(destination: DetailView(model: self.model)) {
                HStack {
                    Image("picture")
                    Text("Go To Detail")
                }
                .customButton()
            }
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        // Add action
                    }, label: {
                        Image("first")
                    })
                    Button(action: {
                        // Add action
                    }, label: {
                        Image("second")
                    })
                }
            )
            .navigationBarTitle(Text("First View"), displayMode: .inline)
        }
    }
}

#if DEBUG
struct FirstView_Previews : PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
#endif
