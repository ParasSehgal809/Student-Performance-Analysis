# ==============================================================================
# STUDENT PERFORMANCE ANALYSIS - DATA GENERATOR
# Generates 30 fictional student records with realistic academic attributes
# ==============================================================================

# Ensure reproducibility
set.seed(101)

n <- 30

# Generate fictional student IDs
student_ids <- sprintf("STU%03d", 1:n)

# Generate Study Hours per week (between 4 and 28 hours)
# Realistic distribution with some variation
study_hours <- round(runif(n, min = 5, max = 28), 1)

# Generate Attendance (%) - positively correlated with study hours
attendance <- round(pmin(99, pmax(48, 45 + 1.8 * study_hours + rnorm(n, mean = 0, sd = 4))))

# Generate Exam Marks (out of 100) - strongly correlated with study hours & attendance
# Formula: baseline + factor*hours + noise
marks <- round(pmin(98, pmax(32, 22 + 2.5 * study_hours + 0.15 * attendance + rnorm(n, mean = 0, sd = 3.5))))

# Create initial Data Frame
students <- data.frame(
  StudentID   = student_ids,
  Study_Hours = study_hours,
  Attendance  = attendance,
  Marks       = marks,
  Grade       = character(n),
  stringsAsFactors = FALSE
)

# ------------------------------------------------------------------------------
# R CONCEPT: LOOPS
# Assign letter grades based on marks using a standard for loop
# ------------------------------------------------------------------------------
for (i in 1:nrow(students)) {
  m <- students$Marks[i]
  if (m >= 85) {
    students$Grade[i] <- "A"
  } else if (m >= 70) {
    students$Grade[i] <- "B"
  } else if (m >= 55) {
    students$Grade[i] <- "C"
  } else if (m >= 40) {
    students$Grade[i] <- "D"
  } else {
    students$Grade[i] <- "F"
  }
}

# Save generated data to CSV file
write.csv(students, "student_data.csv", row.names = FALSE)
cat("Successfully generated 30 fictional student records in 'student_data.csv'.\n")
print(head(students, 10))
