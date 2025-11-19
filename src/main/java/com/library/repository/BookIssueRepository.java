package com.library.repository;

import com.library.model.BookIssue;
import com.library.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookIssueRepository extends JpaRepository<BookIssue, Long> {
    
    List<BookIssue> findByStudent(Student student);
    
    List<BookIssue> findByStatus(String status);
    
    List<BookIssue> findByStudentAndStatus(Student student, String status);
}
