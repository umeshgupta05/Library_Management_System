package com.library.controller;

import com.library.model.Student;
import com.library.service.BookIssueService;
import com.library.service.StudentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/students")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;
    private final BookIssueService bookIssueService;

    @GetMapping("/add")
    public String showAddStudentForm(Model model) {
        model.addAttribute("student", new Student());
        return "addStudent";
    }

    @PostMapping("/add")
    public String addStudent(@Valid @ModelAttribute("student") Student student,
                            BindingResult result,
                            RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "addStudent";
        }

        try {
            studentService.saveStudent(student);
            redirectAttributes.addFlashAttribute("successMessage", "Student added successfully!");
            return "redirect:/students/add";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding student: " + e.getMessage());
            return "redirect:/students/add";
        }
    }

    @GetMapping("/view")
    public String showViewStudentForm(Model model) {
        return "viewStudentInfo";
    }

    @PostMapping("/view")
    public String viewStudent(@RequestParam("rollNumber") String rollNumber, Model model) {
        Optional<Student> studentOpt = studentService.getStudentByRollNumber(rollNumber);
        
        if (studentOpt.isPresent()) {
            Student student = studentOpt.get();
            model.addAttribute("student", student);
            model.addAttribute("bookIssues", bookIssueService.getIssuesByStudent(student));
            model.addAttribute("studentFound", true);
        } else {
            model.addAttribute("errorMessage", "Student not found with Roll Number: " + rollNumber);
            model.addAttribute("studentFound", false);
        }
        
        return "viewStudentInfo";
    }

    @GetMapping("/all")
    public String getAllStudents(Model model) {
        model.addAttribute("students", studentService.getAllStudents());
        return "allStudents";
    }

    @GetMapping("/delete/{id}")
    public String deleteStudent(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            studentService.deleteStudent(id);
            redirectAttributes.addFlashAttribute("successMessage", "Student deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting student: " + e.getMessage());
        }
        return "redirect:/students/all";
    }
}
