//
//  DetailView.swift
//  MyLibrary
//
//  Created by Nadia Seleem on 20/07/1442 AH.
//

import SwiftUI
import PhotosUI
struct DetailView: View {
    let book: Book
    @EnvironmentObject var library:Library
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 16.0) {
                BookMarkButton(book: book)
                TitleAndAuthorStack(book: book, titleFont: .title, authorFont: .title2)
            }
            
            ReviewAndImageStack(book: book)
            
            Spacer()
        }.padding()
        
        
    }
}



struct ImageButtons: View {
    let book: Book
    @EnvironmentObject var library:Library
    @State var alertIsShowing = false
    @State var pickerViewIsShowing = false
    
    var body: some View {
        HStack {
            if library.uiImages[book] != nil {
                Button(action: {
                    alertIsShowing = true
                }, label: {
                    Text("Delete image")
                })
                .alert(isPresented: $alertIsShowing, content: {
                    .init(
                        title: Text("Delete the image for \(book.title)?")
                        , primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            library.uiImages[book] = nil
                        }), secondaryButton: Alert.Button.cancel())
                })
                .foregroundColor(.red)
                Spacer()
            }
            
            Button(action: {
                pickerViewIsShowing = true
            }, label: {
                Text("Upload Image…")
            })
            .padding()
            .sheet(isPresented: $pickerViewIsShowing) {
                PHPickerViewController.View(image: $library.uiImages[book])
            }
        }.padding(.horizontal,10)
    }
}


struct TextFieldView: View {
    @ObservedObject var book:Book
    var body: some View {
        VStack{
            Divider()
                .padding(.vertical)
            TextField("Review…", text: $book.microReview)
            Divider()
                .padding(.vertical)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(book: Book())
            .previewedInAllColorScheme
    }
}

struct ReviewAndImageStack: View {
    let book: Book
    @EnvironmentObject var library:Library
    var body: some View {
        VStack {
            TextFieldView(book: book)
            Book.Image(title: book.title,image: library.uiImages[book],cornerRadius: 16)
                .scaledToFit()
            ImageButtons(book: book)
        }
       
    }
}
