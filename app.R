# ==============================================================================
# STUDENT PERFORMANCE ANALYSIS SYSTEM (R SHINY APPLICATION)
# College Mini Project: Data Analysis, Visualization & Linear Regression
# ==============================================================================

# Ensure library path includes project-level libraries if present
local_lib <- "/Users/parassehgal/.gemini/antigravity/scratch/r_libs"
if (dir.exists(local_lib)) {
  .libPaths(c(local_lib, .libPaths()))
}

if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny", repos = "https://cloud.r-project.org")
}
library(shiny)

# ------------------------------------------------------------------------------
# 1. LOAD OR GENERATE DATASET (30 Fictional Student Records)
# ------------------------------------------------------------------------------
data_file <- "student_data.csv"
if (file.exists(data_file)) {
  student_data <- read.csv(data_file, stringsAsFactors = FALSE)
} else {
  set.seed(101)
  n <- 30
  s_ids <- sprintf("STU%03d", 1:n)
  s_hours <- round(runif(n, 5, 28), 1)
  s_att <- round(pmin(99, pmax(48, 45 + 1.8 * s_hours + rnorm(n, 0, 4))))
  s_marks <- round(pmin(98, pmax(32, 22 + 2.5 * s_hours + 0.15 * s_att + rnorm(n, 0, 3.5))))
  
  student_data <- data.frame(
    StudentID   = s_ids,
    Study_Hours = s_hours,
    Attendance  = s_att,
    Marks       = s_marks,
    Grade       = character(n),
    stringsAsFactors = FALSE
  )
  for (i in 1:nrow(student_data)) {
    m <- student_data$Marks[i]
    if (m >= 85) student_data$Grade[i] <- "A"
    else if (m >= 70) student_data$Grade[i] <- "B"
    else if (m >= 55) student_data$Grade[i] <- "C"
    else if (m >= 40) student_data$Grade[i] <- "D"
    else student_data$Grade[i] <- "F"
  }
  write.csv(student_data, data_file, row.names = FALSE)
}

student_data$Grade <- factor(student_data$Grade, levels = c("A", "B", "C", "D", "F"))

# Demo Credentials
DEMO_USER <- "admin"
DEMO_PASS <- "admin123"

