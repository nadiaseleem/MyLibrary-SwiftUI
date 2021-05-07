//
//  BookViews.swift
//  MyLibrary
//
//  Created by Nadia Seleem on 20/07/1442 AH.
//

import SwiftUI

struct BookMarkButton:View{
   @ObservedObject var book: Book
    var body: some View{
        
        Button(action: {
           
            book.readMe.toggle()

        }, label: {
            
            Image(systemName: book.readMe ? "bookmark.fill":"bookmark")
                .font(.system(size: 48, weight: .light))
            
        })
    }
}

struct TitleAndAuthorStack: View {
    let book: Book
    let titleFont: Font
    let authorFont: Font
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(titleFont)
            Text(book.author)
                .font(authorFont)
                .foregroundColor(.secondary)
        }
    }
}
extension Book{
    struct Image:View {
        let title: String
        let image: UIImage?
        var size: CGFloat?
        let cornerRadius: CGFloat
        var body: some View{
            if let image = image{
                //if let swiftuiImage = uiImage.map(SwiftUI.Image.init){
              let simage = SwiftUI.Image(uiImage: image)
               simage
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                .cornerRadius(cornerRadius)
            }else{//if NO image show symbol
                let image = SwiftUI.Image(title: title) ??
                    .init(systemName: "book")
                
                image.resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension Image{
    init?(title: String){
        guard let charachter = title.first ,
              case let symbolName = "\(charachter.lowercased()).square" , UIImage(systemName: symbolName) != nil else{
            return nil
        }
        self.init(systemName: symbolName)
    }
}


extension Book.Image{
    init(title:String) {
        self.init(title: title, image: nil,cornerRadius: .init())
    }
}
extension View{
    var previewedInAllColorScheme:some View{
        ForEach(ColorScheme.allCases, id: \.self, content: preferredColorScheme)
    }
}

struct Book_Previews: PreviewProvider{
    static var previews: some View{
        VStack{
            BookMarkButton(book: .init())
            BookMarkButton(book: .init(readMe:false))

        TitleAndAuthorStack(book: .init(), titleFont: .title, authorFont: .title2)
        Book.Image(title: "T")
        Book.Image(title: "")
        }.previewedInAllColorScheme
    }
}
