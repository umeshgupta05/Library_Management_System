package com.library.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "books")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Book title is required")
    @Column(nullable = false)
    private String title;

    @NotBlank(message = "Author name is required")
    @Column(nullable = false)
    private String author;

    @NotBlank(message = "ISBN is required")
    @Column(unique = true, nullable = false)
    private String isbn;

    @NotBlank(message = "Publisher is required")
    private String publisher;

    @NotNull(message = "Publication year is required")
    private Integer publicationYear;

    @NotBlank(message = "Category is required")
    private String category;

    @NotNull(message = "Quantity is required")
    private Integer quantity;

    @NotNull(message = "Available quantity is required")
    private Integer availableQuantity;

    private String description;

    @Column(name = "created_date")
    private LocalDate createdDate;

    @PrePersist
    protected void onCreate() {
        createdDate = LocalDate.now();
        if (availableQuantity == null) {
            availableQuantity = quantity;
        }
    }
}
