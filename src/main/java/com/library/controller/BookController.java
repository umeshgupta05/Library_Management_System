package com.library.controller;

import com.library.model.Book;
import com.library.service.BookService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/books")
@RequiredArgsConstructor
public class BookController {

    private final BookService bookService;

    @GetMapping("/add")
    public String showAddBookForm(Model model) {
        model.addAttribute("book", new Book());
        return "addBook";
    }

    @PostMapping("/add")
    public String addBook(@Valid @ModelAttribute("book") Book book, 
                         BindingResult result, 
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "addBook";
        }

        try {
            bookService.saveBook(book);
            redirectAttributes.addFlashAttribute("successMessage", "Book added successfully!");
            return "redirect:/books/add";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding book: " + e.getMessage());
            return "redirect:/books/add";
        }
    }

    @GetMapping("/search")
    public String showSearchForm(Model model) {
        return "searchBook";
    }

    @PostMapping("/search")
    public String searchBooks(@RequestParam("searchType") String searchType,
                             @RequestParam("searchQuery") String searchQuery,
                             Model model) {
        List<Book> books;
        
        switch (searchType) {
            case "title":
                books = bookService.searchBooksByTitle(searchQuery);
                break;
            case "author":
                books = bookService.searchBooksByAuthor(searchQuery);
                break;
            case "isbn":
                books = bookService.getBookByIsbn(searchQuery)
                        .map(List::of)
                        .orElse(List.of());
                break;
            case "category":
                books = bookService.searchBooksByCategory(searchQuery);
                break;
            default:
                books = List.of();
        }
        
        model.addAttribute("books", books);
        model.addAttribute("searchPerformed", true);
        return "searchBook";
    }

    @GetMapping("/all")
    public String getAllBooks(Model model) {
        model.addAttribute("books", bookService.getAllBooks());
        return "allBooks";
    }

    @GetMapping("/available")
    public String getAvailableBooks(Model model) {
        model.addAttribute("books", bookService.getAvailableBooks());
        return "availableBooks";
    }

    @GetMapping("/delete/{id}")
    public String deleteBook(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            bookService.deleteBook(id);
            redirectAttributes.addFlashAttribute("successMessage", "Book deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting book: " + e.getMessage());
        }
        return "redirect:/books/all";
    }
}
