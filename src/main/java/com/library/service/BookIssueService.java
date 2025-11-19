package com.library.service;

import com.library.model.Book;
import com.library.model.BookIssue;
import com.library.model.Student;
import com.library.repository.BookIssueRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookIssueService {

    private final BookIssueRepository bookIssueRepository;
    private final BookService bookService;

    private static final double FINE_PER_DAY = 5.0;

    public List<BookIssue> getAllIssues() {
        return bookIssueRepository.findAll();
    }

    public Optional<BookIssue> getIssueById(Long id) {
        return bookIssueRepository.findById(id);
    }

    public List<BookIssue> getIssuesByStudent(Student student) {
        return bookIssueRepository.findByStudent(student);
    }

    public List<BookIssue> getIssuesByStatus(String status) {
        return bookIssueRepository.findByStatus(status);
    }

    public List<BookIssue> getActiveIssuesByStudent(Student student) {
        return bookIssueRepository.findByStudentAndStatus(student, "ISSUED");
    }

    @Transactional
    public BookIssue issueBook(Book book, Student student) {
        if (bookService.decreaseAvailableQuantity(book.getId())) {
            BookIssue issue = new BookIssue();
            issue.setBook(book);
            issue.setStudent(student);
            return bookIssueRepository.save(issue);
        }
        return null;
    }

    @Transactional
    public BookIssue returnBook(Long issueId) {
        Optional<BookIssue> issueOpt = bookIssueRepository.findById(issueId);
        if (issueOpt.isPresent()) {
            BookIssue issue = issueOpt.get();
            issue.setReturnDate(LocalDate.now());
            issue.setStatus("RETURNED");
            
            // Calculate fine if overdue
            if (issue.getReturnDate().isAfter(issue.getDueDate())) {
                long daysOverdue = ChronoUnit.DAYS.between(issue.getDueDate(), issue.getReturnDate());
                issue.setFine(daysOverdue * FINE_PER_DAY);
            }
            
            // Increase available quantity
            bookService.increaseAvailableQuantity(issue.getBook().getId());
            
            return bookIssueRepository.save(issue);
        }
        return null;
    }

    public void updateOverdueStatus() {
        List<BookIssue> activeIssues = bookIssueRepository.findByStatus("ISSUED");
        LocalDate today = LocalDate.now();
        
        for (BookIssue issue : activeIssues) {
            if (today.isAfter(issue.getDueDate())) {
                issue.setStatus("OVERDUE");
                bookIssueRepository.save(issue);
            }
        }
    }
}
