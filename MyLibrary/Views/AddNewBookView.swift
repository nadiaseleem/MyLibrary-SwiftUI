//
//  AddNewBookView.swift
//  MyLibrary
//
//  Created by Nadia Seleem on 25/07/1442 AH.
//

import SwiftUI

struct AddNewBookView: View {
    @ObservedObject var book = Book(title: "", author: "")
    @EnvironmentObject var library:Library
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            VStack(spacing: 24.0){
                TextField("Title", text: $book.title)
                TextField("Author", text: $book.author)
                ReviewAndImageStack(book: book)
            }
            .padding()
            .navigationBarTitle("Got a new book ?")
            .toolbar{
                
                ToolbarItem(placement: .status){
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        library.addNewBook(book, image: library.uiImages[book])
                        
                    }, label: {
                        Text("Add Book")
                            .padding()
                        
                    }).disabled(
                        [book.title,book.author].contains(where: \.isEmpty)
                    )
                }
            }
            
        }
    }
}

struct AddNewBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBookView().environmentObject(Library())
    }
}
