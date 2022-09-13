//
//  SearchableBookList.swift
//  SearchListExample
//
//  Created by David on 9/13/22.
//  From: https://peterfriese.dev/posts/swiftui-listview-part2/
//  Building Dynamic Lists in SwiftUI
//  The Ultimate Guide to SwiftUI List Views - Part 2

import SwiftUI
import Combine

struct Book: Identifiable {
  var id = UUID()
  var title: String
  var author: String
  var isbn: String
  var pages: Int
  var isRead: Bool = false
}

extension Book {
  static let samples = [
    Book(title: "Changer", author: "Matt Gemmell", isbn: "9781916265202", pages: 476),
    Book(title: "SwiftUI for Absolute Beginners", author: "Jayant Varma", isbn: "9781484255155", pages: 200),
    Book(title: "Why we sleep", author: "Matthew Walker", isbn: "9780141983769", pages: 368),
    Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", isbn: "9780671461492", pages: 216)
  ]
}

private class BooksViewModel: ObservableObject {
  @Published var books: [Book] = Book.samples
}

//class SearchableBooksViewModel: ObservableObject {
//    @Published private var originalBooks = Book.samples
//    @Published var books = [Book]()       // empty initially
//    @Published var searchTerm: String = ""
//
//    init() {
//        Publishers.CombineLatest($originalBooks, $searchTerm)       // 1
//            .map { books, searchTerm in                             // 2
//                books.filter { book in                              // 3
//                    searchTerm.isEmpty ? true : (book.title.matches(searchTerm) || book.author.matches(searchTerm))
//                }
//            }
//            .assign(to: &$books)
//    }
//}

class SearchableBooksViewModel: ObservableObject {
    @Published private var originalBooks = Book.samples
    @Published var books = [Book]()         // empty initially
    @Published var searchTerm: String = ""
    var myReadingList = [Book]()            // empty initially
    
    init() {
        books = originalBooks
    }
    
    func addToReadingList(_ book: Book) {
        // take the give book and add it to my reading list
        myReadingList.append(book)
    }
}

struct SearchableBooksListView: View {
    // needs a NavView for Search field to show up
  @StateObject var viewModel = SearchableBooksViewModel()
  var body: some View {
    List(viewModel.books) { book in
      SearchableBookRowView(book: book)
    }
    .searchable(text: $viewModel.searchTerm)
  }
}

struct SearchableBookRowView: View {
  var book: Book
  
  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text("by \(book.author)")
          .font(.subheadline)
        Text("\(book.pages) pages")
          .font(.subheadline)
      }
      Spacer()
        Button("Add") {
            // I've found my book - add to my reading list and clear search
            viewModel.addToReadingList(book)
            viewModel.searchTerm = ""           // blank search term
            viewModel.books = originalBooks     // repopulate with initial list
        }
    }
  }
}

struct SearchableBookList_Previews: PreviewProvider {
    static var previews: some View {
        SearchableBooksListView()
    }
}
