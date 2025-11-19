package com.library.controller;

import com.library.model.Book;
import com.library.model.BookIssue;
import com.library.model.Student;
import com.library.service.BookIssueService;
import com.library.service.BookService;
import com.library.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/issues")
@RequiredArgsConstructor
public class BookIssueController {

    private final BookIssueService bookIssueService;
    private final BookService bookService;
    private final StudentService studentService;

    @GetMapping("/issue")
    public String showIssueBookForm(Model model) {
        model.addAttribute("books", bookService.getAvailableBooks());
        return "issueBook";
    }

    @PostMapping("/issue")
    public String issueBook(@RequestParam("bookId") Long bookId,
                           @RequestParam("rollNumber") String rollNumber,
                           RedirectAttributes redirectAttributes) {
        try {
            Optional<Book> bookOpt = bookService.getBookById(bookId);
            Optional<Student> studentOpt = studentService.getStudentByRollNumber(rollNumber);

            if (bookOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Book not found!");
                return "redirect:/issues/issue";
            }

            if (studentOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Student not found with Roll Number: " + rollNumber);
                return "redirect:/issues/issue";
            }

            Book book = bookOpt.get();
            Student student = studentOpt.get();

            if (book.getAvailableQuantity() <= 0) {
                redirectAttributes.addFlashAttribute("errorMessage", "Book is not available!");
                return "redirect:/issues/issue";
            }

            BookIssue issue = bookIssueService.issueBook(book, student);
            if (issue != null) {
                redirectAttributes.addFlashAttribute("successMessage", 
                    "Book issued successfully! Due Date: " + issue.getDueDate());
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Failed to issue book!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error issuing book: " + e.getMessage());
        }

        return "redirect:/issues/issue";
    }

    @GetMapping("/return")
    public String showReturnBookForm(Model model) {
        model.addAttribute("activeIssues", bookIssueService.getIssuesByStatus("ISSUED"));
        return "returnBook";
    }

    @PostMapping("/return")
    public String returnBook(@RequestParam("issueId") Long issueId,
                            RedirectAttributes redirectAttributes) {
        try {
            BookIssue returnedIssue = bookIssueService.returnBook(issueId);
            if (returnedIssue != null) {
                String message = "Book returned successfully!";
                if (returnedIssue.getFine() > 0) {
                    message += " Fine: ₹" + returnedIssue.getFine();
                }
                redirectAttributes.addFlashAttribute("successMessage", message);
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Failed to return book!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error returning book: " + e.getMessage());
        }

        return "redirect:/issues/return";
    }

    @GetMapping("/all")
    public String getAllIssues(Model model) {
        model.addAttribute("issues", bookIssueService.getAllIssues());
        return "allIssues";
    }

    @GetMapping("/overdue")
    public String getOverdueIssues(Model model) {
        bookIssueService.updateOverdueStatus();
        model.addAttribute("issues", bookIssueService.getIssuesByStatus("OVERDUE"));
        return "overdueIssues";
    }
}