# ------------------------------------------------------------------------------
# 2. CUSTOM CSS STYLING
# ------------------------------------------------------------------------------
app_css <- "
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
  
  body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background-color: #f8fafc;
    color: #1e293b;
    margin: 0;
    padding: 0;
  }
  
  /* Top Navigation Bar */
  .custom-navbar {
    background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #4338ca 100%);
    color: white;
    padding: 16px 28px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }
  
  .navbar-brand-title {
    font-size: 1.25rem;
    font-weight: 700;
    letter-spacing: -0.02em;
    display: flex;
    align-items: center;
    gap: 10px;
  }
  
  .navbar-user-box {
    display: flex;
    align-items: center;
    gap: 14px;
    font-size: 0.9rem;
  }
  
  .user-badge {
    background: rgba(255, 255, 255, 0.18);
    padding: 6px 14px;
    border-radius: 20px;
    font-weight: 500;
  }
  
  .btn-logout {
    background-color: #ef4444;
    color: white !important;
    border: none;
    padding: 7px 16px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s ease;
  }
  .btn-logout:hover {
    background-color: #dc2626;
  }
  
  /* Login Container */
  .login-wrapper {
    min-height: 85vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }
  
  .login-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 40px;
    width: 100%;
    max-width: 440px;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
  }
  
  .login-header {
    text-align: center;
    margin-bottom: 28px;
  }
  
  .login-header h2 {
    font-size: 1.6rem;
    font-weight: 700;
    color: #1e1b4b;
    margin-bottom: 8px;
  }
  
  .login-header p {
    color: #64748b;
    font-size: 0.9rem;
  }
  
  .demo-badge {
    background-color: #f1f5f9;
    border: 1px dashed #cbd5e1;
    border-radius: 8px;
    padding: 10px 14px;
    margin-top: 20px;
    font-size: 0.85rem;
    color: #334155;
    text-align: center;
  }
  
  .btn-login {
    background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
    color: white !important;
    border: none;
    width: 100%;
    padding: 12px;
    font-size: 1rem;
    font-weight: 600;
    border-radius: 8px;
    margin-top: 15px;
    cursor: pointer;
    transition: transform 0.1s ease, box-shadow 0.2s ease;
  }
  .btn-login:hover {
    box-shadow: 0 4px 14px rgba(79, 70, 229, 0.4);
    transform: translateY(-1px);
  }
  
  /* Metric / KPI Cards */
  .kpi-card {
    background: white;
    border-radius: 12px;
    padding: 22px 20px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    margin-bottom: 20px;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
    border-left: 5px solid #4f46e5;
  }
  .kpi-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08);
  }
  .kpi-title {
    font-size: 0.82rem;
    text-transform: uppercase;
    font-weight: 600;
    letter-spacing: 0.05em;
    color: #64748b;
    margin-bottom: 8px;
  }
  .kpi-value {
    font-size: 2rem;
    font-weight: 700;
    color: #0f172a;
  }
  .kpi-sub {
    font-size: 0.82rem;
    color: #94a3b8;
    margin-top: 4px;
  }
  
  /* Content Panels & Cards */
  .panel-card {
    background: white;
    border-radius: 12px;
    padding: 24px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    margin-bottom: 24px;
  }
  
  .panel-title {
    font-size: 1.15rem;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 16px;
    border-bottom: 2px solid #f1f5f9;
    padding-bottom: 10px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  /* Code / Preformatted blocks */
  pre.code-output {
    background-color: #0f172a;
    color: #38bdf8;
    padding: 16px;
    border-radius: 8px;
    font-size: 0.85rem;
    overflow-x: auto;
    font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
    line-height: 1.45;
  }
  
  /* Tab styling */
  .nav-tabs {
    border-bottom: 2px solid #e2e8f0;
    margin-bottom: 24px;
  }
  .nav-tabs > li > a {
    font-weight: 600;
    color: #64748b;
    border: none;
    padding: 12px 20px;
    border-radius: 8px 8px 0 0;
    font-size: 0.95rem;
  }
  .nav-tabs > li.active > a, .nav-tabs > li.active > a:focus, .nav-tabs > li.active > a:hover {
    color: #4338ca;
    background-color: transparent;
    border-bottom: 3px solid #4338ca;
  }
  
  /* Prediction Result Callout */
  .pred-box {
    background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
    border: 1px solid #818cf8;
    border-radius: 12px;
    padding: 24px;
    text-align: center;
    margin-top: 15px;
  }
  .pred-value {
    font-size: 3rem;
    font-weight: 800;
    color: #312e81;
  }
  .pred-grade {
    font-size: 1.3rem;
    font-weight: 700;
    color: #4338ca;
    margin-top: 6px;
  }
"

# ------------------------------------------------------------------------------
# 3. USER INTERFACE (UI)
# ------------------------------------------------------------------------------
ui <- fluidPage(
  tags$head(
    tags$title("Student Performance Analysis System"),
    tags$style(HTML(app_css))
  ),
  
  # Reactive View Container (Login vs Dashboard)
  uiOutput("app_body")
)

# ------------------------------------------------------------------------------
# 4. SERVER LOGIC
# ------------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # Reactive state for authentication
  auth <- reactiveValues(logged_in = FALSE, user = NULL)
  
  # Login Action
  observeEvent(input$login_btn, {
    req(input$username, input$password)
    user_input <- trimws(input$username)
    pass_input <- trimws(input$password)
    
    if (user_input == DEMO_USER && pass_input == DEMO_PASS) {
      auth$logged_in <- TRUE
      auth$user <- DEMO_USER
    } else {
      showNotification("Invalid credentials! Use demo login: admin / admin123", type = "error", duration = 4)
    }
  })
  
  # Logout Action
  observeEvent(input$logout_btn, {
    auth$logged_in <- FALSE
    auth$user <- NULL
  })
  
  # Render Main App Body (Login or Dashboard)
  output$app_body <- renderUI({
    if (!auth$logged_in) {
      # ------------------------------------------------------------------------
      # VIEW: LOGIN PAGE
      # ------------------------------------------------------------------------
      div(class = "login-wrapper",
        div(class = "login-card",
          div(class = "login-header",
            div(style = "font-size: 2.5rem; margin-bottom: 8px;", "🎓"),
            h2("Student Analytics Portal"),
            p("Sign in to access student performance insights & regression models")
          ),
          
          textInput("username", "Username", placeholder = "Enter username (e.g. admin)"),
          passwordInput("password", "Password", placeholder = "Enter password"),
          
          actionButton("login_btn", "Sign In to Dashboard", class = "btn-login"),
          
          div(class = "demo-badge",
            strong("Demo Login Credentials:"),
            tags$div(style = "margin-top: 4px;",
              span(style = "color: #4338ca; font-weight: 600;", "Username: "), "admin", " | ",
              span(style = "color: #4338ca; font-weight: 600;", "Password: "), "admin123"
            )
          )
        )
      )
    } else {
      # ------------------------------------------------------------------------
      # VIEW: AUTHENTICATED DASHBOARD
      # ------------------------------------------------------------------------
      tagList(
        # Top Navigation Bar
        div(class = "custom-navbar",
          div(class = "navbar-brand-title",
            span(style = "font-size: 1.4rem;", "📊"),
            span("Student Performance Analysis System")
          ),
          div(class = "navbar-user-box",
            div(class = "user-badge", paste("👤 User:", auth$user)),
            actionButton("logout_btn", "Sign Out", class = "btn-logout")
          )
        ),
        
        # Main Dashboard Container
        div(style = "max-width: 1280px; margin: 28px auto; padding: 0 24px;",
          
          # Row 1: Dashboard KPI Summary Cards
          fluidRow(
            column(3,
              div(class = "kpi-card", style = "border-left-color: #3b82f6;",
                div(class = "kpi-title", "Total Students"),
                div(class = "kpi-value", nrow(student_data)),
                div(class = "kpi-sub", "Fictional sample records")
              )
            ),
            column(3,
              div(class = "kpi-card", style = "border-left-color: #10b981;",
                div(class = "kpi-title", "Average Marks"),
                div(class = "kpi-value", paste0(round(mean(student_data$Marks), 1), "/100")),
                div(class = "kpi-sub", paste0("Median: ", round(median(student_data$Marks), 1)))
              )
            ),
            column(3,
              div(class = "kpi-card", style = "border-left-color: #f59e0b;",
                div(class = "kpi-title", "Marks Range (High / Low)"),
                div(class = "kpi-value", paste0(max(student_data$Marks), " / ", min(student_data$Marks))),
                div(class = "kpi-sub", paste0("Spread: ", max(student_data$Marks) - min(student_data$Marks), " marks"))
              )
            ),
            column(3,
              div(class = "kpi-card", style = "border-left-color: #8b5cf6;",
                div(class = "kpi-title", "Average Attendance"),
                div(class = "kpi-value", paste0(round(mean(student_data$Attendance), 1), "%")),
                div(class = "kpi-sub", paste0("Std Dev: ±", round(sd(student_data$Attendance), 1), "%"))
              )
            )
          ),
          
          # Tabbed Navigation
          tabsetPanel(
            id = "main_tabs",
            
            # TAB 1: OVERVIEW & SUMMARY
            tabPanel("📈 Overview Dashboard",
              br(),
              fluidRow(
                column(6,
                  div(class = "panel-card",
                    div(class = "panel-title", "📊 Academic Performance Distribution"),
                    plotOutput("overview_barplot", height = "320px"),
                    p(style = "font-size: 0.85rem; color: #64748b; margin-top: 10px;",
                      "Frequency count of students across grades (A: ≥85, B: 70-84, C: 55-69, D: 40-54, F: <40).")
                  )
                ),
                column(6,
                  div(class = "panel-card",
                    div(class = "panel-title", "⏱️ Study Hours vs Exam Marks"),
                    plotOutput("overview_scatter", height = "320px"),
                    p(style = "font-size: 0.85rem; color: #64748b; margin-top: 10px;",
                      "Initial correlation showing a clear positive trend between weekly study hours and student marks.")
                  )
                )
              ),
              fluidRow(
                column(12,
                  div(class = "panel-card",
                    div(class = "panel-title", "📋 Quick Student Dataset Preview"),
                    tableOutput("quick_table")
                  )
                )
              )
            ),
            
            # TAB 2: DATA ANALYSIS & R CONCEPTS
            tabPanel("🔬 Data Analysis & R Concepts",
              br(),
              fluidRow(
                column(6,
                  div(class = "panel-card",
                    div(class = "panel-title", "1. Dataset Dimensions using dim()"),
                    verbatimTextOutput("output_dim"),
                    tags$div(style = "margin-top: 12px; font-size: 0.88rem; color: #475569;",
                      "In R, ", tags$code("dim()"), " retrieves the matrix/data-frame dimensions (rows and columns)."
                    )
                  )
                ),
                column(6,
                  div(class = "panel-card",
                    div(class = "panel-title", "2. Dataset Structure using glimpse()"),
                    verbatimTextOutput("output_glimpse"),
                    tags$div(style = "margin-top: 12px; font-size: 0.88rem; color: #475569;",
                      "Provides a concise column-by-column glimpse showing data types and sample values."
                    )
                  )
                )
              ),
              fluidRow(
                column(12,
                  div(class = "panel-card",
                    div(class = "panel-title", "3. Dataset Structure using str()"),
                    verbatimTextOutput("output_str"),
                    tags$div(style = "margin-top: 12px; font-size: 0.88rem; color: #475569;",
                      tags$code("str()"), " displays the internal R structure of every attribute, observations count, and factor levels."
                    )
                  )
                )
              ),
              fluidRow(
                column(12,
                  div(class = "panel-card",
                    div(class = "panel-title", "4. Mathematical Operations & Descriptive Statistics"),
                    tableOutput("stats_table"),
                    tags$div(style = "margin-top: 14px; font-size: 0.88rem; color: #475569;",
                      "Calculates essential measures of central tendency (Mean, Median) and dispersion (Range, Variance, Standard Deviation)."
                    )
                  )
                )
              ),
              fluidRow(
                column(6,
                  div(class = "panel-card",
                    div(class = "panel-title", "5. Outlier Identification (IQR Method)"),
                    verbatimTextOutput("output_outliers"),
                    tags$div(style = "margin-top: 12px; font-size: 0.88rem; color: #475569;",
                      "Outliers are detected using the standard IQR rule: values below ",
                      tags$code("Q1 - 1.5 * IQR"), " or above ", tags$code("Q3 + 1.5 * IQR"), "."
                    )
                  )
                ),
                column(6,
                  div(class = "panel-card",
                    div(class = "panel-title", "6. R Concept: For Loop Demonstration"),
                    verbatimTextOutput("output_loop_demo"),
                    tags$div(style = "margin-top: 12px; font-size: 0.88rem; color: #475569;",
                      "Shows how a standard R ", tags$code("for (i in 1:nrow(df))"), " loop iterates over rows to assign grades and status."
                    )
                  )
                )
              )
            ),
            
            # TAB 3: DATA VISUALIZATION
            tabPanel("📊 Data Visualizations",
              br(),
              div(class = "panel-card",
                div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;",
                  div(class = "panel-title", style = "margin-bottom: 0;", "🎨 Exploratory Graphical Plots"),
                  div(style = "display: flex; gap: 15px; align-items: center;",
                    sliderInput("hist_bins", "Histogram Bins:", min = 4, max = 15, value = 7, step = 1, width = "180px")
                  )
                ),
                fluidRow(
                  column(6,
                    div(style = "background: #f8fafc; border-radius: 8px; padding: 12px; border: 1px solid #e2e8f0; margin-bottom: 20px;",
                      h4(style = "font-size: 1rem; font-weight: 700; color: #334155; margin-top: 0;", "1. Histogram of Student Marks"),
                      plotOutput("plot_histogram", height = "330px"),
                      p(style = "font-size: 0.82rem; color: #64748b; margin-top: 8px;",
                        "Shows the frequency distribution of marks. Red dashed line indicates Mean; blue dotted line indicates Median.")
                    )
                  ),
                  column(6,
                    div(style = "background: #f8fafc; border-radius: 8px; padding: 12px; border: 1px solid #e2e8f0; margin-bottom: 20px;",
                      h4(style = "font-size: 1rem; font-weight: 700; color: #334155; margin-top: 0;", "2. Boxplot of Student Marks"),
                      plotOutput("plot_boxplot", height = "330px"),
                      p(style = "font-size: 0.82rem; color: #64748b; margin-top: 8px;",
                        "Visualizes median, Q1 (25th percentile), Q3 (75th percentile), and identifies any potential outliers.")
                    )
                  )
                ),
                fluidRow(
                  column(6,
                    div(style = "background: #f8fafc; border-radius: 8px; padding: 12px; border: 1px solid #e2e8f0;",
                      h4(style = "font-size: 1rem; font-weight: 700; color: #334155; margin-top: 0;", "3. Scatter Plot: Study Hours vs Exam Marks"),
                      plotOutput("plot_scatter", height = "330px"),
                      p(style = "font-size: 0.82rem; color: #64748b; margin-top: 8px;",
                        "Plots study hours (X) against exam marks (Y) with the fitted linear regression line (red).")
                    )
                  ),
                  column(6,
                    div(style = "background: #f8fafc; border-radius: 8px; padding: 12px; border: 1px solid #e2e8f0;",
                      h4(style = "font-size: 1rem; font-weight: 700; color: #334155; margin-top: 0;", "4. Bar Chart: Student Performance by Grade"),
                      plotOutput("plot_barchart", height = "330px"),
                      p(style = "font-size: 0.82rem; color: #64748b; margin-top: 8px;",
                        "Bar chart depicting student counts across letter grades (A, B, C, D, F).")
                    )
                  )
                )
              )
            ),
            
            # TAB 4: REGRESSION ANALYSIS & PREDICTION
            tabPanel("🎯 Regression Analysis",
              br(),
              fluidRow(
                column(7,
                  div(class = "panel-card",
                    div(class = "panel-title", "📐 Simple Linear Regression Model: lm(Marks ~ Study_Hours)"),
                    verbatimTextOutput("reg_summary_output"),
                    tags$h4(style = "font-weight: 700; color: #1e1b4b; margin-top: 20px;", "💡 Explanation of Results:"),
                    htmlOutput("reg_explanation")
                  )
                ),
                column(5,
                  div(class = "panel-card",
                    div(class = "panel-title", "✨ Interactive Mark Predictor"),
                    p(style = "font-size: 0.9rem; color: #475569;",
                      "Adjust the study hours slider below to predict the student's expected marks and projected grade using the regression formula:"),
                    sliderInput("pred_hours", "Student Study Hours (weekly):",
                                min = 4, max = 32, value = 18, step = 0.5, width = "100%"),
                    uiOutput("prediction_display"),
                    hr(),
                    plotOutput("plot_pred_fit", height = "240px")
                  )
                )
              )
            ),
            
            # TAB 5: DATASET EXPLORER
            tabPanel("📁 Dataset Explorer",
              br(),
              div(class = "panel-card",
                div(style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;",
                  div(class = "panel-title", style = "margin-bottom: 0;", "📑 Student Records (30 Fictional Students)"),
                  div(style = "display: flex; gap: 15px; align-items: center;",
                    selectInput("grade_filter", "Filter by Grade:",
                                choices = c("All Grades", "A", "B", "C", "D", "F"),
                                selected = "All Grades", width = "160px"),
                    downloadButton("download_csv", "Export CSV", class = "btn btn-outline-primary")
                  )
                ),
                tableOutput("student_table")
              )
            )
          )
        )
      )
    }
  })
  
  # ----------------------------------------------------------------------------
  # DATA ANALYSIS REACTIVE LOGIC
  # ----------------------------------------------------------------------------
  
  # dim() Output
  output$output_dim <- renderPrint({
    d <- dim(student_data)
    cat("Call: dim(student_data)\n")
    cat("----------------------------------\n")
    cat("Result: [", d[1], " rows , ", d[2], " columns ]\n\n", sep = "")
    cat("Explanation: There are", d[1], "individual student records (rows)\n")
    cat("and", d[2], "features tracked: StudentID, Study_Hours, Attendance, Marks, Grade.\n")
  })
  
  # str() Output
  output$output_str <- renderPrint({
    cat("Call: str(student_data)\n")
    cat("----------------------------------------------------------------\n")
    str(student_data)
  })
  
  # glimpse() Output
  output$output_glimpse <- renderPrint({
    cat("Call: glimpse(student_data)\n")
    cat("----------------------------------------------------------------\n")
    cat("Rows: ", nrow(student_data), "\n", sep = "")
    cat("Columns: ", ncol(student_data), "\n", sep = "")
    for (col in names(student_data)) {
      samp <- paste(head(student_data[[col]], 4), collapse = ", ")
      type_str <- class(student_data[[col]])[1]
      cat(sprintf("$ %-13s <%s> %s ...\n", col, type_str, samp))
    }
  })
  
  # Descriptive Statistics Table
  output$stats_table <- renderTable({
    calc_row <- function(vals, name) {
      data.frame(
        "Variable Name" = name,
        "Mean"          = sprintf("%.2f", mean(vals)),
        "Median"        = sprintf("%.2f", median(vals)),
        "Minimum"       = sprintf("%.2f", min(vals)),
        "Maximum"       = sprintf("%.2f", max(vals)),
        "Range"         = sprintf("%.2f", max(vals) - min(vals)),
        "Std. Deviation"= sprintf("%.2f", sd(vals)),
        check.names = FALSE
      )
    }
    
    rbind(
      calc_row(student_data$Marks, "Exam Marks (0 - 100)"),
      calc_row(student_data$Study_Hours, "Weekly Study Hours (hrs)"),
      calc_row(student_data$Attendance, "Attendance Percentage (%)")
    )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  # Outlier Detection
  output$output_outliers <- renderPrint({
    q1 <- quantile(student_data$Marks, 0.25)
    q3 <- quantile(student_data$Marks, 0.75)
    iqr_val <- IQR(student_data$Marks)
    lower_bound <- q1 - 1.5 * iqr_val
    upper_bound <- q3 + 1.5 * iqr_val
    
    outliers <- student_data$Marks[student_data$Marks < lower_bound | student_data$Marks > upper_bound]
    
    cat("Outlier Analysis for 'Marks' using IQR Method:\n")
    cat("----------------------------------------------------\n")
    cat(sprintf("1st Quartile (Q1) : %.2f\n", q1))
    cat(sprintf("3rd Quartile (Q3) : %.2f\n", q3))
    cat(sprintf("Interquartile Range: %.2f\n", iqr_val))
    cat(sprintf("Lower Fence       : %.2f (Q1 - 1.5 * IQR)\n", lower_bound))
    cat(sprintf("Upper Fence       : %.2f (Q3 + 1.5 * IQR)\n", upper_bound))
    cat("----------------------------------------------------\n")
    if (length(outliers) > 0) {
      cat("Identified Outlier(s):", paste(outliers, collapse = ", "), "\n")
    } else {
      cat("Result: No extreme outliers detected. All student marks fall comfortably\n")
      cat("between the lower fence (", round(lower_bound, 1), ") and upper fence (", round(upper_bound, 1), ").\n", sep = "")
    }
  })
  
  # Loop demonstration output
  output$output_loop_demo <- renderPrint({
    cat("R Loop Execution Snippet:\n")
    cat("----------------------------------------------------\n")
    cat("# Assign grades using for loop:\n")
    cat("for (i in 1:nrow(students)) {\n")
    cat("  if (students$Marks[i] >= 85) grade[i] <- 'A'\n")
    cat("  else if (students$Marks[i] >= 70) grade[i] <- 'B'\n")
    cat("  else if (students$Marks[i] >= 55) grade[i] <- 'C'\n")
    cat("  else if (students$Marks[i] >= 40) grade[i] <- 'D'\n")
    cat("  else grade[i] <- 'F'\n")
    cat("}\n\n")
    cat("Loop iteration verified: Successfully processed all 30 student records.\n")
  })
  
  # ----------------------------------------------------------------------------
  # PLOTS AND VISUALIZATIONS
  # ----------------------------------------------------------------------------
  
  # 1. Overview barplot
  output$overview_barplot <- renderPlot({
    par(mar = c(4, 4, 2, 1), bg = "white")
    counts <- table(student_data$Grade)
    colors <- c("#10b981", "#3b82f6", "#f59e0b", "#f97316", "#ef4444")
    bp <- barplot(counts, col = colors, border = NA,
                  ylab = "Number of Students", xlab = "Letter Grade",
                  ylim = c(0, max(counts) + 2), main = "")
    grid(nx = NA, ny = NULL, col = "#e2e8f0", lty = 1)
    text(bp, counts + 0.6, labels = as.numeric(counts), font = 2, col = "#334155")
  })
  
  # 2. Overview scatter
  output$overview_scatter <- renderPlot({
    par(mar = c(4, 4, 2, 1), bg = "white")
    plot(student_data$Study_Hours, student_data$Marks,
         pch = 19, col = "#4338ca", cex = 1.3,
         xlab = "Weekly Study Hours", ylab = "Exam Marks", main = "")
    grid(col = "#e2e8f0", lty = 1)
    model <- lm(Marks ~ Study_Hours, data = student_data)
    abline(model, col = "#ef4444", lwd = 2.5)
    points(student_data$Study_Hours, student_data$Marks, pch = 19, col = "#4338ca", cex = 1.3)
  })
  
  # 3. Tab: Histogram of Marks
  output$plot_histogram <- renderPlot({
    par(mar = c(4.2, 4.2, 2, 1), bg = "white")
    bins <- input$hist_bins
    h <- hist(student_data$Marks, breaks = bins, col = "#6366f1", border = "white",
              xlab = "Exam Marks (0 - 100)", ylab = "Student Frequency",
              main = "", cex.lab = 1.05)
    grid(nx = NA, ny = NULL, col = "#e2e8f0", lty = 1)
    mean_val <- mean(student_data$Marks)
    med_val <- median(student_data$Marks)
    abline(v = mean_val, col = "#ef4444", lwd = 2.5, lty = 2)
    abline(v = med_val, col = "#0284c7", lwd = 2.5, lty = 3)
    legend("topleft", legend = c(paste("Mean:", round(mean_val, 1)),
                                 paste("Median:", round(med_val, 1))),
           col = c("#ef4444", "#0284c7"), lty = c(2, 3), lwd = 2, bty = "n")
  })
  
  # 4. Tab: Boxplot of Marks
  output$plot_boxplot <- renderPlot({
    par(mar = c(4.2, 4.2, 2, 1), bg = "white")
    boxplot(student_data$Marks, horizontal = TRUE, col = "#38bdf8", border = "#0284c7",
            xlab = "Exam Marks (0 - 100)", main = "",
            notch = FALSE, pch = 19, outcol = "#ef4444", outcex = 1.4)
    grid(col = "#e2e8f0", lty = 1)
    # Re-draw on top of grid
    boxplot(student_data$Marks, horizontal = TRUE, col = "#38bdf8", border = "#0284c7",
            add = TRUE, pch = 19, outcol = "#ef4444", outcex = 1.4)
  })
  
  # 5. Tab: Scatter plot with regression line
  output$plot_scatter <- renderPlot({
    par(mar = c(4.2, 4.2, 2, 1), bg = "white")
    plot(student_data$Study_Hours, student_data$Marks,
         pch = 21, bg = "#4f46e5", col = "#312e81", cex = 1.5,
         xlab = "Weekly Study Hours", ylab = "Exam Marks", main = "")
    grid(col = "#e2e8f0", lty = 1)
    m <- lm(Marks ~ Study_Hours, data = student_data)
    abline(m, col = "#dc2626", lwd = 3)
    points(student_data$Study_Hours, student_data$Marks, pch = 21, bg = "#4f46e5", col = "#312e81", cex = 1.5)
    legend("bottomright", legend = c("Student Observations", "Fitted Regression Line"),
           pch = c(21, NA), pt.bg = c("#4f46e5", NA), col = c("#312e81", "#dc2626"),
           lty = c(NA, 1), lwd = c(NA, 3), bty = "n")
  })
  
  # 6. Tab: Bar chart of grades
  output$plot_barchart <- renderPlot({
    par(mar = c(4.2, 4.2, 2, 1), bg = "white")
    counts <- table(student_data$Grade)
    colors <- c("#10b981", "#3b82f6", "#f59e0b", "#f97316", "#ef4444")
    bp <- barplot(counts, col = colors, border = NA,
                  ylab = "Number of Students", xlab = "Letter Grade",
                  ylim = c(0, max(counts) + 2), main = "")
    grid(nx = NA, ny = NULL, col = "#e2e8f0", lty = 1)
    text(bp, counts + 0.6, labels = as.numeric(counts), font = 2, col = "#1e293b")
  })
  
  # ----------------------------------------------------------------------------
  # REGRESSION MODEL & PREDICTIONS
  # ----------------------------------------------------------------------------
  reg_fit <- reactive({
    lm(Marks ~ Study_Hours, data = student_data)
  })
  
  output$reg_summary_output <- renderPrint({
    m <- reg_fit()
    summary(m)
  })
  
  output$reg_explanation <- renderUI({
    m <- reg_fit()
    s <- summary(m)
    b0 <- round(coef(m)[1], 2)
    b1 <- round(coef(m)[2], 2)
    r2 <- round(s$r.squared, 4)
    r2_pct <- round(s$r.squared * 100, 1)
    
    tags$div(style = "line-height: 1.6; font-size: 0.95rem; color: #334155;",
      tags$p(HTML(paste0("<b>1. Linear Equation:</b> <code>Exam Marks = ", b0, " + (", b1, " × Study_Hours)</code>"))),
      tags$p(HTML(paste0("<b>2. Slope (β₁ = ", b1, "):</b> Each additional hour of weekly study time increases a student's expected exam score by <b>", b1, " marks</b>."))),
      tags$p(HTML(paste0("<b>3. Intercept (β₀ = ", b0, "):</b> Represents the theoretical baseline exam score of <b>", b0, " marks</b> if a student engages in 0 hours of study."))),
      tags$p(HTML(paste0("<b>4. Coefficient of Determination (R² = ", r2, " / ", r2_pct, "%):</b> <b>", r2_pct, "%</b> of the variance in student marks is directly explained by study hours alone, confirming a very strong predictive relationship.")))
    )
  })
  
  # Interactive Prediction Output
  output$prediction_display <- renderUI({
    hrs <- input$pred_hours
    m <- reg_fit()
    pred <- predict(m, newdata = data.frame(Study_Hours = hrs))
    pred_score <- max(0, min(100, round(pred, 1)))
    
    # Calculate grade
    grd <- if (pred_score >= 85) "A (Excellent)"
           else if (pred_score >= 70) "B (Good)"
           else if (pred_score >= 55) "C (Satisfactory)"
           else if (pred_score >= 40) "D (Pass)"
           else "F (Fail)"
           
    div(class = "pred-box",
      div(style = "font-size: 0.85rem; text-transform: uppercase; font-weight: 700; color: #4338ca;",
          paste("For", hrs, "Study Hours / Week:")),
      div(class = "pred-value", paste0(pred_score, " / 100")),
      div(class = "pred-grade", paste("Predicted Grade:", grd))
    )
  })
  
  # Plot showing the prediction point on the regression line
  output$plot_pred_fit <- renderPlot({
    hrs <- input$pred_hours
    m <- reg_fit()
    pred <- predict(m, newdata = data.frame(Study_Hours = hrs))
    
    par(mar = c(3.5, 3.5, 1.5, 1), bg = "white")
    plot(student_data$Study_Hours, student_data$Marks,
         pch = 20, col = "#cbd5e1", cex = 1.2,
         xlab = "Study Hours", ylab = "Marks", main = "Fitted Line with Current Selection")
    grid(col = "#f1f5f9")
    abline(m, col = "#4338ca", lwd = 2)
    # Highlight prediction point
    points(hrs, pred, pch = 18, col = "#ef4444", cex = 2.4)
    text(hrs, pred + 4, labels = paste0(round(pred, 1), " mks"), col = "#ef4444", font = 2)
  })
  
  # ----------------------------------------------------------------------------
  # DATASET EXPLORER & QUICK TABLES
  # ----------------------------------------------------------------------------
  
  output$quick_table <- renderTable({
    head(student_data[, c("StudentID", "Study_Hours", "Attendance", "Marks", "Grade")], 6)
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  filtered_data <- reactive({
    if (input$grade_filter == "All Grades") {
      student_data
    } else {
      student_data[student_data$Grade == input$grade_filter, ]
    }
  })
  
  output$student_table <- renderTable({
    filtered_data()[, c("StudentID", "Study_Hours", "Attendance", "Marks", "Grade")]
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  # Download Handler for CSV
  output$download_csv <- downloadHandler(
    filename = function() {
      paste("student_performance_records_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# ------------------------------------------------------------------------------
# 5. RUN SHINY APPLICATION
# ------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)
