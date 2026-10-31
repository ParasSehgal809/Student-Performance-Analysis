# 🎓 Student Performance Analysis System (R Language)

A lightweight, interactive **Student Performance Analysis System** developed for an R programming college mini project. This system analyzes academic marks across 30 fictional student records, identifies key factors influencing performance, explores core R programming concepts, and applies Linear Regression to predict student marks.

---

## 🌟 Key Features

1. **Attractive Login Authentication**
   - Clean, modern, centered login interface.
   - Username and password input validation with helpful error alerts.
   - Demo credentials displayed directly on the screen for instant grading and evaluation.
   - Secure session state with a one-click logout button.

2. **Executive Summary Dashboard**
   - **Total Students:** 30 fictional records.
   - **Average Marks:** Mean exam performance out of 100.
   - **Marks Range:** Highest and lowest exam scores.
   - **Average Attendance:** Percentage tracking with standard deviation.
   - Visual quick-preview bar chart and initial scatter plot.

3. **Core Data Analysis & R Concepts**
   - **`dim()`**: Displays exact matrix dimensions (30 rows, 5 columns).
   - **`str()`**: Displays internal R data structures, types, and factor levels.
   - **`glimpse()`**: Concise tidyverse-style column overview with data types and sample values.
   - **R Loops**: A `for` loop that iterates over each student to compute letter grades and attendance categories.
   - **Mathematical Operations**: Computes Mean, Median, Min, Max, Range, Variance, and Standard Deviation.
   - **Outlier Detection**: Interquartile Range (IQR) method calculating $Q_1$, $Q_3$, $\text{IQR} = Q_3 - Q_1$, Lower Fence ($Q_1 - 1.5 \times \text{IQR}$), and Upper Fence ($Q_3 + 1.5 \times \text{IQR}$).

4. **Exploratory Data Visualizations**
   - **Histogram of Student Marks**: Frequency distribution with interactive bin adjustments and Mean/Median reference lines.
   - **Boxplot of Student Marks**: Horizontal boxplot highlighting quartiles, spread, and outlier points.
   - **Scatter Plot (Study Hours vs. Marks)**: Demonstrates the strong positive relationship with fitted linear regression trendline.
   - **Bar Chart of Student Performance**: Color-coded distribution of letter grades (A, B, C, D, F).

5. **Linear Regression & Interactive Predictor**
   - Fits simple linear regression model using `lm(Marks ~ Study_Hours)`.
   - Displays full regression coefficients, $t$-statistics, $p$-values, and $R^2$ determination coefficient.
   - Plain-English interpretation of slope and intercept.
   - **Interactive Mark Predictor**: Allows users to move a slider of weekly study hours to instantly calculate the predicted exam mark and letter grade.

6. **Dataset Explorer**
   - Interactive table of all 30 fictional student records.
   - Filter by letter grade (A, B, C, D, F).
   - One-click CSV export button.

---

## 🔑 Demo Login Credentials

| Role | Username | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Administrator / Evaluator** | `admin` | `admin123` | Full Dashboard & Analysis Access |

*(These credentials are also displayed directly on the login screen for convenience).*

---

## 📂 Project Structure

```text
student_performance_analysis/
├── app.R               # Main R Shiny Web Application (Login + Dashboard + Predictor)
├── analysis.R          # Standalone R script demonstrating all required console outputs & stats
├── generate_data.R     # Script to generate 30 fictional student records with realistic correlations
├── run_dashboard.R     # Convenient one-click launcher that starts Shiny and opens the browser
├── student_data.csv    # The generated dataset containing 30 fictional student records
├── FLOWCHART.md        # Architecture & system flow diagram matching college project rubric
├── docs/
│   └── flowchart.html  # Interactive visual HTML flowchart viewable in any browser
└── README.md           # Project documentation and guide
```

---

## 🚀 How to Run the Project from VS Code Terminal

### Prerequisites
Make sure **R** is installed on your computer.

### Step 1: Open VS Code Terminal
Open your project directory in VS Code:
```bash
cd /Users/parassehgal/.gemini/antigravity/scratch/student_performance_analysis
```

### Step 2: Install Required R Packages (One-Time)
Run this command in the terminal to ensure `shiny` is installed:
```bash
Rscript -e 'if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny", repos = "https://cloud.r-project.org")'
```

### Step 3: Run the Standalone Analysis Script
To view all basic data analysis, dimensions (`dim`), structure (`str`, `glimpse`), loops, statistical operations, outlier checks, and regression summary in your terminal:
```bash
Rscript analysis.R
```

### Step 4: Launch the Shiny Web Application
To start the interactive web application and open it in your browser:
```bash
Rscript run_dashboard.R
```
The application will launch and open automatically at:
👉 **`http://127.0.0.1:5000`**

Sign in with `admin` and `admin123` to explore the dashboard!

To stop the web server when finished, press `Ctrl + C` in the terminal.

---

## 📊 Dataset Schema (Fictional Students)

| Column | Type | Description |
| :--- | :--- | :--- |
| `StudentID` | Character | Unique identifier (`STU001` - `STU030`) |
| `Study_Hours` | Numeric | Weekly independent study hours (e.g. 5.9 - 27.0 hrs) |
| `Attendance` | Integer | Class attendance percentage (e.g. 52% - 94%) |
| `Marks` | Integer | Final exam score out of 100 (e.g. 47 - 98) |
| `Grade` | Factor | Letter grade assigned via R loop: **A** (≥85), **B** (70–84), **C** (55–69), **D** (40–54), **F** (<40) |

---

## 🔬 Mathematical Formulas Used

- **Arithmetic Mean:**
  $$\bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i$$
- **Standard Deviation:**
  $$s = \sqrt{\frac{1}{n-1}\sum_{i=1}^n (x_i - \bar{x})^2}$$
- **Simple Linear Regression:**
  $$\text{Marks} = \beta_0 + \beta_1 \times \text{Study\_Hours}$$
- **Coefficient of Determination ($R^2$):**
  $$R^2 = 1 - \frac{\text{SS}_{\text{res}}}{\text{SS}_{\text{tot}}}$$
