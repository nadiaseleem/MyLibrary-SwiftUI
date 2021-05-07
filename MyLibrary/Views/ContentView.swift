//
//  ContentView.swift
//  MyLibrary
//
//  Created by Nadia Seleem on 20/07/1442 AH.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var library:Library
    var body: some View {
        NavigationView{
            List{
                AddNewBook()
                switch library.sortStyle{
                case .title,.author:
                    BookRows(data: library.sortedBooks, section: nil)
                    
                case .manual:
                ForEach(Section.allCases,id:\.self) { section in
                    SectionView(section: section )
                    
                }
                }
            }.toolbar{
                ToolbarItem(content: EditButton.init)
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort") {
                        Picker("Sort Style", selection: $library.sortStyle) {
                            ForEach(SortStyle.allCases,id:\.self) { style in
                                HStack {
                                    Text("\(style)".capitalized)
                                    Image(systemName: style.rawValue)
                                }
                            }
                        }
                    }
                }
            }
            
            .navigationBarTitle("My Library")
        }
    }
}
struct AddNewBook:View{
    @State var addingNewBook:Bool = false
    var body: some View{
        
        Button(action: {
            addingNewBook = true
        }, label: {
            Spacer()
            VStack(spacing: 6.0){
                Image(systemName: "book.circle")
                    .font(.system(size: 60))
                Text("Add New Book")
            }
            Spacer()
            
        }) .buttonStyle(BorderlessButtonStyle())
        .padding(.vertical,8)
        .sheet(isPresented: $addingNewBook, content: {
            AddNewBookView()
        })
        
    }
}
private struct RowView:View{
    @ObservedObject var book: Book // to observe any change that happens to the object properties (i.e. microReview)
    @EnvironmentObject var library:Library
    var body: some View{
        NavigationLink(
            destination: DetailView(book: book)){
            
            HStack {
                Book.Image(title: book.title, image: library.uiImages[book] ,size: 80,cornerRadius: 12)
                
                
                VStack(alignment: .leading) {
                    TitleAndAuthorStack(book: book,titleFont: .title2,authorFont: .title3)
                    if !book.microReview.isEmpty{
                        
                        Spacer()
                        Text(book.microReview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .lineLimit(1)
                Spacer()
                BookMarkButton(book: book)
                    .buttonStyle(BorderlessButtonStyle())
            } .padding(.vertical,8)
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Library())
            .previewedInAllColorScheme
    }
}

private struct BookRows:DynamicViewContent{
    let data:[Book]
    let section:Section?
    @EnvironmentObject var library:Library
    var body: some View{
        ForEach(data) { book in
            RowView(book: book)
        }.onDelete(perform: { indexSet in
            library.deleteBooks(atOffsets: indexSet, section: section)
        })
        
    }
}

private struct SectionView:View{
    @EnvironmentObject var library:Library
    let section:Section
    var body: some View{
        if let books = library.manuallySortedBooks[section]{
            
            SwiftUI.Section(
                header:
                    ZStack {
                        Image("BookTexture")
                        .resizable()
                        .scaledToFit()
                        Text(books[0].readMe ? "Read Me!":"Finished!")
                            .font(.custom("American typewriter", size: 24))
                          
                    }
                    .listRowInsets(.init())
            ){
                BookRows(data: books, section: section)
                    .onMove(perform: { indices, newOffset in
                        library.moveBooks(oldOffsets: indices, newOffset: newOffset, section: section)
                       
                    })
                
            }
        }
    }
}
