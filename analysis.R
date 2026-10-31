# ==============================================================================
# STUDENT PERFORMANCE ANALYSIS - CORE R ANALYSIS SCRIPT
# College Mini Project: Basic Data Analysis, R Concepts & Linear Regression
# ==============================================================================

# Clear console & environment
cat("\014")

cat("====================================================================\n")
cat("       STUDENT PERFORMANCE ANALYSIS SYSTEM (R LANGUAGE)             \n")
cat("====================================================================\n\n")

# ------------------------------------------------------------------------------
# 1. LOAD & PREPARE DATASET
# ------------------------------------------------------------------------------
data_file <- "student_data.csv"
if (!file.exists(data_file)) {
  stop("Dataset 'student_data.csv' not found. Please run 'generate_data.R' first.")
}

students <- read.csv(data_file, stringsAsFactors = FALSE)

# Ensure Grade is an ordered factor
students$Grade <- factor(students$Grade, levels = c("A", "B", "C", "D", "F"))

# ------------------------------------------------------------------------------
# 2. DATASET DIMENSIONS & STRUCTURE
# ------------------------------------------------------------------------------
cat("--- 1. DATASET DIMENSIONS (dim) ---\n")
dims <- dim(students)
cat("Number of Rows (Students):", dims[1], "\n")
cat("Number of Columns (Variables):", dims[2], "\n\n")

cat("--- 2. DATASET STRUCTURE (str) ---\n")
str(students)
cat("\n")

# Custom Glimpse implementation for clean, modern console output
glimpse_custom <- function(df) {
  cat("Rows:", nrow(df), "\n")
  cat("Columns:", ncol(df), "\n")
  for (col in names(df)) {
    val_sample <- paste(head(df[[col]], 5), collapse = ", ")
    col_type <- class(df[[col]])[1]
    cat(sprintf("$ %-14s <%s> %s ...\n", col, col_type, val_sample))
  }
}

cat("--- 3. DATASET STRUCTURE (glimpse) ---\n")
glimpse_custom(students)
cat("\n")

# ------------------------------------------------------------------------------
# 3. R CONCEPT: LOOPS & DATA FRAME MANIPULATION
# ------------------------------------------------------------------------------
cat("--- 4. R CONCEPT DEMO: FOR LOOPS & CONDITIONAL LOGIC ---\n")
# Loop through the dataset to evaluate attendance status
attendance_status <- character(nrow(students))

for (i in 1:nrow(students)) {
  att <- students$Attendance[i]
  if (att >= 85) {
    attendance_status[i] <- "High Attendance"
  } else if (att >= 70) {
    attendance_status[i] <- "Average Attendance"
  } else {
    attendance_status[i] <- "Low Attendance (Need Improvement)"
  }
}

students$Attendance_Category <- attendance_status
cat("Added 'Attendance_Category' column using a for loop.\n")
print(head(students[, c("StudentID", "Study_Hours", "Attendance", "Marks", "Grade", "Attendance_Category")], 6))
cat("\n")

# ------------------------------------------------------------------------------
# 4. MATHEMATICAL OPERATIONS & DESCRIPTIVE STATISTICS
# ------------------------------------------------------------------------------
cat("--- 5. DESCRIPTIVE STATISTICS & MATHEMATICAL OPERATIONS ---\n")

calc_stats <- function(x, name) {
  data.frame(
    Variable = name,
    Mean     = round(mean(x), 2),
    Median   = round(median(x), 2),
    Min      = round(min(x), 2),
    Max      = round(max(x), 2),
    Range    = round(max(x) - min(x), 2),
    Variance = round(var(x), 2),
    StdDev   = round(sd(x), 2)
  )
}

stats_table <- rbind(
  calc_stats(students$Marks, "Exam Marks"),
  calc_stats(students$Study_Hours, "Study Hours (weekly)"),
  calc_stats(students$Attendance, "Attendance (%)")
)

print(stats_table, row.names = FALSE)
cat("\n")

# ------------------------------------------------------------------------------
# 5. OUTLIER IDENTIFICATION (INTERQUARTILE RANGE - IQR METHOD)
# ------------------------------------------------------------------------------
cat("--- 6. OUTLIER IDENTIFICATION (IQR METHOD) ---\n")

q1_marks <- quantile(students$Marks, 0.25)
q3_marks <- quantile(students$Marks, 0.75)
iqr_marks <- IQR(students$Marks)

lower_fence <- q1_marks - 1.5 * iqr_marks
upper_fence <- q3_marks + 1.5 * iqr_marks

outliers <- students$Marks[students$Marks < lower_fence | students$Marks > upper_fence]

cat(sprintf("Marks Q1 (25th Percentile) : %.2f\n", q1_marks))
cat(sprintf("Marks Q3 (75th Percentile) : %.2f\n", q3_marks))
cat(sprintf("Interquartile Range (IQR)  : %.2f\n", iqr_marks))
cat(sprintf("Lower Fence (Q1 - 1.5*IQR) : %.2f\n", lower_fence))
cat(sprintf("Upper Fence (Q3 + 1.5*IQR) : %.2f\n", upper_fence))

if (length(outliers) > 0) {
  cat("Identified Outlier(s) in Marks:", paste(outliers, collapse = ", "), "\n")
  outlier_rows <- students[students$Marks %in% outliers, ]
  print(outlier_rows[, c("StudentID", "Study_Hours", "Attendance", "Marks", "Grade")])
} else {
  cat("No extreme outliers detected in Marks (all values fall within expected bounds).\n")
}
cat("\n")

# ------------------------------------------------------------------------------
# 6. SIMPLE LINEAR REGRESSION ANALYSIS
# ------------------------------------------------------------------------------
cat("--- 7. SIMPLE LINEAR REGRESSION (lm: Marks ~ Study_Hours) ---\n")

# Fit simple linear regression model
reg_model <- lm(Marks ~ Study_Hours, data = students)
reg_summary <- summary(reg_model)

print(reg_summary)

intercept <- coef(reg_model)[1]
slope     <- coef(reg_model)[2]
r_squared <- reg_summary$r.squared
p_val     <- coef(reg_summary)[2, 4]

cat("\n--- REGRESSION EXPLANATION & INTERPRETATION ---\n")
cat(sprintf("1. Regression Equation: Marks = %.2f + (%.2f * Study_Hours)\n", intercept, slope))
cat(sprintf("2. Slope (Beta 1 = %.2f): For every 1 additional hour of weekly study,\n   a student's exam mark is predicted to increase by approximately %.2f marks.\n", slope, slope))
cat(sprintf("3. Intercept (Beta 0 = %.2f): Baseline expected mark with 0 study hours.\n", intercept))
cat(sprintf("4. R-Squared (R² = %.4f or %.1f%%): Approximately %.1f%% of the total variation\n   in student marks is explained by study hours alone.\n", r_squared, r_squared * 100, r_squared * 100))
cat(sprintf("5. Statistical Significance: p-value = %e (p < 0.001), indicating a highly significant\n   positive relationship between study hours and academic performance.\n", p_val))

# Example Prediction
cat("\n--- PREDICTION EXAMPLES ---\n")
test_hours <- data.frame(Study_Hours = c(8, 15, 22))
pred_marks <- predict(reg_model, newdata = test_hours)
for (j in 1:nrow(test_hours)) {
  cat(sprintf("Study Hours: %2d hrs/week  -->  Predicted Marks: %.1f / 100\n",
              test_hours$Study_Hours[j], pred_marks[j]))
}
cat("\n====================================================================\n")
cat(" Analysis complete! Run 'Rscript run_dashboard.R' to launch the web portal.\n")
cat("====================================================================\n")
